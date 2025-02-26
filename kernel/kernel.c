/* kernel.c 
 * Simple kernel main function with setuo and shell */

#include "kernel.h"
#include "../cpu/isr.h"
#include "../drivers/screen.h"
#include "../libc/string.h"
#include "../libc/mem.h"
#include "../shell/shell.h"
#include "stdlib.h"

int kernel_main(void) {
    kprint("\n\n");
    
    kprint("Starting ISR install...\n");
    isr_install();

    kprint("Starting IRQ install...\n");
    irq_install();

    kprint("Memory allocation...\n");
    u32 free_mem_addr = 0x10000; 
    u32 allocated_memory = kmalloc(1048576, 1, NULL);

    kprint("Booting kernel...\n");
    shell();
}