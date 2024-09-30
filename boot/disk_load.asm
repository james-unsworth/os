disk_load:
;    
    pusha
    push dx

    mov ah, 0x02        ; BIOS read sector function 
    mov al, dh          ; number of sectors to read
    mov ch, 0x00        ; cylinder no.
    mov dh, 0x00        ; head no.
    mov cl, 0x02        ; sector to start reading 

    int 0x13            

    jc disk_error       ; if carry error

    ; if sector numbers read error
    pop dx
    cmp al, dh          
    jne sectors_error
    popa
    ret


disk_error:
    mov bx, DISK_ERROR
    call print_16
    call print_nl_16

    ; ah = error code, dl = disk drive that dropped the error
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