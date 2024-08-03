#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

struct spinlock tickslock;
uint ticks;

extern char trampoline[], uservec[], userret[];

// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void
trapinit(void)
{
  initlock(&tickslock, "time");
}

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
  w_stvec((uint64)kernelvec);
}

//
// handle an interrupt, exception, or system call from user space.
// called from trampoline.S
//
void
usertrap(void)
{ if(r_scause() ==12){
	     printf("fatal - scause : %d\n", r_scause());
	     printf("address: %p", r_sepc());
		     
		     }
  int which_dev = 0;

  if((r_sstatus() & SSTATUS_SPP) != 0)
    panic("usertrap: not from user mode");

  // send interrupts and exceptions to kerneltrap(),
  // since we're now in the kernel.
  w_stvec((uint64)kernelvec);

  struct proc *p = myproc();
  
  // save user program counter.
  p->trapframe->epc = r_sepc();
  if(r_scause() == 8){
    // system call
    if(killed(p))
      exit(-1);

    // sepc points to the ecall instruction,
    // but we want to return to the next instruction.
    p->trapframe->epc += 4;

    // an interrupt will change sepc, scause, and sstatus,
    // so enable only now that we're done with those registers.
    intr_on();

    syscall();
  } else if((which_dev = devintr()) != 0){
    // ok
  } else {
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    setkilled(p);
  }

  if(killed(p))
    exit(-1);

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2){
    if(p->alarm_ticks != 0 && !p->in_handler && p->remaining_ticks >0)// the proc is currently not in handler func and ticks remain.
      p->remaining_ticks = p->remaining_ticks - 1;	 
    if(p->alarm_ticks != 0 && !p->in_handler && p->remaining_ticks == 0 ){// ticks have expired
      p->remaining_ticks = p->alarm_ticks;
      p->in_handler = 1;
      p->intr_frame.ra = p->trapframe->ra;
      p->intr_frame.sp = p->trapframe->sp;
      p->intr_frame.gp = p->trapframe->gp;
      p->intr_frame.tp = p->trapframe->tp;
      p->intr_frame.t0 = p->trapframe->t0;
      p->intr_frame.t1 = p->trapframe->t1;
      p->intr_frame.t2 = p->trapframe->t2;
      p->intr_frame.s0 = p->trapframe->s0;
      p->intr_frame.s1 = p->trapframe->s1;
      p->intr_frame.a0 = p->trapframe->a0;
      p->intr_frame.a1 = p->trapframe->a1;
      p->intr_frame.a2 = p->trapframe->a2;
      p->intr_frame.a3 = p->trapframe->a3;
      p->intr_frame.a4 = p->trapframe->a4;
      p->intr_frame.a5 = p->trapframe->a5;
      p->intr_frame.a6 = p->trapframe->a6;
      p->intr_frame.a7 = p->trapframe->a7;
      p->intr_frame.s2 = p->trapframe->s2;
      p->intr_frame.s3 = p->trapframe->s3;
      p->intr_frame.s4 = p->trapframe->s4;
      p->intr_frame.s5 = p->trapframe->s5;
      p->intr_frame.s6 = p->trapframe->s6;
      p->intr_frame.s7 = p->trapframe->s7;
      p->intr_frame.s8 = p->trapframe->s8;
      p->intr_frame.s9 = p->trapframe->s9;
      p->intr_frame.s10 = p->trapframe->s10;
      p->intr_frame.s11 = p->trapframe->s11;
      p->intr_frame.t3 = p->trapframe->t3;
      p->intr_frame.t4 = p->trapframe->t4;
      p->intr_frame.t5 = p->trapframe->t5;
      p->intr_frame.t6 = p->trapframe->t6; 
      p->intr_frame.epc = p->trapframe->epc;// trapframe->epc stores the user address i want to jump back soon, but now i want to jump to handler.
      p->trapframe->epc = p->alarm_handler;
    }
      yield();
  }
  usertrapret();
}

//
// return to user space
//
void
usertrapret(void)
{
  struct proc *p = myproc();

  // we're about to switch the destination of traps from
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
  p->trapframe->kernel_trap = (uint64)usertrap;
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
//  p->trapframe->a0 = p->intr_frame.a0;
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
  x |= SSTATUS_SPIE; // enable interrupts in user mode
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
  ((void (*)(uint64))trampoline_userret)(satp);
}

// interrupts and exceptions from kernel code go here via kernelvec,
// on whatever the current kernel stack is.
void 
kerneltrap()
{
  int which_dev = 0;
  uint64 sepc = r_sepc();
  uint64 sstatus = r_sstatus();
  uint64 scause = r_scause();
  
  if((sstatus & SSTATUS_SPP) == 0)
    panic("kerneltrap: not from supervisor mode");
  if(intr_get() != 0)
    panic("kerneltrap: interrupts enabled");

  if((which_dev = devintr()) == 0){
    printf("scause %p\n", scause);
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    panic("kerneltrap");
  }

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    yield();

  // the yield() may have caused some traps to occur,
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void
clockintr()
{
  acquire(&tickslock);
  ticks++;
  wakeup(&ticks);
  release(&tickslock);
}

// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
     (scause & 0xff) == 9){
    // this is a supervisor external interrupt, via PLIC.

    // irq indicates which device interrupted.
    int irq = plic_claim();

    if(irq == UART0_IRQ){
      uartintr();
    } else if(irq == VIRTIO0_IRQ){
      virtio_disk_intr();
    } else if(irq){
      printf("unexpected interrupt irq=%d\n", irq);
    }

    // the PLIC allows each device to raise at most one
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    // software interrupt from a machine-mode timer interrupt,
    // forwarded by timervec in kernelvec.S.

    if(cpuid() == 0){
      clockintr();
    }
    
    // acknowledge the software interrupt by clearing
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
  }
}

