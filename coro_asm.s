    section .text
    global coro_start
;;; Start coroutine
;;; Arguments:
;;;   rdi: coro - Pointer to Coro struct
;;;   rsi: func - Function pointer
;;;   rdx: data - Function data
coro_start:
    ;; Push registers to caller stack to be able to restore when yielding.
    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15

    ;; Swap stack pointers.
    mov rax, [rdi]
    mov [rdi], rsp
    mov rsp, rax

    ;; Set up call to coroutine function.
    ;; void func(void* ctx, void* data)
    mov rax, rsi
    mov rsi, rdx
    call rax
    ;; If the coroutine yields we return through coro_yield.
    ;; If the coroutine is finished return through coro_return.
    ;; If the coroutine function returns we end up here. This should never happen.
    mov rax, 0
    mov rax, [rax]              ; Cause segfault


    global coro_continue
;;; Continue coroutine
;;; Arguments:
;;;   rdi: Pointer to Coro struct
coro_continue:
    ;; Push registers to caller stack to be able to restore when yielding.
    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15

    ;; Swap stack pointers.
    mov rax, [rdi]
    mov [rdi], rsp
    mov rsp, rax

    ;; Restore registers from coroutine stack.
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx
    ;; Return as if in coro_yield
    ret

;;; Return from coroutine
;;; Arguments:
;;;   rdi: Pointer to Coro struct
    global coro_return
coro_return:
    mov rax, 0                  ; Signal finished
    jmp return_to_caller

;;; Yield from coroutine
;;; Arguments:
;;;   rdi: Pointer to Coro struct
    global coro_yield
coro_yield:
    ;; Push registers coroutine stack to be able to restore when continuing.
    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15
    mov rax, 1                  ; Signal continue.
return_to_caller:                  ; Return already in rax.
    ;; Swap stack pointers.
    mov rdx, [rdi]
    mov [rdi], rsp
    mov rsp, rdx

    ;; Restore registers from caller stack.
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx
    ;; Return as if in coro_continue/coro_start.
    ret
