#!/bin/bash

# author: tianyong
# date: 2021/12/16
# target: management sdk project


# 1. 查看当前服务器是否存在java环境
INSTALL_JDK_VERSION=$(java -version 2>&1 |awk 'NR==1{print $3}');
INSTALL_JDK_FLAG=$INSTALL_JDK_VERSION | grep "jdk-11"
if [ -z "$JAVA_HOME" ]; then
   echo "JDK is not installed on the current server"
   exit 1
elif [ "$2" = "custom" ]; then
   export JAVA_HOME=/root/jdk-11.0.12
   export PATH=$JAVA_HOME/bin:$PATH
   export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
   if [ -z "$JAVA_HOME" ]; then
      echo "You need to install the JDK in the /root/jdk-11.0.12 or custom install"
   fi
elif [ -z "$INSTALL_JDK_FLAG" ]; then
   echo "The JDK version installed on the current system is lower than 11"
   exit 1
else
   echo "The currently used JDK version is: ${INSTALL_JDK_VERSION}"
fi;


# 2. 设置脚本选项
for c in $*
do
    if [ "$c" = "--stop" ] || [ "$c" = "-stop" ] || [ "$c" = "stop" ]; then
          CMD="stop"
    elif [ "$c" = "--start" ] || [ "$c" = "-start" ] || [ "$c" = "start" ]; then
          CMD="start"
    elif [ "$c" = "--restart" ] || [ "$c" = "-restart" ] || [ "$c" = "restart" ]; then
          CMD="restart"
    else
        if [ "$c" != "custom" ]; then
	   echo "The current option is not supported"
	   exit 1
	fi
    fi
done


# 3. 核心命令执行
DATE=`date -u +"%Y-%m-%d"`
if [ "$CMD" = "start" ]; then
   if [ -z $(netstat -nutlp | grep 8083 | awk '{print $7}' | cut -d / -f1) ]; then
      # 此处运行程序
      nohup java \
      -Djava.rmi.server.hostname=127.0.0.1 \
      -Dcom.sun.management.jmxremote.rmi.port=17091 \
      -Dcom.sun.management.jmxremote.port=17091 \
      -Dcom.sun.management.jmxremote.ssl=false \
      -Dcom.sun.management.jmxremote.authenticate=false \
      -Xms10g \
      -Xmx10g \
      -Xloggc:/opt/sirius/sdk-logs/sirius-sdk-gc-$DATE".log" 2>&1 \
      -Dfile.encoding=UTF-8 \
      -XX:+HeapDumpOnOutOfMemoryError \
      -XX:HeapDumpPath=/opt/sirius/sdk-logs/ \
      -XX:MetaspaceSize=1g \
      -XX:MaxMetaspaceSize=1g \
      -jar sirius-sdk.jar > /opt/sirius/sdk-logs/sirius-sdk-$DATE".log" 2>&1 &
   else
      echo "The current Process is already running"
      exit 0
   fi
elif [ "$CMD" = "stop" ]; then
   kill -term $(netstat -nutlp | grep 8083 | awk '{print $7}' | cut -d / -f1)
   exit 0
elif [ "$CMD" = "restart" ]; then
   kill -term $(netstat -nutlp | grep 8083 | awk '{print $7}' | cut -d / -f1)
   echo "The current process is close"   
   sleep 1;
   # 此处运行程序
   nohup java \
      -Djava.rmi.server.hostname=127.0.0.1 \
      -Dcom.sun.management.jmxremote.rmi.port=17091 \
      -Dcom.sun.management.jmxremote.port=17091 \
      -Dcom.sun.management.jmxremote.ssl=false \
      -Dcom.sun.management.jmxremote.authenticate=false \
      -Xms10g \
      -Xmx10g \
      -Xloggc:/opt/sirius/sdk-logs/sirius-sdk-gc-$DATE".log" 2>&1 \
      -Dfile.encoding=UTF-8 \
      -XX:+HeapDumpOnOutOfMemoryError \
      -XX:HeapDumpPath=/opt/sirius/sdk-logs/ \
      -XX:MetaspaceSize=1g \
      -XX:MaxMetaspaceSize=1g \
      -jar sirius-sdk.jar > /opt/sirius/sdk-logs/sirius-sdk-$DATE".log" 2>&1  &
   echo "The current process is start"
fi

