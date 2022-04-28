'''折线图'''
# 引入包:
import pandas as pd
from pyecharts import options as opts
from pyecharts.charts import Line
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot
# 导入数据:
datafile = r'E:\学术论文\博士论文\论文图表\企业创新主体数据\企业创新数据.xlsx'
data = pd.read_excel(datafile)
attr = list(data.年份) # 或者attr = list(data.['年份'])
z = list(data['企业R&D经费支出占比'])
value = []
for i in z:
    value.append(float('%.4f'%i))
# 定义函数:
def line_base(attr,value):
    line=(
        Line()
        .add_xaxis(xaxis_data=attr)
        .add_yaxis(
            series_name='',
            y_axis=value,
            markline_opts=opts.MarkLineOpts(
                data=[
                    opts.MarkLineItem(
                        name='标准线',
                        y=0.60,
                    ),
                ]
            ),
        )
        .set_global_opts(
            title_opts=opts.TitleOpts(
                #title='图1.1 我国企业历年R&D经费占全国R&D总经费比重',
                title_textstyle_opts=opts.TextStyleOpts(
                    font_size=25,
                ),
                pos_left='center',
                pos_bottom='bottom',
            ),
            yaxis_opts=opts.AxisOpts(
                name='百分比',
                name_textstyle_opts=opts.TextStyleOpts(
                    font_size=20,
                    font_weight='bold',
                ),
                is_scale='True',
                min_=0.54,
                min_interval=0.63,
                max_=0.72,
                axislabel_opts=opts.LabelOpts(
                    font_size=15,
                ),
            ),
            xaxis_opts=opts.AxisOpts(
                name='年份',
                name_textstyle_opts=opts.TextStyleOpts(
                    font_size=20,
                    font_weight='bold',
                ),
                axislabel_opts=opts.LabelOpts(
                    font_size=15,
                ),
            ),
        )
    )
    return line
# 生成html和图片:
line_base(attr,value).render()
line_base(attr,value).render(r"E:\学术论文\博士论文\论文图表\图1-1企业R&D经费占比.html")
make_snapshot(snapshot,line_base(attr,value).render(),r"E:\学术论文\博士论文\论文图表\图1-1企业R&D经费占比.png")