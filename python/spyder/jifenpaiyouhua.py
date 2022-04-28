import requests
from bs4 import BeautifulSoup
import csv
def gethtmltext(url):
    try:
        r = requests.get(url)
        r.raise_for_status()
        r.encoding = "GB2312"
        return r.text
    except:
        return ""

def gethtmlpage(year):
    year_pre_url = "http://www.cnpatent.com/score.asp?id="
    year_post_url = "&page=1&keyWord=&section=&industry=&province=&city=&sorta="
    url = year_pre_url+str(year)+year_post_url
    html = gethtmltext(url)
    soup = BeautifulSoup(html,"html.parser")   #爬取到37.18%出错，单引号，抛出”NoneType object has no attribute 'find_all'错误，所以不能用单引号，详见https://blog.csdn.net/qq_37828633/article/details/80641431
    pages = soup.find("strong").text.split("/")[1]
    return pages    

def getfirminfo(year,firmurl1,firmurl2,firmurl3,fpath):
    count = 1
    pages = gethtmlpage(year)
# 第一页时，爬取所有行
    url = firmurl1 + str(year) +firmurl2+str(1)+firmurl3
    html=gethtmltext(url)        
    soup = BeautifulSoup(html,"html.parser")
    firm_info = soup.find('div',attrs={'class':'zhanluzhengwk'})
    td = firm_info.find_all('td')
    lst=[]
    for td1 in td:
        lst.append(td1.text)
    lst1=[lst[i:i+9] for i in range(0,len(lst),9)]
    for j in range(0,len(lst1)):            
        with open(fpath,'a',newline = "",encoding='utf_8_sig') as f: #没有encoding = utf-8 参数，容易出现'gbk' codec can't encode character错误，详见https://www.cnblogs.com/themost/p/6603409.html 。
            writer = csv.writer(f,dialect='excel')                   #但是utf-8参数建立的csv文件，excel打开时乱码，excel不能识别utf-8编码，所以改用encoding='utf_8_sig'，详见https://blog.csdn.net/weixin_39461443/article/details/75303072
            writer.writerow(lst1[j])                                 #codecs模块解决编码问题，详见https://www.cnblogs.com/hester/p/5465338.html
            print("\r当前进度：{:.2f}%".format(count*100/int(pages)),end=" ")
    count = count+1
# 从第二页开始，不爬取第一行
    for i in range(2,int(pages)+1):
        url = firmurl1 + str(year) +firmurl2+str(i)+firmurl3
        html=gethtmltext(url)        
        soup = BeautifulSoup(html,"html.parser")
        firm_info = soup.find('div',attrs={'class':'zhanluzhengwk'})
        td = firm_info.find_all('td')
        lst=[]
        for td1 in td:
            lst.append(td1.text)
        lst1=[lst[i:i+9] for i in range(0,len(lst),9)]
        for j in range(1,len(lst1)):            
            with open(fpath,'a',newline = "",encoding='utf_8_sig') as f:
                writer = csv.writer(f,dialect='excel')
                writer.writerow(lst1[j])
                print("\r当前进度：{:.2f}%".format(count*100/int(pages)),end=" ")
        count = count+1

def main():
    year = 2016
    page_pre_url = "http://www.cnpatent.com/score.asp?id="
    page_url = "&page="
    page_post_url = "&keyWord=&section=&industry=&province=&city=&sorta="
    output_file = "e:/Python/jifenpai2016.csv"
    getfirminfo(year,page_pre_url,page_url,page_post_url,output_file)
main()