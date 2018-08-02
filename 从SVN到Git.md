# 从SVN到Git

## 安装Git-Windows

Git-Windows [下载地址](https://git-scm.com/) ，在Git官网找到下载的链接 ，下载对应操作系统版本的 Git 安装包。虽然提供了下载好的安装程序，但是仍然建议大家自己动手去熟悉这个过程。



> Git-Windows 安装过程如下，Git-Windows是Windows版本的命令行 Git 客户端工具，安装完以后就可以在命令行中完成大多数代码同步操作



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

![1533100143040](/imgs/1533100143040.png)

### 修改系统环境变量 

- 默认选中间那个，建议从上面两个选项二选一

![img](https://upload-images.jianshu.io/upload_images/1625340-b8dcc9ec2d4c323b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/582) 

### SSL证书的选择 

- 默认选上面那个

![img](https://upload-images.jianshu.io/upload_images/1625340-6d5a020a0eb30c66.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/580)

### 配置行尾结束符

- **这个地方请大家选择第三个** ，这里是一个巨坑，请注意
- 不同操作系统下的换行符有不同规范，Windows使用CRLF（即回车 + 换行： \r\n）结束一行，Mac和 Linux下使用LF（即换行：\r）结束一行。
- 我们目前基本在Windows平台上开发和部署，不涉及跨平台问题，过去我们在编辑器（VS）中一般默认使用的是CRLF行尾结束符，过去我们使用的 SVN 仓库里也是使用的 CRLF，因此目前我们在 Git 中继续使用 CRLF 规范，作为开发者，我们需要统一规范，避免代码中出现行尾结束符混用的问题。
- Git 一开始是用于管理Linux内核代码的，后来推广开以后，为了兼容Windows操作系统，它提供了一些行尾结束符转换的策略，这些策略可以在我们 `检出` 和 `commit` 代码的时候，由Git自动帮助我们完成 CRLF 和 LF 的转换。
- 这个地方，我们不采用用 Git 的自动转换策略，我们希望在 `检出` 和 `commit` 代码的时候保留代码原有的行尾结束符。

![img](https://upload-images.jianshu.io/upload_images/1625340-6f1357783077497e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/582) 



### 配置 Git 终端

- 这里不了解的可以选择第一项，这个地方我选的第二项，没有出现异常

![img](https://upload-images.jianshu.io/upload_images/1625340-c8455f88430080cd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/582) 



### 剩下的步骤默认就好了

- 装好以后我们在桌面上就可以看到一个Git  Bash的快捷方式，这是一个ssh的命令行工具，打开它我们就可以在这里面用命令行完成大部分Git操作

- 同样的，我们也可以用Windows的 CMD 命令行工具来执行 Git 命令

- 安装完成以后需要执行的配置

  > 第一步，配置 Git 的用户名和邮箱，这两项配置会在我们提交代码时被添加到提交信息中，这样我们查看历史的时候就可以看到这个提交作者的信息了，这两项时Git必须的设置
  >
  > - `git config --global user.name <你的名字>`
  > - `git config --global user.email <你的邮箱地址>`

  

  > 第二步，需要关闭 HTTPS 的验证，我们的Gitlab Server 的 HTTPS 使用的 ssl 证书是我们自己签发的，没有经过证书机构，因此当我们在浏览器中打开 `https://civpub.vicp.net:8443 ` 的时候会因为证书不可信被浏览器提示危险网站 ，同样，我们在用 Git 通过 Https 协议下载代码的时候，Git 也会对 Https 的 ssl 证书进行验证，这时候会因为证书不可信而中断，我们需要手动把这一步验证关掉，在命令行中执行下面的配置操作，然后重新 `clone` 
  >
  > - `git config --global http.sslVerify false` 

  

  > 第三步，检查我们的`core.autocrlf` 和 `core.safecrlf` 配置是否正确
  >
  > - `git config --global core.autocrlf` 要设置为false，这样 Git 会按照原样 `检出`和 `commit`代码，不会自动转换
  > - `git config --global core.safecrlf` 要设置为true，当 Git 检测到我们的代码中存在 `CRLF`  和 `LF` 混用的情况时会组织我们提交。



## 安装TotoiseGit

### 配置CRLF 自动转换

> TotoiseGit，是一个绑定右键菜单的图形化界面的 Git 客户端工具， 跟我们熟悉的 TotoiseSVN 界面和操作方式十分相似，不建议对 Git 没有了解的情况下直接上手使用它

在安装TotoiseGit 后同样需要进行配置

![first-trap-on-github-autocrlf-tortoisegit](https://camo.githubusercontent.com/8d6a7962aba0ce4e94ec32e4bf788360a84b301f/68747470733a2f2f662e636c6f75642e6769746875622e636f6d2f6173736574732f313233313335392f3937343136322f31363930353264342d303634632d313165332d393434352d3535656637303238623633632e706e67) 



## Git 常识

- 分布式，即 Git 的每一个 clone 都与其他 repository 一样，包含了所有分支的全部提交历史
- 差异化存储，





## Git 常用操作命令

- `git init`
- `git clone`
- `git add`
- `git commit`
- `git push`
- `git fetch`
- `git pull`
- `git config`
- ` git remote`
- `git status`
- `git branch`
- `git checkout`



## Git 账号
GitlabServer:  http://civpub.vicp.net:8880

推荐的两处学习资源

[沉浸式学Git](http://igit.linuxtoy.org/contents.html) 

[官方推荐书籍](https://git-scm.com/book/zh/v2) 

[Git - 简明学习指南](http://rogerdudler.github.io/git-guide/index.zh.html) 

大家用自己的帐号登录后修改登录密码和关联的邮箱
Git通过配置的用户名和邮箱来标记每次提交的作者

| 部门       | 姓名   | GitLabUser  | Password    |
| ---------- | ------ | ----------- | ----------- |
| 管理组     | 董鑫   | dongxin     | ZG9uZ3hpbg  |
| 管理组     | 丁都   | dingdu      | ZGluZ2R1    |
| 物联通讯   | 叶飞   | yefei       | 116d5e26    |
| 应用研发部 | 周盼盼 | zhoupanpan  | 857bbd05    |
| 应用研发部 | 李纪文 | lijiwen     | ee15c5c5    |
| 应用研发部 | 喻天   | yutian      | OGJkMDJhYWI |
| 模型研发部 | 徐鸿   | xuhong      | ZmI0ZWQ5NDE |
| 模型研发部 | 谢礼   | xieli       | YTc1MjEyYWM |
| 模型研发部 | 杨思琦 | yangsiqi    | NDI2Y2ZjOTg |
| 算法研发部 | 邹舒畅 | zousuchang  | ODFjOTA1M2E |
| 算法研发部 | 李涛涛 | litaotao    | NzBlYTM2MGE |
| 移动研发部 | 马永欣 | mayongxin   | NjdhYjA2MTY |
| 移动研发部 | 张思源 | zhangsiyuan | MzdiM2Q0Yjk |
| 测试部     | 张小玉 | zhangxiaoyu | MWUzZDYyNmM |
| 测试部     | 李骏杰 | lijunjie    | YmI4MzQwMzY |



## 创建新仓库

### 登录Web前端

![1533175137097](/imgs/1533175137097.png)

### 新建项目

先确定该项目是隶属于个人还是分组，如果是分组项目，则进入相应的分组下再创建项目

![1533175217363](/imgs/1533175217363.png)



新建项目

> 1. 检查项目Url里的第二部分对应的分组名称是否正确，当该用户对多个分组有权限时，可能将项目创建到错误的分组中去，这里要检查一下
> 2. 为新项目命名
> 3. 确定项目的可见性等级
> 4. 创建项目

![1533175437071](/imgs/1533175437071.png)





创建成功

![1533175495615](/imgs/1533175495615.png)



### 初始化本地仓库

这一步是将本地已经存在的代码项目初始化成一个Git仓库

> 当我们上一步创建的Git项目还不存在时，我们只需要将空项目`clone`到本地，然后在本地的working copy 中添加代码，这与SVN是类似的



这是一个不包含 `.git` 文件夹的工程

![1533175761038](/imgs/1533175761038.png)



```bash
cd /d F:\jekyllTest\mysite	#用命令行 cd 到这个路径下
git init	#执行初始化操作
```

提示初始化成功

![1533175909218](/imgs/1533175909218.png)

我们再看看文件夹下面已经生成了`.git`文件夹

![1533175937707](/imgs/1533175937707.png)

对于全新安装的Git·Windows ，我们还要进行一些初始化设置，记得吗，这里就再啰嗦一下

```bash
git config --global user.name wangjinbo			#全局添加作者名称
git config --global user.email vannue@qq.com	#全局添加用户邮箱

git config --global http.sslVerify false		#设置Git忽略ssl验证，免得我们用https下载代码会出错

git config --global core.autocrlf false		#关闭行尾结束符自动转换
git config --global core.safecrlf true		#打开安全crlf	
```

然后，我们要将Web前端创建的远程仓库的Url添加到本地的origin标识中

```shell
git remote add origin https://civpub.vicp.net:8443/TestUse/test.git	#这里我们默认使用https
git remote 	#该命令检查本地配置的远程标识，可能存在多个远程url
git remote -v	#查看当前远程url的详细信息
```

```shell
git add . 	#将当前目录下的所有文件和子文件夹内的文件添加到track版本控制，add命令在不同情景下含义不同，对新增文件还没有被track，add命令将其添加到版本控制，并添加到暂存区；对于已经被track的文件，add命令将修改添加到暂存区
git status 	#查看当前工作目录的状态
```

![1533176963094](/imgs/1533176963094.png)

```shell
git commit -m "initial commit"	#提交暂存区中的修改，双引号内的内容为提交的注释
```

![1533177035857](/imgs/1533177035857.png)

```shell
git push origin master	#将当前工作目录中的所有提交推送到远端仓库，origin指向了 https://civpub.vicp.net:8443/TestUse/test.git，master是新建仓库的默认分支，我们将代码提交到master分支
#master 分支是默认受保护分支，执行push操作需要用户具有高于Developer的权限
```

Powershell中完整的输入输出如下

```powershell
PS F:\jekyllTest\mysite> git init
Initialized empty Git repository in F:/jekyllTest/mysite/.git/
PS F:\jekyllTest\mysite>  git remote
PS F:\jekyllTest\mysite> git remote add origin https://civpub.vicp.net:8443/TestUse/test.git
PS F:\jekyllTest\mysite> git remote
origin
PS F:\jekyllTest\mysite> git add .
PS F:\jekyllTest\mysite> git commit -a
Aborting commit due to empty commit message.
PS F:\jekyllTest\mysite> git commit -m "initial commit"
[master (root-commit) 48e9af5] initial commit
 13 files changed, 2047 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 404.html
 create mode 100644 Gemfile
 create mode 100644 Gemfile.lock
 create mode 100644 _config.yml
 create mode 100644 _posts/2014-3-3-Hello-World.md
 create mode 100644 _posts/2018-07-21-welcome-to-jekyll.markdown
 create mode 100644 _posts/2018-7-14-Explorer-JavaScript-For-in-loops.md
 create mode 100644 _posts/2018-7-17-How Does Browser Work.md
 create mode 100644 _posts/2018-7-21-Setting-up-a-repository.md
 create mode 100644 about.md
 create mode 100644 index.md
 create mode 100644 test.txt
PS F:\jekyllTest\mysite> start .
PS F:\jekyllTest\mysite> start .
PS F:\jekyllTest\mysite> git init
Initialized empty Git repository in F:/jekyllTest/mysite/.git/
PS F:\jekyllTest\mysite> git remote -v
PS F:\jekyllTest\mysite> git remote add origin https://civpub.vicp.net:8443/TestUse/test.git
PS F:\jekyllTest\mysite> git remote -v
origin  https://civpub.vicp.net:8443/TestUse/test.git (fetch)
origin  https://civpub.vicp.net:8443/TestUse/test.git (push)
PS F:\jekyllTest\mysite> git add .
PS F:\jekyllTest\mysite> git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

        new file:   .gitignore
        new file:   404.html
        new file:   Gemfile
        new file:   Gemfile.lock
        new file:   _config.yml
        new file:   _posts/2014-3-3-Hello-World.md
        new file:   _posts/2018-07-21-welcome-to-jekyll.markdown
        new file:   _posts/2018-7-14-Explorer-JavaScript-For-in-loops.md
        new file:   _posts/2018-7-17-How Does Browser Work.md
        new file:   _posts/2018-7-21-Setting-up-a-repository.md
        new file:   about.md
        new file:   index.md
        new file:   test.txt

PS F:\jekyllTest\mysite> git commit -m "initial commit"
[master (root-commit) 8d9003f] initial commit
 13 files changed, 2047 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 404.html
 create mode 100644 Gemfile
 create mode 100644 Gemfile.lock
 create mode 100644 _config.yml
 create mode 100644 _posts/2014-3-3-Hello-World.md
 create mode 100644 _posts/2018-07-21-welcome-to-jekyll.markdown
 create mode 100644 _posts/2018-7-14-Explorer-JavaScript-For-in-loops.md
 create mode 100644 _posts/2018-7-17-How Does Browser Work.md
 create mode 100644 _posts/2018-7-21-Setting-up-a-repository.md
 create mode 100644 about.md
 create mode 100644 index.md
 create mode 100644 test.txt
PS F:\jekyllTest\mysite> git status
On branch master
nothing to commit, working tree clean
PS F:\jekyllTest\mysite> git push origin master
Counting objects: 16, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (15/15), done.
Writing objects: 100% (16/16), 41.37 KiB | 3.76 MiB/s, done.
Total 16 (delta 0), reused 0 (delta 0)
remote: GitLab: You are not allowed to push code to protected branches on this project.
To https://civpub.vicp.net:8443/TestUse/test.git
 ! [remote rejected] master -> master (pre-receive hook declined)
error: failed to push some refs to 'https://civpub.vicp.net:8443/TestUse/test.git'
PS F:\jekyllTest\mysite>
#最后这里因为我用wangjinbo这个用户执行的push到master分支的操作，wangjinbo在test组的权限是developer，developer不允许向master推送提交
```

进Web前端，查看代码，成功

![1533177684026](/imgs/1533177684026.png) 



## 命令行演示常用操作

### git clone - 远程仓库

这一步是我们开始用git的第一步操作，因为我们之前SVN中的代码全都迁到了Git，大家开始工作第一步就是从Git仓库里面下载代码到本地，这一步与SVN类似。

```shell
cd /d E:\Codes\City #我们先用CMD命令行的CD命令导航到我们习惯存放代码的路径下
git clone https://civpub.vicp.net:8443/TestUse/test.git CityTest #clone远程仓库
```

![1533178094362](/imgs/1533178094362.png)

现在我们就可以看到下载下来的本地工作目录了

![1533178164862](/imgs/1533178164862.png)

### 修改文档

现在我们可以开始工作了，我们新增一些文件，然后修改一些文件，删除一些文件

### git add - 添加修改到暂存区

然后我们需要将修改`add`到暂存区，然后完成`commit` 提交和`push`推送

```shell
cd test	#导航到工作目录，不然无法执行git命令的，会提示当前目录非git目录
git status	#经常执行这个命令是个好习惯
```

git status 命令列出了我们当前工作目录下所作的全部修改

我们可以看到包含了两个部分，第一个部分列出了我们修改的文件

> Changes not staged for commit:
>   (use "git add <file>..." to update what will be committed)
>   (use "git checkout -- <file>..." to discard changes in working directory)
>
> ​	 modified:   about.md

第二个部分列出了我们新增的一个文件，由于是新增的，我们还没有对它进行版本控制，即track

> Untracked files:
>   (use "git add <file>..." to include in what will be committed)
>
> ​    the added file.txt

![1533178455603](/imgs/1533178455603.png)

我们执行`git add` 命令将这两处改动添加到暂存区

```shell
git add .	#这里 ‘.’ 符号是一个用通配符批量添加的方式，我们也可以将 ‘.’替换成单个改动文件的路径来针对性添加
git status	#添加完成后检查状态，好习惯
```

![1533178880943](/imgs/1533178880943.png)

绿色标识添加操作成功，这是非常符合我们一般习惯的表达，然后它还温馨地给出了提示，如果需要撤销暂存操作，执行

```shell
git reset HEAD <file>...
```

### git commit - 提交暂存区地修改

现在我们将暂存区中地修改进行一次提交

```shell
git commit -m "modified about.md and added 'the added file.txt'"
git status	
```

![1533179110870](/imgs/1533179110870.png)

git status 命令告诉我们，没有当前工作目录没有需要提交地修改了，并且告诉我们，我们比"origin/master"超前了一次提交，这里“origin/master”就是指远端仓库地master 分支，区别于我们本地分支

![1533179147136](/imgs/1533179147136.png)



### git fetch - 拉取远程分支数据到本地

先更新再提交！先更新再提交！先更新再提交！

这是我们在用SVN的时候常常强调的一句话。也是一种减少冲突的策略。

在Git下，当我们准备push本地分支上的修改到远程分支的时候，我们也要建议大家先将远程分支的代码拉到本地。

一旦远程主机的版本库有了更新（Git术语叫做commit），需要将这些更新取回本地，这时就要用到`git fetch`命令。 

`git fetch`命令通常用来查看其他人的进程，因为它取回的代码对你本地的开发代码没有影响。 

默认情况下，`git fetch`取回所有分支（branch）的更新。如果只想取回特定分支的更新，可以指定分支名。 

所取回的更新，在本地主机上要用"远程主机名/分支名"的形式读取。比如`origin`主机的`master`，就要用`origin/master`读取。 

```shell
git fetch <远程主机名>  <分支名>	#目前我们的远程主机名是指origin，远程分支名是master
```

取回远程主机的更新以后，可以在它的基础上，使用`git checkout`命令创建一个新的分支。

```shell
 git checkout -b newBrach origin/master
```

上面命令表示，在`origin/master`的基础上，创建一个新分支，名字叫newBranch。

此外，也可以使用`git merge`命令或者`git rebase`命令，在本地分支上合并远程分支。

```shell
$ git merge origin/master
# 或者
$ git rebase origin/master	#我们建议用rebase
```

上面命令表示在当前分支上，合并`origin/master`。

### git pull - 取回并合并远程主机某个分支的更新到本地

 `git pull`命令的作用是，取回远程主机某个分支的更新，再与本地的指定分支合并。它的完整格式稍稍有点复杂。 

```shell
git pull <远程主机名> <远程分支名>:<本地分支名>
```

比如，取回`origin`主机的`next`分支，与本地的`master`分支合并，需要写成下面这样。

```shell
git pull origin next:master
```

如果远程分支是与当前分支合并，则冒号后面的部分可以省略。

```shell
git pull origin next
```

上面命令表示，取回`origin/next`分支，再与当前分支合并。实质上，这等同于先做`git fetch`，再做`git merge`。

```shell
git fetch origin
git merge origin/next
```



#### 高级特性

在某些场合，Git会自动在本地分支与远程分支之间，建立一种追踪关系（tracking）。比如，在`git clone`的时候，所有本地分支默认与远程主机的同名分支，建立追踪关系，也就是说，本地的`master`分支自动"追踪"`origin/master`分支。

Git也允许手动建立追踪关系。

```shell
git branch --set-upstream master origin/next
```



上面命令指定`master`分支追踪`origin/next`分支。

如果当前分支与远程分支存在追踪关系，`git pull`就可以省略远程分支名。

```shell
git pull origin
```



上面命令表示，本地的当前分支自动与对应的`origin`主机"追踪分支"（remote-tracking branch）进行合并。

如果当前分支只有一个追踪分支，连远程主机名都可以省略。

```shell
git pull
```



上面命令表示，当前分支自动与唯一一个追踪分支进行合并。

如果合并需要采用rebase模式，可以使用`--rebase`选项。

```shell
git pull --rebase <远程主机名> <远程分支名>:<本地分支名>
```



如果远程主机删除了某个分支，默认情况下，`git pull` 不会在拉取远程分支的时候，删除对应的本地分支。这是为了防止，由于其他人操作了远程主机，导致`git pull`不知不觉删除了本地分支。

但是，你可以改变这个行为，加上参数 `-p` 就会在本地删除远程已经删除的分支。

```shell
git pull -p
# 等同于下面的命令
git fetch --prune origin 
git fetch -p
```



### git push - 推送本地提交到远程分支

最后一步，我们将提交（commit）推送到远程仓库，与SVN不同，我们大部分修改和提交都在自己地本地分支上操作，不需要频繁地与远程仓库交互，所以这一步，我们不需要每次commit之后就push一下，一般我们认为阶段性修改完成了之后推翻送到服务端，或者下班地时候，处于安全考虑我们将本地修改同步到远端，也起到了备份地作用

```shell
git push origin master
```

![1533179300881](/imgs/1533179300881.png)





## 图形界面的Git - SourceTree

### 先看看SourceTree的界面



#### Local 

展示已经添加到SourceTree管理目录的本地仓库

![1533193111596](/imgs/1533193111596.png)



#### Remote 

展示我们通过关联第三方账号连接的第三方Git托管服务里的远程仓储，如图，我们在SourceTree上登陆GitHub账号后，就可以浏览我们在Github上拥有的仓库，也可以进行clone操作。

![1533193163300](/imgs/1533193163300.png)



#### Clone 

将远程仓库clone到本地，这一步操作与我们在命令行界面下执行 `git clone` 的过程是一样的

![1533193425740](/imgs/1533193425740.png)



#### Add 

添加本地的Git仓库到SourceTree的管理目录，添加后我们就可以在Local下面看到这个仓库了

![1533193706247](/imgs/1533193706247.png)



#### Create 

创建新的本地Git仓库，这个过程类似我们在命令行界面执行 `git init`![1533193776265](/imgs/1533193776265.png)



### clone 仓库到本地

如果你本地还没有工作拷贝，就需要从远程仓库下载代码到本地，这个时候，安装并打开SourceTree，打开Clone选项，输入参数

> Source Path/Url：远程仓库Url
>
> Destination Path：本地目标目录(必须是一个空目录)
>
> Name：SourceTree的标签名称，即SourceTree会为你的本地仓库命名一个别称，也可以和Git仓库名称保持一致

![1533194509699](/imgs/1533194509699.png)



成功

![1533194546869](/imgs/1533194546869.png)



在这个界面上我们就可以方便地查看本地仓库当前状态，完成 `add` `commit` `push` `branch` `merge` `fetch` `pull` `rebase` 等等操作。

![1533194620043](/imgs/1533194620043.png)



### 修改文件

和上面命令行界面中一样，我们clone仓库到本地后就可以开始进行开发了，添加文件，修改文件，删除文件等，然后再在SourceTree中添加修改到缓存区，提交缓存区的修改，将已完成的提交push到远程分支等操作。

这里我们在本地仓库中新增一个文件，修改一个文件，删除一个文件

完成修改后，当我们将窗口切换到SourceTree的界面的时候，SourceTree会自动执行`git status`命令，并将结果可视化地输出到界面上来

![1533195476785](/imgs/1533195476785.png)

我们可以大致将界面划分成几个区域，来学习一下不同区域的主要功能。

> - 1号区域是基本操作区，包含了我们命令行里常用的几个命令等同的操作，界面的好处是比较容易上手，但是缺点是很多新手会在不了解的情况下先习惯性地点一点试试，这是不好的习惯。我们推荐命令行是因为我们通常对陌生的东西会更加谨慎，当我们敲下命令的时候，我们会尽量先了解下我们正在做什么。关于分支合并的操作，我们希望大家谨慎操作，先去官网的pro git教程上学习一下，上面有非常详尽的介绍和情景演示。
> - 2号区域列出了工作目录，本地仓库分支，远程仓库分支，标签，和暂存，方便我们切换到不同维度去查看代码
> - 3号区域是Git的提交分支历史树
> - 4号区域，5号区域和6号区域用来查看当前工作目录的已add到暂存区的修改，未add到暂存区的修改，以及单个文件修改的详细内容。4，5，6号区域在我们选择2号区域中不同维度时会有变化，功能大致相同。

在上面截图的5号区域可以看到我们在上一步修改文件的步骤中设计的文件修改，一共有3项修改

> - 黄色的about.md 图标为三个点号，意为modified，即内容被修改的文件
> - 灰色的test.txt 图标为减号，意思是删除的文件
> - 紫色的newAdded.txt 图标为问号，意思是untracked，没有加入版本控制的文件



### add 修改到暂存区

和命令行一样，我们需要将修改添加到暂存区，红框所示，可以选择全部stage还是选择性stage，这里stage就是添加到暂存区的意思

![1533196272263](/imgs/1533196272263.png)

我们Stage all以后，三项修改就被添加到暂存区了

![1533196344803](/imgs/1533196344803.png)



### commit 提交暂存区的修改

SourceTree在Commit修改的时候也需要写注释，界面工具也为我们提供了一些可选的提交选项，我们可以根据需要来配置。

![1533196602631](/imgs/1533196602631.png)

提交后，切换到Log/History界面，可以看到本次提交已经生成，在分支提交历史树上也可以看到我们这次的提交，然后再顶部Push按钮上显示了一个蓝色的上标，数字为1，标识有一个可执行的push

![1533196970726](/imgs/1533196970726.png)



### push 将本地分支推送到远程分支

点击Push按钮，弹出Push对话框，默认只有一个master分支，本地也是master分支，我们将本地master分支push到远程master分支，即origin/master。

![1533197086917](/imgs/1533197086917.png)



push成功

![1533197167895](/imgs/1533197167895.png)

