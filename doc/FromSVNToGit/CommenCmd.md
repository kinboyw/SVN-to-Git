<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Git 常用操作命令](#git-%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C%E5%91%BD%E4%BB%A4)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

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



## 优雅删除要忽略的文件

  `git rm [-r] --cached <path>`

  > 将文件或目录从缓存去中删除，执行成功后，commit 并 push到远程服务器上，这样当其他人 pull到本地时，本地已经存在的 <path> 路径的文件或目录不会被删除掉，但是会提示为untracked ，未添加到索引区，此时再将文件添加到` .gitignore` ，就可以实现优雅地忽略已存在的文件。

