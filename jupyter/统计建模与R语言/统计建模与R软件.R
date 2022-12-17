# 逻辑向量 ----------------------------------------------------------
x <- -10:10
x
x < 0
x[x < 0]
y <- numeric(length(x))
y
y[x < 0] <- 1 - x[x < 0]
y
y[x >= 0] <- 1 + x[x >= 0]
y

# 验证中心极限定理 --------------------------------------
fun <- function(a) {
  x <- 1:100              #先生成一个1到100的序列，后面可以更改这些值，相当于覆盖掉原来的值
  x <- data.frame(x)
  a <- data.frame(a)
  
  for(i in 1:100){ # 设置循环，循环抽取100个样本，并将计算出来的均值赋值给数据框中的x变量
    c <- a[sample(nrow(a),1000),]  #注意nrow()只用在data.frame
    m=mean(c)
    x$x[i]<-m  #覆盖掉x
  }
  
  #windows(1280,720)
  par(mfrow=c(1,2))
  plot(density(a$a), main = "原本分布") #destiny是核函数密度估计
  plot(density(x$x), main = "样本均值分布")  
}

a <- rexp(10,1)
a
fun(a)
a <- data.frame(a)
a
nrow(a)
a[1]
a[[1]]
a[1][1]
a[1,]
a[,1]
sample(nrow(a),5)
a[sample(nrow(a),5), ]

# 二维正态分布图形 -----------------------------------------
install.packages("shape")
library("shape") #需要用drapecol()函数
library("MASS") #需要用fractions()函数
par(mfrow=c(1,2),bg = "white")
#第一种参数设置
x <- seq(-5,5, by=0.15)
y <- x
rou<-0
mu1<-0
mu2<-0
sgm1<-1
sgm2<-1
lab1<-paste("二维正态分布概率密度曲面"," N(",mu1,mu2,sgm1,fractions(sgm2),rou,")")

f<-function(x,y) {(1.0/(2.0*pi*sgm1*sgm2*sqrt(1-rou^2)))*exp((-1.0/(2.0*(1-rou^2)))*((((x-mu1)^2)/(sgm1^2))-(2*rou*(x-mu1)*(y-mu2)/(sgm1*sgm2))+(((y-mu2)^2)/sgm2^2)))} #二维正态分布概率密度函数表达式
z <- outer(x, y, f)  #生成概率密度值
persp(x, y, z, theta = 60, phi = 10, expand =0.6, r=180,ltheta = 0,shade = 0.5, ticktype = "detailed", xlab = "X", ylab = "Y",col=drapecol(z),main = lab1) #三维画图

#第二种参数设置
x <- seq(-5,5, by=0.15)
y <- x
rou<-0.5
mu1<-1
mu2<--1
sgm1<-2
sgm2<-1/2

lab1<-paste("二维正态分布概率密度曲面"," N(",mu1,mu2,sgm1,fractions(sgm2),rou,")")
z <- outer(x, y, f)
persp(x, y, z, theta = 60, phi = 40, expand =0.6, r=180,ltheta = 0,shade = 0.5, ticktype = "detailed", xlab = "X", ylab = "Y",col=drapecol(z),main = lab1)

# 编写函数 -------------------------------------------
lst <- list(name = "fred", wife = "mary")
lst
lst$name
lst$wife
# 二分法求方程的根
fzero <- function(f, a, b, eps = 1e-5) {
  if (f(a)*f(b) > 0)
    list(fail = "finding root is fail!")
  else {
    repeat {
      if (abs(b - a) < eps) 
        break
      x <- (a + b)/2
      if (f(a) * f(x) < 0) 
        b <- x 
      else {
        a <- x
      }
    }
    list(root = (a +b)/2, fun = f(x))
  }
}

f <- function(x) {
  x^2 - 2*x -3
}

x1 <- fzero(f, -1.1, 3, 1e-10)
x1
x1$root
x1$fun

# 两样本T统计量
twosam <- function(x1, x2) {
  n1 <- length(x1)
  n2 <- length(x2)
  xb1 <- mean(x1)
  xb2 <- mean(x2)
  s1 <- var(x1)
  s2 <- var(x2)
  s <- ((n1-1)*s1+(n2-1)*s2)/(n1+n2-2)
  list(T = (xb1 - xb2)/sqrt(s*(1/n1+1/n2)))
}

A <- c(79.98, 80.04, 80.02, 80.04, 80.03, 80.03, 80.04, 79.97, 80.05, 80.03, 80.02, 80.00, 80.02)
B <- c(80.02, 79.94, 79.98, 79.97, 79.97, 80.03, 79.95, 79.97)

twosam(A, B)

# 定义新的二元运算
# 例2.6 求解非线形方程组 --------------------------------------------------

newtons <- function(fun, x, ep = 1e-5, it_max = 100) {
  index <- 0
  k <- 1
  while (k < it_max) {
    x1 <- x
    obj <- fun(x)
    x <- x - solve(obj$J, obj$f)
    norm <- sqrt((x - x1) %*% (x - x1))
    if (norm < ep) {
      index <- 1
      break
    }
    k <- k + 1
  }
  obj <- fun(x)
  list(root = x, it = k, index = index, FunVal = obj$f)
}

funs <- function(x) {
  f <- c(x[1]^2 + x[2]^2 - 5, (x[1] + 1) * x[2] - (3 * x[1] + 1))
  J <- matrix(c(2 * x[1], 2 * x[2], x[2] - 3, x[1] + 1), nrow = 2, byrow = T)
  list(f = f, J = J)
}
x  <- c(0.1, 0.5)
x1 <- c(1, 3)
x1
t(x1)
dim(x1)
dim(t(x1))
x %*% t(x1)
t(x) %*% x1
funs(x)$f
funs(x)$J

newtons(funs, c(0 , 1))

# 递归函数
area <- function(f, a, b,eps = 1e-6, lim = 10) {
  fun1 <- function(f, a, b, fa, fb, a0, eps, lim, fun) {
    d <- (a + b)/2
    h <- (b - a)/4
    fd <- f(d)
    a1 <- h * (fa + fd)
    a2 <- h * (fd + fb)
    if (abs(a0 - a1 - a2) < eps | lim == 0)
      return(a1 + a2)
    else {
      return(fun(f, a, d, fa, fd, a1, eps, lim - 1, fun) + fun(f, d, b, fd, fb, a2, eps, lim - 1, fun))
    }
  }
  fa <- f(a)
  fb <- f(b)
  a0 <- ((fa + fb) * (b - a))/2
  fun1(f, a, b, fa, fb, a0, eps, lim, fun1)
}

f <- function(x) {
  1/x
}

f(100)
area(f, 1, 5)

rm(list = ls())
a <- 1
a[2] <- 3
a
a[1]

# 数据类型
a <- numeric()
mode(a)
a
for (i in 1:10){
  a[i] <- 2*i + 1
  i <- i + 1
}
a
mode(a)

a <- list()
mode(a)
a
for (i in 1:10){
  a[i] <- 2*i + 1
  i <- i + 1
}
a
mode(a)

