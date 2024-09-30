[org 0x7c00] 

; set stack out of the way
mov bp, 0x9000    
mov sp, bp

; set kernel and boot drive variables
KERNEL_OFFSET equ 0x1000
mov [BOOT_DRIVE], dl

mov bx, MSG_REAL_MODE
call print_16
call print_nl_16

call load_kernel
call switch_to_pm

jmp $

%include "boot/16bit_print.asm"
%include "boot/switch_to_pm.asm"
%include "boot/gdt.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print_16
    call print_nl_16


    mov bx, KERNEL_OFFSET 
    mov dh, 2
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_32

    ; jump to kernel
    jmp CODE_SEG:KERNEL_OFFSET 
    jmp $   


%include "boot/32bit_print.asm"
%include "boot/disk_load.asm"

BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16-bit Real Mode." , 0
MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode." , 0
MSG_LOAD_KERNEL db "Loading kernel into memory..." , 0
ERROR db "Error", 0

times 510-($-$$) db 0
dw 0xAA55         ; Boot signature

