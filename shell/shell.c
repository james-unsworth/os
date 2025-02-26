/* shell.c 
 * Shell/command table initialisation and command loop */

#include "../drivers/keyboard.h"   
#include "../drivers/screen.h"     
#include "shell.h"                  
#include "../commands/commands.h"

void shell() {
    initialise_command_table();
    char input[256]; 
    while (1) {
        kprint("> ");           
        read_input(input);     
        execute_command(input); 
    }
}

void read_input(char *buffer) {
    int index = 0;
    char key;

    while (1) {
        key = get_key();  

        if (key == '\n') {  
            buffer[index] = '\0'; 
            return;
        } else if (key == '\b' && index > 0) {  
            index--;  
        } else if (key >= ' ' && index < 255) {  
            buffer[index++] = key;  
            print_char(key, -1, -1, 0);  
        }
    }
}