a <- c()
mode(a)
a
for (i in 1:10){
  a[i] <- 2*i + 1
  i <- i + 1
}
a
mode(a)

# 循环语句:乘法口诀
n <- 9
x <- array(0, dim = c(n, n))
for (i in 1:n){
  for (j in 1:i){
    x[i, j] <- i * j
  }
}
x

for (i in 1:9){
  for (j in 1:i){
    cat(sprintf('%d x %d = %2d  ', i, j, i*j))
  }
  cat(sprintf("\n"))
}

# %s：字符串，%nd：占n位的整数，%m.nf：浮点数，%%：百分数
sprintf("%d",23)
sprintf("%.8f",23.154)
sprintf("my name is %s", "zhulu")
sprintf("占比为 %.2f %%", 23)

# echarts4r包 ----------------------------------------------------------
library(tidyverse)
library(echarts4r)
iris %>% 
    group_by(Species) %>% 
    e_charts(Sepal.Length) %>% 
    e_line(Sepal.Width) %>% 
    e_title("Group data")


# 函数及作用区域
a <- 3
# 运行函数之前
a

Sum <- function(b) {
  a <<- 1
  a + b
}

Sum(10)
# 运行函数之后
a

# 函数式编程 ----------------------------------------------------------
# 函数不仅仅可以被调用，也可以被当作函数的参数或返回值
f <- function(x, fun){
  fun(x)
}
f(1:10,sum)
f(1:10,mean)

# 验证大数定律 ----------------------------------------------------------
x <- runif(100000, 0, 1)
plot(density(x))
sam <- c()
for (i in 1:5){
  sam1 <- sample(x, 5)
  sam[i] <- sum(sam1)
}
sam
plot(density(sam))

x <- seq(-pi, pi, 0.1)
y <- sin(x)
plot(x, y)

x <- c(10, 6, 4, 7, 8)
sort(x)
order(x)
list(x)
sort.list(x)

x <- rnorm(1000, 0, 1)
d <- density(x)
d
plot(d)
summary(d)

mu <- Inf
mu
mode(Inf)

mean(df)

# 课后P106习题2.7
fun2_7 <- function(n) {
  if (n <= 0)
    print("要求输入一个正整数")
  else repeat {
    if (n %% 2 == 0) {
      n <- n / 2
      print(n)
    }
    else {
      n <- 3 * n + 1
      print(n)
    }
    if (n == 1) {
      print("运算成功")
      break
    }}
}

myf <- function(n) {
  if (n %% 1 == 0) {
    if (n <= 0) 
      print("要求输入一个正整数")
    else repeat {
        if (n%%2==0) {
          n <- n/2
          print(n)}
        else {
          n <- 3*n+1
          print(n)}
        if (n==1) { 
          print("运算成功")
          break}
    }
    }
  else print("请输入一个整数")
}

myf(10.1)
myf(-10)
myf(10)


fun2_7(1)
fun2_7(1)
fun2_7(100)
fun2_7(-1)

fun2_7 <- function(n) {
  if (n <= 0)
    print("要求输入一个正整数")
  else while (n > 1) {
    if (n %% 2 == 0) {
      n <- n / 2
      print(n)
    }
    else {
      n <- 3 * n + 1
      print(n)
    }
    if (n == 1) {
      print("运算成功")
    }}
}
# 第2章 R软件的使用 --------------------------------------------------------------
a <- 1:24
dim(a) <- c(2, 3, 4)
a



# 第3章 数据描述性分析
## 3.1 描述统计量
### 3.1.1 位置的度量
####  1.均值


# 计算各种描述性统计量 --------------------------------------------------------------
x <- 1:12
dim(x) <- c(3, 4)
x

mean(x)
apply(x, 1, mean) # 行方向
apply(x, 2, mean) # 列方向

df <- as.data.frame(x)
df
mean(df)
mean(df$V1)

x <- c(0, 1, 2, 3, NA)
mean(x)
mean(x, na.rm = TRUE)

### 3.1.3 分布形状的度量
# 例 编写一个统一的函数，计算样本的各种描述性统计量
data_outline <- function(x){
  n <- length(x)
  m <- mean(x)
  v <- var(x)
  s <- sd(x)
  me <- median(x)
  cv <- 100*s/m
  css <- sum((x - m)^2)
  uss <- sum(x^2)
  R <- max(x) - min(x)
  R1 <- quantile(x, 3/4) - quantile(x, 1/4)
  sm <- s/sqrt(n)
  g1 <- n/((n - 1)*(n - 2))*sum((x - m)^3)/s^3
  g2 <- (n*(n+1)*sum((x - m)^4))/((n-1)*(n-2)*(n-3)*s^4) - 3*(n-1)^2/((n-2)*(n-3))
  data.frame(
    N = n,
    Mean = m,
    Var = v,
    std_dev = s,
    Median = me,
    std_mean = sm,
    CV = cv,
    CSS = css,
    USS = uss,
    R = R,
    R1 = R1,
    Skewness = g1,
    Kurtosis = g2,
    row.names = 1        
  )
}

x <- c(75.0, 64.0, 47.4, 66.9, 62.2, 62.2, 58.7, 63.5, 66.6, 64.0, 57.0, 69.0, 56.9, 50.0, 72.0)
data_outline(x)
# 数据的分布 -------------------------------------------------------------------
x <- c(75.0, 64.0, 47.4, 66.9, 62.2, 62.2, 58.7, 63.5, 66.6, 64.0, 57.0, 69.0, 56.9, 50.0, 72.0)
hist(x, freq = FALSE)
lines(density(x), col = "blue")
y <- 44:76
lines(y, dnorm(y, mean(x), sd(x)), col = "red")

lines(y, dnorm(y, mean(x), sd(x)), col = "red")


# 外积 ----------------------------------------------------------------------
x <- 1:3
y <- 4:6
x
y
x %o% y
outer(x, y)
outer(x, y, "^")
outer(x, y, "+")


x <- 1:9
x
names(x) <- x
# Multiplication & Power Tables
x %o% x
y <- 2:8; names(y) <- paste(y,":", sep = "")
outer(y, x, `^`)
outer(y, x, `+`)

# 等值线或曲面图 -----------------------------------------------------------------
x <- y <- seq(-2*pi,2*pi,by = pi/15)
f <- function(x , y) sin(x)*sin(y)
z <- outer(x, y, f)
z


# 轮廓图函数 -------------------------------------------------------------------
outline <- function(x, txt = TRUE){
  if (is.data.frame(x) == TRUE)
    x <- as.matrix(x) # 
  m <- nrow(x) # m = 12名学生
  n <- ncol(x) # n = 5门课程
  plot(c(1,5), c(min(x),max(x)),type = "n",
      main = "The Outline graph of Data",
      xlab = "Number",
      ylab = "Value")
  for (i in 1:12){
    lines(x[i,], col = i)
    if (txt == TRUE){
      k <-  dimnames(x)[[1]][i]
      text(1+(i-1)%%n, x[i, 1+(i-1)%%n], k)
    }
  }
}
setwd("/Users/zhulu/工作/上课/上课内容/R程序与数据/Chapter03/")
x <- read.table("course.data")
mar <- as.matrix(x)
outline(x)
x
mar
x[1, ]
mar[1, ]
x[1]
mar[1]
mar[2]
mar[3]
length(x)
length(mar)
# 以下为学习内容：
min(x)
max(x)
for (i in 1:10){
  print(i %% 5)
}


