###R的安装:
# 从网址:https://mirrors.tuna.tsinghua.edu.cn/CRAN/bin/windows/base/old/)下载不同版本的R语言;
# 不同的R版本需要对应不同的Rtools,下载网址:https://mirrors.tuna.tsinghua.edu.cn/CRAN/bin/windows/Rtools/Rtools34.exe,
# 直接更换不同R版本的Rtools34.exe就可以;
# 下载了对应版本的R语言和Rtools以后,使用"checkpoint"包控制包版本;
###使用checkpoint包控制包的版本:
# 新的项目建立一个新文件夹,将工作目录设置为此文件夹,在新文件夹下建立一个.R的脚本文件;
# checkpoint包会自动检测此文件夹目录下的R脚本中的包,并检测当前checkpoint("date")中date日期下的各包的版本,并自动下载;
# 

# 一、基本操作 --------------------------------------------------------------------
# *1.快捷键 ---------------------------------------------------------------------
# **1.1终端区 ---------------------------------------------------------------------
描述	                          键位(Windows和Linux)
光标移动到控制台	              Ctrl+2
清除控制台	                    Ctrl+L
移动光标到行首	                Home
移动光标到行尾	                End
调出以前使用过的命令	          上箭头/下箭头
弹出历史命令的菜单	            Ctrl+上箭头
中断当前正在执行的命令	        Esc
改变工作目录	                  Ctrl+Shift+K
插入书签标题                    ctrl+shift+R
显示插入的书签目录              ctrl+shift+O
# **1.2代码区 ---------------------------------------------------------------------
注释/消除注释当前行或者所选代码	Ctrl+Shift+C
回流注释（不知道什么意思）    	Shift+Ctrl+/
上下移动整行	                  Alt+上肩头/下箭头
复制行	                        Shift+Alt+上箭头/下箭头
跳转到匹配的括号	              Ctrl+P
查找替换	                      Ctrl+F
查找上一个	                    Shift+F3
查找下一个并添加(find and add next)，设置为：F3，
按词为单位跳动	                Ctrl+左/右箭头
跳到开头/结尾	                  Ctrl+Home/End
删除行	                        Ctrl+D
选择	                          Shift+箭头
选择单词	                      Ctrl+Shift+左/右箭头
选择到行首                    	Ctrl+Alt+左箭头
选择到行尾                      Ctrl+ALt+右箭头
向下/上选择页	                  Shift+PageDown/PageUp
选择到文章开始/结束	            Ctrl+Shift+Home/End
删除左边的单词	
缩进	                          ctrl+]
凸出	                          Shift+Tab
删除光标和行首之间的部分	      Ctrl+U
删除光标和行尾之间的部分	      Ctrl+K

# **1.3 hotkeys包 ---------------------------------------------------------------------
## 从github安装：参考：https://github.com/r-stata/hotkeys
install.packages("devtools")
install.packages("remotes")
devtools::install_github('r-stata/hotkeys')
## 安装好hotkeys包以后就可以在修改快捷键里找到这些特殊操作符设置快捷键了
alt + =  : ->
alt + -  : <-
alt + R  : |>
ctrl+shift+M : %>% 
ctrl+D   : 删除整行
ctrl+K   : 删除光标后整行



### checkpoint的使用方法:
getValidSnapshots()
checkpointArchives()
.libPaths()




### 包的安装方法:
# 本地安装:
install.packages("E:/R/SemiParSampleSel_1.5.tar.gz",repos=NULL, type="source") # 本地安装方法未成功
# devtools安装方法:
install.packages("devtools")
library(devtools)
install.packages("SemiParSampleSel")
install_url("https://cran.r-project.org/src/contrib/Archive/SemiParSampleSel/SemiParSampleSel_1.5.tar.gz") # devtools安装方法也未成功;

### 包版本控制:Microsoft R Open:通过日期快照的方式;
library(checkpoint)
checkpoint("2015-02-01") #安装这个日期下的各包
install.packages("SemiParSampleSel")
install.packages("SemiParSampleSel",repos="https://mran.microsoft.com/snapshot/2019-02-01/") 
### 对于过于古老的包,可能还要还要控制R的版本;



