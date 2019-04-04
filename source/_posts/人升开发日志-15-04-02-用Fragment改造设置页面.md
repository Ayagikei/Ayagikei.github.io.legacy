---
title: '人升开发日志#15 | 04/02 用Fragment改造设置页面'
tags:
  - 开发日志
  - Android
categories:
  - 项目
  - 开发日志
  - 人升
abbrlink: 6f83efb3
date: 2019-04-02 12:00:14
---

之前使用Fragment都是配合ViewPager或者配合TabLayout+ViewPager，基本没用过FragmentManager。

实际使用之后才发现，Fragment能实现到和Activity在使用上分辨不出的效果。



# 布局文件

其实我们要实现的效果很简单，一个主Fragment显示各个设置的大类（比如显示设置、小部件设置等），点击之后切换到不同的Fragment显示，然后那些Fragment只能回退到主Fragment，主Fragment再回退就是结束Activity。

大概这样：

 {% asset_img 01.jpg %}



Fragment的布局文件正常就好。

Activity要怎么样呢？**我们的Activity本身是不需要任何内容的，只需要充当一个容器的作用就行：**

`activity_setting.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/fragment_container"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:background="@color/background_color"
    android:fitsSystemWindows="true"
    tools:context=".activities.SettingActivity">

</LinearLayout>
```
<!-- more -->

<br />

# 填充Fragment

**在Activity对Fragment进行操作是要，通过FragmentManager获得FragmentTransaction进行add/remove/replace等处理的。**

具体如何对上述布局里的`fragment_container`填充Fragment呢？

```kotlin
override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_setting)

    // 这是为了防止重复添加
    if (supportFragmentManager.findFragmentById(R.id.fragment_container) == null) {
        val transaction = supportFragmentManager.beginTransaction()
        transaction.add(R.id.fragment_container, SettingMainFragment())
        // 在对transaction进行各种操作之后，要用commit()方法提交修改
                .commit()
    }
}
```

那么如何替换Fragment呢？

**使用FragmentTransaction，只不过调用的方法是replace()**

```kotlin
override fun mainToSettingChildrenFragment(childrenFragment: Fragment) {
    supportFragmentManager.beginTransaction()
    		// 在我们这个例子中，只有Main Fragment会调用这个方法
            .replace(R.id.fragment_container, childrenFragment)
    		// 这里可以将当前的Fragment压入回退栈，等会返回使用
            .addToBackStack("main")
            .commit()
}
```

在其他Fragment返回Main Fragment的方法：

```kotlin
override fun popBackStack() {
    supportFragmentManager.popBackStack()
}
```
<br />

# 接口回调实现Activity和Fragment通信

这些方法是写在Activity中的，Fragment要怎么调用Activity的方法呢？

这里可以使用到接口回调的方法。

定义一个BaseSettingFragment，并且在其中定义接口：

```kotlin
abstract class BaseSettingFragment : Fragment() {
    interface SettingActivityListener {
        fun mainToSettingChildrenFragment(childrenFragment: Fragment)
        fun popBackStack()
    }

    abstract fun initView(rootView:View)
}
```

Activity要实现这个两个接口，然后在Fragment之中：

```kotlin
private val settingActivityListener: SettingActivityListener? by lazy {
    if (activity != null && activity is SettingActivityListener)
        activity as SettingActivityListener
    else null
}

// 然后你就能调用Activity之中这两个方法了：
...
settingActivityListener?.popBackStack()
settingActivityListener?.mainToSettingChildrenFragment(SettingDisplayFragment())
...
```

<br />

# 让Fragment伪装成Activity

## Toolbar和回退按钮

因为我们的例子中Activity的布局文件是没有加上Toolbar的，所以我们要在Fragment之中实现Toolbar。

**我们这里是把Toolbar当做独立控件使用，即Standalone Toolbar。**

有个问题就是，这样子我们在Fragment是调用不了**setDisplayHomeAsUpEnabled()**方法显示出回退键的，那么该怎么办呢？

