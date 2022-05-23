（一）操作步骤
1.	加载R包
library(MASS)		#加载MASS包  
library(tidyverse) 	#用于数据加载及预处理
2.	读取数据
d<-read_csv('c8_1.csv')
nms <- d[['城市']]
d[['城市']] <- NULL
d[is.na(d)]<-0
d<-data.frame(d)  	#将数据转换为数据框
rownames(d)<-nms 		#将城市名称设置为行名
options(digits=2) 	#输出显示小数点后2位
1.	对应分析 利用corresp函数进行对应分析
ca1=corresp(d,nf=2)	#对应分析 
这里d是原始数据，nf表示提取2个主成分。
（二）输出结果
1.	行、列主成分得分 
corresp函数返回值的rscore和cscore组件包含了行、列主成分得分
ca1$rscore 			#行主成分得分
ca1$cscore 		#列主成分得分

2.	对应分析图
biplot(ca1)			#双坐标轴图
abline(v=0,h=0,lty=3)	#添加轴线


getwd()
setwd("/users/zhulu/files/data")
1.加载R包
library(MASS)			#加载MASS包
library(tidyverse) 		#用于数据加载及预处理
library(readxl)

2.读取数据
d0<-read_table('c8_2.data',col_names = FALSE)
d0 <- read_xlsx('c8_2.xlsx',col_names = FALSE)
names(d0) <- c('mpg','cyl','disp','hors','weight','acc','org','name')
d0$hors <- as.numeric(d0$hors)
d0 <- na.omit(d0)
d <- d0[,1:6]
options(digits=2) 			#输出显示小数点后2位
1.对应分析 利用corresp函数进行对应分析
locs <- str_detect(d0$name,'dodge|honda')
d01 <- d0[locs,]
d02 <- d[locs,] 
ca1=corresp(d02,nf=2)			#对应分析
biplot(ca1,cex=0.8)

d01[c(21,27,31,34),]
