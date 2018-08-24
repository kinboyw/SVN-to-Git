## 安装完成以后需要执行的配置

第一步，配置 Git 的用户名和邮箱，这两项配置会在我们提交代码时被添加到提交信息中，这样我们查看历史的时候就可以看到这个提交作者的信息了，这两项时Git必须的设置

- `git config --global user.name <你的名字>`

- `git config --global user.email <你的邮箱地址>`


第二步，需要关闭 HTTPS 的验证，我们的Gitlab Server 的 HTTPS 使用的 ssl 证书是我们自己签发的，没有经过证书机构，因此当我们在浏览器中打开 `https://civpub.vicp.net:8443 ` 的时候会因为证书不可信被浏览器提示危险网站 ，同样，我们在用 Git 通过 Https 协议下载代码的时候，Git 也会对 Https 的 ssl 证书进行验证，这时候会因为证书不可信而中断，我们需要手动把这一步验证关掉，在命令行中执行下面的配置操作，然后重新 `clone` 

- `git config --global http.sslVerify false` 


第三步，检查我们的`core.autocrlf` 和 `core.safecrlf` 配置是否正确

- `git config --global core.autocrlf false` 要设置为false，这样 Git 会按照原样 `检出`和 `commit`代码，不会自动转换

- `git config --global core.safecrlf true` 要设置为true，当 Git 检测到我们的代码中存在 `CRLF`  和 `LF` 混用的情况时会组织我们提交。


第四步，允许Windows符号链接

- `git config --global core.symlinks true` ，这里设置为true才可以正确下载我们部分代码项目中的符号链接。

  此处执行了全局配置后，就不需要在`git clone` 时加上` -c core.symlinks=true`的参数了。但仍然需要管理员权限启动命令行。



## 其他配置

### 格式化日志输出

`git config --global alias.hist "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date='short'"`

执行上述命令设置日志输出格式，然后在命令行中执行`git hist` ，就可以查看当前仓库的提交历史。

也可以执行`gitk` ，打开一个简易的GUI程序，能够比较清晰得查看提交历史



### 密码管理

`git config --global credential.useHttpPath true` 

Git 使用Http(s)协议认证时，默认只匹配Url的域名部分，不能匹配到仓库的具体路径。举个例子说，Web4 和 ConfCenter 部署的Url域名部分是相同的，https://civgit.vicp.net:8443，先` Clone`  Web4时，我们输入了Web4 的部署的帐号密码，然后Windows凭据会记住这个Url和对应的帐号密码，然后当` Clone`  ConfCenter的时候，Git会先去Windows凭据中检查是否已经保存过这个Url的帐号密码，因为只保存了Url的域名部分，Web4 的Url域名部分与ConfCenter 是相同的，就会用Web4 的帐号密码来`clone` ConfCenter，就会报错。

解决办法：在命令行中执行上述全局配置后，我们在`clone` 时，输入帐号密码后 ，Git会将完整的Url保存到Windows凭据中，完整的Url包含了仓库的完整路径，那么Windows凭据中对应不同仓库的Url就是不同的，就不会出现匹配到错误的验证信息的问题了