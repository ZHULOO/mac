'''2007-2017年间各区域政府对上市公司补贴数据饼图Pie'''
import pandas as pd
from pyecharts.commons.utils import JsCode
from pyecharts import options as opts
from pyecharts.charts import Pie
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot
# z = [list(z) for z in zip(Faker.choose(), Faker.values())]

# 导入数据:
datafile = r'E:\学术论文\博士论文\论文图表\分地区2007-2017A公司总补贴.xlsx'
data = pd.read_excel(datafile)
X = list(data.地区)

Z1 = list(data['补贴金额'])
Y1 = []
for i in Z1:
    Y1.append(float('%.2f'%i))
Y2 = list(data['公司数量'])

Z3 = list(data['补贴均值'])
Y3 = []
for i in Z3:
    Y3.append(float('%.2f'%i))

z1 = [list(z1) for z1 in zip(X, Y1)]
z2 = [list(z2) for z2 in zip(X, Y2)]
z3 = [list(z3) for z3 in zip(X, Y3)]

def pie_base() -> Pie:
    c = (
        Pie()
        .add(
            series_name = "公司数量(家)",
            data_pair = z2,
            center=['30%','30%'],
            radius=[50,80],
            )
        .add(
            series_name = "补贴金额(亿元)",
            data_pair = z1,
            center=['70%','30%'],
            radius=[50,80],
            )
        .add(
            series_name = "平均补贴(亿元)",
            data_pair = z3,
            center=['30%','70%'],
            radius=[50,80],
            )
        .set_global_opts(
            title_opts=opts.TitleOpts(
                #title="Pie-基本示例",
                ),
            legend_opts=opts.LegendOpts(
                orient='vertical',
                textstyle_opts=opts.TextStyleOpts(
                    font_size=15,
                ),
                type_='plain',
                pos_top='60%',
                pos_left='70%',                
            ),
        )
        .set_series_opts(
            label_opts=opts.LabelOpts(
                formatter="{b} : {c}",
                font_size=15,
                ),
        )
    )
    return c
pie_base().render()
make_snapshot(snapshot,pie_base().render(),r"E:\学术论文\博士论文\论文图表\图2-6东中西补贴饼图.png")

