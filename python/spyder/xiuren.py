# 输入杂志的网址:"http://www.xiuren.org/category/TuiGirl.html"
import os
import requests
from bs4 import BeautifulSoup
import re
import sys

# 获取一本杂志的页数:
def get_num(url):
    headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
    r = requests.get(url, headers=headers,timeout=3)
    r.encoding = r.status_code
    soup = BeautifulSoup(r.text,'lxml')
    text1 = soup.find_all(attrs={'class':'info'})
    pages = int(text1[0].text[2:])
    return pages

# 生成一本杂志所有页的链接:
def get_magurl(url):
    num = get_num(url)
    com_add = url[0:(url.find(".html"))]
    add = []
    for i in range(1,num+1):
        add.append(com_add+"-"+str(i)+".html")
    return add 

# 获取一整页的专辑链接:
def get_page(url):
    headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
    r = requests.get(url, headers=headers,timeout=3)
    r.encoding = r.status_code
    soup = BeautifulSoup(r.text,'lxml')
    text1 = soup.find_all(attrs={'class':'loop'})
    add = []
    for i in range(0,len(text1)):
        text2 = text1[i].find_all('a') 
        add.append(text2[0].attrs['href'])
    return add

# 获取一本杂志的所有专辑的链接:
def get_urlset(url):
    urls = get_magurl(url) # 获取一个杂志所有页面链接;
    address = []
    for url in urls:
        url1 = get_page(url) # 获取每一页面的所有专辑链接;
        address.append(url1) # 每一个页面的专辑在一个子列表中,所有页面的的列表构成address,需要双重循环取出地址;
    return address

# 下载一整本杂志:
def get_pic(magzine_url): 
    urls = get_urlset(magzine_url)
    for url in urls:
        for i in url:
            os.system("python xiuren_url.py {0}".format(i))

# 下载一本杂志的第m到n页:
def get_pics(magzine_url,m=0,n=1): # 如果调用函数时不输入n,则取默认值1,默认下载杂志的第1页的所有专辑;
    urls = get_urlset(magzine_url)
    urls = urls[m:n] # 根据此处调整下载一本杂志的某几页专辑；
    for url in urls:
        for i in url:
            os.system("python xiuren_url.py {0}".format(i))

# 下载AISS一个杂志的所有专辑:
url = "http://www.xiuren.org/category/AISS.html" # 每个杂志的第一页网址
get_pic(url)

# 下载优星馆:
url = "http://www.xiuren.org/category/uxing.html"
get_pic(url)

# 下载RayShen:
url = "http://www.xiuren.org/category/rayshen.html"
get_pic(url)

# 下载头条女神:
url = "http://www.xiuren.org/category/toutiaogirls.html"
get_pic(url)
# 下载糖果画报:
url = "http://www.xiuren.org/category/candy.html"
get_pic(url)
# 下载影私荟:
url = "http://www.xiuren.org/category/wings.html"
get_pic(url)
# 下载克拉女神:
url = "http://www.xiuren.org/category/kelagirls.html"
get_pic(url)
# 下载花颜:
url = "http://www.xiuren.org/category/HuaYan.html"
get_pic(url)
# 下载星乐园:
url = "http://www.xiuren.org/category/LeYuan.html"
get_pic(url)
# 下载爱蜜社:
url = "http://www.xiuren.org/category/imiss.html"
get_pic(url)
# 下载尤物馆:
url = "http://www.xiuren.org/category/youwu.html"
get_pic(url)
# 下载动感小站:
url = "http://www.xiuren.org/category/donggan.html"
get_pic(url)
# 下载如壹写真:
url = "http://www.xiuren.org/category/ru1mm.html" # 共22页
get_pics(url,0,2)

# 下载网站综合第一页:
url = "http://www.xiuren.org/" # 共300多页
get_pics(url,0,1) # 这种方法不行,可以采用下面的单页面下载方式;


