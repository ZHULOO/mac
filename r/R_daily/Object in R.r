getwd()
setwd("E:/MyGit/r/R_learning")

# 一.Object in R -----------------------------------------------------------

# 1.Data and Files -------------------------------------------------------------
x <- 5
x
x^2
y <- 3
x^y
a <- c(1, 2, 3, 4, 5, 6)

# *1.1 常用函数 ----------------------------------------------------------------
x <- 25             #赋值
abs(x)              #绝对值
sqrt(x)             #平方
exp(x)              #e的x次方
log(x)              #自然对数
log(x, 5)           #5为底x的对数
round(x, 2)         #取两位小数
factorial(x)        #x阶乘
choose(25, 2)       #组合数


# *1.2 向量 -------------------------------------------------------------------
a <- c(1, 2, 3, 4, 5, 6)
b <- a + 1
c <- a + b
d <- a * b


# *1.3 向量函数 ---------------------------------------------------------------
v1 <- seq(20)
v2 <- seq(1,20)
v3 <- seq(1,20,2)
length(v3)
max(v3)
min(v3)
sort(v3)
sum(v3)
prod(v3)
numeric(10)
rep(3,10)
5:15


# *1.4 逻辑运算符 ----------------------------------------------------------------
x==y
x<y
x<=y
x!=y
!b    #非
a|b   #或
a&b   #且

# *1.5 特殊向量 -----------------------------------------------------------------
cities <- c("New York","Los Angeles","Chicago")
cities
0==1
0<1
a <- c(7,2,6,9,4,1,3)
(b <- a<3|a>=6)
x <- c(3,2,1,3,2,1,2,3,1,2,3)
xf <- factor(x,labels = c("good","okey","bad")) # 按顺序给数据打上标签
xf


# *1.6 命名和索引向量 --------------------------------------------------------------
avgs <- c(0.366,0.358,0.356,0.349,0.346)
players <- c("cobb","hornsby","jackson","doul","delahanty")
names(avgs) <- players
avgs
avgs[2]
avgs[1:4]
avgs["jackson"]
avgs[avgs>=0.35]


# *1.7 矩阵 -------------------------------------------------------------------
v <- c(2,-4,-1,5,7,0)
A <- matrix(v,nrow = 2) #竖向生成两行的矩阵
A
row1 <- c(2,-1,7);row2 <- c(-4,5,0)
(A <- rbind(row1,row2))
col1 <- c(2,-4);col2 <- c(-1,5);col3 <- c(7,0)
(A <- cbind(col1,col2,col3))
colnames(A) <- c("alpha","beta","gamma")
rownames(A) <- c("aleph","bet")
A
diag(c(4,2,6))
diag(3)
A[2,1]
A[,c(1,3)]
B <- matrix(c(2,1,0,3,-1,5),nrow = 2)
A
B
A*B
t(B)
A%*%B
C <- A%*%t(B)
solve(C)

# *1.8 list对象 ---------------------------------------------------------------
mylist <- list(A=seq(8,36,4),this="that",idm=diag(3))
mylist #list对象是一个收集器,可以包含各种类型的元素
mylist$A
mylist$this
mylist$idm
names(mylist)

# *1.9 Data Frames and Data Files -------------------------------------------
year <- c(2008,2009,2010,2011,2012,2013)
pro1 <- c(0,3,6,9,7,8);pro2 <- c(1,2,3,5,9,6);pro3 <- c(2,4,4,2,3,2)
sales_mat <- cbind(pro1,pro2,pro3)
row.names(sales_mat) <- year
sales_mat
sales <- as.data.frame(sales_mat)
sales
sales[,"pro1"]
#绝对引用
sales$pro1
sales$totalv1 <- sales$pro1+sales$pro2+sales$pro3
sales
totalv1
#attach相对引用
attach(sales)
totalv1
detach(sales)
totalv1
#with语句
sales$totalv2 <- with(sales,pro1+pro2+pro3+totalv1)
sales
#相对引用后新生成的变量无法直接相对引用,需要再次attach
attach(sales)
sales$totalv3 <- pro1+pro2+pro3+totalv2
sales
attach(sales)
totalv3
detach(sales)
totalv3
#数据集子集:筛选
sales
subset(sales,pro1>=6)#筛选pro1大于等于6的所有数据;

