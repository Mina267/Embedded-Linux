

# Comprehensive Guide to Creating a Character Device Driver in the Linux Kernel

## Introduction

This guide covers the creation of a character device driver in the Linux kernel, offering detailed steps and explanations to help you understand how to interact with hardware devices using device files in the `/dev` directory. The guide is tailored to those who wish to gain a deeper understanding of kernel programming, device management, and user-space interaction with kernel-space components.

### What is a Character Device?

A **character device** handles data as a stream of bytes, allowing for reading and writing operations in a sequential manner. Unlike block devices (which manage data in blocks), character devices are suitable for devices like serial ports, keyboards, and other hardware where data is processed byte-by-byte.

## Workflow Overview

1. **alloc_chrdev_region**: Dynamically allocates a range of device numbers (major and minor) for your device. This `dev_t` structure is essential for registering your device with the kernel.

2. **cdev_init**: Initializes a `cdev` structure, which represents your character device in the kernel. This structure is linked to your file operations, which define how your device responds to read, write, open, and close calls.

3. **cdev_add**: Adds your `cdev` structure to the kernel, associating it with the device numbers allocated earlier. This step effectively makes your device known to the kernel.

4. **class_create**: Creates a device class under `/sys/class`, which provides a directory in the sysfs virtual filesystem for your device. This step helps with organizing devices and is used by udev to create device nodes.

5. **device_create**: Creates the device node in the `/dev` directory, making it accessible to user-space applications. This node is linked to the device class created earlier.

    - **Power Subsystem and uevent**: These are used by the udev system to manage device files dynamically. The `uevent` subsystem allows the kernel to notify udev about device events, ensuring that the correct device files are created under `/dev`.

## Detailed Steps to Implement the Character Device Driver

### Step 1: Define Device File Operations

#### Creating `file_operations.h`
In this header file, define the `file_operations` structure, which links your device to the functions that handle file operations such as open, close, read, and write. The structure should look like this:

```c
#include <linux/fs.h>

extern int driver_open(struct inode *inode, struct file *file);
extern int driver_close(struct inode *inode, struct file *file);
extern ssize_t driver_read(struct file *file, char __user *buf, size_t len, loff_t *off);
extern ssize_t driver_write(struct file *file, const char __user *buf, size_t len, loff_t *off);

static struct file_operations fops = {
    .owner = THIS_MODULE,
    .open = driver_open,
    .release = driver_close,
    .read = driver_read,
    .write = driver_write,
};
```

### Step 2: Implement Driver Logic

#### Implementing `file_operations.c`
This file contains the logic that defines how your device handles read and write operations. Here, we implement the buffer, open, close, read, and write functions.

```c
#include "file_operations.h"
#include <linux/uaccess.h>  // Required for copy_to_user, copy_from_user

#define BUFFER_SIZE 1024  // Size of the internal buffer

static char device_buffer[BUFFER_SIZE];  // Buffer to store data
static ssize_t buffer_pointer = 0;  // Points to the current position in the buffer

// Open function
int driver_open(struct inode *inode, struct file *file) {
    printk(KERN_INFO "Device opened\n");
    return 0;
}

// Close function
int driver_close(struct inode *inode, struct file *file) {
    printk(KERN_INFO "Device closed\n");
    return 0;
}

// Write function
ssize_t driver_write(struct file *file, const char __user *buf, size_t len, loff_t *off) {
    size_t to_copy, not_copied, delta;
    int space_available = BUFFER_SIZE - buffer_pointer;

    to_copy = min(len, (size_t)space_available);
    not_copied = copy_from_user(device_buffer + buffer_pointer, buf, to_copy);

    buffer_pointer += to_copy - not_copied;
    delta = to_copy - not_copied;

    printk(KERN_INFO "Received %ld bytes, %ld bytes copied to buffer\n", len, delta);
    return delta;
}

// Read function
ssize_t driver_read(struct file *file, char __user *buf, size_t len, loff_t *off) {
    size_t to_copy, not_copied, delta;

    to_copy = min(len, (size_t)buffer_pointer);
    if (to_copy == 0) {
        printk(KERN_INFO "No data to read\n");
        return 0;  // EOF
    }

    not_copied = copy_to_user(buf, device_buffer, to_copy);
    buffer_pointer -= to_copy - not_copied;
    delta = to_copy - not_copied;

    printk(KERN_INFO "Sent %ld bytes, %ld bytes copied to user\n", len, delta);
    return delta;
}
```

