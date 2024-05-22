#### apt 
```shell
# 更新软件仓库
apt update
# 查看所有已有仓库源
apt policy
# 查看 apt 所有已安装的软件包
apt list --installed

# install special version
apt policy firefox
apt install firefox=59.0.2+build1-0ubuntu1 

# 搜索关键字可安装的软件包
apt search dig |grep bin
# apt-file 方式搜索，结果更多
apt install apt-file
apt-file update
apt-file search dig |grep bin


# 搜索命令或库文件属于哪个软件包
dpkg -S /usr/bin/lsb_release
dpkg -S /lib/libmultipath.so
# list packages concisely == apt list --installed
dpkg -l 
# 查看 apt 已安装的软件包所有相关文件
dpkg -L lsb-release
# 手动安装、卸载 deb 包
dpkg -r mysql-common
dpkg -P mysql-common
dpkg -i elasticsearch-8.8.2-amd64.deb

```

#### yum
```shell
#
```

