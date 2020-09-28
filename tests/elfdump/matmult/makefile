
all:
	riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -c -o matmult.elf matmult.c
	riscv64-unknown-elf-objdump -d matmult.elf --disassembler-options=no-aliases > matmult.s

clean:
	rm -rf *.x *.o
