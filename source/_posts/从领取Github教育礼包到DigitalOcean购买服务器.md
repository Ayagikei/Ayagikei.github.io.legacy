---
title: 从领取Github教育礼包到DigitalOcean购买服务器
tags:
  - DigitalOcean
  - SSH
  - 云服务器
  - 技术
categories:
  - 技术
  - 记录
abbrlink: 2d5d76b2
date: 2018-06-13 23:09:39
---
> **本文首发于[我的简书页面](https://www.jianshu.com/p/c5e7721d886c)。**



自己想要一台国外的服务器用作某些用途，恰好自己学校又提供了教育邮箱。于是就打算拿Github的教育礼包中DigitalOcean的50美元优惠码来使用一年。

不过根据网上的一些文章，途中也遇到了一些坑。

最后也顺利地在2018/6/11一天内搞定了。所以打算记录一下自己的全过程，以供大家参考。



# 你所需要准备的东西
- Github 账号
- 一个教育邮箱（edu或者是edu.cn结尾都可以）
  如果没有的话，也可以用学生证之类的东西。不过我没试过。
- 一个PayPal账号（你需要至少支付5美元）

<!-- more -->

<br/>

---
# 1 提交 Github 教育礼包申请
在 https://education.github.com/pack 点击 Get Your Pack 
{% asset_img 01.jpg %}

随后填写相关信息：
{% asset_img 02.jpg %}

**最好使用教育邮箱申请，这样申请通过得比较快。**
**如果你注册用的邮箱不是教育邮箱的话，要先去添加教育邮箱，并且验证一下。**



最下方有个How do you plan to use GitHub？（你计划怎么用 Github ），简单的用英文描述一下就好。比如：I want to learn coding and try to make contribution to the community.



提交后，等待一段时间审核通过。
就可以在这个页面看到你领取到的一大堆**羊毛**。



找到 DigitalOcean，获取你的优惠码。
{% asset_img 03.jpg %}
<br/>

---
# 2 注册DigitalOcean账号
注册的过程我没有截图，这里简单的描述一下吧。

我是通过别人的邀请链接注册的，这样可以得到10美元的被邀请奖励，邀请人也能获得一定的奖励。
这里贴一下我的[邀请链接](https://m.do.co/c/42290aaa9a5c) ~ 



**注册途中需要绑定一个社交账号，可以绑定Facebook、Github还有Twitter账号。**
我选择的是选择绑定Github账号，授权一下就好了。



**然后有一个步骤是要绑定信用卡或者用PayPal支付5美元。**
我没有信用卡，选择的是用PayPal支付5美元。



随后有一个审核阶段，可能要等上数个小时才能继续。
{% asset_img 04.jpg %}
<br/>

---
# 3 通过DigitalOcean审核并且兑换优惠码
## 3.1 通过审核
过了挺长一段时间，收到邮件说要填写一些额外的信息。

{% asset_img 05.jpg %}



点击邮件那个链接，进去填一些信息：手机号码（国内手机号码前面需要+86），所在地、姓名（我直接打了中文），还有打算用DigitalOcean做些什么（简单描述即可）。
{% asset_img 06.jpg %}



又过了好一段时间，收到了两封邮件。
第一封是要确认PayPal支付。
{% asset_img 07.jpg %}

简单回复：

> Hi,the paypal payment is an authorized payment.



第二封邮件：
{% asset_img 08.jpg %}



简单回复：
> hi,i have replied to that email.



不久之后，就收到了解除了账号限制的邮件。
{% asset_img 09.jpg %}

## 3.2 兑换优惠码
理论上，在 **Settings** 里面的 **Billing** 应该会有一个兑换优惠码的地方。
但是我怎么都找不到。
{% asset_img 10.jpg %}



这时候就要找客服了。
拉到页面最低端，点击**Support**。
然后再拉到页面下面，点击**Contact Support**。
{% asset_img 11.jpg %}



**按以下图片所示填写表单：**
{% asset_img 12.jpg %}



过了大约半个小时，客服就有了回复：
{% asset_img 13.jpg %}



至此，我们的账号已经就有了65美元余额。
> 50 优惠劵 + 10 邀请链接注册 + 5 Paypal支付

<br/>

---
# 4 购买服务器并且连接上
点击网站首页的 **Create** 中的 **Droplets**。
{% asset_img 14.jpg %}



**调整各种配置：**
> 服务器所在地的选择可以先用[这个网站](http://speedtest-sfo1.digitalocean.com/)测速。

{% asset_img 15.jpg %}



创建后，你会收到一封内含服务器ip地址、用户名、密码的邮件。

{% asset_img 16.jpg %}



接着我们就可以用 [Putty](https://www.putty.org/) 连接上服务器了。

{% asset_img 17.jpg %}



会弹出一个警告框，选择**是**。
然后进入终端，输入用户名和密码，然后设置新密码。



你就可以在里面为所欲为了~
无论是[**搭建ss**](https://www.flyzy2005.com/fan-qiang/shadowsocks/install-shadowsocks-in-one-command/)、搭建web服务器还是只是玩玩linux都可以。