"""某年某期的全部文章在一个网页,一共134期文章,134个网页,保存在web2列表下,用一个循环爬取134页的文章""" 
import csv
import requests
from bs4 import BeautifulSoup
# 第一步先得到每一期的目录页网址web2:
url = "http://www.erj.cn/cn/mlInfo.aspx?m=20190130093538450747&n=20190130093720527750&tip=0"
headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
r = requests.get(url, headers=headers,timeout=3)
soup = BeautifulSoup(r.text,'lxml')

table1 = soup.find_all(attrs={'class':'lm1-leftBOX_01'}) # 左侧栏的下的所有文本内容;获取的结果是一个元素的列表;
table2 = table1[0].find_all('li')                        # 获取的结果是134个li元素的列表;
web1=[]
for i in table2:
    web1.append(i.a.get('href'))

web2=[]
for i in web1:
    web2.append("http://www.erj.cn/cn/"+i)

# 定义函数:
def get_web(url):
    headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
    r = requests.get(url, headers=headers,timeout=3)
    soup = BeautifulSoup(r.text,'lxml')
    text1 = soup.find_all(attrs={'class':'lm1-rightBOX_down'})
    text2 = text1[0].find_all('table') 
    
    td=[]
    for table in text2:
        td.append(table.find_all('td'))

    sub = []
    for i in range(0,len(td)):
        for j in range(0,len(td[i])):
            sub.append(td[i][j].get_text())

    lst1=[sub[i:i+3] for i in range(0,len(sub),3)]

    for j in range(0,len(lst1)):            
        with open("e:/Python/jingjiyanjiu.csv",'a',newline = "",encoding='utf_8_sig') as f: 
            writer = csv.writer(f,dialect='excel')
            writer.writerow(lst1[j])

# 最终爬取web2中的所有网址:
count = 1
for web in web2:
    get_web(web)
    print("\r当前进度：{:.2f}%".format(count*100/134),end=" ")
    count = count+1


### 完整地爬取经济研究后写入mysql操作:
mysql -h192.168.3.50 -uzhuloo -pz20465879
use test;
CREATE TABLE article (
  id int(11) NOT NULL AUTO_INCREMENT,
  title varchar(255) NOT NULL,
  abstract varchar(1000) NOT NULL,
  author varchar(255) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
show tables;

import MySQLdb
import requests
from bs4 import BeautifulSoup
# 第一步先得到每一期的目录页网址web2:
url = "http://www.erj.cn/cn/mlInfo.aspx?m=20190130093538450747&n=20190130093720527750&tip=0"
headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
r = requests.get(url, headers=headers,timeout=3)
soup = BeautifulSoup(r.text,'lxml')

table1 = soup.find_all(attrs={'class':'lm1-leftBOX_01'}) # 左侧栏的下的所有文本内容;获取的结果是一个元素的列表;
table2 = table1[0].find_all('li')                        # 获取的结果是134个li元素的列表;
web1=[]
for i in table2:
    web1.append(i.a.get('href'))

web2=[]
for i in web1:
    web2.append("http://www.erj.cn/cn/"+i)

# 定义函数:
def get_web(url):
    headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
    r = requests.get(url, headers=headers,timeout=3)
    soup = BeautifulSoup(r.text,'lxml')
    text1 = soup.find_all(attrs={'class':'lm1-rightBOX_down'})
    text2 = text1[0].find_all('table') 
    
    td=[]
    for table in text2:
        td.append(table.find_all('td'))

    sub = []
    for i in range(0,len(td)):
        for j in range(0,len(td[i])):
            sub.append(td[i][j].get_text())

    lst1=[sub[i:i+3] for i in range(0,len(sub),3)] 
    return lst1

lst1 = get_web(url) # 得到一个网页,即一期的信息,存储到lst1中;
# 定义一个建立数据库连接和游标:
def get_cursor():    #定义一个函数建立数据可连接并返回两个参数:连接,游标,用(connect,cursor) = get_cursor()获得函数返回的connect和cursor对象;
    import MySQLdb
    connect = None   # 连接对象
    cursor = None    # 游标对象
    try:
        # 连接对象
        connect = MySQLdb.connect(
            host ='192.168.3.50',   # 主机地址 ,服务器上运行,就是以zhuloo用户连上本机的数据库;
            port = 3306,
            user ='zhuloo',         # 账号
            password ='z20465879',  # 密码
            database ='test',       # 数据库名
            connect_timeout = 120,
            use_unicode = True,
            charset='utf8'          # 指定字符集
        )
        # 游标对象
        cursor = connect.cursor()   # 通过连接对象调用cursor()
        return connect,cursor
    except Exception as e:
        print(e)
        connect.close()
# 利用游标cursor写入数据库:
(connect,cursor) = get_cursor()
try:
    if cursor:
        for i in range(0,len(lst1)):        # 循环插入列表中的数据:
            sql = "insert into article (title,abstract,author) values(%s,%s,%s)"
            cursor.execute(sql,(lst1[i][0],lst1[i][1],lst1[i][2]))
        connect.commit()   # 提交
except Exception as e:
    print(e)
    connect.rollback()   # 回滚
finally:
    if cursor:
        cursor.close()
    if connect:
        connect.close()

# 最终爬取web2中的所有网址:
count = 1
lst=[]
for web in web2:
    lst1 = get_web(web)
    lst = lst+lst1 # 合并每一个网页爬取得到的列表;
    print("\r当前进度：{:.2f}%".format(count*100/134),end=" ")
    count = count+1
# 此时已爬取得到了所有信息存储在列表lst中,下面将lst写入数据库:
(connect,cursor) = get_cursor()
try:
    if cursor:
        count = 1
        total = len(lst)
        for i in range(0,len(lst)):
            sql = "insert into article (title,abstract,author) values(%s,%s,%s)"
            result = cursor.execute(sql,(lst[i][0],lst[i][1],lst[i][2])) # 将执行的结果赋值给一个无用的变量,就不会返回每次执行成功时返回的数字"1",下面为每次执行成功进行计数,并显示执行进度:
            print("总共爬取{:.2f}篇文章".format(total))
            print("\r已完成：{:.2f}%".format(count*100/total),end=" ")
            count = count + 1
        connect.commit()   # 提交
except Exception as e:
    print(e)
    connect.rollback()   # 回滚
finally:
    if cursor:
        cursor.close()
    if connect:
        connect.close()


### 练习案例:循环插入数据库

# 单个插入:
(connect,cursor) = get_cursor()
try:
    if cursor:
        result = cursor.execute("insert into students (name, age) values ('Peter', 30)")
        print('result = {}'.format(result))
        connect.commit()
except Exception as e:
    print(e)
    connect.rollback()
finally:
    if cursor:
        cursor.close()
    if connect:
        connect.close()


# 循环插入:
(connect,cursor) = get_cursor() # 获取连接和游标
try:
    if cursor:
        sql = ""
        for i in range(10):
            sql = "insert into students (name, age) values(%s,%s)"
            result = cursor.execute(sql,("hello",i))
        connect.commit()
except Exception as e:
    print(e)
    connect.rollback()
finally:
    if cursor:
        cursor.close()
    if connect:
        connect.close()

