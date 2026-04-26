#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "syscall.h"
#include "defs.h"

// Fetch the uint64 at addr from the current process.
int
fetchaddr(uint64 addr, uint64 *ip)
{
  struct proc *p = myproc();
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    return -1;
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    return -1;
  return 0;
}

// Fetch the nul-terminated string at addr from the current process.
// Returns length of string, not including nul, or -1 for error.
int
fetchstr(uint64 addr, char *buf, int max)
{
  struct proc *p = myproc();
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    return -1;
  return strlen(buf);
}

static uint64
argraw(int n)
{
  struct proc *p = myproc();
  switch (n) {
  case 0:
    return p->trapframe->a0;
  case 1:
    return p->trapframe->a1;
  case 2:
    return p->trapframe->a2;
  case 3:
    return p->trapframe->a3;
  case 4:
    return p->trapframe->a4;
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
  *ip = argraw(n);
}

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
  *ip = argraw(n);
}

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
}

// Prototypes for the functions that handle system calls.
extern uint64 sys_fork(void);
extern uint64 sys_exit(void);
extern uint64 sys_wait(void);
extern uint64 sys_pipe(void);
extern uint64 sys_read(void);
extern uint64 sys_kill(void);
extern uint64 sys_exec(void);
extern uint64 sys_fstat(void);
extern uint64 sys_chdir(void);
extern uint64 sys_dup(void);
extern uint64 sys_getpid(void);
extern uint64 sys_sbrk(void);
extern uint64 sys_pause(void);
extern uint64 sys_uptime(void);
extern uint64 sys_open(void);
extern uint64 sys_write(void);
extern uint64 sys_mknod(void);
extern uint64 sys_unlink(void);
extern uint64 sys_link(void);
extern uint64 sys_mkdir(void);
extern uint64 sys_close(void);
extern uint64 sys_knockknock(void);
extern uint64 sys_getProcessStates(void);
extern uint64 sys_areYouThere(void);
extern uint64 sys_getChildCount(void);
extern uint64 sys_strace_start(void);
extern uint64 sys_strace_end(void);
extern uint64 sys_pte_valid(void);
extern uint64 sys_get_pteflags(void);
extern uint64 sys_print_pgdirs(void);
extern uint64 sys_va_to_pa(void);
extern uint64 sys_va_to_pte(void);
extern uint64 sys_getvasize(void);
extern uint64 sys_getpasize(void);
extern uint64 sys_getlazyfaults(void);
extern uint64 sys_kva_to_pa(void);
extern uint64 sys_tfork(void);
extern uint64 sys_getppid(void);
extern uint64 sys_pfork(void);
extern uint64 sys_shm_init(void);
extern uint64 sys_shm_attach(void);
extern uint64 sys_shm_detach(void);
extern uint64 sys_shm_destroy(void);
extern uint64 sys_shm_refcnt(void);
extern uint64 sys_kmap(void);

// An array mapping syscall numbers from syscall.h
// to the function that handles the system call.
static uint64 (*syscalls[])(void) = {
[SYS_fork]    sys_fork,
[SYS_exit]    sys_exit,
[SYS_wait]    sys_wait,
[SYS_pipe]    sys_pipe,
[SYS_read]    sys_read,
[SYS_kill]    sys_kill,
[SYS_exec]    sys_exec,
[SYS_fstat]   sys_fstat,
[SYS_chdir]   sys_chdir,
[SYS_dup]     sys_dup,
[SYS_getpid]  sys_getpid,
[SYS_sbrk]    sys_sbrk,
[SYS_pause]   sys_pause,
[SYS_uptime]  sys_uptime,
[SYS_open]    sys_open,
[SYS_write]   sys_write,
[SYS_mknod]   sys_mknod,
[SYS_unlink]  sys_unlink,
[SYS_link]    sys_link,
[SYS_mkdir]   sys_mkdir,
[SYS_close]   sys_close,
[SYS_knockknock]   sys_knockknock,
[SYS_getProcessStates]   sys_getProcessStates,
[SYS_areYouThere]   sys_areYouThere,
[SYS_getChildCount]   sys_getChildCount,
[SYS_strace_start]   sys_strace_start,
[SYS_strace_end]   sys_strace_end,
[SYS_pte_valid]   sys_pte_valid,
[SYS_get_pteflags]   sys_get_pteflags,
[SYS_print_pgdirs]   sys_print_pgdirs,
[SYS_va_to_pa]   sys_va_to_pa,
[SYS_va_to_pte]   sys_va_to_pte,
[SYS_getvasize]   sys_getvasize,
[SYS_getpasize]   sys_getpasize,
[SYS_getlazyfaults]   sys_getlazyfaults,
[SYS_kva_to_pa]   sys_kva_to_pa,
[SYS_tfork]   sys_tfork,
[SYS_getppid]   sys_getppid,
[SYS_pfork]   sys_pfork,
[SYS_shm_init]   sys_shm_init,
[SYS_shm_attach]   sys_shm_attach,
[SYS_shm_detach]   sys_shm_detach,
[SYS_shm_destroy]   sys_shm_destroy,
[SYS_shm_refcnt]   sys_shm_refcnt,
[SYS_kmap]   sys_kmap,
};

void
syscall(void)
{
  int num;
  struct proc *p = myproc();

  num = p->trapframe->a7;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    if (p->tracing_on) {
      p->syscall_number[p->syscalls_made]=num;
      p->syscall_return[p->syscalls_made]=p->trapframe->a0;
      p->syscalls_made++;
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
  }
}
