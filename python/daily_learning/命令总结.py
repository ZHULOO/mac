'''一、安装运行问题'''
# 1、安装anaconda环境以后，用conda install Scrapy命令安装第三方库，避免使用pip install Scrapy；将python和scripts文件夹路径添加
#     到系统环境变量设置中path路径中，键入python进入python命令窗口，键入exit（）、quit（）、ctrl+z回车退出python命令；单行注释，'''开
#     头和结尾来进行多行注释'''
# 2、cd命令注意事项：首先要切换进入到根目录（直接输入E:），才能用“cd E:\Codelearning\python\理解if_name_main”命令进入“理解_if_mail”
#     文件夹目录，可以用cd\命令回到根目录，cd命令大全详见https://baike.baidu.com/item/DOS%E5%91%BD%E4%BB%A4/5143255?fr=aladdin
# 3、python的运行方式：python命令行模式下，命令行交互输入，此时不能输入const.py脚本运行；cmd命令窗口下，用“python E:\Codelearning\
#     python\理解if_name_main\const.py”命令运行const.py脚本，或者用“cd E:\Codelearning\python\理解if_name_main”命令进入“理解_if_mail”
#     进入当前目录以后，直接用“python const.py”运行。
# 4、conda和pip安装包的问题：能用conda安装的包，优先使用conda install，conda无法安装的再使用pip install；
# 5、conda安装和更新的一些操作：
conda info
conda list
conda update conda
conda update python
conda install xxx
conda uninstall xxx

'''更新库'''
pip list            # 列出所有库;
pip list --outdated # 列出所有过期库;
pip install --upgrade beautifulsoup4 # 单独更新某个库
# 循环更新所有过期库:
import pip
from subprocess import call
from pip._internal.utils.misc import get_installed_distributions
for dist in get_installed_distributions():
    call("pip install --upgrade " + dist.project_name, shell=True) # 获得所有库的名称,循环调用shell来更新;
# conda创建虚拟环境相关操作
# 参考：https://blog.csdn.net/qq_42902264/article/details/105299796
conda env list #列出当前可用的虚拟环境
conda create -n matlab_vs python=3.7.0 #创建一个名称为matlab_vs的虚拟环境，使用python3.7.0版本；
conda activate matlab_vs # 激活matlab_vs环境；
conda deactivate # 关闭当前环境；

# 或者创建一个全新的环境，并为环境设置一个单独的源设置文件.condarc
# 然后安装geopandas可以成功，如下：
# 原因可能是geopandas依赖的包和已安装的包冲突，而新创建的环境，所有依赖包都是全新安装；
conda create -n geo_env
conda activate geo_env
conda config --env --add channels conda-forge   #为环境单独添加一个.condarc源设置文件：
conda config --env --set channel_priority strict
conda install python=3 geopandas
# conda源设置
# 通过修改用户目录下的 .condarc 文件。Windows 用户无法直接创建名为 .condarc 的文件，可先执行 conda config --set show_channel_urls yes 生成该文件之后再修改。
'''
channels:
    - defaults
show_channel_urls: true
default_channels:
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/pro
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
    conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
'''
# 即可添加 Anaconda Python 免费仓库。
# 运行 conda clean -i 清除索引缓存，保证用的是镜像站提供的索引。
# 运行 conda create -n myenv numpy 测试一下吧。
# 查看当前源：conda config --show


# 6、anaconda瘦身：
'''
第一步：通过conda clean -p来删除一些没用的包，这个命令会检查哪些包没有在包缓存中被硬依赖到其他地方，并删除它们。
第二步：通过conda clean -t可以将conda保存下来的tar包。经过上面两步，我的anaconda便变成了4.3G，几乎瘦身一半。
有一点要注意的是，conda clean命令是对所有anaconda下的包进行搜索，当然也包括构建的其他Python环境中的包，这一点还是很高效的，不用再进入其他环境重复操作。'''

'''二、python环境下切换工作路径'''
import os
os.getcwd() #显示当前工作路径
os.chdir()  #改变当前工作路径
f = open('test.txt','w') #就可以直接打开当前路径下的文件了
.py文件不能和包和命令名重复,否则报错

'''数据分析常用库'''
# 数据处理:
numpy
pandas
scipy
# 数据分析:
statsmodels

# 可视化
pyecharts
matplotlib
seaborn

'''Python语句规则'''
# 冒号和缩近,像if、while、def和class这样的复合语句，首行以关键字开始，以冒号( : )结束，该行之后的一行或多行代码构成代码组。
# Python对代码的缩进要求非常严格，如果不采用合理的代码缩进，将抛出SyntaxError异常。错误表明，你使用的缩进方式不一致，有的
# 是 tab 键缩进，有的是空格缩进，改为一致即可。有时候代码采用合理的缩进但是缩进的情况不同，代码的执行结果也不同。有相同的缩
# 进的代码表示这些代码属于同一代码块。
# Python语句中一般以新行作为为语句的结束符。但是我们可以使用斜杠（ \）将一行的语句分为多行显示。语句中包含[], {} 或 () 括号就不需要使用多行连接符。
# Python空行函数之间或类的方法之间用空行分隔，表示一段新的代码的开始。类和函数入口之间也用一行空行分隔，以突出函数入口的开始。
# 空行与代码缩进不同，空行并不是Python语法的一部分。书写时不插入空行，Python解释器运行也不会出错。但是空行的作用在于分隔两段不同功能或含义的代码，
# 便于日后代码的维护或重构。
# 记住：空行也是程序代码的一部分。
'''print函数'''
print(*objects, sep=' ', end='\n', file=sys.stdout, flush=False)
# 参数
# objects -- 复数，表示可以一次输出多个对象。输出多个对象时，需要用 , 分隔。
# sep -- 用来间隔多个对象，默认值是一个空格。
# end -- 用来设定以什么结尾。默认值是换行符 \n，我们可以换成其他字符串。
# file -- 要写入的文件对象。
# flush -- 输出是否被缓存通常决定于 file，但如果 flush 关键字参数为 True，流会被强制刷新。
print(1)  
print("Hello World")  
a = 1
b = 'runoob'
print(a,b)
print("aaa""bbb")
print("aaa""bbb",end=",")
print("aaa","\n","bbb")
print("aaa","\t","bbb")
print("aaa","\r","bbb")
print("aaa""bbb",sep=".")
print("aaa","bbb")
print("aaa","bbb",sep=".")

print("www","runoob","com",sep=".")  # 设置间隔符
# 制作一个进度条：
import time
print("Loading",end = "")
for i in range(20):
    print(".",end = '',flush = True)
    time.sleep(0.5)
# 乘法表
for i in range(1, 10):
    for j in range(1, i+1):
        print(f'{j}x{i}={i*j}\t', end=',')
    print("he")

for i in range(10):
    for j in range(5):
        print(j,end="") # end表示在后边连续输出，打断后将从头输出；
    print("*")

'''变量类型'''
# 一,字符串:
string = "helloworld"

for c in string:
    print(c)

