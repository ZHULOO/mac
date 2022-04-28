'''折线图条形图组合:R&D经费、人员投入及强度'''
import pandas as pd
from pyecharts import options as opts
from pyecharts.charts import Line
from pyecharts.charts import Bar
from pyecharts.charts import Grid
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot

# 导入数据:
datafile = r'E:\学术论文\博士论文\论文图表\上市公司创新产出数据.xlsx'
data = pd.read_excel(datafile)
X = list(data.年份) # 或者attr = list(data.['年份'])
Z1 = list(data['发明'])
Z2 = list(data['实用新型'])
Z3 = list(data['外观'])




def grid_multiy():
    bar=(
        Bar()
        .add_xaxis(xaxis_data=X)
        .add_yaxis(
            series_name='发明（件）',
            yaxis_data=Z1,
            label_opts=opts.LabelOpts(is_show=False),
            color='#5793f3',
        )        
        .add_yaxis(
            series_name = '实用新型（件）',
            yaxis_data=Z2,
            label_opts=opts.LabelOpts(is_show=False),
            #color='#d14a61', # 注意此处不能设置颜色,否则会和上面的颜色反转...
        )
        .add_yaxis(
            series_name = '外观（件）',
            yaxis_data=Z3,
            label_opts=opts.LabelOpts(is_show=False),
            #color='#d14a61', # 注意此处不能设置颜色,否则会和上面的颜色反转...
        )
        .set_global_opts(
            legend_opts=opts.LegendOpts(
                orient='vertical',
                textstyle_opts=opts.TextStyleOpts(
                    font_size=20,
                ),
            ),
            yaxis_opts=opts.AxisOpts( # yaxis_index = 0
                name='数量',
                position='left',
                #offset=35,
                name_textstyle_opts=opts.TextStyleOpts(
                    font_size=15,
                    font_weight='bold',
                    #color='#d14a61',
                ),
                axislabel_opts=opts.LabelOpts(
                    font_size=12,
                    #color='#d14a61',
                ),
                axisline_opts=opts.AxisLineOpts(
                    linestyle_opts=opts.LineStyleOpts(
                        #color='#d14a61',
                    ),
                ),
            ),
        ) # 此处不能多加逗号，tuple集合；
    )
    return bar
                                # 函数不能多一个括号
grid_multiy().render()

make_snapshot(snapshot,grid_multiy().render(),r"E:\学术论文\博士论文\论文图表\图2-13企业创新产出.png")