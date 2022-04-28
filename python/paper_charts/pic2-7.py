'''散点图和条形图组合:各类性质企业补贴均值和中位数'''
import pandas as pd
from pyecharts import options as opts
from pyecharts.charts import Scatter
from pyecharts.charts import Bar
from pyecharts.charts import Grid
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot

# 导入数据:
datafile = r'E:\学术论文\博士论文\论文图表\按公司性质补贴.xlsx'
data = pd.read_excel(datafile)
X = list(data['企业类别'])
Z1 = list(data['中位数（亿元）'])
Y1 = []
for i in Z1:
    Y1.append(float('%.2f'%i))
Z2 = list(data['均值（亿元）'])
Y2 = []
for i in Z2:
    Y2.append(float('%.2f'%i))

def grid_multiy():
    bar=(
        Bar()
        .add_xaxis(xaxis_data=X)
        .add_yaxis(
            series_name='中位数（亿元）',
            yaxis_data=Y1,
            color='#5793f3', #蓝色
            label_opts=opts.LabelOpts(is_show=False),
            )
        .extend_axis(
            yaxis=opts.AxisOpts(
                name='均值（亿元）',
                type_='value',
                min_=0,
                max_=1.2,
                position='right',
                name_textstyle_opts=opts.TextStyleOpts(
                    font_size=20,
                    font_weight='bold',
                    color='#d14a61',
                ),
                #is_scale='True',
                axislabel_opts=opts.LabelOpts(
                    font_size=15,
                    color='#d14a61'
                ),
                axisline_opts=opts.AxisLineOpts(
                    linestyle_opts=opts.LineStyleOpts(
                        color='#d14a61',
                    ),
                ),
            )
        )
        .set_global_opts(
            legend_opts=opts.LegendOpts(
                orient='vertical',
                textstyle_opts=opts.TextStyleOpts(
                    font_size=20,
                ),
            ),
            title_opts=opts.TitleOpts(
                #title='图2.1 上市公司获得政府补贴及每家公司平均获得补贴金额',
                title_textstyle_opts=opts.TextStyleOpts(
                    font_size=25,
                ),
                pos_left='center',
                pos_bottom='bottom',
            ),
            yaxis_opts=opts.AxisOpts(
                name='中位数（亿元）',
                position='left',
                min_=0,
                max_=0.25,
                #offset=30,
                name_textstyle_opts=opts.TextStyleOpts(
                    font_size=20,
                    font_weight='bold',
                    color='#5793f3',
                ),
                #is_scale='True',
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
            xaxis_opts=opts.AxisOpts(
                axislabel_opts=opts.LabelOpts(
                    font_size=15,

                )
            )
        ) # 此处不能多加逗号，否则会结果对象会改变，由一个Bar对象变为多个Bar构成的tuple集合；
    )

    scatter=(
        Scatter()
        .add_xaxis(xaxis_data=X)
        .add_yaxis(
            series_name='均值（亿元）',
            y_axis=Y2,
            symbol='diamond',
            yaxis_index=1,  #多Y轴时，要设置此项；
            label_opts=opts.LabelOpts(is_show=False), 
        )
        .set_global_opts(
            legend_opts=opts.LegendOpts(
                orient='vertical',
                textstyle_opts=opts.TextStyleOpts(
                    font_size=20,
                ),
            ),
        )
    )

    bar.overlap(scatter)
    return bar
grid_multiy().render()
make_snapshot(snapshot,grid_multiy().render(),r"E:\学术论文\博士论文\论文图表\图2-7各类性质企业获得补贴情况.png")