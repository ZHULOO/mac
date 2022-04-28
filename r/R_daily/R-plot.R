
# 图形初阶 --------------------------------------------------------------------


# *1 画图并保存 ----------------------------------------------------------------
png("mygraph.png") #pdf(),jpeg(),bmp()等函数可以生成相对应的图片格式
    attach(mtcars)
    plot(wt,mpg)
    abline(lm(mpg~wt))
    title("Regression of MPG on Weight")
    detach(mtcars)
dev.off()
#dev.new(),dev.next(),dev.prev()更多dev命令参考help(dev.cur)


# *2 图形参数par --------------------------------------------------------------
#par()函数设置图形参数
rm(list = ls())
dose <- c(20,30,40,45,60)
druga <- c(16,20,27,40,60)
drugb <- c(15,18,25,31,40)
plot(dose,druga,type = "b")


opar <- par(no.readonly = TRUE)#将当前图形参数保存为opar对象,以便后面恢复此选项;

par(lty=2,pch=17)              #中间修改了图形参数的par属性;
plot(dose,druga,type = "b")    #绘图将使用上面的lty=2和pch=17的参数;


par(opar)                      #恢复为上面保存的opar对象保存的图形属性:
plot(dose,druga,type = "b")

par(font.lab=3,cex.lab=1.5,font.main=4,cex.main=2) #cex缩放倍数,font:2粗体3斜体和1常规
plot(dose,druga,type = "b")




# *3 符号,线条,颜色,文本 ----------------------------------------------------------------------
#3.1 点
# pch:指定绘图点所用的符号;
# cex:缩放指定符号的大小;
#3.2 线条
# lty:指定线条类型;
# lwd:指定线条宽度;
#3.3 颜色
# col.axis:坐标轴刻度文字的颜色;
# col.lab:坐标轴标签(名称)的颜色;
# col.main:标题颜色;
# col.sub:副标题颜色;
# fg:图形的前景色;
# bg:图形的背景色;
# 颜色的表示方法:
col = 1
col = "white"
col = "#FFFFFF"
col = rgb(1,1,1)
col = hsv(0,0,1)
# 常用的几种颜色设置函数:
library(RColorBrewer)
n <- 7
mycolors <- brewer.pal(n,"Set1")
barplot(rep(1,n),col=mycolors)
# 或者
n <- 10
mycolors <- rainbow(n)
pie(rep(1,n),labels = mycolors,col = mycolors)   
# 或者
mygrays <- gray(0:n/n)
pie(rep(1,n),labels = mygrays,col = mygrays)
#3.4 文本属性
# 文本大小
cex.axis:坐标轴刻度文字的缩放倍数;
cex.lab:坐标轴标签(名称)的缩放倍数;
cex.main:标题的缩放倍数;
cex.sub:副标题的缩放倍数;
# 字体\字号和字样:1=常规,2=粗体,3=斜体,4=粗斜体,5=符号字体以adobe符号编码表示;
# font.axis:坐标轴刻度文字的样式;
# font.lab:坐标轴标签(名称)的样式;
# font.main:标题的样式;
# font.sub:副标题的样式;
# ps:字体的磅值,最终字体大小等于cex*ps
# family:字体族

windowsFonts(
    A=windowsFont("Arial Black"),
    B=windowsFont("Times New Roman"),
    C=windowsFont("Fira Code")
)

par(family="B",font.lab=3,cex.lab=1.5,font.main=4,cex.main=2)
plot(dose,druga,type = "b")

# *4 图形尺寸和边界尺寸 ------------------------------------------------------------
pin = c(2,3) #以英寸表示图形的宽和高
mai = c(下,左,上,右)#分别表示下左上右边界的大小,以英寸表示;
mar = c(下,左,上,右)#分别表示下左上右边界的大小,以英分表示;

rm(list = ls())
dose <- c(20,30,40,45,60)
druga <- c(16,20,27,40,60)
drugb <- c(15,18,25,31,40)

opar <- par(no.readonly = TRUE) #画图前保存一下图形参数默认配置;
par(pin=c(2,3))
par(lwd=2,cex=1.5)
par(cex.axis=0.75,font.axis=3)
plot(dose,druga,type = "b",pch=19,lty=2,col="red")
plot(dose,drugb,type = "b",pch=23,lty=6,col="blue",bg="green")
par(opar)

