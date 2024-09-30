void main() {
    // print to screen -- writes to VGA cell 
    char* video_memory = (char*) 0xb8000;
    *video_memory = 'X';

    while (1) {};
}

