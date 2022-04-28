
'''折线图条形图组合:补贴总额和平均补贴'''
import pandas as pd
from pyecharts.faker import Faker
from pyecharts.commons.utils import JsCode
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
Z1 = list(data['补贴金额（亿元）'])
Y1 = []
for i in Z1:
    Y1.append(float('%.2f'%i)) # 总补贴金额（亿元） 条形图数据
Z2 = list(data['平均每家公司补贴'])
Y2 = []
for i in Z2:
    Y2.append(float('%.2f'%i)) # 平均每家公司补贴（亿元） 折线图数据

def grid_multiy():
    bar=(
        Bar()
        .add_xaxis(xaxis_data=X)
        .add_yaxis(
            series_name='上市公司获得总补贴(亿元)',
            yaxis_data=Y1,
            color='#5793f3', #蓝色
            label_opts=opts.LabelOpts(is_show=False),
            )
        .extend_axis(
            yaxis=opts.AxisOpts(
                name='平均补贴',
                type_='value',
                min_=0.2,
                max_=0.8,
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
                name='总补贴',
                position='left',
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
            graphic_opts=[
                opts.GraphicGroup(
                    graphic_item=opts.GraphicItem(
                        left="23%",
                        top="12%",
                    ),
                    children=[
                        opts.GraphicRect(
                            graphic_item=opts.GraphicItem(
                                z=50,
                                left="center",
                                top="middle",
                            ),
                            graphic_shape_opts=opts.GraphicShapeOpts(
                                width=190, height=90,
                            ),
                            graphic_basicstyle_opts=opts.GraphicBasicStyleOpts(
                                fill="#fff",
                                stroke="#555",
                                line_width=2,
                                shadow_blur=8,
                                shadow_offset_x=3,
                                shadow_offset_y=3,
                                shadow_color="rgba(0,0,0,0.3)",
                            )
                        ),
                        opts.GraphicText(
                            graphic_item=opts.GraphicItem(
                                left="center",
                                top="middle",
                                z=50,
                            ),
                            graphic_textstyle_opts=opts.GraphicTextStyleOpts(
                                text=JsCode(
                                    "['受2008年金融危机的影响，',"
                                    "'国家出台了一系列刺激计划，',"
                                    "'这其中也包括为了帮助上市',"
                                    "'公司度过难关的各种补贴。'].join('\\n')"
                                ),
                                font="14px Microsoft YaHei",
                                graphic_basicstyle_opts=opts.GraphicBasicStyleOpts(
                                    fill="#333"
                                )
                            )
                        )
                    ]
                )
            ],
        ) # 此处不能多加逗号，否则会结果对象会改变，由一个Bar对象变为多个Bar构成的tuple集合；
    )
    line=(
        Line()
        .add_xaxis(xaxis_data=X)
        .add_yaxis(
            series_name='每家上市公司获得的平均补贴（亿元）',
            y_axis=Y2,
            yaxis_index=1,  #多Y轴时，要设置此项；
            label_opts=opts.LabelOpts(is_show=False), 
            z=100,
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
    bar.overlap(line)
    return bar
                                # 函数不能多一个括号
grid_multiy().render()
grid_multiy().render(r"E:\学术论文\博士论文\论文图表\图2-1上市公司获得补贴数据1.html")
make_snapshot(snapshot,grid_multiy().render(),r"E:\学术论文\博士论文\论文图表\图2-1上市公司获得补贴数据1.png")