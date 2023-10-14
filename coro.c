#include "coro.h"

#include <stdlib.h>

Coro* coro_create(void(*func)(void*, void*), void* data)
{
    Coro* coro = malloc(sizeof(Coro));
    // 4k stack per coroutine.
    coro->stack = malloc(4096);
    coro->stack_pointer = coro->stack + 4095;
    coro->func = func;
    coro->data = data;
    return coro;
}

void coro_destroy(Coro* coro) {
    free(coro->stack);
    free(coro);
}
