section .text
    global call_pointer
    ;; Call function through function pointer
    ;; Arguments:
    ;;   rdi: function pointer to call
    ;;   rsi: pointer to state, passed to function
    call_pointer:
        ;; store function pointer
        mov rax, rdi

        ;; Call funtion pointer passsing state
        mov rdi, rsi
        call rax

        ret