###更新R:R语言一定要保存各版本软件以及对应的包,因为不同的软件版本包不是通用的;
install.packages("installr")
library(installr)
updateR() #在R自带的命令窗口运行该命令;





help("glm")
help("family")

###设置工作目录:
getwd() #获取当前工作目录
setwd() #设置目录到
dir.create("D:R/Case/") #新建文件夹
file.show()

###设置包安装目录:
###最好不要设置,因为不同的版本包不通用,还是保存各版本软件以及对应的包:
#以管理员身份运行Rstudio才能看见所有包安装目录;
.libPaths() #获取当前包的安装目录,一般有两个包目录,第一个是默认的安装包目录:
"C:/Users/User/Documents/R/win-library/3.6" # common library 管理员身份打开Rstudio才可以看见;
"C:/Program Files/R/R-3.6.1/library"# personal library
mypath<-.libPaths()
mypath<-c(mypath[2],mypath[1]) # 将两个包目录更换位置,再赋值给.libpaths(),修改默认的包安装目录;
.libPaths(mypath) #此时将第二个目录(安装目录下的library)修改为默认的安装目录了;
#添加自定义的包安装目录"D:\Rpackages",将这与段代码添加到
#"C:\Program Files\R\R-3.6.1\library\base\R"的Rprofile文件中并保存:打开Rprofile需要修改管理员权限:
mypath<-.libPaths() #获取当前两个包目录;
mypath<-c(mypath[2],mypath[1]) #更换两个包的位置,将安装目录下的library设置为默认;
mypath<-c('D:/Rpackages',mypath) #将自定义的D:\Rpackages添加到.libPaths()的第一个参数(默认的目录),;
.libPaths(mypath) #再将包含自定义目录的三个目录赋值给包目录;

#更新版本后,只需将Rprofile文件复制到新安装的相应目录下即可;

# 二、 包以及自带数据的一些操作----------------------------------------------------------------------
R.home()
.libPaths()#显示包的安装路径
installed.packages()#显示当前已安装的包
remove.packages("")#卸载包
(.packages())#显示当前已加载的包
install.packages("")#安装包
library("")#加载包
available.packages()#查看自己的机器可以安装的包
library()#获取已安装的所有软件包列表
search()#获取当前R环境中加载的所有包
data(package = .packages(all.available = TRUE))#查看已安装所有包内自带数据集。
data(package="包名")#查看包内自带数据集。

###github上包的安装
library(devtools)
install_github('VSNC/VSNR') # VSNC是仓库名,VSNR是包名称;

ap<-installed.packages()
dim(ap)
grep('ABCp2',rownames(ap))#查看“ABCp2”是否存在于正在使用的R的仓库里，并返回位置

sessionInfo() #看你的R语言的环境;

#数据处理####
#数据读入与保存####
#Excel格式：
library(xlsx)
mydata <- read_excel("E:/data/genmatch_data.xlsx")
save(mydata,file = 'E:/Mycode/Rstudio/paper.Rdata')
#导入stata格式：
library(foreign)
mydata <- read.dta("mydata.dta") #只能读取stata5-12的数据
library(haven)
mydata <- read_stata("mydata.dta")

attach(lalonde) #将lalonde数据放到R的搜索路径中,可以直接用数据中的变量re78;
detach(lalonde) #将lalonde数据从R的搜索路径中移除;
na.omit()#删除NA型数据

dim(x)#查看数据集X的行数和列数
names(x)#查看数据集x的列名
head(x)#查看数据集x的前六行
complete.cases(x)#返回数据集X行是否有缺失值，有缺失值返回FALSE,无缺失值返回TRUE
load()#加载数据
View()#查看数据
### 保存数据:
a<-1:10
save(a,file='d://data//dumData.Rdata')
rm(a) #将对象a从R中删除
load('d://data//dumData.Rdata')
print(a)




