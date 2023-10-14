    section .text
    global coro_start
;;; Start coroutine
;;; Arguments:
;;;   rdi: coro - Pointer to Coro struct
;;;   rsi: func - Function pointer
;;;   rdx: data - Function data
coro_start:
    ;; Push registers to caller stack to be able to restore when yielding.
    push rbp

    ;; Swap stack pointers.
    mov rax, [rdi]
    mov [rdi], rsp
    mov rsp, rax

    ;; Set up call to coroutine function.
    ;; void func(void* ctx, void* data)
    mov rax, rsi
    mov rsi, rdx
    call rax
    ;; Returning happens from coro_yield.

    global coro_continue
;;; Continue coroutine
;;; Arguments:
;;;   rdi: Pointer to Coro struct
coro_continue:
    ;; Push registers to caller stack to be able to restore when yielding.
    push rbp

    ;; Swap stack pointers.
    mov rax, [rdi]
    mov [rdi], rsp
    mov rsp, rax

    ;; Restore registers from coroutine stack.
    pop rbp
    ;; Return as if in coro_yield
    ret

;;; Yield from coroutine
;;; Arguments:
;;;   rdi: Pointer to Coro struct
    global coro_yield
coro_yield:
    ;; Push registers coroutine stack to be able to restore when continuing.
    push rbp

    ;; Swap stack pointers.
    mov rax, [rdi]
    mov [rdi], rsp
    mov rsp, rax

    ;; Restore registers from caller stack.
    pop rbp
    ;; Return as if in coro_continue/coro_start.
    ret
