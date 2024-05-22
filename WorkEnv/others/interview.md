### 常见面试题

```http
面试题：ifconfig取ip地址

1.ifconfig eth0|grep inet | tr -s ' ' % | cut -d% -f3 | head -n1
```

```http
面试题：DNS递归查询和跌该查询

递归查询：主机向本地域名服务器的查询一般都是采用递归查询。所谓递归查询就是：如果主机所询问的本地域名服务器不知道被查询的域名的IP地址，那么本地域名服务器就以DNS客户的身份，向其它根域名服务器继续发出查询请求报文(即替主机继续查询)，而不是让主机自己进行下一步查询。因此，递归查询返回的查询结果或者是所要查询的IP地址，或者是报错，表示无法查询到所需的IP地址。

迭代查询：当根域名服务器收到本地域名服务器发出的迭代查询请求报文时，要么给出所要查询的IP地址，要么告诉本地服务器：“你下一步应当向哪一个域名服务器进行查询”。然后让本地服务器进行后续的查询。根域名服务器通常是把自己知道的顶级域名服务器的IP地址告诉本地域名服务器，让本地域名服务器再向顶级域名服务器查询。顶级域名服务器在收到本地域名服务器的查询请求后，要么给出所要查询的IP地址，要么告诉本地服务器下一步应当向哪一个权限域名服务器进行查询。最后，知道了所要解析的IP地址或报错，然后把这个结果返回给发起查询的主机
```

```http
面试题：DNS解析过程

客户端访问www.baidu.com 这个域名时，会先查看本地是否有缓存，如无缓存会去查看本地hosts文件是否有相关信息，如果没有，则会去向设置的dns服务器：ISPDNS 如223.6.6.6，ISPDNS会检查是否有缓存，有则返回结果。无则会向配置文件中设置的13台根服务器的其中一台发送请求。根服务器拿到请求后，查看是com.这级域下的，就会返回com.的ns记录。
ISPDNS向com中的服务器再次发起请求，com域的服务器发现你这请求是baidu.com这个域的，查看到发现了这个域的NS，则会返回给NS记录给ISPDNS
ISPDNS收到信息后去向baidu.com,查到自己下面有个www的主机，则会返回结果到ISPDNS。
ISPDNS收到消息后，会在本地保存一份，再将结果返回给客户端。客户端根据结果中解析出来的主机ip再去请求访问。
```

```http
面试题：CDN是什么？

cdn是内容分发网络，其目的是通过限制的internet中增加一层新的网络架构。将网站的内容发布到最接近用户的网络边缘，使用户可以就近取得所需的内容，提高用户访问网站的响应速度。

CDN类型特点？
专线：让用户直接访问数据源，可以实现数据的动态同步。
```

### Redis常见面试题

```http
面试题：redis为什么快？

1.redis采用多路复用机制
2.数据结构简单
3.纯内存操作 运行在内存缓存区中，数据存储在内存中，读取时无需进行磁盘IO
4.单线程无锁竞争损耗
```

```http
面试题：redis的数据类型？redis常用的使用场景？

redis的五种数据类型如下：
1.String 整数，浮点整数或者字符串
2.Set 集合
3.Zset 有序集合
4.Hash 散列
5.List 列表

redis常用的使用场景有：
1.缓存
2.排行榜 常用实现数据类型：有序集合实现
3.好友关系 利用集合 如交集、差集、并集等
4.简单的消息队列
5.Session共享 默认Session是保存在服务器的文件中，如果是集群服务，同一个用户过来可能落在不同机器上，这就会导致用户频繁登陆；采用Redis保存Session后，无论用户落在那台机器上都能够获取到对应的Session信息。
  频繁被访问的数据，经常被访问的数据如果放在关系型数据库，每次查询的开销都会很大，而放在redis中，因为redis 是放在内存中的可以很高效的访问。
```

```http
面试题：redis的数据淘汰机制有哪些？

1.volatile-lru     从已设置过期时间的数据集中挑选最近最少使用的数据淘汰
2.volatile-ttl     从已设置过期时间的数据集中挑选将要过期的数据淘汰
3.volatile-random  从已设置过期时间的数据集中任意选择数据淘汰
4.allkeys-lru      从所有数据集中挑选最近最少使用的数据淘汰
5.allkeys-random   从所有数据集中任意选择数据进行淘汰
6.noeviction       禁止驱逐数据
```

