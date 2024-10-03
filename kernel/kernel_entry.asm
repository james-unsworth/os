section .text
global _start        

; Allow main function in kernel.c to be called
extern kernel_main          

; Hand control to kernel
_start:
    call kernel_main      
    hlt              
    jmp $