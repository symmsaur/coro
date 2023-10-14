    section .text
    global coro_start
;;; Start coroutine
;;; Arguments:
;;;   rdi: Pointer to Coro struct
coro_start:
    ;; Push registers to caller stack to be able to restore when yielding.
    push rbp

    ;; Swap stack pointers.
    mov rax, [rdi]
    mov [rdi], rsp
    mov rsp, rax

    ;; Set up call to coroutine function.
    ;; Function pointer in coro+8
    mov rax, [rdi+8]
    ;; Coro.data is at coro+16
    mov rsi, [rdi+16]
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
