---
title: LifeUp Release Log
tags:
  - English
  - 开发日志
  - Android
categories:
  - 项目
  - 人升Q&A
abbrlink: e5dce7c7
date: 2020-03-04 15:51:15
---

## Future Plan

1. Custom Achievements
2. Link Complete Reward of task to the inventory.
3. Add time selector in Statistics page
4. Custom Exp of task
5. Better settings of creating a task.

## Known Bug（v1.71.4）

- **Transparent part of the png picture may turn to black when cropping a picture.**


<br />

## Release Log

**1.71.3/1.71.4（Released at 2020/04/16）**

**Minor Fixes about icon and crash report**

**1.71.2（Released at 2020/04/14）**

**Features:**

- Turkish Language (thanks **İbrahim DOĞAN** for helping translation)

- Customize task card background and opacity
- Customize the action button text of inventory item
- Feelings Favorites
- Feelings Search

**Improvement:**

- New Icon

- Report type support multiple languages
- Improve UI of the Settings Page
- Improve the method of switching theme color and language. No need to restart the app to make it work.
- Improve the crop picture page
- Improve UI of the select list
- Add shop item description showing on the shop item list page

**Fixed:**

- Fixed bug that achievement unlock date incorrectly showing
- Fixed bug that shop item picture showing empty when the file deleted. 
- Not clear the status of sub-tasks after single task become overdue.
- Fixed bug that not enough space for Difficulty Degree to show in the Task Detail Page.
- Fixed bug that after setting overdue task to finished, completed times of the next task not plus one.
- Fixed bug that the max coin number not showing correctly in the task default settings.
- Make the data backup/restore page scrollable.
- Fixed that swipe to complete task not working well when fast swiping multiple tasks.
- Now app widgets will show the Frozen status
- Fixed bug that the progress bar on task page showing incorrect progress sometimes

**Server Fixed（2020/4/13）**

- Fixed that report function not working

**v1.71.1 (Released at 2020/03/17)**

**Improvement:**

- Better progress bar animation in task page

**Fixed:**

- Fixed a bug that may cause crash when launching application on some devices
- Fixed a bug about selecting photos

<!-- more -->

**v1.71.0 (Released at 2020/03/13)**

**Features:**

- Feelings Feature

- Add Swipe Action: Finish Task (No Dialog)

**Fixed:**

- Fixed bug that task card state showing incorrectly

- Fixed bug that task which was undo may be disappeared when overdue

- Fixed that the selected sort not showing correctly

**v1.70.6 (Released at 2020/03/09)**

**Improvement:** 

- Make the Achievement unlocked Hint colors same as the theme color

**Fixed：**

- Fixed overdue dialog status not showing correctly after clicking the button

- Fixed a bug that COPY cannot copy sub-tasks
- Fixed a crash occurred when using "Move To..."
- Fixed the Selecting Card not correctly showing on some devices

**v1.70.5 (Released at 2020/03/06)**

**Fixed：**

- To-Do Card keep loading when change theme color or enable/disable night mode

**v1.70.4 (Released at 2020/03/05)**

**Improvements：**

- Shop Page will show coin number when there is no items
- Can access the Coin Detail Page by clicking the coin number in the Shop Page
- Improve text format of the app widget in English
- Can access the Task Detail Page by clicking the task on the App Widget

**Fixed：**

- Team activity incorrect showing style

**v1.70.3 (Released at 2020/03/05)**

**Improvements:**

- Shop Page will now show coin number when there is no items
- Click the coin number in the Shop Page to enter Coin Detail Page now
- Improve the English text format on the App Widget
- Click the App Widget item to enter Task Detail Page

**Fixed：**

- Fixed when Filter Today, the footer hint "xx task(s) is not yet started" not showing after completing task

**v1.70.3 (Released at 2020/03/05)**

**Important Fixes:**

- Fixes bugs about input coin number
- Fixes bugs that sub-tasks not refreshing correctly
- Fixes bugs that cannot like others' activity
- Fixes bugs that App Widget cannot finishing tasks

**v1.70.2 (Released at 2020/03/04)**

**Features：**

- Community is now available for all time zone

- Copy Tasks
- Support edit new task default settings
- Shop List

- Improve App Widget actions
- Add menu for ended tasks for In Calendar Page

**Improvements**：

- Improve animations of task card 

- Remove an unneeded permission
- Add complete sound
- Improve History Page UI style
- Add "Lost Calendar Write/Read Permission" Dialog when enabling System Calendar Reminder and not granted permissions

**Fixed：**

- Fixes bugs about Count Task in compact mode
- Fixes bugs about repeat tasks
- Fixes crash that may occurs when delete sub-tasks
- Fixes crash that occurs when input incorrect WebDAV URL
- Fixes incorrect theme color showing , which may occurs after restore a backup