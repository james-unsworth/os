#ifndef MEM_H
#define MEM_H

#include "../cpu/types.h"

void memory_copy(char *source, char *dest, int nbytes);
void memory_set(u8 *dest, u8 val, u32 len);
u32 kmalloc(u32 size, int align, u32 *phys_addr);

#endif