# 下载makemodel：
url = "http://www.xiuren.org/tag/makemodel.html"
get_pics(url,0,1) # 下载makemodel的第1页所有专辑;
get_pics(url,5,7) # 下载makemodel的第2-6页所有专辑;









# 下载一个专辑：
url = "http://www.xiuren.org/aiss-6006.html" # 每个专辑的网址
url = "http://www.xiuren.org/aiss-6005.html" # 每个专辑的网址
os.system("python xiuren_url.py {0}".format(url))

# 下载一个页面上的所有专辑
url = "http://www.xiuren.org/category/AISS-2.html" # AISS第二页的所有专辑 
page_urls = get_page(url)
for i in page_urls:
    os.system("python xiuren_url.py {0}".format(i))

# 下载主页上第一个页面上的所有专辑
url = "http://www.xiuren.org/page-1.html" 
page_urls = get_page(url)
for i in page_urls:
    os.system("python xiuren_url.py {0}".format(i))


# 下载单个专辑2019-12-4
url = "http://www.xiuren.org/XiuRen-N01615.html" # 每个专辑的网址
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01612.html" # 每个专辑的网址
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01614.html" # 每个专辑的网址
os.system("python xiuren_url.py {0}".format(url))


url = "http://www.xiuren.org/XiuRen-N01588.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01593.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01590.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01605.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01602.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01604.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01617.html"
os.system("python xiuren_url.py {0}".format(url))

# 2019-12-5
url = "http://www.xiuren.org/XiuRen-N01584.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01600.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01601.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01598.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01607.html"
os.system("python xiuren_url.py {0}".format(url))

# 2019-12-8
url = "http://www.xiuren.org/XiuRen-N01563.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01561.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01539.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01526.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01495.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01525.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01504.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01499.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01495.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N00655.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/LeYuan-003.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/miitao-040.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/youwu-038.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/miitao-039.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01627.html"
os.system("python xiuren_url.py {0}".format(url))
url = "http://www.xiuren.org/XiuRen-N01628.html"
os.system("python xiuren_url.py {0}".format(url))
url = ""
os.system("python xiuren_url.py {0}".format(url))
url = ""
os.system("python xiuren_url.py {0}".format(url))
url = ""
os.system("python xiuren_url.py {0}".format(url))
url = ""
os.system("python xiuren_url.py {0}".format(url))
url = ""
os.system("python xiuren_url.py {0}".format(url))
url = ""
os.system("python xiuren_url.py {0}".format(url))





'''
###练习
# 获取每个杂志的页数:
url = "http://www.xiuren.org/category/AISS.html"
url = "http://www.xiuren.org/category/TuiGirl.html"
url = "http://www.xiuren.org/category/AISS-2.html"
headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
r = requests.get(url, headers=headers,timeout=3)
r.encoding = r.status_code
soup = BeautifulSoup(r.text,'lxml')
text1 = soup.find_all(attrs={'class':'info'})
pages = int(text1[0].text[2:])

# 字符串操作:
start = url.find(".html")
str1 = url[0:(url.find(".html"))]


# 输入一本杂志的网址:
url = "http://www.xiuren.org/category/AISS.html"
# 1.根据一个杂志的页数生成所有页面的链接:
page1 = get_magurl(url)
# 2.获取所有页面的专辑链接:即一个杂志所有专辑的链接;
urlset = []
for page in page1:
    url1 = get_page(page)
    urlset.append(url1)

urlset
picurl = []
for urls in urlset:
    for url in urls:
        picurl.append(url)
'''
'''
def get_pics(magzine_url):
    urls = get_urlset(magzine_url)
    for url in urls:
        for i in url:
            print("python xiuren_url.py {0}".format(i))
'''
'''
magzine_url= "http://www.xiuren.org/tag/makemodel.html"
urls = get_urlset(magzine_url)
urls = urls[0:-1]

a = ['a','b','c','d','e','f','g']
def cutt(str1,n=1):
    print(str1[0:n])
'''