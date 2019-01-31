NASM=/usr/local/bin/nasm
CC=gcc
OBJCOPY=objcopy

TARGET=husk.raw
TARGET_ISO=husk.iso

VBOX_VM_NAME=Husk
VBOX_VM_HD=husk.vdi

$(TARGET) : src/bootloader/bootloader.bin src/kernel/kernel.bin
	cat src/bootloader/bootloader.bin src/kernel/kernel.bin > $(TARGET)

run: $(TARGET_ISO)
	VBoxManage unregistervm $(VBOX_VM_NAME) --delete
	rm -f $(VBOX_VM_HD)
	#VBoxManage createhd --filename $(VBOX_VM_HD) --size 2
	VBoxManage createvm --name $(VBOX_VM_NAME) --ostype "Other" --register
	VBoxManage storagectl $(VBOX_VM_NAME) --name "SATA Controller" --add sata --controller IntelAHCI
	#VBoxManage storageattach $(VBOX_VM_NAME) --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $(VBOX_VM_HD)
	VBoxManage storagectl $(VBOX_VM_NAME) --name "IDE Controller" --add ide
	VBoxManage storageattach $(VBOX_VM_NAME) --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium $(TARGET_ISO)
	VBoxManage modifyvm $(VBOX_VM_NAME) --ioapic on
	VBoxManage modifyvm $(VBOX_VM_NAME) --boot1 dvd --boot2 disk --boot3 none --boot4 none
	VBoxManage modifyvm $(VBOX_VM_NAME) --memory 1024 --vram 128
	#VBoxManage modifyvm $(VBOX_VM_NAME) --nic1 bridged --bridgeadapter1 e1000g0
	VBoxManage startvm $(VBOX_VM_NAME) --type gui
	#qemu-system-i386 -drive format=raw,file=$(TARGET)

iso: $(TARGET_ISO)
$(TARGET_ISO): $(TARGET)
	dd if=/dev/zero of=husk.flp bs=1024 count=1440
	dd if=husk.raw of=husk.flp seek=0 count=38 conv=notrunc
	mkdir -p iso
	cp husk.flp iso/
	mkisofs -quiet -V 'HUSK' -input-charset iso8859-1 -o husk.iso -b husk.flp -hide husk.flp iso/

src/kernel/kernel.bin: src/kernel/*.c src/kernel/vesa.bin
		$(CC) -ffreestanding -m32 -c -o src/kernel/kernel.o src/kernel/kernel.c
		$(OBJCOPY) -O binary --change-start 0x1000 --pad-to 0x4000 src/kernel/kernel.o src/kernel/non_vesa_kernel.bin
		cat src/kernel/non_vesa_kernel.bin src/kernel/vesa.bin > src/kernel/kernel.bin

src/kernel/vesa.bin: src/kernel/vesa.asm
	$(NASM) -O0 -f bin -o src/kernel/vesa.bin src/kernel/vesa.asm

src/bootloader/bootloader.bin: src/bootloader/*.asm
	$(NASM) -O0 -f bin -o src/bootloader/bootloader.bin src/bootloader/bootloader.asm
