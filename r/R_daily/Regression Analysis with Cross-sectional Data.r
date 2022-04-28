
# 一 简单线性回归 ----------------------------------------------------------------

rm(list = ls())
require(foreign)
ceosal1 <- read.dta("http://fmwww.bc.edu/ec-p/data/wooldridge/ceosal1.dta")

# *1.1 手动计算回归系数 -----------------------------------------------------------
attach(ceosal1)
cov(roe,salary)
var(roe)
mean(roe)
mean(salary)
b1hat <- cov(roe,salary)/var(roe)
b0hat <- mean(salary)-b1hat*mean(roe)
detach(ceosal1)

# *1.2 回归命令lm -------------------------------------------------------------
attach(ceosal1)
myolsres <- lm(salary~roe,data = ceosal1)
plot(roe,salary,ylim = c(0,4000))
abline(myolsres)
names(myolsres)
myolsres["coefficients"]
myolsres$coefficients
coef(myolsres)
nobs(myolsres)
bhat <- coef(myolsres)
yhat <- bhat["(Intercept)"]+bhat["roe"]*roe
uhat <- salary-yhat
cbind(salary,yhat,uhat)
#或者
yhat <- fitted(myolsres)
uhat <- resid(myolsres)
# 案例;wage~educ
library(foreign)
wage1 <- read.dta("http://fmwww.bc.edu/ec-p/data/wooldridge/wage1.dta")
wagereg <- lm(wage~educ,data = wage1)
b.hat <- coef(wagereg)
wage.hat <- fitted(wagereg)
u.hat <- resid(wagereg)
#做以下验证:
#零均值
mean(u.hat)
#解释变量和随机扰动项不相关
cor(wage1$educ,u.hat)
#均值过回归线
mean(wage1$wage)
b.hat[1]+b.hat[2]*mean(wage1$educ)
#拟合优度
var(wage.hat)/var(wage1$wage)
1-var(u.hat)/var(wage1$wage)
cor(wage1$wage,wage.hat)^2 
cor(wage1$wage,wage1$educ)^2 #四者都是相等的,都表示拟合优度
#最全回归结果输出
summary(wagereg)
var(wagereg$fitted.values)/var(wage1$wage)

# *1.3 非线性和其它形式的回归 --------------------------------------------------------
#取对数
lm(log(wage)~educ,data = wage1)
#无截距项
lm(wage~0+educ,data = wage1)
#只有截距项
lm(wage~1,data = wage1)
#综合以上情况的案例:
library(foreign)
ceosal1 <- read.dta("http://fmwww.bc.edu/ec-p/data/wooldridge/ceosal1.dta")
reg1 <- lm(salary~roe,data = ceosal1)    #包含截距项和斜率项
reg2 <- lm(salary~0+roe,data = ceosal1)  #无截距项
reg3 <- lm(salary~1,data = ceosal1)      #无斜率项
mean(ceosal1$salary)
plot(ceosal1$roe,ceosal1$salary,ylim = c(0,4000))    
abline(reg1,lwd=2,lty=1)    
abline(reg2,lwd=2,lty=2)    
abline(reg3,lwd=2,lty=3)    
legend("topleft",c("正常回归","无截距项","只有截距项"),lwd=2,lty=1:3)  

# *1.4 期望值,方差和标准误 ---------------------------------------------------------
#打开残差和回归系数标准误估计的黑匣子
library(foreign)
meap93 <- read.dta("http://fmwww.bc.edu/ec-p/data/wooldridge/meap93.dta")
results <- lm(math10~lnchprg,data = meap93)
n <- nobs(results)
#估计残差标准差:
SER <- sd(resid(results))*sqrt((n-1)/(n-2))
#估计回归系数的标准差
se_b0 <-  SER/sd(meap93$lnchprg)/sqrt(n-1)*sqrt(mean(meap93$lnchprg^2))
se_b1 <- SER/sd(meap93$lnchprg)/sqrt(n-1)    
#和回归输出结果直接对比
summary(results)

# *1.5 蒙特卡洛模拟 -------------------------------------------------------------
#手工生成数据模拟回归的过程
set.seed(1234567)
n <- 1000    
b0 <- 1;b1 <- 0.5;su <- 2    
x <- rnorm(n,4,1)    
u <- rnorm(n,0,su)    
y <- b0+b1*x+u
olsres <- lm(y~x)
summary(olsres)
mean(x^2)
sum((x-mean(x))^2)
#画图
plot(x,y,col = 'gray',xlim = c(0,8)) #散点图
abline(b0,b1,lwd=2)  #总体回归线
abline(olsres,col="gray",lwd=2) #估计的样本线
legend("topleft",c("总体回归线","样本回归线"),lwd=2,col=c("black","gray"))
#计算估计量的方差
var_b0 <- su^2*mean(x^2)/sum((x-mean(x))^2)
sqrt(var_b0)
var_b1 <- su^2/sum((x-mean(x))^2)
sqrt(var_b1)

