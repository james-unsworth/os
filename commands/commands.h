#ifndef COMMANDS_H
#define COMMANDS_H

typedef void (*command_func_t)();

typedef struct {
    char *name;
    void (*func)();
} command_t;

int initialise_command_table();
void quit_command();
void clear_command();
void echo_command(char *input);
void page_command();
void execute_command(char *input);
void unknown_command(char *input);
void trim(char *str);


#endif