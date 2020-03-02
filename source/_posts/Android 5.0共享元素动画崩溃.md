---
title: Android 5.0共享元素崩溃
tags:
  - 技术
  - Android
categories:
  - 技术
  - Android
abbrlink: e0a2859e
date: 2020-02-29 16:06:06
---

# 简介

后台监测到了数个仅限于Android5的崩溃问题，日志大概如下：

```
Fatal Exception: java.lang.NullPointerException: Attempt to invoke virtual method 'android.view.ViewParent android.view.View.getParent()' on a null object reference at android.view.ViewOverlay$OverlayViewGroup.add(ViewOverlay.java:164) at android.view.ViewGroupOverlay.add(ViewGroupOverlay.java:63) at android.app.EnterTransitionCoordinator.startRejectedAnimations(EnterTransitionCoordinator.java:598) at android.app.EnterTransitionCoordinator.startSharedElementTransition(EnterTransitionCoordinator.java:325) at android.app.EnterTransitionCoordinator.access$200(EnterTransitionCoordinator.java:42) at android.app.EnterTransitionCoordinator$5$1.run(EnterTransitionCoordinator.java:389) at android.app.ActivityTransitionCoordinator.startTransition(ActivityTransitionCoordinator.java:698) at android.app.EnterTransitionCoordinator$5.onPreDraw(EnterTransitionCoordinator.java:386) at android.view.ViewTreeObserver.dispatchOnPreDraw(ViewTreeObserver.java:847) at android.view.ViewRootImpl.performTraversals(ViewRootImpl.java:1985) at android.view.ViewRootImpl.doTraversal(ViewRootImpl.java:1077) at android.view.ViewRootImpl$TraversalRunnable.run(ViewRootImpl.java:5845) at android.view.Choreographer$CallbackRecord.run(Choreographer.java:767) at android.view.Choreographer.doCallbacks(Choreographer.java:580) at android.view.Choreographer.doFrame(Choreographer.java:550) at android.view.Choreographer$FrameDisplayEventReceiver.run(Choreographer.java:753) at android.os.Handler.handleCallback(Handler.java:739) at android.os.Handler.dispatchMessage(Handler.java:95) at android.os.Looper.loop(Looper.java:135) at android.app.ActivityThread.main(ActivityThread.java:5272) at java.lang.reflect.Method.invoke(Method.java) at java.lang.reflect.Method.invoke(Method.java:372) at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:909) at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:704)
```

查了下资料，发现这是 Android 5.0 系统的内置Bug。

在执行切换动画的时候，有一定条件下会导致崩溃问题。

并且，在 API level 22（即 Android 5.1）之后，这个  bug 已经被修复了。



最简单也是最有效的解决方法：

**只有在API level 22的情况下，再执行切换动画。**



## 其他

也有一些想要在 Android 5.0 继续使用切换动画，避免崩溃的解决方案。

> 这个 Android 系统 bug 与分享元素的选取排除（'rejected'）的处理有关。如果一个分享元素在执行动画的时候没有 attached to the window 就有可能被拒绝，也就是当 View 可见性为 `GONE` 的时候。
>
> 
>
> 所以，解决方法就是在执行切换动画的时候，检查每一个共享元素View，并且将可见性改为 `VISIBLE`。
>
> [Glenn Schmidt](https://stackoverflow.com/users/1435436/glenn-schmidt)



# 参考

https://stackoverflow.com/questions/34658911/entertransitioncoordinator-causes-npe-in-android-5-0