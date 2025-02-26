/* commmands.c
 * Initialise and populate command table */

#include "commands.h"
#include "../kernel/kernel.h"
#include "../libc/mem.h"
#include "../libc/string.h"
#include "../drivers/screen.h"
#include "../cpu/types.h"
#include <stdio.h>
#include <stdlib.h>

command_t *commands;  
u32 num_commands;     

int initialise_command_table() {
    u32 phys_addr;
    num_commands = 3;

    u32 table_size = sizeof(command_t) * num_commands;

    commands = (command_t *) kmalloc(table_size, 1, &phys_addr);  

    if (commands == NULL) {
        kprint("Memory allocation failed!\n");
        return -1;
    }

    commands[0].name = "QUIT";
    commands[0].func = quit_command;

    commands[1].name = "CLEAR";
    commands[1].func = clear_command;

    commands[2].name = "PAGE";
    commands[2].func = page_command;

    return 0;
}

void execute_command(char *input) {
    trim(input);

    for (int i = 0; i < num_commands; i++) {
        if (strcmp(input, commands[i].name) == 0) {
            commands[i].func();  
            return;
        }
    }
    unknown_command(input); 
}

void quit_command() {
    kprint("Stopping the CPU. Bye!\n");
    asm volatile("hlt"); 
}

void clear_command() {
    clear_screen();
}

void page_command() {
    u32 phys_addr;
    u32 page = kmalloc(1000, 1, &phys_addr);  
    char page_str[16] = "";
    hex_to_ascii(page, page_str); 
    char phys_str[16] = "";
    hex_to_ascii(phys_addr, phys_str); 

    kprint("Page: ");
    kprint(page_str);
    kprint(", physical address: ");
    kprint(phys_str);
    kprint("\n");
}

void echo_command(char *input) {
    kprint(input);
}

void unknown_command(char *input) {
    kprint("\n");
    kprint("Unknown command: ");
    kprint(input);
    kprint("\n");
}

/* Trim whitespace */
void trim(char *str) {
    int index = 0;
    int i;

    while (str[index] == ' ' || str[index] == '\n' || str[index] == '\r') {
        index++;
    }

    if (index > 0) {
        i = 0;
        while (str[i + index]) {
            str[i] = str[i + index];  
            i++;
        }
        str[i] = '\0';  
    }

    i = strlen(str) - 1;
    while (i >= 0 && (str[i] == ' ' || str[i] == '\n' || str[i] == '\r')) {
        str[i] = '\0';  
        i--;
    }
}