len(string)
string.count("st")
string[2]
string.index("r")
'''
1.判断类型 - 9种:
方法:               说明:
string.isspace()    如果 string 中只包含空格，则返回 True
string.isalnum()    如果 string 至少有一个字符并且所有字符都是字母或数字则返回 True
string.isalpha()    如果 string 至少有一个字符并且所有字符都是字母则返回 True
string.isdecimal()  如果 string 只包含数字则返回 True，全角数字
string.isdigit()    如果 string 只包含数字则返回 True，全角数字、⑴、\u00b2
string.isnumeric()  如果 string 只包含数字则返回 True，全角数字，汉字数字
string.istitle()    如果 string 是标题化的(每个单词的首字母大写)则返回 True
string.islower()    如果 string 中包含至少一个区分大小写的字符，并且所有这些(区分大小写的)字符都是小写，则返回 True
string.isupper()    如果 string 中包含至少一个区分大小写的字符，并且所有这些(区分大小写的)字符都是大写，则返回 True

2.查找和替换 - 7种
方法:                                                    说明:
string.startswith(str)                                  检查字符串是否是以 str 开头，是则返回 True
string.endswith(str)                                    检查字符串是否是以 str 结束，是则返回 True
string.find(str, start=0, end=len(string))              检测 str 是否包含在 string 中，如果 start 和 end 指定范围，则检查是否包含在指定范围内，如果是返回开始的索引值，否则返回 -1
string.rfind(str, start=0, end=len(string))             类似于 find()，不过是从右边开始查找
string.index(str, start=0, end=len(string))             跟 find() 方法类似，不过如果 str 不在 string 会报错
string.rindex(str, start=0, end=len(string))            类似于 index()，不过是从右边开始
string.replace(old_str, new_str, num=string.count(old)) 把 string 中的 old_str 替换成 new_str，如果 num 指定，则替换不超过 num 次.

3.大小写转换 - 5种
方法:                        说明:
string.capitalize()         把字符串的第一个字符大写
string.title()              把字符串的每个单词首字母大写
string.lower()              转换 string 中所有大写字符为小写
string.upper()              转换 string 中的小写字母为大写
string.swapcase()           翻转 string 中的大小写

4.文本对齐 - 3种
方法:                  说明:
string.ljust(width)  返回一个原字符串左对齐，并使用空格填充至长度 width 的新字符串
string.rjust(width)  返回一个原字符串右对齐，并使用空格填充至长度 width 的新字符串
string.center(width) 返回一个原字符串居中，并使用空格填充至长度 width 的新字符串

5.去除空白字符 - 3种
方法:  说明:
string.lstrip() 截掉 string 左边（开始）的空白字符
string.rstrip() 截掉 string 右边（末尾）的空白字符
string.strip()  截掉 string 左右两边的空白字符

6.拆分和连接 - 5种
方法:                         说明:
string.partition(str)       把字符串 string 分成一个 3 元素的元组 (str前面, str, str后面)
string.rpartition(str)      类似于 partition() 方法，不过是从右边开始查找
string.split(str="", num)   以 str 为分隔符拆分 string，如果 num 有指定值，则仅分隔 num + 1 个子字符串，str 默认包含 '\r', '\t', '\n' 和空格
string.splitlines()         按照行('\r', '\n', '\r\n')分隔，返回一个包含各行作为元素的列表
string.join(seq)            以 string 作为分隔符，将 seq 中所有的元素（的字符串表示）合并为一个新的字符串

7.字符串切片:字符串[开始索引:结束索引:步长]
string[2:6]           截取从 2 ~ 5 位置 的字符串;
string[2:]            截取从 2 ~ 末尾 的字符串;
string[:6]            截取从 开始 ~ 5 位置 的字符串;
string[:]             截取完整的字符串;
string[::2]           从开始位置，每隔一个字符截取字符串;
string[1::2]          从索引 1 开始，每隔一个取一个;
string[-1]            截取倒数第一个字符;
string[2:-1]          截取从 2 ~ 末尾 - 1 的字符串
string[-2:]           截取字符串末尾两个字符
string[::-1]          字符串的逆序（面试题）

8.python内置函数:
函数:                  描述:                              备注:
len(item)           计算容器中元素个数   
del(item)           删除变量                            del 有两种方式
max(item)           返回容器中元素最大值                  如果是字典，只针对 key 比较
min(item)           返回容器中元素最小值                  如果是字典，只针对 key 比较
cmp(item1, item2)   比较两个值，-1 小于/0 相等/1 大于      Python 3.x 取消了 cmp 函数

字符串 比较符合以下规则： "0" < "A" < "a"

9.切片:
描述  Python 表达式          结果          支持的数据类型 
切片  "0123456789"[::-2]     "97531"     字符串、列表、元组   
切片使用索引来限定范围,从一个大的字符串中切出小的字符串;
列表和元组都是有序的集合,都能够通过索引值获取到对应的数据;
字典是一个无序的集合,是使用键值对保存数据;

10.运算符:
运算符:           Python表达式:             结果:                           描述:       支持的数据类型:
+               [1, 2] + [3, 4]         [1, 2, 3, 4]                    合并          字符串、列表、元组
*               ["Hi!"] * 4             ['Hi!', 'Hi!', 'Hi!', 'Hi!']    重复          字符串、列表、元组
in              3 in (1, 2, 3)          True                            元素是否存在   字符串、列表、元组、字典
not in          4 not in (1, 2, 3)      True                            元素是否不存在 字符串、列表、元组、字典
> >= == < <=    (1, 2, 3) < (2, 2, 3)   True                            元素比较       字符串、列表、元组

注意:
in 在对字典操作时，判断的是字典的键
in 和 not in 被称为成员运算符

成员运算符""
成员运算符用于测试序列中是否包含指定的成员
    
运算符     描述                                                  实例
in      如果在指定的序列中找到值返回 True，否则返回 False          3 in (1, 2, 3) 返回 True
not in  如果在指定的序列中没有找到值返回 True，否则返回 False       3 not in (1, 2, 3) 返回 False
注意：在对字典操作时，判断的是字典的键.
'''
a = 3
c = 7
print(id(a))
print(id(c))
c+=a  # c=c+a
print(c)
print(id(c))
d=+a
print(d)


'''
11.完整的for循环语法:
for 变量 in 集合:

    循环体代码
else:
    没有通过 break 退出循环，循环结束后，会执行的代码
'''
# 例如:
students = [{"name": "阿土","age": 20,"gender": True,"height": 1.7,"weight": 75.0},{"name": "小美","age": 19,"gender": False,"height": 1.6,"weight": 45.0}]
find_name = "阿土"
for stu in students:
    print(stu)
    if stu["name"] == find_name:
        print("找到了")
        break
    else:
        print("没有找到")
        print("查找结束")

# 二,list列表类型:存储一组信息,中间用逗号隔开,可以有以下方法来操作列表:
list1=[]
for i in range(1,10):
    list1.append(i)

list2=[]
for i in range(20,30):
    list2.append(i)

list1.insert(0,555)
list1.extend(list2)

list1[1]

del list1[1]
list1.remove(5)
list1.pop(1)
list1.clear
len(list1)
list1.count(1)
list1.sort()
list1.sort(reverse=True)
list1.reverse()

for name in list1: # 遍历列表;
    print(name)

# 三,tuple元组:存储一组信息,元素是固定的不能修改:
tuple1 = (1,)               # 当元组只有一个元素时,后面一定要加逗号;
tuple1 = (1,1,1,1,2,3,4)
tuple1[0]
tuple1.count(1)
tuple1.index(3)

for name in tuple1: # 遍历元组;
    print(name)

tuple2 = ("张飞",18)
print("%s 的年龄是 %d" % tuple2)

# list和tuple之间可以相互转换:
list(tuple1)
tuple(list1)

# 四,dictionary字典:无序,存储键值对,键和值之间用:隔开,键必须是唯一的;
dic2= {"name": "小明","age": 18,"gender": True,"height": 1.75}
dic1={"key1":"value1","key2":"value2","key3":"value3","key4":"value4"}
dic1.keys()
dic1.values()
dic1.items()
dic1[key]                   # 从字典中取出key对应的value,key不存在会报错;
dic1.get(key)               # 从字典中取出key对应的value,key不存在不会报错;
del dic1[key]               # 删除字典中key对应的键值对,key不存在会报错;
dic1.pop(key)               # 删除字典中key对应的键值对,key不存在不会报错;
dic1.popitem()              # 随机删除一个键值对;
dic1.clear()                # 清空字典;
dic1[key1] = value5         # key1存在,则修改对应的value,key1不存在,则新建键值对;
dic1.setdefault(key2,value3)# key2存在,不会修改对应的value,key2不存在,则新建键值对;
dic1.update(dic2)           # dict1中的数据合并到dic1
dic1.fromkeys('abcd',123)   # a:123,b:123,c:123,d:123;

for k in dic2:
    print("%s:%s" % (k,dic2[k]))

card_list = [{"name": "张三","qq": "12345","phone": "110"},{"name": "李四","qq": "54321","phone": "10086"}]
for name in card_list:
    for i in name:
        print("%s:%s" % (i,name[i]))

'''函数及变量作用域 '''
# print函数:
print("abcd")
print("")               # 打印一个空行;

print("abcd",end="")    # end=""表示连续接着打印,加上print("")表示换行;
print("abcd",end="\t")  # end="\t"表示连续打印制表符,;

