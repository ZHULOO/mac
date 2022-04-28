"""爬取美图录某合辑:
1、输入某个合辑的网址；
2、分析获取合辑下单个专辑的网址；
3、循环使用meitulu1.py获取各专辑下的图片。
运行命令:python meitulu1.py "http://www.meitulu.cn/item/6235.html"

""" 
import os
import requests
from requests.packages import urllib3
from bs4 import BeautifulSoup
import re
import sys

# 定义函数:得到合辑页面下各专辑网址:url是指合辑网址；
def get_add(url):
    headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.113 Safari/537.36',
    'cookie':'UM_distinctid=17543a8738768-03e8ef6ceee3ac-c781f38-240000-17543a87388b64; CNZZDATA1261577737=100246119-1603157333-https%253A%252F%252Fwww.baidu.com%252F%7C1603157333'}
    urllib3.disable_warnings()
    r = requests.get(url, headers=headers,timeout=10,verify = False)
    r.encoding = r.status_code
    soup = BeautifulSoup(r.text,'lxml')
    text1 = soup.find_all(attrs={'class':'p_title'})
    text2 = []
    for i in range(0,len(text1)):
        text = text1[i].a.get('href')
        text2.append(text)
    text3 = []
    for i in text2:
        text3.append("http://www.meitulu.cn"+ i) 
    return text3

def get_pic(text3):
    for i in text3:
        os.system("python meitulu1.py {0}".format(i))

if __name__ == '__main__':
    url = sys.argv[1] 
    text3 = get_add(url)
    get_pic(text3)



'''
url = "http://www.meitulu.cn/t/feituwang/"   # 飞图网合辑网址；
url = "http://www.meitulu.cn/item/6235.html" # 合辑下单个专辑下载地址；
user = get_user(url)         # 获取专辑名称；
user
idstr,num = get_num(url)     # 获取专辑编码和图片数量
idstr
num
dload = get_dload(idstr,num) # 根据专辑编码和图片数量生成图片下载链接；
dload 
for i in dload:
    print(i)

jpg_add = jpg_add(dload)

for i in jpg_add:
    print(i)


headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.113 Safari/537.36',
'cookie':'UM_distinctid=17543a8738768-03e8ef6ceee3ac-c781f38-240000-17543a87388b64; CNZZDATA1261577737=100246119-1603157333-https%253A%252F%252Fwww.baidu.com%252F%7C1603157333'}
urllib3.disable_warnings()
r = requests.get(url, headers=headers,timeout=10,verify = False)
r.encoding = r.status_code
soup = BeautifulSoup(r.text,'lxml')
text1 = soup.find_all(attrs={'class':'p_title'})
text1
text1[1]
text1[2]
a1 = text1[2].a.get('href')
a1
len(text1)

text2 = []
for i in range(0,len(text1)):
    text = text1[i].a.get('href')
    text2.append(text) 
text3 = []
for i in text2:
    text3.append("http://www.meitulu.cn"+ i)


text2 = text1.find_all('a')
text2
text2[0]
text2[1]
jpg_add = text2[0].get('href')

url = jpg_add[0]
get_content(url)

headers = {
            'Referer':'http://www.meitulu.cn/',
            'Accept-Encoding':'gzip, deflate',
            'Cookie':'UM_distinctid=17543a8738768-03e8ef6ceee3ac-c781f38-240000-17543a87388b64; CNZZDATA1261577737=100246119-1603157333-https%253A%252F%252Fwww.baidu.com%252F%7C1603162749',
            'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36'
        }
urllib3.disable_warnings()
r = requests.get(url, headers=headers,timeout=10,verify = False)



# http://image.meitulu.cn/d/file/bigpic/2016/06/25/08/2016062508533126597.jpg 图片链接无法直接下载或打开的时候，设置以上格式的headers信息；
'''