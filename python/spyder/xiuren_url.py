"""爬取美图录:分析图片链接后,根据链接规律自动构造图片链接:
运行命令:python xiuren.py "http://www.xiuren.org/tuigirl-special-lilisha-double.html"
""" 
import os
import requests
from bs4 import BeautifulSoup
import re
import sys

# 定义函数:得到专辑名称:
def get_user(url):
    headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
    r = requests.get(url, headers=headers,timeout=3)
    r.encoding = r.status_code
    soup = BeautifulSoup(r.text,'lxml')
    text1 = soup.find_all(attrs={'id':'title'})
    text2 = text1[0].find_all('h1') 
    user1 = text2[0].text
    user = user1.strip().replace("/","").replace(" ","")
    return user

# 定义函数:得到专辑图片链接:
def get_address(url):
    headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
    r = requests.get(url, headers=headers,timeout=3)
    r.encoding = r.status_code
    soup = BeautifulSoup(r.text,'lxml')
    text1 = soup.find_all(attrs={'class':'photoThum'})
    add = []
    for i in range(0,len(text1)):
        text2 = text1[i].find_all('a') 
        add.append(text2[0].attrs['href'])
    return add

# 定义函数:得到每个图片的二进制信息:
def get_content(url):
    try:
        headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
        response = requests.get(url, headers=headers, timeout=10)
        if response.status_code == 200:
            return response.content
        else:
            print('请求照片二进制流错误, 错误状态码：', response.status_code)
    except Exception as e:
        print(e)
        return None

# 根据专辑名下载图片:
def down_img(dload,user):
    dirpath = r'F:/xiuren/{0}'.format(user)
    if not os.path.exists(dirpath):
        os.mkdir(dirpath)
    for i in range(0,len(dload)):
        try:
            content = get_content(dload[i])
            file_path = r'F:/xiuren/{0}/{1}.jpg'.format(user, i+1)
            if not os.path.exists(file_path):
                with open(file_path, 'wb') as f:
                    print('第{0}张下载完成： '.format(i+1) + dload[i])
                    f.write(content)
                    f.close()
            else:
                print('第{0}张照片已下载'.format(i+1))
        except Exception as e:
            print(e)
            print('这张图片下载失败')

if __name__ == '__main__':
    url = sys.argv[1]
    user = get_user(url)
    dload = get_address(url)
    down_img(dload,user)


'''
##### 练习：
# 获取专辑名
url = "http://www.xiuren.org/tuigirl-special-lilisha-double.html"
headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
r = requests.get(url, headers=headers,timeout=3)
r.encoding = r.status_code
soup = BeautifulSoup(r.text,'lxml')
text1 = soup.find_all(attrs={'id':'title'})
text2 = text1[0].find_all('h1') 
user = text2[0].text
name = user.strip().replace("/","").replace(" ","")

# 获取专辑每个图片链接:
headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
r = requests.get(url, headers=headers,timeout=3)
r.encoding = r.status_code
soup = BeautifulSoup(r.text,'lxml')
text1 = soup.find_all(attrs={'class':'photoThum'})
add = []
for i in range(0,len(text1)):
    text2 = text1[i].find_all('a') 
    add.append(text2[0].attrs['href'])

# 获取一页上每个专辑的链接
url = "http://www.xiuren.org/category/TuiGirl.html"
headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
r = requests.get(url, headers=headers,timeout=3)
r.encoding = r.status_code
soup = BeautifulSoup(r.text,'lxml')
text1 = soup.find_all(attrs={'class':'loop'})
add = []
for i in range(0,len(text1)):
    text2 = text1[i].find_all('a') 
    add.append(text2[0].attrs['href'])




text2 = text1[0].find_all('h1') 
user = text2[0].get_text()
'''
