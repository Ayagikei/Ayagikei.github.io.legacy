---
title: 魅族Flyme和华为EMUI真机调试看不到log的解决
tags:
  - Android
  - 调试
  - 技术
categories:
  - 技术
  - Android
abbrlink: ea1c38b
date: 2018-07-04 09:53:15
---

# Flyme 7

打开`设置` → `辅助功能` → `开发者选项` → `性能优化` → `高级日志输出`，将其设为`全部允许`就好了。



选项藏得挺深，而且在设置中的搜索功能是搜索不到这个选项的。



# EMUI

没有EMUI实机，这是网传方法：

在**拨号界面**输入 *#*#2846579#*#* 打开工程菜单，再将“`LOG设置`”中AP日志打开。



# 参考链接

[android studio中崩溃无法查看log？](https://www.zhihu.com/question/32024327)