### Step 3: Main Driver Initialization

#### Implementing `main.c`
This file initializes your driver, sets up the device numbers, and registers the device with the kernel.

```c
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include "file_operations.h"

#define DEVICE_NAME "my_char_device"
#define CLASS_NAME "my_char_class"

static dev_t dev_number;  // Holds the major and minor numbers
static struct cdev my_cdev;  // Represents the char device structure
static struct class *my_class;  // Holds the device class

static int __init my_driver_init(void) {
    int result;

    // Allocate device numbers
    result = alloc_chrdev_region(&dev_number, 0, 1, DEVICE_NAME);
    if (result < 0) {
        printk(KERN_ALERT "Failed to allocate device numbers\n");
        return result;
    }

    // Initialize cdev structure
    cdev_init(&my_cdev, &fops);

    // Add the cdev to the system
    result = cdev_add(&my_cdev, dev_number, 1);
    if (result < 0) {
        printk(KERN_ALERT "Failed to add cdev to the system\n");
        unregister_chrdev_region(dev_number, 1);
        return result;
    }

    // Create a device class
    my_class = class_create(THIS_MODULE, CLASS_NAME);
    if (IS_ERR(my_class)) {
        printk(KERN_ALERT "Failed to create device class\n");
        cdev_del(&my_cdev);
        unregister_chrdev_region(dev_number, 1);
        return PTR_ERR(my_class);
    }

    // Create the device file in /dev
    device_create(my_class, NULL, dev_number, NULL, DEVICE_NAME);
    printk(KERN_INFO "Device registered: %s\n", DEVICE_NAME);
    return 0;
}

static void __exit my_driver_exit(void) {
    // Remove the device
    device_destroy(my_class, dev_number);

    // Destroy the class
    class_destroy(my_class);

    // Remove the cdev from the system
    cdev_del(&my_cdev);

    // Free the device numbers
    unregister_chrdev_region(dev_number, 1);
    printk(KERN_INFO "Device unregistered: %s\n", DEVICE_NAME);
}

module_init(my_driver_init);
module_exit(my_driver_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Mina Magdy");
MODULE_DESCRIPTION("A simple character device driver");
MODULE_VERSION("1.0");
```

### Step 4: Writing the Makefile

#### `Makefile`
The Makefile automates the process of building the kernel module. It specifies the source files and the dependencies.

```makefile
obj-m := my_driver.o
my_driver-objs := main.o file_operations.o

KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

all:
    $(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules

clean:
    $(MAKE) -C $(KDIR) SUBDIRS=$(PWD) clean
```

- **obj-m**: Specifies the name of the module to be built.
- **my_driver-objs**: Lists the object files that make up the module.
- **KDIR**: Points to the kernel source directory.
- **PWD**: Points to the current working directory.

### Step 5: Compilation and Installation

#### Compiling the Module
Use the `make` command in the directory containing the Makefile to compile the module:

```bash
make
```

This will generate a `.ko` file, which is your kernel module.

#### Installing the Module
To load the module into the kernel, use the `insmod` command:

```bash
sudo insmod my_driver.ko
```

You can verify the installation with the `lsmod` command:

```bash
lsmod | grep my_driver
```

Check the kernel messages using `dmesg`:

```bash
dmesg | tail
```

### Step 6: Testing the Device

#### Writing to the Device
You can write data to the device using the `echo` command:

```bash
echo "Hello, Kernel!" > /dev/my_char_device
```

#### Reading from the

 Device
To read data back, use the `cat` command:

```bash
cat /dev/my_char_device
```

### Step 7: Cleanup

#### Unloading the Module
To remove the module from the kernel, use the `rmmod` command:

```bash
sudo rmmod my_driver
```

#### Cleaning Up
To clean up the compiled files, use:

```bash
make clean
```

## Conclusion

By following this guide, you should now have a fully functional character device driver, understand its interaction with the Linux kernel, and be able to test it using basic file operations. This project serves as a solid foundation for more advanced kernel programming topics.
