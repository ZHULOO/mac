'''安装pyecharts:'''
pip install pyecharts

'''使用方法:'''
1、cd 进入E:\Mycode\python\example
2、python surface3d_example.py
3、将生成的render.html用浏览器打开

'''安装地图文件:'''
pip install echarts-countries-pypkg
pip install echarts-china-provinces-pypkg
pip install echarts-china-cities-pypkg
pip install echarts-china-counties-pypkg
pip install echarts-china-misc-pypkg
pip install echarts-united-kingdom-pypkg
pip install echarts-cities-pypkg

'''生成图片格式工具:'''
pip install pyecharts-snapshot

'''chromedriver.exe的安装'''
# chrome浏览器更新以后需要更新chromedriver.exe;
# 首先在 https://sites.google.com/a/chromium.org/chromedriver/downloads 下载最新的和chrome版本对应的chromedriver.exe;
# 然后分别复制到python安装目录"D:\Program Files\Anaconda\Scripts"和chrome浏览器安装目录下"C:\Program Files (x86)\Google\Chrome\Application".
# 如果依然出错，可将其复制一份到anaconda3文件夹也即python.exe同一个目录下，省去设置其path环境变量的麻烦；
import pyecharts # 加载pyecharts;
print(pyecharts.__version__) # 查看pyecharts版本;
'''调用方法:单独调用和链式调用'''
from pyecharts.charts import Bar
bar = Bar()
bar.add_xaxis(["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"])
bar.add_yaxis("商家A", [5, 20, 36, 10, 75, 90])
# render 会生成本地 HTML 文件，默认会在当前目录生成 render.html 文件
# 也可以传入路径参数，如 bar.render("mycharts.html")
bar.render()

# pyecharts 所有方法均支持链式调用。
from pyecharts.charts import Bar
bar = (
    Bar()
    .add_xaxis(["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"]) # x轴必须是字符型变量;
    .add_yaxis("商家A", [5, 20, 36, 10, 75, 90])
)
bar.render()

# 使用 options 配置项，在 pyecharts 中，一切皆 Options。
from pyecharts.charts import Bar
from pyecharts import options as opts

# V1 版本开始支持链式调用
# 你所看到的格式其实是 `black` 格式化以后的效果
# 可以执行 `pip install black` 下载使用
bar = (
    Bar()
    .add_xaxis(["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"])
    .add_yaxis("商家A", [5, 20, 36, 10, 75, 90])
    .set_global_opts(title_opts=opts.TitleOpts(title="主标题", subtitle="副标题"))
    # 或者直接使用字典参数
    # .set_global_opts(title_opts={"text": "主标题", "subtext": "副标题"})
)
bar.render()

# 不习惯链式调用的开发者依旧可以单独调用方法:
bar = Bar()
bar.add_xaxis(["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"])
bar.add_yaxis("商家A", [5, 20, 36, 10, 75, 90])
bar.set_global_opts(title_opts=opts.TitleOpts(title="主标题", subtitle="副标题"))
bar.render()

'''带南海九段线的中国地图:'''
from pyecharts import options as opts
from pyecharts.charts import Map, Page
from pyecharts.faker import Faker
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot
# 链式调用:
map = (
    Map()
    .add("商家A", [list(z) for z in zip(Faker.provinces, Faker.values())], "china")
    .set_global_opts(
        title_opts=opts.TitleOpts(title="Map-VisualMap（分段型）"),
        visualmap_opts=opts.VisualMapOpts(max_=200, is_piecewise=True),
    )
)
map.render() # 生成html格式;
# 或者单独调用:
map = Map()
map.add("商家A", [list(z) for z in zip(Faker.provinces, Faker.values())], "china")
map.set_global_opts(title_opts=opts.TitleOpts(title="Map-VisualMap（分段型）"),visualmap_opts=opts.VisualMapOpts(max_=200, is_piecewise=True))
map.render()
# 生成图片格式:
make_snapshot(snapshot, map.render(), "map.png") #将render.html生成map.png保存到当前目录中;
# 定义函数的方式:
def bar_chart() -> Bar: # 箭头后面的信息表示对函数的注释信息;
    c = (
        Bar()
        .add_xaxis(["衬衫", "毛衣", "领带", "裤子", "风衣", "高跟鞋", "袜子"])
        .add_yaxis("商家A", [114, 55, 27, 101, 125, 27, 105])
        .add_yaxis("商家B", [57, 134, 137, 129, 145, 60, 49])
        .reversal_axis()
        .set_series_opts(label_opts=opts.LabelOpts(position="right"))
        .set_global_opts(title_opts=opts.TitleOpts(title="Bar-测试渲染图片"))
    )
    return c
