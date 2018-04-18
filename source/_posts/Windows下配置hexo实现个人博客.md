---
title: Windows下配置hexo实现个人博客
date: 2018-04-16 19:07:32
tags: 
- 前端
- hexo
- NexT
- 记录
categories: 
- 技术
---
## 1.前言 ##
很久以前自己就想要一个自己的博客，来保存自己写过的杂七杂八的文章。偶然间听说用hexo搭建个人博客很简便，就查询了一波资料搭建出了这个网站。
第一篇文章就献给hexo的搭建过程吧~

本文将包括以下部分内容：
 - 所需环境的安装和配置（Git，Node.js）
 - hexo的安装和运行
 - hexo个性化配置
 - 搭桥Github Pages
 - 绑定个人域名
 - 部署优化
 - 开写吧


<!-- more -->

---

## 2. 所需环境的安装和配置 ##

### Git的安装 ###

- [下载地址](https://git-scm.com/download/win)
- 安装步骤：如不懂选项可以全程NexT
- 验证：安装完毕后，在任一文件夹空白处右键会多出Git Bash here选项，点开之后输入
``` bash
$ git -v
```
若出现git version就代表安装成功。

<br />
### Node.js的安装 ###

- [下载地址](https://nodejs.org/en/)
- 安装步骤：同上。注意在 Custom Setup 一步最好勾上 Add to PATH选项。
- 验证：安装完毕后，在bash中输入
``` bash
$ node -v
```
若出现版本号就代表安装成功。

---

## 3. hexo的安装和运行 ##

### 正常步骤 ###

1. 打开一个你想存放博客的文件夹，右键Git Bash here。
2. 安装hexo

``` bash
$ npm install hexo-cli -g
```

3. 初始化博客（ <folder> 为新建的文件夹名，自行替换）

``` bash
$ hexo init <folder>
$ cd <folder>
$ npm install
```

4. 安装服务器模块

``` bash
$ npm install hexo-server --save
```

5. 运行服务器

``` bash
$ hexo server --debug
```

6. Hello hexo！打开 http://localhost:4000 ，你会发现你的博客已经构建完成了！
<br />
### 一个坑 ###
** npm 过程中卡住 **
由于 npm 的服务器问题，国内连接不稳定。
- 可以尝试通过淘宝的镜像服务器解决。
``` bash
$ npm config set registry https://registry.npm.taobao.org
```
- 再或者更换网络，比如使用手机网络。

---

## 4. hexo个性化配置 ##
看到自己构建好的博客后，是不是很想将博客换成自己想要的名字？
如果你不中意默认的主题的话，还可以自己挑选喜欢的主题。
<br />
### 简单的个性化配置 ###
打开博客所在根目录的 _config.yml 文件，我们在此将这个文件叫做 ** 站点配置文件 ** 。
可以看到这么一段
```
# Site
title: #填上你想要的博客名
subtitle: #副标题
description: #描述
keywords:
author: #你的大名
language: #简体中文的话可以在这里填上"zh-CN"
timezone:
```

**注意一个坑：  每一行的冒号之后记得加上一个空格，否则会报错。**

<br />
### 更换 hexo 主题 ###
首先你要找到心怡的主题，可以在[这里](https://hexo.io/themes/)找。

这里推荐一款叫做 NexT 的极简风格的主题，也是本博客使用的主题：

建议直接查阅 [NexT 官网](http://theme-NexT.iissnan.com/getting-started.html) ，安装步骤以及各种自定义步骤十分详细，。

<br />
### 实现 NexT 主题圆形头像 ###
在 \themes\NexT\source\css\_custom 里的 custom.styl 文件是让我们放入自定义css样式的。
我们可能用此文件来实现圆形头像。
打开文件并在其中插入
``` css
.site-author-image {
	/* 头像圆形 */
	border-radius: 80px;
	-webkit-border-radius: 80px;
	-moz-border-radius: 80px;
	box-shadow: inset 0 -1px 0 #333sf;
}
```

---

## 5. 搭桥Github Pages ##
在以上方式搭建的服务器只有自己才能访问到，那么如何让其他人也能访问到自己的博客呢？
我们将用到Github Pages服务。

** Github Pages是什么？ **
Github Pages 可以托管用户编写的静态网页，还能提供一个域名给用户，更重要的是，还是免费的！
<br />
### SSH 配置 ###

1. 首先，你要有一个[Github账号](https://github.com/)。

2. 随后，配置本地 git 以 SSH 方式连接 Github。
``` bash
$ git config --global user.name "<你的github账号名>"
$ git config --global user.email "<你的github邮箱>"
```

3. 接下来输入以下命令
```bash
$ ssh-keygen -t rsa
```
然后回车三次，之后就会生成两个文件，分别为id_rsa和id_rsa.pub，即密钥id_rsa和公钥 id_rsa.pub 。

4. 在 https://github.com/settings/keys 中点击 New SSH key，粘贴到刚才生成的 id_rsa.pub 文件其中的内容。

5. 添加完毕后，可以在 Git Bash 里面输入以下命令来测试是否连接成功。
``` bash
ssh -T git@github.com
```

若显示以下内容就表示你已经**成功**了！
> Hi <你的用户名>! You've successfully authenticated , but Github does not provide shell access. 



<br />
### 建立一个 Github Pages 仓库，并将你的博客上传 ###

1. 在 Github 新建一个名称为 <你的github用户名>.github.io 的仓库。
2. 打开博客所在根目录的 _config.yml 文件，即 ** 站点配置文件 ** 。
3. 找到以下段落并修改：

``` 
# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy: 
  type : git
  repository : git@github.com:<替换成你的用户名>/<替换成你的用户名>.github.io.git
  branch : master
```

4. 在博客根目录打开Git Bash，输入
``` bash
hexo g
hexo d
```

执行完命令后，你的博客就已经部署在了Github Pages上了。
对应的地址是 <替换成你的用户名>.github.io

* 现在，所有人都可以通过这个地址访问你的邮箱了！ *

---

## 6. 绑定个人域名 ##
但是，如果你想要一个自己设定的域名的话，又该怎么办呢？
这里以[ 万网 ](https://wanwang.aliyun.com/)为例。

1. 首先，当然是先要购买一个域名啦。在首页查询自己想要的域名，如果没人占用的话就可以买下来了。
{% asset_img art01_01.png %}

2. 其次，对你的域名进行实名认证。此处只需要提供身份证的照片，再等侯一会即可。（几个小时内就能审核完毕）。

3. 然后，如图配置域名解析。
{% asset_img art01_02.png %}

4. 最后，还要在你的本地博客文件夹/Source文件夹内，新建一个无后缀名的叫做CNAME的文件，并在其中写入你的域名。
{% asset_img art01_05.png %}

5. 试试用你的域名访问吧~

---

## 7. 部署步骤优化 ##
以上方式只是将 hexo 生成的静态网页上传到 Github Pages，但是并没有备份源文件。
这样对于多部电脑编辑博客是件麻烦事，而且文件没有云备份也不安全。
当然，你可以新建一个仓库专门用来保存源文件。但是每次变动要上推两个仓库的变动也不方便。

此处，我们将采用在 Github Pages 的仓库中新建一个分支的方式来保存源文件。

1. 首先，打开 Github，在你的 Github Pages 仓库中建立一个新分支 hexo。
{% asset_img art01_03.png %}

2. 然后，在设置将 hexo 设为 Default branch。
{% asset_img art01_04.png %}

3. 在本地另找一个文件夹，进入 Git Bash：
``` bash
$ git clone git@github.com:<你的github用户名>/<你的github用户名>.github.io.git
```

4. 在clone下来的文件夹中删除除了 .git 文件夹之外的其他文件。

5. 将之前的本地博客文件夹里的所有内容复制过来。

6. 进入 Git Bash，你会发现该仓库正处在 hexo 分支状态，输入以下命令：
``` bash
$ git add .
$ git commit -m "初始化hexo分支"
$ git push
```

这样一来，你 Github 上的仓库就有两个分支，原本的 master 分支保存静态网页；新的 hexo 分支用来保存源文件。

在这之后部署的话，照常使用以下命令来部署静态文件即可。
```
hexo g
hexo d
```



然后再使用以下Git命令来上推备份原文件。
``` bash
$ git add .
$ git commit -m "初始化hexo分支"
$ git push
```

---

## 8. 开写吧！

### 生成 md 文件 ###
使用以下命令生成md文件。
``` bash
$ hexo new [layout] <title>.
```
然后再在 *source\_posts* 里找到md文件。
可以在头部写入文章的标签以及分类。
下面就用正常的 markdown 语法进行编辑即可。

{% asset_img art01_06.png %}

*注意：*
> 如果 title包含空格的话，需要用引号括起来。

<br />

### 本地 Markdown 编辑器

推荐两款：

- [Cmd Markdown](https://www.zybuluo.com/mdeditor)

  <i class="fa fa-check fa-lg"></i> 多平台，还可以在线使用

  <i class="fa fa-check fa-lg"></i> 两栏对比，实时同步预览

  <i class="fa fa-check fa-lg"></i> 编辑器易用

  <i class="fa fa-check fa-lg"></i> 有云同步

  <i class="fa fa-times fa-lg"></i> 需要注册使用

  <i class="fa fa-times fa-lg"></i> 部分功能需要会员

- [Typora](https://www.typora.io/)

  <i class="fa fa-check fa-lg"></i> 多平台

  <i class="fa fa-check fa-lg"></i> 实时渲染写好的Markdown代码

  <i class="fa fa-check fa-lg"></i> 编辑器简洁美观

  <i class="fa fa-check fa-lg"></i> 免费支持多种格式导出

  <i class="fa fa-times fa-lg"></i> 体积有些庞大

<br />

### 后台管理编辑插件 ###
有两款实现了WEB UI的后台管理编辑插件可供你选择。
这里就不对两者的使用方法做介绍了。

 - [Hexo Admin][1]
 {% asset_img art01_07.png %}
 - [Hexo Local Admin][2]
 {% asset_img art01_08.jpg %}
<br />
### 最后 ###
强烈建议读读 hexo 的官方文档以及你所用主题的官方文档。
就如 hexo 3.x 有一些自定义标签（插入图片），不同于 markdown 的标准语法。这些都是需要你看看官方文档才能得知的。

[1]: https://jaredforsyth.com/hexo-admin/
[2]: https://github.com/geekwen/hexo-local-admin