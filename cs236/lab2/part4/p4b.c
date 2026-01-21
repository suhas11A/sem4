#include <math.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>


int main() {
    char n[256];
    while (1) {
        printf("Enter a command: ");
        scanf("%255s", n);
        int f = fork();
        if (f==0) {
            char* argv[] = {n, NULL};
            execvp(argv[0], argv);
        }
        wait(0);
        printf("Finished one thing\n");
    }
    return 0;
}