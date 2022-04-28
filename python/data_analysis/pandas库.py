import numpy as np
import pandas as pd
'''Pandas 的目标是成为 Python 数据分析实践与实战的必备高级工具，其长远目标是成为最强大、最灵活、可以支持任何语言的开源数据分析工具。'''

'''IO工具'''
# 所有的readers函数和writer函数:
'''
Format Type	       Data Description	      Reader             Writer
text	              CSV	                  read_csv	      to_csv
text	              JSON	            read_json	      to_json
text	              HTML	            read_html	      to_html
text	              Local clipboard	      read_clipboard	to_clipboard
binary	        MS Excel	            read_excel	      to_excel
binary	        OpenDocument	      read_excel	
binary	        HDF5 Format	      read_hdf	      to_hdf
binary	        Feather Format	      read_feather	to_feather
binary	        Parquet Format	      read_parquet	to_parquet
binary	        Msgpack	            read_msgpack	to_msgpack
binary	        Stata	            read_stata	      to_stata
binary	        SAS	                  read_sas	
binary	        Python Pickle         read_pickle	      to_pickle
SQL	              SQL	                  read_sql	      to_sql
SQL	              Google Big Query      read_gbq	      to_gbq
'''
'''数据结构'''
维数	    名称	        描述
1	    Series	       带标签的一维同构数组
2	    DataFrame	 带标签的，大小可变的，二维异构表格

'''生成对象'''
s = pd.Series([1, 3, 5, np.nan, 6, 8])
s
# 用含日期时间索引与标签的 NumPy 数组生成 DataFrame
dates = pd.date_range('20130101', periods=6)
dates

df = pd.DataFrame(np.random.randn(6, 4), index=dates, columns=list('ABCD'))
df


# 用 Series 字典对象生成 DataFrame:
df2 = pd.DataFrame({'A': 1.,
                  'B': pd.Timestamp('20130102'),
                  'C': pd.Series(1, index=list(range(4)), dtype='float32'),
                  'D': np.array([3] * 4, dtype='int32'),
                  'E': pd.Categorical(["test", "train", "test", "train"]),
                  'F': 'foo'})
df2

# DataFrame 的列有不同数据类型
df2.dtypes

'''查看数据'''
# 查看 DataFrame 头部和尾部数据：
df.head()
df.tail(3)
# 显示索引与列名:
df.index
df.columns
# DataFrame.to_numpy() 输出底层数据的 NumPy 对象。注意:
# DataFrame 的列由多种数据类型组成时，该操作耗费系统资源较大，这也是 Pandas 和 NumPy 的本质区别：NumPy 数组只有一种数据类型，DataFrame 每列的数据类型各不相同。
# 调用 DataFrame.to_numpy() 时，Pandas 查找支持 DataFrame 里所有数据类型的 NumPy 数据类型。
# 还有一种数据类型是 object，可以把 DataFrame 列里的值强制转换为 Python 对象。
df #  这个 DataFrame 里的值都是浮点数，DataFrame.to_numpy() 的操作会很快，而且不复制数据。
df.to_numpy()
df2 # 这个 DataFrame 包含了多种类型，DataFrame.to_numpy() 操作就会耗费较多资源。
df2.to_numpy() # 比较费时,尽量不要使用;

# describe() 可以快速查看数据的统计摘要：
df.describe()

# 转置数据：
df.T

# 按轴排序：
df.sort_index(axis=1, ascending=False)
df.sort_index(axis=0, ascending=False)

# 按值排序：
df.sort_values(by='B')

'''选择'''
# 获取数据
# 选择单列，产生 Series，与 df.A 等效：
df['A']
df.A

# 用[]切片行:
df[0:3]
df['20130102':'20130104']

# 按标签选择:
df.loc[dates[0]]

# 按标签选择多列数据:
df.loc[:, ['A', 'B']]

# 用标签切片，包含行与列结束点：
df.loc['20130102':'20130104', ['A', 'B']]

# 返回对象降维：
df.loc['20130102', ['A', 'B']]