# *5 添加文本,自定义坐标轴和图例 -------------------------------------------------------
plot(dose,druga,type="b",
     col="red",lty=2,pch=2,lwd=2,
     main="Clinical Trials for Drug A",
     sub="This is hypothetical data",
     xlab="Disage",ylab="Drug Response",
     xlim=c(10,60),ylim=c(10,70)
    
)
title(main = "main title",col.main="red", #单独定义标题
      sub = "subtitle",col.sub="blue",
      xlab = "x-axis label",ylab = "y-axis label",
      col.lab="green",cex.lab=0.75)

axis(side,at=,labels = ,pos = ,lty = ,col = ,las=,tck=,)#单独定义坐标轴
# side:在哪边绘制坐标轴,1=下,2=左,3=上,4=右
# at:绘制刻度线的位置
# labels:一个字符型向量,表示刻度线旁边的文字标签
# 案例:
x <- c(1:10)
y <- x
z <- 10/x
opar <- par(no.readonly = TRUE)

par(mar=c(5,4,4,8)+0.1)
plot(x,y,type="b",pch=21,col="red",
     yaxt="n",lty=3,ann=FALSE) # ann=FALSE:移除默认的标题和标签;
lines(x,z,type="b",pch=22,col="blue",lty=2)
axis(2,at=x,labels = x,col.axis="red",las=2) # las=2 标签垂直于坐标轴,默认为0(平行于坐标轴) 
axis(4,at=z,labels = round(z,digits = 2),
     col.axis="blue",las=2,cex.axis=0.7,tck=-0.01)  # tck=-0.01负值表示刻度位于图形外侧
mtext("y=1/x",side=4,line=3,cex.lab=1,las=2,col="blue") # mtext图形边界添加文本;
title("An example of creative axes",xlab = "x values",ylab = "y=x")
library(Hmisc) #添加次刻度线,需要加载Hmisc包
minor.tick(nx=2,ny=3,tick.ratio=0.5) #nx次要刻度线分割区间个数,0.5次要刻度线为主刻度线的一半;
# 参考线
abline(h=c(1,5,7))
abline(v=seq(1,10,2),lty=2,col="blue") #在不同的位置添加参考线
# 图例
legend("topleft",inset = 0.05,title="Example",c("y=x","y=1/x"), # inset=0.05图例在
       lty=c(1,2),pch=c(15,17),col=c("red","blue")) 
# 文本标注
# text()可向绘图区域内部添加文本;
# mtext()可向图形的四个边界之一添加文本;
text(location,"text to place",pos, ...)
mtext("text to place",side,line=n, ...)
# location为一对坐标,设置文本的位置参数,location(1)鼠标交互式摆放位置;
# pos:1=下,2=左,3=上,4=右,offset=设置偏移量
# side:1=下,2=左,3=上,4=右,line=内移或外移文本,adj=0文本左下对其,adj=1右上对齐;
attach(mtcars)
plot(wt,mpg,
     main = "Mileage vs Car Weight",
     xlab = "weight",ylab = "mileage",
     pch=18,col="blue")
text(wt,mpg,
     row.names(mtcars),
     cex = 0.6,pos = 4,col = 'red')
detach(mtcars)
# 使用plotmath()类似于Tex的写法为图形添加数学符号和公式
help("plotmath")
# 案例
x <- seq(-4, 4, len = 101)
y <- cbind(sin(x), cos(x))
matplot(x, y, type = "l", xaxt = "n",
        main = expression(paste(plain(sin) * phi, "  and  ",
                                plain(cos) * phi)),
        ylab = expression("sin" * phi, "cos" * phi), # only 1st is taken
        xlab = expression(paste("Phase Angle ", phi)),
        col.main = "blue")
axis(1, at = c(-pi, -pi/2, 0, pi/2, pi),
     labels = expression(-pi, -pi/2, 0, pi/2, pi))


## How to combine "math" and numeric variables :
plot(1:10, type="n", xlab="", ylab="", main = "plot math & numbers")
theta <- 1.23 ; mtext(bquote(hat(theta) == .(theta)), line= .25)
for(i in 2:9)
  text(i, i+1, substitute(list(xi, eta) == group("(",list(x,y),")"),
                          list(x = i, y = i+1)))
