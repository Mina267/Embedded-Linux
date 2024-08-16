
# `bbclass` Files in Yocto

### What is a `bbclass` File?

- **`bbclass` Files**: In Yocto, `.bbclass` files define common functionality that can be shared across multiple recipes. They contain functions, tasks, and variables that recipes can inherit, streamlining the build process.

### Using the `INHERIT` Directive

- **INHERIT Directive**: The `INHERIT` directive in a Bitbake recipe is used to import the functionality from a `.bbclass` file. This helps set up the environment required for the recipe to execute specific tasks.

- **Example**: Inheriting `cmake.bbclass` allows a recipe to use CMake for configuration, build, and installation.
  
  ```bash
  INHERIT += "cmake"
  ```

- **Systemd Integration Example**: To integrate a service with systemd in Yocto, use `systemd.bbclass`.
  
  ```bash
  INHERIT += "systemd"
  SYSTEMD_AUTO_ENABLE = "enable"
  SYSTEMD_SERVICE = "myservice.service"
  ```

  - **`SYSTEMD_AUTO_ENABLE`**: Automatically enables the service to start on boot.
  - **`SYSTEMD_SERVICE`**: Specifies the name of the systemd service to be installed and managed.

---

# Building a Recipe in Yocto

### Output and Root Filesystem

- **Destination Folder**: The output of a build process is typically placed in a designated folder (e.g., `APP`). 
- **Package Feeder**: The package feeder is responsible for placing the built packages into the root filesystem (`rootfs`).

### When is the Package Feeder Invoked?

- **`IMAGE_INSTALL` Variable**: The package feeder is invoked when you specify packages to be installed into the root filesystem using the `IMAGE_INSTALL` variable.

  ```bash
  IMAGE_INSTALL:append = " google myrecipe python3 bash"
  ```

- **Purpose**: The `IMAGE_INSTALL` variable in an image recipe determines the packages that will be included in the final image.

---

## `image.bbclass` and `IMAGE_INSTALL`

### What is `image.bbclass`?

- **`image.bbclass`**: This class is used to assemble the root filesystem in Yocto. It ensures that all specified packages in `IMAGE_INSTALL` are included in the final image.

- **Example**: In a `core-image-minimal` recipe:
  
  ```bash
  IMAGE_INSTALL = "packagegroup-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"
  ```

  - **`IMAGE_ROOTFS_SIZE`**: Specifies the size of the root filesystem.
  - **`IMAGE_ROOTFS_EXTRA_SPACE`**: Adds extra space to the root filesystem if certain features are enabled, like systemd.

  ```bash
  IMAGE_ROOTFS_EXTRA_SPACE:append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "", d)}"
  ```
### core-image-minimal
- PATH
```bash
cd /home/mina/yocto/poky/meta/recipes-core/images
```

SUMMARY = "A small image just capable of allowing a device to boot."

IMAGE_INSTALL = "packagegroup-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"

IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image

IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_EXTRA_SPACE:append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "", d)}"

```

### Exploring Recipes

- **Listing Recipes**: You can list and explore recipes using `bitbake-layers`.

  ```bash
  bitbake-layers show-recipes | grep python
  ```

---

## `DISTRO_FEATURES`

### What is `DISTRO_FEATURES`?

- **`DISTRO_FEATURES`**: This variable defines the features enabled for the distribution, such as systemd, X11, Wayland, etc.
  
- **Example**: Enabling systemd in the distribution:

  ```bash
  DISTRO_FEATURES:append = " systemd"
  ```

---

## Adding Qt5 to Your Yocto Build

### Step 1: Source the Build Environment

- **Initialize the Build Environment**:
  
  ```bash
  source oe-init-build-env
  ```

  This command creates the `build` directory where all configuration files will be located.

### Step 2: Clone Required Layers

- **Clone the necessary layers for Qt5 support**:

  1. **meta-qt5**: Contains Qt5 recipes.
     ```bash
     cd ~/yocto
     git clone -b kirkstone https://github.com/meta-qt5/meta-qt5.git
     ```

  2. **meta-openembedded**: Provides additional recipes and classes that may be required by Qt5.
     ```bash
     git clone -b kirkstone https://github.com/openembedded/meta-openembedded.git
     ```

  3. **meta-python**: Often required for Python-related dependencies.
     ```bash
     cd meta-openembedded
     git clone -b kirkstone https://github.com/openembedded/meta-python.git
     ```

### Step 3: Add Layers to Your Build

- **Add the layers to your Yocto build environment** using `bitbake-layers`:

  ```bash
  cd ~/yocto/poky/build
  bitbake-layers add-layer ../meta-openembedded/meta-oe
  bitbake-layers add-layer ../meta-openembedded/meta-python
  bitbake-layers add-layer ../meta-qt5
  ```

- **Alternatively**, manually edit the `bblayers.conf` file located in the `conf` directory:

  ```bash
  BBLAYERS ?= " \
    /path/to/poky/meta \
    /path/to/poky/meta-poky \
    /path/to/meta-openembedded/meta-oe \
    /path/to/meta-openembedded/meta-python \
    /path/to/meta-qt5 \
  "
  ```

  Replace `/path/to/` with the actual paths to your layers.

### Step 4: Configure `local.conf`

- **Configure `local.conf`** to include the necessary Qt5 packages:
  
  ```bash
  IMAGE_INSTALL_append = " qtbase qtdeclarative qtquickcontrols2 qtwebkit"
  ```

- **Set the machine configuration** if necessary (e.g., for Raspberry Pi):

  ```bash
  MACHINE = "raspberrypi4"
  ```

### Step 5: Build the Image

- **Build the Yocto image** with Qt5 libraries included:

  ```bash
  bitbake <your-image-recipe>
  ```

  Replace `<your-image-recipe>` with your desired image recipe, such as `core-image-sato`, `core-image-minimal`, or a custom image recipe.

