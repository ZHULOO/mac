'''requests库的使用:中文说明页:http://cn.python-requests.org/zh_CN/latest/'''
import requests  # 加载库
import json      #

'''传递url参数'''
# https://www.baidu.com/s?wd=python,爬取百度搜索页面的内容，搜索关键字为‘python’;
url = "https://www.baidu.com/s"
kw = {'wd': 'Python'}

'''自定义Headers'''
# 查找headers:右键检查--Network--F5刷新--点击name下的任意网址--选择Doc标签--右侧显示header等的相关信息;
# 或者输入网址:chrome://version/
headers = {
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
r = requests.get(url, headers=headers, params=kw, timeout=3)
# headers参数设置模拟浏览器头部访问;

# fake-useragent伪装请求头的库
pip install fake-useragent
from fake_useragent import UserAgent
ua = UserAgent()
print(ua.ie)
print(ua.opera)
print(ua.chrome)
print(ua.firefox)
print(ua.safari)
print(ua.random)
import requests
url = "https://www.baidu.com/s"
kw = {'wd': 'Python'}
headers = {'user-agent':ua.random}
r = requests.get(url, headers=headers, params=kw, timeout=3)
r.headers  # 查看请求的头部;
r.cookies
r.url      # 查看请求的网址;
r.history  # 显示请求的网址;
print(type(r))
print(type(r.text))
r.content  # r的二进制格式内容;
r.content.decode("utf-8")  # 二进制格式内容然后用utf-8转码;
print(r.json())
print(json.loads(r.text))
r.status_code  # requests运行后提供一种内置的状态码查询;
# 如果等于200--299，获取网页内容成功，否则失败;
# 如果等于400--499，例如404,没有找到请求的资源,网络连接问题,资源从服务器转移等;
# 如果等于500--599，例如504,服务器问题,或者服务器上运行的web应用问题;
# 响应状态:
1xx消息——请求已被服务器接收，继续处理
2xx成功——请求已成功被服务器接收、理解、并接受
3xx重定向——需要后续操作才能完成这一请求
4xx请求错误——请求含有词法错误或者无法被执行
5xx服务器错误——服务器在处理某个正确请求时发生错误.
# 常见代码:
200 OK 请求成功
400 Bad Request 客户端请求有语法错误，不能被服务器所理解
401 Unauthorized 请求未经授权，这个状态代码必须和WWW - Authenticate报头域一起使用
403 Forbidden 服务器收到请求，但是拒绝提供服务
404 Not Found 请求资源不存在，eg：输入了错误的URL
500 Internal Server Error 服务器发生不可预期的错误
503 Server Unavailable 服务器当前不能处理客户端的请求，一段时间后可能恢复正常
301 目标永久性转移
302 目标暂时性转移

r.encoding  # 获取编码方式;
r.text     # 获取文本;
r.raise_for_status  # 判断是否等于200;
r.encoding = r.status_code  # 以header中charset判断的编码方式改为以内容判断的编码方式;

'''自定义cookies'''
# Requests中自定义cookies也不用再去构造CookieJar对象，直接将字典递给cookies参数:
url = "http://httpbin.org/cookies"
co = {'cookies_are': 'working'}
r = requests.get(url, cookies=co)
print(r.text)
# 获取cookies:
r = requests.get("https://www.baidu.com")
print(r.cookies)
for key, value in r.cookies.items():
    print(key + "=" + value) 		# 打印出cookies;

'''设置代理'''
# 当我们需要使用代理时，同样构造代理字典，传递给proxies参数
import requests
proxies = {"http": "http://10.10.1.10:3128",
           " https": "https:// 10.10.1.10:1080"}
r = requests.get("http://httpbin.org/ip", proxies=proxy)
print(r.text)

'''重定向'''
# 在网络请求中，我们常常会遇到状态码是3开头的重定向问题，在Requests中是默认开启允许重定向的，即遇到重定向时，会自动继续访问;
r = requests.get("http://github.com", allow_redirects=False)
print(r.url)
print(r.headers)
print(r.status_code)

'''禁止证书验证'''
# 有时候我们使用了抓包工具，这个时候由于抓包工具提供的证书并不是由受信任的数字证书颁发机构颁发的，所以证书的验证会失败，所以我们就需要关闭证书验证
# 在请求的时候把verify参数设置为False就可以关闭证书验证了;
r = requests.get("http://httpbin.org/post", verify=False)
但是关闭验证后，会有一个比较烦人的warning，可以使用以下方法关闭警告
from requests.packages.urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

'''设置超时'''
# 设置访问超时，设置timeout参数即可
r = requests.get("http://github.com", timeout=0.01)  # 链接和读取的时间合起来;
r = requests.get("https://www.taobao.com", timeout(5, 11, 30))  # 分别设置链接和读取的时间;
# 如果要永久等待则timeout为None，或者不加参数.

'''身份认证'''
# requests自带的身份认证功能:
import requests
from requests.auth import HTTPBasicAuth
r = requests.get("http://localhost:5000",
                 auth=HTTPBasicAuth('username', 'password'))
print(r.status_code)
# 更加简单的传参方式，直接传入一个元组
r = requests.get("http://localhost:5000", auth('username', 'password'))

'''能爬取什么样的数据'''
网页文本：如HTML文档，Json格式化文本等
图片：获取到的是二进制文件，保存为图片格式
视频: 同样是二进制文件;
其他：只要请求到的，都可以获取.

'''如何解析数据'''
直接处理
Json解析
正则表达式处理
BeautifulSoup解析处理
PyQuery解析处理
XPath解析处理.

'''关于抓取的页面数据和浏览器里看到的不一样的问题'''
出现这种情况是因为，很多网站中的数据都是通过js，ajax动态加载的，所以直接通过get请求获取的页面和浏览器显示的不同。
如何解决js渲染的问题？
分析ajax
Selenium / webdriver
Splash
PyV8, Ghost.py.

'''怎样保存数据'''
文本：纯文本，Json, Xml等
关系型数据库：如mysql, oracle, sql server等结构化数据库
非关系型数据库：MongoDB, Redis等key - value形式存储.
