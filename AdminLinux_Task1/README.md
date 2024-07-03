# Question 1

## 1. List three Linux Distributions
	1- fedora
	2- Red Hat
	3- Solus 
	4- ZORIN 
	5- Linux Mint
	6- debian 
	7- archlinux 	
	8- BlackArch 
	9- Kubuntu 
	10- CentOS 
	11- Manjaro
## 2. From the slides what is the man command used for?
### man command
 System-wide documentation system that provides short reference manuals (pages) for individual
 commands,API functions, concepts, configuration file syntax, file formats and is organized in sections
 (1 for user commands, 2 for system calls...). That's the traditional Unix documentation system    

## 3. What is the difference between rm and rmdir using man command?
### a- rm
    rm removes each specified file. By default, it does not remove directories.
    If the -I or - -interactive=once option is given, and there are more
    than three files or the -r, -R, or -- recursive are given, then rm
    prompts the user for whether to proceed with the entire operation.
    If the response is not affirmative, the entire command is aborted.
    
### b- rmdir
    Remove the DIRECTORY(ies), if they are empty.
    -- ignore-fail-on-non-empty
        ignore each failure that is solely because a directory
        is non-empty
    -P, -- parents
        remove DIRECTORY and its ancestors; e.g., 'rmdir -p a/b/c' is similar to 'rmdir a/b/c a/b a'
    -v, -- verbose
        output a diagnostic for every directory processed
    -- help display this help and exit
    -- version
        output version information and exit

    
## 5. Copy the /etc/passwd file to your home directory making its name is mypasswd
    
```shell
cp /etc/passwd ~/mypasswd
```
<p align="center">
	<img src="https://github.com/Mina267/GP_4M_SV2_Intake3_FOTA_18/assets/71601701/52019423-d954-4780-8a81-9948b1317764" width=40% height=40% />
</p>

## 6. Rename this new file to be oldpasswd 
```shell
mv ~/mypasswd ~/oldpasswd
```
<p align="center">
	<img src="https://github.com/Mina267/GP_4M_SV2_Intake3_FOTA_18/assets/71601701/66fe9e76-1588-46d7-9050-22f5ef575466" width=40% height=40% />
</p>

## 7. You are in /usr/bin, list four ways to go to your home directory 
```shell
cd ~
cd /home/user
cd $HOME
cd
```


## 8. List Linux commands in /usr/bin that start with letter w
```shell	
ls /usr/bin/w*
```
<p align="center">
	<img src="https://github.com/Mina267/GP_4M_SV2_Intake3_FOTA_18/assets/71601701/0da028e9-54eb-40cf-a1e7-115b460ca2bb" width=40% height=40% />
</p>

## 9. What command type are used for? (from the slide)
## 10. Show 2 types of command file in /usr/bin that start with letter c
## 11. Using man command find the command to read file. (Note: man take option)
## 12. What is the usage of apropos command?
    
    
