---
title: Git修改已经提交的用户名信息
tags:
  - 技术
  - Git
categories:
  - 技术
abbrlink: 5d88e185
date: 2019-05-29 23:31:29
---

>  参考： <https://www.jianshu.com/p/93bb4d049955>

# 最近的一条记录

如果只是需要修改最近的一条记录的话，只需要

```git
git commit --amend --author="作者名 <邮箱@xxxx.com>"
```

> 注意：这里的尖括号是要带上的。

# 多条记录

```git
# 第一步，（n）代表提交次数
git rebase -i HEAD~n
# 第二步
然后按`i`编辑，把`pick` 改成 `edit`，按'Esc'退出编辑，按`:wq`保存退出
# 第三步
git commit --amend --author="作者 <邮箱@xxxx.com>" --no-edit
# 第四步（多条记录的话，会跳转到下一条记录，返回第三步）
git rebase --continue
# 第五步（全部完成后，覆盖远程git记录，危险操作要谨慎操作）
git push --force
```

# 非常多条记录更改

转自网络：
>如果是多个修改，那么就需要使用到`git filter-branch`这个工具来做批量修改
>为了方便大家使用，封装了一个简单的shell脚本，直接修改`[XXX]`中的变量为对应的值即可

```sh
#!/bin/sh
 
git filter-branch --env-filter '
 
an="$GIT_AUTHOR_NAME"
am="$GIT_AUTHOR_EMAIL"
cn="$GIT_COMMITTER_NAME"
cm="$GIT_COMMITTER_EMAIL"
 
if [ "$GIT_COMMITTER_EMAIL" = "[Your Old Email]" ]
then
    cn="[Your New Author Name]"
    cm="[Your New Email]"
fi
if [ "$GIT_AUTHOR_EMAIL" = "[Your Old Email]" ]
then
    an="[Your New Author Name]"
    am="[Your New Email]"
fi
 
export GIT_AUTHOR_NAME="$an"
export GIT_AUTHOR_EMAIL="$am"
export GIT_COMMITTER_NAME="$cn"
export GIT_COMMITTER_EMAIL="$cm"
'
 
```

