'''六省效率指数热力图'''
# 使用方法：python zhaojian_202203.py 2020耦合度
import sys
import pandas as pd
from pyecharts.charts import Map
from pyecharts import options as opts
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot
# 定义画图函数：
def map_base(data,title,year,min1,max1,p1,p2):
    map=(
        Map()
        .add(
            series_name=year, # 位置和字体等在legend中设置；
            data_pair=data,
            maptype='china',
            label_opts = opts.LabelOpts(is_show=False),
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
                pieces=[
                    {"min":p2,"max":max1,"label":"高"},
                    {"min":p1,"max":p2,"label":"中"},
                    {"min":min1,"max":p1,"label":"低"},
                ],
                pos_left='25%',
                pos_bottom='10%',
            ),
        )
    )
    return map

if __name__ == "__main__":
    filename = sys.argv[1]
    datafile = r'/Users/zhulu/Files/data/Others/zhaojian/{0}.xls'.format(filename)
    data = pd.read_excel(datafile)
    X = data['地区']
    title = filename[4:8:]
    Z = list(data['{0}'.format(title)])
    Y1 = []
    for i in Z:
        Y1.append(float('%.4f'%i))
    dic = [list(z) for z in zip(X, Y1)] # 生成成对的字典型数据;
    year = filename[:4:]+'年'
    title1 = year + title
    min1 = min(Y1)
    max1 = max(Y1)
    p1 = min1 + (max1-min1)/3
    p2 = p1 + (max1-min1)/3
    make_snapshot(snapshot,map_base(dic,title,year,min1,max1,p1,p2).render(),r'/Users/zhulu/Files/data/Others/zhaojian/{0}.png'.format(filename))

'''
filename = "2020耦合度"
datafile = r'/Users/zhulu/Files/data/Others/zhaojian/{0}.xls'.format(filename)
data = pd.read_excel(datafile)
X = data['地区']
title = filename[4:8:]
Z = list(data['{0}'.format(title)])
Y1 = []
for i in Z:
    Y1.append(float('%.4f'%i))
dic = [list(z) for z in zip(X, Y1)] # 生成成对的字典型数据;
year = filename[:4:]+'年'
title1 = year + title
min1 = min(Y1)
max1 = max(Y1)
p1 = min1 + (max1-min1)/3
p2 = p1 + (max1-min1)/3
map_base(dic,title,year,min1,max1,p1,p2).render()
make_snapshot(snapshot,map_base(dic,title,year,min1,max1,p1,p2).render(),r'/Users/zhulu/Files/data/Others/zhaojian/{0}.png'.format(filename))
'''