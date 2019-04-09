---
title: SpringBoot2+Jpa+Shiro实现用户鉴权
tags:
  - 后端
  - 技术
  - SpringBoot2
  - Java
  - 框架
categories:
  - 技术
  - 后端
abbrlink: 27139efb
date: 2019-04-09 22:04:26
---

课设有个额外任务是用Shiro实现用户鉴权，记录一下。

大部分步骤都参考了 https://xlui.me/t/spring-boot-shiro/ 这篇文章，安利一下~

不过也遇到了一些小问题。

<!-- more -->

## 添加依赖

或是添加以下 Maven 依赖

```xml
<!-- shiro -->
<dependency>
  <groupId>org.apache.shiro</groupId>
  <artifactId>shiro-spring</artifactId>
  <version>RELEASE</version>
</dependency>
```

<br />

## 建表和实体类

Sql语句建表

```sql
DROP TABLE IF EXISTS `shiro_permission`;
CREATE TABLE `shiro_permission` (
  `permission_id` int(10) NOT NULL AUTO_INCREMENT,
  `permission` varchar(128) NOT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `remark` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`permission_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `shiro_role`;
CREATE TABLE `shiro_role` (
  `role_id` int(10) NOT NULL AUTO_INCREMENT,
  `role` varchar(128) NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `remark` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `shiro_role_permission`;
CREATE TABLE `shiro_role_permission` (
  `rp_id` int(10) NOT NULL AUTO_INCREMENT,
  `permission_id` int(128) NOT NULL,
  `role_id` int(128) NOT NULL,
  PRIMARY KEY (`rp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `shiro_user`;
CREATE TABLE `shiro_user` (
  `user_id` int(10) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `salt` varchar(128) NOT NULL,
  `username` varchar(64) NOT NULL,
  `nickname` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) NOT NULL,
  `remark` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `shiro_user_role`;
CREATE TABLE `shiro_user_role` (
  `ur_id` int(10) NOT NULL AUTO_INCREMENT,
  `user_id` int(128) NOT NULL,
  `role_id` int(128) NOT NULL,
  PRIMARY KEY (`ur_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
```

PermissionDO.java

```java
package net.sarasarasa.dataobject;

import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * @author AyagiKei
 * @url https://github.com/Ayagikei
 **/

@Data
@Entity
@Table(name = "shiro_permission")
public class PermissionDO implements Serializable {

    private static final long serialVersionUID = -2815922618943120009L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "permission_id")
    private Integer permissionId;
    private String permission;

    // 创建时间
    @Column(name = "create_time")
    private Date createTime;

    private String remark;

    @ManyToMany
    @JoinTable(name = "shiro_role_permission", joinColumns = {@JoinColumn(name = "permission_id")}, inverseJoinColumns = {@JoinColumn(name = "role_id")})
    private List<RoleDO> roleList;

    @Override
    public String toString() {
        return permission;
    }
}
```

RoleDO.java

```java
package net.sarasarasa.dataobject;

import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * @author AyagiKei
 * @url https://github.com/Ayagikei
 **/

@Data
@Entity
@Table(name = "shiro_role")
public class RoleDO implements Serializable {

    private static final long serialVersionUID = 2532670665590869938L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "role_id")
    private Integer roleId;
    private String role;

    @ManyToMany
    @JoinTable(name = "shiro_user_role", joinColumns = {@JoinColumn(name = "role_id")}, inverseJoinColumns = {@JoinColumn(name = "user_id")})
    private List<UserDO> userList;

    @ManyToMany
    @JoinTable(name = "shiro_role_permission", joinColumns = {@JoinColumn(name = "role_id")}, inverseJoinColumns = {@JoinColumn(name = "permission_id")})
    private List<PermissionDO> permissionList;

    // 创建时间
    @Column(name = "create_time")
    private Date createTime;

    private String remark;

    @Override
    public String toString() {
        return role;
    }


}
```

UserDO.java

```java
package net.sarasarasa.dataobject;

import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * @author AyagiKei
 * @url https://github.com/Ayagikei
 **/

@Data
@Entity
@Table(name = "shiro_user")
public class UserDO implements Serializable {
    private static final long serialVersionUID = -2319943079325710028L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "username", nullable = false, unique = true)
    private String username;

    private String nickname;

    private String password;
    private String salt;    // 密码加盐

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "shiro_user_role", joinColumns = {@JoinColumn(name = "user_id")}, inverseJoinColumns = {@JoinColumn(name = "role_id")})
    private List<RoleDO> roleList;

    // 创建时间
    @Column(name = "create_time")
    private Date createTime;

    private String remark;

    @Override
    public String toString() {
        return "User[id = " + userId + ", username = " + username + ", password = " + password + ", salt = " + salt + "]";
    }

}
```

注意Username是要保证唯一性的。

<br />

## 初始化数据库数据

```sql
INSERT INTO shiro_user (id, password, salt, username) VALUES
  (1, "dev", "salt", "admin");

