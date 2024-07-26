
# TFTP Server Setup on Linux

To set up and use a TFTP server on a Linux machine comprehensively, including all necessary details and additional context, follow these steps:

## 1. Install the TFTP Package

### Install the TFTP Server

```bash
sudo apt-get install tftpd-hpa
```

This command installs the TFTP daemon `tftpd-hpa`, which is a highly configurable TFTP server.

### Verify the Installation

After installation, ensure that the TFTP server is running and listening on the default TFTP port (69):

```bash
sudo ss -tulpn | grep :69
```
or
```bash
sudo systemctl status tftpd-hpa
```

These commands check if the TFTP server is active and listening on the correct port.

## 2. Configure the TFTP Server

### Edit the Configuration File

The configuration file for the TFTP server is located at `/etc/default/tftpd-hpa`. Open it with your preferred text editor:

```bash
sudo vim /etc/default/tftpd-hpa
```

Inside this file, you will see some default configurations. Modify or add the following line:

```bash
TFTP_OPTIONS="--secure --create"
```

- `--secure`: Restricts the TFTP server to a specific directory, enhancing security by preventing access to files outside this directory.
- `--create`: Allows the creation of new files on the server during file uploads. Without this option, the TFTP server might only allow reading or overwriting existing files but not creating new ones.

### Restart the TFTP Service

After making changes to the configuration file, restart the TFTP service to apply the new settings:

```bash
sudo systemctl restart tftpd-hpa
```

### Ensure the Service is Running

Verify that the TFTP service is running with the updated configuration:

```bash
sudo systemctl status tftpd-hpa
```

## 3. Set Up the TFTP Directory

### Default TFTP Directory

By default, the TFTP server uses `/srv/tftp` as the directory to serve files. Ensure this directory exists:

```bash
sudo mkdir -p /srv/tftp
```

### Change Ownership of the Directory

Change the ownership of the TFTP directory to the `tftp` user and group to ensure the TFTP server has the appropriate permissions:

```bash
sudo chown tftp:tftp /srv/tftp
```

## 4. Flash Through the TFTP Server

### U-Boot Configuration

If you're using U-Boot to load the kernel and other files via TFTP, configure the U-Boot environment variables appropriately.

### Place Files in the TFTP Directory

Place the necessary files such as `zImage` (compressed Linux kernel image) and `.dtb` (Device Tree Blob) in the `/srv/tftp` directory. For example:

- `zImage`: This is the compressed Linux kernel image used during the boot process.
- `.dtb`: The Device Tree Blob describes the hardware components of the system to the Linux kernel, allowing it to understand the hardware it is running on without needing hardcoded details in the kernel.

### Set U-Boot Environment Variables

On the target device, configure U-Boot to specify the TFTP server IP and the files to load:

```bash
setenv serverip <TFTP_SERVER_IP>
setenv ipaddr <TARGET_DEVICE_IP>
tftp $kernel_addr_r zImage
tftp $fdt_addr_r <DEVICE_TREE_FILE>.dtb
```

- `serverip`: The IP address of the TFTP server.
- `ipaddr`: The IP address of the target device.
- `tftp $kernel_addr_r zImage`: Loads the `zImage` from the TFTP server to the specified address in RAM.
- `tftp $fdt_addr_r <DEVICE_TREE_FILE>.dtb`: Loads the device tree file from the TFTP server to the specified address in RAM.

## Additional Information

### Verify the Package Installation

To check the files installed by the `tftpd-hpa` package, use the following command:

```bash
dpkg -L tftpd-hpa
```

This command lists all the files installed by the `tftpd-hpa` package.

### Manage the TFTP Service

The TFTP service can be managed using the `init.d` scripts. You can start, stop, restart, and check the status of the TFTP service with these commands:

```bash
sudo /etc/init.d/tftpd-hpa start
sudo /etc/init.d/tftpd-hpa stop
sudo /etc/init.d/tftpd-hpa restart
sudo /etc/init.d/tftpd-hpa status
```

## U-Boot and TFTP Interaction

- **U-Boot**: A popular bootloader used in embedded systems. It can load the kernel and other necessary files over TFTP, making it easier to update the kernel without physical access to the device.
- **TFTP Server**: The server from which the U-Boot bootloader retrieves files. The TFTP server must be correctly configured and accessible from the network.


<br>

