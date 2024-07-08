#### dd
```bash
# out of CPU
dd if=/dev/zero of=/dev/null

# 
time dd if=/dev/zero of=test.file bs=1G count=2 oflag=direct

```

#### fio
```bash
# sequence read
fio -filename=/tmp/test.file -direct=1 -iodepth 1 -thread -rw=read -ioengine=psync -bs=16k -size=2G -numjobs=10 -runtime=60 -group_reporting -name=test_r

# sequence write
fio -filename=/tmp/test.file -direct=1 -iodepth 1 -thread -rw=write -ioengine=psync -bs=16k -size=2G -numjobs=10 -runtime=60 -group_reporting -name=test_w

# random write
fio -filename=/tmp/test.file -direct=1 -iodepth 1 -thread -rw=randwrite -ioengine=psync -bs=16k -size=2G -numjobs=10 -runtime=60 -group_reporting -name=test_randw

# mixed random read and write
fio -filename=/var/test.file -direct=1 -iodepth 1 -thread -rw=randrw -rwmixread=70 -ioengine=psync -bs=16k -size=2G -numjobs=10 -runtime=60 -group_reporting -name=test_r_w -ioscheduler=noop


```


#### iostat
```bash
# install
apt install sysstat
# use
iostat [options] [delay [count]]


# probe uninterrupted every 2 seconds
iostat 2
# probe 10 times per second
iostat 1 10


# display info
-c     Display the CPU utilization report.
-d     Display the device utilization report.
-h     Display human
-x     Display extended statistics
-t     Display timestamp

# example
iostat -dhx sda sdb 1 10
```

#### iotop
```bash
iotop -p xxx
```

#### pidstat
```bash
pidstat -d 1
```

#### sar
```bash
sar -b -p 1
```

#### Formatting and Partitioning
##### fdisk && gdisk
```bash
# show info
fdisk -l /dev/sda
gdisk -l /dev/sda
```

##### lsblk
```bash
# show all block device infomation
lsblk -f
```

##### parted && partprobe
```bash
# show disk partition info
parted -l

# partitioning with UEFI(GPT)
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- mkpart primary linux-swap 512MB 1536MB
parted /dev/sda -- mkpart root ext4 1536MB 100%
parted /dev/sda -- set 1 esp on
parted /dev/sda -- print

# refresh partition
partprobe
```

##### others
```bash
# 无需重启服务器,通过刷新磁盘数据总线方式获取新加磁盘
for host in $(ls /sys/class/scsi_host); 
do 
  echo "- - -" > /sys/class/scsi_host/$host/scan
done
```