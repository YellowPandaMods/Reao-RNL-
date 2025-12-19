#!/bin/bash


rm *.o *.so *.efi

# Compile boot.c into an object file
x86_64-linux-gnu-gcc -ffreestanding -fpic -fshort-wchar -fno-stack-protector \
  -maccumulate-outgoing-args \
  -I/usr/include/efi -I/usr/include/efi/x86_64 \
  -c boot.c -o boot.o

# Compile kernel.c into an object file
x86_64-linux-gnu-gcc -ffreestanding -fpic -fno-stack-protector \
  -c kernel.c -o kernel.o

# Link boot.o and kernel.o
ld -nostdlib -znocombreloc \
   -T /usr/lib/elf_x86_64_efi.lds \
   -shared -Bsymbolic \
   /usr/lib/crt0-efi-x86_64.o boot.o kernel.o \
   -L/usr/lib -lgnuefi -lefi \
   -o boot.so

# Convert to EFI
objcopy \
  -j .text -j .sdata -j .data -j .rodata \
  -j .dynamic -j .dynsym -j .rel -j .rela \
  -j .reloc \
  --target=efi-app-x86_64 \
  --subsystem=10 \
  boot.so boot.efi

# Create empty 20 MB FAT image to later use it
dd if=/dev/zero of=efiboot.img bs=1M count=20

# Format it as FAT32
mkfs.vfat efiboot.img

mkdir -p mnt
sudo mount -o loop efiboot.img mnt

# Create EFI/BOOT directories to later put the boot files and etc.
sudo mkdir -p mnt/EFI/BOOT

# Copy the boot.efi as the boot app (bootloader)
sudo cp boot.efi mnt/EFI/BOOT/BOOTX64.EFI

# Unmount the image 
sudo umount mnt
rmdir mnt

#					THE END