INSERT INTO shiro_role (id, role) VALUES
  (1, "admin"),
  (2, "normal");

INSERT INTO shiro_permission (id, permission) VALUES
  (1, "user info"),
  (2, "user add"),
  (3, "user del");

INSERT INTO shiro_user_role (user_id, role_id) VALUES
  (1, 1);

INSERT INTO shiro_role_permission (permission_id, role_id) VALUES
  (1, 1),
  (2, 1);
```

这里的数据直接来自参考的文章（偷懒。

<br />

# JPA查询接口

```java
public interface UserRepository extends JpaRepository<User, Integer> {
  User findByUsername(String username);
}
```

对于Shiro暂时只需要这个接口。

<br />

# Shiro 配置

 ```java
  package net.sarasarasa.config;
  
  import org.apache.shiro.mgt.SecurityManager;
  import org.apache.shiro.spring.security.interceptor.AuthorizationAttributeSourceAdvisor;
  import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
  import org.apache.shiro.web.mgt.DefaultWebSecurityManager;
  import org.springframework.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator;
  import org.springframework.context.annotation.Bean;
  import org.springframework.context.annotation.Configuration;
  
  import java.util.LinkedHashMap;
  import java.util.Map;
  
  /**
   * @author AyagiKei
   * @url https://github.com/Ayagikei
   * 对Shiro的配置
   **/
  
  @Configuration
  public class ShiroConfiguration {
  
      /**
       * 开启对注解 `@RequirePermission` 的支持
       * 在按参考的文章写完配置之后，依然不能使用RequirePermission注解，
       * 在加上这个方法之后才ok。
       */
      @Bean
      public static DefaultAdvisorAutoProxyCreator getDefaultAdvisorAutoProxyCreator() {
  
          DefaultAdvisorAutoProxyCreator defaultAdvisorAutoProxyCreator = new DefaultAdvisorAutoProxyCreator();
          defaultAdvisorAutoProxyCreator.setUsePrefix(true);
  
          return defaultAdvisorAutoProxyCreator;
      }
  
  
      @Bean
      public AuthorizationAttributeSourceAdvisor authorizationAttributeSourceAdvisor(SecurityManager securityManager) {
          AuthorizationAttributeSourceAdvisor authorizationAttributeSourceAdvisor = new AuthorizationAttributeSourceAdvisor();
          authorizationAttributeSourceAdvisor.setSecurityManager(securityManager);
          return authorizationAttributeSourceAdvisor;
      }
  
      /**
       * 自己实现的 Realm，Shiro 的认证最终都交给 Realm 进行执行了。我们需要自己实现一个 Realm，继承自 AuthrozingRealm
       */
      @Bean
      public MyShiroRealm myShiroRealm() {
          return new MyShiroRealm();
      }
  
      @Bean
      public DefaultWebSecurityManager securityManager() {
          DefaultWebSecurityManager securityManager = new DefaultWebSecurityManager();
          securityManager.setRealm(myShiroRealm());
          return securityManager;
      }
  
      @Bean
      public ShiroFilterFactoryBean shiroFilterFactoryBean(SecurityManager securityManager) {
          ShiroFilterFactoryBean shiroFilterFactoryBean = new ShiroFilterFactoryBean();
          shiroFilterFactoryBean.setSecurityManager(securityManager);
  
          Map<String, String> filterChainDefinitionMap = new LinkedHashMap<>();
  
          // 指定访问所需要的权限perms或者roles
          // url可以用**或者*表示不同程度的通配符匹配
          // 这里重叠匹配的url好像跟调用顺序有关
          filterChainDefinitionMap.put("/page/manage/**", "perms[manage]");
          filterChainDefinitionMap.put("/page/manage/**", "roles[manager]");
  
          
          filterChainDefinitionMap.put("/static/**", "anon");        			
          filterChainDefinitionMap.put("/login", "anon");
          filterChainDefinitionMap.put("/**", "authc");
          // authc 表示需要验证身份才能访问，anon 表示不需要
          
          filterChainDefinitionMap.put("/toUser", "user");
          // user与authc比较相似，
          // 表示用户不一定需要已经通过认证,只需要曾经被Shiro记住过登录状态(rememberMe)就可以正常访问。
  
  
  		// 设置登陆页面，在没有登陆之前访问需要验证的页面会跳转到这里
          shiroFilterFactoryBean.setLoginUrl("/login");
          // 设置未授权页面，在登陆后访问权限不够的页面会跳转到这里（不设置默认返回401页面）
          shiroFilterFactoryBean.setUnauthorizedUrl("/unauthorized");
          // 如果不设置，默认 Shiro 会寻找 classpath:/template/login.jsp 文件
          shiroFilterFactoryBean.setSuccessUrl("/index");
          // 成功登陆后跳转
          
          // 配置注销页面，访问该链接会自动实现注销（登出）功能
  		filterChainDefinitionMap.put("/logout", "logout");
          shiroFilterFactoryBean.setFilterChainDefinitionMap(filterChainDefinitionMap);
          return shiroFilterFactoryBean;
      }
  }
 ```

<br />

## Shiro 认证和授权

Shiro 的认证和授权操作都是交给 Realm 类实现的，我们要自定义一个 Realm 实现获取数据（用户对应的角色、权限，还有密码等）的具体逻辑。

```java
package net.sarasarasa.config;

