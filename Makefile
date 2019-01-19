NASM=/usr/local/bin/nasm
CC=gcc
OBJCOPY=objcopy

TARGET=husk.raw

$(TARGET) : src/bootloader/bootloader.bin src/kernel/kernel.bin
	cat src/bootloader/bootloader.bin src/kernel/kernel.bin > $(TARGET)

run: $(TARGET)
	qemu-system-i386 $(TARGET)

src/kernel/kernel.bin: src/kernel/kernel.o src/kernel/port_io.o
		ld -r $^ -o src/kernel/full_kernel.o
		$(OBJCOPY) -O binary --change-start 0x1000 --pad-to 0x4000 src/kernel/full_kernel.o src/kernel/kernel.bin

src/kernel/%.o: src/kernel/%.c
	$(CC) -ffreestanding -m32 -c -o $@ $<

src/bootloader/bootloader.bin: src/bootloader/bootloader.asm
	$(NASM) -O0 -f bin -o src/bootloader/bootloader.bin src/bootloader/bootloader.asm
