# Compile and Disassemble

## Compile
```bash
gcc hello.c -o hello
```

## Disassemble
```bash
objdump -d hello
```

### (Interactive)
```bash
gdb ./hello
(gdb) disassemble main
(gdb) quit
```

## GDB (GNU Debugger)

### Set breakpoint (точка останова)
```bash
(gdb) break main
```

### Run from breakpoint
```bash
(gdb) run
```

### Execute exactly one instruction (step instruction)
```bash
(gdb) stepi
```