#!/bin/bash

# replace, del char
1.  use ${}
  see   ${}.sh

2. use tr
tr 指令从标准输入设备读取数据，经过字符串转译后，将结果输出到标准输出设备。


3. match substring
if [[ "$value" == "cellular_"* ]];then
 echo match
fi

4. push string to arry
service_array=()
service_array+=("$value")

5. split string to arry
IFS='.' read -r -a myarray <<< "$1"

6. read string line by line
while read var; do
 echo $var
done <<< $service_info
#done < test.txt
