    section .text
    global coro_start
;;; Start coroutine
;;; Arguments:
;;;   rdi: Pointer to Coro struct
coro_start:
    ;; Push registers to be able to restore
    push rbp

    ;; Swap stack pointers
    mov rax, [rdi]
    mov [rdi], rsp
    mov rsp, rax

    ;; store function pointer
    mov rax, [rdi+8]
    ;; Call funtion pointer passsing state
    ;; Coro.data is at coro+16
    mov rsi, [rdi+16]
    call rax

    global coro_continue
;;; Continue coroutine
;;; Arguments:
;;;   rdi: Pointer to Coro struct
coro_continue:
    ;; To be able to restore later
    push rbp

    ;; Swap stack pointers
    mov rax, [rdi]
    mov [rdi], rsp
    mov rsp, rax

    ;; Restore registers from coroutine stack
    pop rbp
    ;; Return (out of coro_yield basically)
    ret

;;; Yield from coroutine
;;; Arguments:
;;;   rdi: Pointer to Coro struct
    global coro_yield
coro_yield:
    ;; Push registers to be able to restore
    push rbp

    ;; Swap stack pointers
    mov rax, [rdi]
    mov [rdi], rsp
    mov rsp, rax

    ;; Restore registers from caller stack
    pop rbp
    ret
