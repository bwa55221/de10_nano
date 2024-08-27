DRV_NAME		= msgdma

# KERNEL_SRC		=linux # TODO : modify path
KERNEL_SRC		=/home/brandon/work/de10_nano/linux/build/linux-socfpga
ARCH			=arm
# CROSS_COMPILE		=arm-linux-gnueabihf-
CROSS_COMPILE 	=/home/brandon/work/de10_nano/linux/build/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-

obj-m			+= $(DRV_NAME).o

all:
	make ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KERNEL_SRC) M=$(PWD) modules

install: all
	sudo cp $(DRV_NAME).ko /srv/nfs/de1_rootfs/home/root 

clean:
	make -C $(KERNEL_SRC) M=$(PWD) clean