print("abcd",end="")
print("efgh",end="")
print("")               # 原本表示打印空行,但是和上面的end一起使用时表示换行;

# input函数:
a=input("请输入:")
print(type(a)) #获取的input输入值,赋值给变量a,a始终是str类型.

# 自定义函数，返回n的阶乘。
def fact(n):
    s = 1
    for i in range(1,n+1):   
        s=s*i
    return s
a=fact(5)
print(a)

#可选参数：m=1为可选参数，如果没有输入就默认是1进行运算。
def fun(n,m=1):
    s=1
    for i in range(1,n+1):
        s= s*i
    return s//m
a=fun(5)
print(a)

#可变参数：*b为可变参数，无论输入多少参数，都会进入函数运算。后面用一个循环取出*b中的所有参数进行运算。
def fun1(n,*b):
    s=1
    for i in range(1,n+1):
        s=s*i
    for item in b:
        s=s*item
    return s
fun1(10,2,2)

#函数返回值：return可以返回一个或多个值，用逗号隔开，也可以不返回任何值。
def fun2(n,m=1):
    s=1
    for i in range(1,n+1):
        s=s*i
    return s//m,s,m
fun2(10,5)
a,b,c=fun2(10,5)#将return返回的值分别赋给a,b,c

#全局和局部变量：函数内部是局部变量，可以用global在函数的内部定义全局变量
n,s=4,7
def fun3(n):
    global s#定义函数内部变量为全局变量。
    for  i in range(1,n+1):
        s = s *i
    return s
fun3(n)
n
s

n,s=4,7
def fun3(n):
    s=1#对比上面的函数中global，这里的是局部变量。
    for  i in range(1,n+1):
        s = s *i
    return s
fun3(n)
n
s

#局部变量为组合数据类型且未在函数内部创建，等同于全局变量。
Is = ["F","f"]
def fun4(a):
    Is.append(a)#这里的Is是组合数据，并且未在函数内部创建，就相当于是一个全局变量
    return
fun4("c")
print(Is) #结果是['F', 'f', 'c']，函数对全局变量进行了修改

Is = ["F","f"]
def fun5(a):
    Is=[]#这里的Is是组合数据，在函数内部创建，就是一个局部变量
    Is.append(a)
    return
fun5("c")
print(Is)#结果是['F', 'f']，函数只是修改了局部变量，而未对全局变量进行变动

A={1,2,3,4,'g','h','j','k'}
try:
    while True:
        print(A.pop(),end="")#while循环，为真值的时候，一直循环，直到出现错误
except:
    pass

'''文件的打开和关闭'''
a = open(path，method)
path：#包含路径的文件名，例如反斜杠形式"D:/python/f.txt" 或者两个斜杠的形式"D:\\python\\f.txt",
      #同目录下可省略路径，同根目录"./python/f.txt"，同文件夹"f.txt"
method:
#'r'只读模式，默认值，如果文件不存在返回FileNotFoundError
# 'w'覆盖写模式，文件不存在则创建，存在则完全覆盖
# 'x'创建写模式，文件不存在则创建，存在则返回FileExistError
# 'a'追加写模式，文件不存在则创建，存在则在文件最后追加内容
# 'b'二进制文件模式
# 't'文本文件模式，默认值
# '+'与r/w/x/a同时使用，在原功能基础上增加同时读写功能
f=open("f.txt")       -文本形式、只读模式、默认值
f=open("f.txt","rt")  -文本形式、只读模式、同默认值
f=open("f.txt","w")   -文本形式、覆盖写模式
f=open("f.txt","a+")  -文本形式、追加写模式+读文件
f=open("f.txt","x")   -文本形式、创建写模式
f=open("f.txt","b")   -二进制形式、只读模式
f=open("f.txt","wb")  -二进制形式、覆盖写模式
f.close()#关闭文件
s = f.read(2)#读入前2个长度的内容
s = f.readline(2)#读入一行内容的前2个长度的内容
s = f.readlines(2)#读入文件所有行，以每行为元素形成列表，参数表示读入前2行
#遍历全文本：方法一，一次全部读入
fname = input("请输入打开的文件路径和名称：")
f = open(fname,"r")
s = f.read()
f.close()
#遍历全文本：方法二,一次读入两个字节，只要不为空就一直读下去
fname = input("请输入打开的文件路径和名称：")
f = open(fname,"r")
s = f.read(2)
while s !="":
    s=f.read(2)
f.close()
#逐行遍历文件：方法一,一次读入，分行处理
fname = input("请输入打开的文件路径和名称：")
f = open(fname,"r")
for line in f.readlines():
    print(line)
f.close()

#数据的文件写入
f.write(s)          -向文件写入一个字符串s
f.writelines(lines) -将一个元素全为字符串的列表lines写入文件
f.seek(offset)      -改变文件操作指针位置，offset有三个参数：0表示开头，1表示当前位置，2表示结尾
#举例
f=open("e:/juputer/f.txt",'w+')
ls=['中国','法国','美国']
f.writelines(ls)
f.seek(0)#如果没有将指针位置调整到文件开头，指针将位于文件末尾，print将没有输出值
for line in f:
    print(line)
f.close()

#CSV格式、二维数据的处理，Comma-Separated values，逗号分隔表示一维，按行分隔表示二维
#从CSV格式的文件中读入数据
f = open(filename)
ls = []
for line in f:
    line = line.replace("\n","")
    ls.append(line.split(","))
f.close()
#将数据写入CSV格式文件
ls = [[],[],[]]
f = open(fname,'w')
for item in ls:#遍历ls的每一行，列表都是先行后列
    f.write(','.join(item)+'\n')
f.close()
#遍历二维数据，采用二层循环
ls = [[],[],[]]
for row in ls:#先遍历行
    for column in row:#再遍历每一行下的每一列
        print(ls[row][column])

'''词云wordcloud库的使用'''
pip install wordcloud
w=wordcloud.WordCloud()#width、height参数控制生成图片的宽度和高度，min_font_size()\max_font_size()设置最大和最小字字号
#font_step（）控制最大和最小字号步进间隔。font-path="msyh.ttc"设置字体。
#max_words=20指定显示的单词数量，stop_words=("")排除不显示的单词
#mask参数控制词云显示的形状，需要配合imread（）函数
from scipy.misc import imread
mk=imread("pic.png")
w=wordcloud.WordCloud(mask=mk)
#background_color="white"指定词云图片背景颜色，默认为黑色
w.generate(txt)#向w对象中加载文本txt，以空格分隔，统计单词出现的次数。
w.to_file(filename)#将词云输出为图像文件，png或jpg格式
wordcloud#英文应用实例
import wordcloud
txt = "life is short,you need python python python"
w = wordcloud.WordCloud(\
    background_color="white")
w.generate(txt)#以空格分隔，统计txt中各单词出现的次数。
w.to_file("pythoncloud.png")

wordcloud#中文应用实例
import jieba
import wordcloud
txt = "三是坚持以人民为中心的发展思想。推进跨区域立案诉讼服务改革，\
    优化网上诉讼服务功能，构建物理零距离、网络全时空、交流无障碍的诉讼\
    服务体系。创新发展新时代“枫桥经验”，完善调解、仲裁、诉讼等有机衔接、\
    相互协调的多元化纠纷解决体系，促进共建共治共享社会治理格局建设。\
    认真落实依法治国和以德治国相结合要求，通过审判树立规则导向，\
    让遵法守纪者扬眉吐气，让违法失德者寸步难行。"
w = wordcloud.WordCloud(width=1000,font_path="msyh.ttc",\
    height=700)
w.generate(" ".join(jieba.lcut(txt)))#以空格分隔，统计txt中各单词出现的次数。
w.to_file("zhongwen.png")

#政府工作报告词云
import jieba
import wordcloud
from scipy.misc import imread
mask = imread("ditu1.jpg")
f = open("zhengfubaogao.txt","r",encoding="utf-8")
t=f.read()
f.close()
ls = jieba.lcut(t)
txt = " ".join(ls)
w = wordcloud.WordCloud(width=1000,font_path="msyh.ttc",\
    height=700,background_color="white",mask=mask)
w.generate(txt)
w.to_file("zhengfubaogao2.png")