x[1, ]
dimnames(x)
dimnames(x)[[1]]
dimnames(x)[[2]]
dimnames(x)[[2]][1]

# 调和曲线图 ----------------------------------------------------------
unison <- function(x) {
  if (is.data.frame(x) == TRUE)
    x <- as.matrix(x)
  t <- seq(-pi, pi, pi/30)
  m <- nrow(x)
  n <- ncol(x)
  f <- array(0, c(m, length(t)))
  for (i in 1:m){
    f[i, ] <- x[i, 1]/sqrt(2)
    for (j in 2:n){
      if (j %% 2 ==0)
        f[i, ] <- f[i, ] + x[i, j]*sin(j/2*t)
      else
        f[i, ] <- f[i, ] + x[i, j]*cos(j %/% 2 * t)
    }
  }
  plot(c(-pi, pi), c(min(f), max(f)), type = "n",
    main = "The Unison graph of Data",
    xlab = "t", ylab = "f(t)")
  for (i in 1:m) lines(t, f[i, ], col = i)
}
unison(x)

# 理解上面的函数
x <- as.matrix(x)
t <- seq(-pi, pi, pi/30)
t
sin(t)
f[1, ]
m <- nrow(x)
n <- ncol(x)
f <- array(0, c(m, length(t)))
f
f[1, ] + sin(t)
f[1, ] <- x[1, 1]/sqrt(2)
f[1, ] <- f[1, ] + x[1, 2]*sin(2/2*t)
f[1, ] <- f[1, ] + x[1, 3]*cos(3 %/% 2 * t)
f[1, ]

# 线性回归 ----------------------------------------------------------
x<-c(0.10,0.11,0.12,0.13,0.14,0.15,0.16,0.17,0.18,0.20,0.21,0.23)
y<-c(42.0,43.5,45.0,45.5,45.0,47.5,49.0,53.0,50.0,55.0,55.0,60.0)
fm<-lm(y ~ 1+x)
summary(fm)
summary(fm)$coefficients
fm$coefficients
fm$residuals
# 手动生成回归系数的置信区间
beta_int <- function(fm, alpha = 0.05) {
  A <- summary(fm)$coefficients
  df <- fm$df.residual
  left <- A[, 1] - A[, 2]*qt(1 - alpha/2, df)
  right <- A[, 1] + A[, 2]*qt(1 - alpha/2, df)
  rowname <- dimnames(A)[[1]]
  colname <- c("Estimates", "Left", "Right")
  matrix(c(A[, 1], left, right), ncol = 3, dimnames = list(rowname, colname))
}
beta_int(fm)

# if语句 ----------------------------------------------------------
x <- -2:2
x
if (x > 0) x <- -1  else x <- 1  # if语句不支持向量化运行，会提示错误；
x

x <- 2
if (x > 0) {
  x <- 100
  }else{
  x <- 0}
x
# 对比和上面的区别：
x <- 2
if (x > 0) {
  x <- 100}  # 大括号的位置，这里表示if已经结束，下一行出现else就会报错，但是放到else前面就连到一起了
  else{
  x <- 0}
x

x <- -2:2
x
ifelse( x > 0, x <- -1, x <- 1) # ifelse支持向量化运行，并且支持嵌套；
x
# 轮廓图 ----------------------------------------------------------
getwd()
setwd("/Users/zhulu/工作/上课/上课内容/R程序与数据/Chapter03")
x <- read.table("course.data")
mode(x)
x <- as.matrix(x)
x[1, ]
dimnames(x)
plot(c(1, 5), c(min(x), max(x)))
lines(x[1, ], col="red")


outline(x)

outline <- function(x, txt = TRUE){
  if (is.data.frame(x) == TRUE)
    x <- as.matrix(x)
  m <- nrow(x)
  n <- ncol(x)
  plot(c(1,n), c(min(x),max(x)),type = "n",
      main = "The Outline graph of Data",
      xlab = "Number",
      ylab = "Value")
  for (i in 1:m){
    lines(x[i,], col = i)
    if (txt == TRUE){
      k <-  dimnames(x)[[1]][i]
      text(1+(i-1)%%n, x[i, 1+(i-1)%%n], k)
    }
  }
}

# 调和图 ----------------------------------------------------------
unison <- function(x) {
  if (is.data.frame(x) == TRUE)
    x <- as.matrix(x)
  t <- seq(-pi, pi, pi/30)
  m <- nrow(x)
  n <- ncol(x)
  f <- array(0, c(m, length(t)))
  for (i in 1:m){
    f[i, ] <- x[i, 1]/sqrt(2)
    for (j in 2:n){
      if (j %% 2 ==0)
        f[i, ] <- f[i, ] + x[i, j]*sin(j/2*t)
      else
        f[i, ] <- f[i, ] + x[i, j]*cos(j %/% 2 * t)
    }
  }
  plot(c(-pi, pi), c(min(f), max(f)), type = "n",
    main = "The Unison graph of Data",
    xlab = "t", ylab = "f(t)")
  for (i in 1:m) lines(t, f[i, ], col = i)
}
unison(x)

# outer ----------------------------------------------------------
x1 <- seq(-2*pi,2*pi,by = pi/15)
y1 <- seq(-2*pi,2*pi,by = pi/15)
f <- function(x , y) sin(x)*sin(y)
z1 <- outer(x1, y1, f)
z1
persp(x1, y1, z1,theta = 30, phi = 30, expand = 0.7, col = "lightblue")

library(rgl)
plot3d(x1, y1, z1)

# 回归 ----------------------------------------------------------
# install.packages("car")
library("car")
vif(lm(prestige ~ income + education, data=Duncan))
vif(lm(prestige ~ income + education + type, data=Duncan))
vif(lm(prestige ~ (income + education)*type, data=Duncan),
    type="terms") # not recommended
vif(lm(prestige ~ (income + education)*type, data=Duncan),
    type="predictor")

# 非线性回归系数估计值的协方差矩阵
cl<-data.frame(
  X=c(rep(2*4:21, c(2, 4, 4, 3, 3, 2, 3, 3, 3, 3, 2, 
      3, 2, 1, 2, 2, 1, 1))),
  Y=c(0.49, 0.49, 0.48, 0.47, 0.48, 0.47, 0.46, 0.46, 
      0.45, 0.43, 0.45, 0.43, 0.43, 0.44, 0.43, 0.43, 
      0.46, 0.45, 0.42, 0.42, 0.43, 0.41, 0.41, 0.40, 
      0.42, 0.40, 0.40, 0.41, 0.40, 0.41, 0.41, 0.40, 
      0.40, 0.40, 0.38, 0.41, 0.40, 0.40, 0.41, 0.38, 
      0.40, 0.40, 0.39, 0.39)
)
head(cl)
length(cl$X)
nls_sol <- nls(Y~a + (0.49 - a) * exp(-b * (X - 8)), data = cl, start = list(a = 0.1, b = 0.01))
sum_sol <- summary(nls_sol)

