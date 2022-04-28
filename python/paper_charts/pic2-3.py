'行业分布折线图'
import pandas as pd
from pyecharts import options as opts
from pyecharts.charts import Line
from pyecharts.charts import Bar
from pyecharts.charts import Grid
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot

# 导入数据:
datafile = r'E:\学术论文\博士论文\论文图表\行业补贴数据.xlsx'
data = pd.read_excel(datafile)
X = list(data.行业)
Y1 = list(data['2011年'])
Y2 = list(data['2012年'])
Y3 = list(data['2013年'])
Y4 = list(data['2014年'])
Y5 = list(data['2015年'])
Y6 = list(data['2016年'])

line=(
    Line(
        init_opts=opts.InitOpts(
            width='900px',
            height='500px',
        )
    )
    .add_xaxis(xaxis_data=X)
    .add_yaxis(
        series_name='2011年',
        y_axis=Y1,
        label_opts=opts.LabelOpts(is_show=False),
        linestyle_opts=opts.LineStyleOpts(
            width=1,
        )
    )
    .add_yaxis(
        series_name='2012年',
        y_axis=Y2,
        symbol='rect',
        label_opts=opts.LabelOpts(is_show=False),
        linestyle_opts=opts.LineStyleOpts(
            width=1,
        )
    )
    .add_yaxis(
        series_name='2013年',
        y_axis=Y3,
        symbol='roundRect',
        label_opts=opts.LabelOpts(is_show=False),
        linestyle_opts=opts.LineStyleOpts(
            width=1,
        )
    )
    .add_yaxis(
        series_name='2014年',
        y_axis=Y4,
        symbol='triangle',
        label_opts=opts.LabelOpts(is_show=False),
        linestyle_opts=opts.LineStyleOpts(
            width=1,
        )
    )
    .add_yaxis(
        series_name='2015年',
        y_axis=Y5,
        symbol='diamond',
        label_opts=opts.LabelOpts(is_show=False),
        linestyle_opts=opts.LineStyleOpts(
            width=1,
        )
    )
    .add_yaxis(
        series_name='2016年',
        y_axis=Y6,
        symbol='pin',
        label_opts=opts.LabelOpts(is_show=False),
        linestyle_opts=opts.LineStyleOpts(
            width=1,
        )
    )
    .set_global_opts(
        title_opts=opts.TitleOpts(
            #title='图2.3 历年政府对各行业上市公司补贴金额占比',
            title_textstyle_opts=opts.TextStyleOpts(
                font_size=25,
            ),
            pos_left='center',
            pos_bottom='bottom',
        ),
        legend_opts=opts.LegendOpts(
            #orient='vertical',
            textstyle_opts=opts.TextStyleOpts(
                font_size=20,
            ),
            pos_top='10%',
        ),
        yaxis_opts=opts.AxisOpts(
            name='占比（%）',
            name_textstyle_opts=opts.TextStyleOpts(
                font_size=20,
                font_weight='bold',
            ),
            is_scale=True,
            axislabel_opts=opts.LabelOpts(
                font_size=15,
            ),
        ),
        xaxis_opts=opts.AxisOpts(
            name='行业',
            name_textstyle_opts=opts.TextStyleOpts(
                font_size=20,
                font_weight='bold',
            ),
            axislabel_opts=opts.LabelOpts(
                font_size=12,
                rotate=-24,
            ),
        ),
    )
)
grid=( #                    用grid控制标题覆盖x轴标签的问题；
    Grid()
    .add(
        chart=line,
        grid_opts=opts.GridOpts(pos_bottom="20%"), # 图像距容器底部20%，x轴标签和标题不再重叠；
    )
)

grid.render()
grid.render(r"E:\学术论文\博士论文\论文图表\图2-3各行业获得补贴比例.html")
make_snapshot(snapshot,grid.render(),r"E:\学术论文\博士论文\论文图表\图2-3各行业获得补贴比例.png")