# 提取标量值：
df.loc[dates[0], 'A']

# 快速访问标量，与上述方法等效：
df.at[dates[0], 'A']

# 按位置选择:
df.iloc[3]

# 类似 NumPy / Python，用整数切片：
df.iloc[3:5, 0:2]

# 类似 NumPy / Python，用整数列表按位置切片：
df.iloc[[1, 2, 4], [0, 2]]

# 显式整行切片：
df.iloc[1:3, :]

# 显示整列切片:
df.iloc[:, 1:3]

# 显式提取值：
df.iloc[1,1]

# 快速访问标量，与上述方法等效：
df.iat[1,1]

'''布尔索引'''
# 用单列的值选择数据：
df[df.A > 0]

# 选择 DataFrame 里满足条件的值：
df[df>0]

# 用 isin() 筛选：
df2 = df.copy()
df2['E'] = ['one', 'one', 'two', 'three', 'four', 'three']
df2
df2[df2['E'].isin(['two', 'four'])]

# 总结：at、iat索引，loc、iloc切片，iat、iloc按位置，at、loc按标签。

# 赋值:
# 用索引自动对齐新增列的数据：
s1 = pd.Series([1, 2, 3, 4, 5, 6], index=pd.date_range('20130102', periods=6))
s1
df['F'] = s1

# 按标签赋值:
df.at[dates[0], 'A'] = 0

# 按位置赋值:
df.iat[0, 1] = 0

# 按 NumPy 数组赋值：
df.loc[:, 'D'] = np.array([5] * len(df))

# 上述赋值结果：
df

# 用 where 条件赋值：
df2 = df.copy()
df2[df2 > 0] = -df2
df2

# 缺失值:Pandas 主要用 np.nan 表示缺失数据。 计算时，默认不包含空值。
# 重建索引（reindex）可以更改、添加、删除指定轴的索引，并返回数据副本，即不更改原数据。
df1 = df.reindex(index=dates[0:4], columns=list(df.columns) + ['E'])
df1.loc[dates[0]:dates[1], 'E'] = 1
df1

# 删除所有含缺失值的行：
df1.dropna(how='any')

# 填充缺失值：
df1.fillna(value=5)

# 提取 nan 值的布尔掩码：
pd.isna(df1)

'''统计运算'''
# 一般情况下，运算时排除缺失值。
描述性统计：
df.mean()  # 按列求均值;
# 在另一个轴(即，行)上执行同样的操作：
df.mean(1) # 按行求均值;

# 不同维度对象运算时，要先对齐。 此外，Pandas 自动沿指定维度广播。
s = pd.Series([1, 3, 5, np.nan, 6, 8], index=dates).shift(2)
s
df.sub(s, axis='index') # df减去s;

# apply函数:
df.apply(np.cumsum) # np.cumsum各列元素累积求和;
df.apply(lambda x: x.max() - x.min()) # 各列最大值减去最小值;

# 频率统计:
s = pd.Series(np.random.randint(0, 7, size=10))
s
s.value_counts()

# 字符串方法:str 的模式匹配默认使用正则表达式:
s = pd.Series(['A', 'B', 'C', 'Aaba', 'Baca', np.nan, 'CABA', 'dog', 'cat'])
s.str.lower() # 全部小写;

'''数据合并'''
import numpy as np
import pandas as pd
# 结合:
# concat() 用于连接 Pandas 对象：
df = pd.DataFrame(np.random.randn(10, 4))
df
pieces = [df[:3], df[3:7], df[7:]] # 分解为多组;
pieces
pieces[0]
pieces[1]
pieces[2]
pd.concat(pieces) # 合并;

# 连接 join
left = pd.DataFrame({'key': ['foo', 'foo'], 'lval': [1, 2]})
right = pd.DataFrame({'key': ['foo', 'foo'], 'rval': [4, 5]})
left
right
pd.merge(left, right, on='key')
# 另一个例子:
left = pd.DataFrame({'key': ['foo', 'bar'], 'lval': [1, 2]})
right = pd.DataFrame({'key': ['foo', 'bar'], 'rval': [4, 5]})
left
right
pd.merge(left, right, on='key')

