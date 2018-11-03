---
title: '人升开发日志#10 | 11/03 Android图片选择、裁剪实现（8.0以及MIUI适配）'
tags:
  - 开发日志
  - Android
categories:
  - 项目
  - 开发日志
  - 人升
abbrlink: '99671126'
date: 2018-11-03 19:35:00
---



不得不说MIUI是个大坑，在其他系统都能正常实现的时候，唯独MIUI出现了各种奇奇怪怪的状况。

最后上了第三方框架uCrop解决裁剪问题。



# 所需要的框架

因为LitePal和MobSDK都需要对Application进行修改，所以最好实现自己的Application：

- EasyPermissions（负责处理运行时权限的处理）

- uCrop（一个图片裁剪框架）


<!-- more -->



# 关键代码

**运行时权限+对话框选择是拍照还是选择照片**

Android6.0后，调用相机以及写入存储文件需要运行时申请权限，这里采用了 Google 官方的 EasyPermissions 框架来简化权限申请步骤。


````kotlin
    private var avatarFileName = "avatar.jpg"
    private var avatarOriginFileName = "avatarOrigin.jpg"

    companion object {
        private const val RC_CAMERA = 200
        private const val CHOOSE_PICTURE = 0
        private const val TAKE_PICTURE = 1
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        EasyPermissions.onRequestPermissionsResult(requestCode, permissions, grantResults, this)
    }

    /**
     * 显示修改图片的对话框
     */
    @AfterPermissionGranted(RC_CAMERA)
    fun showChoosePicDialog() {
        val currentApiVersion = android.os.Build.VERSION.SDK_INT
        val builder = android.app.AlertDialog.Builder(this)
        builder.setTitle("修改头像")
        val items = arrayOf("选择本地照片", "拍照")
        builder.setNegativeButton("取消", null)
        builder.setItems(items) { _, which ->
            when (which) {
                0 // 选择本地照片
                -> {
                    val perms = arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE)

                    if (EasyPermissions.hasPermissions(this, *perms)) {
                        val intent = Intent(Intent.ACTION_PICK)//返回被选中项的URI
                        intent.setDataAndType(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, "image/*")//得到所有图片的URI
                        startActivityForResult(intent, CHOOSE_PICTURE)
                    } else {
                        EasyPermissions.requestPermissions(this, "需要文件写入权限", RC_CAMERA, *perms)
                    }
                }
                1 // 拍照
                -> {
                    val perms = arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.CAMERA)

                    if (EasyPermissions.hasPermissions(this, *perms)) {
                        val openCameraIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)

                        val file = getAvatarFile(avatarOriginFileName)

                        if(file.exists())
                            file.delete()

                        val fileUri = if(currentApiVersion < 24) {
                            Uri.fromFile(file)
                        } else{
                            FileProvider.getUriForFile(this, getPackageName() + ".provider", file)
                        }

                        openCameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, fileUri)
                        openCameraIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                        openCameraIntent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                        startActivityForResult(openCameraIntent, TAKE_PICTURE)
                    }
                    else{
                        EasyPermissions.requestPermissions(this, "拍照需要系统摄像头权限授权和文件写入权限", RC_CAMERA, *perms)
                    }
                }
            }
        }
        builder.show()
    }
````

**对选择、裁剪成功等返回结果的处理**

Android7.0 对 APP 内的文件共享做了限制，外部不能直接访问你的内部文件。

这里需要用到FIleProvier，具体的FileProvider的配置在下一小节。


````kotlin
    public override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode == Activity.RESULT_OK) {
            when (requestCode) {
                // 对拍照返回的图片进行裁剪处理
                TAKE_PICTURE -> {
                    val imgUriSel = FileProvider.getUriForFile(this, "$packageName.provider", getAvatarFile(avatarOriginFileName))
                    cutImageByuCrop(imgUriSel)
                }
                // 对在图库选择的图片进行裁剪处理
                CHOOSE_PICTURE -> cutImageByuCrop(data?.data)
                // 上传裁剪成功的文件
                UCrop.REQUEST_CROP -> {
                    data?.let { uploadFile(it) }
                }
                // 输出裁剪
                UCrop.RESULT_ERROR -> {
                    val cropError = data?.let { UCrop.getError(it) }
                    ToastUtils.showShortToast(cropError.toString())
                }
    
            }
        }
    }
