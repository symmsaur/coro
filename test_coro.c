#include <stdio.h>

#include "coro.h"

void generator(void* ctx, void* output_raw) {
    printf("In generator\n");
    int value = 0;
    while (1) {
      value += 7;
      *(int*)output_raw = value;
      printf("Generator yielded value %i\n", value);
      coro_yield(ctx);
    }
}

int main() {
    int value = 10;
    Coro* coro = coro_create(&generator, (void*)&value);
    coro_start(coro);
    printf("Got value from generator %i\n", value);
    for (int i = 0; i < 10; i++)
    {
        coro_continue(coro);
        printf("Got value from generator %i\n", value);
    }
    coro_destroy(coro);
    return value;
}
