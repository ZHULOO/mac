### 下载更新记录前n页:
#url = "https://www.tujidao.com/u/?action=gengxin&page=2"
import os
import requests
from bs4 import BeautifulSoup
from requests.packages import urllib3
# 定义函数:url为某合集下的一个网页，结果得到一个网页下所有专辑的链接:
def get_add(url):
    headers = {'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36 Edg/101.0.1210.39',
    'cookie':'PHPSESSID=4ll5opa4vctbst7pmkechbothe; __51vcke__Je64MI06Q1Neac4F=eb961528-bc14-5842-8356-23fdce676cce; __51vuft__Je64MI06Q1Neac4F=1651483931802; uid=46423; name=frozenevil; leixing=3; __51uvsct__Je64MI06Q1Neac4F=3; __vtins__Je64MI06Q1Neac4F=%7B%22sid%22%3A%20%220f0e8a02-5ff8-5079-a058-5a04f4c8f722%22%2C%20%22vd%22%3A%2019%2C%20%22stt%22%3A%20841042%2C%20%22dr%22%3A%20120152%2C%20%22expires%22%3A%201652351048626%2C%20%22ct%22%3A%201652349248626%7D'}
    urllib3.disable_warnings()
    r = requests.get(url, headers=headers,timeout=10,verify = False)
    r.encoding = r.status_code
    soup = BeautifulSoup(r.text,'lxml')
    text1 = soup.find_all(attrs={'class':'hezi'})
    text2 = text1[0].find_all('li')
    address = []
    for i in text2:
        address.append('https://www.tujidao.com'+i.a['href'])
    return address

# 定义函数:url为某合集下的一个网页,下面自动爬取该页下所有专辑的图片：
def get_pics(url):
    address = get_add(url)
    for i in address:
        os.system("python meitulu2.py {0}".format(i))


# 网页层次：某合集（花漾、秀人等）包含多页 -> 每页下面多个专辑（某个模特的某一期）-> 每个专辑多张图片
####################################下载某合集#######################################################
###先运行上面的函数,再通过一下循环下载该合集的前n页:
url = "https://www.tujidao.com/x/?id=101&page=9" # id = 101 指artgravia合集，下面有9页内容，每页下面有20个专辑，每个专辑下有多张图片；
os.getcwd()
os.chdir("/Users/zhulu/Files/MyGit/python/meitulu")
urls = []
for i in range(1,10): #下载artgravia的9页内容；
    urls.append('https://www.tujidao.com/x/?id=101&page={}'.format(i))
# 循环下载每一页下的所有专辑:
for url in urls:
    get_pics(url)



####################################下载更新页#######################################################
###先运行上面的函数,再通过一下循环下载前n页的更新:
os.getcwd()
os.chdir("/Users/zhulu/Files/MyGit/python/meitulu")
urls = []
for i in range(14,27): #下载更新第14至26页；
    urls.append('https://www.tujidao.com/u/?action=gengxin&page={}'.format(i))
# 循环下载每一页下的所有专辑:
for url in urls:
    get_pics(url)



#################################单独下载某一页上面的几十张图片############################
url = "https://www.tujidao01.com/a/?id=53000"
python meitulu2.py "https://www.tujidao01.com/a/?id=53000"  # 必须加引号
# 或者循环：
for i in address:
    os.system("python meitulu2.py {0}".format(i))







# 更新页面网址： https://www.tujidao.com/u/?action=gengxin&page=2
url = 'https://www.tujidao.com/x/?id=101&page=1'            # ARTGRAVIA图集

url = 'https://www.tujidao.com/u/?action=gengxin&page=33'   # 更新页网址
get_pics(url)