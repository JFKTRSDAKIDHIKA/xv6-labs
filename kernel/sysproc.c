#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;

  argint(n, &fd);
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}



uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_mmap(void)
{
  uint64 addr; // the mapped virtual address, always zero.
  int  length; // the number of bytes to map in the file.
  /*
   * severe error occured here. If length is declared as uint, may be overflow, or may be dangerous type cast, or other reasons. Anyway, it's tricky.
   * */
  int prot, flags, fd;  
  int offset; // always 0;
  struct file *f; // the ptr to the mapped file.
  f = 0;
  
  // 从用户空间获取参数
  argaddr(0, &addr);         // 获取第一个参数：地址
  argint(1, &length);  // 获取第二个参数：长度
  argint(2, &prot);           // 获取第三个参数：保护标志
  argint(3, &flags);          // 获取第四个参数：映射标志
  argfd(4, &fd, &f);             // 获取第五个参数：文件描述符
  argint(5, &offset);  // 获取第六个参数：文件偏移
 
  // addr will always be zero, meaning that the kernel should decide the virtual address at which to map the file. 
  if(addr != 0) 
    return 0xffffffffffffffff;
  // You can assume offset is zero (it's the starting point in the file at which to map).
  if(offset != 0)
    return 0xffffffffffffffff;
  if(length == 0)                                                                     
    return 0xffffffffffffffff;
  // file not writebale but mapped writeable, return -1.
  if (!f->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED)) 
    return 0xffffffffffffffff;

  // Fill in the page table lazily, in response to page faults. 
  int i;
  struct proc *p = myproc();
  for(i = 0; i< 16; i++){
    if(!p->VMAs[i].valid){
      p->VMAs[i].valid = 1;	    
      break;
    }
    if(i == 15)
      panic("no free VMA");
  }

  p->VMAs[i].start = p->msz - PGROUNDUP(length); // grow down form TRAPFRAME, PG aligned.
  p->msz = p->msz - PGROUNDUP(length);
  p->VMAs[i].length =length; // not page aligned.
  p->VMAs[i].prot = prot;
  p->VMAs[i].flags = flags;
  p->VMAs[i].offset = offset; // alwsys zero. 
  p->VMAs[i].file = filedup(f); 
  return (uint64)p->VMAs[i].start; 

}

uint64
sys_munmap(void)
{
  uint64 addr; // unmap区域的头部地址
  int length;  // unmap区域的长度（bytes）
  argaddr(0, &addr);  
  argint(1, &length);

  struct proc *p = myproc();

  int i;
  for(i = 0 ;i < 16 ;i++){
    struct VMA *vma = &p->VMAs[i];
    if(vma->valid && addr >= vma->start && addr < vma->start + PGROUNDUP(vma->length)){
      // Find the VMA for this address range.
      if(vma->flags == MAP_SHARED) // writeback the mapped memory to the file.
        filewrite(vma->file, vma->start, vma->length);    

      if(PGROUNDUP(vma->length) == PGROUNDUP(length)){// unmap的length==vma的length
	vma->valid = 0;
        fileclose(vma->file);
      }else{
        if(addr == vma->start){
          // unmap at the start.
          vma->start = addr + PGROUNDUP(length);
	  vma->length = vma->length - PGROUNDUP(length);
	}else if(addr + length >= vma->start + PGROUNDUP(vma->length)){
          // unmap at the end.
	  vma->length = vma->length - PGROUNDUP(length);
	}else{
	  panic("punch a hole in the middle of a region");
	}
      }
      uvmunmap(p->pagetable, PGROUNDDOWN(addr), (int)PGROUNDUP(length) / PGSIZE, 1);
    }
  }  
  return 0;
}
