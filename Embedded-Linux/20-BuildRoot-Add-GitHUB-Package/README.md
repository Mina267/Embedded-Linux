## Creating a New GitHub Package in Buildroot Menuconfig

### How to Customize a Package and Integrate it with Buildroot Using GitHub

#### Steps on the Host Machine

1. **Develop Your Application and Makefile**

   Create a simple application with the following files:

   **MinaGithub_package.c:**
   ```c
   #include <stdio.h>

   int main() {
       printf("\n*****************************\n");
       printf("* Hello Mina GitHub Package *");
       printf("\n*****************************\n");

       return 0;
   }
   ```

   **Makefile:**
   ```makefile
   TARGET = MinaGithub_package
   SRC = MinaGithub_package.c

   $(TARGET): $(SRC)
   	$(CC) -o $@ $(SRC)

   clean:
   	-rm -f $(TARGET)
   ```

**Create the Tarball:**
   
   First, ensure that your `MinaGithub_package.c` and `Makefile` are in the same directory, then create a tarball.

   ```sh
   tar -czvf MinaGithub_package-v1.tar.gz MinaGithub_package.c Makefile
   ```

2. **Push to GitHub**

   Initialize a new Git repository (if not already done), commit your files, and push them to GitHub:
   ```sh
   git clone  https://github.com/Mina267/Package.git 
   git add .
   git commit -m "Initial commit of Mina Package"
   git push -u origin master
   ```

3. **Get the Commit ID or Tag**
### Understanding Commit IDs and Tags

- **Commit ID:** Every commit in Git has a unique identifier called a commit ID. It's a long string of characters that uniquely identifies a particular state of your repository. Using a commit ID ensures that you are referencing the exact version of the code at that specific commit.
  
- **Tag:** A tag is a reference that points to a specific point in the repository's history. Tags are often used to mark release points (e.g., `v1.0.0`). Using a tag can be more user-friendly because it's easier to remember and understand.

#### To ensure reproducibility, you should use the commit ID or tag when integrating with Buildroot.

### Steps to Get the Commit ID or Tag

#### 1. Getting the Commit ID

To get the latest commit ID from your repository, use the following command:

```sh
git log -1 | grep ^commit | cut -d " " -f 2
```

This command retrieves the most recent commit ID. Here's a breakdown of what it does:
- `git log -1` shows the log for the latest commit.
- `grep ^commit` filters out the line that starts with "commit".
- `cut -d " " -f 2` extracts the commit ID from that line.

For example:
```sh
$ git log -1 | grep ^commit | cut -d " " -f 2
b2d1cceed5c33274935436b4644fc92763a6636f
```

#### 2. Creating and Using a Tag

To create a tag, you can use the following commands:
```sh
git tag v1.0.0
git push origin v1.0.0
```

This creates a tag named `v1.0.0` and pushes it to the remote repository. Tags are often used for marking releases or specific points in the project's history.

To get a list of tags, you can use:
```sh
git tag
```

#### Final Development and Pushing Files

- **Finalize Development:** Ensure your application code and Makefile are in their final state before you push the changes to GitHub.
- **Push Your Files:** Once your development is complete, push all changes to your GitHub repository.

#### Why This Matters

If you make additional commits after the initial push, the commit ID or tag you used in your Buildroot package script will no longer point to the latest version of your code. To keep your Buildroot package script up-to-date with the latest code changes, you would have to update the commit ID or tag accordingly.

### Steps on Buildroot

#### 1. Create Package Directory and Files

1. **Navigate to the Buildroot Package Directory:**

   ```sh
   cd /path/to/buildroot/package
   ```

2. **Create the `MinaGithub_package` Directory:**

   ```sh
   mkdir MinaGithub_package
   cd MinaGithub_package
   ```

3. **Create `MinaGithub_package.mk` and `Config.in` Files:**

   ```sh
   touch MinaGithub_package.mk
   touch Config.in
   ```

#### 2. Edit `MinaGithub_package.mk`

Open `MinaGithub_package.mk` in a text editor:

