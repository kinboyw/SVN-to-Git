@echo off
title CloudPlatform ��ƽ̨�Զ��������װ
cls
color 4e

echo ��ǰ�ű�ִ��Ŀ¼Ϊ %~dp0
echo �ű����ڸ�Ŀ¼ %CD:~0,3% ����ɰ�װ�������غͲ���
echo.
echo.
echo ���������

pause

cd %CD:~0,3%
echo.
echo ����ִ�иýű���Ҫ���� Git �Ĳ��������£�
echo �û�����gitlab+deploy-token-15
echo ���룺pa1dR2x36yVjEfuVgzPe
echo.

echo ִ���������� git clone -b deploy-12.8 https://g.civnet.cn:8443/CivPublish/CloudPlatformPublish.git
git clone -b deploy-12.8 https://g.civnet.cn:8443/CivPublish/CloudPlatformPublish.git

echo �ֿ��������

echo ���� CloudPlatformPublish Ŀ¼

cd CloudPlatformPublish

echo.
echo Ϊ��ȷ��IIS�����Ѱ�װ�����ڻ�ִ��IIS��װ�����װ�����Ӱ���Ѿ�������վ��
echo

pause

echo ���ڰ�װ IIS ���������ĵȺ�
echo.
START /WAIT DISM /Online /Enable-Feature /FeatureName:IIS-ApplicationDevelopment /FeatureName:IIS-ASP /FeatureName:IIS-ASPNET /FeatureName:IIS-BasicAuthentication /FeatureName:IIS-CGI /FeatureName:IIS-ClientCertificateMappingAuthentication /FeatureName:IIS-CommonHttpFeatures /FeatureName:IIS-CustomLogging /FeatureName:IIS-DefaultDocument /FeatureName:IIS-DigestAuthentication /FeatureName:IIS-DirectoryBrowsing /FeatureName:IIS-FTPExtensibility /FeatureName:IIS-FTPServer /FeatureName:IIS-FTPSvc /FeatureName:IIS-HealthAndDiagnostics /FeatureName:IIS-HostableWebCore /FeatureName:IIS-HttpCompressionDynamic /FeatureName:IIS-HttpCompressionStatic /FeatureName:IIS-HttpErrors /FeatureName:IIS-HttpLogging /FeatureName:IIS-HttpRedirect /FeatureName:IIS-HttpTracing /FeatureName:IIS-IIS6ManagementCompatibility /FeatureName:IIS-IISCertificateMappingAuthentication /FeatureName:IIS-IPSecurity /FeatureName:IIS-ISAPIExtensions /FeatureName:IIS-ISAPIFilter /FeatureName:IIS-LegacyScripts /FeatureName:IIS-LegacySnapIn /FeatureName:IIS-LoggingLibraries /FeatureName:IIS-ManagementConsole /FeatureName:IIS-ManagementScriptingTools /FeatureName:IIS-ManagementService /FeatureName:IIS-Metabase /FeatureName:IIS-NetFxExtensibility /FeatureName:IIS-ODBCLogging /FeatureName:IIS-Performance /FeatureName:IIS-RequestFiltering /FeatureName:IIS-RequestMonitor /FeatureName:IIS-Security /FeatureName:IIS-ServerSideIncludes /FeatureName:IIS-StaticContent /FeatureName:IIS-URLAuthorization /FeatureName:IIS-WebDAV /FeatureName:IIS-WebServer /FeatureName:IIS-WebServerManagementTools /FeatureName:IIS-WebServerRole /FeatureName:IIS-WindowsAuthentication /FeatureName:IIS-WMICompatibility /FeatureName:WAS-ConfigurationAPI /FeatureName:WAS-NetFxEnvironment /FeatureName:WAS-ProcessModel /FeatureName:WAS-WindowsActivationService

echo ��װ Windows ����

echo ִ��ע������ WohiScheduleService.exe --install
WohiScheduleService.exe --install

echo ע�����
echo ��������
net start WohiCloudScheduleTenant