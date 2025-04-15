section .data
    msg db 'Result: ', 0

;; section where variables stored, which haven't been initialized by values
section .bss
    ;; resb - reserve bytes (10 bytes)
    result resb 10

section .text
    global _start

_start:
    mov rax, 5
    nov rbx, 7

    add rax, rbx

    mov rdi, result
    call num_to_str 

    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, 8
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 2
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

num_to_str:
    ;; add to rax '0' which is 48 in ASCII ("0" = 48)
    add rax, '0'
    mov byte [rdi], al
    ret 