'''python基础语法体系：'''
基本数据类型：
# 1、数字类型及操作：
-整数型、浮点型、字符型，+ - * / // % **以及二元增强赋值操作
-abs() divmod() pow() round() max() min() int() float() complex()
# 2、字符串类型及操作：
-正向递增序号、反向递减序号、txt[M:N:K]起始于M结束于N，步长为K
-+ ：连接字符串
-*：字符串重复
-len() str() hex() oct() ord() chr()
-.lower() .upper() .split() .count() .replace() .center() .strip() .join() .format() 
# 3、程序的分支结构：
-单分支 if 二分枝if else 及紧凑形式
-多分支if elif else及条件之间的关系
-not and or > >= == <= != 
-异常处理 try except else finally
# 4、程序的循环结构：
-for in 遍历循环
-while无限循环
-continue break保留字，退出当前循环层次
-循环else的高级用法
# 5、函数的定义与使用
-使用保留字def定义函数，lambda定义匿名函数
-可选参数、可变参数、名称传递
-保留字return可以返回任意多个结果
-global声明全局变量
# 6、代码复用与函数递归
-模块化设计：松耦合、紧耦合
-递归函数的2个特征：基例：初始值，链条：递推公式
-函数递归的实现：函数+分支结构
# 7、集合类型及操作
-集合使用{}和set()函数创建
-集合间操作：交& 并| 差- 补^ 比较 <=>
-集合类型方法：.add() .discard() .pop()
-集合类型主要应用于：包含关系比较、数据去重
# 8、序列类型及操作
-序列是基类类型，扩展类型包括：字符串、元组、和列表
-元组用()和tuple()创建，列表用[]list()创建
元组操作和序列操作基本相同
-列表操作在序列操作的基础上，增加了更多的灵活性
# 9、字典类型及操作：
-映射关系采用键值对表达
-字典类型使用{}和dict()创建，键值对之间用：分隔
-d[key]方式既可以索引，也可以赋值
-字典类型也有一些操作方法和函数，最重要的是.get()
# 10、文件的使用：
-文件的使用方式：打开-操作-关闭
-文本和二进制形式，open()和close()
-文件内容的读取：.read() .readline() .readlines()
-数据文件的写入：.write() .writeline() .seek()
# 11、一维数据的格式化和处理：
-数据的维度：一维、二维、多维和高维
-一维数据的表示：列表类型（有序）和集合数据（无序）
-一维数据存储：空格分隔、逗号分隔、特殊符号分隔
-一维数据的处理：字符串方法.split()和.join()
# 12、二维数据的格式化和处理：
-二维数据的表示，列表类型，其中每个元素也是一个列表
-CSV格式，逗号分隔表示一维，按行分隔表示二维
-二维数据的处理：for循环 .split()和.join()

'''列表分组操作'''
-传统方法
L = [3,8,9,4,1,10,6,7,2,5]
result = [[],[],[]]
for item in L:
        if len(result[0]) < 3:
                result[0].append(item)
        elif len(result[1]) < 3:
                result[1].append(item)
        else:
                result[2].append(item)
print(result)
-优雅方法
a=[1,2,3,4,5,6,7,8,9,10,11,12,13,14]
for i in range(0, len(a), 3):
    b.append(a[i:i+3])
print(b)
-简便易读
print([a[i:i+3] for i in xrange(0,len(a),3)])

'''赋值运算符与普通赋值运算'''，
# -详见：“https://blog.csdn.net/scott198510/article/details/80295727”
# -看以下两个运算的区别
# -a为列表，是可变对象，注意：a是可变对象时，对a进行增强赋值操作会改变a本身
a=[1,2,3]
b=a
b+=[1,2,3]#增强赋值
a#a也变成了[1,2,3,1,2,3]，对b进行增强赋值运算时，也改变了a
b
id(a)
id(b)

c=[1,2,3]
d=c
d=d+[1,2,3]#普通赋值
c#c没有变化依然为[1,2,3],对d进行普通赋值，没有改变c
d
id(c)
id(d)

a为字符串，是不可变对象时，普通赋值和增强赋值是一样的，不会改变a
a="运算符"
b=a
b+="你好"
a
b
id(a)
id(b)

c="运算符"
d=c
d=d+"你好"
c
d
id(c)
id(d)

'''if __name__ == '__main__','''
# 详见：https://blog.csdn.net/yjk13703623757/article/details/77918633/
# -通俗的理解__name__ == '__main__'：假如你叫小明.py，在朋友眼中，你是小明(__name__ == '小明')；在你自己眼中，
# 你是你自己(__name__ == '__main__')。
# -if __name__ == '__main__'的意思是：当.py文件被直接运行时，if __name__ == '__main__'之下的代码块将被运行；
# 当.py文件以模块形式被导入时，if __name__ == '__main__'之下的代码块不被运行。


'''文件去重''' 
# 详见：https://blog.csdn.net/qq_30650153/article/details/77894942
originlist=[]
f = open("e:/python/chongfu.csv","r+")
line = f.readline()
lines = f.readlines()
originlist.append(line)
for lin in lines:
    if lin not in originlist:
        originlist.append(lin)

for lst in originlist:
    print(lst)
import csv
for i in range(0,len(originlist)):   
    with open("e:/python/chongfu1.csv",'a',newline = "") as f:
        writer = csv.writer(f,dialect='excel')
        writer.writerow(originlist[i])

'''Ipython的帮助和文档:'''
# help(len)和len?,用help和?获取帮助文档;甚至自己编写的函数也适用,例如:
def square(x):
    '''Return the square of x.'''
    return x**2
#自定义了一个函数返回x的平方,然后用help(square)或者square?返回该函数的信息;

# 用??获取源代码:
square?? #可以看到该自定义函数的源代码;

# 启动和退出jupyter和ipython,CMD面板直接键入：
jupyter notebook
jupyter Lab
ipython
quit() 或 ctrl+z#退出;

# 迭代器:一个特殊的对象,每次调用时只能返回它的下一个元素,例如文件的读取:
for line in open("test.txt"):
    print(line)                 # 每次读取一行输出一行,而不是一次性读入整个文件,节约内存;
# 迭代器和列表数据的区别和相互转换:
list1 = [1,2,3,4,5]
liter1 = iter(list1) # 将list1转换为迭代器lterator;
liter1               # 输出为"<list_iterator object at 0x000002575B3CD288>";
list2 = list(liter1) # 将liter1迭代器转换为list;
list2
# 迭代器只能用循环访问,或者next()方法调用:
for i in liter1:
    print(i)         # 用这个循环将迭代器一个个输出;

for i in liter1:     # 再次循环就没有输出了,迭代器元素全部取出后就清空了.
    print(i)

for i in enumerate(liter1):
    print(i)         # enumerate()函数相当于给加了个索引序号,从0开始;

for i in enumerate(list1):
    print(i)     # enumerate()函数相当于给list1的元素生成一个索引一起输出;

liter1 = iter(list1)
next(liter1)         # next()每次调用就输出下一个值,知道全部调用就清空了.

'''占位符: % 的使用'''
# 占位符%s既可以表示字符串str,还可以表示整数int,浮点数float;
# 占位符%d既可以表示整数int,还可以表示浮点数float(去除整数部分);
# 占位符%f既可以表示浮点数float,还可以表示整数int(默认保留6位小数);
companyname = input("请输入公司名称: ")
name = input("请输入姓名: ")
age = input("请输入年龄: ")
height = input("请输入身高: ")
occupy = input("请输入职位: ")
phone = input("请输入联系方式: ")
# 第一种使用:
print(companyname.center(22,"*"))
print("姓名: %s"%(name))
print("年龄: %d"%(int(age)))
print("身高: %.2fcm"%(float(height)))
print("职位: %s"%(occupy))
print("联系方式: %d"%(int(phone)))
print("%s的职位是%s"%(name,occupy))
# 第二种使用:
print("%(dianhua)s是我的电话"%{"dianhua":"13675872158"})
# 第三种使用:
print("{name}的电话是{phone}.".format(name = "逐鹿",phone = "13675872158"))

'''数字格式'''
# 保留两位小数
b = 0.154879
print('%.2f'%b)           # 0.15
print('%.2f%%'%(100*b))   # 15.49%
# 或者
print('{:.2f}'.format(b))      # 0.15
print('{:.2f}%'.format(b*100)) # 15.49%


