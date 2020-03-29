---
title: Android动画相关代码段
tags:
  - 技术
  - Android
  - Code-Snippet
categories:
  - 技术
  - Android
  - Code-Snippet
abbrlink: a2321477
date: 2020-03-25 01:08:56
---

# ValueAnimator 实现TextView打字机效果

```kotlin
fun TextView.startTypeAnimation(duration: Long = 300) {
    val originText = this.text
    val valueAnimator = ValueAnimator.ofInt(0, originText.length)
    valueAnimator.duration = duration
    valueAnimator.interpolator = LinearInterpolator()
    valueAnimator.addUpdateListener { animation ->
        val length = animation.animatedValue as Int
        this.text = originText.subSequence(0, length)
    }
    valueAnimator.start()
}
```

# SpringInterpolator 简易的弹性插值器 

```kotlin
/**
 * 弹性插值器
 */
class SpringInterpolator(private val factor: Float) : Interpolator {
    override fun getInterpolation(input: Float): Float {
        return (2.0.pow((-10 * input).toDouble()) * sin((input - factor / 4) * (2 * Math.PI) / factor) + 1).toFloat()
    }
}
```

<!-- more -->

# XML 底部弹出动画 

```kotlin
<?xml version="1.0" encoding="utf-8"?>
<translate xmlns:android="http://schemas.android.com/apk/res/android"
    android:duration="800"
    android:fromYDelta="100%"
    android:toYDelta="0" />
```

# 底部弹出+弹性插值器用法

```kotlin
fun View.startTranslateInSpringAnimation(factor: Float = 0.8f) {
    val enterAnimation = AnimationUtils.loadAnimation(context, R.anim.translate_in_bottom)
    enterAnimation.interpolator = SpringInterpolator(factor)

    this.post {
        this.startAnimation(enterAnimation)
    }
}
```

# XML AnimationSet  底部渐显弹出

```xml
<?xml version="1.0" encoding="utf-8"?>
<set xmlns:android="http://schemas.android.com/apk/res/android"
    android:duration="600">
    <alpha
        android:fromAlpha="0"
        android:toAlpha="1" />
    <translate
        android:fromYDelta="100%"
        android:toYDelta="0" />
</set>
```

# ConstraintSet 简易用法

```kotlin
// 伪代码
val genderLayoutMaleSet = ConstraintSet()
genderLayoutMaleSet.clone(genderLayout)
genderLayoutMaleSet.constrainWidth(R.id.femaleTextView, DisplayUtils.dp2px(56))
genderLayoutMaleSet.setVisibility(R.id.femaleIconTextView, View.GONE)

TransitionManager.beginDelayedTransition(genderLayout)
genderLayoutMaleSet.applyTo(genderLayout)
```

# AnimatorSet 放大渐显/缩小渐隐（泡沫效果）

**渐显**

```xml
<?xml version="1.0" encoding="utf-8"?>
<set xmlns:android="http://schemas.android.com/apk/res/android"
    android:interpolator="@android:anim/decelerate_interpolator"
    android:ordering="together">

    <objectAnimator
        android:duration="500"
        android:propertyName="scaleX"
        android:valueFrom="0.0"
        android:valueTo="1.0" />

    <objectAnimator
        android:duration="500"
        android:propertyName="scaleY"
        android:valueFrom="0.0"
        android:valueTo="1.0" />

    <objectAnimator
        android:duration="500"
        android:propertyName="alpha"
        android:valueFrom="0.0"
        android:valueTo="1.0" />

</set>
```

**渐隐**

```xml
<?xml version="1.0" encoding="utf-8"?>
<set xmlns:android="http://schemas.android.com/apk/res/android"
    android:interpolator="@android:anim/accelerate_interpolator"
    android:ordering="together">

    <objectAnimator
        android:duration="500"
        android:propertyName="scaleX"
        android:valueFrom="1.0"
        android:valueTo="0.0" />

    <objectAnimator
        android:duration="500"
        android:propertyName="scaleY"
        android:valueFrom="1.0"
        android:valueTo="0.0" />

    <objectAnimator
        android:duration="500"
        android:propertyName="alpha"
        android:valueFrom="1.0"
        android:valueTo="0.0" />

</set>
```