```http
面试题：redis缓存穿透、缓存击穿、缓存雪崩简述下？有什么方法可以解决？

1.缓存穿透：就是客户持续向服务器发起对不存在服务器中数据的请求。客户先在Redis中查询，查询不到后去数据库中查询。
2.缓存击穿：就是一个很热门的数据，突然失效，大量请求到服务器数据库中
3.缓存雪崩：就是大量数据同一时间失效。

假设你是个很有钱的人，开满了百度云，腾讯视频各种杂七杂八的会员，但是你就是没有netflix的会员，然后你把这些账号和密码发布到一个你自己做的网站上，然后你有一个朋友每过十秒钟就查询你的网站，发现你的网站没有Netflix的会员后打电话向你要。你就相当于是个数据库，网站就是Redis。这就是缓存穿透。
大家都喜欢看腾讯视频上的《水果传》，但是你的会员突然到期了，大家在你的网站上看不到腾讯视频的账号，纷纷打电话向你询问，这就是缓存击穿。
你的各种会员突然同一时间都失效了，那这就是缓存雪崩了。

解决方法：
缓存穿透：
1.接口层增加校验，对传参进行个校验，比如说我们的id是从1开始的，那么id<=0的直接拦截；
2.缓存中取不到的数据，在数据库中也没有取到，这时可以将key-value对写为key-null，这样可以防止攻击用户反复用同一个id暴力攻击
缓存击穿：
最好的办法就是设置热点数据永不过期，拿到刚才的比方里，那就是你买腾讯一个永久会员
缓存雪崩：
1.缓存数据的过期时间设置随机，防止同一时间大量数据过期现象发生。
2.如果缓存数据库是分布式部署，将热点数据均匀分布在不同搞得缓存数据库中。
```

```http
面试题：简述redis的数据持久化实现？

redsi的的持久方式有2种，rdb和aof
rdb持久化：在间隔一段时间或者当key改变达到一定的数量的时候，就会自动往磁盘保存一次。
aof持久化：记录用户的操作过程（用户没执行一次命令，就会被redis记录到一个aof文件中，如果发生突然短路，redis的数据会通过重新读取并执行aof里的命令记录来恢复数据）来恢复数据。

rdb：如未满足设置的条件，就不会触发保存，如出现断电就会丢失数据。
aof:是为解决rdb的弊端的，但aof的持久化会随着时间的推移数量越来越多，会占用很大空间。
```

### MySQL常见面试题

```http
面试题：MySql主从复制原理？

1.主节点必须启用二进制日志，记录任何修改了数据库数据的事件。
2.从节点开启一个线程（I/O Thread)把自己扮演成 mysql 的客户端，通过 mysql 协议，请求主节点的二进制日志文件中的事件
3.主节点启动一个线程（dump Thread），检查自己二进制日志中的事件，跟对方请求的位置对比，如果不带请求位置参数，则主节点就会从第一个日志文件中的第一个事件一个一个发送给从节点。
从节点接收到主节点发送过来的数据把它放置到中继日志（Relay log）文件中。并记录该次请求到主节点的具体哪一个二进制日志文件内部的哪一个位置（主节点中的二进制文件会有多个，在后面详细讲解）。
5.从节点启动另外一个线程（sql Thread ），把 Relay log 中的事件读取出来，并在本地再执行一次。
```

```http
面试题：mysql有哪些日志类型？

错误日志：记录报错或警告信息
查询日志：记录所有对数据请求的信息，不论这些请求是否得到正确的执行。
慢查询日志：设置阕值，将查询时间超过该值的查询语句。
二进制日志：记录对数据库执行更改得所有操作
中继日志
事务日志
```

### nginx常见面试题

```http
面试题：

1、支持高并发，官方测试连接数支持5万，生产可支持2~4万。
2、内存消耗成本低
3、配置文件简单，支持rewrite重写规则等
4、节省带宽，支持gzip压缩。
5、稳定性高
6.支持热部署
```

```http
面试题：nginx用过的模块，在proxy中你配置过的参数？

负载均衡upstream 反向代理proxy_pass location rewrite等
proxy中配置过，proxy_sent_header proxy_connert_timeout proxy_send_timeout
```

