### 下载更新记录前n页:
#url = "https://www.tujidao.com/u/?action=gengxin&page=2"
import os
import requests
from bs4 import BeautifulSoup
from requests.packages import urllib3
# 定义函数:输入一个合集网页，得到一个网页下所有专辑的链接:
def get_add(url):
    headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36',
    'cookie':'UM_distinctid=174dca787a45a2-0d66d330b4de42-3d634d00-240000-174dca787a5600; PHPSESSID=sk249s0mku92ks25ibk1n4datg; uid=46423; name=frozenevil; leixing=3; CNZZDATA1257039673=1090742949-1601429801-%7C1603011783'}
    urllib3.disable_warnings()
    r = requests.get(url, headers=headers,timeout=10,verify = False)
    r.encoding = r.status_code
    soup = BeautifulSoup(r.text,'lxml')
    text1 = soup.find_all(attrs={'class':'c1'})
    text2 = text1[0].find_all('li')
    address = []
    for i in text2:
        address.append('https://www.tujidao.com'+i.a['href'])
    return address

# 定义函数:输入某个模特的合集网页,下面自动爬取所有专辑的图片
def get_pics(url):
    address = get_add(url)
    for i in address:
        os.system("python meitulu2.py {0}".format(i))

###########################################################################################
###先运行上面的函数,再通过一下循环下载前n页的更新:
os.getcwd()
os.chdir("E:\\Mygit\\python\\meitulu")
urls = []
for i in range(14,27): #下载更新第14至26页；
    urls.append('https://www.tujidao.com/u/?action=gengxin&page={}'.format(i))
# 循环下载每一页下的所有专辑:
for url in urls:
    get_pics(url)



# 更新页面网址： https://www.tujidao.com/u/?action=gengxin&page=2