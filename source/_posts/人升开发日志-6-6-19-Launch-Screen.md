---
title: '人升开发日志#6 | 6/19 Launch Screen'
tags:
  - 开发日志
  - Android
categories:
  - 项目
  - 开发日志
  - 人升
abbrlink: a1903a1d
date: 2018-06-19 21:37:01
---

当我们打开 app 的时候，可能会出现一段短暂的白屏或者黑屏界面，这个界面就是 `Launch Screen`。

`Launch Screen`是为了优化用户体验而存在的，一点击就出现一个界面，让用户有流畅的感觉。

然而，如果只是纯色的白或者黑，就有点丑了。



一般的做法是放logo以及标语。

**`Launch Screen` 实际上是一种 Theme。**

**所以我们可以用修改Theme的方式来自定义我们的`Launch Screen`。



**我们实现的只显示logo的Launch Screen（可能会修改）：**

 {% asset_img 01.jpg %}

<!-- more -->

<br />

# 新建SplashActivity

```java
package net.sarasarasa.lifeup;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;

/**
 * Created by AyagiKei on 2018/6/19 0019.
 */

public class SplashActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

 
            Intent intent = new Intent(this, WelcomeActivity.class);
            startActivity(intent);
            finish();
 
    }
}
```

**注意，这里并不需要加载ContentView。**



这个页面将作为我们的启动页面，作简单的判断然后跳转到其他Activity。

<br />

# 注册成启动Activity，更换Theme

```xml
<activity
    android:name=".SplashActivity"
    android:label="@string/app_name"
    android:theme="@style/AppTheme.SplashTheme">
    <intent-filter>
        <action android:name="android.intent.action.MAIN" />

        <category android:name="android.intent.category.LAUNCHER" />
    </intent-filter>
</activity>
```

**将SplashActivity设为启动Activity。**
更改AndroidManifest.xml：

**同时将Theme设为`AppTheme.SplashTheme`，我们将在下一步创建这个Theme。**

<br />

# 新建Theme

在`styles.xml`文件中修改或添加：

```java
    <style name="AppTheme.NoActionBar">
        <item name="windowActionBar">false</item>
        <item name="windowNoTitle">true</item>
    </style>

    <style name="AppTheme.TranslucentTheme" parent="AppTheme.NoActionBar">
        <item name="android:windowTranslucentStatus">true</item>
        <item name="android:windowTranslucentNavigation">false</item>
        <item name="android:statusBarColor">@android:color/transparent</item>
        <item name="android:background">@android:color/transparent</item>
    </style>

    <style name="AppTheme.SplashTheme" parent="AppTheme.TranslucentTheme">
        <item name="android:background">@drawable/splash_layers</item>
    </style>
```

其实就是隐藏各种状态栏什么的，和我们引导页做的事情是一样的。

**所以我们这里直接继承了引导页的Theme然后更改背景。**

将背景设为`@drawable/splash_layers`，这个文件我们下一步再创建。

<br />

# 创建背景文件
在drawable中创建splash_layers.xml：

```xml
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@color/white" />
    <item>
        <bitmap
            android:gravity="center"
            android:src="@mipmap/icon" />
    </item>
</layer-list>
```

我们这里使用 `layer-list` 来作为我们的背景。

> layer-list中，越后的item，图层越在上层。



**当然，你也可以选择普通的图片作为背景图。**



**第一个item就是背景的白色。**

**第二个item就是我们的logo。**



> （这里引入的mipmap最好宽高相等？否则可能会出现奇怪的情况）

<br />

# 设置跳转

```java
package net.sarasarasa.lifeup;

import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;

/**
 * Created by AyagiKei on 2018/6/19 0019.
 */

public class SplashActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //判断是不是第一次打开应用
        SharedPreferences sharedPreferences = getSharedPreferences("status", MODE_PRIVATE);
        boolean isFirst = sharedPreferences.getBoolean("isFirst", true);
        Editor editor = sharedPreferences.edit();

        if (isFirst) {
            //第一次进入的时候，跳转到引导页
            Intent intent = new Intent(this, WelcomeActivity.class);
            startActivity(intent);
            finish();
            editor.putBoolean("isFirst", false);
            editor.commit();
        } else {
            //否则，进入主页面
            Intent intent = new Intent(this, MainActivity.class);
            startActivity(intent);
            finish();
        }


    }
}
```

**我们使用`SharedPreferences`来保存用户是否是第一次打开APP，然后进行不同的Activity跳转。**

<br />

# 参考文章

https://www.jianshu.com/p/6a863fac3f58

https://antonioleiva.com/branded-launch-screen/

https://blog.csdn.net/u010386612/article/details/79039937

https://www.jianshu.com/p/a859b1250bcb

https://juejin.im/post/58ad90518ac2472a2ad9b684

https://keeganlee.me/post/android/20150909

https://blog.csdn.net/qq_26650589/article/details/53738176