#ifndef KEYBOARD_H
#define KEYBOARD_H

#include "../cpu/isr.h"
#include "../cpu/types.h"
#include "../cpu/ports.h"

void init_keyboard();
void print_letter(u8 scancode);
char get_key();
static void keyboard_callback(registers_t regs);

#endif