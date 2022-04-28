## beautifulSoup 
## “美味的汤，绿色的浓汤”,一个灵活又方便的网页解析库，处理高效，支持多种解析器。利用它就不用编写正则表达式也能方便的实现网页信息的抓取
## 更加简单易懂的例子:
from bs4 import BeautifulSoup
html = '''
<html>
<head><title>The Dormouse's story</title></head>
<body>
<p class="story">Once upon a time there were three little sisters; and their names were
    <a href="http://example.com/elsie" class="sister" id="link1">Elsie</a>,
    <a href="http://example.com/lacie" class="sister" id="link2">Lacie</a>;
    and they lived at the bottom of a well.</p>
<div class="panel">
    <div class="panel-heading">
        <h4>Hello</h4>
    </div>
    <div class="panel-body">
        <ul class="list" id="list-1">
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
        <ul class="list list-small" id="list-2">
            <li class="element">Foo</li>
            <li class="element">Bar</li>
        </ul>
    </div>
</div>
<p class="story">Once upon a time there were three little sisters; and their names were
    <a href="http://example.com/tillie" class="sister" id="link3">Tillie</a>;
    and they lived at the bottom of a well.</p>
</body>
'''
soup = BeautifulSoup(html,'lxml')
print(soup.prettify())
print(soup.title)
print(soup.title.name)
print(soup.title.string)
print(soup.title.parent.name)
print(soup.p)                   # 获取的是所有p标签中的第一个p标签;
print(soup.p["class"])          # 获取第一个p标签的class属性;
print(soup.a)                   # 所有a标签中,获取第一个a标签;
print(soup.find_all('a'))       # 获取所有a标签,并存储在一个列表中;
print(soup.find(id='link3'))    # 获取id=link3的标签.

links = soup.find_all('a')
for link in links:
    print(link.get('href'))     # 获取所有a标签,并将a的href值输出;

print(soup.get_text())          #soup.get_text()得到soup里面的所有文本;

# 元素选择:soup.e(title、head、p等);
print(type(soup.title)) #查看元素属性的性质;
soup.title  # 获取title标签;
soup.head   # 获取head标签;
soup.p      # 获取p标签,此时获取的是众多p标签中的第一个p标签;
soup.a      # 获取a标签,此时获取的是众多a标签中的第一个a标签;

# 获取元素名称：soup.e.name
soup.title.name     # 显示各标签的名称;
soup.head.name
soup.p.name

#获取元素属性:soup.e.attrs[] 或 soup.e[]
soup.p.attrs['class']    # 获取了第一个p标签的class属性;
soup.p['class']          # 这两种获取元素属性的方法结果是一样的,都是获取第一个a标签的name属性;

soup.a.attrs['href']     # 获取了第一个a标签的href属性;
soup.a['href']           # 这两句是获取第一个a标签的href属性;

# 获取元素内容：soup.e.string
soup.title.string        # 获取了title标签的文本内容;

# 元素的逐级嵌套：soup.e.e
soup.head.title.string   # 获取head标签下的title标签的文本内容;
soup.p.a.string          # 获取第一个p标签下的第一个a标签的文本内容;

# 子节点：soup.e.contents或soup.e.children
childs1 = soup.p.contents      # 将p标签下的所有内容存入一个列表,可以使用下面的循环逐个输出:
soup.p.contents                # 此时contents是一个列表,可以直接输出contents的内容
for child in childs1:
    print(child)

childs2 = soup.p.children      # children是一个迭代对象，而不是列表，只能通过循环的方式获取所有的信息:
for i in childs2:
    print(i)

for i in childs2:   # 再次循环就没有内容了,需要再次生成;
    print(i)

# 子孙节点：soup.e.descendants
childs3 = soup.p.descendants             # 同上面的children一样,是一个迭代对象,只能通过循环方式获取其信息:
for i in childs3:
    print(i)

# 父节点：soup.e.parent
soup.a.parent
# 祖先节点：soup.e.parents
soup.a.parents                 # 是迭代对象,只能通过循环输出:
for parent in soup.a.parents:
    print(parent)

# 兄弟节点：soup.e.next_siblings   soup.e.previous_siblings
soup.a.next_siblings    
soup.a.previous_siblings
# <generator object PageElement.previous_siblings at 0x0000023F0B934F48>获取的是迭代对象;
soup.p.next_sibling
soup.p.next_sibling.next_sibling
soup.a.next_sibling
soup.a.next_sibling.next_sibling
soup.a.previous_sibling

