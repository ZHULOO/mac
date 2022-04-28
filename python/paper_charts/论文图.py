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

'''生成3D散点图'''
# 生成3D散点图,定义函数,链式调用:
import random
from pyecharts.faker import Faker
from pyecharts import options as opts
from pyecharts.charts import Scatter3D

def scatter3d_base() -> Scatter3D:
    data = [
        [random.randint(0, 100), random.randint(0, 100), random.randint(0, 100)]
        for _ in range(80)
    ]
    c = (
        Scatter3D()
        .add("", data)
        .set_global_opts(
            title_opts=opts.TitleOpts("Scatter3D-ZHULOO"),
            visualmap_opts=opts.VisualMapOpts(range_color=Faker.visual_color),
        )
    )
    return c
scatter3d_base().render() #运行上面生成的函数,然后render方法生成html文件;

'''Map地图'''
import pandas as pd
from pyecharts.charts import Map
from pyecharts import options as opts
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot
datafile = 'E:\\mycode\\python\\gdp.xlsx'
data = pd.read_excel(datafile)
z = [list(z) for z in zip(data.province, data.gdp)] # 生成成对的字典型数据;
def map_base(data):
    map=(
        Map()
        .add(
            series_name="",
            data_pair=data,
            maptype='china',
        )
        .set_global_opts(
            title_opts=opts.TitleOpts(
                title='全国各省经济发展情况',
                title_textstyle_opts=opts.TextStyleOpts(font_size=20),
                pos_left='center',
                pos_top='bottom',                    
            ),
            legend_opts=opts.LegendOpts(
                pos_top='10%',
            ),
            visualmap_opts=opts.VisualMapOpts(
                max_=67000,
                is_piecewise='True',
                pos_left='10%',
                pos_bottom='5%',
            ),
        )
    )
    return map
map_base(z).render()
map_base(z).render(r"E:\学术论文\博士论文\论文图表\map.html")
make_snapshot(snapshot,map_base(z).render(),"map.png")


'''以折线图为例对各项配置的使用说明'''
import pandas as pd
from pyecharts import options as opts
from pyecharts.charts import Line
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot
datafile = r'E:\学术论文\博士论文\论文图表\企业创新主体数据\企业创新数据.xlsx'
data = pd.read_excel(datafile)
attr = list(data['年份'])                # 注意此处X轴一定要对应字符型,list的元素一定要是字符型.'2008'纯数字时一定要加引号;
value = list(data['企业R&D经费支出占比'])
z = []
for i in value:
    z.append(float('%.4f'%i)) # 格式四位小数

line = Line()                                                       # 生成折线图对象;
line.add_xaxis(                                                     # 添加x轴,数值为attr(attr要求是分类型,字符型变量);
    xaxis_data=attr,
)
line.add_yaxis(                                                     # 添加y轴,下面为y轴参数;
    series_name ='',                                                # y轴标题,也就是图例标题,此时只有一个指标,未设置图例;
    y_axis=z,
    markline_opts=opts.MarkLineOpts(                                # 给y轴添加标记线
        data=[
            opts.MarkLineItem(name='标准线',y=0.60),                # 添加多条标记线的时候,直接在下面接MarkLineItem项就可以了;对应的有标记点和区域,MarkPoint和MarkArea;
            #opts.MarkLineItem(name='第二条标准线',y=0.67),
        ],
    ),
)
line.set_global_opts(
    title_opts= opts.TitleOpts(                                     # 标题设置参数;
        title='图1.1 我国企业历年R&D研发经费支出占比变化情况',
        title_textstyle_opts=opts.TextStyleOpts(font_size=25),
        pos_left='center',
        pos_bottom='bottom'
    ),
    legend_opts=opts.LegendOpts(                                    # 图例设置参数;
        pos_left='center',                                          # 图例横向居中,有left,center和right选项,或者'20%'
        pos_top='top',
        textstyle_opts=opts.TextStyleOpts(font_weight='bold'),
    ),
    yaxis_opts=opts.AxisOpts(                                       # y轴参数;
        name='占比',                                                # y轴名称;
        name_textstyle_opts=opts.TextStyleOpts(
            font_size=20,
            font_weight='bold',
            ), # y轴名称黑体显示;
        is_scale='True',                                            # y轴刻度不必从0开始;
        min_interval=0.63,                                          # 最小刻度间隔从0.54-0.63;
        min_=0.54,                                                  # 最小刻度从0.54开始;
        max_=0.72,                                                  # 最大刻度到0.72终止;
        axispointer_opts=opts.LabelOpts(font_size=20),
        axislabel_opts=opts.LabelOpts(font_size=15),
    ),   
    xaxis_opts=opts.AxisOpts(                                       # x 轴参数;
        name='年份',                                                 # x轴名称
        name_textstyle_opts=opts.TextStyleOpts(
            font_size=20,
            font_weight='bold',
            ),
        axispointer_opts=opts.AxisPointerOpts(                      # 坐标轴指示器 （axisPointer）指的是，鼠标悬浮到坐标系上时出现的交叉指示线、阴影区域等。它能帮助用户观察数据。
            is_show='True',
            label=opts.LabelOpts(
                font_size=12,
            ),
        ),
        axislabel_opts=opts.LabelOpts(font_size=15),                # 坐标轴标签配置项;
    ),
)
line.render() 
line.render(r"E:\学术论文\博士论文\论文图表\图1-1企业R&D经费支出占比.html")
make_snapshot(snapshot,line.render(),r"E:\学术论文\博士论文\论文图表\图1-1企业R&D经费支出占比.png")

