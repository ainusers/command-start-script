## 1. sdk.sh脚本使用教程
### 注：如果想添加包名，可将脚本中的包名提成变量，获取命令中输入的包名使用

### 启动
./sdk.sh start

### 关闭
./sdk.sh stop

### 重启
./sdk.sh restart

### 特殊情况下，使用自定义路径下jdk版本 (默认：/root/jdk-11.0.12)
./sdk.sh start custom

## 2. clear-sdk-log.sh脚本使用教程

### 启动
如果做定时任务，则建议每月1号执行 (0 0 1 * * bash /root/clear-sdk-log.sh > /dev/null)

## 3. split-sdk-log.sh脚本使用教程

### 启动
如果做定时任务，则建议每天23:59执行 (59 23 * * * bash /root/split-sdk-log.sh > /dev/null)
