# 马尔可夫
    ## 参考：https://www.cnblogs.com/pinard/p/6632399.html#undefined
    ## 初始状态分布矩阵S1 = [0.3, 0.4, 0.3]，即第一天进进在玩的概率是30%，在学的概率是40%，在睡觉的概率是30%，我们以此来计算100天后，也就是第一百天进进在玩or学or睡觉的概率分布。

import numpy as np

matrix = np.matrix([[0.05, 0.75, 0.2],
                    [0.8, 0.05, 0.15],
                    [0.25, 0.5, 0.25]])
vector1 = np.matrix([[0.3, 0.4, 0.3]])

for i in range(100):
    vector1 = vector1 * matrix
    print('第{}轮'.format(i+1))
    print(vector1)

    ## 从结果可以发现，已知一天初始状态和转移矩阵往后测算，当测算到某一天开始，往后的状态概率分布就不变了，一直保持[0.39781591, 0.41341654, 0.18876755]。这会不会是巧合？假如初始状态分布矩阵S1 不是  [0.3, 0.4, 0.3]，结果还会是[0.39781591, 0.41341654, 0.18876755]吗？我们进行第二次试验，这次试验中，我们将始状态分布矩阵S1 =  [0.2, 0.6, 0.2]。

vector1 = np.matrix([[0.2, 0.6, 0.2]])

for i in range(100):
    vector1 = vector1 * matrix
    print('第{}轮'.format(i+1))
    print(vector1)

    ## 也就是说我们的马尔科夫链模型的状态转移矩阵收敛到的稳定概率分布与我们的初始状态概率分布无关。这是一个非常好的性质，也就是说，如果我们得到了这个稳定概率分布对应的马尔科夫链模型的状态转移矩阵，则我们可以用任意的概率分布样本开始，带入马尔科夫链模型的状态转移矩阵，这样经过一些序列的转换，最终就可以得到符合对应稳定概率分布的样本。

    ## 这个性质不光对我们上面的状态转移矩阵有效，对于绝大多数的其他的马尔科夫链模型的状态转移矩阵也有效。同时不光是离散状态，连续状态时也成立。

    ## 同时，对于一个确定的状态转移矩阵P，它的n次幂Pn在当n大于一定的值的时候也可以发现是确定的，我们还是以上面的例子为例，计算代码如下：

matrix = np.matrix([[0.9,0.075,0.025],[0.15,0.8,0.05],[0.25,0.25,0.5]], dtype=float)
for i in range(10):
    matrix = matrix * matrix
    print('第{}轮'.format(i+1))
    print(matrix)

    ## 我们可以发现，在n≥6以后，Pn的值稳定不再变化，而且每一行都为[0.625   0.3125  0.0625]，这和我们前面的稳定分布是一致的。这个性质同样不光是离散状态，连续状态时也成立。

# 马尔可夫状态矩阵：pysal库的giddy包
## 参考：https://pysal.org/giddy/
import numpy as np
c = np.array([['b','a','c'],['c','c','a'],['c','b','c'],['a','a','b'],['a','b','c']])
c.shape
import giddy
m = giddy.markov.Markov(c)
m
m = giddy.markov.Markov(c, summary=False)
m.classes
m.transitions
m.p
m.steady_state


## 读入实际数据计算马尔可夫转移概率
import libpysal
import os
os.chdir(r"C:\ProgramData\Anaconda3\envs\geo\lib\site-packages\libpysal\examples\us_income")
os.system('start .')
f = libpysal.io.open(libpysal.examples.get_path("usjoin.csv"))  # 48州*81年的数据
pci = np.array([f.by_col[str(y)] for y in range(1929,2010)])    # 只按列读入f的1929-2009列的数据，转化为array的行；
print(pci.shape)

print(pci[0, :])
len(pci[0,:])

# argsort()的用法：显示从小到大排好序以后的数字在源列表中的位置索引;
x = np.array([6, 4, 5])
ind = np.argsort(x)    
ind # [1,2,0] x[1]=4, x[2]=5, x[0]=6
np.take_along_axis(x, ind,axis=0)


x = np.array([[0, 3], [2, 2]])
x
ind = np.argsort(x, axis=0)         # sorts along first axis (down)
ind
np.take_along_axis(x, ind, axis=0)  # same as np.sort(x, axis=0) 按纵向从小到大排序


ind = np.argsort(x, axis=1)  # sorts along last axis (across)
ind

np.take_along_axis(x, ind, axis=1)  # same as np.sort(x, axis=1)

