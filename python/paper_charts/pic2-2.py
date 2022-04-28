'''获补贴上市公司数量、占比、总公司数量'''
import pandas as pd
from pyecharts import options as opts
from pyecharts.charts import Line
from pyecharts.charts import Bar
from pyecharts.charts import Grid
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot

# 导入数据:
datafile = r'E:\学术论文\博士论文\论文图表\政府补贴现状数据.xlsx'
data = pd.read_excel(datafile)
X = list(data.年份) # 或者attr = list(data.['年份'])

Z1 = list(data['补贴公司数'])
Y1 = []
for i in Z1:
    Y1.append(float('%.2f'%i)) # 总补贴公司总数数据；

Z2 = list(data['上市公司总数'])
Y2 = []
for i in Z2:
    Y2.append(float('%.2f'%i)) # 上市公司总数数据；

Z3 = list(data['补贴公司占比'])
Y3 = []
for i in Z3:
    Y3.append(float('%.2f'%i)) # 获取补贴公司占总上市公司比重；

def grid_multiy():
    bar=(
        Bar()
        .add_xaxis(xaxis_data=X)
        .add_yaxis(
            series_name='获得补贴公司总数（家）',
            yaxis_data=Y1,
            yaxis_index=0,
            color='#5793f3', #蓝色
            label_opts=opts.LabelOpts(is_show=False),
            )
        .add_yaxis(
            series_name='上市公司总数（家）',
            yaxis_data=Y2,
            yaxis_index=0,
            color='#d14a61', #红色
            label_opts=opts.LabelOpts(is_show=False),
            )
        .extend_axis(
            yaxis=opts.AxisOpts(
                name='占比',
                type_='value',
                min_=0.7,
                max_=1.0,
                position='right',
                name_textstyle_opts=opts.TextStyleOpts(
                    font_size=20,
                    font_weight='bold',
                    color='#675bba', #淡紫色
                ),
                axislabel_opts=opts.LabelOpts(
                    font_size=15,
                    color='#675bba'
                ),
                axisline_opts=opts.AxisLineOpts(
                    linestyle_opts=opts.LineStyleOpts(
                        color='#675bba',
                    ),
                ),
            )
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
                name='公司数量',
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

    line=(
        Line()
        .add_xaxis(xaxis_data=X)
        .add_yaxis(
            series_name='获得补贴上市公司占总上市公司的比重',
            y_axis=Y3,
            yaxis_index=1,  #多Y轴时，要设置此项；
            label_opts=opts.LabelOpts(is_show=False), #不显示数据标签；
            linestyle_opts=opts.LineStyleOpts(
                color='#675bba',
                width=1,
            ),
        )
        .set_global_opts(
            legend_opts=opts.LegendOpts(
                orient='vertical',
                textstyle_opts=opts.TextStyleOpts(
                    font_size=20,
                ),
            ),
            yaxis_opts=opts.AxisOpts(
                min_=0.7,
                max_=1.0,
            ),
        )
    )

    bar.overlap(line)
    return bar
                                # 函数不能多一个括号
grid_multiy().render()
grid_multiy().render(r"E:\学术论文\博士论文\论文图表\图2-2获得补贴上市公司数.html")
make_snapshot(snapshot,grid_multiy().render(),r"E:\学术论文\博士论文\论文图表\图2-2获得补贴上市公司数.png")