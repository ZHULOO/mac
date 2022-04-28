# 4，定时检查数据库1和数据库2的代理数量，以及是否可用
#检查ip池数量
def time_ip():
 
    while True:
        time.sleep(5)
        Db.act_lenip()
 
#检查备用池数量
def time_ips():
    while True:
        time.sleep(30)<br>        #当备用池数量小于100 再次获取
        if Db.len_ips()<100:
            print('填数据')
            Acting_ip.iplist()
#程序入口
if __name__ == '__main__':
 
  t1=threading.Thread(target=time_ip)
  t1.start()
  t2=threading.Thread(target=time_ips)
  t2.start()
  t1.join()
  t2.join()

 #coding:utf-8
 2 import redis
 3 import Requestdef
 4 r = redis.Redis(host='127.0.0.1', port=6379)#host后的IP是需要连接的ip，本地是127.0.0.1或者localhost
 5 #主ip池
 6 def add_ip(ip):
 7      r.lpush('Iplist',ip)
 8 #备用ip池
 9 def add_ips(ip):
10      r.lpush('Iplists',ip)
11 #备用ip池第一个开始取出
12 def app_ips():
13      i=str(r.lindex('Iplists',1),encoding='utf-8')
14      r.lrem('Iplists',i,num=0)
15      return i
16 def len_ips():
17     return r.llen('Iplists')
18 def len_ip():
19     return r.llen('Iplist')
20 #第一个开始取出
21 def app_ip():
22      i=str(r.lpop('Iplist'),encoding='utf-8')
23      return i
24 #取出从最后一个开始
25 def rem_ip():
26     i=str(r.rpop('Iplist'),encoding='utf-8')
27     return i
28 #检查主ip池
29 def act_db():
30     for i in range(int(r.llen('Iplist')/2)):
31        Requestdef.inspect_ip(rem_ip())
32
33 #如果ip池数量少于25个 则填满
34 def act_lenip():
35     if r.llen('Iplist')<25:
36         print('填ip')
37         while r.llen('Iplist')<=50:
38           Requestdef.inspect_ip(app_ips())