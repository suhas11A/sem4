#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "elf.h"

extern struct spinlock wait_lock;

//
// the implementation of the spawn() system call
//
int
kspawn(char *path, char **argv)
{
  char *s, *last;
  int i, off;
  uint64 argc, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  struct proc *p = 0, *mp = myproc();

  begin_op();

  // Open the executable file.
  if((ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    goto bad;

  if((p = allocproc()) == 0)
    goto bad;
  
  release(&p->lock); // Releaseeeeeeee

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    uint64 sz1;
    if((sz1 = uvmalloc(p->pagetable, p->sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
      goto bad;
    p->sz = sz1;
    if(loadseg(p->pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
  end_op();
  ip = 0;

  // Allocate some pages at the next page boundary.
  // Make the first inaccessible as a stack guard.
  // Use the rest as the user stack.
  p->sz = PGROUNDUP(p->sz);
  uint64 sz1;
  if((sz1 = uvmalloc(p->pagetable, p->sz, p->sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    goto bad;
  p->sz = sz1;
  uvmclear(p->pagetable, p->sz-(USERSTACK+1)*PGSIZE);
  sp = p->sz;
  stackbase = sp - USERSTACK*PGSIZE;

  // Copy argument strings into new stack, remember their
  // addresses in ustack[].
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp -= strlen(argv[argc]) + 1;
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    if(sp < stackbase)
      goto bad;
    if(copyout(p->pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[argc] = sp;
  }
  ustack[argc] = 0;

  // push a copy of ustack[], the array of argv[] pointers.
  sp -= (argc+1) * sizeof(uint64);
  sp -= sp % 16;
  if(sp < stackbase)
    goto bad;
  if(copyout(p->pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    goto bad;

  // a0 and a1 contain arguments to user main(argc, argv)
  *(p->trapframe) = *(mp->trapframe);
  p->trapframe->a0 = argc;
  p->trapframe->a1 = sp;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
    if(*s == '/')
      last = s+1;
  safestrcpy(p->name, last, sizeof(p->name));
    
  // Commit to the user image.
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
  p->trapframe->sp = sp; // initial stack pointer

  // increment reference counts on open file descriptors.
  for(i = 0; i < NOFILE; i++)
    if(mp->ofile[i])
      p->ofile[i] = filedup(mp->ofile[i]);
  p->cwd = idup(mp->cwd);

  acquire(&wait_lock);
  p->parent = mp;
  release(&wait_lock);

  acquire(&p->lock);
  int pid = p->pid;
  p->state = RUNNABLE;
  release(&p->lock);

  return pid;

 bad:
  if(p) {
    if (!holding(&p->lock))
      acquire(&p->lock);
    freeproc(p);
    release(&p->lock);
  }
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
