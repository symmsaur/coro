#include "test_add.h"

int main() {
    int res = 7;
    // put 8 into rdi, put 13 into rsi
    // call add
    // put result in rax into res
    //
    asm(
     "mov rdi,8\n\t"
     "mov rsi, 13\n\t"
     "call %1\n\t"
     "mov %0, eax"
    // Outputs
    : "=r" (res)
        // Inputs
     : "g" (add)
    // Clobber list
    : "rdi", "rsi"
    );
    return res;
}
