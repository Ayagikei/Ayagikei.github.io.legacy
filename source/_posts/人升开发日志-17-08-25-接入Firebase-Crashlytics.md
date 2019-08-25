---
title: '人升开发日志#17 | 08/25 接入Firebase、Crashlytics'
tags:
  - 开发日志
  - Android
categories:
  - 项目
  - 开发日志
  - 人升
abbrlink: be07a40
date: 2019-08-25 16:44:03
---

找到实习后，挺长一段时间没更新了。

《人升》的话，最近接入了Crashlytics，更新了金币系统等等。

回忆一下Crashlytics的接入过程~



# 为什么选择Crashlytics?

- **不需要额外权限**

  而国内很多崩溃统计向的都有不少权限要求，比如友盟统计必须依赖READ_PHONE_STATE等权限。

- **国内也能访问**

  是的，虽然Crashlytics属于Firebase，但是并没有用到Google的服务器。

- **配置简单，不需要额外代码**

  这一点我也很惊喜，只需要在Gradle文件里进行一些配置。项目代码甚至不需要任何变动。

- **能直接在Crashlytics后台看到混淆前的堆栈信息**

 {% asset_img 01.jpg %}

 {% asset_img 02.jpg %}

另外除了崩溃分析/管理功能外，其实还能在控制台看到活跃用户统计、用户行为分析、次日留存率、版本情况等等。

**查看这些信息感觉很有助于维持更新兴趣~**

 {% asset_img 03.jpg %}

总体来讲，感觉Crashlytics很适合独立开发者使用。



# 接入Firebase以及Crashlytics

Crashlytics已经被并入了Firebase体系，所以要先接入Firebase。

> Fabric虽然还能直接加入Crashlytics，**但是仅提供支持到2020年3月31号**，官网也在建议用户迁移至Firebase。

接入Firebase可以参考[官方教程](https://firebase.google.com/docs/android/setup?hl=zh-cn)。

**流程可以概述为：**

1. 创建Firebase项目

2. 注册应用，上传签名的SHA码

   **这两步在官网跟着流程走就可以，就不详细说明了。**

3. **下载 google-services.json**放到项目的模块目录（一般是app文件夹里）中。

4. 项目级gradle文件里加入Firebase和Crashlytics配置：

   ```groovy
   buildscript {
       ...
   
       repositories {
       	// 加上这两个仓库地址
           google()
           maven {
               url 'https://maven.fabric.io/public'
           }
       }
       dependencies {
           classpath 'com.google.gms:google-services:4.3.0' // Google 服务
           classpath 'io.fabric.tools:gradle:1.29.0'  // Crashlytics 插件
       }
   }
   ```

5. 模块级gradle文件里加入：

   ```groovy
   apply plugin: 'com.google.gms.google-services'
   apply plugin: 'io.fabric'
   
   dependencies {
       ...
   
       /** firebase **/
       implementation 'com.google.firebase:firebase-core:17.0.0'
       implementation 'com.crashlytics.sdk.android:crashlytics:2.10.1'
       
   }
   ```

   **到这一步为止，其实已经集成完毕了。**

6. （可选）如果你的应用开启了代码混淆的话，建议在proguard-rules.pro文件里加入以下规则，**以便拿到混淆前的堆栈信息：**

   ```
   # Crashlytics
   -keepattributes *Annotation*
   -keepattributes SourceFile,LineNumberTable
   -keep public class * extends java.lang.Exception
   -keep class com.crashlytics.** { *; }
   -dontwarn com.crashlytics.**
   
   ```

7. **测试一下崩溃吧**

   在相应的地方可以用以下语句制造一个崩溃，然后过几分钟后，前往Firebase的后台查看崩溃信息吧~

   ```java
   Crashlytics.getInstance().crash() // 制造一个崩溃
   ```



# 更多玩法

更多Crashlytics的用法可以参考[官方的页面](https://firebase.google.com/docs/crashlytics/customize-crash-reports?hl=zh-cn&platform=android#nav-buttons-1)，比如可以记录try-catch住的异常，自定义一些key-value信息方便分析崩溃等等。

