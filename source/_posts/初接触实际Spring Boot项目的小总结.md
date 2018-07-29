---
title: 初接触实际Spring Boot项目的小总结
tags:
  - 技术
  - Java
categories:
  - 技术
  - 记录
abbrlink: 687507b9
date: 2018-07-26 01:52:30
---

先说下该项目用到的一些技术：

- Spring boot
- Maven
- lombok
- Jpa
- thymeleaf
- easypoi
- layui

<!-- more -->


# SQL Server 附加数据库时错误：拒绝访问

> 附加数据库失败，操作系统错误 5:"5(拒绝访问。)"

在相应的文件上，**右键ー属性ー安全**，给予`Authenticated Users`组**完全权限**。

然后尝试再次附加。



# Controller的几种写法

## 返回值

### 返回String

String的内容就相当于ViewName。



### 返回@ResponseBodyMap<String, Object>

于是方法体可以这样写：

```
Map<String, Object> map = new HashMap<>();
map.put("success", true);
map.put("message", "修改成功");
return map;
```

适用于ajax的异步请求。



### 返回ModelAndView

```
ModelAndView modelAndView = new ModelAndView();
modelAndView.setViewName("/login");
map.put("size", size);
map.put("page", page);
modelAndView.addObject(map);
return modelAndView;
```

与上面一种方法类似，但是可以自由设置View。



## 参数

### HttpSession session

可以直接获取到session。

假如session放入了一个user实例，前端可以这样获取：

```js
th:value="${session.user.userName}">
```



### @RequestBody + 实体类
能将前端传的json自动映射为一个实体类。

前端ajax写法：

```js
$.ajax({
    url: "/user/login",
            type: 'post',
            dataType: 'json',
            data: JSON.stringify(param),
            contentType: "application/json; charset=utf-8",
            success: function (res) {
        if (res.success) {
            layer.msg(res.message);
            setTimeout(function () {
                location.replace("/index");  //.跳转到登录后的页面
                return false;
            }, 400);    //.延时跳转，显示登录成功的消息
        } else {
            $("[name='userId']")[0].focus();
            layer.alert(res.message, {icon: 5});
        }
    },
    error: function () {
        layer.alert('操作失败！', {icon: 5});
    }
});
```

data可以自动转换表单项，也可以手动写：

```js
var data = {"oldPassword": oldPassword, "newPassword": newPassword};
```



### @RequestParam

如：`@RequestParam(value = "userName") String userName`

那么请求方式该是原本的链接后面加上`?userName=Ayagikei`



### Model model

获取model对象然后返回到前端页面。前端可以直接获取传入的东西。



# JS获取YYYY-MM-DD格式的当天日期

```js
var date = new Date();
var nowMonth = date.getMonth() + 1,
strDate = date.getDate(),
seperator = "-";
if (nowMonth >= 1 && nowMonth <= 9) {
    nowMonth = "0" + nowMonth;
}
if (strDate >= 0 && strDate <= 9) {
    strDate = "0" + strDate;
}
var res = date.getFullYear() + seperator + nowMonth + seperator + strDate;
```



# JS实现表格的展开/隐藏
以下代码举例的是多个表单的情况，以ID进行区分：
```js
//隐藏/展开按钮
$('.mine-hide-btn').click(function () {
    var id = $(this).attr('data-id');
    var classname = "trHidden" + id;

    if ($('.' + classname).attr("hidden") == "hidden") {
        $('.' + classname).removeAttr("hidden");
        $(this).text("隐藏");
    }
    else {
        $('.' + classname).attr("hidden", "hidden");
        $(this).text("展开");
    }

    return false;
});
```



# 分页

## 后端

### Controller

返回一个Page对象即可。

### Service（含模糊搜索的处理）

```java
Sort sort = new Sort(Sort.Direction.ASC, "id");
Pageable pageable = PageRequest.of(page, size, sort);

return userRepository.findAllByIdLike("%" + id + "%", pageable);
```

### Repository

Jpa只需要声明个方法即可：

```
Page<UserDO> findAllByIdLike(String id, Pageable pageable);
```



## 前端

### 内容展示

用 `th:each` 遍历展示传来的Page对象的所有内容即可。

### 页面指示器