bar_chart().render() # 生成html格式;
make_snapshot(snapshot, bar_chart().render(), "bar0.png") # 生成png图片格式;

'''Faker是一个数据集'''
from pyecharts.faker import Faker
z = []
for i in zip(Faker.provinces, Faker.values()):
    print(i)
    z.append(i)

''' 一般excel格式的数据,画出地图'''
import pandas as pd
from pyecharts.charts import Map
from pyecharts import options as opts
datafile = 'E:\\mycode\\python\\gdp.xlsx'
data = pd.read_excel(datafile)
attr = data['province']
value = data['gdp']

data
attr
value
z = [list(z) for z in zip(data.province, data.gdp)] # 类似于:

z = []
for i in zip(data.province,data.gdp):
    z.append(i)

map = Map(init_opts=opts.InitOpts(width = "1920px",height = "1080px",chart_id="a1",page_title = "ZHULOO"))
map.add("2007年GDP", [list(z) for z in zip(data.province, data.gdp)], "china")
# map.add("2007年GDP",z, "china")
map.set_global_opts(title_opts=opts.TitleOpts(title="Map-VisualMap（分段型）"),
visualmap_opts=opts.VisualMapOpts(max_=67000,is_piecewise=True))
map.render()
# 生成图片格式:
make_snapshot(snapshot, map.render(), "map.png")
# 或者链式调用:
map = (
    Map(init_opts=opts.InitOpts(width = "1920px",height = "1080px",chart_id="a1",page_title = "ZHULOO"))
    .add("2007年GDP",z,"china")
    .set_global_opts(title_opts = opts.TitleOpts(title = "GDP示例"),
    visualmap_opts=opts.VisualMapOpts(max_=67000,is_piecewise=True)
    )
)
map.render()
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
        Scatter3D(init_opts=opts.InitOpts(width = "1920px",height = "1080px",chart_id="a1",page_title = "ZHULOO"))
        .add("", data)
        .set_global_opts(
            title_opts=opts.TitleOpts("Scatter3D-ZHULOO"),
            visualmap_opts=opts.VisualMapOpts(range_color=Faker.visual_color),
        )
    )
    return c
scatter3d_base().render() 

# 或者:单独调用
import random
from pyecharts import options as opts
from pyecharts.charts import Page, Scatter3D
from pyecharts.faker import Faker

data = [[random.randint(0, 100), random.randint(0, 100), random.randint(0, 100)] for _ in range(80)]
# data = [[random.randint(0, 100), random.randint(0, 100), random.randint(0, 100)] for i in range(80)] i和上面的_等价;
c = Scatter3D(init_opts=opts.InitOpts(width = "1920px",height = "1080px",chart_id="a1",page_title = "ZHULOO"))
c.add("", data)
c.set_global_opts(title_opts=opts.TitleOpts("Scatter3D-基本示例"),visualmap_opts=opts.VisualMapOpts(range_color=Faker.visual_color))
c.render()


'''
图的四类显示方法:
'''
'''Grid：并行显示多张图表,注意： 第一个图需为 有 x/y 轴的图，即不能为 Pie，其他位置顺序任意;'''
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot
from pyecharts import options as opts
from pyecharts.charts import Bar, Line, Scatter, EffectScatter, Grid
# Grid类：并行显示多个图表 TODO 第一个图需为 有 x/y 轴的图，即不能为 Pie，其他位置顺序任意。
# Bar图单步调用:
attr = ["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"]
v1 = [5, 20, 36, 10, 75, 90]
v2 = [10, 25, 8, 60, 20, 80]
bar = Bar()
bar.add_xaxis(attr)
bar.add_yaxis('商家A',v1)
bar.add_yaxis('商家B',v2)
bar.set_global_opts(title_opts=opts.TitleOpts(title="Grid-Bar"))
bar.render()
# Line图单独调用:
attr = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
high = [11, 11, 15, 13, 12, 13, 10]
low = [1, -2, 2, 5, 3, 2, 0]
line = Line()
line.add_xaxis(attr)
line.add_yaxis('最高',high)
line.add_yaxis('最低',low)
line.set_global_opts(title_opts=opts.TitleOpts(title="Grid-Line", pos_top="48%"),
legend_opts=opts.LegendOpts(pos_top="48%"),)
line.render()
# 将Bar和Line上下组合到一起:
grid = Grid()
grid.add(bar, grid_opts=opts.GridOpts(pos_bottom="60%"))
grid.add(line, grid_opts=opts.GridOpts(pos_top="60%"))
grid.render()