## note that both of these use calls rather than expressions.
##
text(1, 10,  "Derivatives:", adj = 0)
text(1, 9.6, expression(minute: {f * minute}(x) == {f * minute}(x)), adj = 0)
text(1, 9.0, expression(second: {f * second}(x) == {f * second}(x)), adj = 0)


plot(1:10, 1:10)
text(4, 9, expression(hat(beta) == (X^t * X)^{-1} * X^t * y))
text(4, 8.4, expression(hat(beta) == (X^t * X)^{-1} * X^t * y),
     cex = .8)
text(4, 7, expression(bar(x) == sum(frac(x[i], n), i==1, n)))
text(4, 6.4, expression(bar(x) == sum(frac(x[i], n), i==1, n)),
     cex = .8)
text(8, 5, expression(paste(frac(1, sigma*sqrt(2*pi)), " ",
                            plain(e)^{frac(-(x-mu)^2, 2*sigma^2)})),
     cex = 1.2)

## some other useful symbols
plot.new(); plot.window(c(0,4), c(15,1))
text(1, 1, "universal", adj = 0); text(2.5, 1,  "\\042")
text(3, 1, expression(symbol("\042")))
text(1, 2, "existential", adj = 0); text(2.5, 2,  "\\044")
text(3, 2, expression(symbol("\044")))
text(1, 3, "suchthat", adj = 0); text(2.5, 3,  "\\047")
text(3, 3, expression(symbol("\047")))
text(1, 4, "therefore", adj = 0); text(2.5, 4,  "\\134")
text(3, 4, expression(symbol("\134")))
text(1, 5, "perpendicular", adj = 0); text(2.5, 5,  "\\136")
text(3, 5, expression(symbol("\136")))
text(1, 6, "circlemultiply", adj = 0); text(2.5, 6,  "\\304")
text(3, 6, expression(symbol("\304")))
text(1, 7, "circleplus", adj = 0); text(2.5, 7,  "\\305")
text(3, 7, expression(symbol("\305")))
text(1, 8, "emptyset", adj = 0); text(2.5, 8,  "\\306")
text(3, 8, expression(symbol("\306")))
text(1, 9, "angle", adj = 0); text(2.5, 9,  "\\320")
text(3, 9, expression(symbol("\320")))
text(1, 10, "leftangle", adj = 0); text(2.5, 10,  "\\341")
text(3, 10, expression(symbol("\341")))
text(1, 11, "rightangle", adj = 0); text(2.5, 11,  "\\361")
text(3, 11, expression(symbol("\361")))

# *6 图形的组合 ----------------------------------------------------------------
attach(mtcars)
opar <- par(no.readonly = TRUE)
par(mfrow=c(2,2)) # 先按行排列的2x2四幅图
plot(wt,mpg,main = "Scatterplot of wt vs.mpg")
plot(wt,disp,main = "Scatterplot of wt vs.disp")
hist(wt,main = "Histogram of wt")
boxplot(wt,main = "Boxplot of wt")
par(opar)
detach(mtcars)

attach(mtcars)
opar <- par(no.readonly = TRUE)
par(mfcol=c(2,2)) # 先按列排列的2x2四幅图
plot(wt,mpg,main = "Scatterplot of wt vs.mpg")
plot(wt,disp,main = "Scatterplot of wt vs.disp")
hist(wt,main = "Histogram of wt")
boxplot(wt,main = "Boxplot of wt")
par(opar)
detach(mtcars)

attach(mtcars)
layout(matrix(c(1,1,2,3),2,2,byrow = TRUE))
plot(wt,mpg,main = "Scatterplot of wt vs.mpg")
hist(wt,main = "Histogram of wt")
boxplot(wt,main = "Boxplot of wt")
detach(mtcars)
# 图形布局的精细控制
par(fig=c(0,0.8,0,0.8)) # fig设置图形横向占据0-0.8,纵向范围0-0.8
plot(mtcars$wt,mtcars$mpg,
     xlab = "Miles Per Gallon",
     ylab = "Car Weight")
par(fig=c(0,0.8,0.55,1),new=TRUE) #图形横向范围0-0.8,纵向范围0.55-1
boxplot(mtcars$wt,horizontal = TRUE,axes=FALSE)
par(fig=c(0.65,1,0,0.8),new=TRUE)
boxplot(mtcars$mpg,axes=FALSE)