```html
<div class="page-wrap">
    <ul class="pagination">
        <!-- 到达第一页按钮 -->
        <span th:if="${datas.isFirst()}">
            <li class="disabled"><span>«</span></li>
        </span>

        <span th:unless="${datas.isFirst()}">
            <li class="active"><a
                    th:href="@{'/admin/user-list?page=0' + '&search=' + ${search}}">«</a></li>
            <li><a th:href="@{'/admin/user-list?page='+${datas.getNumber()-1} +  + '&search=' + ${search}}"
                   th:text="${datas.getNumber()}">2</a></li>
        </span>

        <!-- 当前页面 -->
        <li class="active"><span th:text="${datas.getNumber()}+1">1</span></li>


        <!-- 到达尾页按钮 -->
        <span th:if="${datas.isLast()}">
            <li class="disabled">
                <span>»</span>
            </li>
        </span>

        <span th:unless="${datas.isLast()}">
            <li><a th:href="@{'/admin/user-list?page='+${datas.getNumber()+1} + '&search=' + ${search}}"
                   th:text="${datas.getNumber()}+2">2</a></li>
            <li class="active"><a
                    th:href="@{'/admin/user-list?page='+${datas.getTotalPages()-1}  + '&search=' + ${search}}">»</a></li>
        </span>
        <!-- end of 到达尾页 -->

    </ul>
</div> <!-- end of page-wrap div -->
```



# 查询指定日期的数据

举例为User表中Date字段为日期

## Repository

声明以下方法：

```java
List<User> findAllByUserIdAndDateGreaterThanEqualAndDateBefore(String userId, Date after, Date before, Sort sort);
```

## Service

```java
/** 查询某一天的订单
 * 需要将
 * Date变为当天的 yyyy-mm-dd 00:00:00
 * Date2为第二天的 yyyy-mm-dd 00:00:00
 */
Calendar calendar = Calendar.getInstance();
calendar.setTime(date);
calendar.set(Calendar.MINUTE, 0);
calendar.set(Calendar.HOUR, 0);
calendar.set(Calendar.SECOND, 0);
date = calendar.getTime();
calendar.set(Calendar.DATE, calendar.get(Calendar.DATE) + 1);
Date date2 = calendar.getTime();
```



# EasyPoi所用到的工具类以及设置边框的方法

## FileUtil.java

```java

import cn.afterturn.easypoi.excel.ExcelExportUtil;
import cn.afterturn.easypoi.excel.ExcelImportUtil;
import cn.afterturn.easypoi.excel.entity.ExportParams;
import cn.afterturn.easypoi.excel.entity.ImportParams;
import cn.afterturn.easypoi.excel.entity.enmus.ExcelType;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

public class FileUtil {
    public static void exportExcel(List<?> list, String title, String sheetName, Class<?> pojoClass, String fileName, boolean isCreateHeader, HttpServletResponse response) {
        ExportParams exportParams = new ExportParams(title, sheetName);
        //设置边框Styler（注意这里）
        exportParams.setStyle(ExcelExportStyler.class);

        exportParams.setCreateHeadRows(isCreateHeader);
        defaultExport(list, pojoClass, fileName, response, exportParams);

    }

    public static void exportExcel(List<?> list, String title, String sheetName, Class<?> pojoClass, String fileName, HttpServletResponse response) {
        ExportParams exportParams = new ExportParams(title, sheetName);
        //设置边框Styler
        exportParams.setStyle(ExcelExportStyler.class);

        defaultExport(list, pojoClass, fileName, response, exportParams);
    }

    public static void exportExcel(List<Map<String, Object>> list, String fileName, HttpServletResponse response) {
        defaultExport(list, fileName, response);
    }

    private static void defaultExport(List<?> list, Class<?> pojoClass, String fileName, HttpServletResponse response, ExportParams exportParams) {
        Workbook workbook = ExcelExportUtil.exportExcel(exportParams, pojoClass, list);

        if (workbook != null) ;
        downLoadExcel(fileName, response, workbook);
    }

    private static void downLoadExcel(String fileName, HttpServletResponse response, Workbook workbook) {
        try {
            response.setCharacterEncoding("UTF-8");
            response.setHeader("content-Type", "application/vnd.ms-excel");
            response.setHeader("Content-Disposition",
                    "attachment;filename=" + URLEncoder.encode(fileName, "UTF-8"));
            workbook.write(response.getOutputStream());
        } catch (IOException e) {
            throw new RuntimeException(e.getMessage());
        }
    }

    private static void defaultExport(List<Map<String, Object>> list, String fileName, HttpServletResponse response) {
        Workbook workbook = ExcelExportUtil.exportExcel(list, ExcelType.HSSF);
        if (workbook != null) ;
        downLoadExcel(fileName, response, workbook);
    }

    public static <T> List<T> importExcel(String filePath, Integer titleRows, Integer headerRows, Class<T> pojoClass) {
        if (StringUtils.isBlank(filePath)) {
            return null;
        }
        ImportParams params = new ImportParams();
        params.setTitleRows(titleRows);
        params.setHeadRows(headerRows);
        List<T> list = null;
        try {
            list = ExcelImportUtil.importExcel(new File(filePath), pojoClass, params);
        } catch (NoSuchElementException e) {
            throw new RuntimeException("模板不能为空");
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
        return list;
    }

    public static <T> List<T> importExcel(MultipartFile file, Integer titleRows, Integer headerRows, Class<T> pojoClass) {
        if (file == null) {
            return null;
        }
        ImportParams params = new ImportParams();
        params.setTitleRows(titleRows);
        params.setHeadRows(headerRows);
        List<T> list = null;
        try {
            list = ExcelImportUtil.importExcel(file.getInputStream(), pojoClass, params);
        } catch (NoSuchElementException e) {
            throw new RuntimeException("excel文件不能为空");
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage());
        }
        return list;
    }
}
```