'''文件路径操作'''
import os
user = "zhuloo"
dirpath = r'F:/meitulu/vip/{0}'.format(user)
print(dirpath)

if not os.path.exists(dirpath):
    os.mkdir(dirpath)



file_path = r'F:/meitulu/vip/{0}\{1}.jpg'.format(user, 5)
file_path
if not os.path.exists(file_path):
    with open(file_path, 'wb') as f:
        print('第{0}张下载完成： '.format(3) + file_path)
else:
    print('第{0}张照片已下载'.format(3))

'F:\meitulu\vip\Manuela玛鲁娜《女教师制服+厨娘系列》 [花の颜HuaYan] VOL.043/12.jpg'
'F:/meitulu/vip/Manuela玛鲁娜《女教师制服+厨娘系列》 [花の颜HuaYan] VOL.043 /12.jpg' # 注意路径中的空格

a = "adbddfad   "
b = a.strip() # 去除空格的办法;

c = r"adfasdg\adsfag"
d = c.replace("\","")

user = "杨晨晨/玛鲁娜/许诺Sabrina/兜豆靓《海边众女神美臀"
dirpath = r'F:/meitulu/vip/{0}'.format(user)
print(dirpath)
F:/meitulu/vip/杨晨晨/玛鲁娜/许诺Sabrina/兜豆靓《海边众女神美臀

if not os.path.exists(dirpath):
    os.mkdir(dirpath)

user1 = user.replace("/","")
user1

user2 = user1.replace("/","")

# @装饰器

'''更改目录'''
import os
print(os.getcwd())                  # 显示当前目录；
os.chdir('E:\pyecharts\example')    # 更改目录；
os.chdir('E:\Mycode\python')    # 更改目录；

# pkl格式的读取和写入EXCEL：
import pandas as pd
data1 = pd.read_pickle(r"E:\学术论文\Data\Statistics_take_home_exam_December_2019\AllFinancialDataExam2019.pkl")
data1.to_excel(r"E:\学术论文\Data\Statistics_take_home_exam_December_2019\AllFinancialDataExam2019.xlsx")
data2 = pd.read_pickle(r"E:\学术论文\Data\Statistics_take_home_exam_December_2019\EXPERTALL30.pkl")
data2.to_excel(r"E:\学术论文\Data\Statistics_take_home_exam_December_2019\EXPERTALL30.xlsx")

'''json格式'''
import json
json.dumps() # 将python对象编码成json字符串;
json.loads() # 将已编码的json字符串解码为python对象;
data1 = [ { 'a' : 1, 'b' : 2, 'c' : 3, 'd' : 4, 'e' : 5 } ] #列表list
json1 = json.dumps(data1)
type(data1)
type(json1)

data2 = { 'a' : 1, 'b' : 2, 'c' : 3, 'd' : 4, 'e' : 5 }     #字典dict
json2 = json.dumps(data2)
type(data2)
type(json2)

json3 = json.dumps(data2, sort_keys=True, indent=4, separators=(',', ': '))
type(json3)
json3

text1 = json.loads(json1)
text1
text2= json.loads(json2)
text2
text3 = json.loads(json3)
text3

'''yield的用法'''：
https://blog.csdn.net/mieleizhi0522/article/details/82142856
def foo():
    print("starting...")
    while True:
        res = yield 4
        print("res:",res)
g = foo()
print(next(g))
print("*"*20)
print(next(g))
print(g.send(7))
# 为什么用这个生成器，是因为如果用List的话，会占用更大的空间，比如说取0,1,2,3,4,5,6............1000
# 生成器generator和list对比:
for n in range(1000):
    print(n)
type(range(1000))

'''传入参数:'''
import sys
sys.argv[0]
# 数学运算符:
/除
//除然后取整
%余数
**乘方
上一次计算的结果被赋值给"_"
'''字符串:'''
""
''
\表示转义
不需要转义前面加r
print('C:\some\name') #此处\n表示转义,换行;
print(r'C:\some\name') #此处加r表示\不再转义;
print("""\
Usage: thingy [OPTIONS]
    -h                        Display this usage message
    -H hostname               Hostname to connect to
""")
print("""
Usage: thingy [OPTIONS]\
    -h                        Display this usage message\
    -H hostname               Hostname to connect to\
""")
'''流程控制:'''
a,b=0,1
while a<10:
    print(a)
    a,b = b,a+b

for i in range(10):
    print(i)

print(range(10))
sum(range(10))
list(range(10))

'''break和continue语句'''
# break语句用于跳出最近的for或while循环;
for n in range(2, 10):
    for x in range(2, n):
        if n % x == 0:
            print(n, 'equals', x, '*', n//x)
            break
    else:
        # else子句属于for循环不属于if语句;
        print(n, 'is a prime number')

# 循环中的else子句会在未发生break时执行;
# try语句中的else子句会在未发生异常时执行;
# if语句中的else

# continue语句表示继续循环中的下一次迭代;
for num in range(2, 10):
    if num % 2 == 0:
        print("Found an even number", num)
        continue
    print("Found a number", num)

'''pass语句'''
# pass语句什么也不做,当语法上需要一个语句,但程序什么动作也不需要做,可以使用它.

'''定义函数'''
# 自定义一个斐波那契数列函数:
def fib(n):
    """生成一个小于n的斐波那契数列""" # 此处的文字用来说明函数的内容
    a,b = 0,1
    while a <n:
        print(a,end=' ')
        a,b = b,a+b
    print()

f = fib
f(100)
f(0)
print(f(0))

# 参数默认值:
def ask_ok(prompt, retries=4, reminder='Please try again!'):
    while True:  #  4是retries参数的默认值,please try again是reminder参数的默认值,
        ok = input(prompt)
        if ok in ('y', 'ye', 'yes'):
            return True
        if ok in ('n', 'no', 'nop', 'nope'):
            return False
        retries = retries - 1
        if retries < 0:
            raise ValueError('invalid user response')
        print(reminder)

ask_ok('Do you really want to quit?')
ask_ok('OK to overwrite the file?', 2)
ask_ok('OK to overwrite the file?', 2, 'Come on, only yes or no!')

i = 5
def f(arg = i):
    print(arg)

i = 6
f() # 此处显示5,f参数测默认值是在上面计算的,依然是5;

# 默认值只会执行一次,尤其是默认值未可变对象(列表,字典等)时很重要
def f(a,L=[]):
    L.append(a)
    return L

def f(a,L=None):
    if L is None:
        L = []
    L.append(a)
    return L 

# 关键字参数:
def parrot(voltage, state='a stiff', action='voom', type='Norwegian Blue'):
    print("-- This parrot wouldn't", action, end=' ')
    print("if you put", voltage, "volts through it.")
    print("-- Lovely plumage, the", type)
    print("-- It's", state, "!")
# 如下调用:
parrot(1000)                                          # 1 positional argument
parrot(voltage=1000)                                  # 1 keyword argument
parrot(voltage=1000000, action='VOOOOOM')             # 2 keyword arguments
parrot(action='VOOOOOM', voltage=1000000)             # 2 keyword arguments
parrot('a million', 'bereft of life', 'jump')         # 3 positional arguments
parrot('a thousand', state='pushing up the daisies')  # 1 positional, 1 keyword
# *name形式的参数
# **name形式的最后一个形参时会接收一个字典
def cheeseshop(kind, *arguments, **keywords):
    print("-- Do you have any", kind, "?")
    print("-- I'm sorry, we're all out of", kind)
    for arg in arguments:
        print(arg)
    print("-" * 40)
    for kw in keywords:
        print(kw, ":", keywords[kw])
# 可以如下调用:
cheeseshop("Limburger", "It's very runny, sir.",
           "It's really very, VERY runny, sir.",
           shopkeeper="Michael Palin",
           client="John Cleese",
           sketch="Cheese Shop Sketch")

# 特殊参数:
# 1,位置或关键字参数,如果函数中未使用/和*,则参数可以按位置或按关键字传递给函数;
def standard_arg(arg):
    print(arg)
# 以上调用方法对调用方式没有任何限制,参数可以按位置也可以按关键字传入,例如:
standard_arg(2)
standard_arg(arg = 2)

# 2,仅限位置的形参要放在/之前,其位置是重要的,并且该形参不能作为关键字传入;
def pos_only_arg(arg, /): # 此特性仅限python3.8.1新版本;可在更新到3.8以后再学习使用;
    print(arg)
# 以上函数调用中有/,限制仅使用位置形参,如果使用关键字传入会报错,例如:


# 3,仅限关键字参数必须以关键字形式传入,应在参数列表的第一个仅限关键字形参之前放置一个*;
def kwd_only_arg(*, arg):
    print(arg)
# 以上调用中有*,表示必须以关键字形式传入,否则报错,例如:
kwd_only_arg(1) # 此时位置形式传入,报错;
kwd_only_arg(arg = 1) # 正确;

def combined_example(pos_only, /, standard, *, kwd_only):
    print(pos_only, standard, kwd_only)

'''数据结构'''
# list列表的特性:
list.append(x)
在列表的末尾添加一个元素。相当于 a[len(a):] = [x] 。

list.extend(iterable)
使用可迭代对象中的所有元素来扩展列表。相当于 a[len(a):] = iterable 。

list.insert(i, x)
在给定的位置插入一个元素。第一个参数是要插入的元素的索引，所以 a.insert(0, x) 插入列表头部， a.insert(len(a), x) 等同于 a.append(x) 。

list.remove(x)
移除列表中第一个值为 x 的元素。如果没有这样的元素，则抛出 ValueError 异常。

list.pop([i])
删除列表中给定位置的元素并返回它。如果没有给定位置，a.pop() 将会删除并返回列表中的最后一个元素。（ 方法签名中 i 两边的方括号表示这个参数是可选的，而不是要你输入方括号。你会在 Python 参考库中经常看到这种表示方法)。

list.clear()
移除列表中的所有元素。等价于``del a[:]``

list.index(x[, start[, end]])
返回列表中第一个值为 x 的元素的从零开始的索引。如果没有这样的元素将会抛出 ValueError 异常。

可选参数 start 和 end 是切片符号，用于将搜索限制为列表的特定子序列。返回的索引是相对于整个序列的开始计算的，而不是 start 参数。

list.count(x)
返回元素 x 在列表中出现的次数。

list.sort(key=None, reverse=False)
对列表中的元素进行排序（参数可用于自定义排序，解释请参见 sorted()）。

list.reverse()
翻转列表中的元素。

list.copy()
返回列表的一个浅拷贝，等价于 a[:]。
# 列表的推导式:提供了一种简单的创建列表方法.
squares = list(map(lambda x: x**2, range(10)))
squares = [x**2 for x in range(10)]
lis1 = [(x,y) for x in [1,2,3] for y in [3,1,4] if x != y]

vec = [-4, -2, 0, 2, 4]
# 每一个元素乘以2:
[x*2 for x in vec]
# 筛选出非负值:
[x for x in vec if x >= 0]
# 每一个元素取绝对值:
[abs(x) for x in vec]
# 每一个元素使用一种方法:
freshfruit = ['  banana', '  loganberry ', 'passion fruit  ']
[weapon.strip() for weapon in freshfruit] # 去掉空格;
# 生成一个元组组成的列表,每个元组由x及其平方组成:
[(x, x**2) for x in range(6)]
# 元组必须由括号括起来,否则报错,如下:
[x, x**2 for x in range(6)]
# 展开一个二维列表,双重循环:
vec = [[1,2,3], [4,5,6], [7,8,9]]
[num for elem in vec for num in elem]

# 嵌套的列表推导式:
matrix = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
]
[[row[i] for row in matrix] for i in range(4)]

