#include "coro.h"

#include <stdlib.h>

Coro* coro_create()
{
    Coro* coro = malloc(sizeof(Coro));
    // 4k stack per coroutine.
    coro->stack = malloc(4096);
    coro->stack_pointer = coro->stack + 4096;
    return coro;
}

void coro_destroy(Coro* coro) {
    free(coro->stack);
    free(coro);
}
