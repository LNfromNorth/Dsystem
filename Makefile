
SCRIPTS=scripts

QEMU_DIR := qemu
QEMU_BUILD := $(QEMU_DIR)/build

LINUX_DIR := linux
LINUX_BUILD := $(LINUX_DIR)

BUSYBOX_DIR := busybox


QEMU_CONFIGURE_FLAGS := --target-list="x86_64-softmmu"
QEMU_CONFIGURE_FLAGS += --enable-debug
QEMU_CONFIGURE_FLAGS += --enable-system
QEMU_CONFIGURE_FLAGS += --disable-user

LINUX_DEFCONFIG := defconfig

BUSYBOX_DEFCONFIG := x86_64_bsybox_defconfig

GREEN  := \033[1;32m
BLUE   := \033[1;34m
YELLOW := \033[1;33m
RESET  := \033[0m

.PHONY: linux
linux:
	$(MAKE) -C $(LINUX_DIR) $(LINUX_DEFCONFIG)
	$(MAKE) -C $(LINUX_DIR) -j$$(nproc)


.PHONY: qemu
qemu:
	mkdir -p $(QEMU_BUILD)
	cd $(QEMU_BUILD) && ../configure $(QEMU_CONFIGURE_FLAGS)
	$(MAKE) -C $(QEMU_BUILD) -j$$(nproc)

.PHONY: busybox
busybox:
	cp $(SCRIPTS)/x86_64_busybox_defconfig busybox/.config
	$(MAKE) -C $(BUSYBOX_DIR) oldconfig
	$(MAKE) -C $(BUSYBOX_DIR) -j$$(nproc)

all: linux qemu busybox

.PHONY: clean
clean:
	$(MAKE) -C $(LINUX_DIR) clean || true
	rm -rf $(QEMU_BUILD)

include mkutils/run.mk
include mkutils/rootfs.mk
