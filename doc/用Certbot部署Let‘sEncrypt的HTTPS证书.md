# 用 Certbot 部署 Let's Encrypt 的 HTTPS 证书

这个操作在 Linux 下很方便，一行命令就可以搞定，Windows 上还是折腾了一番，找了很多文档都对不上我的需求，最后在[官方文档](https://certbot.eff.org/docs/using.html#manual)这里得到了答案。简述过程如下：

### 安装python

安装过程略，但是在后面几步要勾选安装 pip 包管理工具

### 安装 Certbot

```shell

```

### 开始生成证书

 静静地等待安装完成

```shell
C:\Users\Administrator>certbot certonly --manual --preferred-challenges dns --email wohitech@qq.com -d haian.wohitech.com
Saving debug log to C:\Certbot\log\letsencrypt.log
Plugins selected: Authenticator manual, Installer None
Obtaining a new certificate
Performing the following challenges:
dns-01 challenge for haian.wohitech.com

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
NOTE: The IP of this machine will be publicly logged as having requested this
certificate. If you're running certbot in manual mode on a machine that is not
your server, please ensure you're okay with that.

Are you OK with your IP being logged?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: y
```

`--manual` 这个参数，根据官网的解释，意思是你运行 `certbot` 命令的机器不是你部署证书的目标机器时使用。我们就用这个命令

`--preferred-challenges dns` ，这个参数除了 `dns` 以外，还有 `http` 和 `tls-sni` 两个选项，他们都是为 certbot 提供质询的不同方式，certbot 要通过它们来证明你对要部署的域名的持有权限。`http` 就是它会给你一串密钥，按照要求把它保存在你站点指定目录下的某个文件中，然后验证时就会访问这个文件，我司网站部署离奇复杂，这种方式尝试失败，没有继续研究；用 `dns` 比较简单快捷，只需要在域名管理控制台中增加一条 `TXT` 解析记录就可以了；`tls-sni` 这个没有研究。

`--email` 提供一个反馈邮箱，https 证书快要过期时会给你发邮件，如果不在命令中提供，它也会问你要。

`-d` 后面就是你要部署的域名，可以一次写多个 `-d` 参数，就可以实现批量部署

回答 Y 就可以了。

接着会给你生成一串用于配置 `dns` 的解析记录的键值对

```shell
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name
_acme-challenge.haian.wohitech.com with the following value:

eDhLhhaaal5SUpAzMsMTdc5IoleG_RkZXFV0W-nTMW8

Before continuing, verify the record is deployed.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue
```

这个时候不要着急去回车，按照要求，将 `dns` 解析配到域名解析的控制台中去

新增记录

- 主机记录为 `_acme-challenge.haian` ，腾讯云要求只写这部分，有的可能要写完整的 `_acme-challenge.haian.wohitech.com` 
- 记录类型为 `TXT` 
- 记录值为 `eDhLhhaaal5SUpAzMsMTdc5IoleG_RkZXFV0W-nTMW8`

配置完成后用 Linux 命令行验证配置成功

```shell

```

结果如下

```shell

```

记录解析成功

然后回到部署 HTTPS 的命令行，继续，点回车

```shell

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name
_acme-challenge.haian.wohitech.com with the following value:

eDhLhhaaal5SUpAzMsMTdc5IoleG_RkZXFV0W-nTMW8

Before continuing, verify the record is deployed.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue
Waiting for verification...
Cleaning up challenges
[1m
IMPORTANT NOTES:
[0m - Congratulations! Your certificate and chain have been saved at:
   C:\Certbot\live\haian.wohitech.com\fullchain.pem
   Your key file has been saved at:
   C:\Certbot\live\haian.wohitech.com\privkey.pem
   Your cert will expire on 2019-03-16. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

生成的证书会保存在给定的目录中，如上所示，`C:\Certbot\live\haian.wohitech.com\` 路径下，并且有效期只有 3 个月，到期后需要 `renew` 来更新证书。

### 部署证书到 Nginx 中

到 `C:\Certbot\live\haian.wohitech.com\` 目录下找到生成的 `cert.pem` 和 `privkey.pem` 文件，分别重命名后配置到 Nginx 的 `ssl_certificate` 和 `ssl_certificate_key` 参数上。

完