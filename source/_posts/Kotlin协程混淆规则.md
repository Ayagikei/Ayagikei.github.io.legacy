---
title: Git修改已经提交的用户名信息
tags:
  - 技术
  - Android
categories:
  - 技术
  - Android
abbrlink: 5d88e185
date: 2019-09-13 17:10:09
---

>  参考： <https://github.com/Kotlin/kotlinx.coroutines/issues/799>

# 起因

发布了《人升》新版本后，

线上突然出现了数个Kotlin协程相关的异常。

>  IllegalStateException: Module with the Main dispatcher is missing. Add dependency providing the Main dispatcher, e.g. 'kotlinx-coroutines-android'

而我们肯定是已经依赖了kotlin的协程库的，问题不在于此。

**不是很懂为什么在更新的好几天之后才集中爆发这个问题。**



查询了一下发现是升级kotlin版本后的混淆bug，要增加几条混淆规则。

# 混淆规则

https://github.com/Kotlin/kotlinx.coroutines/blob/master/kotlinx-coroutines-core/jvm/resources/META-INF/proguard/coroutines.pro

将以下混淆规则加入到项目的混淆规则文件中：

```
# ServiceLoader support
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-keepnames class kotlinx.coroutines.android.AndroidExceptionPreHandler {}
-keepnames class kotlinx.coroutines.android.AndroidDispatcherFactory {}

# Most of volatile fields are updated with AFU and should not be mangled
-keepclassmembernames class kotlinx.** {
    volatile <fields>;
}
```

然后重新编译打包发版吧~