# del语句:
a = [-1, 1, 66.25, 333, 333, 1234.5]
del a[0]
a
del a[2:4]
a
del a[:]
a

# 元组和序列:
# 一个元组由几个被逗号隔开的值组成:
t = 12345,54321,'hello' 
type(t)
t
u = t,(1,2,3,4,5)
type(u)
u
t[0] = 8888 # 会报错,因为元组的元素不可更改;
v = ([1,2,3],[4,5,6])
type(v)
v
v[0][1] = 100 # 元组由列表组成,元组内列表的元素可以更改;
v

# 集合:只能用set()创建空集,不能用{},表示字典
basket = {'apple', 'orange', 'apple', 'pear', 'orange', 'banana'}
print(basket)                      # 重复值已被移除;
'orange' in basket                 # 检测是否在集合中;
'crabgrass' in basket
# 集合运算符
a = set('abracadabra')
b = set('alacazam')
a                                  # 自动去掉了重复值,组成了集合a;
b
a - b                              # 差,包含在a中,不在b中;
a | b                              # 并,
a & b                              # 交,
a ^ b                              # 并集出去交集;

# 字典:
tel = {'jack': 4098, 'sape': 4139}
tel['guido'] = 4127
tel
tel['jack']
del tel['sape']
tel
tel['irv'] = 4127
tel
list(tel) # 列表只取出了字典中的键
tel
sorted(tel)
tel
'guido' in tel
'jack' not in tel
dict([('sape', 4139), ('guido', 4127), ('jack', 4098)]) # 也可以直接创建字典;
{x: x**2 for x in (2, 4, 6)} # 字典也可以使用推导式;
# 循环时使用items()方法可以同时取出键值对:
knights = {'gallahad': 'the pure', 'robin': 'the brave'}
for k, v in knights.items():
    print(k, v)
# 当在序列中循环时,使用enumerate()可以添加索引值:
for i, v in enumerate(['tic', 'tac', 'toe']):
    print(i, v)
# 当在两个或更多个序列中循环时,使用zip()函数可将其内元素一一对应起来:
questions = ['name', 'quest', 'favorite color']
answers = ['lancelot', 'the holy grail', 'blue']
for q, a in zip(questions, answers):
    print('What is your {0}?  It is {1}.'.format(q, a))
# 逆向循环一个序列,可以先正向定位一个序列,然后调用reversed()函数:
for i in reversed(range(1, 10, 2)):
    print(i)
# 如果要按某个指定顺序循环一个序列，可以用 sorted() 函数，它可以在不改动原序列的基础上返回一个新的排好序的序列:
basket = ['apple', 'orange', 'apple', 'pear', 'orange', 'banana']
for f in sorted(set(basket)):
    print(f)
# 有时可能会想在循环时修改列表内容，一般来说改为创建一个新列表是比较简单且安全的
import math
raw_data = [56.2, float('NaN'), 51.7, 55.3, 52.5, float('NaN'), 47.8]
filtered_data = []
for value in raw_data:
    if not math.isnan(value):
        filtered_data.append(value)

filtered_data

# 解包参数列表:
list(range(3,6))
args = [3,6]
list(range(*args)) # args前面必须加*才能从list中解包参数;

# lambda表达式:
lambda a,b:a+b

# 函数标注:
# 函数标注以字典的形式存放在__annotations__属性中,不影响函数的其他部分;
def f(ham: str, eggs: str = 'eggs') -> str:
    print("Annotations:", f.__annotations__)
    print("Arguments:", ham, eggs)
    return ham + ' and ' + eggs

f('spam')
f.__annotations__  # 存放函数标注信息;

'''模块'''
# 新建fibo.py的文件,文件内包含以下内容,即新建模块:
# Fibonacci numbers module

def fib(n):    # write Fibonacci series up to n
    a, b = 0, 1
    while a < n:
        print(a, end=' ')
        a, b = b, a+b
    print()

def fib2(n):   # return Fibonacci series up to n
    result = []
    a, b = 0, 1
    while a < n:
        result.append(a)
        a, b = b, a+b
    return result
#  可以如下方式使用该新建模块:
import fibo # 只是进入才模块中,使用模块名称的方法;
fibo.fib(1000) 
fibo.fib2(1000)
fibo.__name__ # 查看模块的名称:
fib = fibo.fib # 如果经常使用该函数,可将该函数赋值给一个局部变量;
fib(500)       # 此时就可以直接使用该局部变量调用以上模块里的函数;
from fibo import fib,fib2 # 可以把名字从一个被调模块内部直接导入现模块的符号表里;
fib(500) # 而被调模块fibo并未被引入到局部变量表里;
from fibo import *   # 导入fibo模块内定义的所有名称;
import fibo as fib 
from fibo import fib as fibonacci

