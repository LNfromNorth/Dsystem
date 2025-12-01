
QEMU	:= $(QEMU_DIR)/build/qemu-system-x86_64
ROOTFS 	:= rootfs_image

QEMU_ARGS = -machine pc
QEMU_ARGS += -smp 4
QEMU_ARGS += -m 4G
QEMU_ARGS += -kernel $(LINUX_DIR)/arch/x86/boot/bzImage
QEMU_ARGS += -nographic
QEMU_ARGS += -drive format=raw,file=rootfs_image
QEMU_ARGS += -append "root=/dev/sda console=ttyS0 init=/sbin/init"


run:
	$(QEMU) $(QEMU_ARGS)


dqemu:
	gdb --args $(QEMU) $(QEMU_ARGS)


dlinux:
	$(QEMU) $(QEMU_ARGS) -s -S
