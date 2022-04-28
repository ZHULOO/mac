library(fastSOM)
n<-20
sigma<-crossprod(matrix(rnorm(n*n),nrow = n))#crossprod(a,b)计算t(a)%*%b的结果
sigma
h=10
A=array(rnorm(n*n*h),dim = c(n,n,h))
soi_avg_est(sigma,A)
soi_avg_exact(sigma,A)
