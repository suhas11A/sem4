#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  kexit(n);
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
  return kfork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return kwait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
  argint(1, &t);
  addr = myproc()->sz;

  if(t == SBRK_EAGER || n < 0) {
    if(growproc(n) < 0) {
      return -1;
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
      return -1;
    if(addr + n > TRAPFRAME)
      return -1;
    myproc()->sz += n;
  }
  return addr;
}

uint64
sys_pause(void)
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
  return kkill(pid);
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
sys_getswitchstats(void)
{
  uint64 u_switch_ins;   // user pointer
  uint64 u_switch_outs;  // user pointer

  // fetch syscall arguments
  argaddr(0, &u_switch_ins);
  argaddr(1, &u_switch_outs);

  struct proc *p = myproc();

  // Copy switch_ins array to user space
  acquire(&p->lock);
  if (copyout(p->pagetable, u_switch_ins, (char *)p->switch_ins, sizeof(p->switch_ins)) < 0) {
    release(&p->lock);
    return -1;
  }

  // Copy switch_outs array to user space
  if (copyout(p->pagetable, u_switch_outs, (char *)p->switch_outs, sizeof(p->switch_outs)) < 0) {
    release(&p->lock);
    return -1;
  }

  release(&p->lock);
  return 0;
}

uint64 sys_setpriority(void) {
  int priority;
  argint(0, &priority);

  if (priority < 0 || priority > 10) {
    return -1;
  }

  struct proc *p = myproc();
  acquire(&p->lock);
  p->priority = priority;
  release(&p->lock);

  return 0;
}

uint64 sys_setprioritysched(void) {
  int enable;
  argint(0, &enable);

  if (enable != 0 && enable != 1) {
    return -1;
  }
  ksetprioritysched(enable);

  return 0;
}

uint64 sys_setcpuaffinity(void) {
  int cpu_mask;
  argint(0, &cpu_mask);

  if (cpu_mask <= 0 || cpu_mask >= (1 << NCPU)) {
    return -1;
  }

  struct proc *p = myproc();
  acquire(&p->lock);
  p->prefferred_cpu = cpu_mask;
  release(&p->lock);

  return 0;
}
