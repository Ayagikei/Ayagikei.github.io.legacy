---
title: Android DialogFragment 相关代码段
tags:
  - 技术
  - Android
  - Code-Snippet
categories:
  - 技术
  - Android
  - Code-Snippet
abbrlink: a542da69
date: 2020-03-25 01:20:23
---

# 设置软键盘弹出，自动上移

```kotlin
override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
	...
    // 设置有软键盘时，窗口自动上移
    dialog?.window?.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE)
    ...
}
```

# 设置全屏显示

```kotlin
override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setStyle(STYLE_NORMAL, R.style.Dialog_FullScreen)
}
```

```xml
<style name="Dialog.FullScreen" parent="Theme.AppCompat.Dialog">
    <item name="android:windowNoTitle">true</item>
    <item name="android:windowBackground">@color/transparent</item>
    <item name="android:windowIsFloating">false</item>
</style>
```

# 子Fragment

```kotlin
private fun replace(fragment: androidx.fragment.app.Fragment) {
    val transaction = childFragmentManager.beginTransaction()
    transaction.replace(R.id.fragment, fragment)
    transaction.commit()
}
```

<!-- more -->