# 追加 append
df = pd.DataFrame(np.random.randn(8, 4), columns=['A', 'B', 'C', 'D'])
df
s = df.iloc[3]
s
df.append(s, ignore_index=True) # s追加到df后面;

# “group by” 指的是涵盖下列一项或多项步骤的处理流程：
分割：按条件把数据分割成多组；
应用：为每组单独应用函数；
组合：将处理结果组合成一个数据结构。
df = pd.DataFrame({'A': ['foo', 'bar', 'foo', 'bar',
                        'foo', 'bar', 'foo', 'foo'],
                  'B': ['one', 'one', 'two', 'three',
                        'two', 'two', 'one', 'three'],
                  'C': np.random.randn(8),
                  'D': np.random.randn(8)})
df
# 先分组,再用sum()函数计算每组的汇总数据:
df.groupby('A').sum()
# 多列分组后,生成多层索引,也可以应用sum函数:
df.groupby(['A', 'B']).sum()

# 重塑(reshaping):
# 堆叠（Stack）
tuples = list(zip(*[['bar', 'bar', 'baz', 'baz',
                  'foo', 'foo', 'qux', 'qux'],
                  ['one', 'two', 'one', 'two',
                  'one', 'two', 'one', 'two']]))
tuples
index = pd.MultiIndex.from_tuples(tuples, names=['first', 'second'])
index
df = pd.DataFrame(np.random.randn(8, 2), index=index, columns=['A', 'B'])
df
df2 = df[:4]
df2

# stack()方法把 DataFrame 列压缩至一层：
stacked = df2.stack()
stacked
# 压缩后的 DataFrame 或 Series 具有多层索引， stack() 的逆操作是 unstack()，默认为拆叠最后一层：
stacked.unstack()
stacked.unstack(0)
stacked.unstack(1)
# stack
student=['张三','李四','王五']
chinese=[70,80,90]
english=[75,85,95]
math=   [40,50,60]
physcis=[45,55,65]
dict={'学生':student,'语文':chinese,'英语':english,'数学':english,'物理':physcis}
df=pd.DataFrame(dict)
df
df=df.set_index(['学生'])
df.columns.names=['学科']
df.stack()
df.stack().unstack()
# 多层索引,行和列都是MultiIndex
classno=[1,1,1,2,2,2]
student=['张三','李四','王五','刘六','唐七','赵八']
chinese=[70,80,90,20,30,40]
english=[75,85,95,35,45,55]
math=   [40,50,60,70,90,80]
physcis=[45,55,65,65,75,85]
dict={'班级':classno,'学生':student,'语文':chinese,'英语':english,'数学':english,'物理':physcis}
df=pd.DataFrame(dict)
df
df=df.set_index(['班级','学生'])
df.columns = [['文科','文科','理科','理科'],['语文','英语','数学','物理']]
df.columns.names=['文理','科目']
# 生成数据如下:
'''
文理     文科      理科
科目     语文  英语  数学  物理
班级  学生
1     张三  70  75  75  45
      李四  80  85  85  55
      王五  90  95  95  65
2     刘六  20  35  35  65
      唐七  30  45  45  75
      赵八  40  55  55  85
'''
# stack:由列堆叠为行,要选择索引的层次,最外层为0;
df
df.stack(0) # 0表示按最外层列索引,文理进行堆叠
df.stack(1) # 1表示按第2层列索引,科目进行堆叠
df.stack().stack() # ,默认对第0层进行堆叠
# unstack:由行重构为列,也需要选择索引的层次,默认从第0层;
df
df.unstack(0)
df.unstack(1)
# 相当于转置:
df.stack(0).stack(0).unstack(0).unstack(0).dropna(axis=1)

