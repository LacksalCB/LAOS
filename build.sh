# 1) show the source file timestamp and top of file so we confirm the file you edited is the one being assembled
ls -l src/bootloader/boot.asm
sed -n '1,120p' src/bootloader/boot.asm

# 2) force-assemble the boot sector (run nasm directly so we see any errors)
nasm -f bin -o bin/bootsect.bin src/bootloader/boot.asm
echo "nasm exit: $?"

# 3) confirm new timestamps & size
ls -l bin/bootsect.bin

# 4) show the 6 bytes for the GDT descriptor location that we expect to be changed
xxd -g1 -s 0xCC -l 6 bin/bootsect.bin

# 5) show a larger dump (optional) so I can eyeball surrounding fields
xxd -g1 -s 0xC0 -l 64 bin/bootsect.bin | sed -n '1,40p'