```http
面试题：nginx中的rewrite中有多少个flag标志位？

last：表示完成当前的rewrite规则
break：停止执行当前虚拟主机的后续rewrite
redirect : 返回302临时重定向，地址栏会显示跳转后的地址
permanent : 返回301永久重定向，地址栏会显示跳转后的地址
```

### Docker常见面试题

```http
面试题：什么是Docker？

Docker一个容器化平台，它以容器的方式将应用程序和其所有依赖打包在一起，以确保应用程序在任何环境都能无缝运行。
```

```http
面试题：Dokcer是如何做到容器之间相互隔离的？

Docker Enginer使用了命名空间对全区操作系统资源进行了抽象，对于命名空间内的进程来说，他们拥有独立的资源实例，在命名空间内部的进程是可以实现资源可见的。

Dcoker Enginer中使用的NameSpace如下：
1.UTS nameSpace        提供主机名隔离能力
2.User nameSpace       提供用户隔离能力
3.Net nameSpace        提供网络隔离能力
4.IPC nameSpace        提供进程间通信的隔离能力
5.Mnt nameSpace        提供磁盘挂载点和文件系统的隔离能力
6.Pid nameSpace        提供进程隔离能力
Pid NameSpace:

Mnt NameSpace:
每个容器都要有独立的根文件系统有独立的用户空间，以实现在容器里面启动服
务并且使用容器的运行环境，即一个宿主机是 ubuntu 的服务器，可以在里面启
动一个 centos 运行环境的容器并且在容器里面启动一个 Nginx 服务，此 Nginx 运
行时使用的运行环境就是 centos 系统目录的运行环境，但是在容器里面是不能
访问宿主机的资源，宿主机是使用了 chroot 技术把容器锁定到一个指定的运行
目录里面。

Ipc NameSpace:
一个容器内的进程间通信，允许一个容器内的不同进程的(内存、缓存等)数据访
问，但是不能跨容器访问其他容器的数据。

Uts NameSpace:
UTS namespace（UNIX Timesharing System 包含了运行内核的名称、版本、底层体
系结构类型等信息）用于系统标识，其中包含了 hostname 和域名 domainname ，
它使得一个容器拥有属于自己 hostname 标识，这个主机名标识独立于宿主机系
统和其上的其他容器。

Pid NameSpace:
Linux 系统中，有一个 PID 为 1 的进程(init/systemd)是其他所有进程的父进程，那么在每个容
器内也要有一个父进程来管理其下属的子进程，那么多个容器的进程通 PID namespace 进程隔离
(比如 PID 编号重复、器内的主进程生成与回收子进程等)。

User NameSpace:
User Namespace 允许在各个宿主机的各个容器空间内创建相同的用户名以及相
同的用户 UID 和 GID，只是会把用户的作用范围限制在每个容器内，即 A 容器和
B 容器可以有相同的用户名称和 ID 的账户，但是此用户的有效范围仅是当前容
器内，不能访问另外一个容器内的文件系统，即相互隔离、互不影响、永不相见。

Net NameSpace:
每一个容器都类似于虚拟机一样有自己的网卡、监听端口、TCP/IP 协议栈等，
Docker 使用 network namespace 启动一个 vethX 接口，这样你的容器将拥有它自
己的桥接 ip 地址，通常是 docker0，而 docker0 实质就是 Linux 的虚拟网桥,网桥
是在 OSI 七层模型的数据链路层的网络设备，通过 mac 地址对网络进行划分，并
且在不同网络直接传递数据。
```

```http
面试题：Docker的网络模型？

1.host模式 
启动host模式，Docker不会为这个容器分配NetWork NaneSpace，容器不会虚拟出自己的网卡，而是使用宿主机的IP和端口

2.container模式 
这个模式指定新创建的容器和已经存在的一个容器共享一个Network Namespace，而不是和宿主机共享。新创建的容器不会创建自己的网卡，配置自己的IP，而是和一个指定的容器共享IP、端口范围等。同样，两个容器除了网络方面，其他的如文件系统、进程列表等还是隔离的。两个容器的进程可以通过lo网卡设备通信。

3.none模式
在这种模式下，Docker容器拥有自己的Network Namespace，但是，并不为Docker容器进行任何网络配置。也就是说，这个Docker容器没有网卡、IP、路由等信息。需要我们自己为Docker容器添加网卡、配置IP等。

4.bridge模式 默认模式 此模式会为每一个容器分配Network Namespace、设置IP等，并将一个主机上的Docker容器连接到一个虚拟网桥上。下面着重介绍一下此模式。
```

