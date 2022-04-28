### pandas 中str.contains()的用法：
import pandas as pd
import numpy as np
import re

df1 = pd.DataFrame({'col': ['foo', 'foobar', 'bar', 'baz']})
df1
df1['col'].str.contains('foo')      # 根据筛选条件生成一个对应的bool型列，包含'foo'则显示true，否则显示为false；
df1[df1['col'].str.contains('foo')] # 筛选出显示true位置上的数据；
df1[df1['col'].str.contains(r'foo(?!$)')] # 筛选条件也可以是正则表达式；
df1[df1['col'].str.contains(r'foo(?!$)',regex=False)] # 一般筛选正则表达式的内容，也可以自行取消正则表达式搜索的功能；

### 性能方面，正则表达式搜索比子字符串搜索要慢；
import timeit
df2 = pd.concat([df1] * 1000,ignore_index = True) # 将df1倍增1000遍；
df2
%timeit df2[df2['col'].str.contains('foo')]
%timeit df2[df2['col'].str.contains('foo', regex=False)] # 这两行语句是运行在ipython交互模式下，测试两行语句的执行时间，可以看到上面默认使用正则表达式搜索，更加费时，而下面关闭掉正则搜索模式，程序更节省时间。
# 一般情况下建议关掉正则表达式搜索模式，regex = False;

### 存在缺失值的情况下,直接搜索会出现错误：
s = pd.Series(['foo', 'foobar', np.nan, 'bar', 'baz', 123])
s.str.contains('foo|bar')
s[s.str.contains('foo|bar')] # 由于s里面包含了NaN缺失项，所以会出现错误，应该使用：
s[s.str.contains('foo|bar',na = False)]
# 使用mask：
mask = s.str.contains('foo|bar')
mask1 = s.str.contains('foo|bar',na = False)
s[mask] # 由于s里面包含了NaN缺失项，所以会出现错误，应该使用：
s[mask1]

### 多个子字符串的搜索：可以通过正则表达式或管道的方式搜索
df4 = pd.DataFrame({'col': ['foo abc', 'foobar xyz', 'bar32', 'baz 45']})
df4
df4[df4['col'].str.contains(r'foo|baz')]
# 或者通过一个列表，将关键词连接起来：
terms = ['foo', 'baz']
df4[df4['col'].str.contains('|'.join(terms))]
# 有时，明智的做法是对术语进行转义，以防它们含有可能被解释为regex元字符的字符。如果您的子字符串包含以下任何字符：. ^ $ * + ? { } [ ] \ | ( )
import re
s1 = '|'.join(map(re.escape, terms)) # re.escape具有对特殊字符进行转义的效果，这样它们就可以按字面意思处理了。
re.escape(r'.foo^') # 表示按表面意思处理，不在转义里面的字符；
s1
df4[df4['col'].str.contains('|'.join(map(re.escape, terms)))]

### 匹配完整的单词 例如：blue表示一个完整的单词，而后面的bluejay匹配出的blue就不是一个完整的单词：
# 默认情况下，子字符串搜索将搜索指定的子字符串，而不管它是否是完整的单词。
# 为了只匹配完整的单词，我们需要在这里使用正则表达式，我们的模式需要指定单词边界(\b)。
df3 = pd.DataFrame({'col': ['the sky is blue', 'bluejay by the window']})
df3
df3[df3['col'].str.contains(r'\bblue\b')] # 只匹配出包含blue完整单词的项；
df3[df3['col'].str.contains('blue')]

### 多个完整词搜索与上面类似，只是我们将单词边界(\b)添加到连接的模式中。
p = r'\b(?:{})\b'.format('|'.join(map(re.escape, terms)))
df4[df4['col'].str.contains(p)]

### 列表解析式搜索：
df1[df1['col'].str.contains('foo', regex=False)] # 等价于：
df1[['foo' in x for x in df1['col']]]

### 也可以使用以下正则表达式方式：
regex_pattern = r'foo(?!$)'
df1[df1['col'].str.contains(regex_pattern)]
p = re.compile(regex_pattern, flags=re.IGNORECASE)
df1[[bool(p.search(x)) for x in df1['col']]]

