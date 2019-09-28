---
title: PopupMenu弹出导致RecyclerView滚动的解决方法
tags:
  - 技术
  - Android
categories:
  - 技术
  - Android
abbrlink: 91d5b971
date: 2019-09-28 23:15:44
---

>  参考： <https://blog.csdn.net/qq_16445551/article/details/70213660>

## 起因

这个问题其实一直存在，但是新版本增加了Toolbar收缩之后，就因为这个自动滚动直接导致了Toolbar收缩，现象更为明显。



## 解决办法

参考[原文]()两个解决办法

**如果你的应用的最小支持版本达到了*Android KitKat 4.4*的话，建议使用第一种方法。**



**简单总结一下：**

1. > 将`support.v7`包的PopupMenu换成`android.widget.PopupWindow`包下的PopupMenu。

   **对应到AndroidX的话**，就是将`androidx.appcompat.widget.PopupMenu`换成`import android.widget.PopupMenu`

   

2. > 重写与`PopupMenu`绑定的`AnchorView`的`requestRectangleOnScreen(Rect rectangle, boolean immediate)`方法，并且`return false`。