```http
面试题：Docker常见命令？

FROM

COPY 将宿主机的文件拷贝到容器内

ADD 将宿主机的文件拷贝到容器内 具有解压功能

RUN 执行shell命令

CMD 运行容器内进程为为1的命令

Contianed
```

```http
面试题：Docker容器是如何做到资源限制的？

通过Cgroups实现资源限制
```

### Ansible常见面试题

```http
面试题:ansible是什么？

ansible是自动化部署工具，基于python。基于模块工作
```

```http
面试题：常见的ansible模块？
yum copy service shell file user group ping unarchive

file:修改文件属性
service：用于管理服务运行状态
copy:复制本地文件到远程
mount:对管理机器执行挂载或卸载
unarchive：解压压缩
```

```http
面试题：ansible
```

### 反向代理常见面试题

```http
面试题:lvs调度算法有哪些？

静态算法：
RR：轮询算法
WRR：加权轮询
SH：源ip地址hash,将来自同一个ip地址的请求发送给第一次选择的RS。实现会话绑定。
DH：目标地址hash，第一次做轮询调度，后续将访问同一个目标地址的请求，发送给第一次
挑中的RS。适用于正向代理缓存中

动态算法：
LC：least connection 将新的请求发送给当前连接数最小的服务器。
WLC：默认调度算法。加权最小连接算法
SED：初始连接高权重优先,只检查活动连接,而不考虑非活动连接
NQ：Never Queue，第一轮均匀分配，后续SED
LBLC：Locality-Based LC，动态的DH算法
LBLCR：LBLC with Replication，带复制功能的LBLC，解决LBLC负载不均衡问题，从负载重的复制
到负载轻的RS,,实现Web Cache等
```

```http
面试题：
```

### 监控常见面试题

```http
面试题：zabbix主动模式和被动模式实现原理?(主动模式或被动模式都是站在agent的角度来说)

主动模式：zabbix-agent会主动开启一个随机端口去向zabbix-server的10051端口发送tcp连接。zabbix-server收到请求后，
会将检查间隔时间和检查项发送给zabbix-agent，agent采集到数据以后发送给server.

被动模式：zabbix-server会根据数据采集间隔时间和检查项，周期性生成随机端口去向zabbix-agent的10050发起连接。然后发送检查项给agent，agent采集后，在发送给server。如server未主动发送给agent，agent就不会去采集数据。

有zabbix-proxy的
就是中间有个proxy,主动模式下：agent请求的是proxy，由proxy向server去获取agent的采集间隔时间和采集项。再由proxy将数据发送给agent
agent采集完数据后，再由proxy中转发送给server.
被动模式：
```

```http
面试题：zabbix客户端agent如何批量安装？
 

 可以使用ansible+shell脚本自动化部署zabbix-agent软件包和管理配置文件。
```

```http
面试题：zabbix监控项？

1.硬件监控：交换机、防火墙、路由器
2.系统监控：cpu、内存、磁盘、进程、tcp等
3.服务监控：nginx、mysql、redis、tomcat等
4.web监控：响应时间、加载时间、页面访问是不是200等
```

```http
面试题：zabbix自定义监控项流程

编写shell脚本非交互式取值，如mysql主从复制，监控从节点的slave的IO，show slave status\G;
取出slave的俩个线程 Slave_IO_Running和Slave_SQL_Running:的值都为yes则输出一个0，如不同步则输出1，在zabbix agent的配置文件中，可以设置执行本地脚本 在zabbix server的web端上上配置监控项配置mysql_slave_check，在触发器中判断取到的监控值，如1则报警，如0则输出正常。自定义模板，需要新增图形。
```

### web常见面试题

#### tomcat常见面试题

```http
面试题：tomcat有几种部署方式？
```

