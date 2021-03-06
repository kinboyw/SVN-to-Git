

# CentOS7.4搭建L2TP/IPSec VPN Client

edited by 王进波 2018.09.07

安装ipsec和l2tp协议工具

```shell
sudo yum install libreswan xl2tpd
```

配置文件

```shell
# /etc/ipsec.d/work.conf

config setup
        keep-alive=300

conn Work
        authby=secret
        pfs=yes
        auto=add
        keyingtries=%forever
        dpddelay=30
        dpdtimeout=120
        dpdaction=restart
        rekey=yes
        rekeymargin=1h
        ikelifetime=8h
        keylife=1h
        type=transport
        left=%defaultroute
        leftprotoport=udp/l2tp
        right=civnet.vicp.net
        rightprotoport=udp/l2tp
        ike=aes_ctr,aes_cbc,camellia_cbc,serpent_cbc,twofish_cbc,3des,3DES-SHA1;MODP1024
        phase2alg=aes-HMAC_SHA1,3DES-HMAC_SHA1
        sha2-truncbug=yes
```

```shell
# cat /etc/ipsec.d/Work.secrets

%any civnet.vicp.net : PSK "civvpn.vicp.net"
```

```shell
# cat /etc/xl2tpd/xl2tpd.conf

[lac Work]
lns = civnet.vicp.net
ppp debug = yes
pppoptfile=/etc/ppp/options.ppp
length bit = yes
redial = yes
```

```shell
# cat /etc/ppp/options.ppp

ipcp-accept-local
ipcp-accept-remote
refuse-eap
require-mschap-v2
noccp
noauth
idle 86400
mtu 1400
mru 1400
nodefaultroute
debug
connect-delay 5000
name gitlabserver
password gitlabserver
```

查看日志

```shell
sudo tail -f /var/log/messages | grep -v "journal"
```

启动ipsec服务

```shell
sudo systemctl start ipsec
```

日志输出

```shell
Sep  7 20:05:55 gitlabserver systemd: Stopping Internet Key Exchange (IKE) Protocol Daemon for IPsec...
Sep  7 20:05:55 gitlabserver whack: 002 shutting down
Sep  7 20:05:55 gitlabserver systemd: Starting Internet Key Exchange (IKE) Protocol Daemon for IPsec...
Sep  7 20:05:55 gitlabserver ipsec: nflog ipsec capture disabled
Sep  7 20:05:55 gitlabserver systemd: Started Internet Key Exchange (IKE) Protocol Daemon for IPsec.
```

启动xl2tpd服务

```shell
sudo systemctl start xl2tpd
```

日志输出

```shell
Sep  7 20:08:38 gitlabserver pppd[8312]: Sent 714675 bytes, received 3429972 bytes.
Sep  7 20:08:38 gitlabserver pppd[8312]: Overriding mtu 1500 to 1400
Sep  7 20:08:38 gitlabserver pppd[8312]: Overriding mru 1500 to mtu value 1400
Sep  7 20:08:38 gitlabserver pppd[8312]: Terminating on signal 15
Sep  7 20:08:38 gitlabserver NetworkManager[898]: <info>  [1536322118.7692] device (ppp0): state change: disconnected -> unmanaged (reason 'connection-assumed', sys-iface-state: 'external')
Sep  7 20:08:44 gitlabserver pppd[8312]: Connection terminated.
Sep  7 20:08:44 gitlabserver avahi-daemon[830]: Withdrawing workstation service for ppp0.
Sep  7 20:08:44 gitlabserver pppd[8312]: Modem hangup
Sep  7 20:08:44 gitlabserver pppd[8312]: Exit.
Sep  7 20:08:44 gitlabserver systemd: Unit xl2tpd.service entered failed state.
Sep  7 20:08:44 gitlabserver xl2tpd: xl2tpd[31374]: Not looking for kernel SAref support.
Sep  7 20:08:44 gitlabserver xl2tpd: xl2tpd[31374]: Using l2tp kernel support.
Sep  7 20:08:44 gitlabserver xl2tpd: xl2tpd[31374]: xl2tpd version xl2tpd-1.3.8 started on gitlabserver.localdomain PID:31374
Sep  7 20:08:44 gitlabserver xl2tpd: xl2tpd[31374]: Written by Mark Spencer, Copyright (C) 1998, Adtran, Inc.
Sep  7 20:08:44 gitlabserver xl2tpd: xl2tpd[31374]: Forked by Scott Balmos and David Stipp, (C) 2001
Sep  7 20:08:44 gitlabserver xl2tpd: xl2tpd[31374]: Inherited by Jeff McAdams, (C) 2002
Sep  7 20:08:44 gitlabserver xl2tpd: xl2tpd[31374]: Forked again by Xelerance (www.xelerance.com) (C) 2006-2016
Sep  7 20:08:44 gitlabserver xl2tpd: xl2tpd[31374]: Listening on IP address 0.0.0.0, port 1701
```

