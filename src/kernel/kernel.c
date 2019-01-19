#include "kernel_main.h"

void kernel_start() {
  kernel_main();
}

#include "kernel_main.c"
#include "port_io.c"
