savedcmd_/home/mina/Modules/004_char_module/MyChar.mod := printf '%s\n'   main.o file_operations.o | awk '!x[$$0]++ { print("/home/mina/Modules/004_char_module/"$$0) }' > /home/mina/Modules/004_char_module/MyChar.mod