```http
面试题：tomcat有几种运行模式？

1、bio tomcat7以下默认模式 
阻塞式I/O操作，此模式，每一个请求都要创建一个线程，线程开销较大，不能处理高并发的场景。通常最多处理几百个并发，效率低，不常用。
2、nio tomcat8以上默认采用nio
niop是内置的模式，是一个基于缓冲区、并能提供非阻塞I/O操作的Java API，它拥有比传统I/O操作(bio)更好的并发运行性能
3、apr 简单理解，就是从操作系统级别解决异步IO问题，大幅度的提高服务器的处理和响应性能， 也是Tomcat运行高并发应用的首选模式。用这种模式稍微麻烦一些，需要安装一些依赖库。
```

```http
面试题：tomcat工作模式？

Tomcat是一个JSP/Servlet容器。其作为Servlet容器，有三种工作模式：独立的Servlet容器、进程内的Servlet容器和进程外的Servlet容器。

进入Tomcat的请求可以根据Tomcat的工作模式分为如下两类：
1、Tomcat作为应用程序服务器：请求来自于前端的web服务器，这可能是Apache, IIS, Nginx等；
2、Tomcat作为独立服务器：请求来自于web浏览器；
```

```http
面试题：tomcat优化?

toncat自身优化
1、connector方式选择nio或者apr,默认bio支持并发性能低
2、配置文件线程池开启更多线程

JVM（java虚拟机）内存优化
设置最大堆内存
设置新生代比例参数
设置新生代与老年代优化参数
```

### Kubernetes

#### 1.1 k8s各组件功能

```http
#核心组件：
  apiserver：提供了资源操作的唯一入口，并提供认证、授权、访问控制、API注册和发现等机制；
  controller manager：负责维护集群的状态，比如故障检测、自动扩展、滚动更新等；
  scheduler：负责资源的调度，按照预定的调度策略将Pod调度到相应的机器上；
  kubelet：负责维护容器的生命周期，同时也负责volume（CVI）和网络（CNI）的管理；
  container runtime：负责镜像管理以及Pod和容器的真正运行（CRI）；
  kube-proxy：负责为Service提供cluster内部的服务发现和负载均衡；
  etcd：保存了整个集群的状态
#可选组件
  kube-dns：负责为整个集群提供DNS服务
  Ingress Controller：为服务提供外网入口
  Heapster：提供资源监控
  Dashboard：提供GUI
  Federation：提供跨可用区的集群
  Fluentd-elasticsearch：提供集群日志采集、存储与查询
```

#### 1.2 k8s中的访问服务流程

```http
用户执行kubectl/userClient向 apiserver 发起一个命令，经过认证授权后，经过 scheduler 的各种策略，得到一个目标 node ，然后告诉apiserver，apiserver会请求相关的node的 kubectl，通过kubelet把 pod 运行起来， apiserver还会将 pod的信息保存在 etcd； pod运行起来后，controller mamager 就会负责管理 pod的状态，如，若pod挂了， controller manager 就会重新创建一个一样的pod，或者像扩缩容等；pod有一个独立的ip地址，但pod的IP是易变的，如异常重启，或服务升级的时候，IP都会变，这就有了service；完成service工作的具体模块是kube-proxy；在每个node上都会有一个kube-proxy，在任何一个节点上访问一个service的虚拟ip，都可以访问到pod；service可以把服务端口暴露在当前的node上，外面的请求直接访问到node上的端口就可以访问到service了；
```

#### 1.3 k8s中的容器创建流程