sum_sol$parameters

nls_sol$Parameters[1 ,1]
nls_sol$Parameters[2 ,1]

alpha = 0.05
nls_sum <- summary(nls_sol)
A <- nls_sum$parameters
paramet <- A[, 1]
df <- nls_sum$df[2]
left <- A[, 1] - A[, 2]*qt(1 - alpha/2, df)
right <- A[, 1] + A[, 2]*qt(1 - alpha/2, df)
rowname <- dimnames(A)[[1]]
colname <- c("Estimate", "Left", "Right")
dimnames = list(rowname, colname)
matrix(c(paramet, left, right), ncol = 3, dimnames = list(rowname, colname))

# nlm()函数求解非线性模型参数 --------------------------------------------------
fn <- function(p, X, Y) {
  f <- Y - p[1] - (0.49 - p[1])*exp(-p[2]*(X - 8))
  res <- sum(f^2)
  f1 <- -1 + exp(-p[2]*(X - 8))
  f2 <- (0.49 - p[1])*exp(-p[2]*(X - 8))*(X - 8)
  J <- cbind(f1, f2)
  attr(res, "gradient") <- 2*t(J)%*%f
  res
}
out <- nlm(fn, p = c(0.1, 0.01), X = cl$X, Y = cl$Y, hessian = TRUE)
out
p = c(0.1, 0.01)
p[1]
X = cl$X 
Y = cl$Y
f <- Y - p[1] - (0.49 - p[1])*exp(-p[2]*(X - 8))
f
length(f)
res <- sum(f^2)
res
f1 <- -1 + exp(-p[2]*(X - 8))
f1
f2 <- (0.49 - p[1])*exp(-p[2]*(X - 8))*(X - 8)
f2
J <- cbind(f1, f2)
J
attr(res, "gradient") <- 2*t(J)%*%f
res
attributes(res)

# 线性回归 ----------------------------------------------------------
x<-c(0.10,0.11,0.12,0.13,0.14,0.15,0.16,0.17,0.18,0.20,0.21,0.23)
y<-c(42.0,43.5,45.0,45.5,45.0,47.5,49.0,53.0,50.0,55.0,55.0,60.0)
# lm()函数回归
fm0<-lm(y ~ x)
summary(fm0)
# 一元回归最小二乘公式：
# 回归系数：
b1 <- sum((x - mean(x)) * (y - mean(y)))/sum((x - mean(x))^2)
b1
b0 <- mean(y) - b1 * mean(x)
b0
# 回归系数的标准差
sigma <- sqrt(sum((y - b0 - b1*x)^2)/(length(x) - 2))
sigma
sd_b1 <- sigma / sqrt(sum((x - mean(x))^2))
sd_b1
sd_b0 <- sigma * sqrt((1 / length(x)) + (mean(x)^2)/sum((x - mean(x)) * (x - mean(x))))
sd_b0
# 矩阵式，多元回归
X <- as.matrix(cbind(1, x))
X
Y <- as.matrix(y)
Y
b <- solve(t(X) %*% X) %*% t(X) %*% Y
b
# 协方差矩阵
var_b <- sigma^2 * solve(t(X) %*% X)
sqrt(var_b[1, 1])
sqrt(var_b[2, 2])
# QR分解求解回归系数，
qr <- qr(X)
Q <- qr.Q(qr)
Q
t(Q) %*% Q
R <- qr.R(qr)
R
b <- solve(R) %*% t(Q) %*% Y
b

# 矩阵式多元回归系数
toothpaste<-data.frame(
  X1=c(-0.05, 0.25,0.60,0,   0.25,0.20, 0.15,0.05,-0.15, 0.15,
        0.20, 0.10,0.40,0.45,0.35,0.30, 0.50,0.50, 0.40,-0.05,
        -0.05,-0.10,0.20,0.10,0.50,0.60,-0.05,0,    0.05, 0.55),
  X2=c( 5.50,6.75,7.25,5.50,7.00,6.50,6.75,5.25,5.25,6.00,
        6.50,6.25,7.00,6.90,6.80,6.80,7.10,7.00,6.80,6.50,
        6.25,6.00,6.50,7.00,6.80,6.80,6.50,5.75,5.80,6.80),
  Y =c( 7.38,8.51,9.52,7.50,9.33,8.28,8.75,7.87,7.10,8.00,
        7.89,8.15,9.10,8.86,8.90,8.87,9.26,9.00,8.75,7.95,
        7.65,7.27,8.00,8.50,8.75,9.21,8.27,7.67,7.93,9.26)
)
head(toothpaste)
# 多元回归系数
X <- as.matrix(cbind(1, toothpaste$X1,toothpaste$X2))
Y <- as.matrix(toothpaste$Y)
b <- solve(t(X) %*% X) %*% t(X) %*% Y
b_t <- t(Y) %*% X %*% solve(t(X) %*% X)
b
b_t
t(Y) %*% Y
t(Y) %*% X %*% b
t(b) %*% t(X) %*% Y
t(b) %*% t(X) %*% X %*% b

# 回归系数协方差矩阵
sigma <- sqrt(sum((Y - X %*% b)^2)/(length(Y) - 2 - 1))
var_b <- sigma^2 * solve(t(X) %*% X)
var_b
sqrt(var_b[1, 1])
sqrt(var_b[2, 2])
sqrt(var_b[3, 3])

# 方差分析 ----------------------------------------------------------
setwd("/Users/zhulu/工作/上课/上课内容/R程序与数据/Chapter07")
lamp<-data.frame(
  X=c(1600, 1610, 1650, 1680, 1700, 1700, 1780, 1500, 1640, 
      1400, 1700, 1750, 1640, 1550, 1600, 1620, 1640, 1600, 
      1740, 1800, 1510, 1520, 1530, 1570, 1640, 1600),
  A=factor(c(rep(1,7),rep(2,5), rep(3,8), rep(4,6)))
)
lamp_aov<-aov(X ~ A, data=lamp)
summary(lamp_aov)

anova_tab<-function(fm){
  tab<-summary(fm)
  k<-length(tab[[1]])-2
  temp<-c(sum(tab[[1]][,1]), sum(tab[[1]][,2]), rep(NA,k))
  tab[[1]]["Total",]<-temp
  tab
}

anova_tab(lamp_aov)

plot(lamp$X~lamp$A)
tab<-summary(fm)
mode(tab)
k<-length(tab[[1]])-2
temp<-c(sum(tab[[1]][,1]), sum(tab[[1]][,2]), rep(NA,k))
tab[[1]]["Total",]<-temp
tab

# 正交试验设计
rate<-data.frame(
  A=gl(3,3), 
  B=gl(3,1,9),
  C=factor(c(1,2,3,2,3,1,3,1,2)),
  Y=c(31, 54, 38, 53, 49, 42, 57, 62, 64)
)
rate

K<-matrix(0, nrow=3, ncol=3, dimnames=list(1:3, c("A", "B", "C")))

