### 对比磁盘路径表达式,xpath选择节点的操作类似；
# /   从根节点选取；
# //  从任意位置选取；
# .   选取当前节点
# ..  选取当前节点的父节点；
# @   选取属性。

# xml示例：
from lxml import etree
text = '''
<book>
<title>Harry Potter</title>
<author>J K.Rowling</author>
<year>2005</year>
<price>29.99</price>
</book>
'''
# html示例：


tree = etree.fromstring(text)
book = tree.xpath("/book")
print(book)
print(type(book))
## 使用xpath确定元素，使用xpath返回的结果一定是列表；
t1 = book[0].xpath("./title") # 获取book元素下的子元素title
print(t1[0].tag)              # 获取节点的tag值

y1 = t1[0].xpath("../year")   # 从title节点的父节点book下，获取year节点；
print(y1[0].tag)

p1 = tree.xpath("//price")    # 从任意位置获取price节点；
print(p1[0].tag)

all1 = tree.xpath("//*")      # 从任意位置获取所有节点；
for i in all1:
    print(i.tag)

book_son = tree.xpath("/book/*") # 获取book节点下的所有子节点；
for son in book_son:
    print(son.tag)


## 文本内容与文本节点
# 获取文本内容：
print(t1[0].text)

'''
相当于：
先打开目录："E:\Course\spyder"
再打开文件："xml示例.xml"
'''
# 获取文本节点：
t1_text = tree.xpath("//title/text()") # 所有title元素的  
t1_text

'''
相当于：
直接打开："E:\Course\spyder\xml示例.xml"
'''
