all: build/test/test_coro experiment
.PHONY: all

clean:
	rm -rf build
.PHONY: clean

rebuild: clean all

build/test/test_coro: test/test_coro.c coro.h build/coro_asm.o build/coro.o
	mkdir -p build/test
	cc -I . build/coro.o build/coro_asm.o test/test_coro.c -o build/test/test_coro -g

build/coro_asm.o: coro_asm.s
	mkdir -p build
	nasm -f elf64 -o build/coro_asm.o coro_asm.s

build/coro.o: coro.c coro.h
	mkdir -p build
	cc -c coro.c -o build/coro.o -g

experiment: \
		build/experiment/call_asm \
		build/experiment/call_asm \
		build/experiment/call \
		build/experiment/add.o
.PHONY: experiment

build/experiment/call_asm: experiment/call_asm.c build/experiment/call.o
	mkdir -p build/experiment
	cc build/experiment/call.o experiment/call_asm.c -o build/experiment/call_asm -g

build/experiment/call.o: experiment/call.s
	mkdir -p build/experiment
	nasm -f elf64 -o build/experiment/call.o experiment/call.s

build/experiment/call: build/experiment/add.o experiment/call.c
	mkdir -p build/experiment
	cc build/experiment/add.o experiment/call.c -o build/experiment/call -masm=intel -g

build/experiment/add.o: experiment/add.c experiment/add.h
	mkdir -p build/experiment
	cc -c experiment/add.c -o build/experiment/add.o -g
