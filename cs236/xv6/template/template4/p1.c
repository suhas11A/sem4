#include "kernel/stat.h"
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char* argv[]) {
    if (argc != 2)
        printf("Usage: p1 <filename>\n");
    else
        printf("%s\n", argv[1]);

    // Write your code here
    int f=fork();
    if (f==0) {
        close(0);
        open(argv[1]);
        execvp("cat", {"cat",NULL});
    }
    else {
        wait(0);
        printf("My pid is %d, and my child is %d", getpid(), f);
    }
    exit(0);
}
