ROOTFS_DIR      := rootfs
ROOTFS_IMAGE    := rootfs_image

BUSYBOX_INSTALL := $(BUSYBOX_DIR)/_install
OVERLAY_DIR     := overlay

IMAGE_SIZE      := 100

.PHONY: rootfs clean

DIRS_CREATED    := $(ROOTFS_DIR)/.dirs_created
BUSYBOX_COPIED  := $(ROOTFS_DIR)/.busybox_copied
OVERLAY_COPIED  := $(ROOTFS_DIR)/.overlay_copied
DEVNODES_MADE   := $(ROOTFS_DIR)/.devnodes_made


$(DIRS_CREATED):
	@mkdir -p $(ROOTFS_DIR)
	@mkdir -p $(ROOTFS_DIR)/bin $(ROOTFS_DIR)/sbin $(ROOTFS_DIR)/etc \
               $(ROOTFS_DIR)/proc $(ROOTFS_DIR)/sys $(ROOTFS_DIR)/usr \
               $(ROOTFS_DIR)/tmp $(ROOTFS_DIR)/dev $(ROOTFS_DIR)/lib \
               $(ROOTFS_DIR)/mnt
	@touch $(DIRS_CREATED)


$(BUSYBOX_COPIED): $(BUSYBOX_INSTALL) $(DIRS_CREATED)
	@cp -a $(BUSYBOX_INSTALL)/* $(ROOTFS_DIR)
	@touch $(BUSYBOX_COPIED)


$(OVERLAY_COPIED): $(OVERLAY_DIR) $(BUSYBOX_COPIED)
	@cp -a $(OVERLAY_DIR)/* $(ROOTFS_DIR)
	@touch $(OVERLAY_COPIED)


$(DEVNODES_MADE): $(OVERLAY_COPIED)
	@rm -rf $(ROOTFS_DIR)/dev/*
	@sudo mknod -m 600 $(ROOTFS_DIR)/dev/console c 5 1
	@sudo mknod -m 666 $(ROOTFS_DIR)/dev/null c 1 3
	@touch $(DEVNODES_MADE)


$(ROOTFS_IMAGE): $(DEVNODES_MADE)
	@dd if=/dev/zero of=$(ROOTFS_IMAGE) bs=1M count=$(IMAGE_SIZE) status=progress
	@echo "--> Formatting image as ext4..."
	@mkfs.ext4 -F $(ROOTFS_IMAGE)
	@echo "--> Mounting image and copying rootfs content..."
	@sudo mkdir -p /mnt/tmp_root
	@sudo mount $(ROOTFS_IMAGE) /mnt/tmp_root
	@sudo cp -a $(ROOTFS_DIR)/* /mnt/tmp_root
	@sudo umount /mnt/tmp_root
	@sudo rm -rf /mnt/tmp_root
	@echo "finish create of $(ROOTFS_IMAGE)"


rootfs: $(ROOTFS_IMAGE)
