'''
import re
import requests
from pathlib import Path
from time import time, perf_counter
from fake_useragent import UserAgent
 
 
def download_file_from_url(dl_url, file_name, headers):
    file_path = Path(__file__).parent.joinpath(file_name)
    if file_path.exists():
        dl_size = file_path.stat().st_size
    else:
        dl_size = 0
 
    headers['Range'] = f'bytes={dl_size}-'
    response = requests.get(dl_url, stream=True, headers=headers)
 
    print('\n\n' + '*' * 30 + '下载信息' + '*' * 30)
    total_size = int(response.headers['content-length'])
    print(
        f'\n\n文件名称:{file_name}\t\t已下载文件大小:{dl_size / 1024 / 1024:.2f}M\t\t文件总大小:{total_size/1024/1024:.2f}M\n\n')
    start = perf_counter()
 
    data_count = 0
    count_tmp = 0
    start_time = time()
    with open(file_path, 'ab') as fp:
        for chunk in response.iter_content(chunk_size=512):
            data_count += len(chunk)
            now_pross = (data_count / total_size) * 100
            mid_time = time()
            if mid_time - start_time > 0.1:
                speed = (data_count - count_tmp) / 1024 / (mid_time - start_time)
                start_time = mid_time
                count_tmp = data_count
                print(
                    f"\rDownloading.........{now_pross:.2f}%\t{data_count//1024}Kb/{total_size//1024}Kb\t当前下载速度:{speed:.2f}Kb/s", end='')
            fp.write(chunk)
    
    end = perf_counter()
    diff = end - start
    speed = total_size/1024/diff
 
    print(
        f'\n\n下载完成!耗时:{diff:.2f}秒,  平均下载速度:{speed:.2f}Kb/s!\n文件路径:{file_path}\n')
 
 
if __name__ == '__main__':
    url = 'https://www.stata.com/support/updates/stata16/stata16update_win.zip'
    filename = url.rpartition('/')[-1]
    headers = {
        'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36',
        'cookie':'st_site_nom=111.60.76.5.1562291962589584; _ga=GA1.2.754361509.1562292043; _fbp=fb.1.1563097746717.916549028; __utma=127029199.754361509.1562292043.1563422544.1567847678.3; __utmz=127029199.1567847678.3.2.utmcsr=baidu|utmccn=(organic)|utmcmd=organic; comm100_visitorguid_219216=bee6f140-b703-4a56-a00d-50acf3ad4790; gwcc=%7B%22fallback%22%3A%2219796964600%22%2C%22clabel%22%3A%22eQYsCI7H1HUQ_dbk1QM%22%2C%22backoff%22%3A86400%2C%22backoff_expires%22%3A1568716359%7D; frontend=6he055bmm0d8atpk31md024907; frontend_cid=CHFySr90v2zaiobA'}
    download_file_from_url(url, filename, headers)

'''
from concurrent.futures import ThreadPoolExecutor, wait
from threading import Lock
from requests import get, head
lock = Lock()

class Downloader():
    def __init__(self, url, nums, file):
        self.url = url
        self.num = nums
        self.name = file
        r = head(self.url)
        # 若资源显示302,则迭代找寻源文件
        while r.status_code == 302:
            self.url = r.headers['Location']
            print("该url已重定向至{}".format(self.url))
            r = head(self.url)
        self.size = int(r.headers['Content-Length'])
        print('该文件大小为：{} bytes'.format(self.size))

    def down(self, start, end):
        headers = {'Range': 'bytes={}-{}'.format(start, end)}
        # stream = True 下载的数据不会保存在内存中
        r = get(self.url, headers=headers, stream=True)
        # 写入文件对应位置,加入文件锁
        lock.acquire()
        with open(self.name, "rb+") as fp:
            fp.seek(start)
            fp.write(r.content)
            lock.release()
            # 释放锁

    def run(self):
        # 创建一个和要下载文件一样大小的文件
        fp = open(self.name, "wb")
        fp.truncate(self.size)
        fp.close()
        # 启动多线程写文件
        part = self.size // self.num
        pool = ThreadPoolExecutor(max_workers=self.num)
        futures = []
        for i in range(self.num):
            start = part * i
            # 最后一块
            if i == self.num - 1:
                end = self.size - 1
            else:
                end = start + part - 1
                print('{}->{}'.format(start, end))
            futures.append(pool.submit(self.down, start, end))
        wait(futures)
        print('%s 下载完成' % self.name)

ss =  Downloader('https://www.stata.com/support/updates/stata16/stata16update_win.zip',6, "win.zip")
ss.run()