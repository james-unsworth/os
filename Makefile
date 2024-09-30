# cross-compiler, assembler, linker
CC = i386-elf-gcc
AS = nasm
LD = i386-elf-ld
OBJCOPY = i386-elf-objcopy
GDB = gdb

# flags
CFLAGS = -ffreestanding -c -g
LDFLAGS = -Ttext 0x1000

# source files
BOOTLOADER_SRC = boot/boot_sect.asm
KERNEL_SRC = kernel/kernel.c
KERNEL_ENTRY_SRC = kernel/kernel_entry.asm 

# object files
BOOTLOADER_OBJ = boot/boot_sect.bin
KERNEL_OBJ = kernel/kernel.o
KERNEL_ELF = kernel/kernel.elf
KERNEL_BIN = kernel/kernel.bin
KERNEL_ENTRY_OBJ = kernel/kernel_entry.o 

OS_IMAGE = os-image.bin



all: $(OS_IMAGE)

# build OS image 
$(OS_IMAGE) : $(BOOTLOADER_OBJ) $(KERNEL_BIN)
	cat $(BOOTLOADER_OBJ) $(KERNEL_BIN) > $(OS_IMAGE)

# compile bootloader
$(BOOTLOADER_OBJ) : $(BOOTLOADER_SRC)
	$(AS) -f bin -o $(BOOTLOADER_OBJ) $(BOOTLOADER_SRC)

# assemble kernel entry point
$(KERNEL_ENTRY_OBJ): $(KERNEL_ENTRY_SRC)
	$(AS) -f elf32 -o $(KERNEL_ENTRY_OBJ) $(KERNEL_ENTRY_SRC)

# link kernel --> elf 
$(KERNEL_ELF): $(KERNEL_ENTRY_OBJ) $(KERNEL_OBJ)
	$(LD) $(LDFLAGS) -o $(KERNEL_ELF) $(KERNEL_ENTRY_OBJ) $(KERNEL_OBJ) 


# kernel elf --> raw binary
$(KERNEL_BIN): $(KERNEL_ELF)
	$(OBJCOPY) -O binary $(KERNEL_ELF) $(KERNEL_BIN)

run: $(OS_IMAGE)
	qemu-system-i386 -fda $(OS_IMAGE)

debug: $(OS_IMAGE) $(KERNEL_ELF)
	qemu-system-i386 -s -S -fda $(OS_IMAGE) &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file $(KERNEL_ELF)"

clean:
	rm -rf *.o *.bin *.elf $(OS_IMAGE)
	cd ./boot && rm -rf *.o *.bin *.elf $(OS_IMAGE)
	cd ./kernel && rm -rf *.o *.bin *.elf $(OS_IMAGE)
