import pandas as pd
import os
import codecs
import jieba
import jieba.analyse
os.getcwd()
os.chdir(r'E:\Mydata\hudata')
os.getcwd()

# 读入excel数据：
df1 = pd.read_excel(r'E:\学术论文\Data\subsidy&innovation\csmar\FN_Fn056.xlsx')
df2 = df1[0:500] # 不能直接筛选源数据，提取出一部分用来尝试；
df2
df2.to_excel(r'E:\学术论文\Data\subsidy&innovation\csmar\sample.xlsx')
df = pd.read_excel('sample.xlsx')
df

# 制作“创新”类关键词文本数据：
# 读入要匹配的关键词文本数据：
with open("stopwords.txt",encoding="utf-8") as f:
    stopwords = f.read()
text = codecs.open('words.txt', 'r', encoding='utf-8').read() 
seg = [word for word in jieba.cut(text,cut_all = False)
                if (word.isalnum())  # Only selecting words that are composed by letters and numbers (exclude marks)
                and (word not in stopwords)]  # 
# seg为列表，有重复元素，先转化为集合再转化为列表的方式去重：
seg1 = list(set(seg))
seg1
len(seg)
len(seg1)
text_seg=  '|'.join(seg1)
text_seg
with codecs.open('innovation_seg.txt', 'w', 'utf-8') as f:
    f.write(text_seg)
# 关键词文件为innovation_seg.txt

#################################################################
# 开始匹配：
df = pd.read_excel('FN_FN056.xlsx')
with open("innovation_seg.txt",encoding="utf-8") as f:
    seg = f.read()
seg
# 识别补助列；
mask1 = df['Fn05601'].str.contains(seg,na = False)
mask1
df['subsidy1']=mask1[:]
# 识别备注列；
mask2 = df['Fnother'].str.contains(seg,na = False)
mask2
df['subsidy2']=mask2[:]
df.to_excel('inno_sub.xlsx')




'''学习代码'''
import jieba
seg_list = jieba.cut("我来到北京清华大学", cut_all=True)
print(seg_list)
print ("Full Mode:", "|".join(seg_list)) 

import codecs
import os
os.getcwd()
os.chdir(r'E:\MyGit\jupyter')
os.getcwd()
#define stopword and wordseg
with open("Stopword.txt",encoding="utf-8") as f:
    stopwords = f.read().splitlines()
text = codecs.open('lianghui17.txt', 'r', encoding='utf-8').read() 
seg = [word for word in jieba.cut(text)
                if (word.isalnum())  # Only selecting words that are composed by letters and numbers (exclude marks)
                and (not word.isnumeric())  # Exclude numbers
                and (word not in stopwords)]  # 
text_seg=  ' '.join(seg)
with codecs.open('lianghui17-seg.txt', 'w', 'utf-8') as f:
    f.write(text_seg)

