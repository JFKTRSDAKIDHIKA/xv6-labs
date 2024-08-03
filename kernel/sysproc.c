#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

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
	backtrace();
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
sys_sigalarm(void)
{
	int ticks;
	uint64 handler;
	argint(0, &ticks);
	argaddr(1, &handler);
	myproc()->alarm_ticks = ticks;
	myproc()->alarm_handler = handler;
	myproc()->remaining_ticks = ticks;
	myproc()->in_handler = 0;
	return 0;
}

uint64
sys_sigreturn(void)
{
	struct proc *p = myproc();
	p->trapframe->ra = p->intr_frame.ra;
	p->trapframe->sp = p->intr_frame.sp;
	p->trapframe->gp = p->intr_frame.gp;
	p->trapframe->tp = p->intr_frame.tp;
	p->trapframe->t0 = p->intr_frame.t0;
	p->trapframe->t1 = p->intr_frame.t1;
	p->trapframe->t2 = p->intr_frame.t2;
	p->trapframe->s0 = p->intr_frame.s0;
	p->trapframe->s1 = p->intr_frame.s1;
	p->trapframe->a0 = p->intr_frame.a0;
	p->trapframe->a1 = p->intr_frame.a1;
	p->trapframe->a2 = p->intr_frame.a2;
	p->trapframe->a3 = p->intr_frame.a3;
	p->trapframe->a4 = p->intr_frame.a4;
	p->trapframe->a5 = p->intr_frame.a5;
	p->trapframe->a6 = p->intr_frame.a6;
	p->trapframe->a7 = p->intr_frame.a7;
	p->trapframe->s2 = p->intr_frame.s2;
	p->trapframe->s3 = p->intr_frame.s3;
	p->trapframe->s4 = p->intr_frame.s4;
	p->trapframe->s5 = p->intr_frame.s5;
	p->trapframe->s6 = p->intr_frame.s6;
	p->trapframe->s7 = p->intr_frame.s7;
	p->trapframe->s8 = p->intr_frame.s8;
	p->trapframe->s9 = p->intr_frame.s9;
	p->trapframe->s10 = p->intr_frame.s10;
	p->trapframe->s11 = p->intr_frame.s11;
	p->trapframe->t3 = p->intr_frame.t3;
	p->trapframe->t4 = p->intr_frame.t4;
	p->trapframe->t5 = p->intr_frame.t5;
	p->trapframe->t6 = p->intr_frame.t6;

	p->trapframe->epc = p->intr_frame.epc;
	p->in_handler = 0;
	return p->intr_frame.a0;
}

