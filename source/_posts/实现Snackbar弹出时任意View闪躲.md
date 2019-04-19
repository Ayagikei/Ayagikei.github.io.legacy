---
title: 实现Snackbar弹出时任意View闪躲
tags:
  - 技术
  - Android
categories:
  - 技术
  - Android
abbrlink: 4f03117d
date: 2019-04-19 19:19:10
---

# 简介

Snackbar 是一个底部弹出消息的控件，类似Toast。

**基本使用：**

```java
Snackbar.make(view, message_text, duration)
   .setAction(action_text, click_listener)
   .show();
```

我们知道，在根布局是CoordinatorLayout，并且设置CoordinatorLayout的behavior之后，可以实现Snackbar弹出的时候，fab（浮动按钮）会自动向上移动防止被遮挡。

<!-- more -->

代码如下：

**布局文件**

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.coordinatorlayout.widget.CoordinatorLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/coordinator_layout"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/background_color"
    <!-- 注意这里要设置 layout_behavior -->
    app:layout_behavior="@string/appbar_scrolling_view_behavior"
    tools:context=".fragment.TodoFragment">


    <androidx.constraintlayout.widget.ConstraintLayout
        android:layout_width="match_parent"
        android:layout_height="match_parent">

	<!-- 其他View的布局 -->
	...

    </androidx.constraintlayout.widget.ConstraintLayout>


    <com.google.android.material.floatingactionbutton.FloatingActionButton
        android:id="@+id/fab"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_gravity="end|bottom"
        android:layout_marginEnd="16dp"
        android:layout_marginBottom="16dp"
        android:adjustViewBounds="false"
        android:clickable="true"
        app:backgroundTint="@color/blue"
        app:fabSize="normal"
        app:srcCompat="@drawable/ic_add_d" />


</androidx.coordinatorlayout.widget.CoordinatorLayout>
```

**注：**我这里用了AndroidX的支持库，如果你没迁移到AndroidX，需要改下控件的引用路径。

然后在activity中：

```kotlin
Snackbar.make(coordinator_layout, "Snackbar弹出信息",  Snackbar.LENGTH_SHORT)
   .show();
```

效果（其实这里已经实现了ConstraintLayout的闪躲）：

 {% asset_img 01.png %}



# 实现任意View闪躲

那么如何实现任意View的闪躲呢？

查了一番StackOverflow，发现最佳的实践应该就是实现一个通用的behavior。

废话不多说，直接上代码（Java）：

```java
@Keep
public class MoveUpwardBehavior extends CoordinatorLayout.Behavior<View> {

    public MoveUpwardBehavior() {
        super();
    }

    public MoveUpwardBehavior(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override
    public boolean layoutDependsOn(CoordinatorLayout parent, View child, View dependency) {
        return dependency instanceof Snackbar.SnackbarLayout;
    }

    @Override
    public boolean onDependentViewChanged(CoordinatorLayout parent, View child, View dependency) {
        float translationY = Math.min(0, ViewCompat.getTranslationY(dependency) - dependency.getHeight());
        child.setTranslationY(translationY);
        return true;
    }

    // 重写这个方法才能实现滑动清除消息
    @Override
    public void onDependentViewRemoved(CoordinatorLayout parent, View child, View dependency) {
        ViewCompat.animate(child).translationY(0).start();
    }
}
```


然后在布局文件中，在你想要实现闪躲的View上增加这个layout_behavior：

```xml
<androidx.constraintlayout.widget.ConstraintLayout
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    <!-- 就是这句了，注意要有完整的包名 -->
    app:layout_behavior="net.sarasarasa.lifeup.base.MoveUpwardBehavior">

    <!-- 其他View的布局 -->
    ...

</androidx.constraintlayout.widget.ConstraintLayout>
```

可以在AS里快速获取含完整报名的引用：右键你的类文件，选择**Copy Reference**。



没错，这样就完成了~测试去吧。



# 参考

<https://stackoverflow.com/questions/33217241/how-to-move-a-view-above-snackbar-just-like-floatingbutton>