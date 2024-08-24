// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"
#define BLOCKNO2INDEX(blockno) blockno % NBUCKET
#define NBUCKET 13


struct {
  struct spinlock lock;
  struct buf buf[NBUF];
  struct bucket bucket[NBUCKET]; // 13 buckets and 3 bufs per bucket and the bucket itself does not store the block data.
} bcache;

void insert_buf_to_bucket(struct bucket *, struct buf *);
void remove_buf_from_bucket(struct bucket *, struct buf *);
int can_lock(int , int );

void
binit(void)
{
/*
  initlock(&bcache.lock, "global.lock");
  for (int i = 0; i < NBUCKET; i++) { // Initialize each bucket's spinlock.
    initlock(&bcache.bucket[i].lock, "bcache.bucket"); // Initialize the spinlock of each bucket.
    bcache.bucket[i].first = 0; // Initialize the first pointer of each bucket to NULL.
  }

  int bufs_per_bucket = NBUF / NBUCKET; // Calculate number of buffers per bucket.
  int remaining_bufs = NBUF % NBUCKET; // In case NBUF is not perfectly divisible by NBUCKET.

  int buf_index = 0; // Index for the current buffer.
  for (int i = 0; i < NBUCKET; i++) {
    int num_bufs_to_assign = bufs_per_bucket + (remaining_bufs > 0 ? 1 : 0); // If there are remaining buffers, distribute them one per bucket.

    for (int j = 0; j < num_bufs_to_assign; j++) {
      initsleeplock(&bcache.buf[buf_index].lock, "buffer"); // Initialize the sleeplock of each buffer.
      bcache.buf[buf_index].origin_bucket = i; // Set the original bucket index for this buffer.

      // Insert the buffer into the current bucket's linked list.
      bcache.buf[buf_index].next = bcache.bucket[i].first;
      bcache.bucket[i].first = &bcache.buf[buf_index];

      buf_index++; // Move to the next buffer.
    }

    if (remaining_bufs > 0) {
      remaining_bufs--; // Distribute one extra buffer to each bucket until the remainder is zero.
    }
  }
*/

  initlock(&bcache.lock,"global.lock");
  for(int i = 0; i < NBUCKET; i++){ // tranverse through first 9 buckets.
    initlock(&bcache.bucket[i].lock, "bcache.bucket"); // Initilize the spinlock of each bucket.
    bcache.bucket[i].first = 0; // Initilize the ith bucket 's next to NULL.
  }

  for(int j = 0; j < NBUF;j++){ // tranverse through all the bufs and assign all of them to the first bucket.
    initsleeplock(&bcache.buf[j].lock, "buffer"); // Initilize the sleeplock of each buffer.
    bcache.buf[j].origin_bucket = 0; 
    
    bcache.buf[j].next = bcache.bucket[0].first;
    bcache.bucket[0].first = &bcache.buf[j];
  }

}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.bucket[BLOCKNO2INDEX(blockno)].lock); // acquire the spinlock corresponding to the bucket

  // Is the block already cached?
  for(b = bcache.bucket[BLOCKNO2INDEX(blockno)].first; b != 0; b = b->next){ // 遍历bucket的linkedlist
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;

      release(&bcache.bucket[BLOCKNO2INDEX(blockno)].lock); // once the block has been gotten from the cache, release the spinlock corresponding to the bucket.

      acquiresleep(&b->lock);
      return b;
    }
  }
//  release(&bcache.bucket[BLOCKNO2INDEX(blockno)].lock);

  acquire(&bcache.lock);
  // Not cached.
  // Recycle the least recently sed (LRU) unused buffer.
  for(int i =0 ;i < NBUF; i++){
//    if(can_lock(BLOCKNO2INDEX(blockno),i))
//      continue;
    if(bcache.buf[i].refcnt == 0) {
      if(bcache.buf[i].origin_bucket != BLOCKNO2INDEX(blockno)){
        acquire(&bcache.bucket[bcache.buf[i].origin_bucket].lock);
//	printf("STUCKED HERE\n");
        if(bcache.buf[i].refcnt != 0){
          release(&bcache.bucket[bcache.buf[i].origin_bucket].lock);
	  i--;
	  continue;
	}
      }
      // Find a free buffer from other buckets.
      bcache.buf[i].dev = dev;
      bcache.buf[i].blockno = blockno;
      bcache.buf[i].valid = 0;
      bcache.buf[i].refcnt = 1;

     
      if(bcache.buf[i].origin_bucket != BLOCKNO2INDEX(blockno)){ // 如果空闲的buffer不在当前的bucket中
	// Delete the buf from the old bucket.
	remove_buf_from_bucket(&bcache.bucket[bcache.buf[i].origin_bucket], &bcache.buf[i]);
	uint temp = bcache.buf[i].origin_bucket;
	bcache.buf[i].origin_bucket = BLOCKNO2INDEX(blockno);
        release(&bcache.bucket[temp].lock);
	
        insert_buf_to_bucket(&bcache.bucket[BLOCKNO2INDEX(blockno)], &bcache.buf[i]);      
      }
      release(&bcache.bucket[BLOCKNO2INDEX(blockno)].lock);
      release(&bcache.lock);
      acquiresleep(&bcache.buf[i].lock);
      return &bcache.buf[i];
    }
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.bucket[b->origin_bucket].lock);
  b->refcnt--;
  release(&bcache.bucket[b->origin_bucket].lock);
}

void
bpin(struct buf *b) {
  acquire(&bcache.bucket[b->origin_bucket].lock);
  b->refcnt++;
  release(&bcache.bucket[b->origin_bucket].lock);
}

void
bunpin(struct buf *b) {
  acquire(&bcache.bucket[b->origin_bucket].lock);
  b->refcnt--;
  release(&bcache.bucket[b->origin_bucket].lock);
}

void remove_buf_from_bucket(struct bucket *bucket, struct buf *b) {
  struct buf * b_ptr  = bucket->first;
  struct buf * pre_ptr = 0;
  while(b_ptr != b && b_ptr != 0){
    pre_ptr = b_ptr;
    b_ptr = b_ptr->next;
  }
  
  if(pre_ptr == 0){ // if i want to delete the first element.
    bucket->first = b->next;
  }else{
  pre_ptr->next = b->next;
  }
}

void insert_buf_to_bucket(struct bucket *bucket, struct buf *b) {
  b->next = bucket->first;
  bucket->first = b;
}

// From https://fanxiao.tech/posts/2021-03-02-mit-6s081-notes/#106-lab-8-locks
int can_lock(int id, int j) {
  int num = NBUCKET / 2; // 哈希桶总数的一半

  if (id <= num) { // 当前持有锁的哈希桶在前半部分
    if (j > id && j <= (id + num))
      return 0; // 不允许获取id之后直到前半部分结束范围内的锁
  } else { // 当前持有锁的哈希桶在后半部分
    if ((id < j && j < NBUCKET) || (j <= (id + num) % NBUCKET)) {
      return 0; // 不允许获取后半部分的锁，除非在自己的后半部分之前
    }
  }
  return 1; // 可以获取锁
}
