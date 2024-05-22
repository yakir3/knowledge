1、docker 与 containerd 的区别：
https://www.qikqiak.com/post/containerd-usage/

2、kubectl exec 的执行原理？
https://icloudnative.io/posts/how-it-works-kubectl-exec/

3、Pod 的启动过程以及生命周期？
启动创建过程：
+ https://blog.yutao.co/blog/2022/04/27/Kubernetes(%E4%BA%94)-Pod%E5%90%AF%E5%8A%A8%E8%BF%87%E7%A8%8B%E5%92%8C%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F.html
+ https://kubernetes.renkeju.com/chapter_4/4.5.2.Pod_creation_process.html
生命周期：
https://kubernetes.io/zh-cn/docs/concepts/workloads/pods/pod-lifecycle/

4、kubelet  kubeproxy 组件
kubelet: 
+ 管理容器生命周期与容器资源管理
+ 节点管理：获取 node 上 pod 信息，通过 apiserver 监听（watch+list） etcd 列表，同步信息
+ 读取监听信息并对节点 pod 创建修改操作：创建 pod 数据目录、挂载卷、下载 secret、检查 pod 容器状态以及 pause 容器启动与网络接管、pod hash 值计算以及 pod 的启动或重启
+ pod 健康检测：livenessprobe、readnessprobe、startupprobe

kube-proxy：service 的透明代理与 LB
+ iptables + nat：监听 apiserver 中 service 与 endpoint 信息，配置 iptables 规则，请求通过 iptables 转发给 pod（service 与 pod 过多时，太多 iptables 规则影响性能）
+ ipvs + ipset：与 iptables 类似，使用 ipset 方式基于 iptables 高性能负载

5、k8s 集群节点扩容？
组件横向与纵向扩容
节点的资源
