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
  uint64 addr;
  uint64 length;
  int prot, flags, fd;
  int offset;
  struct file *f;
  f = 0;
  // 从用户空间获取参数
  argaddr(0, &addr);         // 获取第一个参数：地址
  argint(1, (int *)&length);  // 获取第二个参数：长度
  argint(2, &prot);           // 获取第三个参数：保护标志
  argint(3, &flags);          // 获取第四个参数：映射标志
  argfd(4, &fd, &f);             // 获取第五个参数：文件描述符
  argint(5, &offset);  // 获取第六个参数：文件偏移
  
  if (!f->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED)) return -1;

  int i;
  for(i = 0; i< 16; i++){
    printf("myproc()->VMAs[i].valid: %d\n", myproc()->VMAs[i].valid);
    if(!myproc()->VMAs[i].valid){
      myproc()->VMAs[i].valid = 1;	    
      break;
    }
    if(i == 15)
      panic("no free VMA");
  }
  printf("PID:%d\n",myproc()->pid);
  myproc()->VMAs[i].start = myproc()->sz;
  printf("myproc()->sz: %p\n",myproc()->sz);
  myproc()->sz = myproc()->sz + PGROUNDUP(length);
  myproc()->VMAs[i].length =PGROUNDUP(length);
  myproc()->VMAs[i].prot = prot;
  myproc()->VMAs[i].flags = flags;
  myproc()->VMAs[i].offset = 0; 
  myproc()->VMAs[i].file = filedup(f);
  myproc()->VMAs[i].pagetable = myproc()->pagetable;
  return (uint64)myproc()->VMAs[i].start; 

}

uint64
sys_munmap(void)
{
  uint64 addr;
  argaddr(0, &addr);  
  int length; 
  argint(1, &length);

  struct proc *p = myproc();
  int i;
  for(i = 0;i < 16;i++){
    struct VMA *vma = &p->VMAs[i];
    if(vma->valid && addr >= vma->start && addr < vma->start + vma->length){
      // Find the VMA for this address range.
      printf("Find the VMA for this address range.\n");
 
      if(vma->flags == MAP_SHARED)                                                               filewrite(vma->file, vma->start, vma->length);    

      if(PGROUNDUP(vma->length) == PGROUNDUP(length)){
	vma->valid = 0;
        fileclose(vma->file);
      }else{
        vma->start = addr + PGROUNDUP(length);
	vma->length = vma->length - PGROUNDUP(length);
      }
      uvmunmap(p->pagetable, PGROUNDDOWN(addr), PGROUNDUP(length) % PGSIZE, 1);
    }
  }  
  return 0;
}
