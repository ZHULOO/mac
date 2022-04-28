import pandas as pd
import os
os.chdir(r"E:\BaiduNetdiskWorkspace\郑大")
data = pd.read_excel("结果.xlsx")


import chardet#打开其中一个csv文件，查看其编码格式
f = open('结果.xlsx','rb')
data = f.read()
print(chardet.detect(data)['encoding'])
f.close()