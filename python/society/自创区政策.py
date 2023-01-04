import os
import pandas as pd
import numpy as np
import jieba.posseg as pseg
import jieba.analyse
import jieba
import matplotlib.pyplot as plt
import codecs
os.getcwd()
os.chdir("/Users/zhulu/Files/data/郑大/自创区文本")
os.system("open .")

### 词云
# 停用词
with open("/Users/zhulu/Files/MyGit/python/society/china_stopwords.txt",encoding="utf-8") as f:
    stopwords = f.read().splitlines()

# 打开文本:“十四五”时期中关村国家自主创新示范区发展建设规划.txt
text = codecs.open('“十四五”时期中关村国家自主创新示范区发展建设规划.txt', 'r', encoding='gb18030').read() 
seg = [word for word in jieba.cut(text)
                if (word.isalnum())  # Only selecting words that are composed by letters and numbers (exclude marks)
                and (not word.isnumeric())  # Exclude numbers
                and (word not in stopwords)]  # 
text_seg=  '\\'.join(seg)
with codecs.open('“十四五”时期中关村国家自主创新示范区发展建设规划-seg.txt', 'w', 'utf-8') as f:
    f.write(text_seg)

# 画词云图
from wordcloud import WordCloud
wc = WordCloud( background_color = 'white',     # 设置背景颜色
                max_words = 110,                # 设置最大显示的字数
                stopwords = stopwords,          # 设置停用词
                font_path="/System/Library/Fonts/Supplemental/Songti.ttc",# 设置字体格式，如不设置显示不了中文
                max_font_size = 300,            # 设置字体最大值
                random_state = 30,              # 设置有多少种随机生成状态，即有多少种配色方案
                width=2000, height=1000)
wc.generate(text_seg)
plt.imshow(wc)
plt.axis('off')
plt.show()
wc.to_file("“十四五”时期中关村国家自主创新示范区发展建设规划.png")

### 自定义函数：自己选择停用词字典和目标文本，画出词云
def text_cloud(name, encode):
    with open("/Users/zhulu/Files/MyGit/python/society/china_stopwords.txt",encoding="utf-8") as f:
        stopwords = f.read().splitlines() # 读取停用词
    # 打开文本:“十四五”时期中关村国家自主创新示范区发展建设规划.txt
    text = codecs.open('%s.txt'%(name), 'r', encoding='%s'%(encode)).read() 
    seg = [word for word in jieba.cut(text)
                    if (word.isalnum())  # Only selecting words that are composed by letters and numbers (exclude marks)
                    and (not word.isnumeric())  # Exclude numbers
                    and (word not in stopwords)]  # 
    text_seg=  '\\'.join(seg)
    with codecs.open('%s-seg.txt'%(name), 'w', 'utf-8') as f:
        f.write(text_seg)
    # 画词云图
    from wordcloud import WordCloud
    wc = WordCloud( background_color = 'white',     # 设置背景颜色
                    max_words = 110,                # 设置最大显示的字数
                    stopwords = stopwords,          # 设置停用词
                    font_path="/System/Library/Fonts/Supplemental/Songti.ttc", # 设置字体格式，如不设置显示不了中文
                    max_font_size = 300,            # 设置字体最大值
                    random_state = 30,              # 设置有多少种随机生成状态，即有多少种配色方案
                    width=2000, height=1000)
    wc.generate(text_seg)
    plt.imshow(wc)
    plt.axis('off')
    # plt.show()
    wc.to_file("%s.png"%(name))

os.listdir()
text_cloud("“十四五”时期中关村国家自主创新示范区发展建设规划", "gb18030")
text_cloud("东湖国家自主创新示范区发展规划纲要（2011-2020年）", "gb18030")
text_cloud("中关村国家自主创新示范区发展规划纲要（2011-2020年）", "gb18030")
text_cloud("长株潭国家自主创新示范区发展规划纲要（2015-2025年）", "gb18030")
text_cloud("上海张江国家自主创新示范区发展规划纲要（2013-2020年）", "gb18030")
text_cloud("苏南国家自主创新示范区发展规划纲要", "gb18030")
text_cloud("天津国家自主创新示范区发展规划纲要", "gb18030")

## 词频
# #基于 TF-idf算法的关键词抽取
#withWeight 为是否一并返回关键词权重值，默认值为 False
for x, w in jieba.analyse.extract_tags(text_seg, withWeight=True):
    print('%s %s' % (x, w))
#此外，还有基于Textrank的关键词抽取办法
for x, w in jieba.analyse.extract_tags(text, withWeight=True):
    print('%s %s' % (x, w))


import collections
word_counts = collections.Counter(seg)
word_counts
word_counts_top10 = word_counts.most_common(10)
word_counts_top10

### 读取所有文本内容，写入excel
