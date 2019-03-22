---
title: '人升开发日志#13 | 03/21 迁移至AndroidX'
tags:
  - 开发日志
  - Android
categories:
  - 项目
  - 开发日志
  - 人升
abbrlink: d848a650
date: 2019-03-21 17:51:24
---



AndroidX是 Google 发布的对原来的支持库整理后的新一代支持库。并且原来的支持库的最后版本将停留在“28.0.0”，迁移是迟早的事情。

主要动机还是想要用一个框架，结果它只支持AndroidX，就这样决定开始迁移了。



# 利用Android Studio迁移

**需求：**Android Studio版本3.2以上

**操作：**Refactor -> Migrate to Androidx



IDE会询问是否要备份一份当前的项目，并且会告知可能需要你手动解决一些项目Error。

继续操作，IDE会搜索所有的要改变的依赖路径，然后点击`DO REFACTOR`按钮吧。

<!-- more -->

<br />

# 解决问题

## 马上Gradle Build就出现了第一个问题

```
Android resource compilation failed
 error: duplicate value for resource 'attr/visibility' with config ''. and error: resource previously defined here.
```

检索可知，这是依赖库的一个Bug。

```
androidx.constraintlayout:constraintlayout:2.0.0-alpha3  
```



**解决方法：**暂时将alpha3降级到alpha2，等待下一个版本解决。

**参考链接：**https://stackoverflow.com/questions/53908854/android-resource-compilation-failed-error-duplicate-value-for-resource-attr-vi

<br />

## Kotlin的View依赖失效

**解决方法：**重新导一下View的依赖就好。

<br />

## 第三方框架的错误

第三方框架有的可能还依赖于原始的支持库，这时IDE会报错。

这里有2个解决方案：

### 1. 更新框架

一般坚持维护的大型框架都有提供 AndroidX 版本，更新一下即可。

### 2. 修改 gradle.properties

```xml
android.useAndroidX=true
android.enableJetifier=true
```

- `android.useAndroidX=true` 表示当前项目启用 AndroidX
- `android.enableJetifier=true`表示启用 Jetifier。而Jetifier会在构建项目的时候，将你的第三方依赖里面的旧支持库依赖自动转换为AndroidX支持库。

