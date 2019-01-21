@echo off
title CloudPlatform 云平台自动部署服务安装
cls
color 4e

echo 当前脚本执行目录为 %~dp0
echo 脚本将在根目录 %CD:~0,3% 下完成安装包的下载和部署
echo.
echo.
echo 任意键继续

pause

cd %CD:~0,3%
echo.
echo 初次执行该脚本需要输入 Git 的部署口令，如下：
echo 用户名：gitlab+deploy-token-15
echo 密码：pa1dR2x36yVjEfuVgzPe
echo.

echo 执行下载命令 git clone -b deploy-12.8 https://g.civnet.cn:8443/CivPublish/CloudPlatformPublish.git
git clone -b deploy-12.8 https://g.civnet.cn:8443/CivPublish/CloudPlatformPublish.git

echo 仓库下载完成

echo 进入 CloudPlatformPublish 目录

cd CloudPlatformPublish

echo.
echo 为了确保IIS服务已安装，现在会执行IIS安装命令，安装命令不会影响已经发布的站点
echo

pause

echo 正在安装 IIS 服务，请耐心等候
echo.
START /WAIT DISM /Online /Enable-Feature /FeatureName:IIS-ApplicationDevelopment /FeatureName:IIS-ASP /FeatureName:IIS-ASPNET /FeatureName:IIS-BasicAuthentication /FeatureName:IIS-CGI /FeatureName:IIS-ClientCertificateMappingAuthentication /FeatureName:IIS-CommonHttpFeatures /FeatureName:IIS-CustomLogging /FeatureName:IIS-DefaultDocument /FeatureName:IIS-DigestAuthentication /FeatureName:IIS-DirectoryBrowsing /FeatureName:IIS-FTPExtensibility /FeatureName:IIS-FTPServer /FeatureName:IIS-FTPSvc /FeatureName:IIS-HealthAndDiagnostics /FeatureName:IIS-HostableWebCore /FeatureName:IIS-HttpCompressionDynamic /FeatureName:IIS-HttpCompressionStatic /FeatureName:IIS-HttpErrors /FeatureName:IIS-HttpLogging /FeatureName:IIS-HttpRedirect /FeatureName:IIS-HttpTracing /FeatureName:IIS-IIS6ManagementCompatibility /FeatureName:IIS-IISCertificateMappingAuthentication /FeatureName:IIS-IPSecurity /FeatureName:IIS-ISAPIExtensions /FeatureName:IIS-ISAPIFilter /FeatureName:IIS-LegacyScripts /FeatureName:IIS-LegacySnapIn /FeatureName:IIS-LoggingLibraries /FeatureName:IIS-ManagementConsole /FeatureName:IIS-ManagementScriptingTools /FeatureName:IIS-ManagementService /FeatureName:IIS-Metabase /FeatureName:IIS-NetFxExtensibility /FeatureName:IIS-ODBCLogging /FeatureName:IIS-Performance /FeatureName:IIS-RequestFiltering /FeatureName:IIS-RequestMonitor /FeatureName:IIS-Security /FeatureName:IIS-ServerSideIncludes /FeatureName:IIS-StaticContent /FeatureName:IIS-URLAuthorization /FeatureName:IIS-WebDAV /FeatureName:IIS-WebServer /FeatureName:IIS-WebServerManagementTools /FeatureName:IIS-WebServerRole /FeatureName:IIS-WindowsAuthentication /FeatureName:IIS-WMICompatibility /FeatureName:WAS-ConfigurationAPI /FeatureName:WAS-NetFxEnvironment /FeatureName:WAS-ProcessModel /FeatureName:WAS-WindowsActivationService

echo 安装 Windows 服务

echo 执行注册命令 WohiScheduleService.exe --install
WohiScheduleService.exe --install

echo 注册完成
echo 启动服务
net start WohiCloudScheduleTenant