'''折线图条形图组合:补贴总额和平均补贴'''
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
grid_multiy().render(r"E:\学术论文\博士论文\论文图表\图2-1上市公司获得补贴数据.html")
make_snapshot(snapshot,grid_multiy().render(),r"E:\学术论文\博士论文\论文图表\图2-1上市公司获得补贴数据.png")

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
                font_size=13,
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

















'''练习代码'''
line=(
    Line()
    .add_xaxis(xaxis_data=X)
    .add_yaxis(
        series_name='平均每家上市公司获得补贴（右轴）',
        y_axis=Y2,
        )
    .set_global_opts(
        title_opts=opts.TitleOpts(
            title='图2.1 上市公司获得政府补贴及每家公司平均获得补贴金额（亿元）',
            title_textstyle_opts=opts.TextStyleOpts(
                font_size=25,
            ),
            pos_left='center',
            pos_bottom='bottom',
        ),
        yaxis_opts=opts.AxisOpts(
            name='平均补贴',
            name_textstyle_opts=opts.TextStyleOpts(
                font_size=20,
                font_weight='bold',
            ),
            is_scale='True',
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

line.render()

bar = (
    Bar()
    .add_xaxis(xaxis_data=X)
    .add_yaxis(
        series_name="上市公司获得政府总补贴",
        yaxis_data=Y1,
        color='#5793f3',
    )
    .set_global_opts(
        yaxis_opts=opts.AxisOpts(
            name='总补贴',
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

bar.render()








line=(
    Line()
    .add_xaxis(xaxis_data=X)
    .add_yaxis(
        series_name='每家上市公司获得的平均补贴',
        y_axis=Y2,
        label_opts=opts.LabelOpts(is_show=False),
    )
)
line.render()


line=(
    Line()
    .add_xaxis(xaxis_data=X)
    .add_yaxis(
        series_name='平均每家上市公司获得补贴（右轴）',
        y_axis=Y2,
        )
)
line.render()



bar=(
    Bar()
    .add_xaxis(xaxis_data=X)
    .add_yaxis(
        series_name='上市公司获得总补贴',
        y_axis=Y1,
        color='#5793f3',
    )
)

    .extend_axis(
        yaxis=opts.AxisOpts(
            name='平均补贴',
            type_='value',
            min_=0.2,
            max_=0.8,
            position='right',
        )
    )
)

line=(
    Line()
    .add_xaxis(xaxis_data=X)
    .add_yaxis(
        series_name='每家上市公司获得的平均补贴',
        y_axis=Y2,
        label_opts=opts.LabelOpts(is_show=False), 
    )
    .set_global_opts(
        yaxis_opts=opts.AxisOpts(
            name='平均补贴',
            type_='value',
            min_=0.2,
            max_=0.8,
            position='right',
            offset=10,
            split_number=5,
            axisline_opts=opts.AxisLineOpts(
                linestyle_opts=opts.LineStyleOpts(
                    color='#675bba',
                ),
            )
        )
    )
)
line.render()