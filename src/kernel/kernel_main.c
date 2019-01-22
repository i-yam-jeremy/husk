#include "port_io.h"

#define WIDTH 320
#define HEIGHT 200

void render_1bit_image(unsigned char *screen, unsigned char *image, int width, int height, int x, int y, unsigned char color);

unsigned char font[] = {

  0, 1, 1, 0,
  1, 0, 0, 1,
  1, 0, 0, 1,
  1, 0, 0, 1,
  0, 1, 1, 0,


  0, 1, 1, 0,
  0, 0, 1, 0,
  0, 0, 1, 0,
  0, 0, 1, 0,
  0, 1, 1, 1,


  0, 1, 1, 0,
  0, 0, 1, 0,
  0, 1, 0, 0,
  0, 1, 0, 0,
  0, 1, 1, 0,


  0, 1, 1, 0,
  0, 0, 1, 0,
  0, 1, 1, 0,
  0, 0, 1, 0,
  0, 1, 1, 0,


  1, 0, 1, 0,
  1, 0, 1, 0,
  1, 1, 1, 1,
  0, 0, 1, 0,
  0, 0, 1, 0,


  0, 1, 1, 0,
  0, 1, 0, 0,
  0, 0, 1, 0,
  0, 0, 1, 0,
  0, 1, 1, 0,


  0, 0, 1, 0,
  0, 1, 0, 0,
  0, 1, 1, 0,
  0, 1, 0, 1,
  0, 0, 1, 0,


  0, 1, 1, 1,
  0, 0, 0, 1,
  0, 0, 1, 0,
  0, 0, 1, 0,
  0, 1, 0, 0,


  0, 1, 1, 0,
  1, 0, 0, 1,
  0, 1, 1, 0,
  1, 0, 0, 1,
  0, 1, 1, 0,


  0, 1, 1, 1,
  0, 1, 0, 1,
  0, 1, 1, 1,
  0, 0, 0, 1,
  0, 1, 1, 0
};

int abs(int n) {
  return (n >= 0) ? n : -n;
}

// frequency is 1/frequency
int wave(int frequency, int amplitude, int t) {
  int loc = (t % frequency) - frequency/2;
  return abs(2*amplitude/frequency*loc);
}

/*int int_sqrt(int n) {

}

int sphere_sdf(int x, int y, int z, int radius) {
  return int_sqrt(x*x + y*y + z*z) - radius;
}*/

void init_fpu() {
  unsigned int cr4;

  // place CR4 into our variable
  __asm__ __volatile__("mov %%cr4, %0;" : "=r" (cr4));

  // set the OSFXSR bit
  cr4 |= 0x200;

  // reload CR4
  __asm__ __volatile__("mov %0, %%cr4;" : : "r"(cr4));

    // INIT the FPU (FINIT)
  __asm__ __volatile__("finit;");

  int cw = 0;

  // FLDCW = Load FPU Control Word
  asm volatile("fldcw %0;    "
               ::"m"(cw));     // sets the FPU control word to "cw"
}

void kernel_main() {
  init_fpu();

  float x = 1.0;

  unsigned char *screen = (unsigned char *) 0xFD000000;

  int frame = 0;
  while (1) {
    int cx = 1024/2 + wave(25, 25, frame), cy = 768/2 + wave(50, 25, frame);
    int radius = 50;
    for (int y = 0; y < 768; y++) {
      for (int x = 0; x < 1024; x++) {
        int i = 3*(y*1024 + x);
        if ((x-cx)*(x-cx) + (y-cy)*(y-cy) < radius*radius) {
          screen[i+2] = 0;
          screen[i+1] = 255;
          screen[i+0] = 0;
        }
        else {
          screen[i+2] = 0;
          screen[i+1] = 0;
          screen[i+0] = 0;
        }
      }
    }
    frame++;
  }
}

void render_1bit_image(unsigned char *screen, unsigned char *image, int width, int height, int x, int y, unsigned char color) {
  for (int iy = 0; iy < height; iy++) { // iy = iterator y
    for (int ix = 0; ix < width; ix++) { // ix = iterator x
      int sx = x+ix; // sx = screen x
      int sy = y+iy; // sy = screen y
      if (0 <= sx && sx < WIDTH && 0 <= sy && sy < HEIGHT) {
        screen[sy*WIDTH + sx] = ((image[iy*width + ix] == 1) ? color : 0x00);
      }
    }
  }
}
