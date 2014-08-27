CPU := arm926ej-s
CROSSCOMPILE := arm-none-eabi-
AS := $(CROSSCOMPILE)as
CC := $(CROSSCOMPILE)gcc
LD := $(CROSSCOMPILE)ld
OBJCOPY := $(CROSSCOMPILE)objcopy
QEMU := qemu-system-arm
MACHINE := versatilepb
MEMORY := 128M

all: test.bin

startup.o: startup.s
	@echo AS $@
	@$(AS) -mcpu=$(CPU) -g $< -o $@

test.o: test.c
	@echo CC $@
	@$(CC) -mcpu=$(CPU) -g -c $< -o $@

test.elf: test.ld test.o startup.o
	@echo LD $@
	@$(LD) -T $^ -o $@

test.bin: test.elf
	@echo OBJCOPY $@
	@$(OBJCOPY) -O binary $< $@

run: test.bin
	@echo QEMU $<
	@$(QEMU) -M $(MACHINE) -m $(MEMORY) -nographic -kernel $<

clean:
	rm -f *.bin *.elf *.o

help:
	@echo ===================================================
	@echo "make - build the test binary"
	@echo ""
	@echo "make clean - clean the build"
	@echo "make run - run the test. Hit CTRL-a x to exit QEMU"
	@echo ===================================================
