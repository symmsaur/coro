
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
    ;; We will end up here after yielding from the coroutine.
    ;; Can still count on coro being in rdi.
coro_return:
    ;; Restore original stack pointer
    mov rsp, [rdi+24]
    ;; Restore registers
    pop rbp
    ret

    global coro_continue
;;; Continue coroutine
;;; Arguments:
;;;   rdi: Pointer to Coro struct
coro_continue:
    ;; store function pointer
    mov rax, [rdi+8]

    ;; Add stack setting up stuff here!

    ;; Call funtion pointer passsing state
    ;; Coro.data is at coro+16
    mov rsi, [rdi+16]
    call rax

    mov rax, 1
    ret

;;; Yield from coroutine
;;; Arguments:
;;;   rdi: Pointer to Coro struct
    global coro_yield
coro_yield:
    ;; Actually yield
    ;; How do we get the coro struct pointer into here?
    jmp coro_return
    ret