# 以脚本的方式执行模块:
python fibo.py <arguments>
# 模块里的代码会被执行,就好像导入了模块,但是__name__被赋值为"__main__",在模块末尾添加以下代码:
if __name__ == "__main__":
    import sys
    fib(int(sys.argv[1]))

# 此模块就可以当作脚本使用,又可以当作一个可调入的模块来使用,以上代码只有在该模块以"main"文件执行的时候
# 才会执行,而模块是被导入的则不运行:
python fibo.py 50 # 此时name=main 执行;
import fibo       # 此时导入使用,name != main,那些代码不运行;

# 模块的搜索路径:
import sys
sys.path.append('')

# dir()函数:用于查抄模块定义的名称,返回一个排过序的字符串列表:
dir(fibo)
dir(sys)
# 它列出所有类型的名称:变量,模块,函数等.但它不会列出所有内置函数的名称;
# 所有内置函数可以通过builtins列出:
import builtins
dir(builtins)

# 包:模块的集合,以分层文件系统的形式表示:
sound/                          Top-level package
        __init__.py               Initialize the sound package
        formats/                  Subpackage for file format conversions
            __init__.py
            wavread.py
            wavwrite.py
            aiffread.py
            aiffwrite.py
            auread.py
            auwrite.py
            ...
        effects/                  Subpackage for sound effects
            __init__.py
            echo.py
            surround.py
            reverse.py
            ...
        filters/                  Subpackage for filters
            __init__.py
            equalizer.py
            vocoder.py
            karaoke.py
            ...
# 当导入这个包时,python搜索sys.path里的目录,查找包的子目录,导入包的单个模块的方法:
import sound.effects.echo       # 导入;
sound.effects.echo.echofilter() # 使用;
# 或者:
from sound.effects import echo   # 导入;
echo.echofilter()                # 使用;
# 或者:
from sound.effects.echo import echofilter # 导入;
echofilter()                              # 使用;

'''输入输出'''
### 更漂亮的输出格式:
# 格式化字符串面值,在字符串引号之前加上一个f或F:
year = 2016
event = 'referendum'
f'Resuts of the {year} {event}'

# 字符串str.format()方法:
yes_votes = 42_572_654
no_votes = 43_132_495
percentage = yes_votes / (yes_votes + no_votes)
'{:-9} YES votes  {:2.2%}'.format(yes_votes, percentage)

# 字符串切片或连接操作
# 当不需要花哨的输出而只是想以进行调试,可以使用str()和repr()将任何值转化为字符串:

# 格式化字符串文字:
import math
print(f'The value of pi is approximately {math.pi:.3f}.')
# 在":"后传递一个整数可以让该字段称为最小字符宽度,在对齐时很有用:
table = {'Sjoerd': 4127, 'Jack': 4098, 'Dcab': 7678}
for name, phone in table.items():
    print(f'{name:10} ==> {phone:10d}')

# 其它的修饰符可用于在格式化之前转化值,'!a' 应用 ascii() ，'!s' 应用 str()，还有 '!r' 应用 repr():
animals = 'eels'
print(f'My hovercraft is full of {animals}.')
print(f'My hovercraft is full of {animals!r}.')

# 字符串的format()方法:
print('We are the {} who say "{}!"'.format('knights', 'Ni'))
print('{0} and {1}'.format('spam', 'eggs'))
print('{1} and {0}'.format('spam', 'eggs'))
print('This {food} is {adjective}.'.format(food='spam', adjective='absolutely horrible'))
print('The story of {0}, {1}, and {other}.'.format('Bill', 'Manfred',other='Georg'))
table = {'Sjoerd': 4127, 'Jack': 4098, 'Dcab': 8637678}
print('Jack: {0[Jack]:d}; Sjoerd: {0[Sjoerd]:d}; Dcab: {0[Dcab]:d}'.format(table))
print('Jack: {Jack:d}; Sjoerd: {Sjoerd:d}; Dcab: {Dcab:d}'.format(**table))
for x in range(1, 11):
    print('{0:2d} {1:3d} {2:4d}'.format(x, x*x, x*x*x))

# 手动格式化字符串:
for x in range(1, 11):
    print(repr(x).rjust(2), repr(x*x).rjust(3), end=' ')
    print(repr(x*x*x).rjust(4))
# 字符串对象的 str.rjust() 方法通过在左侧填充空格来对给定宽度的字段中的字符串进行右对齐。
# 类似的方法还有 str.ljust() 和 str.center() 。这些方法不会写入任何东西，它们只是返回一
# 个新的字符串，如果输入的字符串太长，它们不会截断字符串，而是原样返回；
# 还有另外一个方法，str.zfill() ，它会在数字字符串的左边填充零。它能识别正负号.

# 读写文件:
f = open('workfile','W')
# W表示只能写入,已存在同名文件会被删除;
# r表示只能读取;
# a表示打开文件以追加内容,任何写入的数据会自动添加到文件的末尾;
# r+表示打开文件进行读写;
# 省略时默认为r;
# b表示二进制形式打开文件,适用于所有不包含文本的文件;
# 在文本下读取时,默认会将平台特定的行结束符转换为\n,会将\n转换为平台特定的结束符;
# 对文本数据没问题,但是会破坏二进制数据,例如jpeg和exe格式,读写此类文件时应注意使用二进制模式;
# 处理文件对象时,最好使用with关键字,优点是当句体结束后文件会正确关闭,即使在某个时刻发生了异常,比try-finally代码块要简短的多;
with open('workfile') as f:
    read_data = f.read()
# 如果没有使用with关键字,应该使用f.close()来关闭文件;
# 使用以下方法读取文件:
f.read(size)     # 读取文件将其作为字符串,size僧略或为负,读取并返回整个文件;
f.readline()     # 从文件中读取一行;
f.readlines()    # 以列表的形式读取文件的所有行,或者使用list(f);
f.write(string)  # 将string的内容写入到文件中,并返回字符串的字符数;
# 在写入其他类型的对象之前,要先把他们转化为字符串(文本模式下)或者字节对象(二进制模式下);
value = ('the answer',42)
s = str(value)
f.write(s)
f.tell()         # 返回一个整数,给出文件对象在文件中的当前位置,表示为二进制模式下时从文件开始的字节数，以及文本模式下的意义不明的数字;
f.seek(offset,whence) # 改变文件对象的位置,whence=0 从文件开头算起,1表示当前文件位置算起,2表示从文件末尾算起,默认为0;
f = open('workfile', 'rb+')
f.write(b'0123456789abcdef')
f.seek(5)      # Go to the 6th byte in the file
f.read(1)
f.seek(-3, 2)  # Go to the 3rd byte before the end
f.read(1)

'''错误和异常'''
### 语法错误:invalid syntax;
### 异常;
### 处理异常:
# try语句:
while True:
    try:
        x = int(input("Please enter a number: "))
        break
    except ValueError:
        print("Oops!  That was no valid number.  Try again...")
# try语句的工作原理:
# 首先,执行try与except之间的语句;
# 如果没有发生异常,则跳过except子句并完成try语句的执行;
# 如果执行try子句发生了异常,则跳过该句子中剩下的部分,然后,如果异常类型和except关键字后面的异常匹配,则执行except子句,然后继续执行try语句之后的代码;
# 如果发生的异常和except子句后面的异常类型不匹配,则将其传递到外部的try语句中,如果未找到处理程序,则它是一个未处理异常,执行将停止,并显示如上所示的消息;
# 一个try语句可能有多个except子句,以指定不同的异常处理程序.最多会执行一个处理程序。 处理程序只处理相应的 try 子句中发生的异常，而不处理同一 try 语句内
# 其他处理程序中的异常。 一个 except 子句可以将多个异常命名为带括号的元组，例如:
except (RuntimeError, TypeError, NameError):
pass
# try...except语句有一个可选的else子句:在使用时必须放在所有except子句的后面
for arg in sys.argv[1:]:
    try:
        f = open(arg, 'r')
    except OSError:
        print('cannot open', arg)
    else:
        print(arg, 'has', len(f.readlines()), 'lines')
        f.close()


### 用户自定义异常:
class Error(Exception):
    """Base class for exceptions in this module."""
    pass

