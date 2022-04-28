#!/usr/bin/env python
# coding: utf-8

# # Text analysis
# 
# 
# 
# ## Feng  Li(lifeng@ccps.gov.cn)

# In[1]:


# -*- coding: utf-8 -*- 


# In[95]:


import  os
os.getcwd()


# In[96]:


os.chdir(r"C:\Users\pkuli\shanghai\data\text")


# ### 1-Input Text

# In[3]:


news = '习近平抵达捷克进行国事访问'


# In[4]:


print (news)


# In[5]:


texts = ['云南去年5800余名公职人员受处分','国务院成立山东疫苗案调查组','东北三省取消玉米临储',22222]


# In[6]:


print (texts[3])


# ## 2-Text Detection

# In[7]:


len("习近平抵达捷克进行国事访问") #length of the string 


# In[8]:


len("Hello World") #length of the string 


# In[9]:


'Alice' == "Alice "


# In[10]:


'Alice' == "alice"


# In[11]:


"That's a nice hat."


# In[12]:


print ("1\t2") #\t is tab


# In[13]:


print ("1\n2") #\n is newline


# In[14]:


print ("云南去年5800余名公职人员受处分\n国务院\t东北三省取消玉米临储") #end-line character


# ## 3-Text Computation

# In[15]:


1+2


# In[16]:


"White"+" "+"Rabbit"


# In[17]:


"alice".capitalize()


# In[18]:


print ("alice".upper())


# In[19]:


print ("ALIce".lower())


# In[20]:


"There were doors all around the hall".count('e')


# In[21]:


"There were doors all round the hall".count('all')


# In[22]:


"人民币在过去半年总是躺着中枪。英国人完成脱欧，人民币并没有太多暴露于脱欧的风险头寸，然后投资者寻求避险，人民币遭到“错杀”".count('人')


# In[23]:


print ("   White Rabbit   ".strip())
print ("\t White Rabbit  \t ".strip('\t '))


# In[24]:


"Rabbit".startswith("R")


# In[25]:


"Rabbit".endswith("t")


# In[26]:


print ("a" in "Rabbit") #returns a boolean 

print ("doors" in "There were doors all round the hall" )#returns a boolean


# ## 4-Text Data

# In[27]:


id_number={'张三':'54201','李四':'87302','王五':'32201'}


# In[28]:


print (id_number['李四'])


# In[29]:


category={}
category["苹果"]="fruit"
category["香蕉"]="fruit"
category["草莓"]="fruit"
category["土豆"]="vegetable"
category["西红柿"]="vegetable"


# In[30]:


category


# In[31]:


category["香蕉"]


# In[32]:


doc_a = "Brocolli is good to eat. My brother likes to eat good brocolli, but not my mother."
doc_b = "My mother spends a lot of time driving my brother around to baseball practice."
doc_c = "Some health experts suggest that driving may cause increased tension and blood pressure."
doc_d = "I often feel pressure to perform well at school, but my mother never seems to drive my brother to do better."
doc_e = "Health professionals say that brocolli is good for your health."

# compile sample documents into a list
doc_set = [doc_a, doc_b, doc_c, doc_d, doc_e]


# In[33]:


print (doc_set)


# ## 5-Text Reading

# In[34]:


import re
import pandas as pd
import numpy as np


# In[35]:


report= pd.read_csv('samgov1.csv',encoding="utf-8")
report.head(10)
#print report['content'][0].decode('gbk') Python2中需要进行decode显示


# In[36]:


len(report) #length of the string 


# In[37]:


report2 = pd.read_excel('sample2.xlsx')
report2.head()


# In[38]:


import codecs
text = codecs.open('lianghui17.txt', 'r', encoding='utf-8').read() 


# In[39]:


print (text)


# In[40]:


len(text) #length of the string 


# ## 6-Text Segment
# 

# In[40]:


import pandas as pd
import numpy as np
import jieba.posseg as pseg
import jieba.analyse
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.naive_bayes import GaussianNB
from sklearn.decomposition import NMF, LatentDirichletAllocation
import jieba
import matplotlib.pyplot as plt
get_ipython().run_line_magic('matplotlib', 'inline')


# In[41]:


seg_list = jieba.cut("我来到北京清华大学", cut_all=True)
print ("Full Mode:", "__".join(seg_list))  # 全模式

seg_list = jieba.cut("我来到北京清华大学", cut_all=False)
print ("Default Mode:", "   ".join(seg_list))  # 精确模式

seg_list = jieba.cut("他来到了网易杭研大厦")  # 默认是精确模式
print (", ".join(seg_list))

seg_list = jieba.cut_for_search("小明硕士毕业于中国科学院计算所，后在日本京都大学深造")  # 搜索引擎模式
print (", ".join(seg_list))


# In[42]:


words = pseg.cut("我爱北京天安门")
for word, flag in words:
    print('%s %s' % (word, flag))#词性标注


# In[43]:


result = jieba.tokenize('十动然拒是网络新词')
for tk in result:
    print("word %s\t\t start: %d \t\t end:%d" % (tk[0],tk[1],tk[2]))


