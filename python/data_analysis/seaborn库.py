### seaborn中文文档:https://seaborn.apachecn.org/#/docs/1
# seaborn是Python中基于matplotlib的具有更多可视化功能和更优美绘图风格的绘图模块，
# 当我们想要探索单个或一对数据分布上的特征时，可以使用到seaborn中内置的若干函数对数据
# 的分布进行多种多样的可视化。

# kdeplot
    ## seaborn中的kdeplot可用于对单变量和双变量进行核密度估计并可视化，其主要参数如下：
    ## data：一维数组，单变量时作为唯一的变量
    ## data2：格式同data2，单变量时不输入，双变量作为第2个输入变量
    ## shade：bool型变量，用于控制是否对核密度估计曲线下的面积进行色彩填充，True代表填充
    ## vertical：bool型变量，在单变量输入时有效，用于控制是否颠倒x-y轴位置
    ## kernel：字符型输入，用于控制核密度估计的方法，默认为'gau'，即高斯核，特别地在2维变量的情况下仅支持高核方法
    ##　legend：bool型变量，用于控制是否在图像上添加图例
    ##　cumulative：bool型变量，用于控制是否绘制核密度估计的累计分布，默认为False
    ##　shade_lowest：bool型变量，用于控制是否为核密度估计中最低的范围着色，主要用于在同一个坐标轴中比较多个不同分布总体，默认为True
    ##　cbar：bool型变量，用于控制是否在绘制二维核密度估计图时在图像右侧边添加比色卡
    ##　color：字符型变量，用于控制核密度曲线色彩，同plt.plot()中的color参数，如'r'代表红色
    ##　cmap：字符型变量，用于控制核密度区域的递进色彩方案，同plt.plot()中的cmap参数，如'Blues'代表蓝色系
    ##　n_levels：int型，在而为变量时有效，用于控制核密度估计的区间个数，反映在图像上的闭环层数
    ##　下面我们来看几个示例来熟悉kdeplot中上述参数的实际使用方法：
    ##　首先我们需要准备数据，本文使用seaborn中自带的鸢尾花数据作为示例数据，因为在jupyter notebook中运行代码，所以加上魔术命令%matplotlib inline使得图像得以在notebook中显示；

# 官方API：https://seaborn.pydata.org/api.html
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import os
os.getcwd()
os.chdir(r"E:\data\seaborn")
# tips = sns.load_dataset("tips")
tips = pd.read_csv("tips.csv")
tips.head()
sns.kdeplot(data=tips, x="total_bill")              # 数据是tips，dataframe，画x=“total_bill”的核密度图；
sns.kdeplot(data=tips)                              # 画数据框tips中所有数据列的核密度图在一个图中；
sns.kdeplot(x="total_bill")
sns.kdeplot(data = tips,x="total_bill",y = "tip")
sns.kdeplot(data = tips,y = "tip")

plt.show()

#加载seaborn自带的鸢尾花数据集，格式为数据框
iris = sns.load_dataset('iris')
# 读不出数据去github网站https://github.com/mwaskom/seaborn-data下载数据集放到本地
iris = pd.read_csv("E:\data\seaborn\iris.csv")
#分离出setosa类的花对应的属性值
setosa = iris.loc[iris.species == "setosa"].reset_index(drop=True)
setosa.petal_width
#分离出virginica类的花对应的属性值
virginica = iris.loc[iris.species == "virginica"].reset_index(drop=True)
# 首先我们不修改其他参数只传入数据来观察绘制出的图像：
#绘制iris中petal_width参数的核密度估计图
fig, ax = plt.subplots(constrained_layout=True)
ax = sns.kdeplot(iris.petal_width)
ax = sns.kdeplot(iris.petal_width,shade=True,color='r') # 红色填充
ax = sns.kdeplot(iris.petal_width,shade=True,color='r',cumulative=True) # 累计概率分布
# 绘制setosa花的petal_width与petal_length的联合核密度估计图
ax = sns.kdeplot(x = setosa.petal_width,y = setosa.petal_length)
ax = sns.kdeplot(data = iris)
ax = sns.kdeplot(x = setosa.petal_width)
data = [setosa.petal_width,virginica.petal_width]
ax = sns.kdeplot(data = iris.iloc[:,[1,3]])
fig.savefig('iris_petal.png')
# 两个变量的和密度图画在一个图上：
ax1 = sns.kdeplot(setosa.petal_width,label='setosa.petal_width')
ax2 = sns.kdeplot(virginica.petal_width,label='virginica.petal_width')
# 
sns.kdeplot(data=tips, x="total_bill", bw_adjust=.2) # 设置带宽
sns.kdeplot(data=tips, x="total_bill", bw_adjust=5) # 设置带宽
# 
tips.head()
sns.kdeplot(data=tips, x="total_bill", hue="time")

