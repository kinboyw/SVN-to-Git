# 如何使用 SSH 协议或获取 gitlab 仓库

### 什么是SSH

`SSH` 全称是 **Secure Shell** (**SSH**)，是一种安全加密的网络协议，不同于用户名/密码这种基础验证，SSH 类似于HTTPS，用到了非对称加密技术来保证连接安全，不过我们只是借它来绕过 HTTP 协议下存在的一些 But。

### SSH 如何工作

使用 SSH 时需要具备公/私钥对，我们一般在客户端用 openSSH 这样的实现了 SSH 协议的库来生成自己的公钥/私钥对，然后将公钥交给需要通信的服务器，服务器将客户端公钥保存在自己的授信列表中，然后客户端的私钥是唯一能够提供身份识别的标识，一旦丢失就无法恢复，任何人得到私钥都可以冒充你的身份和服务端通信。

客户端使用 SSH 和服务器通信时，会使用自己的私钥将通信内容加密，这段加密内容只能用跟这段私钥一起生成的公钥才能解密，服务器收到加密内容后，就去自己的授信列表中找能够解密内容的公钥，找到了就可以解密，然后与客户端通信，我解释的很小儿科，但过程其实是非常复杂的。

### gitlab 中如何使用 SSH？

gitlab 中有两个地方可以使用 SSH ：

- gitlab.wohitech.com 网站中注册用户的帐号设置里，这里是用于开发人员添加自己的 SSH 公钥，然后使用 SSH 同步代码的。设置位置在 - 登录gitlab.wohitech.com - 右上角头像 - Settings - SSH Keys - 根据提示填入 SSH 公钥。

- 部署环境（CivWebPublish）的仓库设置的 Deploy key里，这里是用于实施人员将部署环境的 SSH 公钥添加进来，用于同步部署环境更新的。设置位置在 - 登录 gitlab.wohitech.com - 进入部署环境仓库主页 - Settings - Repository - Deploy Keys - 按提示填入 SSH 公钥

### 怎么得到 SSH 公钥？

这里以实施部署环境为例：

- 登录或远程登录部署环境的服务器（只考虑 Windows 服务器）
- 安装 Git-windows 客户端，安装过程在[这里](https://gitlab.wohitech.com/wangjinbo/Svn-to-Git/blob/master/doc/FromSVNToGit/InstallGitWindows.md)。 （如果命令行中可以执行 git 命令，则跳过此步骤）
- 打开 Git-Bash 命令行，是 Git-Bash 命令行，不是 Windows Command Line，也不是 PowerShell。
- 执行命令 `ssh-keygen`， 然后一路回车，不用输入任何参数，最后会得到一副气泡图一样的矩形图像，就生成成功了

### 如何使用 SSH 密钥

- 命令行导航到用户家目录下，操作为执行命令 `cd` 

- 执行命令 `cat .ssh/id_rsa.pub` ，会得到很长的一串字符串，这就是公钥，选中并复制
- 实施拿到公钥后需要找研发或者实施有 gitlab.wohitech.com 帐号的同事，将公钥配置到仓库的 Deploy key 里面去。

在 gitlab.wohitech.com 中添加 Deploy key 后，就可以直接 clone 代码了，不需要像 HTTP 协议那样输入部署口令，命令行会自动使用你刚刚生成的 SSH 私钥去向 git 服务器发起请求，然后就开始下载了。

### SSH 相对 HTTP 有什么优势

- 安全就不必说了，只是我们工作环境对安全的需求还没有高到这种程度
- 学会了可以装13，毕竟这种东西在 Windows下的应用比较少，Linux中则是很常见的
- 多了一种选择吧，习惯以后就会觉得比 HTTP 方便
- 其实主要原因是最近 HTTP 下载出了一点问题，外网配置使用了 Nginx 反向代理，使用 HTTP 下载时会出现一些奇奇怪怪的bug，暂时没有找到解决办法。用 SSH 就没有问题



> P.S：[部署环境搭建，面向实施](https://gitlab.wohitech.com/wangjinbo/Svn-to-Git/blob/master/doc/%E9%83%A8%E7%BD%B2%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA--%E9%9D%A2%E5%90%91%E5%AE%9E%E6%96%BD.md#%E6%9B%B4%E6%96%B0-2018-12-05-gitlab-%E4%BD%BF%E7%94%A8-ssh-%E5%8D%8F%E8%AE%AE) 中更新了部署环境对应的 SSH 协议的仓库地址，如果是 clone 新仓库，则直接复制后执行 `clone` 命令即可；如果是更新已有仓库，则需要将原有的 https 协议的 origin 源的 URL 替换成 SSH 协议的新地址，当然如果 https 协议地址可以成功更新就不需要换；
>
> https 协议 origin 源替换成 ssh 协议的命令如下：
>
> ``` shell
> cd <仓库目录>		#或者打开仓库文件夹，右键，GitBash
> git remote -v 		#查看当前URL
> git remote set-url origin git@example.com:example/example.git		#设置SSH协议URL，URL需要根据实际情况修改
> ```
>