---
title: Quartz的简单介绍与实例应用：整点报时
date: 2018-04-19 15:23:25
tags: 
- Quartz
- 技术
- 实例
- Java
- 框架
categories: 
- 技术
---

自己弄的一个 QQ 机器人有一个整点报时的功能，当时使用了非常简陋的方法实现。想要重写的时候，发现了一款非常好用的任务调度框架：**Quartz**。

简单的说，你可以使用 **Quartz** 轻易地实现类似以下功能：

- 每隔一段时间执行

- 每天的特定时间点执行

- 每月的特定某天的时间点执行

- 每周几执行

  ​

而且你只需要编写一条表达式就可以按照你设定的日历触发你指定的任务。

<!-- more -->

## 下载

[官网](http://www.quartz-scheduler.org/)

* 可以选择下载 jar 包导入项目
* 或是添加以下 Maven 依赖

```xml
  <dependency>
    <groupId>org.quartz-scheduler</groupId>
    <artifactId>quartz</artifactId>
    <version>2.2.1</version>
  </dependency>
  <dependency>
    <groupId>org.quartz-scheduler</groupId>
    <artifactId>quartz-jobs</artifactId>
    <version>2.2.1</version>
  </dependency>   
```



## 实现任务类

Quartz 执行的任务必须是实现了 **org.quartz.Job**接口的类，该接口只有唯一一个方法 execute(JobExecutionContext arg0) throws JobExecutionException 需要实现。



```java
import java.text.SimpleDateFormat;
import java.util.Date;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class myJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		System.out.println(sdf.format(new Date()));
	}

}
```



## 创建并执行任务调度

```java
import static org.quartz.CronScheduleBuilder.cronSchedule;
import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerFactory;
import org.quartz.impl.StdSchedulerFactory;

public class Test {
   public void go() throws Exception {
   
      // 首先，从 SchedulerFactory 中取得一个 Scheduler 的引用
      SchedulerFactory sf = new StdSchedulerFactory();
      Scheduler sched = sf.getScheduler();
      //jobs可以在scheduled的sched.start()方法前被调用

      //将 job 通过 Jobdetail 传给 Scheduler
      JobDetail job = newJob(HourChimeJob.class)
          .withIdentity("job1", "group1")
          .build();
          
      //设置触发方式 这里用到的是 cron 表达式
      CronTrigger trigger = newTrigger()
          .withIdentity("trigger1", "group1")
          .withSchedule(cronSchedule("0 * * * * ?"))
          .build();
       
      Date ft = sched.scheduleJob(job, trigger);


      // 计时器开始
      sched.start();

   }

   public static void main(String[] args) throws Exception {

      Test test = new Test();
      test.go();
   }

}
```



运行你会发现，控制台每一分钟整秒的时候会打印出一次时间。

你可以直接猜到这是由 `(cronSchedule("0 * * * * ?")` 实现的。

没错，这就是 Cron 表达式。

<br />

## Cron 表达式

Cron 表达式包含着由空格分开的多个子表达式。

从左到右分别代表的是 `Seconds（秒） Minutes（分） Hours（时） Day-of-Month（日） Month （月） Day-of-Week（周几） Year（年，可选）`

并且表达式允许使用一些特殊符号指代一些特殊含义。



| 字段名              | 允许数值          | 允许的符号      |
| ------------------- | ----------------- | --------------- |
| Seconds（秒）       | 0-59              | , - * /         |
| Minutes（分）       | 0-59              | , - * /         |
| Hours（时）         | 0-23              | , - * /         |
| Day-of-Month（日）  | 1-31              | , - * ? / L W C |
| Month （月）        | 1-12 或者 JAN-DEC | , - * /         |
| Day-of-Week（周几） | 1-7 或者 SUN-SAT  | , - * ? / L C # |
| Year（年，可选）    | 空 或者 1970-2099 | , - * /         |



**特殊符号的含义：**

* “?”字符：表示不确定的值
* “,”字符：指定数个值
* “-”字符：指定一个值的范围
* “/”字符：指定一个值的增加幅度。n/m表示从n开始，每次增加m。
* “L”字符：用在日表示一个月中的最后一天，用在周表示该月最后一个星期X。
* “W”字符：指定离给定日期最近的工作日（周一到周五）
* “#”字符：表示该月第几个周X。6#3表示该月第3个周五



<br />

##  整点报时

由上易知，整点报时只需要将 **Cron 表达式**改成 `"0 0 * * * ?"` ，即只在0分0秒的时候触发执行任务类，也就是整点了。



## 参考链接

1. http://www.cnblogs.com/sunjie9606/archive/2012/03/15/2397626.html
2. https://www.cnblogs.com/monian/p/3822980.html
3. http://blog.csdn.net/u010648555/article/details/54863394