'''河南省各地市指数热力图'''
import sys
import pandas as pd
from pyecharts.charts import Map
from pyecharts import options as opts
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot
# 定义画图函数：
def map_base(data,title,year,min1,max1):
    map=(
        Map()
        .add(
            series_name=year, # 位置和字体等在legend中设置；
            data_pair=data,
            maptype='河南',
        )
        #.set_series_opts(label_opts=opts.LabelOpts(is_show = False))
        .set_global_opts(
            title_opts = opts.TitleOpts(
                title = title,
                pos_left= '25%',
            ),
            legend_opts=opts.LegendOpts(
                pos_top='5%',
                pos_left= '40%', # 可以设置series_name内容的字体和位置；
                textstyle_opts = opts.TextStyleOpts(
                    #font_size = 14,
                    #font_weight = 'bold',
                ),
            ),
            visualmap_opts=opts.VisualMapOpts(
                max_=max1,
                min_=min1,
                split_number=3,
                is_piecewise='True',
                pos_left='25%',
                pos_bottom='10%',
            ),
        )
    )
    return map
# map_base(dic).render(r"E:\学术论文\博士论文\论文图表\map.html")

if __name__ == "__main__":
    filename = sys.argv[1]
    datafile = r'E:\学术论文\zhaojian\{0}.xlsx'.format(filename)
    data = pd.read_excel(datafile)
    X = data['地区']
    title = filename[4:9:]
    Z = list(data['{0}'.format(title)])
    Y1 = []
    for i in Z:
        Y1.append(float('%.4f'%i))
    dic = [list(z) for z in zip(X, Y1)] # 生成成对的字典型数据;
    year = filename[:4:]+'年'
    title1 = year + title
    min1 = min(Y1)
    max1 = max(Y1)
    #map_base(dic,title,year,min1,max1).render(r'E:\学术论文\zhaojian\{0}.html'.format(filename))
    make_snapshot(snapshot,map_base(dic,title,year,min1,max1).render(),r'E:\学术论文\zhaojian\{0}.png'.format(filename))

"""
datafile = r'E:\学术论文\zhaojian\2009耦合指数.xlsx'
data = pd.read_excel(datafile)
X = data['地区']
Z = list(data['耦合指数'])
Y1 = []
for i in Z:
    Y1.append(float('%.4f'%i))
min1 = min(Y1)
max1 = max(Y1)
dic = [list(z) for z in zip(X, Y1)] # 生成成对的字典型数据;
title = filename[:4:]+'年'
"""

# 2022.4.15
# 批量运行画图基本公共服务供给水平 year in list(2011,2012,2013,2014,2015,2016,2017,2018,2019,2020)
import os
import time
os.chdir(r"E:\BaiduNetdiskWorkspace\others'data\zhaojian")
os.getcwd()
for year in range(2011,2021):
    os.system("python zhaojian_public.py {0}基本公共服务供给水平".format(year))
    time.sleep(10)