```bash
#Pod是kubernetes创建或部署的最小/最简单的基本单位，一个pod代表集群上正在运行的一个进程。

#一个pod封装一个应用容器（也可以有多个容器），存储资源、一个独立的网络IP以及管理控制容器运行方式的策略选项。pod代表部署的一个单位：kubernetes中单个应用的实例，它可以由单个容器或多个容器共享组成的资源。

#Docker是Kubernetes Pod中最常见的runtime，Pods也支持其他容器runtimes

#Kubernetes中的Pod使用可分两种主要方式：
1、Pod中运行一个容器。"one-container-per-Pod"模式是Kubernetes最常见的用法；在这种情况下，你可以将Pod视为单个封装的容器，但是Kubernetes是直接管理Pod而不是容器

2、Pods中运行多个需要一起工作的容器。Pod可以封装紧密耦合的应用，它们需要由多个容器组成，它们之间能够共享资源（IP,网络、cpu、mem、挂载目录等），这些容器可以形成一个单一的内部service单位-一个容器共享文件，另一个"sidecar"容器来更新这些文件。Pod将这些容器的存储资源作为一个实体来管理


#第一步：kubectl create po
 首先进行认证后，kubectl会调用master api创建对象的接口，然后向k8s apiserver发出创建pod的命令 
 
#第二步：k8s apiserver
 apiserver收到请求后，并非直接创建pod，而是先创建一个包含pod创建信息的yaml文件  
 
#第三步：controller manager
 创建Pod的yaml信息会交给controller manager，controller manager根据配置信息将要创建的资源对象（pod）放到等待队列中  
 
#第四步：scheduler
 scheduler查看k8s api，类似于通知机制。首先判断：pod.spec.Node == null?
若为null，表示这个Pod请求是新来的，需要创建；然后进行预选调度和优选调度计算，找出最 “闲” 的且符合调度条件的node。最后将信息在etcd数据库中更新分配结果：pod.spec.Node2(设置一个具体的节点) 同样上述操作的各种信息也要写到etcd数据库中。
 分配过程需要两层调度：预选调度和优选调度
  （1）预选调度：一般根据资源对象的配置信息进行筛选。例如NodeSelector、HostSeletor和节点亲和性等。
  （2）优选调度：根据资源对象需要的资源和node节点资源的使用情况，为每个节点打分，然后选出最优的节点创建资源对象（pod）
  
#第五步：kubelet
  目标节点node2上的kubelet进程通过API Server，查看etcd数据库（kubelet通过API Server的WATCH接口监听Pod信息，如果监听到新的pod副本被调度绑定到本节点）监听到kube-scheduler 产生的Pod绑定事件后获取对应的Pod清单，然后调用node1本机中的docker api初始化volume、分配IP、下载image镜像，创建容器并启动服务
  
#第六步：controller manager
  controller manmager会通过API Server提供的接口实时监控资源对象的当前状态，当发生各种故障导致系统状态发生变化时，会尝试将其状态修复到 “期望状态”
```

#### 1,4 k8s集群实现高可用

```http
k8s集群实现高可用 HA的2种部署方式

#第一种是将 etcd 与 master 节点组件混布在一起
#第二种是使用独立的 etcd 集群，不与 master节点混布
```

#### 1.5 k8s的资源对象

```http
1、RC/RS和Deplyment的区别？
   Replication Controller 和 Replica Set 两种资源对象， RC 和 RS 的功能基本上是差不多的，唯⼀的区别就是 RS ⽀持集合的 selector 
   RC:
     (1)确保 Pod 数量：它会确保 Kubernetes 中有指定数量的 Pod 在运⾏，如果少于指定数量的 Pod ， RC 就会创建新的，反之这会删除多余的，保证 Pod 的副本数量不变。
     (2)确保 Pod 健康：当 Pod 不健康，比如运⾏出错了，总之无法提供正常服务时， RC 也会杀死不健康的 Pod ，重新创建一个新的Pod。
     (3)弹性伸缩：在业务⾼峰或者低峰的时候，可以通过 RC 来动态调整 Pod 数量来提供资源的利用率，当然我们也提到过如何使用 HPA 这种资源对象的话可以做到自动伸缩。
     (4)滚动升级：滚动升级是⼀种平滑的升级⽅式，通过逐步替换的策略，保证整体系统的稳定性。  
   Deployment 同样也是 Kubernetes 系统的⼀个核心概念，主要职责和 RC ⼀样的都是保证 Pod 的数量和健康，⼆者大部分功能都是完全⼀致的，我们可以看成是⼀个升级版的 RC 控制器，那 Deployment ⼜具备那些新特性呢？ 
     (1)RC 的全部功能： Deployment 具备上⾯描述的 RC 的全部功能；
     (2)事件和状态查看：可以查看 Deployment 的升级详细进度和状态；
     (3)回滚：当升级 Pod 的时候如果出现问题，可以使用回滚操作回滚到之前的任⼀版本；
     (4)版本记录：每⼀次对 Deployment 的操作，都能够保存下来，这也是保证可以回滚到任⼀版本的基础；
     (5)暂停和启动：对于每⼀次升级都能够随时暂停和启动。
```

