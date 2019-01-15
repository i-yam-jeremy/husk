#define WIDTH 320
#define HEIGHT 200

unsigned char render_pixel(int x, int y);

void main() {
  unsigned char *screen = (unsigned char *) 0xA0000;

  for (int y = 0; y < HEIGHT; y++) {
    for (int x = 0; x < WIDTH; x++) {
      screen[y*WIDTH + x] = render_pixel(x, y);
    }
  }
}

unsigned char render_pixel(int x, int y) {
  int u = x - WIDTH/2;
  int v = y - HEIGHT/2;

  int radius = 20;

  if (u*u + v*v < radius*radius) {
    return 0x0F;
  }
  else {
    return 0x00;
  }
}