````

**使用uCrop框架对指定的文件进行裁剪**

uCrop 是一款很优秀的第三方裁剪框架，Bilibili的客户端也在使用。

一开始调用系统的裁剪的时候，出现过各种坑（比如MIUI用return-data的方式调用会报错，不用return-data有时候又拿不到返回值），于是才换用了这个。

````kotlin
    private fun cutImageByuCrop(uri: Uri?) {
        val outputImage = getAvatarFile(avatarFileName)
        val outputUri = Uri.fromFile(outputImage)

        uri?.let {
            UCrop.of(it, outputUri)
                    .withAspectRatio(1f, 1f)
                    .withMaxResultSize(256, 256)
                    .start(this)
        }
    }
````

**一个获得指定名字的[File]对象的私有方法**

```kotlin
private fun getAvatarFile(filename:String): File{
    // 使用 APP 内部储存空间
    val appDir = File(getExternalFilesDir(Environment.DIRECTORY_PICTURES).absolutePath, "Avatar")

    // 这句是使用外部存储空间的
    //val appDir = File(Environment.getExternalStorageDirectory().absolutePath, "LifeUp")

    if (!appDir.exists())
        appDir.mkdir()

    return File(appDir, filename)
}
```

**上传裁剪后的头像**

```kotlin
@Throws(IOException::class)
fun uploadFile(data: Intent) {
val file = getAvatarFile(avatarFileName)
    val file = getAvatarFile(avatarFileName)

    LoadingDialogUtils.show(this)
    userNetwork.updateAvatar(file)
}
```



**如果要调用系统内置的裁剪，部分代码：**

```kotlin
@Deprecated("use ucrop instead")
fun cutImage(uri: Uri?) {

    if (uri == null) {
        Log.i("tip", "The uri is not exist.")
    }
    tempUri = uri!!

    val intent = Intent("com.android.camera.action.CROP")
    //com.android.camera.action.CROP这个action是用来裁剪图片用的
    intent.setDataAndType(uri, "image/*")
    // 设置裁剪
    intent.putExtra("crop", "true")
    // aspectX aspectY 是宽高的比例
    intent.putExtra("aspectX", 1)
    intent.putExtra("aspectY", 1)
    // outputX outputY 是裁剪图片宽高
    intent.putExtra("outputX", 256)
    intent.putExtra("outputY", 256)
    //intent.putExtra("return-data", true)
    //val appDir = File(Environment.getExternalStorageDirectory().absolutePath, "LifeUp")
    tempUri = Uri.parse("file://" + "/" + Environment.getExternalStorageDirectory().absolutePath + "/" + "LifeUp" + "/" + avatarFileName)
    intent.putExtra(MediaStore.EXTRA_OUTPUT, uri)
    intent.putExtra("outputFormat", Bitmap.CompressFormat.JPEG.toString())
    intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
    intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
    intent.putExtra("noFaceDetection", true)

    startActivityForResult(intent, CROP_SMALL_PICTURE)
}
```

最好通过将 return-data 设为 false，然后通过传递 uri ， 返回时通过 uri 获取 File 的方式来使用。

MIUI 好像在 return-data 设为 true，在 intent 返回 bitmap 的情况下会报错。

另外，即便在 return-data 设为 false 的时候，MIUI 仍然可能会出现保存失败的情况。可能原始文件和裁剪后文件的 uri 不能相同（纯猜测）。



# FileProvider 配置

**在 AndroidManifest.xml 中加上：**

```xml
<!--FileProvider共享文件-->
<provider
    android:name="android.support.v4.content.FileProvider"
    android:authorities="net.sarasarasa.lifeup.provider"
    android:exported="false"
    android:grantUriPermissions="true">
    <meta-data
        android:name="android.support.FILE_PROVIDER_PATHS"
        android:resource="@xml/file_paths"/>
</provider>
```



**在 res/xml/file_paths.xml 中加上：**

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths>
    <files-path path="Android/data/net.sarasarasa.lifeup/files/Pictures/" name="Avatar" />
    <external-path path="Android/data/net.sarasarasa.lifeup/files/Pictures/" name="Avatar" />
    <external-files-path path="files/Pictures/Avatar" name="images"/>
    <root-path name="name" path="" />
</paths>
```