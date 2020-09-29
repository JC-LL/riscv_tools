
all:
	# no optimisation required by our ISS : -O0
	riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -c -O0 -o pgcd.x pgcd.c
	riscv64-unknown-elf-objdump -d pgcd.x --disassembler-options=no-aliases > pgcd.s

clean:
	rm -rf *.x *.o
