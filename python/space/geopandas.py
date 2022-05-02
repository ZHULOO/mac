########################geopandas##############################
from shapely import geometry
import geopandas as gpd
import numpy as np
import matplotlib.pyplot as plt
# 2.1 GeoSeries#
# 2.1.1 GeoSeries中的基础几何对象
    ## 与Series相似，GeoSeries用来表示一维向量，只不过这里的向量每个位置上的元素都表示着一个shapely中的几何对象，有如下几种类型：

# Points:对应shapely.geometry中的Point，用于表示单个点，下面我们创建一个由若干Point对象组成的GeoSeries并像Series一样定义索引;
# 创建存放Point对象的GeoSeries
# 这里shapely.geometry.Point(x, y)用于创建单个点对象
gls = gpd.GeoSeries([geometry.Point(0, 0),
    geometry.Point(0, 1),
    geometry.Point(1, 1),
    geometry.Point(1, 0)],
    index=['a', 'b', 'c', 'd'])
gls
type(gls)

# MultiPoint:对应shapely中的MultiPoint，用于表示多个点的集合，下面我们创建一个由若干MultiPoint对象组成的GeoSeries;
# 创建存放MultiPoint对象的GeoSeries
# 这里shapely.geometry.MultiPoint([(x1, y1), (x2, y2), ...])用于创建多点集合
gls1 = gpd.GeoSeries([geometry.MultiPoint([(0, 1), (1, 0)]),
    geometry.MultiPoint([(0, 0), (1, 1)])],
    index=['a', 'b'])
gls1
type(gls1)

# LineString:对应shapely中的LineString，用于表示由多个点按顺序连接而成的线，下面我们创建一个由若干LineString对象组成的GeoSeries;
# 创建存放LineString对象的GeoSeries
# 这里shapely.geometry.LineString([(x1, y1), (x2, y2), ...])用于创建多点按顺序连接而成的线段
gline = gpd.GeoSeries([geometry.LineString([(0, 0), (1, 1), (1, 0)]),
        geometry.LineString([(0, 0), (0, 1), (-1, 0)])],
        index=['a', 'b'])
gline

# MultiLineString:对应shapely中的MultiLineString，用于表示多条线段的集合，下面我们创建一个由若干MultiLineString对象组成的GeoSeries;
# 创建存放MultiLineString对象的GeoSeries
# 这里shapely.geometry.MultiLineString([LineString1, LineString2])用于创建多条线段的集合
glines = gpd.GeoSeries([geometry.MultiLineString([[(0, 0), (1, 1), (1, 0)],
        [(-0.5, 0), (0, 1), (-1, 0)]])],
        index=['a'])

# 无孔Polygon:geopandas中的Polygon对应shapely中的Polygon，用于表示面，根据内部有无孔洞可继续细分。下面我们创建一个由无孔Polygon对象组成的GeoSeries
# 创建存放无孔Polygon对象的GeoSeries
# 这里shapely.geometry.Polygon([(x1, y1), (x2, y2),...])用于创建无孔面
poly = gpd.GeoSeries([geometry.Polygon([(0, 0), (0, 1), (1, 1), (1, 0)])],
        index=['a'])

# 有孔Polygon:
# 创建存放有孔Polygon对象的GeoSeries
# 这里shapely.geometry.Polygon(polygonExteriors, interiorCoords)用于创建有孔面
# 其中polygonExteriors用于定义整个有孔Polygon的外围，是一个无孔的多边形
# interiorCoords是用于定义内部每个孔洞（本质上是独立的多边形）的序列
gpd.GeoSeries([geometry.Polygon([(0,0),(10,0),(10,10),(0,10)], 
        [((1,3),(5,3),(5,1),(1,1)), ((9,9),(9,8),(8,8),(8,9))])])

# MultiPolygon:
# 创建存放MultiPolygon对象的GeoSeries
# 这里shapely.geometry.MultiPolygon([Polygon1, Polygon2])用于创建多个面的集合
gpd.GeoSeries([geometry.MultiPolygon([geometry.Polygon([(0, 0), (0, 1), (1, 1), (1, 0), (0, 0)]),
        geometry.Polygon([(2, 2), (2, 3), (3, 3), (3, 2), (2, 2)])])],
        index=['a'])