#学习过的几个包
"rvest"#网页爬虫包
"Rwordseg"#文本分词包，需要依赖"rjava"包
"jiebaR"#分词包
"nnet"#BP神经网络包
"rpart"#决策树包
"arules"/"arulesViz"#关联规则包


#数据类型####
#1、向量Vectors：c()函数，基本数据类型logical\numeric\integer\complex\character\raw
#2、列表Lists:list()函数，可以包含不同类型的元素，向量、函数、列表等；
#3、矩阵Matrics:matrix()函数；
#4、数组Arrays:array()函数，使用一个dim属性创建所需维数；
#5、因子Factors:factor()函数，使用向量创建的R对象，它将向量与向量中元素的不同值一起存储为标签；nlevels()函数给出各水平的频数；
#6、数据帧Data Frames：data.frame()函数，每一列可以是不同类型的数据。

#cat(“”，，)函数：将多个项目组合成连续打印输出。
#显示变量的数据类型：class(x):显示变量x的数据类型。
#查找变量：ls()函数列举出当前工作空间中的所有变量。ls(pattern="")列举出pattern的所有变量。
#删除当前工作空间中的所有变量：rm(list=ls())
#remove(x)删除内存中的x变量

#运算符：%% 求余数，%/% 求商，!=不等于，& and运算符，|或运算符，！非运算符
v <- c(3,1,TRUE,2+3i)
t <- c(4,1,FALSE,2+3i)
print(v&t)
[1]  TRUE  TRUE FALSE  TRUE#比较两个向量的每一个元素
#&& and运算，但是仅比较两个向量的第一个元素
print(v|t)
[1] TRUE TRUE TRUE TRUE
v <- c(3,0,TRUE,2+2i)
t <- c(4,0,FALSE,2+3i)
print(v|t)
[1]  TRUE FALSE  TRUE  TRUE

# %in%：标识一个元素是否属于某个向量，%*%：矩阵乘以其转置矩阵。%>%管道函数传递参数。

#if判断结构####
#if判断语句:
x <- c("what","is","truth")

if("Truth" %in% x) {
  print("Truth is found")
} else {
  print("Truth is not found")
}
#if ... else if ... else语句的基本语法:
if(boolean_expression 1) 
{
  // Executes when the boolean expression 1 is true.
} else if( boolean_expression 2) 
{
  // Executes when the boolean expression 2 is true.
} else if( boolean_expression 3)
{
  // Executes when the boolean expression 3 is true.
} else 
{
  // executes when none of the above condition is true.
}
#switch语句：
switch(expression, case1, case2, case3....)

#循环语句####
#repeat循环：
repeat { 
  commands 
  if(condition) {
    break
  }
}
#例如：
v <- c("Hello","loop")
cnt <- 2

repeat {
  print(v)
  cnt <- cnt+1
  
  if(cnt > 5) {
    break#break终止语句
  }
}

#while循环：
while (test_expression) {
  statement
}
#例如：
v <- c("Hello","while loop")
cnt <- 2

while (cnt < 7) {
  print(v)
  cnt = cnt + 1
}

#for循环：
#例如：
v <- LETTERS[1:4]
for ( i in v) {
  print(i)
}
#next语句
v <- LETTERS[1:6]
for ( i in v) {
  
  if (i == "D") {
    next
  }
  print(i)
}



#数据重塑####
#R语言中的数据重塑是关于改变数据被组织成行和列的方式。 大多数时间R语言中的数据处理是通过将输入数据作为数据帧来完成的。 很容易从数据帧的行和列中提取数据，但是在某些情况下，我们需要的数据帧格式与我们接收数据帧的格式不同。 R语言具有许多功能，在数据帧中拆分，合并和将行更改为列，反之亦然。
#列合并：使用cbind()函数连接多个向量来创建数据帧。 
#行合并：我们可以使用rbind()函数合并两个数据帧。
#merge()函数合并两个数据帧。 数据帧必须具有相同的列名称，在其上进行合并。
#melt()拆分数据:打乱各列数据，串起来显示，cast()函数组合数据。