# 标准选择器：find_all(name,attrs,recursive,text,**kwargs) 返回所有元素;
# 标签名获取：soup.find_all('name')
html='''
<div class="panel">
    <div class="panel-heading">
        <h4>Hello</h4>
    </div>
    <div class="panel-body">
        <ul class="list" id="list-1" name="elements">
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
        <ul class="list list-small" id="list-2">
            <li class="element">Foo</li>
            <li class="element">Bar</li>
        </ul>
    </div>
</div>
'''
from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
# 标签属性获取：soup.find_all(attrs={})
print(soup.find_all(attrs={'id': 'list-1'}))     # attrs={'key':'value'}属性等于一个键值对的形式;
list1 = soup.find_all(id = 'list-1')
for i in list1:
    print(i.find_all('li'))

print(soup.find_all(attrs={'name': 'elements'}))
# 标签名获取：soup.find_all('name')
list1 = soup.find_all('ul') # 查找每一个ul,一个ul标签下的所有内容一起作为list1的一个元素;
list1[0]
list1[1]
for i in list1:             # 循环再次查找每一个ul标签下的内容;
    print(i.find_all('li'))

soup.find_all('ul')[0]
soup.find_all('ul')[1]
# 或者:soup.find_all(attrs="")
soup.find_all(id='list-1')                      # key = 'value'的形式;
list1 = soup.find_all(id='list-1')              
soup.find_all(class_='element')    # class在python中是一个特殊字段,其它需要出现class时要使用class_形式;
list1 = soup.find_all(class_='element')
list1[0]
list1[1]
list1[2]

# 文本内容获取
soup.find_all(text='Foo')

# find(name,attrs,recursive,text,**kwargs) 返回单个(第一个)元素:
soup.find('li')

# find_parents()返回所有祖先节点、find_parent()返回直接父节点:
soup.li.find_parent()
l1 = soup.li.find_parents() # find_parents()返回所有的每一级上一级节点及其所包含的全部内容;
for i in l1:
    print(i)
    print("")

# find_next_siblings()返回后面所有兄弟节点、find_next_sibling()返回后面第一个兄弟点:
l1 = soup.li.find_next_sibling()   # 返回的是同一个父节点下的后面的第一个兄弟节点;
l1 = soup.li.find_next_siblings()  # 返回的是同一个父节点下的后面的所有兄弟节点;

l1 = soup.li.find_previous_sibling()     # 返回的是同一个父节点下的前面的第一个兄弟节点;由于当前已是第一个节点,所以前面没有节点,返回内容为空;
l1 = soup.li.find_previous_siblings()    # 返回的是同一个父节点下的前面的所有兄弟节点;

l1 = soup.li.find_next()     # find_next()返回同一个父节点下后面的第一个符合条件的节点;
l1 = soup.li.find_all_next() # find_all_next()返回同一个父节点下后面的所有符合条件的节点;

l1 = soup.li.find_all_previous() # find_all_previous()返回节点前所有符合条件的节点;
l1 = soup.li.find_previous()      # find_previous()返回节点前第一个符合条件的节点;
for i in l1:
    print(i)
    print("")

# CSS选择器：soup.select(css选择器)
soup.select('.panel .panel-heading')
soup.select('ul li')
soup.select('#list-2 .element')
soup.select('ul')
for ul in soup.select('ul'):
    print(ul.select('li'))
# 获取属性：e.attrs[] e[]
for ul in soup.select('ul'):
    ul['id']
    ul.attrs['id']
# 获取内容 get_text()
for li in soup.select('li'):
    li.get_text()

"""总结:所有的方法和函数一般对beautifulsoup的对象才有用:tag等
"""

## 经济研究期刊摘要和目录爬取:
import re
import requests
from bs4 import BeautifulSoup
url = "http://www.erj.cn/cn/mlInfo.aspx?m=20190130093538450747&n=20190130093720527750&tip=0"
headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
r = requests.get(url, headers=headers,timeout=3)
soup = BeautifulSoup(r.text,'lxml')
# 左侧栏获取各期网址:
table1 = soup.find_all(attrs={'class':'lm1-leftBOX_01'}) # 左侧栏的下的所有文本内容;获取的结果是一个元素的列表;
table2 = table1[0].find_all('li')                        # 获取的结果是134个li元素的列表;
web1=[]
for i in table2:
    print(i)
    web1.append(i.a.get('href'))

web2=[]
for i in web1:
    web2.append("http://www.erj.cn/cn/"+i)

name1=[]
for i in table2:
    name1.append(i.a.string)

dict1 = {}
for i in range(0,len(web2)):
    dict1.setdefault(name1[i],web2[i])