# 将Scatter和Line左右组合到一起:
attr = ["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"]
v1 = [5, 20, 36, 10, 75, 90]
v2 = [10, 25, 8, 60, 20, 80]
scatter = (
    Scatter()
    .add_xaxis(attr)
    .add_yaxis('商家A',v1)
    .add_yaxis('商家B',v2)
    .set_global_opts(
        title_opts=opts.TitleOpts(title="Grid-Scatter"),
        legend_opts=opts.LegendOpts(pos_left="20%"),
    )
)
# Line图
line = (
        Line()
        .add_xaxis(attr)
        .add_yaxis('A',v1)
        .add_yaxis('B',v2)
        .set_global_opts(
            title_opts=opts.TitleOpts(title="Grid-Line", pos_right="40%"),
            legend_opts=opts.LegendOpts(pos_right="20%"),
        )
    )

grid = (
    Grid()
    .add(scatter, grid_opts=opts.GridOpts(pos_left="55%"))
    .add(line, grid_opts=opts.GridOpts(pos_right="55%"))
)
grid.render(r"E:\学术论文\博士论文\论文图表\render1.html")
make_snapshot(snapshot, grid.render(), "E:\学术论文\博士论文\论文图表\grid.png")

'''Overlap:图表混合使用:多个x y轴示例'''
from pyecharts import Line, Bar, Overlap
# Grid-多 Y 轴示例
def grid_mutil_yaxis() -> Grid:
    x_data = ["{}月".format(i) for i in range(1, 13)]
    bar = (
        Bar()
        .add_xaxis(x_data)
        .add_yaxis(
            "蒸发量",
            [2.0, 4.9, 7.0, 23.2, 25.6, 76.7, 135.6, 162.2, 32.6, 20.0, 6.4, 3.3],
            yaxis_index=0,
            color="#d14a61",
        )
        .add_yaxis(
            "降水量",
            [2.6, 5.9, 9.0, 26.4, 28.7, 70.7, 175.6, 182.2, 48.7, 18.8, 6.0, 2.3],
            yaxis_index=1,
            color="#5793f3",
        )
        .extend_axis(
            yaxis=opts.AxisOpts(
                name="蒸发量",
                type_="value",
                min_=0,
                max_=250,
                position="right",
                axisline_opts=opts.AxisLineOpts(
                    linestyle_opts=opts.LineStyleOpts(color="#d14a61")
                ),
                axislabel_opts=opts.LabelOpts(formatter="{value} ml"),
            )
        )
        .extend_axis(
            yaxis=opts.AxisOpts(
                type_="value",
                name="温度",
                min_=0,
                max_=25,
                position="left",
                axisline_opts=opts.AxisLineOpts(
                    linestyle_opts=opts.LineStyleOpts(color="#675bba")
                ),
                axislabel_opts=opts.LabelOpts(formatter="{value} °C"),
                splitline_opts=opts.SplitLineOpts(
                    is_show=True, linestyle_opts=opts.LineStyleOpts(opacity=1)
                ),
            )
        )
        .set_global_opts(
            yaxis_opts=opts.AxisOpts(
                name="降水量",
                min_=0,
                max_=250,
                position="right",
                offset=80,
                axisline_opts=opts.AxisLineOpts(
                    linestyle_opts=opts.LineStyleOpts(color="#5793f3")
                ),
                axislabel_opts=opts.LabelOpts(formatter="{value} ml"),
            ),
            title_opts=opts.TitleOpts(title="Grid-多 Y 轴示例"),
            tooltip_opts=opts.TooltipOpts(trigger="axis", axis_pointer_type="cross"),
        )
    )

    line = (
        Line()
        .add_xaxis(x_data)
        .add_yaxis(
            "平均温度",
            [2.0, 2.2, 3.3, 4.5, 6.3, 10.2, 20.3, 23.4, 23.0, 16.5, 12.0, 6.2],
            yaxis_index=2,
            color="#675bba",
            label_opts=opts.LabelOpts(is_show=False),
        )
    )

    bar.overlap(line)
    return Grid().add(bar, opts.GridOpts(pos_left="5%", pos_right="20%"), is_control_axis_index=True)