查了一下[Stackoverflow](https://stackoverflow.com/questions/26732952/how-to-enable-homeasup-or-call-setdisplayhomeasupenabled-on-standalone-toolbar)，发现加上一个神奇的参数就可以了：

```xml
app:navigationIcon="?homeAsUpIndicator"
```

Toolbar相关的布局内容：

```xml
<com.google.android.material.appbar.AppBarLayout
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:theme="@style/AppTheme.AppBarOverlay">

    <androidx.appcompat.widget.Toolbar
        android:id="@+id/setting_toolbar"
        android:layout_width="match_parent"
        android:layout_height="?attr/actionBarSize"
        android:background="?attr/colorPrimary"
        app:navigationIcon="?homeAsUpIndicator"
        app:popupTheme="@style/AppTheme.PopupOverlay" />

</com.google.android.material.appbar.AppBarLayout>
```

然后你就可以设置Title和按键监听：

```xml
toolbar.setNavigationOnClickListener { settingActivityListener?.popBackStack() }
toolbar.title = "桌面小部件设置"
```

这样的效果就和普通的Activity无异了。

当然，除了一点：

<br />

## 切换动画

实际运行会发现Fragment的切换是默认不带动画的。

其中Fragment是有默认的切换动画的，只是没有开启。

**调用FragmentTransaction的setTransition(int)方法就可以设置相应的动画效果。**

参数可以传入TRANSIT_FRAGMENT_FADE、TRANSIT_FRAGMENT_OPEN、TRANSIT_FRAGMENT_CLOSE等，具体可以参考https://developer.android.com/reference/android/app/FragmentTransaction



自带的这几个效果并没有Activity默认的SLIDE_IN等，这时候就要用到自定义动画了。

调用FragmentTransaction的setCustomAnimations方法即可。

该方法有两种使用方法，一种是只传入ENTER和EXIT动画，另外一种是再这两种的基础上再加上入栈出栈的动画。

 {% asset_img 02.jpg %}

 {% asset_img 03.jpg %}

**因为我们的例子中，回退是用出栈实现的，自然要实现第二种。**



**首先新建动画文件：**

**slide_left_in.xml**

```xml
<?xml version="1.0" encoding="utf-8"?>
<set xmlns:android="http://schemas.android.com/apk/res/android">
    <translate
        android:duration="300"
        android:fromXDelta="-100.0%p"
        android:toXDelta="0.0" />
</set>
```

**slide_left_out.xml**

```xml
<?xml version="1.0" encoding="utf-8"?>
<set xmlns:android="http://schemas.android.com/apk/res/android">
    <translate
        android:duration="300"
        android:fromXDelta="0.0"
        android:toXDelta="-100.0%p" />
</set>
```

**slide_right_in.xml**

```xml
<?xml version="1.0" encoding="utf-8"?>
<set xmlns:android="http://schemas.android.com/apk/res/android">
    <translate
        android:duration="300"
        android:fromXDelta="100.0%p"
        android:toXDelta="0.0" />
</set>
```

**slide_right_out.xml**

```xml
<?xml version="1.0" encoding="utf-8"?>
<set xmlns:android="http://schemas.android.com/apk/res/android">
    <translate
        android:duration="300"
        android:fromXDelta="0.0"
        android:toXDelta="100.0%p" />
</set>
```



更改我们的mainToSettingChildrenFragment(childrenFragment: Fragment)方法的实现：

```kotlin
override fun mainToSettingChildrenFragment(childrenFragment: Fragment) {
    supportFragmentManager.beginTransaction()
			// 其实就是加上了这一句
            .setCustomAnimations(R.anim.slide_right_in, R.anim.slide_left_out, R.anim.slide_left_in, R.anim.slide_right_out)
            .replace(R.id.fragment_container, childrenFragment)
            .addToBackStack("main")
            .commit()
}
```

还有一点要注意，setCustomAnimations方法要在add/remove/replace/addToBackStack等方法前调用，要不然动画效果不会生效。