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

  render_image(screen, image, 4, 4, 25, 25);
}

void render_image(unsigned char *screen, unsigned char *image, int width, int height, int x, int y) {
  for (int iy = 0; iy < height; iy++) {
    for (int ix = 0; ix < width; ix++) {
      screen[(y+iy)*WIDTH + (x+ix)] = image[iy*width + ix];
    }
  }
}
