---
title: 使用SplashScreen实现闪屏页
tags:
  - 技术
  - Android
categories:
  - 技术
  - Android
abbrlink: 547b7b56
date: 2022-02-05 19:02:00
---

## 前言

> 水篇小文章

一般我们实现闪屏页是通过自定义主题的`windowBackground`，然后在主页恢复正常主题。

而在Android12上，谷歌对闪屏页支持了更多特性（如动画Drawable等）。

并因此在Jetpack中引入了新成员——SplashScreen。



使用该库可以非常简单的实现闪屏页，并完成大部分Android版本的兼容。



## API 文档
 [SplashScreen  |  Android Developers](https://developer.android.com/reference/kotlin/androidx/core/splashscreen/SplashScreen#setKeepOnScreenCondition(androidx.core.splashscreen.SplashScreen.KeepOnScreenCondition) )

> 其实文档里的描述非常清晰。



## 依赖
```groovy
implementation "androidx.core:core-splashscreen:1.0.0-beta01"
```



## 简单使用

### 步骤1：定制 themes
 改为继承 `Theme.SplashScreen.*`，一般Icon背景可以使用`"Theme.SplashScreen.IconBackground"`
 ```xml
 <style name="Theme.Calendar_manager" parent="Theme.SplashScreen.IconBackground">  
    <item name="postSplashScreenTheme">@style/Theme.Material3.DayNight</item>  
    <item name="windowSplashScreenBackground">@android:color/background_light</item>  
    <item name="windowSplashScreenAnimatedIcon">@mipmap/ic_launcher_foreground</item>  
</style>
 ```


### 步骤2：将 application 或者启动页 theme 改为该 theme


### 步骤3：启动页 onCreate 前调用 installSplashScreen()
 ```kotlin
installSplashScreen()  
super.onCreate(savedInstanceState)
 ```



## 进阶使用

### 延长展示时间
可以使用**KeepOnScreenCondition** api 进行设置：
```kotlin
SplashScreen.KeepOnScreenCondition {  
    return@KeepOnScreenCondition SystemClock.elapsedRealtime() - App.appCreateTime <= 150  
}
```



## 简单示例

[Feature 1.1.0 material you by Ayagikei · Pull Request #5 · Ayagikei/calendar-account-manager (github.com)](https://github.com/Ayagikei/calendar-account-manager/pull/5/commits/b930c4202ffbf3ca442db7c55c78970100376c3b)