---
title: Toolbar减少标题和 Navigation icon 的间距
tags:
  - 技术
  - Android
categories:
  - 技术
  - Android
abbrlink: 96ecb474
date: 2019-04-23 19:01:51
---

Toolbar 默认配置下，标题和Navigation icon（比如返回按钮）之间的间隔会迷之过长，

可以通过配置toolbar的属性调整：

```xml
app:contentInsetStartWithNavigation="0dp"
```



这个间隔的设计好像是配合没有Navigation icon的情况的，默认值为16dp。

有Navigation icon的情况下应该手动调整。



**完整的Toolbar配置：**

```xml
<com.google.android.material.appbar.AppBarLayout
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:theme="@style/AppTheme.AppBarOverlay">

        <androidx.appcompat.widget.Toolbar
            android:id="@+id/toolbar"
            android:layout_width="match_parent"
            android:layout_height="?attr/actionBarSize"
            android:background="?attr/colorPrimary"
            app:contentInsetStartWithNavigation="0dp"
            app:popupTheme="@style/AppTheme.PopupOverlay" />

</com.google.android.material.appbar.AppBarLayout>
```