# 右侧每一期下面的文章(练习部分):
text1 = soup.find_all(attrs={'class':'lm1-rightBOX_down'}) # len(text1)=1 text1是含有一个元素的列表;
text2 = text1[0].find_all('table')                         # len(text2)=14 text2是含有14个table标签的列表;
title1=[]
for i in text2:
    title1.append(i.a.string)

sub1=[]
for i in text2:
    sub1.append(i.find_all('span'))

sub = []
for i in range(0,len(sub1)-2):
    try:
        submatch = re.search('<span style="font-size: 13px;">：(.*?)</span>',str(sub1[i][1]),re.S)
        sub.append(submatch.group(1))
    except Exception as e:
        print(e) # try except程序正常就执行,异常就打印出错误类型;

sub = []
for i in range(0,len(sub1)):
    try:
        sub.append(sub1[i][1].get_text())
    except Exception as e:
        print(e)

sub = []
for i in range(0,len(sub1)):
    for j in range(0,len(sub1[i])):
        sub.append(sub1[i][j].get_text())

"""每期对应一个网址下的所有文章,提取某一期网页下面的所有文章,即该页所有table下的所有文本"""
text1 = soup.find_all(attrs={'class':'lm1-rightBOX_down'}) # len(text1)=1 text1是含有一个元素的列表;
text2 = text1[0].find_all('table') 
td=[]
for table in text2:
    print(type(table))
    print(table.find_all('td'))
    td.append(table.find_all('td'))

len(td)

sub = []
for i in range(0,len(td)):
    for j in range(0,len(td[i])):
        sub.append(td[i][j].get_text())

lst1=[sub[i:i+4] for i in range(0,len(sub),4)]

                                 




for i in sub:
    print(i)
    print("---------------------------------------------------")


matstr = text2[0].find_all('span')
matstr[1]
type(matstr[1])
submatch = re.search('<span style="font-size: 13px;">：(.*?)</span>',str(matstr[1]),re.S)
submatch.group(1)

sub=[]
submatch = re.search('<span style="font-size: 13px;">：(.*?)</span>',str(sub1[0][1]),re.S)
sub.append(submatch.group(1))

# 知网新冠肺炎：
import os
import requests
from requests.packages import urllib3
from bs4 import BeautifulSoup
import re
import sys

# 定义函数:得到专辑名称:
url = "https://cajn.cnki.net/xgbt/zh-CN/Search/GetSearchContent"
headers = {
    'Connection': 'keep-alive',
    'Content-Length': '195',
    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    'Cookie': 'amid=ca2109b9-d0c9-4070-b32d-c3978398c550; UM_distinctid=176cca76753250-02f1aa287d8b94-c791039-240000-176cca767547d0; Ecp_ClientId=1210105220604919251; Ecp_IpLoginFail=21020342.239.5.178; _pk_ref=%5B%22%22%2C%22%22%2C1612360849%2C%22https%3A%2F%2Fcn.bing.com%2F%22%5D; _pk_id=416c314e-5d22-4570-9313-db5d9484ea5e.1609855565.4.1612360849.1612360849.; _pk_ses=*; ASP.NET_SessionId=btizvqkpgu4alvb5lc5m4rph; Ecp_LoginStuts={"IsAutoLogin":false,"UserName":"OAuser","ShowName":"OAuser","UserType":"jf","BUserName":"","BShowName":"","BUserType":"","r":"xSocI5"}; LID=WEEvREcwSlJHSldTTEYzVTFPU25NbVVuZk1vdnpic0hEbkVnYlZvMGJWND0=$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4IQMovwHtwkF4VYPoHbKxJw!!; SID=011131; cnkiUserKey=672b8074-7de2-4fcc-8c94-44cbab95834a; c_m_LinID=LinID=WEEvREcwSlJHSldTTEYzVTFPU25NbVVuZk1vdnpic0hEbkVnYlZvMGJWND0=$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4IQMovwHtwkF4VYPoHbKxJw!!&ot=02/03/2021 22:39:59; c_m_expire=2021-02-03 22:39:59',
    'Host': 'cajn.cnki.net',
    'Origin': 'https://cajn.cnki.net',
    'Referer': 'https://cajn.cnki.net/xgbt',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36',
    'X-Requested-With': 'XMLHttpRequest'
    }

urllib3.disable_warnings()
r = requests.post(url, headers=headers,timeout=10,verify = False)
r.encoding = r.status_code
soup = BeautifulSoup(r.text,'lxml')
text1 = soup.find_all(attrs={'class':'result-table-list'})
text1 = soup.find_all(name = 'tbody')
text2 = text1[0].find_all('h1') 
user = text2[0].get_text().strip().replace("/","") # 两边可能含有的空格和/;
