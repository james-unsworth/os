; kernel_entry.asm
; Entry point at 0x1000, jumps to C kernel

section .text
global _start        

extern kernel_main          

_start:
    call kernel_main      
    hlt              
    jmp $