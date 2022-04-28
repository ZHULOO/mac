'''R&D投入经费中政府资金和企业资金'''
import pandas as pd
from pyecharts import options as opts
from pyecharts.charts import Bar
from pyecharts.charts import Grid
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot

# 导入数据:
datafile = r'E:\学术论文\博士论文\论文图表\R&D投入中政府和企业出资情况.xlsx'
data = pd.read_excel(datafile)
X = list(data.年份)

Z1 = list(data['R&D经费政府出资额（亿元）'])
Y1 = []
for i in Z1:
    Y1.append(float('%.2f'%i))

Z2 = list(data['R&D经费企业出资额（亿元）'])
Y2 = []
for i in Z2:
    Y2.append(float('%.2f'%i))

def grid_multiy():
    bar=(
        Bar()
        .add_xaxis(xaxis_data=X)
        .add_yaxis(
            series_name='政府出资（亿元）',
            yaxis_data=Y1,
            yaxis_index=0,
            color='#5793f3', #蓝色
            label_opts=opts.LabelOpts(is_show=False),
            )
        .add_yaxis(
            series_name='企业出资（亿元）',
            yaxis_data=Y2,
            yaxis_index=0,
            color='#d14a61', #红色
            label_opts=opts.LabelOpts(is_show=False),
            )
        .set_global_opts(
            legend_opts=opts.LegendOpts(
                orient='vertical',
                #textstyle_opts=opts.TextStyleOpts(
                    #font_size=20,
                #),
            ),
            title_opts=opts.TitleOpts(
                #title='图2.2 获得政府补贴上市公司数、上市公司总数及占比',
                title_textstyle_opts=opts.TextStyleOpts(
                    font_size=25,
                ),
                pos_left='center',
                pos_bottom='bottom',
            ),
            yaxis_opts=opts.AxisOpts(
                name='R&D投入',
                position='left',
                name_textstyle_opts=opts.TextStyleOpts(
                    font_size=20,
                    font_weight='bold',
                    color='#5793f3',
                ),
                is_scale='True',
                axislabel_opts=opts.LabelOpts(
                    font_size=15,
                    color='#5793f3',
                ),
                axisline_opts=opts.AxisLineOpts(
                    linestyle_opts=opts.LineStyleOpts(
                        color='#5793f3',
                    ),
                ),
            ),
        ) # 此处不能多加逗号，否则会结果对象会改变，由一个Bar对象变为多个Bar构成的tuple集合；
    )
    return bar  # 函数不能多一个括号

grid_multiy().render(r"E:\学术论文\博士论文\论文图表\图2-11R&D政府出资和企业出资.html")
make_snapshot(snapshot,grid_multiy().render(),r"E:\学术论文\博士论文\论文图表\图2-11R&D政府出资和企业出资.png")