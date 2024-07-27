# Creating the Root File System
Create a directory for the root filesystem:

```sh
mkdir rootfs
```

## 6. Copy BusyBox Installation to Root File System

Copy the contents of the BusyBox installation to the `rootfs` directory using `rsync`:

```sh
rsync -av /path/to/busybox/_install/ ~/rootfs
```

## 7. Create Additional Directories in rootfs

In the `rootfs` directory, create other necessary root directories manually:

```sh
mkdir  dev etc home mnt proc root srv sys
```

## 8. Create a Startup Script

Create a startup script called `rcS` in `etc/init.d/` to perform initialization tasks when booting the kernel:

```sh
mkdir -p etc/init.d
touch etc/init.d/rcS
```

Edit the `rcS` file:

```sh
vim etc/init.d/rcS
```

Add the following commands to the `rcS` script:

```sh
#!/bin/sh
# mount a filesystem of type `proc` to /proc
mount -t proc nodev /proc
# mount a filesystem of type `sysfs` to /sys
mount -t sysfs nodev /sys
# mount devtmpfs if you forget to configure it in Kernel menuconfig
mount -t devtmpfs devtmpfs /dev
# Path to ramfs script 
sh bin/RamfsScript
```

Make the script executable:

```sh
chmod +x etc/init.d/rcS
```

## 9. Create a Configuration File (inittab)

Create an `inittab` file in the `etc` directory:

```sh
touch etc/inittab
```

Edit the `inittab` file:

```sh
vim etc/inittab
```

Add the following lines to the `inittab` file:

```sh
# inittab file 
#-------------------------------------------------------
# When system startup, will execute "rcS" script
::sysinit:/etc/init.d/rcS
# Start "askfirst" shell on the console (Ask the user firstly to press any key)
ttyAMA0::askfirst:-/bin/sh
# When restarting the init process, will execute "init"
::restart:/sbin/init
```

## 10. Set Ownership of rootfs Files

Ensure the ownership of `rootfs` files is set to `root`:

```sh
sudo chown -R root:root /path/to/rootfs

sudo chown -R root:root *
```

# initramfs Script 
#### To select between two root filesystems rootfs1 and rootfs1 or quitting and use ramfs. `bin/RamfsScript` 
``` bash
Script Content
#!/bin/sh
echo "Select your desired booting option:"
echo "1) rootfs1"
echo "2) rootfs2"
echo "3) Resume in initRamfs"
read -r choice

case $choice in
    1)
        echo "Lunching rootfs one"
        mkdir -p /mnt/rootfs1
        mount -t ext4 /dev/mmcblk0p2 /mnt/rootfs1
        /bin/chroot /mnt/rootfs1
        ;;
    2)
        echo "Lunching rootfs two"
        mkdir -p /mnt/rootfs2
        mount -t ext4 /dev/mmcblk0p3 /mnt/rootfs2
        /bin/chroot /mnt/rootfs2
        ;;
    3)
        echo "Resume in initRamfs"
        break
        ;;
    *)
        echo "Wrong selection"
        ;;
esac
```

# Creating initramfs
#### initramfs (initial ramdisk filesystem) is a temporary, early root filesystem that is mounted before the real root filesystem becomes available during the Linux kernel's initialization process. It is commonly used in the boot process to perform tasks such as loading essential kernel modules, configuring devices, and preparing the system for the transition to the actual root filesystem.

```sh
cd ~/rootfs
find . | cpio -H newc -ov --owner root:root > ../initramfs.cpio
cd ..
gzip initramfs.cpio
mkimage -A arm -O linux -T ramdisk -d initramfs.cpio.gz uRamdisk
```


# Script to Booting with initramfs from bootcmd 


#### Copy uRamdisk you created earlier in this section to the boot partition on the microSD card, and then use it to boot to point that you get a U-Boot prompt. Then enter these commands:

```sh
sudo cp ./uRamdisk /media/mina
```
```bash
# In bootargs variable you need to configure like this
setenv bootargs "console=ttyAMA0 rdinit=/bin/sh"

# make sure the variable initramfs doesn't overwrite the dtb and zimage variables
setenv initramfs [chose a value depends on bdinfo]

fatload mmc 0:1 $kernel_addr_r zImage
fatload mmc 0:1 $fdt_addr_r am335x-boneblack.dtb
fatload mmc 0:1 $initramfs uRamdisk
setenv bootargs console=ttyO0,115200 rdinit=/bin/sh

bootz $kernel_addr_r $initramfs $fdt_addr_r

```




# Virtual SD Card Partitioning and Management

This project demonstrates how to create, partition, and manage a virtual SD card using loop devices in Ubuntu.

## Steps

1. **Create a Virtual Memory File:**

   ```bash
   dd if=/dev/zero of=sd.img bs=1M count=1024
   ```

2. **Setup Loop Device:**

   ```bash
   sudo losetup -f --show --partscan sd.img
   ```

   Assume the loop device is `/dev/loop0`.

3. **Partition the Virtual Disk:**

   ```bash
   sudo cfdisk /dev/loop0
   ```

   In `fdisk`:
   - Press `o` to create a new empty DOS partition table.
   - Press `n` to create new partitions:
     - `boot`    (200MB)
     - `rootfs1` (400MB)
     - `rootfs2` (400MB)

4. **Format the Partitions:**

   ```bash
   sudo mkfs.vfat -F 16 -n boot /dev/loop0p1
   sudo mkfs.ext4 -L rootfs /dev/loop0p2
   sudo mkfs.ext4 -L rootfs /dev/loop0p3
   ```

5. **Mount the Partitions:**

   ```bash
   sudo mkdir -p /mnt/boot /mnt/rootfs1 /mnt/rootfs2
   sudo mount /dev/loop0p1 ~/boot
   sudo mount /dev/loop0p2 ~/rootfs1
   sudo mount /dev/loop0p3 ~/rootfs2
   ```

6. **Copy Files to New Partition:**

   ```bash
   sudo cp -r ~/rootfs/* ~/rootfs1
   sudo cp -r ~/rootfs/* ~/rootfs2
   ```


