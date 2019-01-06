BUILD_DIR=bin
TARGET=$(BUILD_DIR)/self-alchemy.flp

all : $(TARGET)

$(TARGET) : src/bootloader.asm
	mkdir -p $(BUILD_DIR)
	nasm -f bin -o bin/self-alchemy.bin src/bootloader.asm
	dd conv=notrunc if=bin/self-alchemy.bin of=$(TARGET)

run : $(TARGET)
	qemu-system-i386 -fda $(TARGET)
