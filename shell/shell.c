#include "../drivers/keyboard.h"    // For get_key()
#include "../drivers/screen.h"      // For print_char(), kprint(), and cursor management functions
#include "shell.h"                  // For shell-related declarations
#include "../commands/commands.h"

void shell() {
    initialise_command_table();
    char input[256];  // Buffer for user input
    while (1) {
        kprint("> ");           // Display shell prompt
        read_input(input);      // Read user input
        execute_command(input); // Call command execution function
    }
}

void read_input(char *buffer) {
    int index = 0;
    char key;

    while (1) {
        key = get_key();  // Fetch the next key press from the keyboard

        if (key == '\n') {  // Enter key pressed
            buffer[index] = '\0';  // Null-terminate the string 
            return;
        } else if (key == '\b' && index > 0) {  // Handle backspace
            index--;  // Move the buffer index back
        } else if (key >= ' ' && index < 255) {  // Printable characters (ASCII >= 32)
            buffer[index++] = key;  // Add key to buffer
            print_char(key, -1, -1, 0);  // Print character at the current cursor position
        }
    }
}