# In[44]:


#添加自定义词典
#jieba.load_userdict(filename)
jieba.add_word('十动然拒')
result = jieba.tokenize('十动然拒是网络新词')
for tk in result:
    print("word %s\t\t start: %d \t\t end:%d" % (tk[0],tk[1],tk[2]))


# In[45]:


#可手动调节词典
print('/'.join(jieba.cut('如果放到post中将出错。', HMM=False)))

jieba.suggest_freq(('中', '将'), True)
print('/'.join(jieba.cut('如果放到post中将出错。', HMM=False)))

print('/'.join(jieba.cut('「台中」正确应该不会被切开', HMM=False)))

jieba.suggest_freq('台中', True)
print('/'.join(jieba.cut('「台中」正确应该不会被切开', HMM=False)))


# In[46]:


##基于 TF-idf算法的关键词抽取
#withWeight 为是否一并返回关键词权重值，默认值为 False
s = "高圆圆和赵又廷在京举行答谢宴，诸多明星现身捧场，其中包括张杰、谢娜夫妇、何炅、徐克、张凯丽等。高圆圆身穿粉色外套，看到大批记者在场露出娇羞神色，赵又廷则戴着鸭舌帽，十分淡定，两人快步走进电梯，未接受媒体采访记者了解到，出席高圆圆、赵又廷答谢宴的宾客近百人，其中不少都是女方的高中同学"
for x, w in jieba.analyse.extract_tags(s, withWeight=True):
    print('%s %s' % (x, w))
#此外，还有基于Textrank的关键词抽取办法


# In[47]:


##基于 TF-idf算法的关键词抽取
#withWeight 为是否一并返回关键词权重值，默认值为 False
s='中共中央总书记、国家主席、中央军委主席习近平近日在山东考察时强调，切实把新发展理念落到实处，不断取得高质量发展新成就，不断增强经济社会发展创新力，更好满足人民日益增长的美好生活需要。初夏的齐鲁大地，万物勃兴，生机盎然。6月12日至14日，习近平在出席上海合作组织青岛峰会后，在山东省委书记刘家义、省长龚正陪同下，先后来到青岛、威海、烟台、济南等地，深入科研院所、社区、党性教育基地、企业、农村，考察党的十九大精神贯彻落实和经济社会发展情况。'
for x, w in jieba.analyse.extract_tags(s, withWeight=True):
    print('%s %s' % (x, w))
#此外，还有基于Textrank的关键词抽取办法


# ## 7-Text Segment and wordcloud

# In[49]:


import codecs
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


# In[50]:


from wordcloud import WordCloud#部分情况需要使用whl的方式安装
#http://www.lfd.uci.edu/~gohlke/pythonlibs/#wordcloud
## pip install wordcloud-1.3.1-cp36-cp36m-win_amd64.whl
wc = WordCloud( background_color = 'white',    # 设置背景颜色
               
                max_words = 110,            # 设置最大显示的字数
                stopwords = stopwords,        # 设置停用词
                font_path = 'msyh.ttf',# 设置字体格式，如不设置显示不了中文
                max_font_size = 300,            # 设置字体最大值
                random_state = 30,            # 设置有多少种随机生成状态，即有多少种配色方案
                width=2000, height=1000)
wc.generate(text_seg)
plt.imshow(wc)
plt.axis('off')
plt.show()
wc.to_file("lianghui-b.png")


# ## 8- Text analysi with web text

# In[52]:


#!/usr/bin/python
# -*- coding:utf-8 -*-


import matplotlib.pyplot as plt
from PIL import Image
import numpy as np
from wordcloud import WordCloud
from bs4 import BeautifulSoup
import jieba
import requests


# 获取网页中的正文文本
def extract_text(url):
    page_source = requests.get(url).content
    bs_source = BeautifulSoup(page_source, "lxml")
    report_text = bs_source.find_all('p')
    text = ''
    for p in report_text:
        text += p.get_text()
        text += '\n'
    return text




# In[64]:


# 词频分析
def word_frequency(text):
    from collections import Counter
    words = [word for word in jieba.cut(text, cut_all=True) if len(word) >= 2]
    c = Counter(words)
    for word_freq in c.most_common(35):
        word, freq = word_freq
        print(word, freq)

# 生成词频
url= 'https://www.thepaper.cn/newsDetail_forward_7571327'
url= 'http://www.p5w.net/kuaixun/202010/t20201024_2469736.htm'
text= extract_text(url)
word_frequency(text)


# In[66]:


# 词云分析
words = jieba.lcut(text, cut_all=True)
exclude_words = ["我们", "提高"]##另外的方法去除部分词语
for word in words:
    if word in exclude_words:
        words.remove(word)
cuted = ' '.join(words)
path = 'msyh.ttf'

wc = WordCloud( background_color = 'white',    # 设置背景颜色
                max_words = 110,            # 设置最大显示的字数
                #stopwords = stopwords,        # 设置停用词
                font_path = path,# 设置字体格式，如不设置显示不了中文
                max_font_size = 300,            # 设置字体最大值
                random_state = 30,            # 设置有多少种随机生成状态，即有多少种配色方案
                width=2000, height=1000)
