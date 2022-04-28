import requests
from bs4 import BeautifulSoup
import traceback
import re
def gethtmltext(url,code="utf-8"):
    try:
        r = requests.get(url)
        r.raise_for_status()
        r.encoding = code
        return r.text
    except:
        return ""

def getstocklist(lst,stockurl):
    html = gethtmltext(stockurl,"GB2312")
    soup = BeautifulSoup(html,"html.parser")
    a = soup.find_all("a")
    for i in a:
        try:
            href = i.attrs["href"]
            lst.append(re.findall(r"[s][hz]\d{6}",href)[0])
        except:
            continue

def getstockinfo(lst,stockurl,fpath):
    count = 0
    for stock in lst:
        url = stockurl + stock +'.html'
        html=gethtmltext(url)
        try:
            if html=="":
                continue
            infodict = {}
            soup = BeautifulSoup(html,'html.parser')
            stockinfo = soup.find('div',attrs={'class':'stock-bets'})
            name =stockinfo.find_all(attrs={'class':'bets-name'})[0]
            infodict.update({'股票名称':name.text.split()[0]})
            keylist = stockinfo.find_all('dt')
            valuelist = stockinfo.find_all('dd')
            for i in range(len(keylist)):
                key = keylist[i].text
                val = valuelist[i].text
                infodict[key] = val
            with open(fpath,'a',encoding='utf-8') as f:
                f.write(str(infodict)+'\n')
                print("\r当前进度：{:.2f}%".format(count*100/len(lst)),end=" ")
        except:
            count=count+1
            print("\r当前进度：{:.2f}%".format(count*100/len(lst)),end=" ")
            continue            

def main():
    stock_list_url = "http://quote.eastmoney.com/stocklist.html"
    stock_info_url = "https://gupiao.baidu.com/stock/"
    output_file = "e:/Python/gupiao.txt"
    slist = []
    getstocklist(slist,stock_list_url)
    getstockinfo(slist,stock_info_url,output_file)
main()