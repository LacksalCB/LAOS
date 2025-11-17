CC=gcc
ASM=nasm
LD=ld

SRC_DIR = src
LOG_DIR = logs
BUILD_DIR = build
BIN_DIR = bin

CFLAGS= -m32 -ffreestanding -std=c11 -O2 -g -Wall -Wextra -Wno-return-type -Wno-unused-function -nostdlib

BOOTSECT_SOURCES= $(SRC_DIR)/bootloader/boot.asm

BOOTSECT_OBJECTS=$(BOOTSECT_SOURCES:.asm=.o)

KERNEL_ASM_SOURCES:=$(wildcard $(SRC_DIR)/kernel/*.asm)
KERNEL_C_SOURCES:=$(wildcard $(SRC_DIR)/kernel/*.c)
KERNEL_OBJECTS:=$(KERNEL_ASM_SOURCES:.asm=.o) $(KERNEL_C_SOURCES:.c=.o) 

BOOTSECT=$(BIN_DIR)/bootsect.bin
KERNEL=$(BIN_DIR)/kernel.bin
IMG=boot.img

LDFLAGS_BOOTSECT = -m elf_i386 -T $(SRC_DIR)/bootloader/link.ld -nostdlib
LDFLAGS_KERNEL = -m elf_i386 -T $(SRC_DIR)/kernel/link.ld -nostdlib

.PHONY: all clean 

all: dirs $(IMG)

dirs:
	mkdir -p bin

clean:
	-rm $(SRC_DIR)/**/*.o
	-rm $(BIN_DIR)/*.bin
	-rm $(LOG_DIR)/*.txt
	-rm *.img

%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS)

%.o: %.asm
	$(ASM) -f elf32 -o $@ $<

$(BOOTSECT): $(BOOTSECT_SOURCES)
	$(ASM) -f bin -o $(BOOTSECT) $< 
	objdump -D -b binary -mi386 -Maddr16,data16 $(BOOTSECT) >> $(LOG_DIR)/boot.txt

$(KERNEL): $(KERNEL_OBJECTS)
	$(LD) $(LDFLAGS_KERNEL) -o $(BUILD_DIR)/kernel.elf $^
	objcopy -O binary $(BUILD_DIR)/kernel.elf $(KERNEL)

$(IMG): $(BOOTSECT) $(KERNEL)
	dd if=/dev/zero of=$(IMG) bs=512 count=2880
	dd if=$(BOOTSECT) of=$(IMG) conv=notrunc seek=0 count=1
	dd if=$(KERNEL) of=$(IMG) conv=notrunc seek=$$((0x10000)) bs=1 
	objdump -D -b binary -mi386 -Maddr16,data16 $(IMG) >> $(LOG_DIR)/img.txt

run: 
	qemu-system-i386 -drive format=raw,file=boot.img -monitor stdio
	
	#qemu-system-i386 -drive format=raw,file=boot.img