# 函数 ----------------------------------------------------------------------

# 自定义函数 -------------------------------------------------------------------
# *语法格式 --------------------------------------------------------------------
function_name <- function(arg_1, arg_2, ...) {
  Function body 
}

f1<-function(a)
{
  for (i in 1:a) {
    b=0        
    b<-b+i^2
    print(b)}
}

# *创建和使用函数 ----------------------------------------------------------------

customMean <- function(x) {  # x 是输入参数
  # 以下是操作集合，即代码块
  s <- i <- 0
  for (j in x) {
    s <- s + j
    i <- i + 1
  }
  
  return(s / i)  # s / i 是返回值
}
customMean(x = c(1, 2, 3)) # 和是6，除以三个数，返回均值

# 还可以显示打印信息加函数结果：
customMean_v2 <- function(x) {  
  
  s <- i <- 0
  for (j in x) {
    s <- s + j
    i <- i + 1
  }
  
  mu <- s / i
  
  message(
    "Mean of sequence ",
    paste(x, collapse = ","),
    " is ",
    mu
  )
  
  return(mu)  
}
customMean_v2(x = c(1:3))
# 完整的函数定义，还有函数的说明
# @title 计算均值
# @param x 输入数据，一个数值向量
# @param verbose 逻辑值，控制是否打印
customMean_v4 <- function(x, verbose = TRUE) {  
  
  if (!is.numeric(x)) {
    stop("输入数据必须是一个数值型向量！")
  }
  
  s <- i <- 0
  for (j in x) {
    s <- s + j
    i <- i + 1
  }
  
  mu <- s / i
  
  if (verbose) {
    l <- length(x)
    if (l > 10) {
      message(
        "Mean of sequence ",
        paste(c(x[1:5], "...", x[(l-4):l]), collapse = ","),
        " is ",
        mu
      )
    } else {
      message(
        "Mean of sequence ",
        paste(x, collapse = ","),
        " is ",
        mu
      )
    }
  }
  
  return(mu)  
}
customMean_v4(c("1", "2", "3"))
customMean_v4(c(1, 2, 3))
# 比较一下自定义均值和系统均值函数的运行效率
system.time(customMean(1:1e7))
system.time(mean(1:1e7))

# *作用域 --------------------------------------------------------------------
# 由内向外查找和使用参数
a <- 3
Sum <- function(b) {
  a + b
}
Sum(10)

#
a <- 3
Sum <- function(b) {
  a <- 1
  a + b
}
Sum(10)
#
a <- 3
# 运行函数之前
a

Sum <- function(b) {
  a <<- 1       # 函数内部修改变量的值使用"<<-"符号；
  a + b
}

result <- Sum(10)
# 运行函数之后
a
# 任意参数
addAll <- function(x, ...) {  # 三个点...表示任意可以传入任意长度的参数；
  args <- list(...)
  for (a in args) {
    x <- x + a
  }
  return(x)
}

# 函数式编程 -------------------------------------------------------------------

# *传入和返回一个函数 --------------------------------------------------------------
f <- function(x, fun) {
  fun(x)
}
f(1:10,sum)
f(1:10,mean)
f(1:10,quantile)

f2 <- function(type) {
  switch(type,
         mean = mean,
         sum = sum,
         quantile = quantile)
}
f2("mean")
f2("sum")
f2("quantile")
# 可不可以直接调用它呢
f2("mean")(1:10)


# apply家族 -----------------------------------------------------------------
# 包括apply(),lapply(),sapply(),vapply()等，以函数作为输入来进行批量运算，可以取
# 之前的循环控制；
# 构造一个100x100000的正太分布矩阵
# 设置随机种子数
set.seed(1234)
mat <- matrix(rnorm(1e7), ncol = 100, byrow = TRUE)
# 展示数据维度
dim(mat)
# 查看少量数据
mat[1:5, 1:5]