grid_mutil_yaxis().render(r"E:\学术论文\博士论文\论文图表\render2.html")
make_snapshot(snapshot, grid_mutil_yaxis().render(), "E:\学术论文\博士论文\论文图表\grid2.png")

'''Page:一个页面顺序渲染多个图表'''
# 多个表格整合到一个html中显示:
from pyecharts import options as opts
from pyecharts.charts import Map, Page
from pyecharts.faker import Collector, Faker

C = Collector()

@C.funcs
def map_base() -> Map:
    c = (
        Map()
        .add("商家A", [list(z) for z in zip(Faker.provinces, Faker.values())], "china")
        .set_global_opts(title_opts=opts.TitleOpts(title="Map-基本示例"))
    )
    return c


@C.funcs
def map_without_label() -> Map:
    c = (
        Map()
        .add("商家A", [list(z) for z in zip(Faker.provinces, Faker.values())], "china")
        .set_series_opts(label_opts=opts.LabelOpts(is_show=False))
        .set_global_opts(title_opts=opts.TitleOpts(title="Map-不显示Label"))
    )
    return c


@C.funcs
def map_visualmap() -> Map:
    c = (
        Map()
        .add("商家A", [list(z) for z in zip(Faker.provinces, Faker.values())], "china")
        .set_global_opts(
            title_opts=opts.TitleOpts(title="Map-VisualMap（连续型）"),
            visualmap_opts=opts.VisualMapOpts(max_=200),
        )
    )
    return c


@C.funcs
def map_visualmap_piecewise() -> Map:
    c = (
        Map()
        .add("商家A", [list(z) for z in zip(Faker.provinces, Faker.values())], "china")
        .set_global_opts(
            title_opts=opts.TitleOpts(title="Map-VisualMap（分段型）"),
            visualmap_opts=opts.VisualMapOpts(max_=200, is_piecewise=True),
        )
    )
    return c


@C.funcs
def map_world() -> Map:
    c = (
        Map()
        .add("商家A", [list(z) for z in zip(Faker.country, Faker.values())], "world")
        .set_series_opts(label_opts=opts.LabelOpts(is_show=False))
        .set_global_opts(
            title_opts=opts.TitleOpts(title="Map-世界地图"),
            visualmap_opts=opts.VisualMapOpts(max_=200),
        )
    )
    return c


@C.funcs
def map_guangdong() -> Map:
    c = (
        Map()
        .add("商家A", [list(z) for z in zip(Faker.guangdong_city, Faker.values())], "广东")
        .set_global_opts(
            title_opts=opts.TitleOpts(title="Map-广东地图"),
            visualmap_opts=opts.VisualMapOpts(),
        )
    )
    return c

Page().add(*[fn() for fn, _ in C.charts]).render()

# Page布局示例:将Bar,Line,Pie,Grid组合到一个html页面:
from pyecharts.faker import Faker
from pyecharts import options as opts
from pyecharts.charts import Bar, Grid, Line, Page, Pie


def bar_datazoom_slider() -> Bar:
    c = (
        Bar()
        .add_xaxis(Faker.days_attrs)
        .add_yaxis("商家A", Faker.days_values)
        .set_global_opts(
            title_opts=opts.TitleOpts(title="Bar-DataZoom（slider-水平）"),
            datazoom_opts=[opts.DataZoomOpts()],
        )
    )
    return c


def line_markpoint() -> Line:
    c = (
        Line()
        .add_xaxis(Faker.choose())
        .add_yaxis(
            "商家A",
            Faker.values(),
            markpoint_opts=opts.MarkPointOpts(data=[opts.MarkPointItem(type_="min")]),
        )
        .add_yaxis(
            "商家B",
            Faker.values(),
            markpoint_opts=opts.MarkPointOpts(data=[opts.MarkPointItem(type_="max")]),
        )
        .set_global_opts(title_opts=opts.TitleOpts(title="Line-MarkPoint"))
    )
    return c


