> **特别声明：本脚本仅供研究学习使用，遵循GPL开源协议，不得用于获取商业利益。**

## 说明

项目代码使用Lua脚本语言编写，相较于Python，Lua更加轻量小巧，更适合于在路由器上使用，并且LEDE/OpenWrt默认支持Lua。
    
项目代码基于未上岸大哥的[【GDDX_Portal Python版】](https://github.com/lililala/GDDX_Portal)重写，感谢开源

## 更新日志

### 2020年10月8日

由于此前的写法，在非`start.lua`所在路径执行`lua /xxxx/xxx/start.lua`会出现找不到导入包、配置的情况，也因此使用定时任务时，出现不起无法认证的情况，为解决这个问题，将需要用到的`md5.lua`、`json.lua`包cp至`/usr/lib/lua`，将原先的`conf.lua`合并到`start.lua`中。

## 支持院校

测试可用

- 广东工业大学华立学院（增城校区）

## 运行环境

支持Lua环境的设备均可。

## 使用说明

### 将源码上传至路由器

```bash
scp -r lua_esurfing\ root@10.10.20.1:/root/lua_esurfing
```

### 配置bin\start.lua

> 如果不熟悉linux命令，也可配置后再上传路由器

```lua
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


```bash
lua start.lua 
```

返回下面JSON则认证成功

```json
{"resinfo":"login success","rescode":"0"}
```

### 定时启动

在`/etc/crontabs/root`中添加

```bash
1 7 * * 6,7 lua /root/lua_esurfing/bin/start.lua >>/root/lua_esurfing/cron.log
30 7 * * 6,7 lua /root/lua_esurfing/bin/start.lua >>/root/lua_esurfing/cron.log
1 9 * * 1,2,3,4,5 lua /root/lua_esurfing/bin/start.lua >>/root/lua_esurfing/cron.log
30 9 * * 1,2,3,4,5 lua /root/lua_esurfing/bin/start.lua >>/root/lua_esurfing/cron.log
```



## 常见问题

### module 'md5' not found

由于openwrt默认编译并不包括lua-md5，如果出现该报错，需要自行解压项目目录中的`luamd5.tar`库到`/usr/lib/lua`。

```bash
tar -xf luamd5.tar
```

### module 'socket.http' not found

原因同上

```bash
opkg install luarocks
```

## 参考项目

- [OpenWrt版小蝴蝶拨号认证插件](https://github.com/ok-dok/lua_supplicant)
- [GDDX_Portal](https://github.com/lililala/GDDX_Portal)