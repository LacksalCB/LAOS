CC=gcc
ASM=nasm
LD=ld

SRC_DIR = src
LOG_DIR = logs
BUILD_DIR = build
BIN_DIR = bin

CFLAGS=-std=c11 -O2 -g -Wall -Wextra -Wno-return-type -Wno-unused-function -nostdlib

BOOTSECT_SOURCES= $(SRC_DIR)/bootloader/boot.asm

BOOTSECT_OBJECTS=$(BOOTSECT_SOURCES:.asm=.o)

KERNEL_C_SOURCES=$(wildcard $(SRC_DIR)/kernel/*.c)
KERNEL_OBJECTS=$(KERNEL_C_SOURCES:.c=.o)

BOOTSECT=$(BIN_DIR)/bootsect.bin
KERNEL=$(BIN_DIR)/kernel.bin
IMG=boot.img

LDFLAGS_BOOTSECT = -m elf_i386 -T $(SRC_DIR)/bootloader/link.ld -nostdlib
LDFLAGS_KERNEL = -T $(SRC_DIR)/kernel/link.ld -nostdlib

.PHONY: all clean 

all: dirs $(IMG)

dirs:
	mkdir -p bin

clean:
	-rm $(SRC_DIR)//**/*.o
	-rm $(BIN_DIR)/*.bin
	-rm *.img
	-rm $(LOGS_DIR)/*.txt

%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS)

$(BOOTSECT): $(BOOTSECT_SOURCES)
	$(ASM) -f bin -o $(BOOTSECT) $< 
	objdump -D -b binary -mi386 -Maddr16,data16 $(BOOTSECT) >> $(LOG_DIR)/boot.txt

$(KERNEL): $(KERNEL_OBJECTS)
	$(LD) $(LDFLAGS_KERNEL) -o $(KERNEL) $^

$(IMG): $(BOOTSECT) $(KERNEL)
	dd if=/dev/zero of=$(IMG) bs=512 count=2880
	dd if=$(BOOTSECT) of=$(IMG) conv=notrunc seek=0 count=1
	dd if=$(KERNEL) of=$(IMG) conv=notrunc seek=1 count=512
	objdump -D -b binary -mi386 -Maddr16,data16 $(IMG) >> $(LOG_DIR)/img.txt

run: 
	qemu-system-i386 -drive format=raw,file=boot.img -monitor stdio
	
	#qemu-system-i386 -drive format=raw,file=boot.img
