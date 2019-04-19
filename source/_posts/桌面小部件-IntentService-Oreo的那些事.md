---
title: 桌面小部件-IntentService-Oreo的那些事
tags:
  - 技术
  - Android
categories:
  - 技术
  - Android
abbrlink: 5e0f1c47
date: 2019-04-19 21:57:42
---

# 简介

之前在《人升》的桌面小部件，实现ListView中的点击事件监听的方式是：

使用fillInIntent发送广播到Widget类中，并在onReceive方法中拦截，处理业务逻辑。



**但是，**

Widget的本质是个广播接收器，不适宜在里面处理耗时操作。

（完成团队事项的时候需要发送网络请求，普通事项需要更改数据库，都可以视为是耗时操作。）

所以，我决定改用IntentService处理完成事项的业务逻辑。

**IntentService的特点是后台运行、自动销毁、异步运行。**



首先尝试直接用fillInIntent启动服务失败了。

**然后改成了先发送广播，然后在Widget类中，并在onReceive方法拦截再启动IntentService：**

```kotlin
override fun onReceive(context: Context, intent: Intent) {
    super.onReceive(context, intent)

    if (...) {
	...
    } else if (intent.action == FINISH_TASK) {
        // 将耗时操作交给IntentService完成
        val finishIntent = Intent(context, FinishTaskIntentService::class.java)
        if (intent.extras != null) {
            finishIntent.putExtras(intent.extras!!)
        }

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(finishIntent)
            } else {
                context.startService(finishIntent)
            }
        } catch (e: Exception) {
            e.printStackTrace()
            ToastUtils.showShortToast("完成事项似乎出现了一些问题，请尝试刷新下。", LifeUpApplication.getLifeUpApplication())
        }
    }
}
```

然后就遇到了坑。

<!-- more -->

# 问题

一开始我是没写对Oreo的判断的，直接startService。

简单测试了成功，但是应用放置一会后，再测试，会发现应用抛出了异常：

```
java.lang.IllegalStateException: Not allowed to start service Intent
```

查询了一下，是Oreo不允许后台启动服务。



首先需要以startForegroundService的方式启动服务，然后启动后5s内切换到前台服务（调用startForeground方法）：

```kotlin
class FinishTaskIntentService : IntentService("FinishTaskIntentService") {

    override fun onCreate() {
        super.onCreate()
        Log.i("FinishTaskIntentService", "onCreate()")
    }


    override fun onHandleIntent(intent: Intent?) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val NOTIFICATION_CHANNEL_ID = "net.sarasarasa.lifeup"
            val channelName = "FinishTaskIntentService"
            val channel = NotificationChannel(NOTIFICATION_CHANNEL_ID, channelName,
                    NotificationManager.IMPORTANCE_MIN)

            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)

            val notification = Notification.Builder(applicationContext, NOTIFICATION_CHANNEL_ID).build()

            startForeground(1001, notification)       
        }


        val extras = intent?.extras

        if (extras != null) {
            ... // 业务逻辑
        }
    }


}
```

一开始我是直接new Notification传参，然后测试发现又抛了一个异常：

```
Bad notification for startForeground: java.lang.RuntimeException: invalid channel for service notification: Notification
```

嗯，这是Android 8.1新添加的限制。

**在Android 8.1中，必须创建自己的Notification Channel。**



**在 Android 9（P）中，还需要声明前台服务权限：**

```xml
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
```



# JobIntentService

其实 Google 推荐的是使用 JobIntentService 处理那些后台业务。

**特色：**

- 8.0以下会被当作普通的Service。
- 8.0及以上会被作为job用jobScheduler.enqueue()方法来分发。

但是呢，JobIntentService 并不适用于我们这个场景：

**它的任务会在合适的时刻执行，（即使空闲）也并不保证会立即执行。**



这里的[讨论](https://stackoverflow.com/questions/46856171/jobintentservice-doesnt-start-immediately-on-android-8-0)挺有意思的，可以看看~

结论就是，需要立即执行的业务最好还是靠前台Service实现。



# 参考

<https://stackoverflow.com/questions/46445265/android-8-0-java-lang-illegalstateexception-not-allowed-to-start-service-inten>



[JobIntentService详解及使用](https://blog.csdn.net/Houson_c/article/details/78461751)