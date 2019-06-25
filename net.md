ifconfig命令
手动设置网卡示例
假设想把网卡设置为如下：

网卡：eth0
IP：192.168.2.110
掩码：255.255.255.0
网管：192.168.2.1
可以这样：

ifconfig eth0 192.168.2.110 netmask 255.255.255.0 up
route add default gw 192.168.2.1 dev eth0
修改MAC
有时候我们需要修改网卡的mac地址，比如我现在的网卡信息如下：

eth0      Link encap:Ethernet  HWaddr 00:15:22:99:36:c9
          inet addr:192.168.2.110  Bcast:192.168.2.255  Mask:255.255.255.0
          inet6 addr: fe80::215:22ff:fe99:36c9/64 Scope:Link
...
上面显示的HWaddr就是mac地址：00:15:22:99:36:c9。现在我们想把 它修改成我们需要的：

ifconfig eth0 down  # 一定要先停止网卡
ifconfig eth0 hw ether 00:15:22:99:36:c9   # 修改mac地址
然后可以重启网络：

/etc/init.d/networking restart
MAC和网卡名绑定
如果我们有多个网卡，linux下可能叫eth0,eth1,eth2等等，有时候我 们自己都分不清到底哪个网卡对于哪个名字。这时候可以将mac可网卡 名绑定。

Redhat系列linux：
使用sysinit作为scripts管理一些系统服务，可以在类似的 /etc/sysconfig/network-scripts/ifcft-ethX 中写上 HWADDR=00:01:02:8C:50:09 ，这样以后这个ethX网卡就是mac值为 00:01:02:8C:50:09 的网卡了。这里MAC换成自己机器网卡的 mac，ethX中的X代表0,1,2,等等数字。

有nameif命令的linux：
基本都有这个命令，可以man一下，这个可以设置mac和网卡名字绑定。

桥接网络
创建网络设备
创建一个指定用户有权限的设备 tap0

# tunctl -t tap0 -u 用户名
# chmod 0666 /dev/net/tun
网卡混杂模式
# ifconfig eth0 promisc // 设置eth0为混杂模式
# ifconfig tap0 promisc // 设置tap0为混杂模式
建立桥接接口
# brctl addbr br0
# brctl addif br0 eth0
# brctl addif br0 tap0
设置br0的IP
静态IP
# ifconfig br0 IP地址 netmask 掩码
# route add default gw 默认网关 dev br0
DHCP
# dhclient br0
常见应用
1. 查看网络接口使用什么驱动
[root@jianlee ~]# ethtool -i eth0
driver: 3c59x
version:
firmware-version:
bus-info: 0000:01:02.0
2. 查看网络接口link
[root@jianlee ~]# mii-tool
eth0: negotiated 100baseTx-FD, link ok
3. 网卡名字eth0,eth1修改
modprobe 中修改模块别名
使用 udev 的情况
fedora10 就是使用 udev 设置网卡的名字，比如我的系统有两块网卡，e1000e已经 坏了，3c59x还是好的。每次都认3c59x为eth1,即使我在 /etc/sysconfig/network-scripts/ifcfg-eth0 中设置了mac都不行。后来发现在 /etc/udev/rules.d/70-persistent-net.rules 下有这些内容 ：

# 3Com Corporation 3c905B 100BaseTX [Cyclone] (rule written by anaconda)
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:01:02:8c:50:09", ATTR{type}=="1", KERNEL=="eth*", NAME="eth1"
# Intel Corporation 82567LM-3 Gigabit Network Connection (rule written by anaconda)
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="88:88:88:88:87:88", ATTR{type}=="1", KERNEL=="eth*", NAME="eth0"
我把 eth0,和 eth1 名字交换。这样就可以了。

使用 ip link
ip link set eth0 name eth2
ip link set eth1 name eth0
ip link set eth2 name eth1
禁止某个 IP 访问
如果不需要用复杂的 iptables，可以简单地在 route 里加上一条：

route add -host IP-A gw 127.0.0.1
路由
参考： http://blog.ligj.eol.cn/628

route 命令
使用route 命令添加的路由，机器重启或者网卡重启后路由就失效了，方法：

添加到主机的路由
# route add –host 192.168.168.110 dev eth0
# route add –host 192.168.168.119 gw 192.168.168.1
添加到网络的路由
# route add –net IP netmask MASK eth0
# route add –net IP netmask MASK gw IP
# route add –net IP/24 eth1
添加默认网关
# route add default gw IP
删除路由
# route del –host 192.168.168.110 dev eth0
设置永久路由
/etc/rc.local
route add -net 192.168.3.0/24 dev eth0
route add -net 192.168.2.0/24 gw 192.168.3.254
在/etc/sysconfig/network里添加到末尾
方法：GATEWAY=gw-ip 或者 GATEWAY=gw-dev

/etc/sysconfig/static-router
any net x.x.x.x/24 gw y.y.y.y