def pie_rosetype() -> Pie:
    v = Faker.choose()
    c = (
        Pie()
        .add(
            "",
            [list(z) for z in zip(v, Faker.values())],
            radius=["30%", "75%"],
            center=["25%", "50%"],
            rosetype="radius",
            label_opts=opts.LabelOpts(is_show=False),
        )
        .add(
            "",
            [list(z) for z in zip(v, Faker.values())],
            radius=["30%", "75%"],
            center=["75%", "50%"],
            rosetype="area",
        )
        .set_global_opts(title_opts=opts.TitleOpts(title="Pie-玫瑰图示例"))
    )
    return c


def grid_mutil_yaxis() -> Grid:
    x_data = ["{}月".format(i) for i in range(1, 13)]
    bar = (
        Bar()
        .add_xaxis(x_data)
        .add_yaxis(
            "蒸发量",
            [2.0, 4.9, 7.0, 23.2, 25.6, 76.7, 135.6, 162.2, 32.6, 20.0, 6.4, 3.3],
            yaxis_index=0,
            color="#d14a61",
        )
        .add_yaxis(
            "降水量",
            [2.6, 5.9, 9.0, 26.4, 28.7, 70.7, 175.6, 182.2, 48.7, 18.8, 6.0, 2.3],
            yaxis_index=1,
            color="#5793f3",
        )
        .extend_axis(
            yaxis=opts.AxisOpts(
                name="蒸发量",
                type_="value",
                min_=0,
                max_=250,
                position="right",
                axisline_opts=opts.AxisLineOpts(
                    linestyle_opts=opts.LineStyleOpts(color="#d14a61")
                ),
                axislabel_opts=opts.LabelOpts(formatter="{value} ml"),
            )
        )
        .extend_axis(
            yaxis=opts.AxisOpts(
                type_="value",
                name="温度",
                min_=0,
                max_=25,
                position="left",
                axisline_opts=opts.AxisLineOpts(
                    linestyle_opts=opts.LineStyleOpts(color="#675bba")
                ),
                axislabel_opts=opts.LabelOpts(formatter="{value} °C"),
                splitline_opts=opts.SplitLineOpts(
                    is_show=True, linestyle_opts=opts.LineStyleOpts(opacity=1)
                ),
            )
        )
        .set_global_opts(
            yaxis_opts=opts.AxisOpts(
                name="降水量",
                min_=0,
                max_=250,
                position="right",
                offset=80,
                axisline_opts=opts.AxisLineOpts(
                    linestyle_opts=opts.LineStyleOpts(color="#5793f3")
                ),
                axislabel_opts=opts.LabelOpts(formatter="{value} ml"),
            ),
            title_opts=opts.TitleOpts(title="Grid-多 Y 轴示例"),
            tooltip_opts=opts.TooltipOpts(trigger="axis", axis_pointer_type="cross"),
        )
    )

    line = (
        Line()
        .add_xaxis(x_data)
        .add_yaxis(
            "平均温度",
            [2.0, 2.2, 3.3, 4.5, 6.3, 10.2, 20.3, 23.4, 23.0, 16.5, 12.0, 6.2],
            yaxis_index=2,
            color="#675bba",
            label_opts=opts.LabelOpts(is_show=False),
        )
    )

    bar.overlap(line)
    return Grid().add(
        bar, opts.GridOpts(pos_left="5%", pos_right="20%"), is_control_axis_index=True
    )
# 默认布局:
page = Page()
page.add(bar_datazoom_slider(), line_markpoint(), pie_rosetype(), grid_mutil_yaxis())
page.render()

# SimplePageLayout 布局:
page = Page(layout=Page.SimplePageLayout)
# 需要自行调整每个 chart 的 height/width，显示效果在不同的显示器上可能不同
page.add(bar_datazoom_slider(), line_markpoint(), pie_rosetype(), grid_mutil_yaxis())
page.render()

# DraggablePageLayout 布局:
page = Page(layout=Page.DraggablePageLayout)
page.add(bar_datazoom_slider(), line_markpoint(), pie_rosetype(), grid_mutil_yaxis())
page.render()

'''pyecharts库使用示例'''
from pyecharts.charts.basic_charts import bar
from pyecharts.charts.basic_charts import line
from pyecharts import options as opts
from pyecharts.globals import SymbolType, ThemeType


