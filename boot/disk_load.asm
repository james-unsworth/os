; disk_load.asm
; Load sectors from disk using BIOS

READ_SECTORS equ 0x13

; Load [dh] sctors from drive [dl] into [es:bx]
disk_load:
    pusha
    push dx

    mov ah, 0x02        ; BIOS read sector 
    mov al, dh          
    mov ch, 0x00        ; Low 8 bits of cylinder no.
    mov dh, 0x00        ; Head no.
    mov cl, 0x02        ; Sector no. 

    int READ_SECTORS            

    jc disk_error       

    pop dx
    cmp al, dh          
    jne sectors_error
    popa
    ret


disk_error:
    mov bx, DISK_ERROR
    call print_16
    call print_nl_16

    ; ah = error code
    mov dh, ah     
    call print_hex 
    jmp disk_loop

sectors_error:
    mov bx, SECTORS_ERROR
    call print_16
    jmp disk_loop

disk_loop:
    jmp $

DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0