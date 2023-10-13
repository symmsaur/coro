##
# coro
#
# @file
# @version 0.1

build/test_coro: test_coro.c coro.h build/coro_asm.o build/coro.o
	cc build/coro.o build/coro_asm.o test_coro.c -o build/test_coro

build/coro_asm.o: coro_asm.s
	nasm -f elf64 -o build/coro_asm.o coro_asm.s

build/coro.o: coro.c
	cc -c coro.c -o build/coro.o

build/test_call_asm: test_call_asm.c build/call.o
	cc build/call.o test_call_asm.c -o build/test_call_asm

build/call.o: call.s
	nasm -f elf64 -o build/call.o call.s

build/test_call: build/test_add.o test_call.c
	cc build/test_add.o test_call.c -o build/test_call -masm=intel

build/test_add.o: test_add.c test_add.h
	cc -c test_add.c -o build/test_add.o


# end
