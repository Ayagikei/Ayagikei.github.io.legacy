---
title: '将Ubuntu装入U盘,打造便携系统'
tags:
  - Ubuntu
  - linux
  - 系统
categories:
  - 技术
  - Linux
abbrlink: 4d0e5331
date: 2018-05-17 22:43:00
---

前段时间想要尝试下 Ubuntu 系统，又不太想弄双系统，后来想了想干脆将 Ubuntu 装入一个空闲的 U 盘里面，实现即插即用的便携系统与工作环境。



## 准备工作

- **闲置的 U 盘**
  建议至少支持USB3.0，空间至少16G以上，32G为佳。

- **虚拟机或是另外一个闲置U盘**

  用来当启动盘安装 Ubuntu。这里选择的是 Vmware Workstation 14 Pro。 

- **Ubuntu Desktop 系统安装文件**
  在[Ubuntu官网](https://www.ubuntu.com/download)下载，这里选择的是Ubuntu Desktop 18.04 LTS。

<!-- more -->

## 新建虚拟机

启动  Vmware ，`文件`<i class="fa-arrow-right"></i>`新建虚拟机`<i class="fa-arrow-right"></i>`典型`<i class="fa-arrow-right"></i>`稍后安装系统`<i class="fa-arrow-right"></i>`Linux Ubuntu`。

{% asset_img 01.jpg %}



> `最大磁盘大小`设为最小（1G）即可，我们是用虚拟机来安装系统，并不需要硬盘空间。



接着一路`下一步`，创建出一个虚拟机。



右键你新建的虚拟机，点击`设置`。

将 CD/DVD 设为你下载的 Ubuntu Desktop 系统安装文件（iso文件）。

同时最好打上`已连接`和`启动时连接`两个勾。



{% asset_img 02.jpg %}



## 安装系统

插上 U 盘，启动虚拟机。

没有意外的话，你能看到 Ubuntu 的安装界面。



{% asset_img 03.jpg %}



选择`安装Ubuntu`，注意此时的 U 盘应该与虚拟机相连接。

如果没有连接的话，点击以下图片所示的按钮：

{% asset_img 04.jpg %}



注意要安装到 U 盘里，其他的按照需求进行点击安装即可。

分区的话这里将`根目录 '/'` 挂载为最大的空间，`/boot`空间设为了300MB，`swap空间`设为了2GB。

可按需求自行修改，注意下方的`安装启动引导器的设备`一定要设置为你的 U 盘。

{% asset_img 05.jpg %}





## 启动系统

实机启动的话，只需要进入 `bios` ，将 `Removable Devices` 设为优先启动即可。



我们这里讲讲怎么用虚拟机启动你的 U 盘里的系统。

进入虚拟机设置，添加<i class="fa-arrow-right"></i>硬盘<i class="fa-arrow-right"></i>使用物理硬盘。

{% asset_img 06.jpg %}



在下一步的`设备`中选择最后一项（一般 U 盘是最后一项）。



{% asset_img 07.jpg %}



点击如下图所示按钮进入虚拟机的bios：

{% asset_img 08.jpg %}



接着更改启动优先级到下图所示状态：

{% asset_img 09.jpg %}



最后，重新启动你的虚拟机，就能进入你的 Ubuntu 系统了。



**此时要保证断开虚拟机与 U 盘的连接，应与主机连接。**

**确保是以下状态，不要点击：**

{% asset_img 04.jpg %}



## What's Next?

接下来当然是安装程序，捣鼓你的 Ubuntu 去啊。



{% asset_img 10.jpg %}



{% asset_img 11.jpg %}