import lombok.extern.slf4j.Slf4j;
import net.sarasarasa.dao.UserRepository;
import net.sarasarasa.dataobject.PermissionDO;
import net.sarasarasa.dataobject.RoleDO;
import net.sarasarasa.dataobject.UserDO;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.credential.CredentialsMatcher;
import org.apache.shiro.authc.credential.HashedCredentialsMatcher;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @author AyagiKei
 * @url https://github.com/Ayagikei
 **/
@Slf4j
public class MyShiroRealm extends AuthorizingRealm {
    @Autowired
    private UserRepository userRepository;

    /**
     * 负责授权，获取用户所拥有的所有权限
     */
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
        log.info("权限配置：MyShiroRealm.doGetAuthorizationInfo");
        SimpleAuthorizationInfo authorizationInfo = new SimpleAuthorizationInfo();
        UserDO user = (UserDO) principalCollection.getPrimaryPrincipal();
        log.info("为用户 " + user.getUsername() + " 进行权限配置");

        for (RoleDO role : user.getRoleList()) {
            authorizationInfo.addRole(role.getRole());
            for (PermissionDO permission : role.getPermissionList()) {
                authorizationInfo.addStringPermission(permission.getPermission());
            }
        }

        return authorizationInfo;
    }

    /**
     * 负责身份认证，即登陆的时候验证密码
     */
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {
        log.info("开始身份认证");
        String username = (String) authenticationToken.getPrincipal();
        log.info("输入得到的用户名：" + username);
        UserDO user = userRepository.findByUsername(username);
        // 从数据库中查找 UserDO

        if (user == null) {
            return null;
        }

        log.info("用户信息：\n" + user.toString());
        SimpleAuthenticationInfo authenticationInfo = new SimpleAuthenticationInfo(
                user,
                user.getPassword(),
                // ByteSource.Util.bytes(user.getSalt()),  // 对密码进行加盐验证
                getName()
        );
        return authenticationInfo;
    }

}
```

没有进行加盐验证的Shiro配置就这样写好了，可以先进行简单测试。

<br />

## Controller + 测试

```java
package net.sarasarasa.controller;

