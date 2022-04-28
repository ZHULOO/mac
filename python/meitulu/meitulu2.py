"""爬取美图录VIP图集岛上的图片:分析图片链接后,根据链接规律自动构造图片链接:
""" 
import os
import requests
from bs4 import BeautifulSoup
from requests.packages import urllib3
import sys

# 定义函数:得到专辑名称:
def get_user(url):
    headers = {'user-agent': 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Mobile Safari/537.36 Edg/96.0.1054.62',
    'cookie':'UM_distinctid=17bf81bb0772ae-07ff0e6c48d262-57341040-240000-17bf81bb078b2b; PHPSESSID=isijdiah8msh88rln1tgqp0i0j; CNZZDATA1257039673=1055518379-1615096700-%7C1641000419; uid=46423; name=frozenevil; leixing=3'}
    urllib3.disable_warnings()
    r = requests.get(url, headers=headers, timeout=10, verify = False)
    r.encoding = r.status_code
    soup = BeautifulSoup(r.text,'lxml')
    text1 = soup.find_all(attrs={'class':'tuji'})
    text2 = text1[0].find_all('h1') 
    user = text2[0].get_text().strip().replace("/","") # 两边可能含有的空格和/;
    return user

# 定义函数:自动获取每张图片链接:不再像meitulu1中根据专辑编码和图片数量生成图片链接；
def get_address(url):
    headers = {'user-agent': 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Mobile Safari/537.36 Edg/96.0.1054.62',
    'cookie':'UM_distinctid=17bf81bb0772ae-07ff0e6c48d262-57341040-240000-17bf81bb078b2b; PHPSESSID=isijdiah8msh88rln1tgqp0i0j; CNZZDATA1257039673=1055518379-1615096700-%7C1641000419; uid=46423; name=frozenevil; leixing=3'}
    urllib3.disable_warnings()
    r = requests.get(url, headers=headers,timeout=10,verify = False)
    r.encoding = r.status_code
    soup = BeautifulSoup(r.text,'lxml')
    text1 = soup.find_all(attrs={'id':'kbox'})
    text2 = text1[0].find_all('img')
    address = []
    for i in text2:
        address.append(i['data-src'])
    return address

# 定义函数:得到每个图片的二进制信息:
def get_content(url):
    try:
        headers = {'user-agent': 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Mobile Safari/537.36 Edg/96.0.1054.62',
        'cookie':'UM_distinctid=17bf81bb0772ae-07ff0e6c48d262-57341040-240000-17bf81bb078b2b; PHPSESSID=isijdiah8msh88rln1tgqp0i0j; CNZZDATA1257039673=1055518379-1615096700-%7C1641000419; uid=46423; name=frozenevil; leixing=3'}
        urllib3.disable_warnings()
        r = requests.get(url, headers=headers,timeout=10,verify = False)
        if r.status_code == 200:
            return r.content
        else:
            print('请求照片二进制流错误, 错误状态码：', response.status_code)
    except Exception as e:
        print(e)
        return None

def down_img(dload,user):
    dirpath = r'G:/vip/{0}'.format(user) # 将下载目录更改到移动硬盘G:/vip
    if not os.path.exists(dirpath):
        os.mkdir(dirpath)
    for i in range(0,len(dload)):
        try:
            content = get_content(dload[i])
            file_path = r'G:/vip/{0}/{1}.jpg'.format(user, i+1)
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
    url = sys.argv[1]       # 输入的单个专辑网址赋值给url；
    user = get_user(url)    # 根据专辑链接获取专辑名称；
    dload = get_address(url)# 根据专辑链接获取专辑每一张图片的链接；
    down_img(dload,user)    # 根据图片链接下载图片保存在以专辑名称命名的文件夹内。


# 出错：重装了系统，更换了headers和cookie