# 处理全国城市面板数据合并后的结果
import os 
import pandas as pd
os.chdir("E:\data")
os.getcwd()
df = pd.read_excel("全国数据汇总.xlsx",sheet_name="Sheet2",header=0)
df = pd.read_excel("全国数据汇总.xlsx",sheet_name="总表 (2)",header=0)
type(df)

df1 = df.set_index(["指标","地区"])
type(df1)
df1.head()

df2 = df1.stack(0)
df2.head()
df2.index
type(df2)


df3 = df2.unstack('指标')
type(df3)
df3.head()

df4 = df3.reset_index()
df4.head()
df4.columns
df4.rename(columns={'level_1':'年份'},inplace=True)
df4.to_excel("全国数据汇总3.xlsx")


# 数据透视表
df = pd.DataFrame({'A': ['one', 'one', 'two', 'three'] * 3,
                   'B': ['A', 'B', 'C'] * 4,
                   'C': ['foo', 'foo', 'foo', 'bar', 'bar', 'bar'] * 2,
                  'D': np.random.randn(12),
                  'E': np.random.randn(12)})
pd.pivot_table(df, values='D', index=['A', 'B'], columns=['C'])

'''时间序列'''
# Pandas 为频率转换时重采样提供了虽然简单易用，但强大高效的功能;
rng = pd.date_range('1/1/2012', periods=100, freq='S')
rng
ts = pd.Series(np.random.randint(0, 500, len(rng)), index=rng)
ts
tm = ts.resample('5Min').sum()# 将秒级的数据转换为 5 分钟为频率的数据。
tm

# 时区表示:
rng = pd.date_range('3/6/2012 00:00', periods=5, freq='D')
ts = pd.Series(np.random.randn(len(rng)), rng)
ts
ts_utc = ts.tz_localize('UTC')
ts_utc
# 转换为其他时区:
ts_utc.tz_convert('US/Eastern')

# 转换时间段:
rng = pd.date_range('1/1/2012', periods=5, freq='M')
rng
ts = pd.Series(np.random.randn(len(rng)), index=rng)
ts
ps = ts.to_period()
ps
ps.to_timestamp()

# Pandas 函数可以很方便地转换时间段与时间戳。
prng = pd.period_range('1990Q1', '2000Q4', freq='Q-NOV')
prng
prng.asfreq('M','e')
prng.asfreq('M','e')+1
(prng.asfreq('M','e')+1).asfreq('H','s')

ts = pd.Series(np.random.randn(len(prng)), prng)
ts
ts.index = (prng.asfreq('M', 'e') + 1).asfreq('H', 's') + 9
ts.head()

'''类别型数据'''
df = pd.DataFrame({"id": [1, 2, 3, 4, 5, 6],
                  "raw_grade": ['a', 'b', 'b', 'a', 'a', 'e']})
df
df["grade"] = df["raw_grade"].astype("category") # 多增加一类grade数据;
df["grade"]
df
# 用有含义的名字重命名不同类型，调用 Series.cat.categories。
df["grade"].cat.categories = ["very good", "good", "very bad"]
df['grade']
df
# 这里是按生成类别时的顺序排序，不是按词汇排序：
df.sort_values(by="grade")
# 按类列分组（groupby）时，即便某类别为空，也会显示：
df.groupby("grade").size()

'''可视化'''
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
ts = pd.Series(np.random.randn(1000),index=pd.date_range('1/1/2000', periods=1000))
ts
tsum = ts.cumsum()
tsum
tsum.plot()
# DataFrame 的 plot() 方法可以快速绘制所有带标签的列：
df = pd.DataFrame(np.random.randn(1000, 4), index=ts.index,columns=['A', 'B', 'C', 'D'])
df
df = df.cumsum()
plt.figure()
df.plot()
plt.legend(loc='best')

'''数据输入输出'''
df
df.to_csv('foo.csv')
pd.read_csv('foo.csv')
df.to_excel('foo.xlsx', sheet_name='Sheet1')
pd.read_excel('foo.xlsx', 'Sheet1', index_col=None, na_values=['NA'])


