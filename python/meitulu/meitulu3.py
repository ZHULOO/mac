# 下载一个牛仔合集网页上的多个专辑：
# cd "python/meitulu"
# python meitulu3.py https://www.tujidao.com/s/?id=24 (牛仔合集的一个网页)
import os
import requests
from bs4 import BeautifulSoup
from requests.packages import urllib3
os.chdir(r'E:\MyGit\python\meitulu')
# 定义函数:输入一个合集网页，得到一个网页下所有专辑的链接:
def get_add(url):
    headers = {'user-agent': 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Mobile Safari/537.36 Edg/96.0.1054.62',
    'cookie':'UM_distinctid=17bf81bb0772ae-07ff0e6c48d262-57341040-240000-17bf81bb078b2b; PHPSESSID=isijdiah8msh88rln1tgqp0i0j; CNZZDATA1257039673=1055518379-1615096700-%7C1641000419; uid=46423; name=frozenevil; leixing=3'}
    urllib3.disable_warnings()
    r = requests.get(url, headers=headers,timeout=10,verify = False)
    r.encoding = r.status_code
    soup = BeautifulSoup(r.text,'lxml')
    text1 = soup.find_all(attrs={'class':'biaoti'})
    address = []
    for i in text1:
        address.append('https://www.tujidao.com'+i.a['href'])
    return address

# 定义函数:输入某个模特的合集网页,下面自动爬取所有专辑的图片
def get_pics(url):
    address = get_add(url)
    for i in address:
        os.system("python meitulu2.py {0}".format(i))

#if __name__ == '__main__':
    #url = sys.argv[1]       # 输入的多个专辑合集的网址赋值给url；
    #get_pics(url)     # 获取该合集下的多个专辑的网址；
    
'''
url = "https://www.tujidao.com/s/?id=24"
address = get_add(url)
'''