###########################爬取前10页微博##############################
import requests
from urllib.parse import urlencode
from pyquery import PyQuery as pq
# from pymongo import MongoClient

base_url = 'https://m.weibo.cn/api/container/getIndex?'
headers = {
    'Host': 'm.weibo.cn',
    'Referer': 'https://m.weibo.cn/u/2830678474',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36',
    'X-Requested-With': 'XMLHttpRequest',
}
# client = MongoClient()
# db = client['weibo']
# collection = db['weibo']
max_page = 10
# pages参数变为了since_id，需要做如下修改：
"""
首先，我观察几次的ajax的url，并没有发现什么规律：
Request URL:https://m.weibo.cn/api/container/getIndex?type=uid&value=2830678474&containerid=1076032830678474&since_id=4464249252756977
每次都不一样，而且毫无规律可循。就在想他们是怎么通过本次的请求得到下次的since_id的，肯定是哪传递了这个参数仔细观察，发现since_id实际上是本次刷新出来的最开始的那条微博的id，再仔细观察几个xhr之间的关系，发现每次的xhr的preview里的.data.cardlistInfo里有一个since_id，而这个since_id正好是下一次url里的since_id，也就是下一次的第一条微博的id。而第一次的xhr的url里并没有since_id，因为他是第一个。（实际上仔细看书会发现新浪就是把page换成了since_id，位置都没变，其他参数也都没变）
得到了以上信息，我们就可以在原始代码上进行修改。
def get_page(since_id):
    params = {
    'type': 'uid',
    'value': '2830678474',
    'containerid': '1076032830678474'
    }
    if since_id!=0:
        params['since_id'] = since_id

# main作如下修改：（省略部分保持不变）
    if name == 'main':
        since_id = 0
    for page in range(1, max_page + 1):
        json = get_page(since_id)
        since_id = json.get('data').get('cardlistInfo').get('since_id')
"""

def get_page(since_id):
    params = {
    'type': 'uid',
    'value': '2830678474',
    'containerid': '1076032830678474'
    }
    if since_id!=0:
        params['since_id'] = since_id
    url = base_url + urlencode(params)
    try:
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            return response.json(), page
    except requests.ConnectionError as e:
        print('Error', e.args)


def parse_page(json, page: int):
    if json:
        items = json.get('data').get('cards')
        for index, item in enumerate(items):
            if page == 1 and index == 1:
                continue
            else:
                item = item.get('mblog', {})
                weibo = {}
                weibo['id'] = item.get('id')
                weibo['text'] = pq(item.get('text')).text()
                weibo['attitudes'] = item.get('attitudes_count')
                weibo['comments'] = item.get('comments_count')
                weibo['reposts'] = item.get('reposts_count')
                yield weibo


# def save_to_mongo(result):
#     if collection.insert(result):
#         print('Saved to Mongo')


if __name__ == '__main__':
    # since_id = 0 # 第一页没有since_id
    for since_id in range(0, max_page + 1):
        json = get_page(since_id)
        since_id = json[0].get('data').get('cardlistInfo').get('since_id')
        results = parse_page(*json)
        for result in results:
            print(result)
            # save_to_mongo(result)

"""尝试
since_id = 4589265352136530

params = {
'type': 'uid',
'value': '2830678474',
'containerid': '1076032830678474'
}
if since_id!=0:
    params['since_id'] = since_id
url = base_url + urlencode(params)

json = get_page(since_id)
since_id1 = json[0].get('data').get('cardlistInfo').get('since_id')
since_id1
"""

##########################爬取今日头条搜索"街拍"图片################################
# 加载单个Ajax请求:
import requests
from urllib.parse import urlencode
def get_page(offset):
    params = {
        'aid': '24',
        'app_name': 'web_search',
        'offset': offset,
        'format': 'json',
        'keyword': '%E8%A1%97%E6%8B%8D',
        'autoload': 'true',
        'count': '20',
        'en_qc': '1',
        'cur_tab': '1',
        'from': 'search_tab',
        'pd': 'synthesis',
    }
    url = 'https://www.toutiao.com/api/search/content/?' + urlencode(params)
    headers = {
        'user-agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36',
        'cookie':'tt_webid=6779219984990275085; WEATHER_CITY=%E5%8C%97%E4%BA%AC; tt_webid=6779219984990275085; csrftoken=20b1aed340ed3189c2c15901e05f1be7; __tasessionId=ua2g0049f1578535249804; s_v_web_id=de29434c46037ab0156315303f0d5a41'
    }
    try:
        response = requests.get(url,headers=headers)
        if response.status_code == 200:
            return response.json()
    except requests.ConnectionError:
        return None
# 获取每张图片的链接和标题:
def get_images(json):
    if json.get('data'):
        for item in json.get('data'):
            title = item.get('title')
            images = item.get('image_list')
            for image in images:
                yield {
                    'image':image.get('url'),
                    'title':title
                }
# 保存每一个链接对应的图片:
import os 
from hashlib import md5

def save_image(item):
    if not os.path.exists(item.get('title')):
        os.mkdir(item.get('title'))
    try:
        response = requests.get(item.get('image'),headers=headers)
        if response.status_code == 200:
            file_path = '{0}/{1}.{2}'.format(item.get('title'),md5(response.content).hexdigest(),'jpg')
            if not os.path.exists(file_path):
                with open(file_path,'wb') as f:
                    f.write(response.content)
            else:
                print('Already Download',file_path)
    except requests.ConnectionError:
        print('Failed to Save Image')

# 构造一个offset数组,遍历offset将其下载:
from multiprocessing.pool import Pool #多进程的进程池,调用map方法实现多进程下载;
def main(offset):
    json = get_page(offset)
    for item in get_images(json):
        print(item)
        save_image(item)

main(20)


offset = 20
json = get_page(offset)
items = json.get('data')
title = []
images = []
for item in items:
    title.append(item.get('title'))
    images.append(item.get('image_list'))

title
images



images = get_images(json)




for item in json.get('data'):
    title = item.get('title')
    images = item.get('image_list')



items = get_images(json)
for item in items:
    print(item)
    save_image(item)




GROUP_START = 1
GROUP_END = 20


pool = Pool()
groups = ([x*20 for x in range(GROUP_START,GROUP_END+1)])
pool.map(main,groups)
pool.close()
pool.join()













'''
params = {
    'aid': '24',
    'app_name': 'web_search',
    'offset': 'offset',
    'format': 'json',
    'keyword': '%E8%A1%97%E6%8B%8D',
    'autoload': 'true',
    'count': '20',
    'en_qc': '1',
    'cur_tab': '1',
    'from': 'search_tab',
    'pd': 'synthesis',
}
url = 'https://www.toutiao.com/api/search/content/?' + urlencode(params)
# https://www.toutiao.com/api/search/content/?aid=24&app_name=web_search&offset=offset&format=json&keyword=%25E8%25A1%2597%25E6%258B%258D&autoload=true&count=20&en_qc=1&cur_tab=1&from=search_tab&pd=synthesis

groups = ([x*20 for x in range(GROUP_START,GROUP_END+1)])
'''


