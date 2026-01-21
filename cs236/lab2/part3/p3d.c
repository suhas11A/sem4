#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    // TODO: fork and complete if-else (copy from p3b.c)
    int f1=fork(); int f2; int status;
    if (f1<0) {
        printf("fork failed\n");
        return 1;
    }
    else if (f1==0) {  // Child
        printf("In child1: pid, ppid are %d, %d\n", getpid(), getppid());
        sleep(3);
    }
    else{
        f2 = fork();
        if (f2<0) {
            printf("fork failed\n");
            return 1;
        }
        else if (f2==0) {
            printf("In child2: pid, ppid are %d, %d\n", getpid(), getppid());
            sleep(60);
        }
        else {
            int children_left = 2;
            while (children_left > 0) {
                int pid = waitpid(-1, &status, WNOHANG);
                if (pid > 0) {
                    if (WIFEXITED(status)) {
                        printf("Child %d exited normally with status %d\n", pid, WEXITSTATUS(status));
                    }
                    else if (WIFSIGNALED(status)) {
                        printf("Child %d terminated by signal %d\n", pid, WTERMSIG(status));
                    }
                    children_left--;
                }
                else if (pid == 0) {
                    printf("No child to reap\n");
                    sleep(2);
                }
            }
            printf("All children exited. Parent exiting.\n");
        }
    }
    return 0;
}
