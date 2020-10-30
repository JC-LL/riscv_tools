
all:
	# no optimisation required by our ISS : -O0
	#riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -c -O0 -o sumofint.x sumofint.c
	riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -O0  --save-temps sumofint.c
	#riscv64-unknown-elf-objdump -d sumofint.x --disassembler-options=no-aliases > sumofint.s
	riscv64-unknown-elf-objdump -d a.out --disassembler-options=no-aliases > sumofint.s
clean:
	rm -rf *.x *.o
