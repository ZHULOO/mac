# 正则表达式的用法:

# 常用表达式:
'''
\w      匹配字母数字及下划线;
\W      匹配非字母数字及下划线
\s      匹配任意空白字符，等价于[\t\n\r\f]
\S      匹配任意非空字符
\d      匹配任意数字
\D      匹配任意非数字
\A      匹配字符串开始
\Z      匹配字符串结束，如果存在换行，只匹配换行前的结束字符串
\z      匹配字符串结束
\G      匹配最后匹配完成的位置
\n      匹配一个换行符
\t      匹配一个制表符
^       匹配字符串的开头
$       匹配字符串的末尾
.       匹配任意字符，除了换行符，re.DOTALL标记被指定时，则可以匹配包括换行符的任意字符
[....]  用来表示一组字符，单独列出：[amk]匹配a,m或k
[^...]  不在[]中的字符：[^abc]匹配除了a,b,c之外的字符
*       匹配0个或多个的表达式
+       匹配1个或者多个的表达式
?       匹配0个或1个由前面的正则表达式定义的片段，非贪婪方式
{n}     精确匹配n前面的表示
{m,m}   匹配n到m次由前面的正则表达式定义片段，贪婪模式
a|b     匹配a或者b
()      匹配括号内的表达式，也表示一个组
'''
# 最常规的匹配
## re.match(pattern,string,flags)
import re
from typing import Pattern
content= "hello 123 4567 World_This is a regex Demo"
result = re.match('^hello\s\d\d\d\s\d{4}\s\w{10}.*Demo$',content)
print(result)
print(result.group())
print(result.span())

result.group() # 获取匹配的结果;
result.span()  # 获取匹配字符串的长度范围;

content = "https://www.meitulu.com/item/10081.html"
nums = re.findall(r'\d+', content)
nums

# 泛匹配
## 上面的匹配方式非常不方便,可以进行更改;
import re
content= "hello 123 4567 World_This is a regex Demo"
result = re.match('^hello.*Demo$',content)
result
result.group()
result.span()

# 匹配目标
## 如果要匹配字符串中的具体目标,则需要用()括起来:```
import re
content= "hello 123 4567 World_This is a regex Demo"
result = re.match('^hello\s(\d+).*Demo$',content)
result
result.group()
result.span()
result.group(1) # 返回表达式中第一个括号中的内容；

# 贪婪匹配
## 从结果中可以看出只匹配到了7，并没有匹配到1234567，出现这种情况的原因是前面的.* 给匹配掉了， 
## .*在这里会尽可能的匹配多的内容，也就是我们所说的贪婪匹配.
import re
content= "hello 1234567 World_This is a regex Demo"
result= re.match('^he.*(\d+).*Demo',content)   # .*尽可能多地匹配;
result1= re.match('^he.*?(\d+).*Demo',content) # ?匹配0或1个由前面正则表达式定义的片段;
result.group()
result.group(1)  # 发现只返回了7,前面的都被.*给贪婪匹配掉了;
result1.group()
result1.group(1) # ?非贪婪模式;

# 匹配模式
## 很多时候匹配的内容是存在换行的问题的，这个时候的就需要用到匹配模式re.S来匹配换行的内容;
import re
content = """hello 123456 world_this
my name is zhaofan
"""
result =re.match('^he.*?(\d+).*?zhaofan$',content,re.S) # re.S表示匹配了换行
result
result.group()         # 显示了换行符\n;
print(result.group())  # 换行显示;

# 转移字符
## 当我们要匹配的内容中存在特殊字符的时候，就需要用到转移符号\,例子如下：
import re
content= "price is $5.00"
result = re.match('price is \$5\.00',content) # $和.是特殊字符,要匹配出它们,必须使用转义符\;
print(result)
print(result.group())
'''
对上面的一个小结：
尽量使用泛匹配，使用括号得到匹配目标，尽量使用非贪婪模式，有换行符就用re.S
强调re.match是从字符串的起始位置匹配一个模式.
'''
# re.search:re.search扫描整个字符串返回第一个成功匹配的结果;
import re
content = "extra things hello 123455 world_this is a Re Extra things"
result = re.search("hello.*?(\d+).*?Re",content)
print(result)
print(result.group())
print(result.group(1))

'''
其实这个时候我们就不需要在写^以及$，因为search是扫描整个字符串;
注意：所以为了匹配方便，我们会更多的用search，不用match,match必须匹配头部，
所以很多时候不是特别方便
'''

# 匹配演练:
import re
html = '''<div id="songs-list">
    <h2 class="title">经典老歌</h2>
    <p class="introduction">
        经典老歌列表
    </p>
    <ul id="list" class="list-group">
        <li data-view="2">一路上有你</li>
        <li data-view="7">
            <a href="/2.mp3" singer="任贤齐">沧海一声笑</a>
        </li>
        <li data-view="4" class="active">
            <a href="/3.mp3" singer="齐秦">往事随风</a>
        </li>
        <li data-view="6"><a href="/4.mp3" singer="beyond">光辉岁月</a></li>
        <li data-view="5"><a href="/5.mp3" singer="陈慧琳">记事本</a></li>
        <li data-view="5">
            <a href="/6.mp3" singer="邓丽君">但愿人长久</a>
        </li>
    </ul>
</div>
'''
result = re.search('<li.*?active.*?singer="(.*?)">(.*?)</a>',html,re.S)
print(result)
print(result.groups())
print(result.group(1))
print(result.group(2))

# re.findall搜索字符串，以列表的形式返回全部能匹配的子串,代码例子如下：
results1 = re.findall('<li.*?href="(.*?)".*?singer="(.*?)">(.*?)</a>', html, re.S)
results2 = re.findall('<li.*?>\s*?(<a.*?>)?(\w+)(</a>)?\s*?</li>',html,re.S)
print(results1)
print(type(results1))
print(results2)
print(type(results2))

for result in results1:
    print(result)

for result in results1:
    print(result[0])

for result in results2:
    print(result)

for result in results2:
    print(result[2])

# re.sub替换字符串中每一个匹配的子串后返回替换后的字符串:
re.sub(Pattern,repl,string,count,flags)
re.sub(正则表达式，替换成的字符串，原字符串)

import re
content = "Extra things hello 123455 World_this is a regex Demo extra things"
sub1 = re.sub('\d+','',content)
print(sub1)

# repl可以是函数
def double(matched):
    value = int(matched.group('str1'))
    return str(value * 2)
sub2 = re.sub('(?P<str1>\d+)',double,content) # 将匹配出来的数字乘以2
sub2

sub3 = re.sub('(\d+)',r'\1 7890',content) # 这里需要注意的一个问题是\1是获取第一个匹配的结果，为了防止转义字符的问题，我们需要在前面加上r;
print(sub3) 

# re.compile将正则表达式编译成正则表达式对象，方便复用该正则表达式;
import re
content= """hello 12345 world_this
fan
"""
pattern =re.compile("hello.*fan",re.S)
result = re.match(pattern,content)
print(result)
print(result.group())

# 正则表达式爬取豆瓣书籍页面的信息:
import requests
import re
content = requests.get('https://book.douban.com/').text
pattern = re.compile('<li.*?cover.*?href="(.*?)".*?title="(.*?)".*?more-meta.*?author">(.*?)</span>.*?year">(.*?)</span>.*?</li>', re.S)
results = re.findall(pattern, content)
print(results)

for result in results:
    url,name,author,date = result
    author = re.sub('\s','',author)
    date = re.sub('\s','',date)
    print(url,name,author,date)