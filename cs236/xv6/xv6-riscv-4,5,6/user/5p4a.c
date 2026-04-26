#include "kernel/types.h"
#include "user/user.h"

#define PGSIZE 4096
#define MAXVA (1L << (9 + 9 + 9 + 12 - 1))
#define TRAMPOLINE (MAXVA - PGSIZE)

int main(int argc, char *argv[])
{
    // Implement your logic here. Re-use va_to_pa() here.
    printf("Trampoline virtual address : %p\n", (void *) TRAMPOLINE);
    printf("Trampoline physical address: %p\n", (void *) va_to_pa(TRAMPOLINE));
    exit(0);
}
