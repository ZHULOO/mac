"""爬取美图录:分析图片链接后,根据链接规律自动构造图片链接:
运行命令:python meitulu1.py "http://www.meitulu.cn/item/6235.html" 爬取美图录上的单个专辑图片；不是tujidao上的图片，一页只能打开一张照片；

""" 
import os
import requests
from requests.packages import urllib3
from bs4 import BeautifulSoup
import re
import sys

# 定义函数:得到专辑名称:
def get_user(url):
    headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.113 Safari/537.36',
    'cookie':'UM_distinctid=17543a8738768-03e8ef6ceee3ac-c781f38-240000-17543a87388b64; CNZZDATA1261577737=100246119-1603157333-https%253A%252F%252Fwww.baidu.com%252F%7C1603157333'}
    urllib3.disable_warnings()
    r = requests.get(url, headers=headers,timeout=10,verify = False)
    r.encoding = r.status_code
    soup = BeautifulSoup(r.text,'lxml')
    text1 = soup.find_all(attrs={'class':'weizhi'})
    text2 = text1[0].find_all('h1') 
    user = text2[0].get_text().strip().replace("/","") # 两边可能含有的空格和/;
    return user

# 定义函数:得到专辑编码和图片数量:
def get_num(url):
    headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.113 Safari/537.36',
    'cookie':'UM_distinctid=17543a8738768-03e8ef6ceee3ac-c781f38-240000-17543a87388b64; CNZZDATA1261577737=100246119-1603157333-https%253A%252F%252Fwww.baidu.com%252F%7C1603157333'}
    urllib3.disable_warnings()
    r = requests.get(url, headers=headers,timeout=10,verify = False)
    r.encoding = r.status_code
    soup = BeautifulSoup(r.text,'lxml')
    text1 = soup.find_all(attrs={'class':'c_l'})
    idstr = re.findall(r'\d+', url) # 匹配到出"10081"
    pattern = re.compile(r'(?<=<p>图片数量： )\d+\d')
    num = pattern.findall(str(text1))
    return idstr[0],num[0]

# 定义函数:根据图片数量生成图片网页链接:http://www.meitulu.cn/item/6235_2.html，并获取该网页下图片的链接：
def get_dload(idstr,num):
    dload = ["http://www.meitulu.cn/item/"+str(idstr)+".html"]
    for i in range(2,int(num)+1):
        dload.append("http://www.meitulu.cn/item/"+str(idstr)+"_"+str(i)+".html")
    return dload

def jpg_add(dload):
    headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.113 Safari/537.36',
    'cookie':'UM_distinctid=17543a8738768-03e8ef6ceee3ac-c781f38-240000-17543a87388b64; CNZZDATA1261577737=100246119-1603157333-https%253A%252F%252Fwww.baidu.com%252F%7C1603157333'}
    add2 = []
    for i in dload:
        urllib3.disable_warnings()
        r = requests.get(i, headers=headers,timeout=10,verify = False)
        r.encoding = r.status_code
        soup = BeautifulSoup(r.text,'lxml')
        text1 = soup.find_all(attrs={'class':'content'})
        text2 = text1[0].find_all('img')
        add1 = text2[0].get('src')
        add2.append(add1)
    return add2

# 定义函数:得到每个图片的二进制信息:
def get_content(url):
    try:
        headers = {
            'Referer':'http://www.meitulu.cn/',
            'Accept-Encoding':'gzip, deflate',
            'Cookie':'UM_distinctid=17543a8738768-03e8ef6ceee3ac-c781f38-240000-17543a87388b64; CNZZDATA1261577737=100246119-1603157333-https%253A%252F%252Fwww.baidu.com%252F%7C1603162749',
            'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36'
        }
        urllib3.disable_warnings()
        r = requests.get(url, headers=headers,timeout=10,verify = False)
        if r.status_code == 200:
            return r.content
        else:
            print('请求照片二进制流错误, 错误状态码：', r.status_code)
    except Exception as e:
        print(e)
        return None

def down_img(jpg_add,user):
    dirpath = r'F:/meitulu/{0}'.format(user)
    if not os.path.exists(dirpath):
        os.mkdir(dirpath)
    for i in range(0,len(jpg_add)):
        try:
            content = get_content(jpg_add[i])
            file_path = r'F:/meitulu/{0}/{1}.jpg'.format(user, i+1)
            if not os.path.exists(file_path):
                with open(file_path, 'wb') as f:
                    print('第{0}张下载完成： '.format(i+1) + jpg_add[i])
                    f.write(content)
                    f.close()
            else:
                print('第{0}张照片已下载'.format(i+1))
        except Exception as e:
            print(e)
            print('这张图片下载失败')


if __name__ == '__main__':
    url = sys.argv[1]            # 输入专辑url；
    user = get_user(url)         # 获取专辑名称；
    idstr,num = get_num(url)     # 获取专辑编码和图片数量
    dload = get_dload(idstr,num) # 根据专辑编码和图片数量生成图片下载链接；
    jpg_add = jpg_add(dload)
    down_img(jpg_add,user)         # 根据图片链接和用户名下载图片保存在以用户名命名的文件夹内；



'''
url = "http://www.meitulu.cn/item/6235_2.html"  # 单个图片地址
url = "http://www.meitulu.cn/item/6235.html"    # 下载地址
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
text1 = soup.find_all(attrs={'class':'content'})
text2 = text1[0].find_all('img')
jpg_add = text2[0].get('src')

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