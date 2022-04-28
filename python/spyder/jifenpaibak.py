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
    soup = BeautifulSoup(html,"html.parser")
    pages = soup.find("strong").text.split("/")[1]
    return pages    

def getfirminfo(year,firmurl1,firmurl2,firmurl3,fpath):
    count = 1
    pages = "3"#gethtmlpage(year)
    for i in range(1,int(pages)+1):
        url = firmurl1 + str(year) +firmurl2+str(i)+firmurl3
        html=gethtmltext(url)        
        soup = BeautifulSoup(html,'html.parser')
        firm_info = soup.find('div',attrs={'class':'zhanluzhengwk'})
        td = firm_info.find_all('td')
        lst=[]
        for td1 in td:
            lst.append(td1.text)
        lst1=[lst[i:i+9] for i in range(0,len(lst),9)]
        for j in range(0,len(lst1)):            
            with open(fpath,'a',newline = "") as f:
                writer = csv.writer(f)
                writer.writerow(lst1[j])
                print("\r当前进度：{:.2f}%".format(count*100/int(pages)),end=" ")
        count = count+1

                

def main():
    year = 2016
    page_pre_url = "http://www.cnpatent.com/score.asp?id="
    page_url = "&page="
    page_post_url = "&keyWord=&section=&industry=&province=&city=&sorta="
    output_file = "e:/Python/jifenpai.csv"
    getfirminfo(year,page_pre_url,page_url,page_post_url,output_file)
main()


pages = "3"#gethtmlpage(year)
for i in range(1,int(pages)+1):
    url = page_pre_url + str(year) +page_url+str(i)+page_post_url
    html=gethtmltext(url)        
    soup = BeautifulSoup(html,'html.parser')
    firm_info = soup.find('div',attrs={'class':'zhanluzhengwk'})
    td = firm_info.find_all('td')
    lst=[]
    for td1 in td:
        lst.append(td1.text)
    lst1=[lst[i:i+9] for i in range(0,len(lst),9)]
    for j in range(0,len(lst1)):            
        with open(fpath,'a',newline = "",encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow(lst1[j])

# 找出233页以后的问题
url = page_pre_url + str(year) +page_url+str(233)+page_post_url
html=gethtmltext(url)        
soup = BeautifulSoup(html,'html.parser')
firm_info = soup.find('div',attrs={'class':'zhanluzhengwk'})
td = firm_info.find_all('td')
lst=[]
for td1 in td:
    lst.append(td1.text)
lst1=[lst[i:i+9] for i in range(0,len(lst),9)]

# 问题2017年87页
url = "http://www.cnpatent.com/score.asp?id=2017&page=87&keyWord=&section=&industry=&province=&city=&sorta="
html=gethtmltext(url)        
soup = BeautifulSoup(html,'html.parser')
firm_info = soup.find('div',attrs={'class':'zhanluzhengwk'})
td = firm_info.find_all('td')
lst=[]
for td1 in td:
    lst.append(td1.text)
lst1=[lst[i:i+9] for i in range(0,len(lst),9)]
for j in range(0,len(lst1)):            
    with open("e:/python/87.csv",'a',newline = "") as f:
        writer = csv.writer(f)
        writer.writerow(lst1[j])