wc.generate(cuted)

# 作图
plt.figure(dpi=300)  # 通过分辨率放大或缩小图片
plt.imshow(wc)
plt.axis('off')
plt.show()


# ## 9-Topic model

# In[53]:


import os
os.getcwd()


# In[54]:


report= pd.read_csv('samgov.csv',encoding="gbk")
report.head()


# In[55]:


txt_list = []
cixing=["x","zg","uj","ul","e","d","uz","y","eng","m"]
with open("Stopword.txt",encoding="utf-8") as f:
    stopwords = f.read().splitlines()
for i, txt in enumerate(report['content']):
    result = ''
    try:
        for w in pseg.cut(txt):
                if not str(w.flag)  in cixing:
                    seg=str(w.word)
                    if seg not in stopwords:
                            result+=str(seg)+" "
        print (i)
    finally:
        pass
    txt_list.append(result)


# In[56]:


print (str(txt_list))


# In[57]:


def print_top_words(model, feature_names, n_top_words):
    for topic_idx, topic in enumerate(model.components_):
        print("Topic %d:" % topic_idx)
        print(" ".join([feature_names[i]
                        for i in topic.argsort()[:-n_top_words - 1:-1]]))
    print()


# In[58]:


data_samples=txt_list  
#自己设定主题个数
n_features = 500
n_topics = 5
n_top_words = 50


# In[59]:


from sklearn.feature_extraction.text import TfidfVectorizer,CountVectorizer
from time import time

print("Extracting tf features for LDA...")
tf_vectorizer = CountVectorizer(max_df=0.95, min_df=3, max_features=n_features,
stop_words=stopwords)
t0 = time()
tf = tf_vectorizer.fit_transform(data_samples)
print("done in %0.3fs." % (time() - t0))


# In[60]:


# Use tf-idf features for NMF.
print("Extracting tf-idf features for NMF...")
tfidf_vectorizer = TfidfVectorizer(max_df=0.95, min_df=3, stop_words=stopwords)
t0 = time()
tfidf = tfidf_vectorizer.fit_transform(data_samples)
print("done in %0.3fs." % (time() - t0))

# Use tf (raw term count) features for LDA.
print("Extracting tf features for LDA...")
tf_vectorizer = CountVectorizer(max_df=0.95, min_df=3, max_features=n_features,
stop_words=stopwords)
t0 = time()
tf = tf_vectorizer.fit_transform(data_samples)
print("done in %0.3fs." % (time() - t0))


# In[61]:


# Fit the NMF model
print("Fitting the NMF model with tf-idf features,"
        "n_features=%d..."
        % (n_features))
t0 = time()
nmf = NMF(n_components=n_topics, random_state=1, alpha=.1, l1_ratio=.5).fit(tfidf)
print("done in %0.3fs." % (time() - t0))

print("Fitting LDA models with tf features, n_features=%d..."
        % (n_features))
lda = LatentDirichletAllocation(n_topics=n_topics, max_iter=5,
learning_method='online', learning_offset=50.,random_state=0)
t0 = time()
lda.fit(tf)
print("done in %0.3fs." % (time() - t0))

print("\nTopics in LDA model")
tf_feature_names = tf_vectorizer.get_feature_names()
print_top_words(lda, tf_feature_names, n_top_words)


# ## 10-随机森林-有监督

# In[71]:


import pandas as pd

df = pd.read_csv('C:\\Users\\pkuli\\shanghai\\data\\parkinsons.data')
print(df.head())


# In[93]:


df['status']


# In[81]:


X = df.drop('status', axis=1)
X = X.drop('name', axis=1)
y = df['status']


# In[82]:


from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=1)#将数据库随机分为训练集和测试集


# In[83]:


from sklearn.ensemble import RandomForestClassifier

random_forest = RandomForestClassifier(n_estimators=30, max_depth=10, random_state=1)


# In[86]:


random_forest.fit(X_train, y_train)


# In[89]:





# In[92]:



from sklearn.metrics import accuracy_score
##评估模型
y_predict = random_forest.predict(X_test)
y_predict


# In[ ]:


accuracy_score(y_test, y_predict)
from sklearn.metrics import confusion_matrix

pd.DataFrame(
    confusion_matrix(y_test, y_predict),
    columns=['Predicted Healthy', 'Predicted Parkinsons'],
    index=['True Healthy', 'True Parkinsons']
)


# In[72]:


import numpy as np
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.ensemble import RandomForestClassifier
from sklearn import datasets


# In[75]:


corpus = ["The apple is on sale","The oranges in on sale","The apple and is present","The orange and is present"]


# In[76]:


Y = np.array([1,2,1,2])


# In[77]:


#词袋模型
vectorizer = CountVectorizer(min_df=1)
X = vectorizer.fit_transform(corpus).toarray()


# In[80]:


clf = RandomForestClassifier()
clf.fit(X, Y)
clf.predict(vectorizer.transform(['apple is bad']).toarray())


# In[ ]:




