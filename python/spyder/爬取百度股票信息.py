import requests
from bs4 import BeautifulSoup
import traceback
import re
def gethtmltext(url):
    try:
        r = requests.get(url)
        r.raise_for_status()
        r.encoding = r.apparent_encoding
        return r.text
    except:
        return ""

def getstocklist(lst,stockurl):
    html = gethtmltext(stockurl)
    soup = BeautifulSoup(html,"html.parser")
    a = soup.find_all("a")
    for i in a:
        try:
            href = i.attrs["href"]
            lst.append(re.findall(r"[s][hz]\d{6}",href)[0])
        except:
            continue

def getstockinfo(lst,stockurl,fpath):
    for stock in lst[1:100]:
        url = stockurl + stock +'.html'
        html=gethtmltext(url)
        try:
            if html=="":
                continue
            infodict = {}
            soup = BeautifulSoup(html,'html.parser')
            stockinfo = soup.find('div',attrs={'class':'stock-bets'})

            name =stockinfo.find_all(attrs={'class':'bets-name'})[0]
            infodict.update({'股票名称'：name.text.split()[0]})

            keylist = stockinfo.find_all('dt')
            valuelist = stockinfo.find_all('dd')
            for i in range(len(keylist)):
                key = keylist[i].text
                val = valuelist[i].text
                infodict[key] = val

            with open(fpath,'a',encoding='utf-8') as f:
                f.write(str(infodict)+'\n')
        except:
            traceback.print_exc()
            continue            

def main():
    stock_list_url = "http://quote.eastmoney.com/stocklist.html"
    stock_info_url = "https://gupiao.baidu.com/stock/"
    output_file = "e:/Python/gupiao.txt"
    slist = []
    getstocklist(slist,stock_list_url)
    getstockinfo(slist,stock_info_url,output_file)

main()



#以下是练习代码：
url = "http://quote.eastmoney.com/stocklist.html"
html = gethtmltext(url)
soup = BeautifulSoup(html,"html.parser")
a = soup.find_all("a")

lst=[]
for i in a:
    try:
        href = i.attrs["href"]
        lst.append(re.findall(r"[s][hz]\d{6}",href)[0])
    except:
        continue

lst=[]
for i in a:
    try:
        href = i.attrs['href']
        lst.append(href)
    except:
        continue

http=[]
for i in lst[100:200]:
    code = re.findall(r'[s][hz]\d{6}',i)
    http.append(code)

# 练习爬取细节
# 引入库，运行前两个函数，获取lst列表，练习第三个函数：
url = "http://quote.eastmoney.com/stocklist.html"
lst = []
getstocklist(lst,url)#运行后取得股票代码列表lst
infodict = {}
soup = BeautifulSoup(html,'html.parser')
stockinfo = soup.find('div',attrs={'class':'stock-bets'})#soup中找出div class="stock-bets"标签，该板块含有所要爬取的个股信息，赋给stockinfo变量
name =stockinfo.find_all(attrs={'class':'bets-name'})[0]#stockinfo中找出class="bets-name"的标签，赋值给name变量
infodict.update({'股票名称':name.text.split()[0]})                                                                       

keylist = stockinfo.find_all('dt')
valuelist = stockinfo.find_all('dd')
for i in range(len(keylist)):
    key = keylist[i].text
    val = valuelist[i].text
    infodict[key] = val

fpath = "e:/Python/gupiao.txt"
with open(fpath,'a',encoding='utf-8') as f: #在开发的过程中，会有很多对象在使用之后，是需要执行一条或多条语句来进行关闭，释放等操作的，
                                            #例如上面说的的文件，还有数据库连接，锁的获取等，这些收尾的操作会让代码显得累赘，
                                            #也会造成由于程序异常跳出后，没有执行到这些收尾操作，而导致一些系统的异常，
                                            #还有就是很多程序员会忘记写上这些操作-_-!-_-!，为了避免这些错误的产生，with语句就被生产出来了。
                                            #with语句的作用就是让程序员不用写这些收尾的代码，并且即使程序异常也会执行到这些代码（finally的作用）
    f.write(str(infodict)+'\n')
except:
traceback.print_exc()
continue