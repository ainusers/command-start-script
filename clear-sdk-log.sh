#!/bin/bash

# author: tianyong
# date: 2021/12/17
# target: 清除sirius-sdk离线分析项目,7天前产生的日志文件

# 注：若使用crontab定时任务，则建议每月1号执行 ( 0 0 1 * * bash /opt/sirius/clear-sdk-log.sh > /dev/null )

# 核心代码 (这里的时间，是指文件内容变更时间)
DATE=`date -u +"%Y-%m-%d"`

find /opt/sirius/sdk-logs -mtime +7 -name "*.log" -exec rm -rf {} \;   
echo "$DATE 成功清除/opt/sirius/sdk-logs目录下7天前的日志文件"
