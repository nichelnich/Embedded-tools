# 括号，符号
$() == ``
${}  # 模式匹配
$[] == $(())  # 数学运算
    $ a=5; b=7; c=2
    $ echo $(( a+b*c ))
    19
[ ] == test

(( ))及[[ ]] 
分别是[ ]的针对数学比较表达式和字符串表达式的加强版。
[[ ]]中增加模式匹配特效；
(( ))不需要再将表达式里面的大小于符号转义，除了可以使用标准的数学运算符外，还增加了以下符号：


# array
array_name=(value1 value2 ... valuen)  # 数组定义
${array_name[index]}     #数组元素
${array_name[@]}        #数组表示
${#array_name[@]}       #数组长度


# $IFS
$IFS  #bash use $IFS 作为字符串分隔符，可以更改$IFS
echo "$IFS" | od -b  # see IFS
# example
echo "192.168.1.1" | { IFS=. read a b c d e;}


# read
# print