if __name__ == '__main__':
    X = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]
    data1 = ['0', '0', '0', '0', '0', '0', '0',  '3', '7', '18', '21', '20', '18', '8', '5', '5', '1','0', '0', '0', '0', '0', '0', '0' ]
    data2 = ['0', '0', '0', '0', '0', '0', '0', '16', '11', '7', '13', '10', '16', '11', '7', '13', '10','0', '0', '0', '0', '0', '0', '0' ]
   bar = (
        Bar(
            init_opts=opts.InitOpts(
                animation_opts=opts.AnimationOpts(
                    animation_delay=500, animation_easing="elasticOut"  # 延时动画效果
                ),
                theme=ThemeType.LIGHT    # 主题选择 WHITE ,LIGHT...
            ),
        )
        .add_xaxis(
            X,
        )   # X轴数据
        .add_yaxis(
            "A",                # 系列名
            data1,              # 数据
            # gap='0%',         # 不同系列柱间距
            # category_gap=0,   # 相同系列柱间距   category_gap='80%'  百分数或者数值
            # stack='stack1',   # 相同stack名字的系列堆叠在一起
            # color='#003366',  # 柱子颜色
            itemstyle_opts=opts.ItemStyleOpts(opacity='0.5')    # 柱子的属性
        )
        .set_series_opts(     # 图表区域内的属性设置:系列属性设置 数据系列
            label_opts=opts.LabelOpts(is_show=False),  # 是否显示具体的数据值
            # markpoint_opts=opts.MarkPointOpts(
            #     data=[
            #         opts.MarkPointItem(type_='max', name='最大值'),
            #         opts.MarkPointItem(type_='min', name='最小值'),
            #         opts.MarkPointItem(type_='average', name='平均值'),
            #     ]
            # ),   # 显示出最大值，最小值，平均值，与X轴平行的刻度线
            markline_opts=opts.MarkLineOpts(
                data=[
                    opts.MarkLineItem(type_='LSL', name='LSL:4', x=4),    # 显示与Y轴平行的刻度线1
                    opts.MarkLineItem(type_='USL', name='USL:20', x=20),
                    opts.MarkLineItem(type_='+3sigma', name='+3s', x=18),
                    opts.MarkLineItem(type_='-3sigma', name='-3s', x=6),
                ],
                linestyle_opts=opts.LineStyleOpts(color="#364678", type_="dotted", width=2),  # 设置线的属性
                label_opts=opts.LabelOpts(position='end', formatter='{b}'),  # 设置线上文字的属性,formatter设置label的内容
            ),
        )
        .set_global_opts(     # 图表的全局项设置:坐标轴，title等属性设置
            title_opts=opts.TitleOpts(
                title="Bar-动画配置基本示例",
                # subtitle="我是副标题"
            ),
            yaxis_opts=opts.AxisOpts(
                # axislabel_opts=opts.LabelOpts(formatter='{value}/个'),  # 编辑Y轴的刻度线内容
                name='Qty',  # Y轴名字
                splitline_opts=opts.SplitLineOpts(is_show=True),  # 显示分割线
            ),  # 设置Y轴属性
            xaxis_opts=opts.AxisOpts(
                name='Value',   # X轴名字
                # splitline_opts=opts.SplitLineOpts(is_show=True),  # 显示分割线
            ),  # 设置X轴属性
            # brush_opts=opts.BrushOpts(),  # 圈选工具
            toolbox_opts=opts.ToolboxOpts(),  # 显示toolbox，toolbox中有下载图片的功能
            tooltip_opts=opts.TooltipOpts(formatter='Qty:{c}')  # 自定义鼠标悬停内容
        )
    )
    line = (
        Line()
        .add_xaxis(X)
        .add_yaxis(
            "A",
            data1,
            label_opts=opts.LabelOpts(is_show=False),
            is_smooth=True,
            linestyle_opts=opts.LineStyleOpts(width=3),
        )
    )
    bar.overlap(line)           # 将两个图表组合在一起
    bar.render("MyBar.html")    # 生产文件

