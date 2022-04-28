#1.软件包介绍: xtable和flextable
#这个软件包,主要是可以将R的对象生产Latex和html的格式,但是对于输出word和直接在R中显示
#支持不够. 这样就用到到了第二个软件包: flextable.

#flextable有很多功能, 比较好用的是它可以将xtable的格式转化为flextable, 这样就可以进
#行图表的可视化和结果输出, 它可以输出word和PPT格式, 下面以几个示例进行演示.

#2.软件安装
#xtable和flextable在CRAN上, 所以通过install.packages直接安装即可, 安装代码如下:
install.packages("xtable")
install.packages("flextable")
library("xtable")
help("xtable")

library("flextable")
help("flextable")
ft<-flextable(mtcars)
ft
#3.案例演示
install.packages("VSNR") #cran安装出错,用github安装;
library(devtools)
install_github('VSNC/VSNR')
library(VSNR)
data("fm")
str(fm)
# 描述统计表:
func <- function(x)(c(n = length(x),mean=mean(x,na.rm = T),
                      max = max(x,na.rm = T), min = min(x,na.rm = T),
                      sd=sd(x,na.rm = T),cv=sd(x,na.rm = T)/mean(x,na.rm = T)*100))
library(tidyverse)
library(reshape2)                                                               
tt = melt(fm,1:5)
head(tt)
a = aggregate(value~variable,tt,func)
re = cbind(type = a$variable,as.data.frame(a$value))
library(xtable)
library(flextable)
m1 = xtable_to_flextable(xtable(re))
m1 #m1即是描述统计表;

#方差分析表:
mod1 = summary(aov(dj~Spacing+Rep+Fam,data = fm))
m2 = xtable_to_flextable(xtable(mod1))
m2

#简单回归分析:
mod2 = summary(lm(h5~dj,fm))
m2 = xtable_to_flextable(xtable(mod2))
m2

#多元回归分析:
mod3 = summary(lm(h5~dj+h1+h2+h3+h4,fm))
m3 = xtable_to_flextable(xtable(mod3))
m3

#输出到word:
library(officer)
doc = read_docx()
doc = body_add_flextable(doc,m3)
print(doc,"E:/Mycode/Rstudio/m3.docx")

