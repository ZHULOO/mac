import os
os.chdir(r'E:\MyGit\python\meitulu')
os.getcwd()
################################################################################
### meitulu2.py 下载单个专辑下的多张图片：
# python meitulu2.py "https://www.tujidao.com/a/?id=32730" # 不是在python终端，是在cmd终端中使用
# 或者python终端
url = "https://www.tujidao.com/a/?id=32730"
os.system("python meitulu2.py {0}".format(url))

###############################################################################
### meitulu3.py 下载一个model（付艺轩）合集的所有专辑：
# python meitulu3.py "https://www.tujidao.com/t/?id=2794&page=1" #cmd命令
# 或者
url = "https://www.tujidao.com/t/?id=2794&page=1"
os.system("python meitulu3.py {0}".format(url))

##############################################################################
# 某个人、机构、系列可能有多页合集,可能出错:
for i in range(1,3): # 一共有两页合集：
    url = "https://www.tujidao.com/t/?id=2794&page="+str(i)
    os.system("python meitulu3.py {0}".format(url))
# 20200728模范学院15页 
for i in range(2,16):
    url = "https://www.tujidao.com/x/?id=70&page="+str(i)
    os.system("python meitulu3.py {0}".format(url))

# 20200911翘臀29页 
# 只能下载第一页 后面会出错，下载不下来；
for i in range(1,30):
    url = "https://www.tujidao.com/s/?id=46&page="+str(i)
    os.system("python meitulu3.py {0}".format(url))
# 此方法正常运行；
for i in range(2,30):
    get_pics("https://www.tujidao.com/s/?id=46&page="+str(i))

############################################################################
### 下载ARTGRAVIA图集（合辑）：
# 首先运行meitulu3.py中的函数；
# 然后再运行一下内容：
os.getcwd()
get_pics("https://www.tujidao.com/x/?id=101&page=1") # 下载一个网页上的多个专辑
# 20210606下载ARTGRAVIA图集,共三页:
import os
os.getcwd()
os.chdir(r'E:\MyGit\python\meitulu')
from meitulu3 import get_pics
for i in range(1,n):
    get_pics("https://www.tujidao.com/x/?id=101&page="+str(i))

# 自定义方法运行:2022年1月1日
# get_jigou函数下载机构合集,url 共n页
def get_jigou(url,n):
    import os
    os.chdir(r'E:\MyGit\python\meitulu')
    from meitulu3 import get_pics
    for i in range(1,n):
        get_pics(url+"&page="+str(i))
# 设定机构url,和页码
url = "https://www.tujidao.com/x/?id=101" # ARTGRAVIA图集网址的前(n-1)页
n = 8
# 运行一下命令即可开始下载:
get_jigou(url,n)

# 下载花漾前2页:
# 先从目录导入get_jigou函数
import os
os.getcwd()
os.chdir(r'E:\MyGit\python\meitulu')
from tujidao import get_jigou
# 然后设定机构网址和下载的页数n-1
url = "https://www.tujidao.com/x/?id=23"
n = 3
get_jigou(url,n)




### 20201124后的保存到移动硬盘上G:\vip:
import os
os.chdir(r'E:\MyGit\python\meitulu')
os.getcwd()
# 20210412
# 下载秀人最新合集的前两页：http://tujidao.com/x/?id=59&page=1
import meitulu3 
for i in range(1,3):
    get_pics("http://tujidao.com/x/?id=59&page="+str(i))





### 下载单个专辑：
# CMD终端下，进入meitulu文件夹；
# 运行“python meitulu2.py "https://www.tujidao.com/a/?id=36315" ”

##################################################################################


# 一、按机构分类下载：
# 下载秀人共84页
for i in range(1,85):
    get_pics("http://www.tujidao.com/x/?id=59&page="+str(i))
# 秀人最新的20页：https://www.tujidao.com/x/?id=59&page=1 20200728
for i in range(1,21):
    get_pics("https://www.tujidao.com/x/?id=59&page="+str(i))

# 模范学院15页 20200729 合集1-301
for i in range(2,16):
    get_pics("https://www.tujidao.com/x/?id=70&page="+str(i))
# 王雨纯最新2页 20200803 
for i in range(1,3):
    get_pics("https://www.tujidao.com/t/?id=293&page="+str(i))

# graphis合辑前十页，截止到2015年
for i in range(1,11):
    get_pics("https://www.tujidao.com/x/?id=43&page="+str(i))