---


# Installing the Linux Kernel

## 3.1. Download Linux Kernel

In this example, we will use the Qemu emulator (Vexpress A9).

1. Clone the Linux kernel repository:

```sh
git clone --depth=1 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
```

- `git clone`: This is the command to clone a Git repository.
- `--depth=1`: This option specifies that only the latest commit and its associated files should be cloned. This can be useful when you are only interested in the latest state of the repository and don't need the entire history. The number '1' indicates the depth of the clone.
- `git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git`: This is the URL of the Kernel repository we want to clone.

2. Change directory to the Linux source:

```sh
cd linux
```

### Configure the Kernel for a Specific Target (Vexpress A9)

1. Set the cross-compiler:

```sh
export CROSS_COMPILE=~/x-tools/arm-cortexa9_neon-linux-musleabihf/bin/arm-cortexa9_neon-linux-musleabihf-
```

2. Set the architecture type:

```sh
export ARCH=arm
```

3. Configure the kernel for the Vexpress A9 target:

```sh
make vexpress_defconfig
```

If you encounter an error at this stage, make sure the cross-compiler and architecture are correctly set.

### 3.2. Linux Kernel Configuration

You can customize your kernel image as needed:

1. Run `make menuconfig` to open the kernel configuration menu:

```sh
make menuconfig
```

#### Enable devtmpfs

1. Select `Device Drivers`.
2. Select `Generic Driver Options`.
3. Enable `Automount devtmpfs` by pressing `Y` and save the configuration.

#### Change Kernel Compression to XZ

1. Select `General Setup`.
2. Select `Kernel Compression Mode`.
3. Choose `XZ` and press `Enter` (don't forget to save).

#### Change Kernel Local Version

1. Select `General Setup`.
2. Select `Local Version - Append to Kernel Release`.
3. Enter your name and version (e.g., `AnasKernel-v1.0`) and save.

### Build the Kernel Configuration

1. Run the following command to build the kernel image, modules, and device tree blobs:

```sh
make -j4 zImage modules dtbs
```

- `-j4`: This option specifies the number of parallel jobs to run during the build process. `-j4` indicates that the build system should use 4 parallel jobs to speed up the compilation. Using multiple jobs in parallel can significantly reduce the time it takes to build the kernel. 

To determine the number of cores on your computer, use:

```sh
lscpu
```

2. If you encounter errors related to missing GMP or MPC headers, install the necessary development packages:

```sh
sudo apt-get install libgmp-dev
sudo apt-get install libmpc-dev
```

### Verify the Kernel Build

1. Check the built kernel image:

```sh
make kernelrelease
```

You should see something like `6.7.0-AnasKernel-V1.0+`, where `6.7.0` is the main kernel version, `AnasKernel-V1.0` is your custom version, and `+` indicates additional changes.

By following these steps, you will successfully configure, build, and customize the Linux kernel for the Vexpress A9 using Qemu. The instructions include handling common errors and ensuring the necessary packages are installed for a smooth build process.


# Example 


### Copy kernel image and dtb to TFTP server `srv/tftp`
```sh
sudo cp ~/linux/arch/arm/boot/zImage /srv/tftp/
sudo cp ~/linux/arch/arm/boot/dts/arm/vexpress-v2p-ca9.dtb /srv/tftp/
```


### Make small script to load zImage and dtb to RAM
```sh
sudo mkimage -A arm -T script -C none -a 0x62000000 -e 0x62000000 -n 'load Script' -d TFTP_script.txt ~/SD-card/boot/TFTP_script.img
```
### TFTP_script.txt
```bash
setenv ipaddr 192.168.1.9
setenv serverip 192.168.1.8


 if ping 192.168.1.8; then
        echo "Network connection available, loading from network..."
        tftp $kernel_addr_r zImage
        tftp $fdt_addr_r vexpress-v2p-ca9.dtb
        bootz $kernel_addr_r - $fdt_addr_r
 fi
```

## U-boot
### Save script in bootcmd
```sh
editenv bootcmd
edit: fatload mmc 0:1 0x62000000 /TFTP_script.img; source 0x62000000
saveenv 
```


```sh
sudo qemu-system-arm -M vexpress-a9 -m 128M -nographic -kernel u-boot -sd ~/SD-card/sd.img  -net tap,script=./qemu-ifup -net nic

```