创建连接

```shell
sudo ipsec auto --up work
sudo xl2tpd-control connect work
```

日志输出

```shell
Sep  7 20:12:24 gitlabserver xl2tpd: xl2tpd[20538]: Connecting to host civnet.vicp.net, port 1701
Sep  7 20:12:24 gitlabserver xl2tpd: xl2tpd[20538]: Connection established to 171.113.154.63, 1701.  Local: 45773, Remote: 36724 (ref=0/0).
Sep  7 20:12:24 gitlabserver xl2tpd: xl2tpd[20538]: Calling on tunnel 45773
Sep  7 20:12:24 gitlabserver xl2tpd: xl2tpd[20538]: Call established with 171.113.154.63, Local: 31692, Remote: 20120, Serial: 1 (ref=0/0)
Sep  7 20:12:24 gitlabserver pppd[31767]: Plugin pppol2tp.so loaded.
Sep  7 20:12:24 gitlabserver pppd[31767]: pppd 2.4.5 started by root, uid 0
Sep  7 20:12:24 gitlabserver NetworkManager[898]: <info>  [1536322344.5696] manager: (ppp0): new Ppp device (/org/freedesktop/NetworkManager/Devices/470)
Sep  7 20:12:24 gitlabserver pppd[31767]: Using interface ppp0
Sep  7 20:12:24 gitlabserver pppd[31767]: Connect: ppp0 <-->
Sep  7 20:12:24 gitlabserver pppd[31767]: Overriding mtu 1500 to 1400
Sep  7 20:12:24 gitlabserver pppd[31767]: Overriding mru 1500 to mtu value 1400
Sep  7 20:12:27 gitlabserver pppd[31767]: CHAP authentication succeeded: Access granted
Sep  7 20:12:27 gitlabserver pppd[31767]: CHAP authentication succeeded
Sep  7 20:12:27 gitlabserver pppd[31767]: local  IP address 10.1.0.2
Sep  7 20:12:27 gitlabserver pppd[31767]: remote IP address 10.1.0.1
Sep  7 20:12:27 gitlabserver NetworkManager[898]: <info>  [1536322347.5741] device (ppp0): state change: unmanaged -> unavailable (reason 'connection-assumed', sys-iface-state: 'external')
Sep  7 20:12:27 gitlabserver NetworkManager[898]: <info>  [1536322347.5746] device (ppp0): state change: unavailable -> disconnected (reason 'none', sys-iface-state: 'external')
```

检查路由，连接成功后会在系统路由中增加一个ppp0的网络接口

```shell
[gitlab@gitlabserver ~]$ route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.12.252  0.0.0.0         UG    100    0        0 enp2s0
10.1.0.1        0.0.0.0         255.255.255.255 UH    0      0        0 ppp0
172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
192.168.12.0    0.0.0.0         255.255.255.0   U     100    0        0 enp2s0
192.168.122.0   0.0.0.0         255.255.255.0   U     0      0        0 virbr0
```





参考文档

- [Securing L2TP using IPsec](https://tools.ietf.org/html/rfc3193)

- [Streisand](https://github.com/StreisandEffect/streisand/blob/master/README-chs.md)

- [How to Connect to L2TP/IPsec VPN on Linux](https://www.elastichosts.com/blog/linux-l2tpipsec-vpn-client/)
- [ SECURING VIRTUAL PRIVATE NETWORKS (VPNS) USING LIBRESWAN](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/sec-securing_virtual_private_networks)
- [[strongSwan] L2TP over strongswan](https://lists.strongswan.org/pipermail/users/2015-April/007964.html)
- [Linux VPN 客户端](https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/clients-zh.md#linux-vpn-%E5%AE%A2%E6%88%B7%E7%AB%AF)
- [VPN server for remote clients using IKEv1 with L2TP](https://libreswan.org/wiki/VPN_server_for_remote_clients_using_IKEv1_with_L2TP)
- [VPN Feature Guide for Security Devices](https://www.juniper.net/documentation/en_US/junos/information-products/pathway-pages/security/security-vpn-ipsec.html)
