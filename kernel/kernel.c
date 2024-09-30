
// read byte from port
unsigned char port_byte_in (unsigned char port) {
    unsigned char result;
    // read result from port (dx) and store in al
    __asm__( "in %%dx, %%al" : "=a" (result) : "d" (port) );
    return result;
}

// write byte to port
void port_byte_out (unsigned char port, unsigned char data) {
    __asm__( "out %%al, %%dx" : :"a" (data), "d" (port) );
}

// read word from port
unsigned short port_word_in(unsigned short port) {
    unsigned short result;
    __asm__( "in %%dx, $$ax" : "=a" (result) : "d" (port) );
}

// write word to port
void port_word_out(unsigned short port, unsigned short data) {
    __asm__( "out %%ax, %%dx" : : "a" (data), "d" (port) );
}

void main() {
    // print to screen -- writes to VGA cell 
    char* video_memory = (char*) 0xb8000;
    *video_memory = 'X';

    while (1) {};
}

