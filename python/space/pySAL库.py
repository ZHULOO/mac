################################### 空间计量#########################################
# 1. https://github.com/pysal pysal的源代码库
# 2. http://pysal.org/        pysal的官方网站，有对pysal各个模块的详细介绍：
    ## 2.1 Lib       ：Libpysal 包含基本算法和数据结构，有io（输入输出）、Weights（存储和操作空间权重矩阵）
        ##           、cp（几何形状的几种算法）
    ## 2.2 Explore   ：包含：esda（全局或局部自相关分析）、giddy（空间在随时间变化的特征，马尔可夫链）、inequality、momepy... 
    ## 2.3 Model     : access、mgwr、spglm、spint、spopt、spreg、spvcm、tobler
    ## 2.4 Viz       ： lengendgram、mapclassify、splot（可视化，莫兰散点图等）


# https://pysal.org/libpysal/api.html ：详细的内置参数
# libpysal提供了四个模块，它们构成了PySAL家族中许多上游包的构建块:
    ## 空间权重:libpysal.weights
    ## 输入和输出:libpysal.io
    ## 计算几何:libpysal.cg
    ## 内置的示例数据集libpysl.examples
#####################几种权重########################
# 一、相邻权重（Contiguity-Based Spatial Weights）
    ## 1.车相邻（Rook）：有共同的边；
    ## 2.后相邻（Queen）：有共同的边和顶点；
    ## 3.象相邻（Bishop）：有共同的顶点;
# 二、距离权重（Distancd-Based Spatial Weights)
    ## 1.距离带权重（Distance-Band Weights）:欧氏距离（平方）和曼哈顿距离（绝对值），
        ### 当距离大于设定的临界值时，权重取1，否则为0，临界值设定要满足每个地区至少有一个邻居，
        ### 避免孤岛的出现；
        ### max-min准则：最近邻距离中最大的为临界值，这往往导致过多的邻居产生，一些点比较聚集，
        ### 而另一些点比较分散，这样用分散点之间的最小距离最为临界值就会导致聚集区域点邻居过多；
        ### 相邻点个数的范围与点的空间分布直接相关。有些孤立的位置将驱动最大的最近邻居截断点的确定(它们的最近邻居距离将很大)，
        ### 而稠密的位置集群将使用这个大的截断距离包围许多邻居。
    ## 2.K近邻矩阵（KNN）：找K个最近的点算作相邻点，所有的点都有K个相邻区域；
    ## 3.距离倒数权重（Inverse-Distance）
    ## 4.kernel：选择合适的带宽，两点之间的距离除以带宽作为z值，然后用核函数计算的值K(z)作为权重值；
        ### 固定的带宽：所有的距离都除以这个带宽，然后取核函数值；
        ### 自适应带宽：给定K=6，会在最近的六个点中去最大的距离为带宽；
        ### 核函数的不同：只影响具体的权重值的大小，不影响连通性；
    ## 5.综述:这几种矩阵只是权重值的大小不同，连通性上是差不多的，不影响空间相关性和连通性的分析，
        ### 但影响显示的计算值，计算莫兰指数时只需要是否相邻的信息，权重值大小不影响莫兰指数的计算，但是变量间显性定量关系时，
        ### 会随着权重值的不同而受影响；

# 三、标准化（Standardize）
    ## 1.行标准化：每个元素除以所在行的和，每一行的和为1；
        ### 连通性矩阵：是否相邻的0-1矩阵，按行标准化以后Wy为相邻位置y的加权平均，不按行标准化则是相邻区域y的和；
        ### 权重值矩阵：每个连通的位置之间有具体的权重值，权重值可以为：距离的倒数或者核函数的值；
    ## 2.

# 四、空间权重矩阵的应用
    ## 1.空间权重矩阵的作用：
        ### 1.1 构造多种多样的空间自相关检验：只用到是否相邻层面的信息；
        ### 1.2 构造显示空间显示变量：构造空间滞后变量，会用到具体的相邻权重值的大小信息；
            #### 1.2.1 个涉及构建所谓的空间滞后变量，以包含在空间回归中；
                ##### 空间滞后的典型效果是压缩变量的范围和方差;
                ##### 
            #### 1.2.2  通过从相邻观测值中借用强度来实现平滑率的方法；
    ## 1.
    ## 1.
    ## 1.
    ## 1.

###################### 关于地图数据文件###############
# 1.一个文件的扩展名为 .shp，一个 .shx，一个.dbf，一个 .prj（带有投影信息）。前三个是必需的，
    # 第四个是可选的，但强烈建议使用。这些文件应全部位于同一目录中，并具有相同的文件名。
# 2..shp文件中可能没有坐标等其它地理信息，但是他们的图层和位置信息可能存储在其它格式的同名文件中，不影响创建
    # 空间权重矩阵；