# 如果不适用rowMeans()函数，计算每一行均值该怎么实现的：
# for 循环
calcRowMeans <- function(mat) {
  # 先初始化一个结果向量，这样更有效率
  res <- vector("numeric", nrow(mat))
  for (i in 1:nrow(mat)) {
    res[i] <- mean(mat[i, ])
  }
  
  return(res)
} 
# 看一下实际计算的时间
system.time(
  rm <- calcRowMeans(mat)
)
# 看上去不到一秒，很快了，但是再看apply的时间
system.time(
  rm <- apply(mat, 1, mean) # 1表示按行
)
# 时间增加了，效率没有提升但是代码却及其精简了；
# 可以抛弃for循环对矩阵做各种运算：
# 行和
r <- apply(mat, 1, sum)
# 行最大值
r <- apply(mat, 1, max)
# 行最小值
r <- apply(mat, 1, min)

# 列和
r <- apply(mat, 2, sum)
# 列最大值
r <- apply(mat, 2, max)
# 列最小值
r <- apply(mat, 2, min)

# lapply ------------------------------------------------------------------
set.seed(1234)
# 有四组温度数据，长度不一，求每一组的最小最大平均值和中位数：
temp <- list(
  35 + rnorm(10, mean = 1, sd = 10),
  20 + rnorm(5, mean = 1, sd = 3),
  25 + rnorm(22, mean = 2, sd = 6),
  33 + rnorm(14, mean = 4, sd = 20)
)
basic <- function(x) {
  c(min = min(x), mean = mean(x), median = median(x), max = max(x))
}
# 直接将列表数据和处理函数传入lapply函数
lapply(temp, basic)
# 虽然数据不等长，单处理的结果却是等长的，输出结果略显多杂，使用sapply看：
sapply(temp, basic)
# 再看vapply
vapply(temp, basic, FUN.VALUE = numeric(4)) #第三个参数表示输出结果预期是4个
vapply(temp, basic, FUN.VALUE = numeric(3))


#字符串操作####
paste(..., sep = " ", collapse = NULL)
#以下是所使用的参数的说明：
#...表示要组合的任意数量的自变量。
#sep表示参数之间的任何分隔符。它是可选的。
#collapse用于消除两个字符串之间的空格，但不是一个字符串的两个字内的空间。
#format()函数将数字和字符串格式化为特定样式。
#基本语法是 -
format(x, digits, nsmall, scientific, width, justify = c("left", "right", "centre", "none")) 
#以下是所使用的参数的描述 - 
  #x是向量输入。
#digits是显示的总位数。
#nsmall是小数点右边的最小位数。
#科学设置为TRUE以显示科学记数法。
#width指示通过在开始处填充空白来显示的最小宽度。
#justify是字符串向左，右或中心的显示。
nchar(x)#:计算x包含的字符数。
toupper(x)#大写
tolower(x)#小写
substring(x,first,last)#提取字符串x的一部分
seq(5, 9, by = 0.4)#产生等差数列
sort(x,decreasing = TRUE)#对序列x进行排序
list()#列表是R语言对象，它包含不同类型的元素，如数字，字符串，向量和其中的另一个列表。 列表还可以包含矩阵或函数作为其元素。
unlist()#将列表转换为向量，然后可以对其进行向量运算。
summary()#函数获取数据的统计摘要和性质。
#条形图####
barplot(H, xlab, ylab, main, names.arg, col)
#以下是所使用的参数的描述 - 
 # H是包含在条形图中使用的数值的向量或矩阵。
#xlab是x轴的标签。
#ylab是y轴的标签。
#main是条形图的标题。
#names.arg是在每个条下出现的名称的向量。
#col用于向图中的条形提供颜色。
#箱线图####
boxplot(x, data, notch, varwidth, names, main)
#以下是所使用的参数的描述 - 
#  x是向量或公式。
#数据是数据帧。
#notch是逻辑值。 设置为TRUE以绘制凹口。
#varwidth是一个逻辑值。 设置为true以绘制与样本大小成比例的框的宽度。
#names是将打印在每个箱线图下的组标签。
#main用于给图表标题。

