#/bin/bash

# author: tianyong
# dateL 20220413
# target: 清空flink日志内容大小大于1g的文件

clear_dir=/opt/sirius/flink-1.13.1/log
for log_file in ${clear_dir}/*.out
do
  log_size=`du -sm ${log_file} | awk '{print $1}'`
  if [ ${log_size} -gt $((1024)) ]; then
    cat /dev/null > ${log_file}
    echo "已清空文件:${log_file}"
  fi
done
