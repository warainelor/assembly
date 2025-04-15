section .data
    input_num equ 5                   ;; input is hard coded
    msg db "Factorial of ", 0
    msg_len equ $ - msg
    msg_result db " is ", 0
    msg_res_len equ $ - msg_result
    newline db 10                   ;; newline symbol

section .bss
    result resb 20                 ;; buffer for result storage (as string)
    num_str resb 20                 ;; buffer for number storage (as string)

section .text
    global _start

_start:
    ;; compute number factorial input_num
    mov rdi, input_num                  ;; factorial arg
    call factorial
    mov rdi, rax                        ;; save result for string convertation
    call int_to_string                  ;; convert result to string
    mov [result], rsi                   ;; save result

    ;; convert input_num to string
    mov rdi, input_num
    call int_to_string
    mov [num_str], rsi                  ;; save number string

    ;; print message "Factorial of "
    mov rax, 1                          ;; sys_write
    mov rdi, 1
    mov rsi, msg 
    mov rdx, msg_len
    syscall

    ;; print number (input num)
    mov rax, 1
    mov rdi, 1
    mov rsi, num_str                    ;; convert number to string 
    call strlen                         ;; compute string length
    mov rdx, rax                        ;; string length for sys_write
    syscall

    ;; print " is "
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_result
    mov rdx, msg_res_len
    syscall

    ;; print result (factorial)
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    call strlen
    mov rdx, rax
    syscall

    ;; print symbol of new line
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ;; end of program
    mov rax, 60                         ;; sys_exit
    xor rdi, rdi                        ;; return code is 0
    syscall

;; compute factorial function (iterative)
factorial:
    mov rax, 1                          ;; result initialization (1! = 1)
    cmp rdi, 0
    je .end                             ;; if 0! = 1
.loop:
    mul rdi                             ;; rax *= rdi
    dec rdi                             ;; decrement rdi
    jnz .loop                           ;; while rdi != 0
.end:
    ret

;; int to string (ASCII) convert function
;; input: rdi = number
;; output: rsi = string pointer
int_to_string:
    mov rax, rdi                        ;; convertation number
    lea rsi, [num_str + 19]             ;; buffer end pointer
    mov byte [rsi], 0                   ;; zero terminator
    mov rbx, 10                         ;; divider 
.loop:
    dec rsi
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rsi], dl
    test rax, rax
    jnz .loop
    ret

;; string length computation function
;; input: rsi = string pointer
;; output: rax = string length
strlen:
    xor rax, rax                        ;; length counter
.loop:
    cmp byte [rsi + rax], 0             ;; check end of string
    je .end
    inc rax
    jmp .loop
.end:
    ret