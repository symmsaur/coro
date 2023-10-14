#include <assert.h>
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
    printf("Generator finished\n");
    coro_return(ctx);
}

void test_generator() {
    printf("Test generator\n");
    int value = 10;
    Coro* coro = coro_create();
    int res = 1;
    for (coro_start(coro, &generator, (void*)&value); res ; res = coro_continue(coro))
    {
        printf("Got value from generator %i\n", value);
    }
    assert(value == 4);
    coro_destroy(coro);
}

int main() {
    test_generator();
    return 0;
}
