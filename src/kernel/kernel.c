#define WIDTH 320
#define HEIGHT 200

unsigned  char  port_byte_in(unsigned  short  port);
void  port_byte_out(unsigned  short  port , unsigned  char  data);

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

void main() {
  unsigned char *screen = (unsigned char *) 0xA0000;


  while (1) {
    port_byte_out(0x61, 1 << 1);
    unsigned char b = port_byte_in(0x60);// | port_byte_in(0x61) | port_byte_in(0x62) | port_byte_in(0x63) | port_byte_in(0x64);

    if (1 <= b && b <= 10) {
      render_1bit_image(screen, &(font[20*(b-1)]), 4, 5, 25, 25, 0x0F);
    }
    else {
      for (int y = 0; y < HEIGHT; y++) {
        for (int x = 0; x < WIDTH; x++) {
          screen[y*WIDTH + x] = 0x00;
        }
      }
    }
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

unsigned  char  port_byte_in(unsigned  short  port) {
  // A handy C wrapper  function  that  reads a byte  from  the  specified  port
  //   "=a" (result) means: put AL  register  in  variable  RESULT  when  finished
  //   "d" (port) means: load  EDX  with  port
  unsigned  char  result;
  __asm__("in %%dx, %%al" : "=a" (result) : "d" (port ));
  return  result;
}
void  port_byte_out(unsigned  short  port , unsigned  char  data) {
  // "a" (data) means: load  EAX  with  data
  // "d" (port) means: load  EDX  with  port
  __asm__("out %%al, %%dx" : :"a" (data), "d" (port ));
}
unsigned  short  port_word_in(unsigned  short  port) {
  unsigned  short  result;
  __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port ));
  return  result;
}
void  port_word_out(unsigned  short  port , unsigned  short  data) {
  __asm__("out %%ax, %%dx" : :"a" (data), "d" (port ));
}
