# Package Management

## debian
`dpkg`

## redhat
`rpm`

pakage: collection of files


```
dpkg -i   file_name.deb
```
```
dpkg -L 
```

apt: high level package manager
apt: server contain all packages
 depends in dpkg to intall dependencies

sudo apt install package
 intall all libraries required
 resolve all dependencies

when you fetch the package like vs code you fetched from the server not from website you need to know the package name in server

snap 

did not depends on distribution running into 
work only on PCs


apt install download install
apt upgade download new vwersion for already exist pakage
apt update fetch new update on the repo
fetch  update reference sync with server, lessen to new update in the system


# compressing archiving

make bakage to send it

archiving with same size
```
tar -cf bag.tar file file2 file3 dir1/
-C:create
-f:output file 
```
get type of file

```
file bag 
```

uncompress
```
tar -xf bag.tar mydir/
-x: extract 
```

algorithm implemented
gzip
xz
bzip2
select according to type of data video or file etc.

tar.gz    -z
tar.xz     -J
tar.bz2     -j

gzip -d file.tar.gz -- > decompress
gzip file.tar.gz ---> file is be compressed

bunzip -- > decompress
bzip   ---> compressed

# user
* normal user   ID 1000 - 40k
* system user   ID 1 - 199
* service user  ID 200 - 999

         shh
server <----- client

ls -h fady:fady
    owner  group

    fady 
    1- user login
    SU switch user 
    2- primary group

    all user in machine
    /etc/passwd 

    /etc/shadow
    encryptect password (HAsH)


Name:UID:GID:coment:homedirtory:shepp type

cat /etc/passwd | grep mina
cat /etc/passwd | grep sshd
cat /etc/passwd | grep -v /bin/bash | wc -l
    cat /etc/passwd | grep  /bin/bash | wc -l

cat /etc/passwd | grep /bin/bash


sudo: group vollection of user
search /etc/sudeors


adduser NEW_USER
1- password 
2- comment

groupadd GROUP_NAME

sudo visudo ---> /etc/sudeors

%sudo ALL=(ALL:ALL) ALL  -> alluser allgroup allapplications
%hero ALL=(ALL:ALL) ALL

vim /etc/group
// add NEW_USER to GROUP_NAME group to give it privllage of sudo
GROUP_NAME:X:22:NEW_USER

// switch to new user
su NEW_USER

// add NEW_USER to GROUP_NAME group to give it privllage of sudo
usermod -aG GROUP_NAME NEW_USER