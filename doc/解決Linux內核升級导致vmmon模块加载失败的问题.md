# 解决 Linux 内核升级后导致 VMWare 无法启动虚拟机问题

> 故障描述：
>
> Could not open /dev/vmmon: No such file or directory. Please make sure that the kernel module `vmmon' is loaded

解决办法是，使用 `vmware-config.pl` 重新配置内核模块，而不用重新安装 VMWare 。

这个文件的默认存放目录是 `/usr/bin/vmware-config` 。

如果 VMWare 是6.5.x 或者更早的版本，就需要用 root 权限执行 `vmware-config.pl` 文件。

如果是 Workstation7 以上的版本，直接 `sudo vmware-modconfig --console --install-all` 。

命令执行完成后，就可以正常打开虚拟机了