'''组合图案例'''
def grid_mutil_yaxis() -> Grid:
    x_data = ["{}月".format(i) for i in range(1, 13)]
    bar = (
        Bar()
        .add_xaxis(x_data)
        .add_yaxis(
            "蒸发量",
            [2.0, 4.9, 7.0, 23.2, 25.6, 76.7, 135.6, 162.2, 32.6, 20.0, 6.4, 3.3],
            yaxis_index=0, # 多Y轴时，设置坐标轴索引；
            color="#d14a61", # 红色
        )
        .add_yaxis(
            "降水量",
            [2.6, 5.9, 9.0, 26.4, 28.7, 70.7, 175.6, 182.2, 48.7, 18.8, 6.0, 2.3],
            yaxis_index=1,
            color="#5793f3", # 蓝色
        )
        .extend_axis(
            yaxis=opts.AxisOpts(
                name="蒸发量",
                type_="value",
                min_=0,
                max_=250,
                position="right",
                axisline_opts=opts.AxisLineOpts(
                    linestyle_opts=opts.LineStyleOpts(color="#d14a61") # 坐标轴设置成红色；
                ),
                axislabel_opts=opts.LabelOpts(formatter="{value} ml"), # 坐标轴标签显示10ml的格式；
            )
        )
        .extend_axis(
            yaxis=opts.AxisOpts(
                type_="value",
                name="温度",
                min_=0,
                max_=25,
                position="left",
                axisline_opts=opts.AxisLineOpts(
                    linestyle_opts=opts.LineStyleOpts(color="#675bba") #淡紫色
                ),
                axislabel_opts=opts.LabelOpts(formatter="{value} °C"),
                splitline_opts=opts.SplitLineOpts(
                    is_show=True, linestyle_opts=opts.LineStyleOpts(opacity=1)
                ),
            )
        )
        .set_global_opts(
            yaxis_opts=opts.AxisOpts(
                name="降水量",
                min_=0,
                max_=250,
                position="right",
                offset=80,
                axisline_opts=opts.AxisLineOpts(
                    linestyle_opts=opts.LineStyleOpts(color="#5793f3") # 蓝色
                ),
                axislabel_opts=opts.LabelOpts(formatter="{value} ml"),
            ),
            title_opts=opts.TitleOpts(title="Grid-多 Y 轴示例"),
            tooltip_opts=opts.TooltipOpts(trigger="axis", axis_pointer_type="cross"), # 提示框
        )
    )

    line = (
        Line()
        .add_xaxis(x_data)
        .add_yaxis(
            "平均温度",
            [2.0, 2.2, 3.3, 4.5, 6.3, 10.2, 20.3, 23.4, 23.0, 16.5, 12.0, 6.2],
            yaxis_index=2, # 多Y轴时，设置此序列数据使用哪个Y轴；
            color="#675bba",
            label_opts=opts.LabelOpts(is_show=False),
        )
    )

    bar.overlap(line)
    return Grid().add(bar, opts.GridOpts(pos_left="5%", pos_right="20%"), is_control_axis_index=True) # bar和line重叠放入Grid区域，区域左右两侧至边界的距离，

grid_mutil_yaxis().render()

'''原生图形元素组件'''
# 在图形上添加水印、注释等，使用方法如下：
def bar_graphic_grid():
    bar = (
        Bar(init_opts=opts.InitOpts(chart_id="1234"))
        .add_xaxis(Faker.choose())
        .add_yaxis("商家A", Faker.values())
        .add_yaxis("商家B", Faker.values())
        .set_global_opts(
            title_opts=opts.TitleOpts(title="Bar-Graphic Image（旋转功能）组件示例"),
            graphic_opts=[                          # 设置原生图形元素组件的选项；
                opts.GraphicImage(                  # 加入一个logo图形元素；
                    graphic_item=opts.GraphicItem(
                        id_="logo",
                        right=20,
                        top=20,
                        z=-10,
                        bounding="raw",
                        origin=[75, 75],
                    ),
                    graphic_imagestyle_opts=opts.GraphicImageStyleOpts(
                        image="http://echarts.baidu.com/images/favicon.png",
                        width=150,
                        height=150,
                        opacity=0.4,
                    ),
                )
            ],
        )
    )
    c = (
        Grid(init_opts=opts.InitOpts(chart_id="1234"))
        .add(
            chart=bar,
            grid_opts=opts.GridOpts(pos_left="5%", pos_right="4%", pos_bottom="5%"),
        )
        .add_js_funcs(
            """
            var rotation = 0;
            setInterval(function () {
                chart_1234.setOption({
                    graphic: {
                        id: 'logo',
                        rotation: (rotation += Math.PI / 360) % (Math.PI * 2)
                    }
                });
            }, 30);
        """
        )
    )
    return c
bar_graphic_grid().render()
