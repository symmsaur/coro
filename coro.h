#pragma once

typedef struct Coro {
    void* stack_pointer;
    void* stack;
} Coro;

// Create coroutine
Coro* coro_create();
void coro_destroy(Coro* coro);

void coro_start(Coro* coro, void(*func)(void*, void*), void* data);
// Continue coroutine
void coro_continue(Coro* coro);

// Yield execution to caller
void coro_yield(void* ctx);
