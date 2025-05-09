section .text
    global _start

_start:
    mov rax, 100
    mov rbx, 100

    ;; switch using temporary registry (rcx)
    mov rcx, rax    ;; rcx = rax (100)
    mov rax, rbx    ;; rax = rbx (200)
    mov rbx, rcx    ;; rbx = rcx (100)

    ;; using xor-swap
    xor rax, rbx    ;; rax = rax ^ rbx
    xor rbx, rax    ;; rbx = rbx ^ rax (rbx = 100)
    xor rax, rbx    ;; rax = rax ^ rbx (rax = 200)

    ;; end of program (lunux syscall)
    mov rax, 60     ;; sys_exit
    xor rdi, rdi    ;; exit code 0
    syscall