# *1.10 保存数据和载入数据 -----------------------------------------------------------
save(v1,v2,sales,file = "learning.RData")
load("learning.RData")
rm(v1)
exists("v2")

# *1.11 查看数据集基本信息 -----------------------------------------------------------
head(sales)
str(sales)          #数据结构structure
colMeans(sales)     #列均值

# *1.12 导入导出文本文件 ------------------------------------------------------------
#导入txt,csv文本文档
data1 <- read.table("sales.txt",header = TRUE)
data1
data2 <- read.table("sales.csv",sep=",")
data2
colnames(data2) <- c("year")
data2
write.table(data2,file = "mydata2.RData")
#导入其它格式数据文件,需要foreign包
library(foreign)
read.dta  #stata
read.spss #SPSS

# *1.13 案例中的数据集 -------------------------------------------------------------
library(foreign) #还可以直接读取网络数据
affairs <- read.dta("http://fmwww.bc.edu/ec-p/data/wooldridge/affairs.dta")
head(affairs) #查看前6行
colMeans(affairs)

# 2.作图 --------------------------------------------------------------------
setwd("E:/MyGit/r/R_learning")

# *2.1 一般图形及图形元素 ----------------------------------------------------------
curve(x^2,-2,2)
curve(dnorm(x),-3,3)         #dnorm表示标准正态分布;
x <- c(1,3,4,7,8,9)
y <- c(0,3,6,9,7,8)
plot(x,y)
plot(x,y,type = "l")         #type可取:l,b,o,s,h,代表不同类型;
plot(x,y,pch = "A")          #pch直接用字符A作为点的类型;
plot(x,y,pch = 1)            #pch可取:1,2,3...18代表不同点的类型;
plot(x,y,type = "o",lty = 2) #lty可取:1,2,3...6代表不同线的类型;
plot(x,y,type = "o",lty = 2,cex = 3) #cex点和文本的大小,默认为1;
plot(x,y,type = "o",lty = 2,cex = 2,lwd = 2) #lwd线的粗细,默认为1;
plot(x,y,type = "o",lty = 2,cex = 2,lwd = 2,col = "blue") #col颜色;
plot(x,y,type = "o",lty = 2,cex = 2,lwd = 2,col = "blue",main = "主标题",sub = "子标题") #col颜色;
plot(x,y,xlab = "x轴标题",ylab = "y轴标题") #xlab,ylab坐标轴标题;
plot(x,y,xlim = c(1,10),ylim = c(1,9)) #xlim,ylim坐标轴起止刻度;
plot(x,y,las = 0) #las=0,1,2,3轴刻度文字的方向;
plot(x,y,las = 1) 
plot(x,y,las = 2)
plot(x,y,las = 3) 
#多曲线画到一个图
curve(dnorm(x,0,1),-10,10,lwd = 1,lty = 1)
curve(dnorm(x,0,2),add = TRUE,lwd = 2,lty = 2)
curve(dnorm(x,0,3),add = TRUE,lwd = 3,lty = 3)
points(0,0.3,col = "red")
#图上增加其它元素
plot(x,y, main = "Example for an Outlier")
points(8,1)
abline(a=0.31,b=0.97,lty=2,lwd=2)
text(7,2,"outlier",pos=3)
arrows(7,2,8,1,length = 0.15)
#矩阵的所有列画到一个图上
matplot(year,sales,type = "b",lwd = c(1,2,3),col = "blue")

# *2.2 图例 -----------------------------------------------------------------
curve(dnorm(x,0,1),-10,10,lwd = 1,lty = 1)
curve(dnorm(x,0,2),add = TRUE,lwd = 2,lty = 2)
curve(dnorm(x,0,3),add = TRUE,lwd = 3,lty = 3)
#添加图例
legend("topright",c("sigma=1","sigma=2","sigma=3"),lwd = 1:3,lty = 1:3)
#添加带希腊字母表达式的图例,表达式用expression
legend("topleft",expression(sigma==1,sigma==2,sigma==3),lwd = 1:3,lty = 1:3)
#添加公式
text(6,0.3,expression(f(x)==frac(1,sqrt(2*pi)*sigma)*e^{-frac(x^2,2*sigma^2)}))

