
section .text
    global coro_continue
    ;; Call function through function pointer
    ;; Arguments:
    ;;   rdi: Pointer to Coro struct
    coro_continue:
        ;; store function pointer
        mov rax, [rdi+8]

        ;; Add stack setting up stuff here!

        ;; Call funtion pointer passsing state
        ;; Coro.data is at coro+16
        mov rdi, [rdi+16]
        call rax

        mov rax, 1
        ret

;;// Yield execution to caller
    ;; void coro_yield()
