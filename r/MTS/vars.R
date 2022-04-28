library("vars")
data("Canada")
da<-data("Canada")
da<-Canada
summary(da)
plot(da,nc=2,xlab="")#nc=2两列显示
adf1<-ur.df(Canada[,"prod"],type = "trend",lags = 2)
summary(adf1)
adf2<-ur.df(diff(Canada[,"prod"]),type = "drift",lags = 1)
summary(adf2)
p1ct<-VAR(Canada,p=1,type="both")
p1ct
summary(p1ct,equation="e")#因变量为e的方程
plot(p1ct,names="e")
seri1<-serial.test(p1ct,lags.pt = 16,type = "PT.asymptotic")#用PT.asymptotic方法，计算统计量，检验是否序列相关
seri1$serial#显示统计量及P值
norm1<-normality.test(p1ct,multivariate.only = TRUE)#检验残差是否是正态
norm1$jb.mul
arch1<-arch.test(p1ct,lags.multi = 5)
arch1$arch.mul
plot(arch1,names="e")
plot(stability(p1ct),nc=2)
