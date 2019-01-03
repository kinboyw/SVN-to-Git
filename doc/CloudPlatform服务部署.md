# CloudPlatform服务部署

## TenantServer部署

### 部署环境

- Windows Server 2016 Standard (Datacenter 版本可能会出现权限问题)
- .Net Framework 4.6
- 操作系统管理员权限
- 访问 http://192.168.12.1:8000/ ，能够打开Zabbix 管理后台登录页面

### 基础软件服务检查

- SQL Server (MSSQLSERVER)，确认服务已开启，并监听默认 `1433` 端口

  > 端口测试可以运行命令行 `telnet localhost 1433` ，如果没有安装 `telnet` 客户端，可以运行命令行 `netstat -ano | findstr :1433` ，如果有结果则表示已监听1433端口

- MongoDB，确认服务开启，并监听默认端口 `27017`

- Java环境，检查环境变量或者运行命令 `Java -version` 

-  IIS 服务开启，浏览器访问 `localhost` ，能打开 IIS 管理页

- Git，运行命令 `git --version` 

### 安装步骤

#### 下载 `TenantServer` 

```
git clone git@gitlab.wohitech.com:CivPublish/CloudWebPublish.git TenantServer
```

如果服务器提示拒绝，则用 `powershell` 运行如下命令生成公钥

```
ssh-keygen
```

一直回车，直到出现气泡图，运行如下命令

```
cat ~/.ssh/id_rsa.pub
```

将打印出的密文字符串完整复制后发给王进波，确认在服务端添加部署环境的公钥后再次执行上面的 `git clone` 命令。详细说明见：[如何使用ssh协议获取gitlab仓库的代码](./如何使用ssh协议获取gitlab仓库的代码.md)  

#### 修改配置

服务配置文件为 `TenantServer` 目录下的 `WohiScheduleService.exe.config` ，大部分配置项都有默认值，需要修改的配置项列举如下，`<!--这是一条注释-->` ：

```xml
<!--主站host,即协议头+IP地址+端口-->
<add key="CityService" value="http://192.168.12.8:8088" />

<!--调度服务AdminServer所在服务器IP地址-->
<add key="PingIP" value="192.168.12.8" />

<!--沃海云平台主站点的数据库连接-->
<add key="ConnectionString" value="server=192.168.12.8;database=wisdomwater;uid=sa;pwd=sa" />

<!--MongoDB连接信息-->
<add key="MongoDBUrl" value="mongodb://192.168.12.8:27017/DMAControl?connectTimeoutMS=5000;maxIdleTimeMS=300000" />
<!--主站IP--> <!--冗余配置项，是遗留问题，后期去掉-->
<add key="SiteHost" value="192.168.12.8" />
<!--主站外网域名--> 
<add key="mainserver" value="https://gck.wohitech.com/" />

<!--git同步账户及Url，如果无法访问civgit.vicp.net动态域名的连接，需要换成 gitlab.wohitech.com-->
		<add key="CloudWebPublish_giturl" value="https://civgit.vicp.net:8443/CivPublish/CloudWebPublish.git" />
		<add key="CloudWebPublish_user" value="gitlab+deploy-token-9" />
		<add key="CloudWebPublish_password" value="GvFzys3XoSs_yqmUsgjy" />



<!--以下配置需要根据后续步骤进行修改-->

<!--站点模板目录，默认为：D:\WohiSite\Template-->
<add key="TEMPLATEPATH" value="D:\WohiSite\Template" />

<!--MSSQL SERVER数据库备份文件名称，用于子站还原，默认为DMAS87XX.bak,位置为TEMPLATEPATH配置的路径下-->
<add key="SiteBackupDB" value="DMAS87XX.bak" />

<!--站点模板文件夹名称，默认为 S87XX,位置为TEMPLATEPATH配置的路径-->
<add key="SiteFolderName" value="S87XX" />
```

#### 部署子站模板

子站模板是位于 `TenantServer/packages`目录下的 `Template.zip` 压缩包文件。

- 首先，需要在系统中指定子站部署路径，默认为 `D:\WohiSite` ，根据系统硬盘容量，如果可以将D盘作为部署盘，则创建 `D:\WohiSite` 目录
-  拷贝 `Template.zip` 至 `D:\WohiSite` 并 解压至当前文件夹，注意解压后的 `Template` 文件夹内部是模板文件，不能嵌套 `Template` 文件夹
- 修改配置文件，将配置项 `<add key="TEMPLATEPATH" value="D:\WohiSite\Template" />` 的 value 值设置为实际路径，这里为  `D:\WohiSite\Template`
- 如果解压后没有修改数据库备份文件名称和站点模板文件夹名称，则 `SiteBackupDB` 与 `SiteFolderName` 配置项不需要修改

#### 安装TenantServer 为 WindowsService

- 方法一，管理员权限运行 `TenantServer` 目录下的 `install.bat` 脚本，按说明安装
- 方法二，管理员权限启动命令行，用 `cd /d D:/TenantServer` 命令导航到`TenantServer` 文件夹所在路径，输入 `WohiScheduleService.exe --install` 命令，回车
- 方法三，用 `installUtil.exe` 或者 `sc` 命令安装，具体方法百度

#### 检查安装是否成功

- 打开服务面板，搜索 `WohiCloud` ，查看有没有 `WohiCloudScheduleTenant` 这个服务

- 如果 找到的是 `WohiCloudScheduleAdmin` ，则需要将配置文件中的  `ServiceType` 配置项改为 `2` ，卸载后再次安装

- 如果安装成功，则 `启动`服务，并确定服务启动类型是否设置为 `自动`

- 检查日志，位于 `TenantServer` 的 `logs` 目录下，找到当天日期的日志，建议用 `tail -f log-190101.txt` 的命令查看日志，它会读取日志末尾最新的若干行，并且自动刷新。

  > P.S 如果Windows中无法执行 `tail` 命令，可以去下载一个 cmder 这个终端模拟器，在上面执行上述命令。

如果日志输出服务器注册成功，则该服务器已经被添加到子站服务器集群中，成为可以创建子站站点的服务器了

如果注册不成功，则可能的原因有，该服务器的IP地址不能被 Zabbix 服务器识别，需要配置 Zabbix 服务器