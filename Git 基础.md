# Pull VS. Fetch
![image](https://l.ruby-china.org/photo/2017/e51bde23-8ce5-49d7-b9c4-b0a386de6248.png!large)



## git pull 和 git fetch 有什么区别？ 

首先，你的每一个操作都是要指明【来源】和【目标】的，而对于 pull 来说，【目标】就是当前分支

其次，你得清楚 git 是有 tracking 的概念的，所谓 tracking 就是把【来源】和【目标】绑定在一起，节省一些操作是需要输入的参数。

那么，假设你的 master 和 develop 都是 tracking 了的，于是：

```
# 当你在 master 下
$ git pull
# 等于 fetch origin，然后 merge origin/master

# 当你在 develop 下
$ git pull
# 等于 fetch origin，然后 merge origin/develop
```

### ~~如果 tracking 了多个 remote，要指明 remote 的名字，比如：~~

```
$ git pull origin
```

~~分支的名字不用打，因为你 tracking 了~~

Sorry，写这里的时候没有动脑子，错了。tracking 只能是一对一的，没有一个 local branch tracking 多个 remote branch 这么一说，但是多个 remote 是有的。

因此，若你有多个 remote ，`git pull [remote name]` 所做的事情是：

1. fetch [remote name] 的所有分支
2. 寻找本地分支有没有 tracking 这些分支的，若有则 merge 这些分支，若没有则 merge 当前分支

另外，若只有一个 remote，假设叫 origin，那么 `git pull` 等价于 `git pull origin`；平时养成好习惯，没谱的时候都把 【来源】带上。

### 但是，如果我要合并 origin/master 去 develop 呢？

```
# 当你在 master 下
$ git checkout develop # 切换到 develop，这就是 【目标】
$ git pull origin master  # 合并 origin/master，这就是 【来源】
```

### OK，那我怎么知道 tracking 了没有？

1. 如果你曾经这么推过：`git push -u origin master`，那么你执行这条命令时所在的分支就已经 tracking to origin/master 了，`-u` 的用处就在这里
2. 如果你记不清了：`cat .git/config`，给你一张截图，注意红色方框标示的地方（上半部分是 tracking 的，下半部分是 untracking 的），由此可见，tracking 的本质就是指明 pull 的 merge 动作来源。别忘了：pull = fetch + merge。

[![img](https://l.ruby-china.org/photo/2013/d5cef21e0a95973d8494e9e0abbc898c.png)](https://l.ruby-china.org/photo/2013/d5cef21e0a95973d8494e9e0abbc898c.png)

### 顺便一提：`git fetch` 到底干了些啥？

注意到红色方框上面的一句了么？

```
fetch = +refs/heads/*:refs/remotes/origin/*
```

它指明了 fetch 动作的来源，在本例中就是 **叫做 origin 的那个 remote server 下的所有分支**

也就是说， `git fetch` 的操作就是取下上述目标的更新。但是——取下的东西到底在哪儿？

再补一个截图：

[![img](https://l.ruby-china.org/photo/2013/69f0ee7c8a46f90f51483afc4728df41.png)](https://l.ruby-china.org/photo/2013/69f0ee7c8a46f90f51483afc4728df41.png)

就在这里：`.git/FETCH_HEAD`。上图特意也做了一个对比，第一次 cat 的时候没有 fetch，第二次 cat 的时候 fetch 了，于是你可以看到其中的区别，之后就可以明白 `git pull` 的 merge 是如何被触发的了。

### Wrap up

1. `git pull` = `git fetch + merge`
2. `git fetch` 拿到了远程所有分支的更新，我用 `cat .git/FETCH_HEAD` 可以看到其状态，若都是 `not-for-merge` 则不会有接下来的 merge 动作
3. `merge` 动作的默认目标是当前分支，若要切换目标，可以直接切换分支
4. `merge` 动作的来源则取决于你是否有 tracking，若有则读取配置自动完成，若无则请指明【来源】

