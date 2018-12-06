# 如何在ArchLinux上安装自签名证书

简单来说只有两行命令，将证书拷贝到指定目录下，然后更新证书信任列表

```shell
cp *.crt /usr/share/ca-certificates/trust-source/anchors
update-ca-trust  #或 trust extract-compat
```

这里是为了安装 mitmproxy 的ssl证书，便于拦截和 decode https请求，mitmproxy第一次启动时会自动生成自签名证书，证书存放在目录 `.mitmproxy/` 下

```
sudo cp .mitmproxy/mitmproxy-ca.pem	/usr/share/ca-certificates/trust-source/anchors/
sudo trust extract-compat
```

重要的是，更新证书后需要重启浏览器，才会重新加载系统证书