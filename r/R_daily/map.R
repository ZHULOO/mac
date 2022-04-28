地图数据文件主要是国家基础地理信息1：400万数据包，网上均可以下载，只是不知道时间，我们只是示例，不考虑这种差别，需要的包主要有
library(maptools) #是很多空间分析的基础包，需要先加载
library(rgdal) #读取矢量边界要用到此包 
library(ggplot2)
library(sp)
library(plyr)
library(dplyr)

#
#data reading
china_map = readOGR("E:/R/map","bou2_4p")   # 读取分省的地图文件
xdata<-china_map@data #读取地图数据
xdata$NAME2004 <- iconv(xdata$NAME2004,"UTF8","cp936") # 中文乱码转码;

xs<-data.frame(xdata,id=seq(1:37)-1) #获取分省数据
xs$NAME2004 <- iconv(xs$NAME2004,"UTF8","cp936")

china_map1 <- fortify(china_map) #转化为数据框 id-(0,36)
china_map_data<-join(china_map1, xs, type = "full") #将xs和china_map1合并;

dat_pop<-read.csv("E:/R/map/province.csv",T) #读取各省人口数据
china_data <- join(china_map_data, dat_pop, type="full") #矩阵合并
#
## 绘热力图
p1<-ggplot(china_data,aes(long,lat,group=group))+
  geom_polygon(aes(fill=gdp_2017),color="grey40")+ # fill=gdp_2017,指标不能含有小数?画出2017年各地的gdp热力图;
  scale_fill_gradient(low="white",high="steelblue",guide=guide_legend("2017年GDP"))+
  scale_x_continuous(limits = range(china_data$long))+
  scale_y_continuous(limits=c(min(china_data$lat)+10,max(china_data$lat)))+
  coord_map("albers",lat0=27,lat1=45)+
  xlab("Longitude")+
  ylab("Latitude")+
  theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    panel.background = element_blank()
  )

p1

## 绘制小图
#fork到的九段线
l9<-rgdal::readOGR("E:/R/map/九段线.shp")
l91<-l9%>%fortify() 
p2<-ggplot()+
  geom_polygon(data=china_data,aes(x=long,y=lat,group=group),color="grey40",fill="white")+ #绘制分省图
  geom_line(data=l91,aes(x=long,y=lat,group=group),color="red",size=1)+ #9段线
  coord_cartesian(xlim=c(105,125),ylim=c(3,30))+ #缩小显示范围在南部区域
  theme(
    aspect.ratio = 1.25, #调节长宽比
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    panel.background = element_blank(),
    panel.border = element_rect(fill=NA,color="grey20",linetype=1,size=0.8),
    plot.margin=unit(c(0,0,0,0),"mm")
  )
p2

#嵌合2个图
library(grid) #ggplot也是grid图
vie <- viewport(width=0.45,height=0.3,x=0.78,y=0.25) #定义小图的绘图区域
p1 #绘制大图
print(p2,vp=vie) #在p1上按上述格式增加小图


## 将数据写入excel:
install.packages("xlsx") #将数据写入到excel的包;
library("xlsx")
help("xlsx")
write.xlsx(xs, "E:/R/map/test1.xlsx",sheetName = "province_id", append = TRUE)
write.xlsx(china_map1, "E:/R/map/test2.xlsx",sheetName = "province_id", append = TRUE)


