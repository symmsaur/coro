#include <stdint.h>
#include <stdio.h>
#include <sys/time.h>
#include <sys/resource.h>

#include "../coro.h"

int64_t get_time_us() {
    struct timeval time;
    gettimeofday(&time, 0);
    return (int64_t)time.tv_sec * 1000000 + time.tv_usec;
}

#define NUM_STEPS 100000
#define NUM_COROUTINES 1000

void increment(void* ctx, void* value) {
    coro_yield(ctx);  // Immediately suspend after coro_start().
    for (int i = 0; i < NUM_STEPS; i++)
    {
        *(int64_t*)value += 1;
        coro_yield(ctx);
    }
    coro_return(ctx);
}

int main() {
    int64_t value = 0;
    Coro* coroutines[NUM_COROUTINES];
    printf("Spawning %i coroutines\n", NUM_COROUTINES);
    int64_t start_time_us = get_time_us();
    for (int i = 0; i < NUM_COROUTINES; i++) {
        coroutines[i] = coro_create();
        coro_start(coroutines[i], &increment,  &value);
    }
    int64_t started_time_us = get_time_us();
    printf("Started in %ld us\n", started_time_us - start_time_us);
    printf("Running %i steps of %i coroutines\n", NUM_STEPS, NUM_COROUTINES);
    for (int i = 0; i < NUM_STEPS; i++) {
        for (int j = 0; j < NUM_COROUTINES; j++) {
            coro_continue(coroutines[j]);
        }
    }
    int64_t finished_time_us = get_time_us();
    printf("Executed in %ld us\n", finished_time_us - started_time_us);
    printf("%f us per step\n", (double)(finished_time_us - started_time_us) / (NUM_STEPS * NUM_COROUTINES));
    printf("value %ld\n", value);
    return 0;
}