```http
Service: 
   一个Pod只是一个运行服务的实例，随时可能在一个节点上停止，在另一个节点以一个新的IP启动一个新的Pod，因此不能以确定的IP和端口号提供服务。要稳定地提供服务 需要服务发现和负载均衡能力
  在k8s集群中，客户端需要访问的服务就是Service对象。每个Service会对应一个集群内部有效的虚拟IP，集群内部通过虚拟IP访问一个服务
```

```http
Job：
   Job是k8s用来控制批处理型任务的API对象。批处理业务与长期伺服业务的主要区别是批处理业务的运行有头有尾，而长期伺服业务在用户不停止的情况下永远运行。Job管理的Pod根据用户的设置把任务成功完成就自动退出了。成功完成的标志根据不同的spec.completions策略而不同：单Pod型任务有一个Pod成功就标志完成；定数成功型任务保证有N个任务全部成功；工作队列型任务根据应用确认的全局成功而标志成功
```

#### 1.6 yaml文件详解

```http
# cat nginx.yaml 
kind: Deployment  #类型，是deployment控制器，kubectl explain  Deployment
apiVersion: extensions/v1beta1  #API版本，# kubectl explain  Deployment.apiVersion
metadata: #pod的元数据信息，kubectl explain  Deployment.metadata
  labels: #自定义pod的标签，# kubectl explain  Deployment.metadata.labels
    app: linux36-nginx-deployment-label #标签名称为app值为linux36-nginx-deployment-label，后面会用到此标签 
  name: linux36-nginx-deployment #pod的名称
  namespace: linux36 #pod的namespace，默认是defaule
spec: #定义deployment中容器的详细信息，kubectl explain  Deployment.spec
  replicas: 3 #创建出的pod的副本数，即多少个pod，默认值为1
  selector: #定义标签选择器
    matchLabels: #定义匹配的标签，必须要设置
      app: linux36-nginx-selector #匹配的目标标签，
  template: #定义模板，必须定义，模板是起到描述要创建的pod的作用
    metadata: #定义模板元数据
      labels: #定义模板label，Deployment.spec.template.metadata.labels
        app: linux36-nginx-selector #定义标签，等于Deployment.spec.selector.matchLabels
    spec: #定义pod信息
      containers:#定义pod中容器列表，可以多个至少一个，pod不能动态增减容器
      - name: linux36-nginx-container #容器名称
        image: harbor.magedu.net/linux36/nginx-web1:v1 #镜像地址
        #command: ["/apps/tomcat/bin/run_tomcat.sh"] #容器启动执行的命令或脚本
        #imagePullPolicy: IfNotPresent #如果node有镜像就使用本地的，如果没有再下载镜像，适合用于镜像tag每次都不一样
        #imagePullPolicy: none #从不下载镜像
        imagePullPolicy: Always #拉取镜像策略
        ports: #定义容器端口列表
        - containerPort: 80 #定义一个端口
          protocol: TCP #端口协议
          name: http #端口名称
        - containerPort: 443 #定义一个端口
          protocol: TCP #端口协议
          name: https #端口名称
        env: #配置环境变量
        - name: "password" #变量名称。必须要用引号引起来
          value: "123456" #当前变量的值
        - name: "age" #另一个变量名称
          value: "18" #另一个变量的值
        resources: #对资源的请求设置和限制设置
          limits: #资源限制设置，上限
            cpu: 500m  #cpu的限制，单位为core数，可以写0.5或者500m等CPU压缩值
            memory: 2Gib #内存限制，单位可以为Mib/Gib，将用于docker run --memory参数
          requests: #资源请求的设置，# kubectl  explain deployment.spec.template.spec.containers.resources.
            cpu: 200m #cpu请求数，容器启动的初始可用数量,可以写0.5或者500m等CPU压缩值
            memory: 512Mi #内存请求大小，容器启动的初始可用数量，用于调度pod时候使用    
          
---
kind: Service #类型为service
apiVersion: v1 #service API版本， service.apiVersion
metadata: #定义service元数据，service.metadata
  labels: #自定义标签，service.metadata.labels
    app: linux36-nginx #定义service标签的内容
  name: linux36-nginx-spec #定义service的名称，此名称会被DNS解析
  namespace: linux36 #该service隶属于的namespaces名称，即把service创建到哪个namespace里面
spec: #定义service的详细信息，service.spec
  type: NodePort #service的类型，定义服务的访问方式，默认为ClusterIP， service.spec.type
  ports: #定义访问端口， service.spec.ports
  - name: http #定义一个端口名称
    port: 80 #service 80端口
    protocol: TCP #协议类型
    targetPort: 8080 #目标pod的端口
    nodePort: 30001 #node节点暴露的端口
  - name: https #SSL 端口
    port: 443 #service 443端口
    protocol: TCP #端口协议
    targetPort: 443 #目标pod端口
    nodePort: 30043 #node节点暴露的SSL端口
  selector: #service的标签选择器，定义要访问的目标pod
    app: linux36-nginx-selector #将流量路到选择的pod上，须等于Deployment.spec.selector.matchLabels
```

