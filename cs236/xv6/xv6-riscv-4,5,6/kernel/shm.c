#include "shm.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "vm.h"

uint64
sys_shm_init(void)
{
    if (!shm.valid) {
        shm.valid=1;
        shm.refcnt=-1;
    }
    if(shm.refcnt >= 0){
        return -1;
    }
    shm.kva = (uint64) kalloc();
    shm.refcnt=0;
    return 0;
}

uint64
sys_shm_attach(void)
{
    if (myproc()->has_attached_shm || !shm.valid || shm.refcnt == -1){
        return 0;
    }
    extern pagetable_t kernel_pagetable;
    mappages(myproc()->pagetable, SHMEM, PGSIZE, PTE2PA(*walk(kernel_pagetable, shm.kva, 0)), PTE_U|PTE_R|PTE_W);
    myproc()->has_attached_shm=1;
    shm.refcnt++;
    return SHMEM;
}

uint64
sys_shm_detach(void)
{
    if (!myproc()->has_attached_shm || !shm.valid || shm.refcnt == -1){
        return -1;
    }
    uvmunmap(myproc()->pagetable, SHMEM, 1, 0);
    myproc()->has_attached_shm=0;
    shm.refcnt--;
    return 0;
}

uint64
sys_shm_destroy(void)
{
    if (!shm.valid || shm.refcnt != 0){
        return -1;
    }
    shm.refcnt=-1;
    extern pagetable_t kernel_pagetable;
    kfree((void *) PTE2PA(*walk(kernel_pagetable, shm.kva, 0)));
    return 0;
}

uint64
sys_shm_refcnt(void)
{
    if (!shm.valid) return -1;
    return shm.refcnt;
}