# LinearRing:LinearRing对应shapely.geometry中的LinearRing，是一种特殊的几何对象，可以理解为闭合的线或无孔多边形的边框，创建时传入数据的格式与Polygon相同，
# 下面我们创建一个由LinearRing对象组成的GeoSeries：
# 创建存放LinearRing对象的GeoSeries
# 这里shapely.geometry.LinearRing([(x1, y1), (x2, y2),...])用于创建LinearRing
gpd.GeoSeries([geometry.LinearRing([(0, 0), (0, 1), (1, 1), (1, 0)])],
        index=['a'])


# 2.1.2 GeoSeries常用属性
# area:area属性返回与GeoSeries中每个元素一一对应的面积值
# bounds属性返回每个几何对象所在box左下角、右上角的坐标信息
# centroid返回每个几何对象的重心（几何中心）

# 2.2 GeoDataFrame#
# 2.2.1 GeoDataFrame基础
# geopandas中的GeoDataFrame是在pandas.DataFrame的基础上，加入空间分析相关内容进行改造而成，
# 其最大特点在于其在原有数据表格基础上增加了一列GeoSeries使得其具有矢量性，
# 所有对于GeoDataFrame施加的空间几何操作也都作用在这列指定的几何对象之上。
contents = [(loc, 0.5) for loc in range(0, 10, 2)]
contents

geo_df = gpd.GeoDataFrame(data=contents, 
    geometry=[geometry.MultiPoint(np.random.normal(loc=loc, scale=scale, size=[10, 2]).tolist()) 
    for loc, scale in contents],columns=['均值', '标准差'])
geo_df

# 其中定义GeoDataFrame时作为每行所关联几何对象的GeoSeries需要通过geometry参数指定，
# 而除了用上述的方式创建GeoDataFrame，先创建数据表，再添加矢量信息列亦可，
# 这时几何对象列的名称可以自由设置，但一定要利用GeoDataFrame.set_geometry()方法
# 将后添加的矢量列指定为矢量主列，因为每个GeoDataFrame若在定义之处没有指定矢量列，
# 后将无法进行与适量信息挂钩的所有操作（GeoSeries所有属性都可同样作用于GeoDataFrame，
# 因为所有空间操作实际上都直接作用于其矢量主列）：
# 添加矢量列但未定义:
geo_df = gpd.GeoDataFrame(contents, columns=['均值', '标准差'])
geo_df
geo_df['raw_points'] = [geometry.MultiPoint(np.random.normal(loc=loc, scale=scale, size=[10, 2]).tolist()) 
                        for loc, scale in contents]
# 尝试查看矢量类型:
geo_df.geom_type
# 重新为GeoDataFrame指定矢量列:
geo_df.set_geometry('raw_points').geom_type
geo_df.geom_type

# 多个矢量列切换
# 通过前面的内容，我们知道了每个GeoDataFrame都有一个矢量主列，相关操作例如绘图都基于此列，
# 实际上GeoDataFrame允许表中存在多个矢量列，只要求任意时刻有且仅有1列为矢量主列即可，
# 因此我们可以在一个GeoDataFrame中保存多列矢量，需要用到哪列时再进行切换即可，如下面的例子：
geo_df = gpd.GeoDataFrame(contents, columns=['均值', '标准差'])
geo_df['raw_points'] = [geometry.MultiPoint(np.random.normal(loc=loc, scale=scale, size=[10, 2]).tolist()) 
                        for loc, scale in contents]
geo_df.set_geometry('raw_points', inplace=True) # inplace=True表示对原数据进行更新

# 绘制第一图层
ax = geo_df.plot(color='red')
geo_df['convex_hull'] = geo_df.convex_hull
# 切换矢量主列
geo_df.set_geometry('convex_hull', inplace=True)
# 绘制第二图层
geo_df.plot(ax=ax, color='blue', alpha=0.4)
plt.show()

