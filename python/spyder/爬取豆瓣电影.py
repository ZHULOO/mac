import urllib.request
from bs4 import BeautifulSoup
import pymysql #pip install pymysql 在CMD窗口输入命令 

movielist = [] 
url ="https://movie.douban.com/top250"
def get_html(url): #获取html内容
    res = urllib.request.urlopen(url)
    html =res.read().decode()
    return html
#pass #占位的意思，保证函数结构的完整性

def parse_html(htmlfile): #解析html
    mysoup = BeautifulSoup(htmlfile,'html.parser')
    movie_zone = mysoup.find('ol')
    movie_list = movie_zone.find_all('li')
    for movie in movie_list:
         movie_name =movie.find('span',attrs = {'class':'title'}).getText()
         movielist.append(movie_name)
         nextpage = mysoup.find('span',attrs={'class':'next'}).find('a')
    if nextpage:
         new_url = url+nextpage['href']
         parse_html(get_html(new_url))
          







def save_data(movielist):

    pass

reshtml = get_html(url)
parse_html(reshtml)
print(movielist)