#### 1.7 探针类型

```bash
livenessProbe
#存活探针，检测容器是否正在运行，如果存活探测失败，则kubelet会杀死容器，并且容器将受到其重启策略的影响，如果容器不提供存活探针，则默认状态为 Success，livenessprobe用于控制是否重启pod

readinessProbe
#就绪探针，如果就绪探测失败，端点控制器将从与Pod匹配的所以Service的端点中删除该Pod的IP地址初始延迟之前的就绪状态默认为Failure（失败），如果容器不提供就绪探针，则默认状态为 Success，readinessProbe用于控制pod是否添加至service
```

#### 1.8 k8s基本概念、资源对象

```http
#kubernetes里的master指的是集群控制节点
master负责的是整个集群的管理和控制
kubernetes 3大进程：
   API server：增删改查操作的关键入口
   controller manager：资源对象的自动化控制中心
   Scheduler：负责资源调度的进程
```

```http
etcd服务kubernetes所有资源对象都保存在etcd中
node除了集群中的master，其他的机器被成为node
kubectl：负责pod对应的容器的创建，启停等任务，同时与master密切协作，实现集群管理的基本功能
kube-proxy：实现kubernetes service的通信与负载均衡机制的重要组件
docker engine：docker引擎，负责本机的容器创建和管理工作
```

```bash
pod里面有pause根容器和用户业务容器
```

```http
label 标签可以查询筛选资源对象
matchlabels 定义一组label
```

```bash
RC pod期待的副本数量
用于筛选目标pod的label selector
当pod的副本数量小于预期数量值，用于创建新pod的pod模板
```

```http
deplyment 相当 RC的升级
创建一个deplyment对象来生成对应的replica set 并完成 pod 副本的创建
检查deplyment的状态来看部署动作是否完成
更新deployment已创建新的pod（比如镜像升级
```

```bash
HPApod自动扩容系统
stateful
stateful里的每个pod都有稳定唯一的网络标识可以发现集群里的其他成员
stateful控制的pod副本的启停顺序是受控的
statefulset里的pod采用稳定的持久化存储卷
```

```http
service等于微服务架构里的微服务，服务访问入口
通过kube-proxy实现负载均衡转发到后端某个pod上
```

```bash
job用于批量处理任务
```

```http
volume
volume（存储卷）是pod中能够被多个容器访问的共享目录
emptyDir Volume是在pod分配到node时创建的。临时空间分配
```

```bash
namespace：实现多租户的资源隔离
```

```http
annotation注解和label类似标记 一些特殊信息
configmap：修改配置参数
```

#### 1.9 k8s命令使用

```bash
基础命令：
 create/delete/edit/get/describe/logs/exec/scale  #增删改查
 explain      #命令说明
 
配置命令：
  label：给node标记label，实现亲pod与node亲和性  #标签管理
  apply     #动态配置
  
  
  
  集群管理命令：
  cluster-info/top    #集群状态
node节点管理：
  cordon：警戒线，标记node不被调度
  uncordon：取消警戒标记为cordon的node
  drain：驱逐node上的pod，用于node下线等场景
  taint：给node标记污点，实现反亲pod与node反亲和性
api-resources/api-versions/version   #api资源
config   #客户端kube-config配置
```
