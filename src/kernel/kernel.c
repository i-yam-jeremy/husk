#define WIDTH 320
#define HEIGHT 200

void set_pixel(unsigned char *screen, int x, int y, unsigned char color);

void main() {
  unsigned char *screen = (unsigned char *) 0xA0000;

  for (int y = 0; y < HEIGHT; y++) {
    for (int x = 0; x < WIDTH; x++) {
      screen[y*WIDTH + x] = 0x0F;
    }
  }
}

void set_pixel(unsigned char *screen, int x, int y, unsigned char color) {
  screen[y*WIDTH + x] = color;
}