######################pysal安装:自己摸索安装最顺畅的一遍#################
## 老版本的python=3.8 兼容性更强：
conda create -n geo python=3.8
conda activate geo
conda install --channel conda-forge geopandas 
conda install --channel conda-forge pysal 
## 运行时先切换到geo环境下；

# 找到了原因：和老环境下的版本冲突
    ## 一直失败，为了安装geopandas和pysal创建了一个全新的环境geo
    ## 或者创建一个全新的环境，并为环境设置一个单独的源设置文件.condarc
    ## 然后安装geopandas可以成功，如下：
    ## 原因可能是geopandas依赖的包和已安装的包冲突，而新创建的环境，所有依赖包都是全新安装；
conda create -n geo
conda activate geo
conda config --env --add channels conda-forge   # --env为环境单独添加一个.condarc源设置文件：
conda config --env --set channel_priority strict
conda install python=3 geopandas                # 不指定具体哪一个python版本，适配的是3.10最新版本
conda install pysal


######################### pysal读取csv数据 #####################
import libpysal
import numpy as np
f = libpysal.io.open(libpysal.examples.get_path("usjoin.csv"))   # 直接读取.csv数据
pci = np.array([f.by_col[str(y)] for y in range(1929,2010)])
ls0 = f.by_row[0]                  # 取第一行
ls0
len(ls0)
lsc = f.by_col["STATE_FIPS"]       # 按列取第一列
lsc
len(lsc)



w = libpysal.io.open("E:\BaiduNetdiskWorkspace\郑大\W.txt")       # 直接读取.txt数据
lw0 = w.check()

print(pci.shape)
type(pci)

ls1 = [[str(y)] for y in range(1929,2010)]
ls1
ls2 = [f.by_col[str(y)] for y in range(1929,2010)]
ls2[0]
len(ls2[0])
len(ls2)

####################### Geopandas #####################
# 关于安装，建议先安装geopandas，再安装pysal；
# 因为有版本的原因，建议新建python3.8的环境再按以下顺序安装：
# 建议不要轻易更新python版本，可能很多包不兼容，继续使用老版本：
##  geopandas安装非常麻烦，可能时版本不支持问题:
    ## 创建python3.8虚拟环境：
    conda create -n python38 python=3.8
    conda activate python38
    ## 然后执行
    conda install python=3.8 geopandas # 也能安装成功
## 再在此环境下安装pysal：https://github.com/pysal/pysal ，官方推荐命令
    conda config --add channels conda-forge
    conda install pysal
## 运行时先切换到python38环境下

# geopandas使用
import geopandas as gpd
import pandas as pd
import os 
os.getcwd()
os.chdir(r"F:\Books\python\pySAL\columbus")
os.system('start .')
### 如果要使用Python绘制地图，你需要学会Geopandas、contextily、osmnx、shapely、NetworkX等包；
### Geopandas是地理信息领域的pandas
# 1.Geopandas读取地理数据非常的方便，它只需要几行代码就可以将shp文件转换为GeoDataFrame;
gdf = gpd.read_file("F:\Books\python\pySAL\columbus\columbus.shp")
gdf.head(5)
gdf.geometry
# 2.GeoDataFrame和pandas的DataFrame非常类似,，只不过多了最后一个关于geometry的地理信息字段，
# 用来进行地理信息的描述;
# 3.如果你是excel或者csv等格式的文本文件，需要转换为GeoDataFrame，就需要结合pandas进行操作，
# 原理类似于Arcgis里的添加XY数据
df = pd.read_excel("F:\Books\python\pySAL\columbus\columbus.xlsx")
df.dtypes
df.columns
df.shape
gdf = gpd.GeoDataFrame(df,geometry=gpd.points_from_xy(df.X, df.Y))
df.to_excel('columbus_geo.xlsx') #经过上一步的转换，df里也增加了相应的geometry信息；
gdf.crs = 'EPSG:4326'           # EPSG:4326 (WGS84)目前最流行的地理坐标系统。在国际上，每个坐标系
                                # 统都会被分配一个 EPSG 代码，EPSG:4326 就是 WGS84 的代码。GPS是基
                                # 于WGS84的，所以通常我们得到的坐标数据都是WGS84的。一般我们在存储数据时，
                                # 仍然按WGS84存储。
                                # EPSG:3857 (Pseudo-Mercator)：伪墨卡托投影，也被称为球体墨卡托，Web Mercator。
                                # 它是基于墨卡托投影的，把 WGS84坐标系投影到正方形。我们前面已经知道 WGS84 是基于椭球体的，
                                # 但是伪墨卡托投影把坐标投影到球体上，这导致两极的失真变大，但是却更容易计算。
                                # 这也许是为什么被称为”伪“墨卡托吧。另外，伪墨卡托投影还切掉了南北85.051129°纬度以上的地区，
                                # 以保证整个投影是正方形的。因为墨卡托投影等正形性的特点，在不同层级的图层上物体的形状保持不变，
                                # 一个正方形可以不断被划分为更多更小的正方形以显示更清晰的细节。很明显，伪墨卡托坐标系是非常显示数据，
                                # 但是不适合存储数据的，通常我们使用WGS84 存储数据，使用伪墨卡托显示数据。
