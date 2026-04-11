#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

int total = 0;
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

void* increment(void *arg) {
    int x = *(int *)arg;

    for (int i = 0; i < 1000000; i++) {
        pthread_mutex_lock(&lock);
        total += x;
        pthread_mutex_unlock(&lock);
    }

    int *thread_sum = (int*) malloc(sizeof(int));
    *thread_sum = x * 1000000;
    return thread_sum;
}

int main() {
    pthread_t threads[4];
    int args[4] = {1, 2, 3, 4};

    for (int i = 0; i < 4; i++) {
        pthread_create(&threads[i], NULL, increment, &args[i]);
    }
    int *thread_result;
    for (int i = 0; i < 4; i++) {
        pthread_join(threads[i], (void **)&thread_result);
        printf("Thread %d incremented total by %d\n", args[i], *thread_result);
    }

    printf("Total: %d\n", total);

    pthread_mutex_destroy(&lock);
    return 0;
}