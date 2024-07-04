#### Arch
##### pacman
```bash
#
```

#### Debian
##### apt
```bash
# update repo
apt update

# list packages
apt list
apt list --installed

# search package
apt search dig |grep bin

# show package detail
apt show bind9-dnsutils

# install, remove, upgrade package
apt install xxx
apt remove xxx
apt upgrade xxx

# show all repo and install special version
apt policy
apt policy firefox
apt install firefox=59.0.2+build1-0ubuntu1 



# apt-file
apt install apt-file
apt-file update
apt-file search dig |grep bin
```

##### dpkg
```bash
# list packages concisely
dpkg -l

# find which package owning binary or library file
dpkg -S /usr/bin/lsb_release
dpkg -S /lib/libmultipath.so

# List files 'owned' by package
dpkg -L lsb-release

# manually install or remove a .deb file package
dpkg -i elasticsearch-8.8.2-amd64.deb
dpkg -r mysql-common && dpkg -P mysql-common
```

#### RedHat
##### yum
```bash
#
yum update
```

##### rpm
```bash
#
```

