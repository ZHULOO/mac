# python city_map.py agglo2005
from pyecharts import options as opts
from pyecharts.charts import Map
from pyecharts.faker import Faker
import sys
import pandas as pd
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot

def city_map(dic,year,min1,max1,p1,p2 ):
    c = (
        Map()
        .add(
            series_name = year,
            data_pair = dic,
            maptype = "china",
            label_opts = opts.LabelOpts(is_show=False),
            is_map_symbol_show = False,
        )
        .set_global_opts(
            title_opts=opts.TitleOpts(
                title = "产业集聚水平",
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
                # max_=max1,
                # min_=0,
                # split_number=3,
                # is_piecewise='True',
                # pieces=[
                #     {"min":p2,"max":max1,"label":"高"},
                #     {"min":p1,"max":p2,"label":"中"},
                #     {"min":min1,"max":p1,"label":"低"},
                # ],
                pos_left='25%',
                pos_bottom='10%',
            ),
        )
        .render("map_china_cities.html")
    )
    return c

if __name__ == "__main__":
    arg = sys.argv[1]
    filename = arg[0:5]
    datafile = r'/Users/zhulu/Files/data/郑大/%s.xlsx'%(filename)
    data = pd.read_excel(datafile)
    X = data['省份']
    year = arg[5:9]
    Z = list(data[int(year)])
    Y1 = []
    for i in Z:
        Y1.append(float('%.2f'%i))
    dic = [list(z) for z in zip(X, Y1)]
    min1 = min(Y1)
    max1 = max(Y1)
    p1 = min1 + (max1-min1)/3
    p2 = p1 + (max1-min1)/3
    make_snapshot(snapshot, city_map(dic,year,min1,max1,p1,p2), r'/Users/zhulu/Files/data/郑大/{0}.png'.format(arg))


'''
[list(z) for z in zip(Faker.guangdong_city, Faker.values())]
arg = "agglo2009"
filename = arg[0:5]
datafile = r'/Users/zhulu/Files/data/郑大/%s.xlsx'%(filename)
data = pd.read_excel(datafile)
X = data['城市']
year = arg[5:9]
Z = list(data[int(year)])
Y1 = []
for i in Z:
    Y1.append(float('%.2f'%i))
dic = [list(z) for z in zip(X, Y1)] # 生成成对的字典型数据;
'''