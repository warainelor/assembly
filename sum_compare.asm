;; definition of the .data section
section .data:
    ;; the first number
    num1 dq 0x64
    ;; the second number
    num2 dq 0x32
    ;; the message to print if the sum is correct
    msg db "the sum is correct!", 10

;; definiton of the .text section
section .text
    ;; reference to the entry point of our program
    global _start

;; entry point
_start:
    ;; set the value of the num1 to the rax
    mov rax, [num1]
    ;; set the value of the num2 to the rbx
    mov rbx, [num2]
    ;; get the sum of the rax and rbx. the result is stored in the rax
    add rax, rbx 

.compare:
    ;; compare the value of the rax with 150
    cmp rax, 150
    ;; go to the .exit label if the rax value is not 150
    jne .exit 
    ;; go to the .correctSum label if the rax value is 150
    jmp .correctSum

;; print a message that the sum is correct
.correctSum:
    ;; specify the system call (1 is sys_write)
    mov rax, 1
    ;; set the first argument of sys_write to 1 (stdout)
    mov rdi, 1
    ;; set the second argument of sys_write to the reference of the msg variable
    mov rsi, msg 
    ;; set the third argument to the length of the msg variable's value (20 bytes)
    mov rdx, 20
    ;; call the sys_write system call
    syscall
    ;; go to the exit of the program
    jmp .exit 

;; exit procedure
.exit:
    ;; specify the number of the system call (60 is sys_exit)
    mov rax, 60
    ;; set the first argument of sys_exit to 0. the 0 status code is success
    mov rdi, 0
    ;; call the sys_exit system call
    syscall