download.file(url,destfile,method,quiet=FALSE,mode="w",cacheOK=TRUE,extra=getOption("download.file.extra"))
#url:字符串,必须http://,https://,ftp://,file://开头
#destfile:下载文件的保存地址,默认工作目录,file为保存文件名
#method:提供"internal","wget","curl","lynx","libcurl","wininet".windows上通常internal就能解决大多数的问题,
##少数搞不定的如Cygwin,gnuwin32用"wget",windows二进制文件用"curl".method对于Mac用户来说是都要设置的."lynx"主要针对historical interest
#quiet:TRUE-禁止状态消息,显示进度条
#mode:写入文件模式,只能在method="internal"时使用,"w"/"wb"(binary)/"a"(append)/"ab"
#cacheOK:是否接受服务器端的缓存值,对http://,https://使用.FALSE-尝试从站点获取副本,而不是从中间缓存中获取

y1=rnorm(500,0,1)

#R中使用Python#####
install.packages("reticulate") #reticulate包
library("reticulate")
#几种调用Python的方法：####
#Rmarkdown中使用：
'''{python}
import pandas as pd
data = pd.read_csv("")
'''
#导入python模块:
library(reticulate)
os <- import('os')
os$listdir(".")
pd <- import('pandas')
data <- pd$read_csv('result.csv')

#交互式REPL:
repl_python()
exit

#直接写.py脚本


#source_python()函数:
source_python("flights.py")
flights <- read_flights("flights.csv")
library(ggplot2)
ggplot(flights, aes(carrier, arr_delay)) + geom_point() + geom_jitter()


##### 线性回归 #####
age = 18:29
height = c(76.1,77,78.1,78.2,78.8,79.7,79.9,81.1,81.2,81.8,82.8,83.5)
plot(age,height,main = "身高与年龄的散点图")
reg1 <- lm(height~age)
reg1
abline(reg1)
# 完整案例：
getwd()
setwd("E:/atom_github/r")
insurance <- read.csv("insurance.csv")
head(insurance)
str(insurance)
summary(insurance$charges)
hist(insurance$charges)
cor(insurance[c("age","bmi","children","charges")])
pairs(insurance[c("age","bmi","children","charges")])
# 一个改进后的三点图矩阵，可以用psych包中的pairs.panels()函数来创建：
install.packages("psych")
library("psych")
pairs.panels(insurance[c("age","bmi","children","charges")])
# 回归：
lm1 <- lm(charges~age+children+bmi+sex+smoker+region,data=insurance)
summary(lm1)


##### R计量经济学 #####
install.packages("wooldridge")

library("wooldridge")
data()          # 列出所有数据;
data("wage1")   # 加载"wage1"的数据;

lm1 <- lm(lwage~educ,data = wage1)
summary(lm1)

rm(list = ls())
n <- 50
set.seed(680156)
x <- rnorm(n,5,sqrt(5))
e <- runif(n,-1,1)
y <- 1 + x + e
lm2 <- lm(y~x)
summary(lm2)

# 简单回归过程 ####
require(foreign)
data("ceosal1")
attach(ceosal1)
# 手工计算回归系数:
cov(roe,salary)
var(roe)
mean(salary)
mean(roe)
(beta1 <- cov(roe,salary)/var(roe))
(beta0 <- mean(salary)-beta1*mean(roe))
detach(ceosal1)
# 使用lm进行回归:
lm1 <- lm(salary~roe,data = ceosal1)
# 或者:
attach(ceosal1)
lm1 <- lm(salary~roe)
detach(ceosal1)
# 画散点图:
plot(ceosal1$roe,ceosal1$salary,ylim = c(0,4000))
# 添加回归拟合线:
abline(lm1)
# 回归系数,拟合值和残差
names(lm1)
bhat <- lm1$coefficients # 或者
bhat <- coef(lm1)
n <- nobs(lm1)
sal_hat <- fitted(lm1)
u_hat <- resid(lm1)
cbind(ceosal1$salary,ceosal1$roe,sal_hat,u_hat)[1:15,]
# 检验OLS的性质
mean(u_hat)
cov(ceosal1$roe,u_hat)
mean(ceosal1$salary)
bhat[1] + bhat[2]*mean(ceosal1$roe)
# 拟合优度:
(r2 <- var(sal_hat)/var(salary))
# 汇总回归结果:
summary(lm1)
# 非线性形式:
require("wooldridge")
data(wage1)
attach(wage1)
lm2 <- lm(log(wage)~educ)
summary(lm2)
# 无截距项:
lm3 <- lm(wage~0 + educ)
summary(lm3)
# 只有截距项
lm4 <- lm(wage~1)
summary(lm4)
# 将所有回归拟合线画到一个图上
plot(educ,wage)
abline(lm2,lwd=2,lty=1)
abline(lm3,lwd=3,lty=2)
abline(lm4,lwd=4,lty=3)

