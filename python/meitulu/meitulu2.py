"""爬取美图录VIP图集岛上的图片:分析图片链接后,根据链接规律自动构造图片链接:
""" 
import os
import requests
from bs4 import BeautifulSoup
from requests.packages import urllib3
import sys

# 定义函数:得到专辑名称:
def get_user(url):
    headers = {'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36 Edg/101.0.1210.39',
    'cookie':'PHPSESSID=4ll5opa4vctbst7pmkechbothe; __51vcke__Je64MI06Q1Neac4F=eb961528-bc14-5842-8356-23fdce676cce; __51vuft__Je64MI06Q1Neac4F=1651483931802; uid=46423; name=frozenevil; leixing=3; __51uvsct__Je64MI06Q1Neac4F=3; __vtins__Je64MI06Q1Neac4F=%7B%22sid%22%3A%20%220f0e8a02-5ff8-5079-a058-5a04f4c8f722%22%2C%20%22vd%22%3A%2019%2C%20%22stt%22%3A%20841042%2C%20%22dr%22%3A%20120152%2C%20%22expires%22%3A%201652351048626%2C%20%22ct%22%3A%201652349248626%7D'}
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
    headers = {'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36 Edg/101.0.1210.39',
    'cookie':'PHPSESSID=4ll5opa4vctbst7pmkechbothe; __51vcke__Je64MI06Q1Neac4F=eb961528-bc14-5842-8356-23fdce676cce; __51vuft__Je64MI06Q1Neac4F=1651483931802; uid=46423; name=frozenevil; leixing=3; __51uvsct__Je64MI06Q1Neac4F=3; __vtins__Je64MI06Q1Neac4F=%7B%22sid%22%3A%20%220f0e8a02-5ff8-5079-a058-5a04f4c8f722%22%2C%20%22vd%22%3A%2019%2C%20%22stt%22%3A%20841042%2C%20%22dr%22%3A%20120152%2C%20%22expires%22%3A%201652351048626%2C%20%22ct%22%3A%201652349248626%7D'}
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
    try: # 需要更详细的头部信息才能请求到图片内容,多添加一个referer字段即可；
        headers = {'cookie': 'PHPSESSID=4ll5opa4vctbst7pmkechbothe; __51vcke__Je64MI06Q1Neac4F=eb961528-bc14-5842-8356-23fdce676cce; __51vuft__Je64MI06Q1Neac4F=1651483931802; uid=46423; name=frozenevil; leixing=3; __51uvsct__Je64MI06Q1Neac4F=5; __vtins__Je64MI06Q1Neac4F=%7B%22sid%22%3A%20%222aff9062-2efd-5808-bdec-8696e295fefa%22%2C%20%22vd%22%3A%205%2C%20%22stt%22%3A%2023931%2C%20%22dr%22%3A%206412%2C%20%22expires%22%3A%201652362023295%2C%20%22ct%22%3A%201652360223295%7D','referer': 'https://www.tujidao.com','user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36 Edg/101.0.1210.39'}
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
    dirpath = r'/Volumes/My Passport/vip/pics/{0}'.format(user) # 将下载目录更改到移动硬盘/Volumes/My Passport/vip
    if not os.path.exists(dirpath):
        os.mkdir(dirpath)
    for i in range(0,len(dload)):
        try:
            content = get_content(dload[i])
            file_path = r'/Volumes/My Passport/vip/pics/{0}/{1}.jpg'.format(user, i+1)
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
# /Volumes/My Passport/vip