## ExcelExportStyler.java

这是设置边框线的一个Styler。

```java
import cn.afterturn.easypoi.excel.export.styler.AbstractExcelExportStyler;
import cn.afterturn.easypoi.excel.export.styler.IExcelExportStyler;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Workbook;

public class ExcelExportStyler extends AbstractExcelExportStyler implements IExcelExportStyler {
    public ExcelExportStyler(Workbook workbook) {
        super.createStyles(workbook);
    }

    public CellStyle getHeaderStyle(short color) {
        CellStyle titleStyle = this.workbook.createCellStyle();
        Font font = this.workbook.createFont();
        font.setFontHeightInPoints((short) 12);
        titleStyle.setFont(font);
        titleStyle.setBorderBottom((short) 1);
        titleStyle.setAlignment((short) 2);
        titleStyle.setVerticalAlignment((short) 1);
        return titleStyle;
    }

    public CellStyle stringNoneStyle(Workbook workbook, boolean isWarp) {
        CellStyle style = workbook.createCellStyle();
        style.setBorderLeft((short) 1);
        style.setBorderRight((short) 1);
        style.setBorderBottom((short) 1);
        style.setBorderTop((short) 1);
        style.setAlignment((short) 2);
        style.setVerticalAlignment((short) 1);
        style.setDataFormat(STRING_FORMAT);
        if (isWarp) {
            style.setWrapText(true);
        }

        return style;
    }

    public CellStyle getTitleStyle(short color) {
        CellStyle titleStyle = this.workbook.createCellStyle();
        titleStyle.setBorderLeft((short) 1);
        titleStyle.setBorderRight((short) 1);
        titleStyle.setBorderBottom((short) 1);
        titleStyle.setBorderTop((short) 1);
        titleStyle.setAlignment((short) 2);
        titleStyle.setVerticalAlignment((short) 1);
        titleStyle.setWrapText(true);
        return titleStyle;
    }

    public CellStyle stringSeptailStyle(Workbook workbook, boolean isWarp) {
        return isWarp ? this.stringNoneWrapStyle : this.stringNoneStyle;
    }
}

```



# MD5Utils

```java
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;


public class MD5Utils {
    /**
     * 可以把一段文字转换为MD
     * Can convert a file to MD5
     *
     * @param text
     * @return md5
     */
    public static String encode(String text) {
        try {
            MessageDigest digest = MessageDigest.getInstance("md5");
            byte[] buffer = digest.digest(text.getBytes());
            // byte -128 ---- 127
            StringBuffer sb = new StringBuffer();
            for (byte b : buffer) {
                int a = b & 0xff;
                // Log.d(TAG, "" + a);
                String hex = Integer.toHexString(a);

                if (hex.length() == 1) {
                    hex = 0 + hex;
                }
                sb.append(hex);
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return null;
    }
}
```



# 不定长度的单元格合并的前端展示以及导出

## 前端展示

重点就是rowspan要设为长度，同时第一个td要只出现一遍，所以要加个if限定。

```html
<span th:each="item,itemIter : ${table}">
        <tr th:each="obj,objIter:${item.getPara()}">
            <td class="hidden-xs" th:text="${item.getId()}" th:rowspan="${item.getParaSize()}"
                th:if="${objIter.count == 1}">112</td>
            <td class="hidden-xs" th:text="${objIter.count}">段数</td>
            <td class="hidden-xs" th:text="${obj.getLeftMargin()}">左边距</td>
            <td class="hidden-xs" th:text="${obj.getStartPoint()}">开始点数</td>
            <td class="hidden-xs" th:text="${obj.getLength()}">切割长度</td>
            <td class="hidden-xs" th:text="${obj.getEndPoint()}">结束点数</td>
            <td class="hidden-xs" th:text="${obj.getRightMargin()}">右边距</td>
            <td class="hidden-xs" th:text="${obj.getGzl()}">工作令</td>
        </tr>
</span>
```

## 导出

在需要合并的List上加注解：

```java
@ExcelCollection(name = "", orderNum = "1")
```