
## Adding Qt5 to Your Yocto Build

### Step 1: Source the Build Environment

- **Initialize the Build Environment**:

  ```bash
  source oe-init-build-env
  ```

  This command creates the `build` directory where all configuration files will be located, and sets up the environment for the build process.

### Step 2: Clone Required Layers

- **Clone the necessary layers for Qt5 support**:

  1. **meta-qt5**: Contains the Qt5 recipes.
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

- **Manually edit the `bblayers.conf`** (located in the `conf` directory) to include the paths to these layers:

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
  IMAGE_INSTALL:append = " qtbase qtdeclarative qtquickcontrols2 qtwebkit"
  ```

- **Set the machine configuration** if targeting specific hardware (e.g., Raspberry Pi):

  ```bash
  MACHINE = "raspberrypi3"
  ```

### Step 5: Integrate Systemd into Your Build

- **Add systemd support** to your distribution by editing your `distro.conf` or using a custom `distro.conf`:

  ```bash
  DISTRO_FEATURES:append = " systemd"
  DISTRO_FEATURES_BACKFILL_CONSIDERED:append = " sysvinit"
  VIRTUAL-RUNTIME_init_manager = "systemd"
  VIRTUAL-RUNTIME_initscripts = "systemd-compat-units"
  VIRTUAL-RUNTIME_login_manager = "shadow-base"
  VIRTUAL-RUNTIME_dev_manager = "systemd"
  ```

- **Ensure your image recipe reflects these changes** by adding systemd to `DISTRO_FEATURES` and including necessary packages.

### Step 6: Build the Image

- **Build the Yocto image** with Qt5 and systemd included:

  ```bash
  bitbake <your-image-recipe>
  ```

  Replace `<your-image-recipe>` with the name of your image recipe, such as `core-image-sato`, `core-image-minimal`, or a custom image recipe.

### Example Custom Image Recipe (`myimage.bb`)

**Create or Modify Your Image Recipe** to ensure Qt5 and systemd are included:

```bitbake
SUMMARY = "A minimal image with Qt5 and systemd support."
LICENSE = "MIT"

# Include necessary Qt5 packages
IMAGE_INSTALL:append = " qtbase qtdeclarative qtquickcontrols2 qtwebkit"

# Enable systemd support
DISTRO_FEATURES:append = " systemd"
VIRTUAL-RUNTIME_init_manager = "systemd"
VIRTUAL-RUNTIME_initscripts = "systemd-compat-units"
VIRTUAL-RUNTIME_dev_manager = "systemd"

inherit core-image
```

### Step 7: Using `qmake` in Recipes

- **Inherit `qmake` in your Qt5 application recipes** to compile using `qmake`:

  ```bitbake
  inherit qmake
  ```

  Ensure that your recipe includes the necessary `SRC_URI` pointing to your source files, and configure any specific build options needed for your project.

### Example Yocto Layer Structure

- **Organize your Yocto layer** to include your custom image recipe, machine configuration, and any additional recipes:

  ```
  meta-mina/
  ├── conf
  │   ├── layer.conf
  │   └── machine
  │       └── rpi.conf 
  ├── distro
  │   └── Mina.conf   
  ├── COPYING.MIT
  ├── README
  ├── recipes-demo
  │   └── demo
  │       └── demo_0.1.bb
  ├── classes/
  ├── recipes-myrecipe/
  │   └── myrecipe/
  │       └── myrecipe_1.0.bb
  │       └── myrecipe_%.bbappend
  │       └── files/
  │           └── main.c
  │           └── myservice.service
  ├── recipes-image/
  │   └── image
  │       └── myimage.bb
  └── recipes-kernel/
      └── hello-mod
          ├── files
          │   ├── COPYING
          │   ├── hello.c
          │   └── Makefile
          └── hello-mod_0.1.bb
  ```

### Step 8: Final Build

- **Build your image** with the following command:

  ```bash
  bitbake myimage
  ```

This will compile the image with all the specified features, including Qt5 and systemd, tailored to your hardware target.

