---
title: Android 手机通过 SSH 方式连接云服务器
tags:
  - Android
  - SSH
  - 云服务器
  - 技术
categories:
  - 技术
abbrlink: 83d18952
date: 2018-04-24 22:16:46
---

身边没有电脑，只有手机，但又想远程连接服务器进行操作和文件传输，该怎么办呢？

其实，一些 app 能让你的手机立刻变成一个 linux 终端。

<!-- more -->

## <i class="fa fa-mobile  fa-lg"></i> 所用的APP

 {% asset_img pic01.png %}

[**Termux**](https://www.coolapk.com/apk/com.termux)

<i class="fa fa-check-square-o fa-lg"></i> 体积小

<i class="fa fa-check-square-o fa-lg"></i> 内置了一个虚拟键盘，可以模拟ESC，CTRL等键盘操作

<i class="fa fa-check-square-o fa-lg"></i> 支持bash和zsh

<i class="fa fa-check-square-o fa-lg"></i> 支持nano和vim

<i class="fa fa-check-square-o fa-lg"></i> 支持多 Session

<i class="fa fa-check-square-o fa-lg"></i> More...



## <i class="fa fa-server  fa-lg"></i> 连接服务器

```
ssh <user name>@<ip address> -p <port>
```

第一次使用可能要求你安装 ssh 服务。

端口号是必须指定才能连接的，一般 ssh 用的端口是 22。

之后会要求你输入密码，输完密码就进入了云服务器的终端。

## <i class="fa fa-download  fa-lg"></i> 下载文件

```
scp -r <user name>@<ip address>:<file path> <local download path>
```

例如：scp -r root@192.168.1.1:/root/qrcode.png /storage/emulated/0/download/

一般 `/storage/emulated/0` 就是你本地存储空间的根目录。

## <i class="fa fa-question fa-lg"></i> 说好的虚拟键盘

 {% asset_img pic02.jpg %}

在左边界往右滑动可唤出侧边栏，接着长按 KEYBOARD 按钮就可以了。