'''各省平均补贴热力图'''
import pandas as pd
from pyecharts.charts import Map
from pyecharts import options as opts
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot
datafile = r'E:\学术论文\博士论文\论文图表\各省2017年A公司补贴数据.xlsx'
data = pd.read_excel(datafile)
X = data['province']
Z = list(data['average'])
Y1 = []
for i in Z:
    Y1.append(float('%.4f'%i))

dic = [list(z) for z in zip(X, Y1)] # 生成成对的字典型数据;
def map_base(data):
    map=(
        Map()
        .add(
            series_name="各省每家A股上市公司所获平均补贴（亿元）",
            data_pair=data,
            maptype='china',
        )
        .set_global_opts(
            legend_opts=opts.LegendOpts(
                pos_top='10%',
            ),
            visualmap_opts=opts.VisualMapOpts(
                max_=1.5,
                min_=0.1,
                split_number=10,
                is_piecewise='True',
                pos_left='10%',
                pos_bottom='5%',
            ),
        )
    )
    return map
# map_base(dic).render(r"E:\学术论文\博士论文\论文图表\map.html")
make_snapshot(snapshot,map_base(dic).render(),r"E:\学术论文\博士论文\论文图表\图2-5各省上市公司所获平均补贴MAP.png")