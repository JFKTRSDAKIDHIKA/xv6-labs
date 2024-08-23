struct buf {
  int valid;   // has data been read from disk?
  int disk;    // does disk "own" buf?
  uint dev;
  uint blockno;
  struct sleeplock lock;
  uint refcnt;
  uint origin_bucket;
//  struct buf *prev; // LRU cache list
  struct buf *next;
  uchar data[BSIZE];
};


struct bucket{
  struct buf *first;
  struct spinlock lock;
};

