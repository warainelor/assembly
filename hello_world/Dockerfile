FROM --platform=linux/amd64 alpine:latest AS builder

ARG PROGRAM=hello_world

RUN apk add --no-cache nasm binutils

WORKDIR /app

COPY $PROGRAM.asm .

RUN nasm -f elf64 $PROGRAM.asm -o object.o && \
    ld -s -o executable object.o

FROM --platform=linux/amd64 alpine:latest

WORKDIR /app

COPY --from=builder /app/executable .

CMD ["./executable"]