import lombok.extern.slf4j.Slf4j;
import net.sarasarasa.dao.UserRepository;
import net.sarasarasa.dataobject.UserDO;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.DisabledAccountException;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;


@Slf4j
@Controller
public class LoginController {
    @Autowired
    private UserRepository userRepository;

    @PostMapping("/login")
    public @ResponseBody
    Map<String, Object> login(
            @RequestParam(value = "username") String username,
            @RequestParam(value = "password") String password) {

        log.info("用户登陆，使用username=" + username + " password=" + password);

        Map<String, Object> map = new HashMap<>();
        Subject user = SecurityUtils.getSubject();
        UsernamePasswordToken token = new UsernamePasswordToken(username, password);
        map.put("success", false);

        try {
            user.login(token);
            map.put("success", true);
        } catch (UnknownAccountException | IncorrectCredentialsException e) {
            map.put("msg", "账号不存在或密码错误！");
        } catch (DisabledAccountException e) {
            map.put("msg", "账号未启用！");
        } catch (Throwable e) {
            map.put("msg", "未知错误！");
        }

        return map;
    }
}
```

这里就不放页面了，可以用Postman之类的简单测试下。

接下来讲讲开始加盐验证。

<br />

# 加盐验证

首先先让我们的admin账号的密码加个密，Controller中加入：

```java
/**
 * 临时使用对admin用户的密码进行加盐操作的方法
 **/
@RequestMapping("/en")
@ResponseBody
public String encrypt() {
    UserDO user = userRepository.findByUsername("admin");
    // 这里用的盐选择是时间+固定字符串然后MD5的结果
    user.setSalt((new SimpleHash("MD5", userDO.getPassword(), ByteSource.Util.bytes(new Date().toString() + "Sara"), 1024)).toString());
    user.setPassword((new SimpleHash("MD5", userDO.getPassword(), ByteSource.Util.bytes(userDO.getSalt()), 1024)).toString());
    userRepository.save(user);
    return "";
}
```

然后访问一下“/en”。

<br />

## 注入加密方式

### 方法1：重写 `MyShiroRealm`（自定义 Realm 类）的 `setCredentialsMatcher` 方法：

```java
/**
 * 使用加盐验证
 **/
@Override
public void setCredentialsMatcher(CredentialsMatcher credentialsMatcher) {
    // 重写 setCredentialsMatcher 方法为自定义的 Realm 设置 hash 验证方法
    HashedCredentialsMatcher hashedCredentialsMatcher = new HashedCredentialsMatcher();
    hashedCredentialsMatcher.setHashAlgorithmName("MD5");
    hashedCredentialsMatcher.setHashIterations(1024);
    super.setCredentialsMatcher(hashedCredentialsMatcher);
}
```

###  方法2：在 `ShiroConfiguration` 中注入：

```java
@Configuration
public class ShiroConfiguration {
// ...

  @Bean
  public HashedCredentialsMatcher hashedCredentialsMatcher(){
    HashedCredentialsMatcher hashedCredentialsMatcher = new HashedCredentialsMatcher();
    hashedCredentialsMatcher.setHashAlgorithmName("md5");
    hashedCredentialsMatcher.setHashIterations(1024);
    return hashedCredentialsMatcher;
  }

