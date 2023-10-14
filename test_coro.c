#include <stdio.h>

#include "coro.h"

void generator(void* ctx, void* output_raw) {
    /* int* output = (int*)output_raw; */
    /* int value = 0; */
    /* while (1) { */
    /*   value += 7; */
    /*   *output = value; */
    /*   coro_yield(ctx); */
    /* } */
    *(int*)output_raw = 7;
    coro_yield(ctx);
}

int main() {
    int value = 10;
    Coro* coro = coro_create(&generator, (void*)&value);
    coro_start(coro);
    printf("%i\n", value);
    /* coro_continue(coro); */
    /* printf("%i\n", value); */
    /* coro_continue(coro); */
    /* printf("%i\n", value); */
    coro_destroy(coro);
    return value;
}
