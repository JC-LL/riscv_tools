
all:
	riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 -c -O2 -o gcd_rv.x gcd.c
	riscv64-unknown-elf-objdump -d gcd_rv.x --disassembler-options=no-aliases > gcd_rv.s
	cat gcd_rv.s

clean:
	rm -rf *.x *.o