  @Bean
  public MyShiroRealm myShiroRealm() {
    MyShiroRealm myShiroRealm = new MyShiroRealm();
    myShiroRealm.setCredentialsMatcher(hashedCredentialsMatcher());
    return myShiroRealm;
  }
}
```

<br />

## 在MyShiroRealm的doGetAuthenticationInfo方法中传入盐

```java
...
@Override
protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {
    log.info("开始身份认证");
    String username = (String) authenticationToken.getPrincipal();
    log.info("输入得到的用户名：" + username);
    UserDO user = userRepository.findByUsername(username);

    if (user == null) {
        return null;
    }

    log.info("用户信息：\n" + user.toString());
    SimpleAuthenticationInfo authenticationInfo = new SimpleAuthenticationInfo(
            user,
            user.getPassword(),
            ByteSource.Util.bytes(user.getSalt()),  // 其实就是加上这句
            getName()
    );
    return authenticationInfo;
}
...
```
至此应该就实现了Shiro的完整配置了。

<br />

# 遇到过的一些问题

## LazyInitializationException

JPA + shiro好像可能会遇到这个懒加载的问题，这个异常出现在已经认证的用户访问一些需要特定权限的页面

。

我采用的解决方案是在application.yml中加入一句：

```xml
spring.jpa.properties.hibernate.enable_lazy_load_no_trans = true
```

这个可能有些弊端，，可以参考下另外的解决方案：<https://blog.csdn.net/zcs20082015/article/details/80751626>

<br />

## @RequiresPermissions不生效，并且不会跳转到指定的未验证页面

其实上面的代码已经解决了不生效的问题，原本参考的文章里没有注入这个方法，加入之后就没问题了。

```java
  @Bean
  public static DefaultAdvisorAutoProxyCreator getDefaultAdvisorAutoProxyCreator() {
  
      DefaultAdvisorAutoProxyCreator defaultAdvisorAutoProxyCreator = new DefaultAdvisorAutoProxyCreator();
      defaultAdvisorAutoProxyCreator.setUsePrefix(true);
  
      return defaultAdvisorAutoProxyCreator;
  }
```
注解的使用方法：

```java
@RequiresPermissions(value = "manage add update")
```

然后注解拦截的确实不会跳转到我们在Shiro配置里指定的页面，而是会抛出一个异常UnauthorizedException，我们可以在全局异常处理中接收这个异常然后重定向：

```kotlin
package net.sarasarasa.exception.handler

import org.apache.shiro.authz.UnauthorizedException
import org.slf4j.LoggerFactory
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.ResponseBody
import org.springframework.web.servlet.ModelAndView


/**
 * @author AyagiKei
 * @url https://github.com/Ayagikei
 *
 **/

@ControllerAdvice
class GlobalExceptionHandler {
    private val log = LoggerFactory.getLogger(this.javaClass)

    /**
     * 拦截未授权异常，重定向到"未授权"页面
     */
    @ExceptionHandler(value = UnauthorizedException::class)
    fun handleUserAuthorizeException(): String {
        return "redirect:/unauthorized"
    }

    @ExceptionHandler(value = Exception::class)
    @ResponseBody
    fun handleGlobalException(e: Exception): ModelAndView {
        e.printStackTrace()
        log.error("系统异常：", e.toString())
        val view = ModelAndView()
        return view
    }
}
```

<br />

## 尝试混用 Kotlin 启动报错

上面的全局异常用的就是Kotlin，发现少了一个maven依赖：

```xml
<!-- kotlin -->
<dependency>
    <groupId>org.jetbrains.kotlin</groupId>
    <artifactId>kotlin-stdlib-jdk8</artifactId>
    <version>${kotlin.version}</version>
</dependency>
<dependency>
    <groupId>org.jetbrains.kotlin</groupId>
    <artifactId>kotlin-test</artifactId>
    <version>${kotlin.version}</version>
    <scope>test</scope>
</dependency>

<!-- 就是少了这个reflect的依赖，启动的时候会失败 -->
<dependency>
    <groupId>org.jetbrains.kotlin</groupId>
    <artifactId>kotlin-reflect</artifactId>
    <version>1.2.41</version>
</dependency>
```