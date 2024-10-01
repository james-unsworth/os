# Toolchain definitions for cross-compiling the OS
CC = i386-elf-gcc			# Cross-compiler (GCC) for generating object files from C source files
AS = nasm					# Assembler (NASM) for converting assembly code to object files
LD = i386-elf-ld			# Linker for linking object files into the final executable (ELF)
OBJCOPY = i386-elf-objcopy	# Tool for converting ELF executables into raw binary format
GDB = gdb					# Debugger for debugging the kernel in QEMU

# Compilation and linking flags 
CFLAGS = -ffreestanding -c -g	# Compiler flags: freestanding environment, debugging information
LDFLAGS = -Ttext 0x1000			# Linker flags: link the kernel at memory address 0x1000

# Source files
BOOTLOADER_SRC = boot/boot_sect.asm				# Bootloader source file (assembly)
KERNEL_ENTRY_SRC = kernel/kernel_entry.asm 		# Kernal entry point (assembly)
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)	# All C source files in kernel/ and drivers/ directories
HEADERS = $(wildcard kernel/*.h drivers/*.h)	# All C header files in kernel/ and drivers/ directories

# Object and binary files
BOOTLOADER_OBJ = boot/boot_sect.bin			# Bootloader binary file
KERNEL_ELF = kernel/kernel.elf				# Kernel ELF file for debugging
KERNEL_BIN = kernel/kernel.bin				# Kernel binary file for bootable image
KERNEL_ENTRY_OBJ = kernel/kernel_entry.o 	# Kernel entry object file 
OBJ = ${C_SOURCES:.c=.o}					# Object files generated from C source file

OS_IMAGE = os-image.bin						# Final OS image that combines bootloader and kernel binary


# Default target: build OS image
all: $(OS_IMAGE)

# Build final OS image by concatenating bootloader and kernel binary
$(OS_IMAGE) : $(BOOTLOADER_OBJ) $(KERNEL_BIN)
	cat $^ > $@

# compile bootloader (assembly) into raw binary
$(BOOTLOADER_OBJ) : $(BOOTLOADER_SRC)
	$(AS) -f bin -o $@ $<

# assemble kernel entry point (assembly) into object file 
$(KERNEL_ENTRY_OBJ): $(KERNEL_ENTRY_SRC)
	$(AS) -f elf32 -o $@ $<

# link all kernel object files into kernel ELF files (used for debugging)
$(KERNEL_ELF): $(KERNEL_ENTRY_OBJ) ${OBJ}
	$(LD) $(LDFLAGS) -o $@ $^

# Convert kernel ELF file to raw binary format for OS image
$(KERNEL_BIN): $(KERNEL_ELF)
	$(OBJCOPY) -O binary $< $@


# Generic rule for compiling C files to object files
%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} $< -o $@

# Generic rule for assembling ASM files to object files
%.o: %.asm
	nasm $< -f elf32 -o $@

# Generic rule for assembling ASM files to raw binary
%.bin: %.asm
	nasm $< -f bin -o $@


# Run OS image using Qemu 
run: $(OS_IMAGE)
	qemu-system-i386 -fda $<

# Debug OS using Qemu and GDB
debug: $(OS_IMAGE) $(KERNEL_ELF)
	qemu-system-i386 -s -S -fda $(OS_IMAGE) &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file $(KERNEL_ELF)"

# Clean up generated files
clean:
	rm -rf *.o *.bin *.elf $(OS_IMAGE)
	rm -rf boot/*.o boot/*.bin boot/*.elf
	rm -rf kernel/*.o kernel/*.bin kernel/*.elf
	rm -rf drivers/*.o drivers/*.bin drivers/*.elf
