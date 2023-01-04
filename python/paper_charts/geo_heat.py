from pyecharts import options as opts
from pyecharts.charts import Geo
from pyecharts.faker import Faker
from pyecharts.globals import ChartType
from pyecharts.render import make_snapshot
from snapshot_selenium import snapshot

c = (
    Geo()
    .add_schema(maptype="china")
    .add(
        "geo",
        [list(z) for z in zip(Faker.provinces, Faker.values())],
        type_=ChartType.HEATMAP,
    )
    .set_series_opts(label_opts=opts.LabelOpts(is_show=False))
    .set_global_opts(
        visualmap_opts=opts.VisualMapOpts(),
        title_opts=opts.TitleOpts(title="Geo-HeatMap"),
    )
    .render(r"/Users/zhulu/Files/MyGit/python/paper_charts/geo_heatmap.html")
)
make_snapshot(snapshot,c,r'/Users/zhulu/Files/MyGit/python/paper_charts/geo_heatmap.png')

[list(z) for z in zip(Faker.provinces, Faker.values())]