// Contants from writing to VGA
#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
#define WHITE_ON_BLACK 0x0f

// Screen device I/O ports
# define REG_SCREEN_CTRL 0x3D4
# define REG_SCREEN_DATA 0x3D5

void print_char(char character, int col, int row, char attribute_byte) {
    unsigned char *vid_mem = (unsigned char*) VIDEO_ADDRESS;

    // If attribute byte not set, assume default style
    if (! attribute_byte ) {
        attribute_byte = WHITE_ON_BLACK ;
    }

    // Get video memory offset for on screen location 
    // - To use cursor position as offset, pass negative row and col values
    int offset;
    if (col >= 0 && row >= 0) {
        offset = get_screen_offset(col, row);
    }
    else {
        offset = get_cursor();
    }

    // 
    if (character == '\n') {
        int rows = offset / (2*MAX_COLS);
        offset = get_screen_offset (79, rows);
    }


}