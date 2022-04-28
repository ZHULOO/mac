# -*- coding: utf-8 -*-
"""
Created on Sat Jan 15 17:43:56 2022

@author: ZHULOO
@email: zhuloo@126.com
"""
##############################1.1 创建一个新的excel##########################
import os
import xlwings as xw
os.getcwd()
# 方法1：
# 创建一个新的App，并在新App中新建一个Book
wb = xw.Book()          # 打开一个新excel
wb.save('1.xlsx')       # 保存到当前目录下
wb.close()              # 关闭excel
​
# 方法2：
# 当前App下新建一个Book
# visible参数控制创建文件时可见的属性
app=xw.App(visible=True,add_book=False)
wb=app.books.add()
wb.save('2.xlsx')
wb.close()
#结束进程
app.quit()
# os.system("del 3.xlsx")
# os.system("start .")

############################1.2 打开已有的Excel文件##############################
app=xw.App(visible=True,add_book=False)
#不显示Excel消息框
app.display_alerts=False 
#关闭屏幕更新,可加快宏的执行速度
app.screen_updating=False  
wb=app.books.open('1.xlsx')
# 输出打开的excle的绝对路径
print(wb.fullname)
wb.save()
wb.close()
# 退出excel程序，
app.quit()
# 通过杀掉进程强制Excel app退出
​# app.kill() 
# 以第一种方式创建Book时，打开文件的操作可如下
wb = xw.Book('1.xlsx')

# （1）每个App对应一个PID值，这个PID值可以认为是一个标签，用来识别不同的App。
# （2）创建工作簿之前要先创建App: app=xw.App(visible=Ture,add_book=False)
# （3）通过xlwings可以创建多个App，每个App又可以创建多个工作簿，每一个工作簿中又可 以创建多
#  个Sheet。
# （4）需要注意的是这些App之间是相互独立的，也就是操作不同的工作簿的时候就要找到对 应的App。
#  建议使用：xw.Book('filename.xlsx') 来打开工作薄或引用工作簿，不容易出错

#############################1.3. 读入和写入值#############################

# 在A1单元格写入值
# 实例化一个工作表对象
wb = xw.Book('1.xlsx')
sheet1 = wb.sheets["sheet1"]
# 或者
sheet1 =xw.books['1.xlsx'].sheets['sheet1']
# 输出工作簿名称
print(sheet1.name)
# 写入值
sheet1.range('A1').value = 'python知识学堂'
# 读值并打印
print('value of A1:',sheet1.range('A1').value)
# 清空单元格内容,如果A1中是图片，此方法没有效果
sheet1.range('A1').clear()
# 传入列表写入多行值
sheet1.range('A1').value = [['a','b','c'],[1,2,3]]

# 当然也可以将pandas的DataFrame数据写入
import pandas as pd
df = pd.DataFrame([[1,2], [3,4]], columns=['A', 'B'])
sheet1.range('A1').value = df
# 读取数据，输出类型为DataFrame
sheet1.range('A1').options(pd.DataFrame, expand='table').value


# 支持添加图片的操作
import numpy as np
import matplotlib.pyplot as plt
fig = plt.figure()
x = np.arange(20)
plt.plot(x, np.log(x))
sheet1.pictures.add(fig, name='MyPlot', update=True) # 上面同时运行才可以插入图片

n =65
n = chr(n)   # ASCII字符
pos = '%s%d' % (n, 1)
print(pos)   #A1

##############################1.4. 活动对象#################################
