import matplotlib.pyplot as plt
%matplotlib inline
years = range(1929,2010) 
names = np.array(f.by_col("Name"))                                    # 提取州名
names
order1929 = np.argsort(pci[0,:])                                      # 提取pci第一行1929年数据从小到大的索引
pci[0,:]
order1929
order1929[::-1] # 倒序索引
order2009 = np.argsort(pci[-1,:])                                     # pci最后一行2009年数据从小到大的索引
names1929 = names[order1929[::-1]]
names2009 = names[order2009[::-1]]
first_last = np.vstack((names1929,names2009))
first_last
first_last.shape
from pylab import rcParams
rcParams['figure.figsize'] = 15,10  # rc 图参数
plt.plot(years,pci)
for i in range(48):
    plt.text(1915,54530-(i*1159), first_last[0][i],fontsize=12)      # 坐标轴左两侧添上对应的州名称
    plt.text(2010.5,54530-(i*1159), first_last[1][i],fontsize=12)    # 坐标轴右两侧添上对应的州名称
plt.xlim((years[0], years[-1]))
plt.ylim((0, 54530))
plt.ylabel(r"$y_{i,t}$",fontsize=14)
plt.xlabel('Years',fontsize=12)
plt.title('Absolute Dynamics',fontsize=18)

plt.show()


# 矩阵除以向量运算：矩阵的列数等于向量的行数，对应于每一列分别除以向量的每一个值；
pci
pci.shape
pci.T
pci.mean(axis=1)                    # 行方向求均值，每年时间内48个州的均值；
pci.mean(axis=1).shape              # 81行对应81个均值；
rpci= (pci.T / pci.mean(axis=1)).T  # 81*48相当于pci的81行除以各行的均值；

rpci0 = pci/pci.mean(axis=0)        # 相当于
rpci.shape
rpci0.shape

a = np.array([[2,4,6],[8,10,12]])
b = np.array([4,10])
c = np.array([5,7,9])
d = a.mean(axis=0)      # 列求均值[5,7,9]
e = a.mean(axis=1)      # 行求均值[4,10],无论行或列求均值最终都转换成了列向量；
a
a.shape
b
b.shape
c
c.shape
d
d.shape
e
e.shape
a/d        # 各列除以各列的均值
(a.T/e).T  # 各行除以各行的均值

years = range(1929,2010)
rpci= (pci.T / pci.mean(axis=1)).T   # 各行除以各行的均值，每个年份下48个州除以当年各州的均值
names = np.array(f.by_col("Name"))
order1929 = np.argsort(rpci[0,:])
order2009 = np.argsort(rpci[-1,:])
names1929 = names[order1929[::-1]]
names2009 = names[order2009[::-1]]
first_last = np.vstack((names1929,names2009))
from pylab import rcParams
rcParams['figure.figsize'] = 15,10
plt.plot(years,rpci)
for i in range(48):
    plt.text(1915,1.91-(i*0.041), first_last[0][i],fontsize=12)
    plt.text(2010.5,1.91-(i*0.041), first_last[1][i],fontsize=12)
plt.xlim((years[0], years[-1]))
plt.ylim((0, 1.94))
plt.ylabel(r"$y_{i,t}/\bar{y}_t$",fontsize=14)
plt.xlabel('Years',fontsize=12)
plt.title('Relative Dynamics',fontsize=18)

# mapclassify：分类包，连续变量离散化
import mapclassify
y = mapclassify.load_example()
y
y.mean()
y.min(), y.max()
## 分位数分类
mapclassify.Quantiles(y, k=5).yb

import mapclassify as mc
pci.shape

def fun():
    count = 0
    for y in pci:     # 按行取出循环打印，共81行，每行48个州的收入数据
        count += 1
        print("当前第{0}次循环".format(count))
        print(y)
fun()

for y in pci:
    print(y)



q5 = np.array([mc.Quantiles(y,k=5).yb for y in pci]).transpose()
q5.shape
print(q5[:, 0])

q5[4,:].shape



# 论文实证：空间马尔可夫
import geopandas as gpd
import pandas as pd
import numpy as np
import libpysal
import os
os.chdir(r"E:\BaiduNetdiskWorkspace\郑大")
os.system('start .')
## geopandas读入数据转化为shp格式
df = pd.read_excel("geff_markev.xlsx")
gdf = gpd.GeoDataFrame(df,geometry=gpd.points_from_xy(df.longitude, df.latitude))
gdf.crs = 'EPSG:4326'
gdf.to_file('geff_markev.shp',driver='ESRI Shapefile',encoding='utf-8')