# *2.3 输出图形 ---------------------------------------------------------------
png(filename = "figures/distribution.png",width = 800,height = 600)
par(mar=c(2,2,0,0))
curve(dnorm(x,0,1),-10,10)
curve(dnorm(x,0,2),add = TRUE,col = "blue")
curve(dnorm(x,0,3),add = TRUE,col = "red")
dev.off()

# *2.4 地图 -----------------------------------------------------------------
install.packages("maps")
library("maps")
data(unemp)
data("county.fips")
plotdata <- unemp$unemp[match(county.fips$fips,unemp$fips)]
plotcol <- gray(1-plotdata/max(plotdata))
map("county",col = plotcol,fill = TRUE,resolution = 0,lty = 0)
map("state",add = TRUE)

# 3 描述统计 ------------------------------------------------------------------

# *3.1 离散分布:频数分布表和列联表 -----------------------------------------------------
library("foreign")
affairs <- read.dta("http://fmwww.bc.edu/ec-p/data/wooldridge/affairs.dta")
head(affairs)
str(affairs)
haskids <- factor(affairs$kids,labels = c("no","yes"))
str(haskids)
head(haskids)
mlab <- c("very unhappy","unhappy","average","happy","very happy")
marriage <- factor(affairs$ratemarr,labels = mlab)
#频数统计
table(haskids)
table(marriage)
#显示占比
prop.table(table(haskids))
prop.table(table(marriage))
#列联表
table(marriage,haskids)
prop.table(table(marriage,haskids),margin = 1) #横向百分比相加等于1
prop.table(table(marriage,haskids),margin = 2) #纵向百分比相加等于1

# *3.2 饼图和条形图 -------------------------------------------------------------
pie(table(marriage))
pie(table(marriage),col = gray(seq(0.2,1,0.2)))
barplot(table(marriage),horiz = TRUE,las = 1,main = "Distribution of Happiness")
#复式条形图
barplot(table(haskids,marriage),horiz = TRUE,las = 1,legend = TRUE,args.legend = c(x="bottomright"),main = "Happiness by Kids")
barplot(table(haskids,marriage),beside = TRUE,las = 1,legend = TRUE,args.legend = c(x="top"),main = "Happiness by Kids")

# *3.3 连续分布:直方图和密度 --------------------------------------------------------
#直方图
library(foreign)
ceosall <- read.dta("http://fmwww.bc.edu/ec-p/data/wooldridge/ceosal1.dta")
ROE <- ceosall$roe
hist(ROE)
hist(ROE,breaks = c(0,2,10,20,30,60))
#密度图
plot(density(ROE))
hist(ROE,freq = FALSE,ylim = c(0,0.07))
lines(density(ROE),lwd = 3)
#经验累积分布函数
plot(ecdf(ROE))

# *3.4 基本统计量 --------------------------------------------------------------
mean(ceosall$salary)
median(ceosall$salary)
sd(ceosall$salary)
summary(ceosall$salary)
cor(ceosall$salary,ceosall$roe)
#箱线图
boxplot(ROE,horizontal = TRUE)
boxplot(ROE~ceosall$consprod)

# 4 常见分布 ------------------------------------------------------------------

# *4.1 离散分布 ---------------------------------------------------------------
#离散分布
dbinom(x,1,p) #伯努利分布
dbinom(x,n,p) #二项分布
dpois(x,lambda) #泊松分布
#对应的累计分布函数
pbinom(x,1,p) #伯努利分布
pbinom(x,n,p) #二项分布
ppois(x,lambda) #泊松分布
#连续分布密度函数
dunif(x,a,b)
dnorm(x)
dnorm(x,mean,sd)
dchisq(x,n)
dt(x,n)
df(x,m,n)
#连续分布函数,由x计算概率
punif(x,a,b)
pnorm(x)
pnorm(x,mean,sd)
pchisq(x,n)
pt(x,n)
pf(x,m,n)
#随机生成相应分布
runif(r,a,b)
rnorm(r)
rnorm(r,mean,sd)
rchisq(r,n)
rt(r,n)
rf(r,m,n)
#由概率计算x,q为概率
qunif(q,a,b)
qnorm(q)
qnorm(q,mean,sd)
qchisq(q,n)
qt(q,n)
qf(q,m,n)
#离散型随机变量的分布律
choose(10,2)*0.2^2*0.8^8 #二项分布等价于:
dbinom(2,10,0.2)
x <- seq(0,10)
fx <- dbinom(x,10,0.2)
cbind(x,fx)
plot(x,fx,type = "h")
#连续型随机变量
curve(dnorm(x),-4,4)
pbinom(3,10,0.2)
pnorm(1.96)-pnorm(-1.96)
#二项分布的累计分布函数图
x <- seq(-1,10)
fx <- pbinom(x,10,0.2)
plot(x,fx,type="S")
#标准正态分布的累积分布图
curve(pnorm(x),-4,4)
#随机生成满足某种分布的数据
rbinom(10,1,0.5) #10个0-1分布
rnorm(10)        #10个标准正态
#设置随机种子
set.seed(6254137)
rnorm(5)
rnorm(5)

