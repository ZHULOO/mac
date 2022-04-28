# -*- coding: utf-8 -*-
"""
Created on Sat Oct 24 20:25:39 2020

@author: wxn
"""

from urllib.request import urlopen

resp = urlopen('http://www.baidu.com')
print (resp.getcode())#200 代表正常，500 服务器出错，400 请求参数异常
print(resp.geturl())#打印出发起访问百度url
print(resp.info())#打印返回头部信息

content = resp.read().decode("utf-8")#打印首页内容赋值给变量content

print(content)