for (j in 1:3)
  for (i in 1:3)
    K[i,j]<-mean(rate$Y[rate[j]==i]) # 将每一列下面的各类分别求均值

K

K[1, 1] <- mean(rate$Y[rate[1]==1])
K[2, 1] <- mean(rate$Y[rate[1]==2])
K[3, 1] <- mean(rate$Y[rate[1]==3])

# 判别分析 ----------------------------------------------------------
discriminiant.distance<-function(TrnX1, TrnX2, TstX = NULL, var.equal = FALSE){
  if (is.null(TstX) == TRUE) 
    TstX<-rbind(TrnX1,TrnX2)
  if (is.vector(TstX) == TRUE)  
    TstX<-t(as.matrix(TstX))
  else if (is.matrix(TstX) != TRUE)
    TstX<-as.matrix(TstX)
  if (is.matrix(TrnX1) != TRUE) 
    TrnX1<-as.matrix(TrnX1)
  if (is.matrix(TrnX2) != TRUE) 
    TrnX2<-as.matrix(TrnX2)

  nx<-nrow(TstX)
  blong<-matrix(rep(0, nx), nrow=1, byrow=TRUE, 
        dimnames=list("blong", 1:nx))
  mu1<-colMeans(TrnX1); mu2<-colMeans(TrnX2) 
  if (var.equal == TRUE  || var.equal == T){
      S<-var(rbind(TrnX1,TrnX2))
      w<-mahalanobis(TstX, mu2, S)-mahalanobis(TstX, mu1, S)
  }
  else{
      S1<-var(TrnX1); S2<-var(TrnX2)
      w<-mahalanobis(TstX, mu2, S2)-mahalanobis(TstX, mu1, S1)
  }
  for (i in 1:nx){
      if (w[i]>0)
          blong[i]<-1
      else
          blong[i]<-2
  }
  blong
}

TrnX1<-data.frame(
    x1=c(6.60,  6.60,  6.10,  6.10,  8.40,  7.2,   8.40,  7.50,  
        7.50,  8.30,  7.80,  7.80),
    x2=c(39.00, 39.00, 47.00, 47.00, 32.00,  6.0, 113.00, 52.00,
        52.00,113.00,172.00,172.00),
    x3=c(1.00,  1.00,  1.00,  1.00,  2.00,  1.0,   3.50,  1.00,
        3.50,  0.00,  1.00,  1.50),
    x4=c(6.00,  6.00,  6.00,  6.00,  7.50,  7.0,   6.00,  6.00,
        7.50,  7.50,  3.50,  3.00),
    x5=c(6.00, 12.00,  6.00, 12.00, 19.00, 28.0,  18.00, 12.00,
        6.00, 35.00, 14.00, 15.00),
    x6=c(0.12,  0.12,  0.08,  0.08,  0.35,  0.3,   0.15,  0.16,
        0.16,  0.12,  0.21,  0.21),
    x7=c(20.00, 20.00, 12.00, 12.00, 75.00, 30.0,  75.00, 40.00,
        40.00,180.00, 45.00, 45.00)
)
TrnX2<-data.frame(
    x1=c(8.40,  8.40,  8.40,  6.3, 7.00,  7.00,  7.00,  8.30,
        8.30,   7.2,   7.2,  7.2, 5.50,  8.40,  8.40,  7.50,
        7.50,  8.30,  8.30, 8.30, 8.30,  7.80,  7.80),
    x2=c(32.0 ,32.00, 32.00, 11.0, 8.00,  8.00,  8.00, 161.00,
        161.0,   6.0,   6.0,  6.0, 6.00,113.00,113.00,  52.00,
        52.00, 97.00, 97.00,89.00,56.00,172.00,283.00),
    x3=c(1.00,  2.00,  2.50,  4.5, 4.50,  6.00,  1.50,  1.50,
        0.50,   3.5,   1.0,  1.0, 2.50,  3.50,  3.50,  1.00,
        1.00,  0.00,  2.50, 0.00, 1.50,  1.00,  1.00),
    x4=c(5.00,  9.00,  4.00,  7.5, 4.50,  7.50,  6.00,  4.00,
        2.50,   4.0,   3.0,  6.0, 3.00,  4.50,  4.50,  6.00,
        7.50,  6.00,  6.00, 6.00, 6.00,  3.50,  4.50),
    x5=c(4.00, 10.00, 10.00,  3.0, 9.00,  4.00,  1.00,  4.00,
        1.00,  12.0,   3.0,  5.0, 7.00,  6.00,  8.00,  6.00,
        8.00,  5.00,  5.00,10.00,13.00,  6.00,  6.00),
    x6=c(0.35,  0.35,  0.35,  0.2, 0.25,  0.25,  0.25,  0.08,
        0.08,  0.30,   0.3,  0.3, 0.18,  0.15,  0.15,  0.16,
        0.16,  0.15,  0.15, 0.16, 0.25,  0.21,  0.18),
    x7=c(75.00, 75.00, 75.00,  15.0, 30.00, 30.00, 30.00, 70.00,
        70.00,  30.0,  30.0,  30.0, 18.00, 75.00, 75.00, 40.00,
        40.00,180.00,180.00,180.00,180.00, 45.00, 45.00)
)
setwd("/Users/zhulu/工作/上课/上课内容/R程序与数据/Chapter08")
source("discriminiant.distance.R")
discriminiant.distance(classX1, classX2, var.equal=TRUE)
discriminiant.distance(classX1, classX2)

# 理解距离判别
TstX<-rbind(TrnX1,TrnX2)
TstX
nx<-nrow(TstX)
nx
blong<-matrix(rep(0, nx), nrow=1, byrow=TRUE, dimnames=list("blong", 1:nx))
mu1<-colMeans(TrnX1)
mu1
mu2<-colMeans(TrnX2) 
var.equal = TRUE
if (var.equal == TRUE  || var.equal == T){ # 方差相等
    S<-var(rbind(TrnX1,TrnX2)) # 7*7协方差矩阵
    w<-mahalanobis(TstX, mu2, S)-mahalanobis(TstX, mu1, S)
}else{
    S1<-var(TrnX1)
    S2<-var(TrnX2)
    w<-mahalanobis(TstX, mu2, S2)-mahalanobis(TstX, mu1, S1)
}
w
for (i in 1:nx){
    if (w[i]>0)
        blong[i]<-1
    else
        blong[i]<-2
}
blong

# 马氏距离
mu <- colMeans(classX1)
s <- var(classX1)
x <- c(6.6, 39, 1.0, 6.0, 12, 0.12, 20)
D <- (x - mu) %*% solve(s) %*% (x - mu)
D
D1 <- t(x - mu) %*% solve(s) %*% (x - mu)
D1
# 上面两种方式是对的，下面是错的：
D <- (x - mu) %*% solve(s) %*% t(x - mu)
D <- t(x - mu) %*% solve(s) %*% t(x - mu)
D

