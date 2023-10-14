#pragma once

typedef struct Coro {
    void* stack_pointer;
    void* stack;
} Coro;

// Create coroutine
Coro* coro_create();
// Destroy coroutine
void coro_destroy(Coro* coro);

int coro_start(Coro* coro, void(*func)(void*, void*), void* data);
// Continue coroutine
int coro_continue(Coro* coro);

// Yield execution to caller
void coro_yield(void* ctx);
