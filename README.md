> **特别声明：本脚本仅供研究学习使用，遵循GPL开源协议，不得用于获取商业利益。**

## 说明

项目代码使用Lua脚本语言编写，相较于Python，Lua更加轻量小巧，更适合于在路由器上使用，并且LEDE/OpenWrt默认支持Lua。
    
项目代码基于未上岸大哥的[【GDDX_Portal Python版】](https://github.com/lililala/GDDX_Portal)重写，感谢开源

## 支持院校

测试可用

- 广东工业大学华立学院（增城校区）

## 运行环境

支持Lua环境的设备均可。

## 使用说明

### 将源码上传至路由器

```
scp -r lua_esurfing\ root@10.10.20.1:/root/lua_esurfing
```

### 配置conf.lua

> 如果不熟悉linux命令，也可配置后再上传路由器

```
#!/usr/bin/lua

-- 内网ip地址 即WAN口IP
clientip='0.0.0.0'

-- 认证服务器地址 
nasip='0.0.0.0'

-- mac地址，字母大写，使用-分割
mac='AA-BB-CC-DD-EE-FF'

-- 安全码，无需修改
secret='Eshore!@#'

-- 用户名
username='123456'

-- 密码
password='123455'
```

根据实际情况修改

### 启动


```
lua start.lua 
```

返回下面JSON则认证成功

```
{"resinfo":"login success","rescode":"0"}
```


## 常见问题

### module 'md5' not found

由于openwrt默认编译并不包括lua-md5，如果出现该报错，需要自行解压项目目录中的`luamd5.tar`库到`/usr/lib/lua`。

```
tar -xf luamd5.tar
```

### module 'socket.http' not found

原因同上

```
opkg install luarocks
```

## 参考项目

- [OpenWrt版小蝴蝶拨号认证插件](https://github.com/ok-dok/lua_supplicant)
- [GDDX_Portal](https://github.com/lililala/GDDX_Portal)