#多次抽样模拟估计量的一致性
set.seed(1234567)
n <- 1000;r <- 10000    
b0 <- 1;b1 <- 0.5;su <- 2 
b0hat <- numeric(r)
b1hat <- numeric(r)
x <- rnorm(n,4,1)
for(j in 1:r){ 
    u <- rnorm(n,0,su)
    y <- b0+b1*x+u
    bhat <- coefficients(lm(y~x))
    b0hat[j] <- bhat["(Intercept)"]
    b1hat[j] <- bhat["x"] #估计10000次,获取每一次的回归系数,保存下来;
}
#看估计量的结果是否满足无偏性和有效性
mean(b0hat)
mean(b1hat)
var(b0hat)
var(b1hat)
#画图显示前10次抽样的回归线
plot(NULL,xlim=c(0,8),ylim=c(0,6),xlab="x",ylab="y")
for(j in 1:10) abline(b0hat[j],b1hat[j],col="gray") #样本:灰色,线宽为1
abline(b0,b1,lwd=2,col="red") #总体:红色,线宽为2
legend("topleft",c("样本OLS","总体"),lwd=c(1,2),col = c("gray","red"))

# *1.6 违背假定:随机扰动项的条件期望不等于0 ------------------------------------------------
#E(U|X)=(X-4)/5
set.seed(1234567)
n <- 1000;r <- 10000    
b0 <- 1;b1 <- 0.5;su <- 2 
b0hat <- numeric(r)
b1hat <- numeric(r)
x <- rnorm(n,4,1)
for(j in 1:r){ 
    u <- rnorm(n,(x-4)/5,su)
    y <- b0+b1*x+u
    bhat <- coefficients(lm(y~x))
    b0hat[j] <- bhat["(Intercept)"]
    b1hat[j] <- bhat["x"] #估计10000次,获取每一次的回归系数,保存下来;
}
#看估计量的结果是否满足无偏性和有效性
mean(b0hat) #结果不再满足无偏性
mean(b1hat)

# *1.7 违背假定:异方差 -----------------------------------------------------------
#var(u) <- 4/exp(4.5)*exp(x) 
set.seed(1234567)
n <- 1000;r <- 10000    
b0 <- 1;b1 <- 0.5;su <- 2 
b0hat <- numeric(r)
b1hat <- numeric(r)
x <- rnorm(n,4,1)
varu <- 4/exp(4.5)*exp(x)
for(j in 1:r){ 
    u <- rnorm(n,0,sqrt(varu))
    y <- b0+b1*x+u
    bhat <- coefficients(lm(y~x))
    b0hat[j] <- bhat["(Intercept)"]
    b1hat[j] <- bhat["x"] #估计10000次,获取每一次的回归系数,保存下来;
}
#看估计量的结果是否满足无偏性和有效性
mean(b0hat) #结果依然满足无偏性
mean(b1hat)
var(b0hat)
var(b1hat)

# 二 多元回归 ------------------------------------------------------------------

# *2.1 多元回归一般步骤 -----------------------------------------------------------
library(foreign)
gpa1 <- read.dta("http://fmwww.bc.edu/ec-p/data/wooldridge/gpa1.dta")
GPAres <- lm(colGPA~hsGPA+ACT,data = gpa1)
summary(GPAres)
#取对数
wage1 <- read.dta("http://fmwww.bc.edu/ec-p/data/wooldridge/wage1.dta")
summary(lm(log(wage)~educ+exper+tenure,data = wage1))

# *2.2 多元回归的矩阵形式 ----------------------------------------------------------
bhat <- solve(t(X)%*%X)%*%t(X)%*%Y
uhat <- Y-X%*%bhat
sigsqhat <- as.numeric(t(uhat)%*%uhat/(n-k-1))
vbetahat <- sigsqhat*solve(t(x)%*%x)
se <- sqrt(diag(vbetahat))
#案例:手动计算回归系数及方差
library(foreign)
gpa1 <- read.dta("http://fmwww.bc.edu/ec-p/data/wooldridge/gpa1.dta")
n <- nrow(gpa1);k <- 2
y <- gpa1$colGPA
x <- cbind(1,gpa1$hsGPA,gpa1$ACT)
head(x)
#回归系数
bhat <- solve(t(x)%*%x)%*%t(x)%*%y
bhat
#残差
uhat <- y-x%*%bhat
uhat
#扰动项方差的估计
sigsqhat <- as.numeric(t(uhat)%*%uhat/(n-k-1))
sigsqhat
SER <- sqrt(sigsqhat)
SER
#估计量的方差
vbetahat <- sigsqhat*solve(t(x)%*%x)
vbetahat
se <- sqrt(diag(vbetahat))
se
#和命令计算比较
summary(lm(y~gpa1$hsGPA+gpa1$ACT))
bhat
SER
se

# *2.3 忽略变量偏差 -------------------------------------------------------------


