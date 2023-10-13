#pragma once

typedef struct Coro {
    void* stack;
    void(*func)(void*);
    void* data;
} Coro;

typedef enum CoroResult {
    Finished,
    Ok
} CoroResult;

// Create coroutine
Coro* coro_create(void(*func)(void*), void* data);
void coro_destroy(Coro* coro);

// Start or continue coroutine
CoroResult coro_continue(Coro* coro);

// Yield execution to caller
void coro_yield();
