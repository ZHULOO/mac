# 爬去各大代理网站面费代理IP：https://www.cnblogs.com/ruogu/p/9606599.html
# 主要步骤：
# 1，在各大网站爬去免费代理ip
# 2，检查ip可用 可用存入数据库1和2
# 3，在数据库1中拿出少量代理ip存入数据库2（方便维护）
# 4，定时检查数据库1和数据库2的代理数量，以及是否可用
# 5，调用端口
def IPList_61():
  for q in [1,2]:
      url='http://www.66ip.cn/'+str(q)+'.html'
      html=Requestdef.get_page(url)
      if html!=None:
          #print(html)
          iplist=BeautifulSoup(html,'lxml')
          iplist=iplist.find_all('tr')
          i=2
          for ip in iplist:
             if i<=0:
                 loader=''
                 #print(ip)
                 j=0
                 for ipport in ip.find_all('td',limit=2):
                     if j==0:
                        loader+=ipport.text.strip()+':'
                     else:
                         loader+=ipport.text.strip()
                     j=j+1
                 Requestdef.inspect_ip(loader)
             i=i-1
      time.sleep(1)