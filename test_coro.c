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
    int value = 42;
    Coro* coro = coro_create();
    int res = 1;
    for (coro_start(coro, &generator, (void*)&value); res ; res = coro_continue(coro))
    {
        printf("Got value from generator %i\n", value);
    }
    assert(value == 4);
    coro_destroy(coro);
}

void inner(void* ctx, void*) {
    for (int i = 0; i < 5; i++)
    {
        printf("Inner %i\n", i);
        coro_yield(ctx);
    }
    coro_return(ctx);
}

void outer(void* ctx, void*) {
    Coro* coro = coro_create();
    int res = 1;
    int i = 0;
    for (coro_start(coro, &inner, 0); res ; res = coro_continue(coro))
    {
        printf("Outer %i\n", i);
        if (!(i % 2)) coro_yield(ctx);
        i++;
    }
    coro_return(ctx);
}

void test_nested() {
    printf("Test nested\n");
    Coro* coro = coro_create();
    int res = 1;
    for (coro_start(coro, &outer, 0); res ; res = coro_continue(coro))
    {
        printf("In caller\n");
    }
}

int main() {
    test_generator();
    test_nested();
    return 0;
}
