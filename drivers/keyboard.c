#include "keyboard.h"
#include "../cpu/ports.h"
#include "../cpu/isr.h"
#include "screen.h"
#include "../libc/string.h"
#include "../libc/function.h"
#include "../kernel/kernel.h"

#define BACKSPACE 0x0E
#define ENTER 0x1C

static char key_buffer[256];  // Buffer to store the input line
static int key_ready = 0;     // Flag to indicate if a new key has been captured

#define SC_MAX 57
const char *sc_name[] = { "ERROR", "Esc", "1", "2", "3", "4", "5", "6", 
    "7", "8", "9", "0", "-", "=", "Backspace", "Tab", "Q", "W", "E", 
        "R", "T", "Y", "U", "I", "O", "P", "[", "]", "Enter", "Lctrl", 
        "A", "S", "D", "F", "G", "H", "J", "K", "L", ";", "'", "", 
        "LShift", "\\", "Z", "X", "C", "V", "B", "N", "M", ",", ".", 
        "/", "RShift", "Keypad *", "LAlt", "Spacebar"};
const char sc_ascii[] = { '?', '?', '1', '2', '3', '4', '5', '6',     
    '7', '8', '9', '0', '-', '=', '\b', '?', 'Q', 'W', 'E', 'R', 'T', 'Y', 
        'U', 'I', 'O', 'P', '[', ']', '\n', '?', 'A', 'S', 'D', 'F', 'G', 
        'H', 'J', 'K', 'L', ';', '\'', ' ', '?', '\\', 'Z', 'X', 'C', 'V', 
        'B', 'N', 'M', ',', '.', '/', '?', '?', '?', ' '};

static void keyboard_callback(registers_t regs) {
    u8 scancode = port_byte_in(0x60);

    if (scancode > SC_MAX) return;  // Ignore unsupported keys
    
    if (scancode == BACKSPACE) {
        backspace(key_buffer);
        kprint_backspace();
        append(key_buffer, '\b');
        key_ready = 1;
    } else if (scancode == ENTER) {
        key_buffer[0] = '\0';  // Clear the buffer after Enter
         kprint("\n");
         append(key_buffer, '\n');
         key_ready = 1;
    } else {
        char letter = sc_ascii[(int)scancode];
        char str[2] = {letter, '\0'};
        append(key_buffer, letter);
        key_ready = 1;  // Set the flag indicating a key is ready
    }

    UNUSED(regs);
}

void init_keyboard() {
    register_interrupt_handler(IRQ1, keyboard_callback); 
}

char get_key() {
    // Wait for a new key to be ready
    while (!key_ready) {
        // Wait until key is captured in keyboard_callback
    }
    key_ready = 0;  // Reset the flag for next key press
    return key_buffer[strlen(key_buffer) - 1];  // Return the last character entered
}