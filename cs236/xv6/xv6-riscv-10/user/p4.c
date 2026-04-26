#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

sem_t s0, s1, s2;
int N;

void t0(int *arg)
{
    for (int i = 0; i < N; i++) {
        sem_down(&s0);
        printf("T-0: hello\n");
        sem_up(&s1);
    }
    exit(0);
}

void t1(int *arg)
{
    for (int i = 0; i < N; i++) {
        sem_down(&s1);
        printf("T-1: hello\n");
        sem_up(&s2);
    }
    exit(0);
}

void t2(int *arg)
{
    for (int i = 0; i < N; i++) {
        sem_down(&s2);
        printf("T-2: hello\n");
        sem_up(&s0);
    }
    exit(0);
}

int main(int argc, char *argv[])
{
    if (argc < 2) {
        printf("Usage: p4 N\n");
        exit(0);
    }

    N = atoi(argv[1]);

    // initialize semaphores
    s0.lock = s1.lock = s2.lock = 0;
    sem_init(&s0, 1);  // T0 starts first
    sem_init(&s1, 0);
    sem_init(&s2, 0);

    create_thread(t0, 0);
    create_thread(t1, 0);
    create_thread(t2, 0);

    join();
    join();
    join();

    exit(0);
}