section .text
global _start        

; Allow main function in kernel.c to be called
extern main          

; Hand control to kernel
_start:
    call main      
    hlt              
    jmp $