# 多分类判别 ----------------------------------------------------------
distinguish.distance<-function(TrnX, TrnG, TstX = NULL, var.equal = FALSE){
  if ( is.factor(TrnG) == FALSE){  # 如果TrnG不是因子变量，是另外一个训练集
      mx<-nrow(TrnX)
      mg<-nrow(TrnG)
      TrnX<-rbind(TrnX, TrnG)
      TrnG<-factor(rep(1:2, c(mx, mg)))
  }
  if (is.null(TstX) == TRUE) 
    TstX<-TrnX
  if (is.vector(TstX) == TRUE)  
    TstX<-t(as.matrix(TstX))
  else if (is.matrix(TstX) != TRUE)
      TstX<-as.matrix(TstX)
  if (is.matrix(TrnX) != TRUE) 
    TrnX<-as.matrix(TrnX)

  nx<-nrow(TstX)
  blong<-matrix(rep(0, nx), nrow=1, dimnames=list("blong", 1:nx))
  g<-length(levels(TrnG))
  mu<-matrix(0, nrow=g, ncol=ncol(TrnX))
  for (i in 1:g)
      mu[i,]<-colMeans(TrnX[TrnG==i,]) 
  D<-matrix(0, nrow=g, ncol=nx)
  if (var.equal == TRUE  || var.equal == T){
      for (i in 1:g)
        D[i,]<- mahalanobis(TstX, mu[i,], var(TrnX))
  }
  else{
      for (i in 1:g)
        D[i,]<- mahalanobis(TstX, mu[i,], var(TrnX[TrnG==i,]))
  }
  for (j in 1:nx){
      dmin<-Inf
      for (i in 1:g)
          if (D[i,j]<dmin){
            dmin<-D[i,j]; blong[j]<-i
      }
  }
  blong
}
# 理解上面的过程：
iris
class(iris)
class(iris[[1]])

TstX <- iris[, 1:4]
TrnX <- iris[, 1:4]
class(TstX)
TrnX[[1]]
class(TrnX[[1]])

ma_iris <- as.matrix(iris)
ma_iris
mode(ma_iris)
class(ma_iris)
ma_iris[1, ]


ma_trnx <- as.matrix(TrnX)
ma_trnx
mode(ma_trnx)
class(ma_trnx)
is.matrix(ma_trnx)
is.array(ma_trnx)
ma_trnx[1 ,]
is.vector(ma_trnx[1, ])

TrnG <- gl(3, 50)
TrnG
nx<-nrow(TstX) # 总共150行
blong<-matrix(rep(0, nx), nrow=1, dimnames=list("blong", 1:nx)) # 生成一个分类变量，初始值为0
g<-length(levels(TrnG)) # 共3类
mu<-matrix(0, nrow=g, ncol=ncol(TrnX))
for (i in 1:g)
    mu[i,]<-colMeans(TrnX[TrnG==i,]) 
D<-matrix(0, nrow=g, ncol=nx)
D
if (var.equal == TRUE  || var.equal == T){
    for (i in 1:g)
      D[i,]<- mahalanobis(TstX, mu[i,], var(TrnX))  # 方差相等
}else{
    for (i in 1:g)
      D[i,]<- mahalanobis(TstX, mu[i,], var(TrnX[TrnG==i,])) # 方差不等
}
for (j in 1:nx){
    dmin<-Inf
    for (i in 1:g)
        if (D[i,j]<dmin){
          dmin<-D[i,j]
          blong[j]<-i
    }
}
blong
1/0 # Inf表示无穷大；
mahalanobis(TstX, mu[1,], var(TrnX))

as.matrix(TstX[1, ]- mu[1, ]) %*% solve(var(TrnX)) %*% as.matrix(TstX[1, ] - mu[1, ])
as.matrix(TstX[1, ]- mu[1, ]) %*% solve(var(TrnX)) %*% t(TstX[1, ] - mu[1, ])

# 相当于上面的mahalanobis函数：
mah <- numeric(length(TstX[[1]]))
for (i in 1:length(TstX[[1]])){  
  mah[i] <- as.matrix(TstX[i, ]- mu[1, ]) %*% solve(var(TrnX)) %*% t(TstX[i, ] - mu[1, ])}

as.matrix(TstX[1, ]- mu[1, ]) %*% solve(var(TrnX)) %*% (TstX[1, ] - mu[1, ])
(TstX[1, ]- mu[1, ]) %*% solve(var(TrnX)) %*% (TstX[1, ] - mu[1, ])
(TstX[1, ]- mu[1, ]) %*% solve(var(TrnX)) %*% t(TstX[1, ] - mu[1, ])

mu[1, ] %*% solve(var(TrnX)) %*% t(mu[1, ])

class(TstX)
class(TstX[1, ])
class(mu)
class(TstX[1, ]- mu[1, ])





# 主成分分析 ----------------------------------------------------------
#### 输入数据, 按下三角输入, 构成向量
x<-c(1.00, 
    0.79, 1.00, 
    0.36, 0.31, 1.00, 
    0.96, 0.74, 0.38, 1.00, 
    0.89, 0.58, 0.31, 0.90, 1.00, 
    0.79, 0.58, 0.30, 0.78, 0.79, 1.00, 
    0.76, 0.55, 0.35, 0.75, 0.74, 0.73, 1.00, 
    0.26, 0.19, 0.58, 0.25, 0.25, 0.18, 0.24, 1.00,
    0.21, 0.07, 0.28, 0.20, 0.18, 0.18, 0.29,-0.04, 1.00,
    0.26, 0.16, 0.33, 0.22, 0.23, 0.23, 0.25, 0.49,-0.34, 1.00, 
    0.07, 0.21, 0.38, 0.08,-0.02, 0.00, 0.10, 0.44,-0.16, 0.23, 
    1.00, 
    0.52, 0.41, 0.35, 0.53, 0.48, 0.38, 0.44, 0.30,-0.05, 0.50, 
    0.24, 1.00, 
    0.77, 0.47, 0.41, 0.79, 0.79, 0.69, 0.67, 0.32, 0.23, 0.31, 
    0.10, 0.62, 1.00, 
    0.25, 0.17, 0.64, 0.27, 0.27, 0.14, 0.16, 0.51, 0.21, 0.15, 
    0.31, 0.17, 0.26, 1.00, 
    0.51, 0.35, 0.58, 0.57, 0.51, 0.26, 0.38, 0.51, 0.15, 0.29, 
    0.28, 0.41, 0.50, 0.63, 1.00, 
    0.21, 0.16, 0.51, 0.26, 0.23, 0.00, 0.12, 0.38, 0.18, 0.14, 
    0.31, 0.18, 0.24, 0.50, 0.65, 1.00)
#### 输入变量名称
names<-c("X1", "X2", "X3", "X4", "X5", "X6", "X7", "X8", "X9",  
        "X10", "X11", "X12", "X13", "X14", "X15", "X16")
#### 将矩阵生成相关矩阵
R<-matrix(0, nrow=16, ncol=16, dimnames=list(names, names))
for (i in 1:16){
  for (j in 1:i){
      R[i,j]<-x[(i-1)*i/2+j]
      R[j,i]<-R[i,j]
  }
}
R
#### 作主成分分析
pr<-princomp(covmat=R)
summary(pr,loadings = TRUE)
eigen(R)$vectors[, 1:2]
load
load<-loadings(pr)
#### 画散点图
plot(load[,1:2])
text(load[,1], load[,2], adj=c(0, 0))
text(load[,1], load[,2], adj=c(0, 1))
text(load[,1], load[,2], adj=c(1, 1))
text(load[,1], load[,2], adj=c(1, 0))
text(load[,1], load[,2], adj=c(0.5, 1))

