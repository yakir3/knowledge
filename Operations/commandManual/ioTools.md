#### dd
```shell
# out of CPU
dd if=/dev/zero of=/dev/null

# 
time dd if=/dev/zero of=test.file bs=1G count=2 oflag=direct

```

##### fdisk && parted
```shell
# show info
fdisk -l
parted -l

```

#### fio
```shell
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
```shell
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
```shell
iotop -p xxx
```

#### pidstat
```shell
pidstat -d 1
```

#### sar
```shell
sar -b -p 1
```