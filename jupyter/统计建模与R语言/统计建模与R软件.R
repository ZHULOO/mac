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
# QR分解求解多元回归系数，
qr <- qr(X)
Q <- qr.Q(qr)
Q
t(Q) %*% Q
R <- qr.R(qr)
R
b <- solve(R) %*% t(Q) %*% Y
b
