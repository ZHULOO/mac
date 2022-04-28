'''折线图条形图组合:R&D经费、人员投入及强度'''
import pandas as pd
from pyecharts import options as opts
from pyecharts.charts import Line
from pyecharts.charts import Bar
from pyecharts.charts import Grid
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot

# 导入数据:
datafile = r'E:\学术论文\博士论文\论文图表\研发经费人员投入及GDP占比.xlsx'
data = pd.read_excel(datafile)
X = list(data.年份) # 或者attr = list(data.['年份'])
Z1 = list(data['R&D经费支出（亿元）'])
Y1 = []
for i in Z1:
    Y1.append(float('%.2f'%i)) # R&D经费投入

Z2 = list(data['R&D经费占GDP的比例'])
Y2 = []
for i in Z2:
    Y2.append(float('%.2f'%i)) # 投入强度

Z3 = list(data['R&D人员（万人）'])
Y3 = []
for i in Z3:
    Y3.append(float('%.2f'%i)) # 投入强度



def grid_multiy():
    bar=(
        Bar()
        .add_xaxis(xaxis_data=X)
        .add_yaxis(
            series_name='R&D人员投入(万人)',
            yaxis_data=Y3,
            yaxis_index=2,
            label_opts=opts.LabelOpts(is_show=False),
            color='#5793f3',
            )
        
        .add_yaxis(
            series_name = 'R&D经费投入(亿元)',
            yaxis_data=Y1,
            yaxis_index=0,
            label_opts=opts.LabelOpts(is_show=False),
            #color='#d14a61', # 注意此处不能设置颜色,否则会和上面的颜色反转...
        )
        .extend_axis( # 强度坐标轴 yaxis_index = 1
            yaxis=opts.AxisOpts(
                name='强度',
                type_='value',
                min_=1,
                max_=2.5,
                position='right',
                name_textstyle_opts=opts.TextStyleOpts(
                    font_size=15,
                    font_weight='bold',
                    color='#749f83',
                ),
                axislabel_opts=opts.LabelOpts(
                    font_size=12,
                    color='#749f83'
                ),
                axisline_opts=opts.AxisLineOpts(
                    linestyle_opts=opts.LineStyleOpts(
                        color='#749f83',
                    ),
                ),
            )
        )
        .extend_axis( # 左侧研发人员投入坐标轴 yaxis_index = 2
            yaxis=opts.AxisOpts(
                name='人员',
                type_='value',
                min_=150,
                max_=450,
                position='left',
                name_textstyle_opts=opts.TextStyleOpts(
                    font_size=15,
                    font_weight='bold',
                    color='#5793f3', #蓝色
                ),
                axislabel_opts=opts.LabelOpts(
                    font_size=12,
                    color='#5793f3'
                ),
                axisline_opts=opts.AxisLineOpts(
                    linestyle_opts=opts.LineStyleOpts(
                        color='#5793f3',
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
            yaxis_opts=opts.AxisOpts( # yaxis_index = 0
                name='经费',
                position='left',
                offset=35,
                name_textstyle_opts=opts.TextStyleOpts(
                    font_size=15,
                    font_weight='bold',
                    color='#d14a61',
                ),
                axislabel_opts=opts.LabelOpts(
                    font_size=12,
                    color='#d14a61',
                ),
                axisline_opts=opts.AxisLineOpts(
                    linestyle_opts=opts.LineStyleOpts(
                        color='#d14a61',
                    ),
                ),
            ),
        ) # 此处不能多加逗号，tuple集合；
    )

    line=(
        Line()
        .add_xaxis(xaxis_data=X)
        .add_yaxis(
            series_name='R&D投入强度（占GDP比重）',
            y_axis=Y2,
            yaxis_index=1,  #多Y轴时，要设置此项；
            label_opts=opts.LabelOpts(is_show=False),
            linestyle_opts=opts.LineStyleOpts(
                color='#749f83', #青绿色
            ),
            
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

make_snapshot(snapshot,grid_multiy().render(),r"E:\学术论文\博士论文\论文图表\图2-10R&D投入及GDP占比.png")










def grid_multiy():
    bar=(
        Bar()
        .add_xaxis(xaxis_data=X)
        .add_yaxis(
            series_name='R&D人员投入(万人)',
            yaxis_data=Y3,
            label_opts=opts.LabelOpts(is_show=False),
            color='#5793f3', 
        )
        .add_yaxis(
            series_name='R&D经费投入(亿元)', #第二个系列不能有颜色,否则回反转
            yaxis_data=Y1,
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
    return bar

grid_multiy().render()


def grid_mutil_yaxis() -> Grid:
    x_data = ["{}月".format(i) for i in range(1, 13)]
    bar = (
        Bar()
        .add_xaxis(x_data)
        .add_yaxis(
            "蒸发量",
            [2.0, 4.9, 7.0, 23.2, 25.6, 76.7, 135.6, 162.2, 32.6, 20.0, 6.4, 3.3],
            yaxis_index=0,
            color="#5793f3",
        )
        .add_yaxis(
            "降水量",
            [2.6, 5.9, 9.0, 26.4, 28.7, 70.7, 175.6, 182.2, 48.7, 18.8, 6.0, 2.3],
            yaxis_index=0,
            #color="#5793f3",
        )
    )
    return bar

grid_mutil_yaxis().render()