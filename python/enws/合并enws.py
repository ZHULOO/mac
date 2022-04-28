import os
import os.path #文件夹遍历函数
os.getcwd()
os.chdir(r"E:\atom_github\python\enws")
#获取目标文件夹的路径
filedir = os.getcwd()
#获取当前文件夹中的文件名称列表
filenames=os.listdir(filedir)
#打开当前目录下的result.txt文件，如果没有则创建，编码为utf-8模式；

# 一种方法：
f=open('result.txt','w',encoding='utf-8')
#先遍历文件名
for filename in filenames:
    filepath = filedir+'/'+filename
    #遍历单个文件，读取行数
    for line in open(filepath,encoding = 'utf-8'):
        f.writelines(line)
    f.write('\n')
#关闭文件
f.close()

# 另一种方法：

with open('result.txt','w',encoding='utf-8') as f:      # 创建并打开一个名为result.txt的文件，已存在则覆盖；
    for filename in filenames:                          # 先遍历各txt；
        filepath = filedir+'/'+filename                 # 获取每一个txt文档的绝对路径；
        with open(filepath,encoding = 'utf-8') as txt:  # 根据获取的每一个txt文档路径，打开它们；
            for line in txt:                            # 遍历文档的每一行，逐行写入上面新建的result.txt文档；
                f.writelines(line)
            f.write('\n')                               # 写完每一个文档插入一个空行；
