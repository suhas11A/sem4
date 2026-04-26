#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf("Usage: p1 <filename>\n");
        exit(1);
    }
    else
        printf("%s\n", argv[1]);

    // Write your code here
    int f=fork();
    if (f==0) {
        close(0);
        open(argv[1],0);
        char* argo[2]={"cat",'\0'};
        exec("cat", argo);
    }
    else {
        wait(0);
        printf("My pid is %d, and my child is %d\n", getpid(), f);
    }
    exit(0);
}
