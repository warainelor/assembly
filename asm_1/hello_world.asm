;; definition of the data section
;; data section is for static data, exists till program works
section .data
    ;; variable with type of string with value "hello, world"
    msg db "hello, world"
    ;; msg is just a label
    ;; db - Defyne Bye
    ;; string is gonna be saved as ASCII-code

;; definition of the text section
;; text section contains source code of program
section .text
    ;; mark the '_start' symbol as global so that it is visible to the linker
    global _start 

;; definition of the program entry point
_start:
    ;; rax (Accumulator Register) - storages num of syscall
    ;; num for syscall (1 for 'sys_write')
    mov rax, 1

    ;; rdi (Destination Index Register) - storages file descriptor (where to write)
    ;; set 1st arg for 'sys_write' to the value of 1 (stdout)
    mov rdi, 1

    ;; rsi (Source Index Register) - points to the msg address
    ;; set 2nd arg for 'sys_write' to the value of string msg
    mov rsi, msg 

    ;; rdx (Data Register) - storages amount of bites, which needs to be output
    ;; set 3rd arg for to the length of the msg string
    mov rdx, 13
    ;; call 'sys_write'
    syscall


    ;; set new num of syscall (60 for 'sys_exit')
    mov rax, 60

    ;; set 1st arg 'sys_exit' to 0 (success)
    mov rdi, 0

    ;; call 'sys_exit'
    syscall
