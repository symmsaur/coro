
    section .text
    global coro_start
;;; Start coroutine
;;; Arguments:
;;;   rdi: Pointer to Coro struct
coro_start:
    ;; To be able to restore later
    push rbp

    ;; store function pointer
    mov rax, [rdi+8]
    ;; Call funtion pointer passsing state
    ;; Coro.data is at coro+16
    mov rsi, [rdi+16]
    ;; Store our stack pointer to enable restoring it
    mov [rdi+24], rsp
    ;; Restore coroutine stack pointer
    mov rsp, [rdi]
    call rax

    global coro_continue
;;; Continue coroutine
;;; Arguments:
;;;   rdi: Pointer to Coro struct
coro_continue:
    ;; To be able to restore later
    push rbp

    ;; Store our stack pointer to enable restoring it
    mov [rdi+24], rsp
    ;; Restore coroutine stack pointer
    mov rsp, [rdi]
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
    ;; Store the stack pointer to be able to resume the coroutine
    mov [rdi], rsp
    ;; Restore original stack pointer
    mov rsp, [rdi+24]
    ;; Restore registers
    pop rbp
    ret