```sh
vim MinaGithub_package.mk
```

Add the following content:

**MinaGithub_package.mk:**
```makefile
MINAGITHUB_PACKAGE_VERSION = b2d1cceed5c33274935436b4644fc92763a6636f
# MINAGITHUB_PACKAGE_VERSION = v1.0.0 
MINAGITHUB_PACKAGE_SITE = $(call github,Mina267,Package,$(MINAGITHUB_PACKAGE_VERSION))
MINAGITHUB_PACKAGE_LICENSE = GPL-2.0+
MINAGITHUB_PACKAGE_LICENSE_FILES = LICENSE

define MINAGITHUB_PACKAGE_BUILD_CMDS
    $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D)
endef

define MINAGITHUB_PACKAGE_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/MinaGithub_package $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
```

#### 3. Edit `Config.in` in `MinaGithub_package` Directory

Open `Config.in` in a text editor:

```sh
vim Config.in
```

Add the following content:

**Config.in:**
```makefile
config BR2_PACKAGE_MINAGITHUB_PACKAGE
    bool "MinaGithub_package"
    help
      MinaGithub_package package.
```

#### 4. Modify the Main `Config.in`

Navigate back to the `package` directory and edit the main `Config.in` file:

```sh
cd ..
vim Config.in
```

Add the following lines to include your package:

**package/Config.in:**
```makefile
menu "MinaGithub_package Packages"
    source "package/MinaGithub_package/Config.in"
endmenu
```

### Building the Image with Your Package

1. **Configure Buildroot:**

   Run `make menuconfig` to open the Buildroot configuration menu:

   ```sh
   make menuconfig
   ```

2. **Select Your Package:**

   Navigate to "Target Packages" -> "Misc" and select "MinaGithub_package". Save and exit the configuration menu.

3. **Build the Image:**

   Run `make` to build the entire Buildroot image with your custom package:

   ```sh
   make
   ```

4. **If Rebuilding Just the Package:**

   If you have already built an image and only want to add the new package, you can run:

   ```sh
   make MinaGithub_package
   make -j4
   ```

   This will include `MinaGithub_package` into the root filesystem image.

### Summary

1. **Develop your application and Makefile.**
2. **Push your files to GitHub.**
3. **Get the commit ID or tag from GitHub.**
4. **Create the package directory and necessary files in Buildroot.**
5. **Edit the `MinaGithub_package.mk` and `Config.in` files to define your package.**
6. **Include your package in the main `Config.in` file.**
7. **Configure Buildroot to select your package.**
8. **Build the Buildroot image.**

By following these steps, your `MinaGithub_package` will be integrated into the Buildroot system and included in the final filesystem image.




<br>

---

<br>



<p align="center">
	<img src="https://github.com/user-attachments/assets/ea5a68d7-c8ce-4d5d-be21-061bdf7b2b33" width=85% height=85% />
</p>
<p align="center">
	<img src="https://github.com/user-attachments/assets/8baa1538-b33b-45ac-bffe-102260ac707e" width=85% height=85% />
</p>
<p align="center">
	<img src="https://github.com/user-attachments/assets/2622c49e-c775-4937-841b-40ebeca26b0c" width=85% height=85% />
</p>
<p align="center">
	<img src="https://github.com/user-attachments/assets/be16bb54-39c6-4365-9e4c-cb7ec0c7a3ed" width=85% height=85% />
</p>
<p align="center">
	<img src="https://github.com/user-attachments/assets/40d2f83c-162a-4b2f-a829-150b869c72ba" width=85% height=85% />
</p>
<p align="center">
	<img src="https://github.com/user-attachments/assets/2bac3e25-89f4-4194-a3c0-70c80f6f6094" width=85% height=85% />
</p>
<p align="center">
	<img src="https://github.com/user-attachments/assets/1b5428f9-6c33-455d-9ea2-97997abe835a" width=85% height=85% />
</p>
<p align="center">
	<img src="https://github.com/user-attachments/assets/c18430ba-e5c3-491e-b45b-73dc1eb59fa1" width=85% height=85% />
</p>