### 其它字符串匹配方法：
# np.char.find()
df4[np.char.find(df4['col'].values.astype(str), 'foo') > -1]

# np.vectorize()
f = np.vectorize(lambda haystack, needle: needle in haystack)
f(df1['col'], 'foo')
# array([ True,  True, False, False])
df1[f(df1['col'], 'foo')]

# 正则表达式：
regex_pattern = r'foo(?!$)'
p = re.compile(regex_pattern)
f = np.vectorize(lambda x: pd.notna(x) and bool(p.search(x)))
df1[f(df1['col'])]

# DataFrame.query
df1.query('col.str.contains("foo")', engine='python')

# Recommended Usage Precedence,使用优先级
'''
1.(First) str.contains, for its simplicity and ease handling NaNs and mixed data
2.List comprehensions, for its performance (especially if your data is purely strings)
3.np.vectorize
4.(Last) df.query
'''






# 语句计时使用
import timeit
def add(x,y):
    return x + y
a = '1'
b = '2'
timeit.timeit('add(a,b)', 'from __main__ import add, a, b')

a = 1
b = 2
timeit.timeit('add(a,b)', 'from __main__ import add, a, b')




# 第二版最新答案：
# 第一版答案用于遍历DataFrame是否含有关键词。但是，如果我们只需要查询一列数据是否含有目标关键词的话，如下更快捷：
# 第一种情况：筛选一个目标关键词
mask = df['目标列的名称'].str.contains('目标关键词')
selected_data = df[mask]

## 第二种情况：筛选n个目标关键词
List = ['key_w1', ..., 'key_wn']
mask = df['目标列的名称'].str.contains('|'.join(List))
selected_data = df[mask]


## 第一版答案：
# 从stackoverflow学来的答案；https://stackoverflow.com/questions/51045207/pandas-select-rows-if-keyword-appears-in-any-column

import pandas as pd

def select_data():
    df = pd.read_csv('路径+文件名.csv', encoding='gbk', low_memory=False)
    mask = df.select_dtype(include=[object]).stack().str.contains('中国移动').unstack()        # 最快
    # mask = df.select_dtypes(include=[object]).apply(lambda x: x.str.contains('中国移动', na=False))
    # mask = df.select_dtypes(include=[object]).applymap(lambda x: '中国移动' in x if pd.notnull(x) else False)   # 最慢
    selected_data = df[mask.any(axis=1)]
    selected_data.to_csv('路径+新文件名.csv', encoding='bgk)
    
if __name__ = '__main__':
    select_data()
    print('done')


# stack:多列堆叠为一列，处理后再还原unstack：
df = pd.DataFrame({'vals': [1, 2, 3, 4], 'ids': [u'aball', u'bball', u'cnut', u'fball'],'id2': [u'uball', u'mball', u'pnut', u'zball']})
df[df['ids'].str.contains("ball")]
mask = df.select_dtypes(include=[object]).stack().str.contains('ball').unstack()

# applymap
df = pd.DataFrame({'vals': [1, 2, 3, 4], 
                   'ids': [None, u'bball', u'cnut', u'fball'],
                   'id2': [u'uball', u'mball', u'pnut', u'zball']})
print (df)
   vals    ids    id2
0     1   None  uball
1     2  bball  mball
2     3   cnut   pnut
3     4  fball  zball

mask = df.select_dtypes(include=[object]).applymap(lambda x: 'ball' in x if pd.notnull(x) else False)
#if always non NaNs, no Nones
#mask = df.select_dtypes(include=[object]).applymap(lambda x: 'ball' in x)
print (mask)

mask = df.select_dtypes(include=[object]).apply(lambda x: x.str.contains('ball', na=False))
#if always non NaNs, no Nones
#mask = df.select_dtypes(include=[object]).apply(lambda x: x.str.contains('ball'))
print (mask)
df1 = df[mask.any(axis=1)]
df2 = df[mask.all(axis=1)]

# 
df = pd.DataFrame({'vals': [1, 2, 3, 4, 5], 'ids': [u'aball', u'bball', u'cnut', u'fball', 'ballxyz']})
df
df.set_index('ids').filter(like='ball', axis=0)
df.set_index('ids').filter(regex='ball$', axis=0)