gdf.shape
gdf.head(5)
gdf.columns
# 4.Geopandas支持将数据导出为shp、geojson等格式的文件;
gdf.to_file('columbus_gdf.shp')
gdf.dtypes
# 论文数据excel-->shp
df = pd.read_excel("geff_space.xlsx")
gdf = gpd.GeoDataFrame(df,geometry=gpd.points_from_xy(df.longitude, df.latitude))
gdf.crs = 'EPSG:4326'
gdf.to_file('geff_space.shp',driver='ESRI Shapefile',encoding='utf-8')
df.to_excel('geff_space_geo.xlsx')




####################### Space data #####################
import pandas
import osmnx
import geopandas as gpd
import rioxarray
import xarray
import datashader
import contextily as cx
from shapely import geometry
import matplotlib.pyplot as plt








###################### Space weights ####################
libpysal.weights.W(neighbors, weights=None, id_order=None, silence_warnings=False, ids=None)
# neighbors:dict
{'a':['b'],'b':['a','c'],'c':['b']} # 邻居，以字典的形式，a,b,c以及他们的邻居。
# weights:dict
{'a':[0.5],'b':[0.5,1.5],'c':[1.5]} # 权重，以字典的形式，和上面的邻居对应，a,b,c和对应邻居之间的权重；
# id_order:list 
# silence_warnings:bool
# ids:list
# 案例：
from libpysal.weights import W
neighbors = {0: [3, 1], 1: [0, 4, 2], 2: [1, 5], 3: [0, 6, 4], 4: [1, 3, 7, 5], 5: [2, 4, 8], 6: [3, 7], 7: [4, 6, 8], 8: [5, 7]}
weights = {0: [1, 1], 1: [1, 1, 1], 2: [1, 1], 3: [1, 1, 1], 4: [1, 1, 1, 1], 5: [1, 1, 1], 6: [1, 1], 7: [1, 1, 1], 8: [1, 1]}
w = W(neighbors, weights) # 构造了一个权重矩阵对象w
"%.3f"%w.pct_nonzero      
w.pct_nonzero             # 非零权重的占比

# 读取外部.gal数据,gal为GeoDa构造空间权重矩阵的格式
import libpysal
w = libpysal.io.open(libpysal.examples.get_path("stl.gal")).read()
w.neighbors
w = libpysal.io.open("E:\BaiduNetdiskWorkspace\郑大\W.txt").read()
w.cardinalities  # 每个个体相邻的个体数；
w.histogram      # 相邻个数相同的个体频数统计；
w.n
"%.3f"%w.pct_nonzero

# 隐藏式设置权重
neighbors = {0: [3, 1], 1: [0, 4, 2], 2: [1, 5], 3: [0, 6, 4], 4: [1, 3, 7, 5], 5: [2, 4, 8], 6: [3, 7], 7: [4, 6, 8], 8: [5, 7]}
w = W(neighbors)
w.n
w.pct_nonzero  # 9x9矩阵里，有24个非零；
print(24/81)

from libpysal.weights import lat2W
w = lat2W(100, 100)
w.n
w.cardinalities
w.histogram
w.pct_nonzero  # =w.s0/w.n
w.s0

# libpysal.weights.DistanceBand
import libpysal
points=[(10, 10), (20, 10), (40, 10), (15, 20), (30, 20), (30, 30)]


wcheck = libpysal.weights.W({0: [1, 3], 1: [0, 3], 2: [], 3: [0, 1], 4: [5], 5: [4]})
w=libpysal.weights.DistanceBand(points,threshold=11.2)
w=libpysal.weights.DistanceBand(points,threshold=11.2,binary=False)
w.n
del w
w = libpysal.weights.DistanceBand.from_array(array, threshold)
w = libpysal.weights.DistanceBand.from_file()
w = libpysal.weights.DistanceBand.full(self)



