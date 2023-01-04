# wordcloud中文应用实例
import os
import jieba
from wordcloud import WordCloud
os.getcwd()
os.chdir("/Users/zhulu/Files/MyGit/python/society")
txt = "三是坚持以人民为中心的发展思想。推进跨区域立案诉讼服务改革，\
    优化网上诉讼服务功能，构建物理零距离、网络全时空、交流无障碍的诉讼\
    服务体系。创新发展新时代“枫桥经验”，完善调解、仲裁、诉讼等有机衔接、\
    相互协调的多元化纠纷解决体系，促进共建共治共享社会治理格局建设。\
    认真落实依法治国和以德治国相结合要求，通过审判树立规则导向，\
    让遵法守纪者扬眉吐气，让违法失德者寸步难行。"
w = wordcloud.WordCloud(width=1000,font_path="/System/Library/Fonts/Supplemental/Songti.ttc", height=700)
w.generate(" ".join(jieba.lcut(txt)))#以空格分隔，统计txt中各单词出现的次数。
w.to_file("zhongwen.png")

#政府工作报告词云
from scipy.misc import imread
mask = imread("ditu1.jpg")
f = open("zhengfubaogao.txt","r",encoding="utf-8")
t=f.read()
f.close()
ls = jieba.lcut(t)
txt = " ".join(ls)
w = wordcloud.WordCloud(width=1000,font_path="/System/Library/Fonts/Supplemental/Songti.ttc",\
    height=700,background_color="white",mask=mask)
w.generate(txt)
w.to_file("zhengfubaogao2.png")

# 自创区政策：
import os
import pandas as pd
import numpy as np
import jieba.posseg as pseg
import jieba.analyse
import jieba
import matplotlib.pyplot as plt
import codecs
os.chdir("/Users/zhulu/Files/data/郑大/自创区文本")
os.listdir()
# 定义停止词：
with open("Stopword.txt",encoding="utf-8") as f:
    stopwords = f.read().splitlines()
# 读取文本：
text = codecs.open('lianghui17.txt', 'r', encoding='utf-8').read() 
seg = [word for word in jieba.cut(text)
                if (word.isalnum())           # Only selecting words that are composed by letters and numbers (exclude marks)
                and (not word.isnumeric())    # Exclude numbers
                and (word not in stopwords)]  # 
text_seg=  '\\'.join(seg)
with codecs.open('lianghui17-seg.txt', 'w', 'utf-8') as f:
    f.write(text_seg)

from wordcloud import WordCloud#部分情况需要使用whl的方式安装
#http://www.lfd.uci.edu/~gohlke/pythonlibs/#wordcloud
## pip install wordcloud-1.3.1-cp36-cp36m-win_amd64.whl
wc = WordCloud( background_color = 'black',    # 设置背景颜色
                max_words = 110,            # 设置最大显示的字数
                stopwords = stopwords,        # 设置停用词
                font_path="/System/Library/Fonts/Supplemental/Songti.ttc",# 设置字体格式，如不设置显示不了中文
                max_font_size = 300,            # 设置字体最大值
                random_state = 30,            # 设置有多少种随机生成状态，即有多少种配色方案
                width=2000, height=1000)

wc.generate(text)
plt.imshow(wc)
plt.axis('off')
plt.show()
wc.to_file("lianghui-b.png")