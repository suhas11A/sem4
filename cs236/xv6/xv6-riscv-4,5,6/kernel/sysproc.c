#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "vm.h"

static char *states[] = {
  [UNUSED]   "unused",
  [USED]     "used  ",
  [SLEEPING] "sleep ",
  [RUNNABLE] "runble",
  [RUNNING]  "run   ",
  [ZOMBIE]   "zombie"
};

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
  int f= kfork();
  // printf("fork: created child with pid: %d\n", f);
  return f;
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
sys_knockknock(void)
{
  printf("[pid %d] Who's there?\n", myproc()->pid);
  return 0;
}

uint64
sys_getProcessStates(void)
{
  struct proc *p;
  extern struct proc proc[NPROC];
  for(p = proc; p < &proc[NPROC]; p++){
    acquire(&p->lock);
    if(p->state != UNUSED){
      printf("Process %d was found in %s state\n", p->pid, states[p->state]);
    }
    release(&p->lock);
  }
  return 0;
}

uint64
sys_areYouThere(void)
{ 
  int pidd;
  argint(0, &pidd);
  struct proc *p;
  extern struct proc proc[NPROC];
  for(p = proc; p < &proc[NPROC]; p++){
    acquire(&p->lock);
    if(p->pid == pidd){
      printf("Process %d is found in %s state\n", pidd, states[p->state]);
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }
  printf("Process %d has gone missing\n", pidd);
  return 0;
}

uint64
sys_getChildCount(void) {
  return myproc()->child_count;
}

uint64
sys_strace_start(void)
{
  struct proc *p=myproc();
  acquire(&p->lock);
  p->tracing_on=1;
  p->syscalls_made = 0;
  if(p->syscall_number){
    kfree((void*)p->syscall_number);
    p->syscall_number = 0;
  }
  if(p->syscall_return){
    kfree((void*)p->syscall_return);
    p->syscall_return = 0;
  }
  p->syscall_number = (int*)kalloc();
  p->syscall_return = (int*)kalloc();
  if(p->syscall_number == 0 || p->syscall_return == 0){
    if(p->syscall_number) { kfree((void*)p->syscall_number); p->syscall_number = 0; }
    if(p->syscall_return) { kfree((void*)p->syscall_return); p->syscall_return = 0; }
    p->tracing_on = 0;
    release(&p->lock);
    return -1;
  }

  for(int i = 0; i < 100; i++){
    p->syscall_number[i] = -1;
    p->syscall_return[i] = 0;
  }
  release(&p->lock);
  return 0;
}

uint64
sys_strace_end(void)
{
  struct proc *p=myproc();
  acquire(&p->lock);
  if (!p->tracing_on) return -1;
  p->tracing_on=0;
  printf("Syscall Trace for PID %d:\n", myproc()->pid);
  for (int i=0;i<p->syscalls_made;i++) {
    printf("  Syscall %d returned %d\n", p->syscall_number[i], p->syscall_return[i]);
  }
  if(p->syscall_number){
    kfree((void*)p->syscall_number);
    p->syscall_number = 0;
  }
  if(p->syscall_return){
    kfree((void*)p->syscall_return);
    p->syscall_return = 0;
  }
  p->syscalls_made = 0;
  release(&p->lock);
  return 0;
}

uint64
sys_pte_valid(void)
{
  uint64 memid;
  argaddr(0, &memid);
  return ismapped(myproc()->pagetable, memid);
}

uint64
sys_get_pteflags(void)
{
  uint64 memid;
  argaddr(0, &memid);
  pte_t* olaa = walk(myproc()->pagetable, memid, 0);
  if (olaa==0 || !((*olaa)&PTE_V)) {
    printf("%ld is not a valid address dumbo\n", memid);
    return 0;
  }
  printf("VA: %p -> R:%d W:%d X:%d U:%d\n", (void *)memid, ((*olaa)&PTE_R) != 0, ((*olaa)&PTE_W )!= 0, ((*olaa)&PTE_X) != 0, ((*olaa)&PTE_U) != 0);
  return 0;
}

uint64
sys_print_pgdirs(void)
{
  extern pagetable_t kernel_pagetable;
  printf("Physical Address of Kernel root pagetable : %p\n", (void *)kernel_pagetable);
  printf("Physical Address of User root pagetable   : %p\n", (void *)myproc()->pagetable);
  printf("Physical Address of Current satp register : %p\n", (void *)(r_satp()<<12));
  return 0;
}

uint64
sys_va_to_pa(void)
{
  uint64 memid;
  argaddr(0, &memid);
  pte_t* pte = walk(myproc()->pagetable, memid, 0);
  if (pte==0 || (*pte & PTE_V) == 0) return -1;
  return ((*pte>>10)<<12)+((memid<<52)>>52);
}

uint64
sys_va_to_pte(void)
{
  uint64 memid;
  argaddr(0, &memid);
  pte_t* pte = walk(myproc()->pagetable, memid, 0);
  if (pte==0 || (*pte & PTE_V) == 0) return -1;
  return ((*pte>>10)<<12);
}

uint64
sys_getvasize(void)
{
  return myproc()->sz;
}

uint64
numberofactivepages(pagetable_t pagetable, int level)
{
  if (level==0) {return 1;}
  uint64 total_pages=0;
  for (int i=0;i<512;i++) {
    pte_t *pte = &pagetable[i];
    if ((*pte)&PTE_V) {total_pages+=numberofactivepages((pagetable_t)PTE2PA(*pte),level-1);}
  }
  return total_pages;
}

uint64
sys_getpasize(void)
{
  pagetable_t pagetable = myproc()->pagetable;
  return (numberofactivepages(pagetable, 3)-2)*PGSIZE;
}

uint64
sys_getlazyfaults(void)
{
  return myproc()->num_pfs;
}

uint64
sys_kva_to_pa(void)
{
  uint64 memid;
  argaddr(0, &memid);
  extern pagetable_t kernel_pagetable;
  pte_t* pte = walk(kernel_pagetable, memid, 0);
  if (pte==0 || (*pte & PTE_V) == 0) return -1;
  return ((*pte>>10)<<12)+((memid<<52)>>52);
}

uint64
sys_tfork(void)
{
  int n; uint64 pids;
  argint(0, &n); argaddr(1, &pids);
  return ktfork(n, pids);
}

uint64
sys_getppid(void)
{
  return myproc()->parent->pid;
}

uint64
sys_pfork(void)
{
  int n; uint64 pids;
  argint(0, &n); argaddr(1, &pids);
  return kpfork(n, pids);
}

uint64
sys_kmap(void)
{
  void* olaa = kalloc();
  memset(olaa, 0, PGSIZE);
  mappages(myproc()->pagetable, myproc()->sz, PGSIZE, (uint64) olaa, PTE_U|PTE_R|PTE_W);
  myproc()->sz+=PGSIZE;
  myproc()->kmap_kernalva = (uint64) olaa;
  return myproc()->sz-PGSIZE;
}