#
sns.kdeplot(
    data=tips, x="total_bill", hue="size",
    fill=True, common_norm=False, palette="crest",
    alpha=.5, linewidth=0,
)
plt.show()

# heatmap图
from numpy import arange
x = arange(25).reshape(5, 5)
cmap = sns.cubehelix_palette(as_cmap=True)
cmap = sns.color_palette("crest",as_cmap=True)
ax = sns.heatmap(x, cmap=cmap)
plt.show()

# 颜色系统:https://seaborn.pydata.org/tutorial/color_palettes.html?highlight=color

## 设置不同的颜色对象,在画图函数的参数调用:
### 不同的color_palette
sns.color_palette("hls", 8)
sns.color_palette("husl", 8)
sns.color_palette("Set2")
sns.color_palette("Paired")
### 画出
sns.palplot(sns.color_palette("ch:2,r=.2,l=.6"))
sns.palplot(sns.color_palette("Set2"))
### 一种调用,hue分类图形
iris = sns.load_dataset("iris")
sns.kdeplot(data=iris,palette="Set2")
plt.show()
### 或者定义一个cmap:
cmap = sns.color_palette("Set2",as_cmap=True)
ax = sns.heatmap(x, cmap=cmap)

### 不同的cubehelix_palette
sns.cubehelix_palette(start=.5, rot=-.5, as_cmap=True)
sns.cubehelix_palette(rot=-.4)
### 画出不同的cubehelix_palette
sns.palplot(sns.cubehelix_palette())
sns.palplot(sns.cubehelix_palette(rot=-.4))
sns.palplot(sns.cubehelix_palette(start=2.8, rot=.1))
sns.palplot(sns.cubehelix_palette(reverse=True))
### 调用
from numpy import arange
x = arange(25).reshape(5, 5)
cmap = sns.cubehelix_palette(as_cmap=True)
ax = sns.heatmap(x, cmap=cmap)

# 论文
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import os
os.getcwd()
os.chdir(r"E:\BaiduNetdiskWorkspace\郑大")
os.system('start .')
df = pd.read_excel("kernel_plot.xlsx")
df.head()

# sns.kdeplot(data = df,x = "geff2005")
# ax = sns.kdeplot(data = df,x = "geff2005",hue="district")
# ax.set(xlabel='common xlabel', ylabel='common ylabel')
# plt.legend(title = "changshi")
# plt.show()

# 每年内(2005、2010、2015、2019)的各区域核密度图

fig, axes = plt.subplots(2,2,figsize = (10,10)) 
plt.rcParams['axes.unicode_minus'] = False 
sns.set_style("darkgrid", {"axes.facecolor": ".9"})
sns.set_style( {'font.sans-serif': ['Times Newroman','FangSong']})
fig.suptitle("The Regions'GEE of Over Different Years", fontsize=15)
lis = ['geff2005','geff2010','geff2015','geff2019']  # 循环画这四年的密度图
lis1 = ['2005\'s','2010\'s','2015\'s','2019\'s']
for i in range(2):
    for j in range(2):
        ax = axes[i,j]
        ax.set_xlabel(" ")
        index = lis[i*2+j]
        im = sns.kdeplot(data = df,x = df[index],hue="Area", ax=ax, palette="Set2")   # 每个图上画三个区域的对比;
        ax.set_title(" %s GEE "%lis1[i*2+j],fontsize=13)

plt.show()


# 全国和各区域四年2005、2010、2015、2019的核密度图
import seaborn as sns; sns.set()
import matplotlib.pyplot as plt
import pandas as pd
import os
os.getcwd()
os.chdir(r"E:\BaiduNetdiskWorkspace\郑大")
os.system('start .')
df_country = pd.read_excel("kernel_plot_area_country.xlsx")
df = pd.read_excel("kernel_plot_area.xlsx")
df.head()

fig, axes = plt.subplots(2,2,figsize = (10,10)) 
plt.rcParams['axes.unicode_minus'] = False   # 防止中文显示为空白格
sns.set_style("darkgrid", {"axes.facecolor": ".9"})
sns.set_style( {'font.sans-serif': ['Times Newroman','FangSong']})
sns.set_palette("PuBuGn_d")
fig.suptitle("The Change of GEE's Density In Different Regions", fontsize=15)
lis = ['Eastern','Central','Western']
for i in range(2):
    for j in range(2):
        ax = axes[i,j]
        if i == 0 and j == 0:
            ax = sns.kdeplot(data = df_country,x = df_country["geff"],hue="Year", ax=ax, palette="Set2")
            ax.set_title("The Country's GEE",fontsize=13)
            ax.set_xlabel(" ")
            continue
        index = lis[i*2+j-1]
        im = sns.kdeplot(data = df,x = df[index],hue="Year", ax=ax, palette="Set2")
        ax.set_title("The %s GEE "%lis[i*2+j-1],fontsize=13)
        ax.set_xlabel(" ")

plt.show()