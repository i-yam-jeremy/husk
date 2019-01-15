#define WIDTH 320
#define HEIGHT 200

void set_pixel(unsigned char *screen, int x, int y, unsigned char color);

int screen_x = 5;
int screen_y = 2;

void main() {
  unsigned char *screen = (unsigned char *) 0xA0000;

  screen[screen_y*320 + screen_x] = 0x0F;
}

void set_pixel(unsigned char *screen, int x, int y, unsigned char color) {
  screen[y*WIDTH + x] = color;
}
