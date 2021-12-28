#!/bin/bash

# author: tianyong
# date: 2021/12/17
# target: 每天0点切割日志文件

# 注：若使用crontab定时任务，则建议每天23:59执行 ( 59 23 * * * bash /opt/sirius/split-sdk-log.sh > /dev/null )

# 核心代码 (这里的时间，是指文件内容变更时间)
DATE=`date -u +"%Y-%m-%d"`
# 拷贝当天日志文件
cp /opt/sirius/sdk-logs/sdk.log /opt/sirius/sdk-logs/sdk-$DATE".log"
# 清除原文件日志
cat /dev/null > /opt/sirius/sdk-logs/sdk.log