# 5 推断统计 ------------------------------------------------------------------

# *5.1 区间估计 ---------------------------------------------------------------
#手工计算置信区间
#就业培训的案例
sr87 <- c(10,1,6,0.45,1.25,1.3,1.06,3,8.18,1.67,0.98,1,0.45,5.03,8,9,18,0.28,7,3.97)
sr88 <- c(3,1,5,0.5,1.54,1.5,0.8,2,0.67,1.17,0.51,0.5,0.61,6.7,4,7,19,0.2,5,3.83)
change <- sr88 - sr87
avgch <- mean(change)
n <- length(change)
sdch <- sd(change)
se <- sdch/sqrt(n)
c <- qt(0.975,n-1)
c(avgch-c*se,avgch+c*se)
#种族歧视案例
library(foreign)
audit <- read.dta("http://fmwww.bc.edu/ec-p/data/wooldridge/audit.dta")
y <- audit$y
n <- length(y)
sigy <- sd(y)
ybar <- mean(y)
z <- qnorm(0.975)
c(ybar-z*sigy/sqrt(n),ybar+z*sigy/sqrt(n))

# *5.2 假设检验 ---------------------------------------------------------------
#t检验
#自由度和分位数
df <- 19
alpha.one.tailed <- c(0.1,0.05,0.025,0.01,0.005,0.001)
alpha.two.tailed <- alpha.one.tailed*2
tcv <- qt(1-alpha.one.tailed,df)
zcv <- qnorm(1-alpha.one.tailed)
cbind(alpha.one.tailed,alpha.two.tailed,tcv,zcv) #t检验和z检验的分位数;
p <- 2*(1-pt(abs(t),n-1)) #计算t统计量的P值
#上面就业培训案例的t检验
t <- avgch*sqrt(n)/sdch
p <- pt(t,n-1)

# *5.3 自动计算 ---------------------------------------------------------------
t.test(change) #双侧检验
t.test(change,alternative = "less") #单侧检验,less和备择假设一致;
t.test(y, mu=5, alternative="greater", conf.l.evel.=0.99) #备择假设为mu>5
#保存t检验的结果:
testres <- t.test(change)
testres
names(testres)      #t检验结果所有统计量
#显示t检验各统计量的结果
testres["statistic"]
testres["p.value"]
testres["conf.int"]
#或者
testres$statistic
testres$parameter

# 6 R的高级功能:条件和循环等 ---------------------------------------------------------
#条件
if (condition) expressionl else expression2
p
if (p<=0.05) decision<-"reject HO!" else decision<-"don't reject HO!"
decision
#循环:repeat,while,replicate,apply or lapply
for (loopvar in vector) {
    some
}
#合并应用
for (i in 1:6) {
    if (i<4) {
        print(i^3)
    } else {
        print(i^2)
    }
}
#函数
mysqrt <- function(x) {
    if (x>=0){
        return(sqrt(x))
    }else{
        return("负数不能开平方")
    }
}
mysqrt(9)
mysqrt(-9)

# 7 其它高级功能 ----------------------------------------------------------------

# *7.1 自动格式化报告 ------------------------------------------------------------


# *7.2 计算速度优化 -------------------------------------------------------------
#并行计算

# 8 蒙特卡洛模拟 ----------------------------------------------------------------

