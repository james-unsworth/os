#include "kernel.h"
#include "../cpu/isr.h"
#include "../drivers/screen.h"
#include "../libc/string.h"
#include "../libc/mem.h"
#include "../shell/shell.h"
#include "stdlib.h"

int kernel_main(void) {
    kprint("\n\n");
    isr_install();
    irq_install();
    u32 free_mem_addr = 0x10000;  // Ensure free_mem_addr is set to the correct value
    u32 allocated_memory = kmalloc(1048576, 1, NULL);

    kprint("Booting kernel...\n");
    shell();
}