### libpysal.weights.Kernel
from libpysal.weights import Kernel
points=[(10, 10), (20, 10), (40, 10), (15, 20), (30, 20), (30, 30)]
kw=Kernel(points)
kw.neighbors
kw.neighbors[0]
kw.neighbors[1]
kw.weights
kw.weights[0]
kw.weights[1]
kw.bandwidth
kw15=Kernel(points,bandwidth=15.0)
kw15[0]
kw15[1]
kw15.neighbors
kw15.weights
# Adaptive bandwidths user specified
bw=[25.0,15.0,25.0,16.0,14.5,25.0]
kwa=Kernel(points,bandwidth=bw)
kwa.neighbors
kwa.weights
kwa.neighbors[0]
kwa.weights[0]
kwa.bandwidth
# Endogenous adaptive bandwidths
kwea=Kernel(points,fixed=False)
kwea.neighbors
kwea.weights
kwea.neighbors[0]
kwea.weights[0]
kwea.bandwidth
# Endogenous adaptive bandwidths with Gaussian kernel
kweag=Kernel(points,fixed=False,function='gaussian')
kweag.neighbors
kweag.weights
kweag.neighbors[0]
kweag.weights[0]
kweag.bandwidth
# 方法
libpysal.weights.Kernel.from_dataframe(df)
libpysal.weights.Kernel.from_file()


############################空间马尔可夫###########################



############################莫兰散点图###########################
import matplotlib.pyplot as plt
from libpysal.weights.contiguity import Queen
from libpysal import examples
import numpy as np
import pandas as pd
import geopandas as gpd
import os
import splot
from esda.moran import Moran
from splot.esda import moran_scatterplot

os.chdir(r"/users/zhulu/files/data/郑大")
gdf = gpd.read_file('geff_space.shp')

y = gdf['geff2005'].values
w = Queen.from_dataframe(gdf)
w.transform = 'r'

moran = Moran(y, w)
moran.I

fig, ax = moran_scatterplot(moran, aspect_equal=True)
plt.show()

# 画2005\2010\2015\2019四年的莫兰散点图:
gdf = gpd.read_file('geff_space.shp')
w = Queen.from_dataframe(gdf)
w.transform = 'r'

fig, axes = plt.subplots(2,2,figsize = (10,10)) 
plt.rcParams['font.sans-serif']=['Songti SC'] # 将无衬线字体设置为Songti SC字体;
plt.rcParams['axes.unicode_minus'] = False   # 正常显示负号;
lis = ['geff2005','geff2010','geff2015','geff2019']  # 循环画这四年的密度图
lis1 = ['2005年','2010年','2015年','2019年']
for i in range(2):
    for j in range(2):
        ax = axes[i,j]
        ax.set_xlabel(" ")
        index = lis[i*2+j]
        y = gdf[index].values
        moran = Moran(y, w)
        moran_scatterplot(moran, ax=ax, aspect_equal=True)
        ax.set_xlabel(" %s "%lis1[i*2+j],fontsize=13)
        # ax.set_title(" %s "%lis1[i*2+j],fontsize=13)

plt.show()

############产业集聚莫兰散点图#############
# 读取转换文件
import os
import pandas as pd
import geopandas as gpd
from shapely import geometry


os.chdir(r"/users/zhulu/files/data/郑大")
df = pd.read_excel(r"/users/zhulu/files/data/郑大/agg_space.xlsx")
gdf = gpd.GeoDataFrame(df,geometry=gpd.points_from_xy(df.longitude, df.latitude))
gdf.crs = 'EPSG:4326'
gdf.to_file('agg_space.shp',driver='ESRI Shapefile',encoding='utf-8')







### Raster awareness API
from libpysal.weights import Rook, Queen, raster
import matplotlib.pyplot as plt
from splot import libpysal as splot
import numpy as np
import xarray as xr
import pandas as pd
from esda import Moran_Local
import os
import pooch
os.getcwd()
os.chdir(r"F:\Books\python\pySAL")

ds = xr.tutorial.open_dataset("air_temperature.nc")      # -> returns a xarray.Dataset object
da = ds["air"]                                           # we'll use the "air" data variable for further analysis
print(da)






### 
import matplotlib.pyplot as plt
from libpysal.weights.contiguity import Queen
from libpysal import examples
import numpy as np

import pandas as pd
import geopandas as gpd
import os
import splot

guerry = examples.load_example('Guerry')
link_to_data = guerry.get_path('guerry.shp')
gdf = gpd.read_file(link_to_data)

y = gdf['Donatns'].values
w = Queen.from_dataframe(gdf)
w.transform = 'r'

from esda.moran import Moran
w = Queen.from_dataframe(gdf)
moran = Moran(y, w)
moran.I

from splot.esda import moran_scatterplot
fig, ax = moran_scatterplot(moran, aspect_equal=True)
plt.show()

from libpysal.weights import lat2W
w = lat2W(4,3)

from_dataframe = jls_extract_def()


rom libpysal.weights import lat2W
w = lat2W(4,3)

from_dataframe


