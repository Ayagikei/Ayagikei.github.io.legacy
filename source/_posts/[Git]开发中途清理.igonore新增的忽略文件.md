---
title: '[Git]开发中途清理.igonore新增的忽略文件'
tags:
  - Git
  - 技术
categories:
  - 技术
  - Git
abbrlink: 9a4281e2
date: 2018-09-04 22:12:15
---

中途修改.gitignore文件后，直接commit的话，以前git跟踪的文件就算添加进忽略里，依旧会跟踪变化。

<br />

# 获取.gitignore文件模板

https://github.com/github/gitignore

<br />

# 删除已经跟踪的文件

1. 修改.gitignore文件后，先进行一次commit操作。

   `git commit -m "update .gitignore"`

2. 然后，清空本地暂存区的内容：

   `git rm -rf --cached .`

3. 再次添加跟踪文件：

   `git add .`

4. 再进行一遍commit提交修改。

   `git commit -m "delete files that should not be tracked"`



**我本地测试的时候，似乎修改.gitigonore文件的操作和下面的操作要分属两个commit才能生效。**

**不过也有可能是操作问题，这里有待检验。**

<!-- more -->

<br />

# 利用Rebase操作合并commit

**比如要合并从HEAD开始的最新的两个commit：**

1. 首先，用rebase指明要rebase的从HEAD开始数的版本数量：

   `git rebase -i HEAD~2`

2. 在弹出的文本编辑器中，将后面那个commit前面的pick改成squash然后保存。

3. 如果中途出现冲突中断的话，处理后，可以用以下命令继续：

   `git add .`

   `git rebase --continue`

4. 最后会弹出一个文本编辑器，让你编辑合并后的commit的描述，修改后保存即可。

<br />

# 参考链接

 [(Git)合并多个commit](https://segmentfault.com/a/1190000007748862)

 [Git:中途清理.gitignore 忽略文件](http://ericode.pro/2017/09/24/Git-%E4%B8%AD%E9%80%94%E6%B8%85%E7%90%86-gitignore-%E5%BF%BD%E7%95%A5%E6%96%87%E4%BB%B6.html)