# 二、按人物分类下载：
# 松果儿共2页
for i in range(1,3):
    get_pics("http://www.tujidao.com/t/?id=665&page="+str(i))
# 刘飞儿共2页
for i in range(1,3):
    get_pics("http://www.tujidao.com/t/?id=118&page="+str(i))
# 糯美子共2页
for i in range(1,3):
    get_pics("http://www.tujidao.com/t/?id=161&page="+str(i))
# 于大小姐共2页
for i in range(1,3):
    get_pics("http://www.tujidao.com/t/?id=940&page="+str(i))
# 于思琪
get_pics("http://www.tujidao.com/t/?id=1344")
# 赵智妍
get_pics("http://www.tujidao.com/t/?id=3193")
# 伊莉
get_pics("http://www.tujidao.com/t/?id=4437")
# 夏茉共2页
for i in range(1,3):
    get_pics("http://www.tujidao.com/t/?id=450&page="+str(i))
# 谢芷馨共4页
for i in range(1,5):
    get_pics("http://www.tujidao.com/t/?id=796&page="+str(i))
# 尤妮丝共4页
for i in range(1,5):
    get_pics("http://www.tujidao.com/t/?id=3852&page="+str(i))

# 2020年4月后加入了https模式，网址改为https：
# 付艺轩共2页
for i in range(1,3):
    get_pics("https://www.tujidao.com/t/?id=2794&page="+str(i))



################################################################################
# 三类网址:
# 个人合集网页，一个网页下是该人多个专辑：
person_url = "https://www.tujidao.com/t/?id=2794&page=1" # 付艺轩合集，共2页；


# 机构合集网页，一个网页下是该机构的多个专辑:
stitute_url = "https://www.tujidao.com/x/?id=59&page=1" # 秀人网合集第1页，共90页，1793个专辑；

# 单个专辑网页，一个网页下是该专辑的各张图片：
url = "https://www.tujidao.com/a/?id=32697" # 秀人第1804期，月音瞳专辑；


import os
os.chdir(r"e:/mygit/python/meitulu")
os.getcwd()
# meitulu1的函数：是用来爬取美图录的图片,图集岛是美图录的VIP版；
from meitulu1 import get_user
from meitulu1 import get_num
from meitulu1 import get_dload
url = "https://www.meitulu.com/item/19022.html" # 单个专辑地址；
user = get_user(url)         # 获取专辑名称；
idstr,num = get_num(url)     # 获取专辑编码和图片数量
dload = get_dload(idstr,num) # 根据专辑编码和图片数量生成图片下载链接,此方法不可取，一旦图片数量变化，链接会出错；


import os
os.chdir(r"e:/mygit/python/meitulu")
os.getcwd()
# meitulu2的函数：是用来爬取tujidao上的单个专辑的图片；
from meitulu2 import get_user
from meitulu2 import get_address
url = "https://www.tujidao.com/a/?id=32697" # 单个专辑地址；
user = get_user(url)    # 根据专辑链接获取专辑名称；
dload = get_address(url)# 根据专辑链接获取专辑每一张图片的链接；

import os
os.chdir(r"e:/mygit/python/meitulu")
os.getcwd()
# meitulu3的函数：先获取一个网页下的所有专辑的网址，再使用meitulu2爬取每个专辑下的图片；
from meitulu3 import get_add
from meitulu3 import get_pics # 输入专辑合集页的链接，下载该页上的所有专辑的图片；
url = "https://www.tujidao.com/x/?id=59&page=1" # 秀人网第一页的所有专辑；
address = get_add(url)








import requests
from requests.packages import urllib3
from bs4 import BeautifulSoup
import re
import sys
headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.113 Safari/537.36','cookie': 'UM_distinctid=174dca787a45a2-0d66d330b4de42-3d634d00-240000-174dca787a5600; PHPSESSID=sk249s0mku92ks25ibk1n4datg; uid=46423; name=frozenevil; leixing=3; CNZZDATA1257039673=1090742949-1601429801-%7C1603011783'}
urllib3.disable_warnings()
url = "https://www.tujidao.com/a/?id=34957"
r = requests.get(url, headers=headers,timeout=10,verify = False)
r.encoding = r.status_code
soup = BeautifulSoup(r.text,'lxml')
text1 = soup.find_all(attrs={'class':'tuji'})
text2 = text1[0].find_all('h1') 
user = text2[0].get_text().strip().replace("/","") # 两边可能含有的空格和/;



