#include "coro.h"

void add_3(void* value_raw) {
    int* value = (int*)value_raw;
    *value += 3;
}
int main() {
    int value = 10;
    Coro* coro = coro_create(&add_3, (void*)&value);
    coro_continue(coro);
    coro_destroy(coro);
    return value;
}