#### 用数据框的形式输入数据
conomy<-data.frame(
  x1=c(149.3, 161.2, 171.5, 175.5, 180.8, 190.7, 
      202.1, 212.4, 226.1, 231.9, 239.0),
  x2=c(4.2, 4.1, 3.1, 3.1, 1.1, 2.2, 2.1, 5.6, 5.0, 5.1, 0.7),
  x3=c(108.1, 114.8, 123.2, 126.9, 132.1, 137.7, 
      146.0, 154.1, 162.3, 164.3, 167.6),
  y=c(15.9, 16.4, 19.0, 19.1, 18.8, 20.4, 22.7, 
      26.5, 28.1, 27.6, 26.3)
)
#### 作线性回归
lm.sol<-lm(y~x1+x2+x3, data=conomy)
summary(lm.sol)

#### 作主成分分析
conomy.pr<-princomp(~x1+x2+x3, data=conomy, cor=T)
conomy.pr
summary(conomy.pr, loadings=TRUE)

#### 预测测样本主成分, 并作主成分分析
pre<-predict(conomy.pr)
conomy$z1<-pre[,1]
conomy$z2<-pre[,2]
lm.sol<-lm(y~z1+z2, data=conomy)
summary(lm.sol)

#### 作变换, 得到原坐标下的关系表达式
beta<-coef(lm.sol)
A<-loadings(conomy.pr)
beta[2]
A
A[, 1]
A[, 2]
x.bar<-conomy.pr$center
x.sd<-conomy.pr$scale
coef<-(beta[2]*A[,1]+ beta[3]*A[,2])/x.sd
beta0 <- beta[1]- sum(x.bar * coef)
c(beta0, coef)

# 作业9.2
spend <- data.frame(
    x1 = c(82.9, 88.0, 99.9, 105.3, 117.7, 131.0, 148.2, 161.8, 174.2, 184.7),
    x2 = c(92, 93, 96, 94, 100, 101, 105, 112, 112, 112),
    x3 = c(17.1, 21.3, 25.1, 29.0, 34.0, 40.0, 44.0, 49.0, 51.0, 53.0),
    x4 = c(94, 96, 97, 97, 100, 101, 104, 109, 111, 111),
    y = c(8.4, 9.6, 10.4, 11.4, 12.2, 14.2, 15.8, 17.9, 19.6, 20.8)
)
lm.sol <- lm(y~x1 + x2 + x3 +x4, data = spend)
summary(lm.sol)

cor(spend)

spend.pr <- princomp(~x1 + x2 +x3 +x4, data = spend, cor = T)
summary(spend.pr, loadings = TRUE)

screeplot(spend.pr)
pre <- predict(spend.pr)

spend$z1<-pre[,1]
spend$z2<-pre[,2]
spend
lm.sol<-lm(y~z1+z2, data=spend)
lm.sol<-lm(y~z1, data=spend)
summary(lm.sol)

# 作变换, 得到原坐标下的关系表达式
beta<-coef(lm.sol)
beta
A<-loadings(spend.pr)
A
A[, 1]
A[, 2]
x.bar<-spend.pr$center
x.sd<-spend.pr$scale
x.bar
x.sd
coef<-(beta[2]*A[,1])/x.sd
beta0 <- beta[1]- sum(x.bar * coef)
c(beta0, coef)


# 自定义一个多元正态的密度函数 ----------------------------------------------------------
# 输入参数X为一个p维列向量，计算服从N(mu, S2)的多元正态分布的密度函数；
class <- data.frame(
  x1=c(6.60,  6.60,  6.10,  6.10,  8.40,  7.2,   8.40,  7.50,  
      7.50,  8.30,  7.80,  7.80),
  x2=c(39.00, 39.00, 47.00, 47.00, 32.00,  6.0, 113.00, 52.00,
      52.00,113.00,172.00,172.00),
  x3=c(1.00,  1.00,  1.00,  1.00,  2.00,  1.0,   3.50,  1.00,
      3.50,  0.00,  1.00,  1.50),
  x4=c(6.00,  6.00,  6.00,  6.00,  7.50,  7.0,   6.00,  6.00,
      7.50,  7.50,  3.50,  3.00),
  x5=c(6.00, 12.00,  6.00, 12.00, 19.00, 28.0,  18.00, 12.00,
      6.00, 35.00, 14.00, 15.00),
  x6=c(0.12,  0.12,  0.08,  0.08,  0.35,  0.3,   0.15,  0.16,
      0.16,  0.12,  0.21,  0.21),
  x7=c(20.00, 20.00, 12.00, 12.00, 75.00, 30.0,  75.00, 40.00,
      40.00,180.00, 45.00, 45.00)
)
head(class)
mu <- colMeans(class)
mu
s2 <- var(class)
s2
solve(s2)

# 取出总体中两个样本：
class[1, ]
class[1, ][1, ]
as.matrix(class[1, ])
as.matrix(class[1, ])[1, ]

x <- as.matrix(class[1, ])[1, ]
y <- as.matrix(class[5, ])[1, ]
x
y
# 自定义一个计算多元正态分布密度函数的函数
normf <- function(X){ # 此处的X是指一个obs的p个特征变量X_i = （x_i1,x_i2,x_i3...x_ip)
  p <- length(X)
  fx <- (1/(((2*pi)^(p/2))*sqrt(det(s2))))*exp(-0.5*t(X-mu)%*%solve(s2)%*%(X-mu))
  fx
}

X <- x
X
normf(X)

# 尝试计算一个二元正态分布
mu <- c(0, 0)
mu
s2 <- matrix(c(0.04,0,0,0.04),nrow = 2)
s2
det(s2)
# 向量式：R语言支持向量式，x，y为标量的时候是对的，但是列向量的时候结果是错误的
normfx <- function(x,y){
  X <- cbind(x, y)
  fx <- (1/(((2*pi)^(2/2))*sqrt(det(s2))))*exp(-0.5*(X-mu)%*%solve(s2)%*%t(X-mu))
  fx # x和y是列向量，fx返回一个矩阵，而不是对应的点的密度函数值；
}

# 函数内使用循环取出单独的点来计算密度函数，返回的适合x，y向量长度一致的密度函数值列向量
normf <- function(x,y){
  ln <- length(x)
  fx <- 0
  for (i in 1:ln){
    X <- cbind(x[i],y[i])
    fx[i] <- (1/(((2*pi)^(2/2))*sqrt(det(s2))))*exp(-0.5*(X-mu)%*%solve(s2)%*%t(X-mu))
    }
  fx
}

# 外部循环计算密度函数
z2 <- matrix(0, nrow = length(x), ncol = length(y))
for (i in 1:length(x)){
  for (j in 1:length(y)){
    z2[i,j] <- normfx(x[i], y[j])
  }
}

