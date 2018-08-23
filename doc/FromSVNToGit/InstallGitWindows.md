<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [安装Git-Windows](#%E5%AE%89%E8%A3%85git-windows)
  - [开始安装界面](#%E5%BC%80%E5%A7%8B%E5%AE%89%E8%A3%85%E7%95%8C%E9%9D%A2)
  - [安装路径](#%E5%AE%89%E8%A3%85%E8%B7%AF%E5%BE%84)
  - [建议全选](#%E5%BB%BA%E8%AE%AE%E5%85%A8%E9%80%89)
  - [菜单文件夹](#%E8%8F%9C%E5%8D%95%E6%96%87%E4%BB%B6%E5%A4%B9)
  - [选择Git默认编辑器](#%E9%80%89%E6%8B%A9git%E9%BB%98%E8%AE%A4%E7%BC%96%E8%BE%91%E5%99%A8)
  - [修改系统环境变量](#%E4%BF%AE%E6%94%B9%E7%B3%BB%E7%BB%9F%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F)
  - [SSL证书的选择](#ssl%E8%AF%81%E4%B9%A6%E7%9A%84%E9%80%89%E6%8B%A9)
  - [配置行尾结束符](#%E9%85%8D%E7%BD%AE%E8%A1%8C%E5%B0%BE%E7%BB%93%E6%9D%9F%E7%AC%A6)
  - [配置 Git 终端](#%E9%85%8D%E7%BD%AE-git-%E7%BB%88%E7%AB%AF)
  - [剩下的步骤默认就好了](#%E5%89%A9%E4%B8%8B%E7%9A%84%E6%AD%A5%E9%AA%A4%E9%BB%98%E8%AE%A4%E5%B0%B1%E5%A5%BD%E4%BA%86)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## 安装Git-Windows

Git-Windows 下载地址[Git-2.18.0-64-bit.exe](../../%E5%B7%A5%E5%85%B7/Git-2.18.0-64-bit.exe) 

### 开始安装界面

![img](https://upload-images.jianshu.io/upload_images/1625340-ed9bf0f750dd9dd9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/582) 

### 安装路径

![img](https://upload-images.jianshu.io/upload_images/1625340-4ea6a4a9f6a02d39.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/582) 

### 建议全选

![img](https://upload-images.jianshu.io/upload_images/1625340-be289d5604878843.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/582) 

### 菜单文件夹

![img](https://upload-images.jianshu.io/upload_images/1625340-2f31b5b0f9b7d7e8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/582)

### 选择Git默认编辑器

- 默认Vim，建议选择Notepad++或者vscode这样的图形化界面的工具作为编辑器，Vim是一个命令行的编辑器，不会的可能需要学习。

![1533100143040](../../imgs/1533100143040.png)

### 修改系统环境变量

- 默认选中间那个，建议从上面两个选项二选一

![img](https://upload-images.jianshu.io/upload_images/1625340-b8dcc9ec2d4c323b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/582) 

### SSL证书的选择

- 默认选上面那个

![img](https://upload-images.jianshu.io/upload_images/1625340-6d5a020a0eb30c66.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/580)

### 配置行尾结束符

- **这个地方请大家选择第三个** ，这里是一个巨坑，请注意 !!!!!!!!

- Windows换行符是CRLF，即我们常用的\r\n，Linux平台的换行符是LF，为了兼容跨平台开发的需求，Gti默认会使用下面第一个选项，Checkout Windows-style，commit Unix-style line endings，即签出时转换为Windows风格，提交时转换为Unix风格，如果选默认的，我们以后每次提交，代码都会被转换成Unix风格，因为我们全部是Windows平台开发的，代码都是Windows风格换行，而且命令行里会出现一大堆转换日志，十分不美观，而且没必要

- 这里我们选第三个选项，不执行自动转换，本地是什么风格，commit的时候就按原样提交

- 如果在安装这一步选错了，还可以通过命令行来配置该选项

  ```shell
  git config --global core.autocrlf false
  git config --global core.safecrlf true
  ```

  如果需要检查自己本地的配置是否正确，可以执行命令

  ```shell
  git config --global core.autocrlf 	#结果为false则是正确的，不执行自动转换
  git config --global core.safecrlf 	#结果为tru则是正确的，不允许混合风格的提交
  ```

  

![img](https://upload-images.jianshu.io/upload_images/1625340-6f1357783077497e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/582) 



### 配置 Git 终端

- 这里不了解的可以选择第一项，这个地方我选的第二项，没有出现异常

![img](https://upload-images.jianshu.io/upload_images/1625340-c8455f88430080cd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/582) 



### 剩下的步骤默认就好了

- 装好以后我们在桌面上就可以看到一个Git  Bash的快捷方式，这是一个ssh的命令行工具，打开它我们就可以在这里面用命令行完成大部分Git操作

- 同样的，我们也可以用Windows的 CMD 命令行工具来执行 Git 命令

