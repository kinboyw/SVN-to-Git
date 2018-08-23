### 安装完成以后需要执行的配置

第一步，配置 Git 的用户名和邮箱，这两项配置会在我们提交代码时被添加到提交信息中，这样我们查看历史的时候就可以看到这个提交作者的信息了，这两项时Git必须的设置

- `git config --global user.name <你的名字>`

- `git config --global user.email <你的邮箱地址>`

  

第二步，需要关闭 HTTPS 的验证，我们的Gitlab Server 的 HTTPS 使用的 ssl 证书是我们自己签发的，没有经过证书机构，因此当我们在浏览器中打开 `https://civpub.vicp.net:8443 ` 的时候会因为证书不可信被浏览器提示危险网站 ，同样，我们在用 Git 通过 Https 协议下载代码的时候，Git 也会对 Https 的 ssl 证书进行验证，这时候会因为证书不可信而中断，我们需要手动把这一步验证关掉，在命令行中执行下面的配置操作，然后重新 `clone` 

- `git config --global http.sslVerify false` 

  

第三步，检查我们的`core.autocrlf` 和 `core.safecrlf` 配置是否正确

- `git config --global core.autocrlf false` 要设置为false，这样 Git 会按照原样 `检出`和 `commit`代码，不会自动转换

- `git config --global core.safecrlf true` 要设置为true，当 Git 检测到我们的代码中存在 `CRLF`  和 `LF` 混用的情况时会组织我们提交。

  

第四步，允许Windows符号链接

- `git config --global core.symlinks true` ，这里设置为true才可以正确下载我们部分代码项目