# 分别使用上面的密度函数计算：
x <- seq(-1,1,by = 0.02)
y <- seq(-1,1,by = 0.02)

zx <- normfx(x, y) # outer(x, y, normfx) 报错，normfx返回的是一个矩阵
# 画3D图 ------------------------------------------------------------------
z1 <- outer(x, y, normf)
z1 - z2

persp(x, y, z1,theta = 30, phi = 30, expand = 0.7, col = "lightblue") # 正确的
persp(x, y, z2,theta = 30, phi = 30, expand = 0.7, col = "lightblue") # 和z1的结果是一致的
persp(x, y, zx,theta = 30, phi = 30, expand = 0.7, col = "lightblue") # 结果是错误的

# 验证是否对称
s2 <- matrix(c(0.2,0.1,0.1,0.2),nrow = 2)
s2
det(s2)
solve(s2) %*% s2
x <- c(0.2, 0.3)
y <- c(0.3, 0.4)
t(x) %*% s2 %*% y
t(y) %*% s2 %*% x

# 聚类分析 ----------------------------------------------------------
# scale()函数
x <- data.frame(
    x1=c(6.60,  6.60,  6.10,  6.10,  8.40,  7.2,   8.40,  7.50,  
        7.50,  8.30,  7.80,  7.80),
    x2=c(39.00, 39.00, 47.00, 47.00, 32.00,  6.0, 113.00, 52.00,
        52.00,113.00,172.00,172.00),
    x3=c(1.00,  1.00,  1.00,  1.00,  2.00,  1.0,   3.50,  1.00,
        3.50,  0.00,  1.00,  1.50),
    x4=c(6.00,  6.00,  6.00,  6.00,  7.50,  7.0,   6.00,  6.00,
        7.50,  7.50,  3.50,  3.00),
    x5=c(6.00, 12.00,  6.00, 12.00, 19.00, 28.0,  18.00, 12.00,
        6.00, 35.00, 14.00, 15.00),
    x6=c(0.12,  0.12,  0.08,  0.08,  0.35,  0.3,   0.15,  0.16,
        0.16,  0.12,  0.21,  0.21),
    x7=c(20.00, 20.00, 12.00, 12.00, 75.00, 30.0,  75.00, 40.00,
        40.00,180.00, 45.00, 45.00)
)
scale(x,center = TRUE, scale = TRUE) # center中心化，scale标准化

scale(x,center = TRUE, scale = FALSE) # center中心化:减去各自均值
sweep(x, 2, apply(x, 2, mean))

scale(x,center = FALSE, scale = TRUE) # scale标准化
# 相当于：
x_m <- as.matrix(x)
sum2 <- diag(sqrt((t(x_m) %*% x_m)/(length(x_m[, 1])-1)))
sweep(x, 2, sum2, "/")
var



scale(x,center = FALSE, scale = FALSE) # 相当于不做改动

# 为什么使用%o%
x - apply(x, 2, mean)
x - rep(1, length(x$x1)) %o% apply(x, 2, mean)

# 变量分类 --------------------------------------------------------------------
## 输入相关矩阵. 
x<- c(1.000, 0.846, 0.805, 0.859, 0.473, 0.398, 0.301, 0.382,
      0.846, 1.000, 0.881, 0.826, 0.376, 0.326, 0.277, 0.277, 
      0.805, 0.881, 1.000, 0.801, 0.380, 0.319, 0.237, 0.345, 
      0.859, 0.826, 0.801, 1.000, 0.436, 0.329, 0.327, 0.365, 
      0.473, 0.376, 0.380, 0.436, 1.000, 0.762, 0.730, 0.629, 
      0.398, 0.326, 0.319, 0.329, 0.762, 1.000, 0.583, 0.577, 
      0.301, 0.277, 0.237, 0.327, 0.730, 0.583, 1.000, 0.539, 
      0.382, 0.415, 0.345, 0.365, 0.629, 0.577, 0.539, 1.000)
names<-c("身高 x1", "手臂长 x2", "上肢长 x3", "下肢长 x4", "体重 x5", 
        "颈围 x6", "胸围 x7", "胸宽 x8")
r<-matrix(x, nrow=8, dimnames=list(names, names))
## 作系统聚类分析, 
## as.dist()的作用是将普通矩阵转化为聚类分析用的距离结构. 
r
d<-as.dist(1-r)
d
hc<-hclust(d) # hierarchical cluster
dend<-as.dendrogram(hc)
# 研究一下dend的结构
str(dend)
str(unclass(dend))
print(dend)
nobs(dend)
rev(x)
dend[1][1][1]
dend[[1]]
str(dend, max.level = NA,
    give.attr = TRUE, wid = getOption("width"),
    nest.lev = 0, indent.str = "",
    last.str = getOption("str.dendrogram.last"), stem = "--",
    )
is.leaf(dend[[1]][[1]][[1]])

## 写一段小程序, 其目的是在绘图命令中调用它, 使谱系图更好看.
nP<-list(col=3:2, cex=c(2.0, 0.75), pch= 21:22, 
        bg= c("light blue", "pink"),
        lab.cex = 1.0, lab.col = "tomato")
addE <- function(n){
  if(!is.leaf(n)) {
    attr(n, "edgePar") <- list(p.col="plum") # plum：紫红色,p.col:多边形文本框颜色；
    attr(n, "edgetext") <- paste(attr(n,"members"),"members")
  }
  n
}
## 画出谱系图.
de <- dendrapply(dend, addE)
plot(de, nodePar= nP)
plot(dend, nodePar= nP)
par(op)

# dendrogram ----------------------------------------------------------
require(graphics)
require(utils)

hc <- hclust(dist(USArrests), "ave")
(dend1 <- as.dendrogram(hc)) # "print()" method
str(dend1)          # "str()" method
str(dend1, max.level = 2, last.str =  "'") # only the first two sub-levels
oo <- options(str.dendrogram.last = "\\") # yet another possibility
str(dend1, max.level = 2) # only the first two sub-levels
options(oo)  # .. resetting them

op <- par(mfrow =  c(2,2), mar = c(5,2,1,4))
par(opar)
plot(dend1)
## "triangle" type and show inner nodes:
plot(dend1, nodePar = list(pch = c(1,NA), cex = 0.8, lab.cex = 0.8),
      type = "t", center = FALSE)
# nodePar：节点参数设置，为列表形式
# pch：节点形状，1圆形，2三角，c(枝节点形状，叶节点形状)
# cex：节点大小缩放比例
# lab.cex:末节点标签缩放

plot(dend1, edgePar = list(col = 1:2, lty = 2:3),
    dLeaf = 1, edge.root = TRUE)
# edgePar：连接线参数设置，参数为列表形式
# col：连接线颜色，前面连接线颜色：最后一根连接线颜色
# lty：连接线线型，实线或虚线等，前面连接线线型：最后一根连接线线型
# dLeaf:叶子的距离，个体标签距枝条距离
# edge.root:是否显示根线条
plot(dend1, nodePar = list(pch = 2:1, cex = .4*2:1, col = 2:3),
    horiz = TRUE)
