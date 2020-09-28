
all:
	riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -c -o pgcd.x pgcd.c
	riscv64-unknown-elf-objdump -d pgcd.x --disassembler-options=no-aliases > pgcd.s

clean:
	rm -rf *.x *.o
