---
title: 阿里云服务器CentOS搭建Minecraft服务器
tags:
  - 游戏
  - 云服务器
  - 技术
  - linux
  - 记录
categories:
  - 技术
  - 记录
abbrlink: d8f0add3
date: 2018-05-11 22:28:19
---



## 前期准备

### 购买云服务器
本文选择的是阿里云+CentOS。

### 安装 Java 环境

首先使用以下命令来分别检查 java 和 jdk 的安装状况。

```bash
java -version
rpm -qa | grep jdk
```
如果没有安装的话，可以用yum方式安装：
```
yum -y install java-1.8.0-openjdk*
```

<!-- more -->


## 开启端口

CentOS 7.0以上版本，内置防火墙从 iptables 替换成了 firewalld。所以你要根本版本选择不同的设置方式。

<br />

### Firewalld

1. 首先查看已经开放的端口

  ```bash
  firewall-cmd --zone=public --list-ports
  ```

  ​

2. 分别开启 22 和 25565 端口

   ```bash
   firewall-cmd --zone=public --add-port=22/tcp --permanent
   firewall-cmd --zone=public --add-port=25565/tcp --permanent
   ```

   > 注：22 是为了后面的  SSH 连接服务器，25565 是MC默认采用的端口。

3. 重启防火墙，使更改生效

   ```bash
   firewall-cmd --reload
   ```

   ​

### iptables 

1. 首先查看已经开放的端口

   ```bash
   /etc/init.d/iptables status
   ```

   ​

2. 分别开启 22 和 25565 端口

   ```bash
   iptables -A INPUT -p tcp --dport 22 -j ACCEPT 
   iptables -A INPUT -p tcp --dport 25565 -j ACCEPT 
   ```

   > 注：22 是为了后面的  SSH 连接服务器，25565 是MC默认采用的端口。

   ​

3. 重启防火墙，使更改生效

   ```bash
   /etc/rc.d/init.d/iptables save
   /etc/init.d/iptables restart
   ```



当然，你还能手动打开文件进行修改：`vi /etc/sysconfig/iptables`，然后在里面添加一句`-A RH-Firewall-1-INPUT -m state –state NEW -m tcp -p tcp –dport 22 -j ACCEPT`来开启22端口。



### 阿里云控制台开启端口

其次，你还要在阿里云的配置安全组设置。

登陆之后，选择你的`云服务器 ECS`<i class="fa-arrow-right"></i>`更多`<i class="fa-arrow-right"></i>`安全组配置`<i class="fa-arrow-right"></i>`配置规则`<i class="fa-arrow-right"></i>`添加安全组规则`

{% asset_img 01.jpg %}

如下图填入规则信息：

> MC服务器默认用的端口号是25565，也可以改成别的

{% asset_img 02.jpg %}

## 远程连接以及文件传输

我用的是一款叫做 `SSH Secure Shell Client`的软件，它本身可以实现SSH连接，同时又具有可视化文件传输的功能。

但是在 SSH 官网这款软件似乎改名了，而且变成付费软件了。

**可以尝试更换 `PuTTY` 软件进行远程连接，`FIleZilla`软件进行文件传输。**



这些软件操作都类似，输入你的服务器公网IP地址，22端口，系统用户名和密码就可以登入了。

{% asset_img 03.jpg %}

{% asset_img 04.jpg %}



## 环境配置


### 服务器文件

在 [官网](https://minecraft.net/zh-hans/download/server) 可以下载到Minecraft的纯净服务器端。

将 jar 文件上传（利用上一节所述软件）到服务器端，最好专门建一个文件夹放置，以`MC`为例。

然后开始尝试启动服务器吧：

```
cd /root/MC
java -jar server.jar
```

你会发现运行过程中生成了一些配置文件，同时让你去同意 eula 协议才能继续。



编辑新生成的 `eula.txt` 文件，将其中的 `eula=flase` 改成 `eula=true`。

随后可以打开 `server.properties` 文件进行服务器配置。

将 `online-mode=true` 改成 `online-mode=false` 后非正版玩家才可进入服务器。



其他的可按需求修改，比如可以修改最大玩家量`max-players`、游戏模式`gamemode`、服务器端口`server-port`、待机踢出时间`player-idle-timeout`、服务器名称 `motd` 等。



## 服务器启动

### 测试

使用以下命令就可以启动服务器了：

```bash
java -Xmx1024M -Xms1024M -jar server.jar nogui
```

`-Xmx`参数是设置最大内存量、`-Xms`是最小内存量，根据你的服务器配置进行调节。

最好起码1G以上。



随后就可以测试能不能用`服务器公网IP+端口号`连接服务器了。

如果使用默认端口号的话就是`xxx.xxx.xxx.xxx:25565`



### 挂载后台

你会发现用上述方式运行的服务器，当你的远程终端软件断开之后，服务器也会随之关闭。

你可能会想到用nohup命令挂载后台：

```bash
nohup java -Xmx1024M -Xms1024M -jar server.jar nogui&
```

一开始我这样是没有问题的，但是设置 op 之后，用这个命令运行的服务器会抛出一个异常。



我们这里采用 screen 来解决这个问题。

**安装：**

```bash
yum install screen
```

**使用方法：**

1. 新建窗口（注意-S必须是大写的）

   ```
   screen -S mc
   ```

2. 运行服务器

3. 会话分离 输入CTRL+A、CTRL+D



### 自动重启服务器脚本

新建一个 `startmc.sh`文件，并在其中输入

```bash
while true
do
   java -Xmx1024M -Xms1024M -jar server.jar nogui
done

```

然后运行服务器的时候执行这个脚本即可

```bash
bash startmc.sh
```

