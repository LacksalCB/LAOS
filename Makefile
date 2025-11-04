CC=gcc
ASM=as
LD=ld

CFLAGS=-std=c11 -O2 -g -Wall -Wextra -Wno-return-type -Wno-unused-function -nostdlib

BOOTSECT_SOURCES=\
	src/bootloader/boot.S

BOOTSECT_OBJECTS=$(BOOTSECT_SOURCES:.S=.o)

KERNEL_C_SOURCES=$(wildcard src/kernel/*.c)
KERNEL_OBJECTS=$(KERNEL_C_SOURCES:.c=.o)

BOOTSECT=bootsect.bin
KERNEL=kernel.bin
IMG=boot.img

LDFLAGS_BOOTSECT = -m elf_i386 -T src/bootloader/link.ld -nostdlib
LDFLAGS_KERNEL = -T src/kernel/link.ld -nostdlib

.PHONY: all clean 

all: dirs $(KERNEL) $(BOOTSECT) $(IMG)

dirs:
	mkdir -p bin

clean:
	-rm ./**//**/*.o
	-rm ./**/*.bin
	-rm ./*.img

%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS)

%.o: %.S
	$(ASM) --32 -o $@ $<  

$(BOOTSECT): $(BOOTSECT_OBJECTS)
	$(LD) $(LDFLAGS_BOOTSECT) -o ./bin/$@ $^ 

$(KERNEL): $(KERNEL_OBJECTS)
	$(LD) $(LDFLAGS_KERNEL) -o ./bin/$@ $^

$(IMG): $(BOOTSECT) $(KERNEL)
	dd if=/dev/zero of=boot.img bs=512 count=2880
	dd if=./bin/$(BOOTSECT) of=$(IMG) conv=notrunc seek=0 count=1
	dd if=./bin/$(KERNEL) of=$(IMG) conv=notrunc seek=1 count=2048

run: 
	qemu-system-i386 -drive format=raw,file=boot.img -monitor stdio
	
	#qemu-system-i386 -drive format=raw,file=boot.img