# 2.2.2 GeoDataFrame数据索引
# 作为pandas.DataFrame的延伸，GeoDataFrame同样支持pandas.DataFrame中的.loc以及.iloc对数据在行、
# 列尺度上进行索引和筛选，这里我们以geopandas自带的世界地图数据为例：
world = gpd.read_file(gpd.datasets.get_path('naturalearth_lowres'))
world.plot()
plt.show()
# 查看其表格内容：
world.head()
# 使用.loc+条件筛选选择数据:
world.loc[world['pop_est'] >= 1000000000,['pop_est','name']] # 选出人口大于10的行，显示pop_est和name列
# 使用.iloc选择数据：
world.iloc[:10,:4] # 显出前10行，前4列

# 而除了这些常规的数据索引方式之外，geopandas为GeoDataFrame添加了.cx索引方式，可以传入所需的空间范围，
# 用于索引与传入范围相交的对应数据：
# 选择与东经80度-110度，北纬0度-30度范围相交的几何对象
part_world = world.cx[80:110, 0:30]

# 绘制第一图层：世界地图
ax = world.plot(alpha=0.05)
# 绘制第二图层：.cx所选择的地区
ax = part_world.plot(ax=ax, alpha=0.6)
# 绘制第三图层：.cx条件示意图
ax = gpd.GeoSeries([geometry.box(minx=80, miny=0, maxx=110, maxy=30).boundary])\
    .plot(ax=ax, color='red')
plt.show()

#########################################geopandas读取数据##########################################
import geopandas as gpd

# geopandas将fiona作为操纵矢量数据读写功能的后端，使用geopandas.read_file()读取对应类型文件，而在后端实际上是使用
# fiona.open来读入数据，即两者参数是保持一致的，读入的数据自动转换为GeoDataFrame，下面是geopandas.read_file()主要参数：

# filename：str类型，传入文件对应的路径或url
# layer：str类型，当要读入的数据格式为地理数据库.gdb或QGIS中的.gpkg时，传入对应图层的名称

##### 多行数据合并 #####

# 原始数据`china.shp`中每个要素不是单独的省份而是面，即有的包含众多岛屿的省份会由若干行共同构成，因此使用`geopandas`地理
# 操作中的融合`dissolve()`按照`OWNER`列融合分离的面为多面，从而使得每一行是对应的完整的省份，关于更多地理操作将会在后续的对应的文章介绍）：
# `dissolve()`:将多行显示同一个地区的`geometry`合并到一行显示,一行都是一个完整的省份`geometry`信息,省份不再多行显示而重复;

##### 关于dissolve#####
from shapely.geometry import Point
d = {
    "col1": ["name1", "name2", "name1"],
    "geometry": [Point(1, 2), Point(2, 1), Point(0, 1)],
}
d
gdf = gpd.GeoDataFrame(d, crs=4326)
gdf
dissolved = gdf.dissolve('col1')
dissolved  # doctest: +SKIP


import matplotlib.pyplot as plt
import geopandas as gpd
import pandas as pd
import numpy as np
import libpysal
import os
## pandas读入xlsx数据,然后使用geopandas转化为shp格式
os.chdir(r"E:\BaiduNetdiskWorkspace\郑大")
os.system('start .')
df = pd.read_excel("geff_markev.xlsx")
gdf = gpd.GeoDataFrame(df,geometry=gpd.points_from_xy(df.longitude, df.latitude))
gdf.crs = 'EPSG:4326'
gdf.to_file('geff_markev.shp',driver='ESRI Shapefile',encoding='utf-8')










## 读入地级市地图数据
os.chdir(r"F:\Books\python\pySAL\columbus\地市4902")
city = gpd.read_file('CN-shi-A.shp')  # 4902行合并到340行
city.head()
city['CityNameC'] # 该列是城市名称,有很多重复项,每个市不止一行;
# 由于每行数据是单独的面，因此按照其城市列'CityNameC'融合
city = city.dissolve(by='CityNameC')
city

## 385各地级市的还有重复,用dissolve
os.chdir(r"E:\BaiduNetdiskWorkspace\郑大\地图数据\中国地级市地图-385")
city = gpd.read_file('city.shp')  # 4902行合并到340行
city.crs
city.head()
city['NAME'] # 该列是城市名称,有几个城市重复,每个市不止一行;
# 由于每行数据是单独的面，因此按照其城市列'NAME'融合
city = city.dissolve(by='NAME')
city.to_file('city.shp',encoding='utf-8')