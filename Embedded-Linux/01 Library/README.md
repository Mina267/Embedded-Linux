
# C Library Project

This project demonstrates the creation and use of static and dynamic libraries in C, along with automating the build process using a Makefile.

## Directory Structure

```
project/
├── app/
│   └── main.c
├── includes/
│   └── .h (files)
├── lib/
│   └── libmylib.so
│   └── libmylib.a
├── obj/
│   └── .o (files static)
├── objDynamic/
│   └── .o (files Dynamic)
├── src/
│   └── mylib.c
└── Makefile
```


## Static Library

1. **Compile Source Files to Object Files**

    ```sh
    gcc -c -Wall ./src/*.c -I ./includes/ && mv *.o ./obj/
    ```
    - `-c`: Compile source files without linking.
    - `-Wall`: Enable all compiler warnings.
    - `./src/*.c`: Compile all `.c` files in the `src` directory.
    - `-I ./includes/`: Specify the directory to search for header files.
    - `mv *.o ./obj/`: Move all generated object files to the `obj` directory.

2. **Create Static Library**

    ```sh
    ar -rcs libmylib.a ./obj/*.o && mv libmylib.a ./lib/
    ```
    - `ar -rcs libmylib.a ./obj/*.o`: Create an archive (static library) named `libmylib.a` from the object files in the `obj` directory.
    - `mv libmylib.a ./lib/`: Move the archive to the `lib` directory.

3. **Link Static Library with Main Program**

    ```sh
    gcc -static ./app/main.c -o Run -I ./includes/ -L./lib/ -lmylib
    ```
    - `-static`: Link the executable statically.
    - `./app/main.c`: The main program source file.
    - `-o Run`: Output executable named `Run`.
    - `-I ./includes/`: Include directory for header files.
    - `-L ./lib/`: Directory containing the library.
    - `-lmylib`: Link with the static library `libmylib.a`.

4. **Run the Executable**

    ```sh
    ./Run
    ```

## Dynamic Library

1. **Compile Source Files to Position-Independent Code (PIC) Object Files**

    ```sh
    gcc -c -fPIC -Wall ./src/*.c -I ./includes/ && mv *.o ./objDynamic/
    ```
    - `-fPIC`: Generate position-independent code.
    - `mv *.o ./objDynamic/`: Move all generated object files to the `objDynamic` directory.

2. **Create Shared Library**

    ```sh
    gcc -shared -o ./lib/libmylib.so ./objDynamic/*.o
    ```
    - `-shared`: Create a shared library.
    - `-o ./lib/libmylib.so`: Output shared library named `libmylib.so` in the `lib` directory.

3. **Show Symbol Table**

    ```sh
    objdump -T ./lib/libmylib.so
    ```
    - Display the symbol table of the shared library.

4. **Link Dynamic Library with Main Program**

    ```sh
    gcc ./app/main.c -o dynamicApp -I ./includes/ -L ./lib/ -lmylib -Wl,-rpath=./lib/
    ```
    - `-o dynamicApp`: Output executable named `dynamicApp`.
    - `-L ./lib/`: Directory containing the shared library.
    - `-lmylib`: Link with the shared library `libmylib.so`.
    - `-Wl,-rpath=./lib/`: Set runtime library search path to `./lib`.

5. **Run the Dynamic Executable**

    ```sh
    ./dynamicApp
    ```

6. **Extract Printable Strings from the Executable**

    ```sh
    strings dynamicApp
    ```
    - Display printable strings in the executable.

7. **Print Shared Library Dependencies**

    ```sh
    ldd dynamicApp
    ```
    - Display shared library dependencies of the executable.


## Summary

- **Static Library**:
  - Compile source files to object files.
  - Archive object files into a static library.
  - Link the static library with the main program to create an executable.

- **Dynamic Library**:
  - Compile source files to position-independent object files.
  - Create a shared library from the object files.
  - Link the shared library with the main program to create an executable.

- **Utilities**:
  - `objdump -T` to show the symbol table of a shared library.
  - `strings` to extract printable strings from a binary file.
  - `ldd` to print shared library dependencies of an executable or a shared library.