## 读入原始excel数据，先不考虑空间信息的马尔可夫转换矩阵
f = libpysal.io.open("geff_markev.csv")    # 279市*15年
pci = np.array([f.by_col["geff"+str(y)] for y in range(2005,2020)])
print(pci.shape)  # 15年*279市

import mapclassify as mc
import giddy
q3 = np.array([mc.Quantiles(y,k=3).yb for y in pci]).transpose() # 15年，按年份取每一年下279个市绿色效率的3分位数
print(q3.shape) # 279*15，一列是一个年份所有城市的分位数位置数据；
print(q3[:, 0]) # q5的第一列，2005年的279个市收入数据的分位数情况
print(f.by_col("city_label")) # 显示279个城市名称
print(q3[4,:])  # 第四个城市，保山市15年绿色效率的分位数位置数据
m3 = giddy.markov.Markov(q3) # 对每一年分内279个市的5分位数分为5类的情况进行马尔可夫
m3.transitions
m3.p
m3.summary()

## 考虑空间依赖的空间马尔可夫转换概率矩阵：
### 使用geopandas读取上面转换的shp格式文件，先生成空间权重矩阵
from libpysal.weights.contiguity import Queen
gdf = gpd.read_file('geff_markev.shp')
gdf
w = Queen.from_dataframe(gdf)
w.transform = 'r'
w
rpci= (pci.T / pci.mean(axis=1)).T   # 各行除以各行的均值，每个年份下279个市除以当年内各市绿色效率的均值
sm = giddy.markov.Spatial_Markov(rpci.T, w, fixed = True, k = 3,m=3)  # 尝试多次，分为三类：低，中，高，并且邻居也分为3类时比较显著；
sm.p     # 小写p表示,此时是无空间依赖的转移矩阵

sm.P     # 大写P，表示有空间依赖的时候空间矩阵，此处有3个,可以使用循环将上面四个矩阵画到一个图上
sm.P[0]  
sm.p[1]
sm.P[2]
sm.summary() # 上面四个矩阵全部显示出来


### 画出矩阵图
import seaborn as sns

fig, axes = plt.subplots(2,2,figsize = (10,10)) 
plt.rcParams['axes.unicode_minus'] = False 
sns.set_style( {'font.sans-serif': ['Times Newroman','FangSong']})
sns.set_palette("Set2")
fig.suptitle("The Spatial Markov Transition Probability Matrix Plot", fontsize=15)
lis = ['L','M','H']
for i in range(2):
    for j in range(2):
        ax = axes[i,j]
        if i==0 and j==0:
            ax = sns.heatmap(sm.p, annot=True, linewidths=.5, ax=ax, cbar=True, vmin=0, vmax=1,
                        square=True, cmap="YlGn",fmt='.3f')
            ax.set_title("No Spatial Dependant",fontsize=13)
            continue
        p_temp = sm.P[i*2+j-1]
        im = sns.heatmap(p_temp, annot=True, linewidths=.5, ax=ax, cbar=True, vmin=0, vmax=1,
                        square=True, cmap="YlGn",fmt='.3f')
        ax.set_title("With %s Neighbors"%lis[i*2+j-1],fontsize=13) 

plt.show()


## 计算权重指数,并画出历年莫兰指数折线图
from esda.moran import Moran
import matplotlib.pyplot as plt
gdf = gpd.read_file('geff_markev.shp')
w = Queen.from_dataframe(gdf)
w.transform = 'r'

mits = [Moran(cs, w) for cs in pci]  # pci 15*279，15行，每行279个市的空间自相关情况；
res = np.array([(mi.I, mi.EI, mi.seI_norm, mi.sim[974]) for mi in mits]) # 可以得到15个莫兰指数；
years = np.arange(2005,2020)
fig, ax = plt.subplots(nrows=1, ncols=1,figsize = (10,5) )
ax.plot(years, res[:,0], label='Moran\'s I') # 历年莫兰指数的散点图；
#plot(years, res[:,1], label='E[I]')
ax.plot(years, res[:,1]+1.96*res[:,2], label='Upper bound',linestyle='dashed')
ax.plot(years, res[:,1]-1.96*res[:,2], label='Lower bound',linestyle='dashed')
ax.set_title("Global Spatial Autocorrelation for Green Efficience",fontdict={'fontsize':15})
ax.set_xlim([2005,2019])
ax.legend()
plt.show()