# 蒙特卡洛模拟 ####
rm(list = ls())
set.seed(123456)
n <- 1000
b0 <- 1
b1 <- 0.5 # 总体参数都是已知的;
su <- 2
x <- rnorm(n,4,1)
u <- rnorm(n,0,su)
y <- b0 + b1*x + u
(olsreg <- lm(y~x))
# 计算回归系数估计值的方差:
mean(x^2)
sum((x-mean(x))^2)
var_b0 <- (su^2*mean(x^2))/sum((x-mean(x))^2)
var_b1 <- (su^2)/sum((x-mean(x))^2)
# 画出总体回归曲线和ols回归曲线图:
plot(x,y,col="gray",xlim = c(0,8))
abline(b0,b1,lwd=2)
abline(olsreg,col="gray",lwd=2)
legend("topleft",c("pop. regr. fct.","OLS regr. fct."),lwd=2,col=c("black","gray"))

# 重复抽样10000次
rm(list = ls())
set.seed(123456)
n <- 1000
b0 <- 1
b1 <- 0.5
su <- 2
r <- 10000
b0hat <- numeric(r) # 初始化两个值用来存储结果
b1hat <- numeric(r)
x <- rnorm(n,4,1)
# 重复10000次:
for (j in 1:r) {
  u <- rnorm(n,0,su)
  y <- b0 + b1*x + u
  # ols估计并存储每次估计的系数:
  bhat <- coefficients(lm(y~x))
  b0hat[j] <- bhat["(Intercept)"]
  b1hat[j] <- bhat["x"]
}
mean(b0hat) # 是否等于真实值,证明无偏性;
mean(b1hat)
var(b0hat) # 方差是否等于估计量;
var(b1hat)
# 一万次抽样回归线画到一个图上:
# 初始化一个空白图
plot(NULL,xlim=c(0,8),ylim=c(0,6),xlab="x",ylab="y")
# 将前10次的回归线都添加到同一个图上:
for(j in 1:10) abline(b0hat[j],b1hat[j],col="gray")
# 将总体回归线画到图上:
abline(b0,b1,lwd=2)
# 添加图例:
legend("topleft",c("Population","OLS regression"),lwd = c(2,1),col=c("black","gray"))

# par-opar ----------------------------------------------------------
dose <- c(20, 30, 40, 45, 60)
drugA <- c(16, 20, 27, 40, 60)
drugB <- c(10, 18, 25, 60, 20)
# 先默认画一个图
plot(dose, drugA, type="b") # 图形默认参数为空心点、实线型

# 使用par()函数修改图形点和线的类型
opar <- par(no.readonly=TRUE) # 修改之前保存之前的图形参数为opar，以便后面恢复；
par(lty=2, pch=17)
# 再次画图，可以看到图形的点变成了实心三角，线变成了虚线
plot(dose, drugA, type="b")
plot(dose, drugB, type="b")
# 如果要恢复到当初的空心圆加实线：
par(opar)
plot(dose, drugA, type="b")
plot(dose, drugB, type="b")

# 关于画图参数
type：线条类型
lty：线条类型
pch：点类型
cex：缩放
col：颜色
font：字体


