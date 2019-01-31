# ArchLinux 中设置 Wine 调用 iBus

前言：

如果你是**fcitx输入法用户**，那么这篇文章大可不必看。fcitx是一个非常强大的框架，著名[搜狗输入法](http://pinyin.sogou.com/linux/)就是基于fcitx输入法架构开发的。据我所知。您遇到这个问题可以通过**卸载ibus输入法进行修复**。（在ubuntu等系统中fcitx中必ibus优先级低，所以需要卸载ibus进行修复）

ibus输入法用户可以继续往下看，**ibus架构推荐rime输入法**。

![img](https://images2015.cnblogs.com/blog/952608/201606/952608-20160624195252188-2039130374.png)

------

首先，系统中用户目录下几个文件。您要有所了解，他们是：

- $HOME/.profile：该文件是用户环境配置文件。（在非 ArchLinux 中还有其他名称 “.bash_profile”。意思一样，发行版本不同）
- $HOME/.bash_logout ：该文件作为用户退出登录时执行的配置文件。

- **/etc/****profile*****：该文件是用户环境配置文件。***（在读取$HOME失败时会读取该文件，对全局所有用户生效）
- /etc/bash.bash_logout ：类似，同上。
- source 命令可以作为立即生效使用：***source /etc/profile***

------

那么怎么使用呢。就是在**$HOME/.profile**输入以下代码：

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="zh_CN.utf8"
export LC_COLLATE="en_US.UTF-8"
export LC_ALL=""

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export XIM=ibus
export QT_IM_MODULE=ibus
export XIM_ARGS="ibus-daemon -d -x"

这样还不够。你还需要在**/etc/profile**中添加

ibus-daemon -d -x

让ibus输入法开机自行启动。-d表示静默后台系统，-x（--xim）表示使用X server模式。