FROM --platform=linux/amd64 alpine:latest AS builder

RUN apk add --no-cache nasm binutils

WORKDIR /app

COPY hello_world.asm .

RUN nasm -f elf64 hello_world.asm -o object.o && \
    ld -s -o executable object.o

FROM --platform=linux/amd64 alpine:latest

WORKDIR /app

COPY --from=builder /app/executable .

CMD ["./executable"]