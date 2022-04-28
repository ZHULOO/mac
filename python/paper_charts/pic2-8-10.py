'''R&D人员'''
import pandas as pd
from pyecharts import options as opts
from pyecharts.charts import Bar
from pyecharts.charts import Grid
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot

# 导入数据:
datafile = r'E:\学术论文\博士论文\论文图表\R&D人员.xlsx'
data = pd.read_excel(datafile)
X = list(data.年份)

Z1 = list(data['R&D人员（万人）'])
Y1 = []
for i in Z1:
    Y1.append(float('%.2f'%i))

def grid_multiy():
    bar=(
        Bar()
        .add_xaxis(xaxis_data=X)
        .add_yaxis(
            series_name='R&D人员数（万人）',
            yaxis_data=Y1,
            yaxis_index=0,
            color='#5793f3', #蓝色
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
                name='R&D人员数',
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

grid_multiy().render(r"E:\学术论文\博士论文\论文图表\图2-8R&D人员数.html")
make_snapshot(snapshot,grid_multiy().render(),r"E:\学术论文\博士论文\论文图表\图2-8R&D人员数.png")