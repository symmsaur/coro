##
# coro
#
# @file
# @version 0.1

build/test_call: build/test_add.o test_call.c
	cc build/test_add.o test_call.c -o build/test_call -masm=intel

build/test_add.o: test_add.c test_add.h
	cc -c test_add.c -o build/test_add.o


# end
