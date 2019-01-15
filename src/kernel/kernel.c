#define WIDTH 320
#define HEIGHT 200

void render_image(unsigned char *screen, unsigned char *image, int width, int height, int x, int y);

void main() {
  unsigned char *screen = (unsigned char *) 0xA0000;

  unsigned char image[] = {
    0x0F, 0x0F, 0x0F, 0x0F,
    0x0F, 0x00, 0x00, 0x0F,
    0x0F, 0x00, 0x00, 0x0F,
    0x0F, 0x0F, 0x0F, 0x0F,
  };

  for (int y = 0; y < 10; y++) {
    for (int x = 0; x < 10; x++) {
      render_image(screen, image, 4, 4, -2 + 6*x, -2 + 6*y);
    }
  }
}

void render_image(unsigned char *screen, unsigned char *image, int width, int height, int x, int y) {
  for (int iy = 0; iy < height; iy++) { // iy = iterator y
    for (int ix = 0; ix < width; ix++) { // ix = iterator x
      int sx = x+ix; // sx = screen x
      int sy = y+iy; // sy = screen y
      if (0 <= sx && sx < WIDTH && 0 <= sy && sy < HEIGHT) {
        screen[sy*WIDTH + sx] = image[iy*width + ix];
      }
    }
  }
}
