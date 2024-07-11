# 1- linux filesystem
etc: configration
dev: node
sys: registers in the devices 
bin: commands user can use it
sbin: command system
boot: files booting (kernal, bootloader)
home: home foder for all user in device
usr: lin and headers
media: external storage connected through socket like USB
mnt: internal storage on the board connected in kit


# 2- Variables
## Global (enviroment)
export GLOBAL=hi

advantage of global when you open child process from parent process you can see the output
1-->

## Local
LOCAL=hi

in child process will not see the about of local variable
1-->2

## command to see all olable vriables
$printenv
$set

## command echo 
echo print variable on terminal

# 3- types of command
## 1- enternal command
kernal --> bin 
## 2- internal command
bin/bash  -->source build inside the bash
## alias command
given another name for the command
$alias
$unalias

# 4- wildcard
? * [] {*.pdf, *.c}



# *Enviroment*
# File .bashrc
 
 script once you open terminal run over bash autmatically run .bashrc
Handle the design of the bash terminal
PS1 in bash rc respoible for design
path ~/.bashrc
 .: means hidden file

ls -a list all file include hidden

eah user has (home directory)
create .bashrc reposible for 
1- design terminal shape
2- set variable during open terminal
3- run APP. or scripts once you open the trerminal
4- .bashrc setup enviroment variable for teminal (vriable, alias) 
### for edit files
gedit .bashrc.

## File .profile

1- for each user has this file
run once you login to your user
run anthything program, stript ect. during login



path: ~/.profile

/bin: for all user in machine
./local/bin: save collect of binary for specific user, save any it any user created command.

if .bashrc or .profile didnot exist in home directory of user not found?
run backup -> etc/.bashrc etc/.profile


# Read file
## 1- cat (Concatenate)
print file contect on the terminal
## 2- less or more 

(terminal buffer) is limmited buffer file more size than 10000 line cannot print on yhe termnal once 
beacuse max terminal buffer is limmited
so by using less will divide the file into managebale parts and easy to scroll 
for example scroll data on the website
/: search
n: next accurency
N: previous
q:quit

more: scroll down only till the end of file and close autmatically

## 3- gedit  
read write using GUI

# 4- VS code

## 5- Edit file 
## vi or vim
sudo apt install vim
read & write file using terminal
it need bash only to run vim, but bash is independent app. 
how to navigate through vi  right --> L left --> h up --> k down --> j
navigate through by using arrows

## vim work in three mode
### 1- read(less)
/ serach 
n next 
N previous occutency

### 3- inert mode (i)

esc: return isert mode to read read mode
3- command mode
:q --> quit not work if you edit the file
:q!--> force quit
:wq --> save and quit

some sort cuts in read mode
dd: delete line
yy: copy
p: paste
v: select

## 6- nano
rdit file 
save: ctrl + x --> y + enter

# 7- head-tail
head print first 10 lines of file
tail: print last 10 lines of the file

# search file
## a - locate
sudo apt install locate
data base of all computer (in all HDD)
## b- find 
find [PATTH] -name file
find . -name main.c --> case sensetive
find . -iname main.c --> ignore case sensetivity

## c- whereis  
under dierctrioes $PATH

# search patern in file
## a - locate
a- grep
prep [pattern] [file]
grep -R [pattern] [directory]
enter directory to search for pattern
-R :recurcive
-n --> print line number
-i --> ignore case sensetivity

# Redirection & file descriptor
`>` : output on another file 
`>>`: input from anther file
`2>`: output error on another file

echo hello --> show interminal
cat main.c --> show interminal


myApp
int main(argv**, argc[]){return 0;};
./myApp hello --> terminal command


cat only work like that
while (1)
{
    scanf();
    printf();
}


if i want aoutput to print in another file 
cat main.c > output
will print in output file 

file descriptor (for any process)  
file --> 0 --> terminal --> input
file --> 1 --> terminal --> output
file --> 2 --> terminal --> error

when run cat main.c --> terminal fd(1)
scanf --> input from file

all three file will create for that procces `cat main.c`
kernal create three file descriptor

### example 1
``` c
int main(void)
{
    int var = 0;
    /* by default print on the terminal */
    printf("hello\n");
    /* by default take input from the terminal */
    scanf("%d", &var);
    printf("%d \n", var);
    return 0;
}
```
build program
```sh
gcc main.c -o myexe
./myexe
```

open another terminal
```sh
# all process running include myexe
ls /proc/
# all process running like task manager
ps -aux
# process runing in the terminal only
ps -at
# get PTD for myexe task
cd ~/proc
cd [PID]
# all information saved in from for that process cmdline, stack, fd etc
ls 
# enter file descriptor
cd fd
# Will see there is three file created for that process 0 1 2 and all of them point to the terminal

```

change output to be instead of terminal to output file
``` sh
./myexe > output
```

``` sh
ps -at
cat [PID]/fd
ls -lh [PID]/fd
# file 1 redirect (output) will point to outputfile instead of terminal
```

``` sh
# output to print file, and input from var file
./a.out > print < var
```






### example 2
``` c
int main(void)
{
    int var = 0;
    /* by default print on the terminal, stderr mean 2 error file*/
    fprintf(stderr,"hello\n");
    /* by default take input from the terminal */
    scanf("%d", &var);
    printf("%d \n", var);
    return 0;
}
```
```sh
# redirect error to output file
./myexe 2> output
```

### Example 3
``` c
int main(void)
{
    char var = 0;
    /* by default print on the terminal, stderr mean 2 error file*/
    fprintf(stderr,"hello from error\n");
    /* by default take input from the terminal */
    printf("hello from here\n");
    /* by default print on the terminal, stdout mean 1 output file*/
    fprintf(stdout,"hello from out\n");
    
    scanf("%c", &var);
    printf("%c \n", var);
    return 0;
}
```
```sh
# redirect error to output file
gcc main.c -o myexe
./myexe 2> output
# terminal output :  hello from here
# 

./myexe 2> error > output < var
# terminal output :  
# all out, in, error redirected to files
```

to direct error of gcc complier
```sh
gcc main.c 2> filename
```
### Example 4
``` c
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main(void)
{
    char var = 0;
    int FD = 0;
    /* will open form me new file descriptor */
    fd = open("var", O_RDWR);
    printf("My file descriptor:%d \n", fd);
    /* write in that new file descriptor */
    write(fd, "hiiiii", 7);

    /* by default print on the terminal, stderr mean 2 error file*/
    fprintf(stderr,"hello from error\n");
    /* by default take input from the terminal */
    printf("hello from here\n");
    /* by default print on the terminal, stdout mean 1 output file*/
    fprintf(stdout,"hello from out\n");
    
    scanf("%c", &var);
    printf("%c \n", var);
    return 0;
}
```
```sh
# redirect error to output file
gcc main.c -o myexe
./myexe 

./myexe 3> output

```

# piping |
IPC inter process communication

each process has its own heap and stack
each process is application
share resource between process

run procces and output of that process is input to another process

```sh
cat main.c | grep [pattern]

find . --iname | grep ^/
```

