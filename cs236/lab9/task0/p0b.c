#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

int total = 0;

void* increment(void *arg) {
    int x = *(int *)arg;
    // TODO: Increment total by x for 1 million times, where x is the argument passed to the thread.
    for (int i = 0; i < 1000000; i++) {
        total += x;
    }
    int *thread_sum = (int*)malloc(sizeof(int));
    *thread_sum = x * 1000000;
    // TODO: Return the total increment done by this thread (i.e., x * 1000000) as the thread's return value.
    return thread_sum;
}

int main() {
    // TODO: Create threads to run increment function with arguments 1, 2, 3, and 4 respectively.
    pthread_t threads[4];
    int args[4] = {1, 2, 3, 4};
    for (int i = 0; i < 4; i++) {
        pthread_create(&threads[i], NULL, increment, &args[i]);
    }
    // TODO: Wait for all threads to finish and print the total value.

    for (int i = 0; i < 4; i++) {
        int *thread_result;
        pthread_join(threads[i], (void **)&thread_result);
        printf("Thread %d incremented total by %d\n", args[i], *thread_result);
        free(thread_result);
    }
    printf("Total: %d\n", total);
    return 0;
}