class InputError(Error):
    """Exception raised for errors in the input.

    Attributes:
        expression -- input expression in which the error occurred
        message -- explanation of the error
    """

    def __init__(self, expression, message):
        self.expression = expression
        self.message = message
### 定义清理操作:finally子句,作为 try 语句结束前的最后一项任务被执行。 finally 子句不论 try 语句是否产生了异常都会被执行。
### 预定义的清理操作:
with open("myfile.txt") as f:
    for line in f:
        print(line, end="")
# 执行完语句后，即使在处理行时遇到问题，文件 f 也始终会被关闭。和文件一样，提供预定义清理操作的对象将在其文档中指出这一点。

### 作用域和命名空间:
def scope_test():
    def do_local():
        spam = "local spam" # 局部赋值不会改变scope_test对spam的绑定;

    def do_nonlocal():
        nonlocal spam       # nonlocal赋值会改变scope_test对spam的绑定;
        spam = "nonlocal spam"

    def do_global():
        global spam         # global会改变模块层级的绑定;
        spam = "global spam"

    spam = "test spam"
    do_local()
    print("After local assignment:", spam)
    do_nonlocal()
    print("After nonlocal assignment:", spam)
    do_global()
    print("After global assignment:", spam)

scope_test()
print("In global scope:", spam)

### 迭代器:
s = 'abcdefg'
it = iter(s) # 字符串转化为迭代器对象;
it
next(it)

### 生成器:写法类似标准函数,返回数据时会使用yield语句;
generator

'''常用标准库简介'''
### 操作系统接口:
import os
os.getcwd()
os.chdir()
os.system()
dir(os)
help(os)

### shutil模块提供了更易于使用的更高级别的接口;提供了一系列对文件和文件集合的高阶操作。 特别是提供了一些支持文件拷贝和删除的函数。
#  对于单个文件的操作，请参阅 os 模块。

### 文件通配符,glob提供了一个在目录中使用通配符搜索文件列表的函数:
import glob
glob.glob('*.py')

### 命令行参数:
import sys
print(sys.argv)

### 字符串匹配,正则表达式:
import re

### 数学:
import math
import random
import statistics

### 互联网访问:
urllib.request # 从url检索数据;
smtplib        # 发送邮件;

### 日期和时间:
from datetime import date
now = date.today()
now

### 数据压缩:
# 常见的数据存档和压缩格式由模块直接支持，包括：zlib, gzip, bz2, lzma, zipfile 和 tarfile。

### 性能测量:
timeit
profile
pstats

### 质量控制:
doctest
unittest

### 自带电池:
xmlrpc.client
xmlrpc.server
email
json
sqlite3

### 格式化输出:
reprlib # 提供了一个定制化版本的repr函数,用于缩略显示大型或深层嵌套的容器对象;
pprint  # 提供了更加复杂的打印控制,其输出的内置对象和用户自定义对象能够被解释器直接读取;
textwrap # 格式化文本段落,以适应给定的屏幕宽度;
locale # 模块处理与特定地域文化相关的数据格式.

### 模板:
string # 包含一个通用的Template类,具有适用于最终用户的简化语法。它允许用户在不更改应用逻辑的情况下定制自己的应用。
# 上述格式化操作是通过占位符实现的，占位符由 $ 加上合法的 Python 标识符（只能包含字母、数字和下划线）构成。一旦使用花括号将占位符括起来，就可以在后面直接跟上更多的字母和数字而无需空格分割。$$ 将被转义成单个字符 $:
from string import Template
t = Template('${village}folk send $$10 to $cause.')
t.substitute(village='Nottingham', cause='the ditch fund')
# 如果在字典或关键字参数中未提供某个占位符的值，那么 substitute() 方法将抛出 KeyError。对于邮件合并类型的应用，用户提供的数据有可能是不完整的，此时使用 safe_substitute() 方法更加合适 —— 如果数据缺失，它会直接将占位符原样保留。
t = Template('Return the $item to $owner.')
d = dict(item='unladen swallow')
t.substitute(d)
t.safe_substitute(d)
# Template 的子类可以自定义定界符。例如，以下是某个照片浏览器的批量重命名功能，采用了百分号作为日期、照片序号和照片格式的占位符:
import time, os.path
photofiles = ['img_1074.jpg', 'img_1076.jpg', 'img_1077.jpg']
class BatchRename(Template):
    delimiter = '%'
fmt = input('Enter rename style (%d-date %n-seqnum %f-format):  ')
t = BatchRename(fmt)
date = time.strftime('%d%b%y')
for i, filename in enumerate(photofiles):
    base, ext = os.path.splitext(filename)
    newname = t.substitute(d=date, n=i, f=ext)
    print('{0} --> {1}'.format(filename, newname))

### 多线程:
threading 

### 日志:
logging

'''虚拟环境和包'''
# 如果应用程序A需要特定模块的1.0版本但应用程序B需要2.0版本，则需求存在冲突，安装版本1.0或2.0将导致某一个应用程序无法运行。
# 这个问题的解决方案是创建一个 virtual environment，一个目录树，其中安装有特定Python版本，以及许多其他包。
# 然后，不同的应用将可以使用不同的虚拟环境。 要解决先前需求相冲突的例子，应用程序 A 可以拥有自己的 安装了 1.0 版本的虚拟环境，
# 而应用程序 B 则拥有安装了 2.0 版本的另一个虚拟环境。 如果应用程序 B 要求将某个库升级到 3.0 版本，也不会影响应用程序 A 的环境。
evenv # 创建和管理虚拟环境的模块;
pip install novas # 指定包的名称来安装最新版本的包：
pip install requests==2.6.0 # 通过提供包名称后跟 == 和版本号来安装特定版本的包：
pip install --upgrade requests # 将软件包升级到最新版本：
pip uninstall  # 后跟一个或多个包名称将从虚拟环境中删除包。
pip show requests #将显示有关特定包的信息：
pip list 将显示虚拟环境中安装的所有软件包：
pip freeze # 将生成一个类似的已安装包列表，但输出使用 pip install 期望的格式。一个常见的约定是将此列表放在 requirements.txt 文件中：
pip freeze > requirements.txt
cat requirements.txt
novas==3.1.1.3
numpy==1.9.2
requests==2.7.0
pip install -r requirements.txt # 使用 install -r 安装所有必需的包：

'''字符串前面加u\r\b的含义'''
# 1.字符串前面加u:
# 表示以unicode编码,一般用在中文字符串前面,防止出现乱码,例如:
u"我是中文字符串,此处的u防止出现乱码."
# 2.字符串前面加r:
# 表示去掉反斜杠的转义机制,例如用在文件路径字符串前:
r"换行符\n,此时不再换行"
r"e:\data,此时斜杠不再转义,表示路径"
# 3.字符串前面加b:
# 表示后面的字符串时bytes类型数据;

###Edgedriver安装
# 1.下载对应的驱动：https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/，并改名为“MicrosoftWebDriver.exe”，放入anaconda中的python目录下或者放到其它文件夹，但是文件夹要添加到系统路径；
# 2.pip install msedge-selenium-tools 安装库，参考;https://pypi.org/project/msedge-selenium-tools/

# 3.使用selenium库：
from selenium import webdriver
from selenium.webdriver.edge.options import Options
# 直接使用会出现错误提示：ERROR:device_event_log_impl.cc(211)，但不影响使用
driver = webdriver.Edge()
driver.get("https://cn.bing.com/")
driver.quit()

# 4.或者使用msedge-selenium-tools库：
# 可以使用如下方法消除错误提示：ERROR:device_event_log_impl.cc(211)
# 参考：https://stackoverflow.com/questions/64927909/failed-to-read-descriptor-from-node-connection-a-device-attached-to-the-system/64928509#64928509
from msedge.selenium_tools import Edge, EdgeOptions

# Launch Microsoft Edge (EdgeHTML)
driver = Edge()

# Launch Microsoft Edge (Chromium) 
options = EdgeOptions()
options.use_chromium = True
options.add_experimental_option('excludeSwitches', ['enable-logging'])
driver = Edge(executable_path=r'D:\Anaconda\MicrosoftWebDriver.exe',options = options)
driver.get("https://cn.bing.com/")
driver.quit()