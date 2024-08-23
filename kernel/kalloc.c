// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.		
extern int cpuid(void);

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem[NCPU]; // one freelist for one CPU.

void
kinit()
{
  push_off();
  int cid = cpuid();
  pop_off();
  initlock(&kmem[cid].lock, "kmem");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;
  push_off();
  int cid = cpuid();
  pop_off();

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem[cid].lock);
  r->next = kmem[cid].freelist;
  kmem[cid].freelist = r;
  release(&kmem[cid].lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;
  push_off();
  int cid = cpuid();
  pop_off();

  acquire(&kmem[cid].lock);
  r = kmem[cid].freelist;
//  release(&kmem[cid].lock);
  if(!r){
   // what is the free list is empty ? stealing mechanism
    for(int i = 0 ;i < NCPU;i++){
      if(i == cid)
        continue;
      acquire(&kmem[i].lock);
      struct run *r = kmem[i].freelist;
      int count = 0;
      while(r){
        count++;
	r = r->next;
      }
      if(count > 1){
        struct run *steal_head = kmem[i].freelist;
	struct run *steal_tail = steal_head;
	for(int i = 0;i < count/2 - 1;i++ ){
	  steal_tail = steal_tail->next;
	}
       
       kmem[i].freelist = steal_tail->next;
       steal_tail->next = 0;
       
       steal_tail->next = kmem[cid].freelist;
       kmem[cid].freelist = steal_head;
       release(&kmem[i].lock);
       break;
      }
      release(&kmem[i].lock);
    }   
  }
//  acquire(&kmem[cid].lock);
  r = kmem[cid].freelist;
  if(r)
    kmem[cid].freelist = r->next;
  release(&kmem[cid].lock);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
