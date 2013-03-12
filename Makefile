swtm: linker_script main.o intp.o
	ld -Bstatic -T linker_script -o swtm /usr/lib32/crt1.o /usr/lib32/crti.o main.o intp.o -lc /usr/lib32/crtn.o

intp.o: intp.asm
	nasm -f elf32 intp.asm

main.o: main.s
	as --32 -o main.o main.s

main.s: main.c
	gcc -m32 -Wall -Wextra -pedantic -O3 -S main.c

clean:
	rm -f swtm intp.o main.o main.s
