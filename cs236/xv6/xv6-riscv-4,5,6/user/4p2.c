#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char* argv[]) {
    int f=fork();
    if (f==0) {
        exit(0);
    }
    else {
        wait(0);
        printf("[parent]: my_pid: %d, child_pid: %d\n", getpid(), f);
    }
    exit(0);
}
