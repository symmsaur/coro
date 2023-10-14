#include <stdio.h>

#include "coro.h"

void generator(void* ctx, void* output_raw) {
    printf("In generator\n");
    int value = 0;
    for (int i = 0; i < 5; i++)
    {
      *(int*)output_raw = i;
      coro_yield(ctx);
    }
}

int main() {
    int value = 10;
    Coro* coro = coro_create();
    int res = 1;
    for (coro_start(coro, &generator, (void*)&value); res ; res = coro_continue(coro))
    {
        printf("Got value from generator %i\n", value);
    }
    coro_destroy(coro);
    return value;
}