# *8.1 有限样本估计量的性质 ---------------------------------------------------------
set.seed(123456)
#第1次
sample <- rnorm(100,10,2)
sd(sample)
mean(sample)
#第2次
sample <- rnorm(100,10,2)
sd(sample)
mean(sample)
#第3次
sample <- rnorm(100,10,2)
sd(sample)
mean(sample)
...

ybar <- numeric(10000)
#重复10000次
for(j in 1:10000){
    sample <- rnorm(100,10,0.2)
    ybar[j] <- mean(sample)
}
ybar
mean(ybar)
var(ybar)
plot(density(ybar))
curve(dnorm(x,10,0.2/sqrt(100)),add = TRUE,lty=2)

# *8.2 估计量的渐进性质 -----------------------------------------------------------
#检验中心极限定理,总体服从正态分布,抽样10000次,看xbar的分布:
#当n=2
xbar <- numeric(10000)
for(j in 1:10000){
    sample <- rnorm(2,10,0.2)
    xbar[j] <- mean(sample)
}
mean(xbar)
var(xbar)
plot(density(xbar))
curve(dnorm(x,10,0.2/sqrt(2)),add = TRUE,lty=2)
#当n=10
xbar <- numeric(10000)
for(j in 1:10000){
    sample <- rnorm(10,10,0.2)
    xbar[j] <- mean(sample)
}
mean(xbar)
var(xbar)
plot(density(xbar))
curve(dnorm(x,10,0.2/sqrt(10)),add = TRUE,lty=2)
#当n=100
xbar <- numeric(10000)
for(j in 1:10000){
    sample <- rnorm(100,10,0.2)
    xbar[j] <- mean(sample)
}
mean(xbar)
var(xbar)
plot(density(xbar))
curve(dnorm(x,10,0.2/sqrt(100)),add = TRUE,lty=2)
#当n=1000
xbar <- numeric(10000)
for(j in 1:10000){
    sample <- rnorm(1000,10,0.2)
    xbar[j] <- mean(sample)
}
mean(xbar)
var(xbar)
plot(density(xbar))
curve(dnorm(x,10,0.2/sqrt(1000)),add = TRUE,lty=2)

#总体服从自由度为1的卡方分布,所以总体均值为1,方差为2
curve(dchisq(x,1),0,3)
#当n=2
xbar <- numeric(10000)
for(j in 1:10000){
    sample <- rchisq(2,1)
    xbar[j] <- mean(sample)
}
mean(xbar)
var(xbar)
plot(density(xbar))
curve(dnorm(x,1,2/sqrt(2)),add = TRUE,lty=2)
#当n=10
xbar <- numeric(10000)
for(j in 1:10000){
    sample <- rchisq(10,1)
    xbar[j] <- mean(sample)
}
mean(xbar)
var(xbar)
plot(density(xbar))
curve(dnorm(x,1,2/sqrt(10)),add = TRUE,lty=2)
#当n=100
xbar <- numeric(10000)
for(j in 1:10000){
    sample <- rchisq(100,1)
    xbar[j] <- mean(sample)
}
mean(xbar)
var(xbar)
plot(density(xbar))
curve(dnorm(x,1,2/sqrt(100)),add = TRUE,lty=2)
#当n=1000
xbar <- numeric(10000)
for(j in 1:10000){
    sample <- rchisq(1000,1)
    xbar[j] <- mean(sample)
}
mean(xbar)
var(xbar)
plot(density(xbar))
curve(dnorm(x,1,2/sqrt(1000)),add = TRUE,lty=2)

# *8.3 置信区间的模拟 ------------------------------------------------------------
set.seed(123456)
cilower <- numeric(10000);ciupper <- numeric(10000)
pvalue1 <- numeric(10000);pvalue2 <- numeric(10000)
for(i in 1:10000){
    sample <- rnorm(100,10,2)
    testres1 <- t.test(sample,mu = 10)
    cilower[i] <- testres1$conf.int[1]
    ciupper[i] <- testres1$conf.int[2]
    pvalue1[i] <- testres1$p.value
    pvalue2[i] <- t.test(sample,mu = 9.5)$p.value
}
reject1 <- pvalue1<=0.05;reject2 <- pvalue2<=0.05
table(reject1)
table(reject2)
