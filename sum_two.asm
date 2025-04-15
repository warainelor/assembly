section .data
    SYS_WRITE   equ 1
    STD_OUT     equ 1
    SYS_EXIT    equ 60
    EXIT_CODE   equ 0
    
    NEW_LINE    db 0xa
    WRONG_ARGC  db "Must be two command line argument", 0xa

section .text
    global _start

_start:
    ;; в linux аргументы командной строки передаются через стек
    ;; первая ячейка содержит argc (количество аргументов)
    ;; pop rcx забирает это значение и помещает в rcx
    pop rcx
    ;; в argc также учитывается и имя программы (например: ./program arg1 arg2)
    cmp rcx, 3
    ;; если argc != 3, переход к argcError
    jne argcError

    ;; пропускает имя программы argv[0], увеличивая rsp на 8 байт, т.к. argv[0] это указатель с размеров 8 байт
    add rsp, 8
    ;; забирает argv[1] из стека и помещает в rsi
    pop rsi
    ;; преобразует строку в число, т.к. аргументы передаются как строки и неявно помезает это в rax
    call str_to_int

    ;; копирует значение из регистра rax в r10
    mov r10, rax
    ;; берем argv[2] и помещаем в rsi
    pop rsi
    ;; изменяем тип данных на int и помещаем в rax
    call str_to_int
    ;; помещаем из rax в r11
    mov r11, rax

    ;; складывает 2 числа из r10 и r11 и сохраняет результат в r10 (r10 = r10 + r11)
    add r10, r11

    mov rax, r10
    ;; number counter
    xor r12, r12
    ;; convert to string 
    jmp int_to_str

argcError:
    ;; sys_write syscall
    mov rax, 1
    ;; file descriptor, stdout
    mov rdi, 1
    ;; message address
    mov rsi, WRONG_ARGC
    ;; length of the message
    mov rdx, 34
    ;; call write syscall
    syscall
    ;; exit from program 
    jmp exit 

str_to_int:
    ;; обнуляем rax потому что может содержать мусорные значения
    xor rax, rax
    ;; rcx используется как основание системы счисления, 10 для десятичных чисел 
    mov rcx, 10
next:
    ;; проверяет достигли ли конца строки - NULL (0 byte)
    cmp [rsi], byte 0
    ;; если достигли переходит как return_str 
    je return_str
    ;; загружает текущий символ (rsi указывает на строку)
    mov bl, [rsi]
    ;; В ASCII цифры '0'–'9' представлены кодами 48–57, поэтому sub bl, 48 превращает '0' → 0, '1' → 1, и т. д.
    sub bl, 48
    ;; Умножает текущее значение rax на 10 (сдвигает разряд).
	;; Это сдвигает текущее число влево, чтобы можно было добавить новую цифру.
    mul rcx
    ;; добавляет новую цифру к числу
    add rax, rbx
    ;; увеличивает rsi чтобы перейти к следующему символу
    inc rsi
    jmp next 

return_str:
    ret

int_to_str:
    ;; обнуляет регистр rdx
    ;; rdx используется для хранения остатка от деления 
    ;; перед div важно обнулять rdx так как 64-битное деление использует rdx:rax кка едины 128-битный регистр
    mov rdx, 0
    ;; задаем делитель (основание системы счисления)
    mov rbx, 10
    ;; деление на 10
    ;; div делит rdx:rax на rbx (10)
    ;; результат деления (rax / rbx) записывается в rax 
    ;; остаток записывается (rax % rbx) в rdx 
    div rbx
    ;; преобразуем цифру в ascii
    add rdx, 48
    ;; добавляем 0x0 потому что все строки должны заканчиваться на 0x0
    add rdx, 0x0
    ;; сохраняем ascii-символ в стек
    push rdx
    ;; увеличиваем счетчик цифр r12 (r12 используется как счетчик цифр)
    inc r12
    ;; проверка все ли цифры обработаны, если rax еще не ноль значит есть еще цифры
    cmp rax, 0x0
    jne int_to_str
    jmp print

print:
    ;; calculate number length
    mov rax, 1
    mul r12
    mov r12, 8
    mul r12
    mov rdx, rax

    ;; print sum
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, rsp
    ;; call sys_write
    syscall

    jmp exit

exit:
    mov rax, SYS_EXIT
    ;; exit code
    mov rdi, EXIT_CODE
    syscall