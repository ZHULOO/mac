install.packages("MTS")
library("vars")
library("MTS")

library(mvtnorm)#生成多元正态分布的命令
sig=diag(2)
x=rmvnorm(300,rep(0,2),sig)#生成2个均值为零的协方差为sig的二元正态分布序列
MTSplot(x)#画出它们的时间序列图
ccm(x)#画出ccf图
##tset zero cross-correlations
data("mts-examples", package="MTS")
#Selected R commands used in Chapter 1 ####
da=read.table("q-gdpunemp.txt",header=T)  ## Load data
head(da)
year mon      gdp     rate
1 1948   1 1821.809 3.733333
2 1948   4 1855.345 3.666667
3 1948   7 1865.320 3.766667
4 1948  10 1868.184 3.833333
5 1949   1 1842.240 4.666667
6 1949   4 1835.512 5.866667
dim(da)
[1] 256   4
x=cbind(diff(da$gdp),diff(da$rate))
head(x)
mq(x,lag = 10)#检验滞后10期的cross-correlations matrix是否为0，
sig=diag(3)
z=rmvnorm(200,rep(0,3),sig)
head(z)
mq(z,10)

zt=cbind(log(da$gdp),da$rate)  ## Create time series
tdx=da[,1]+da[,2]/12  ## Create calendar time
require(MTS)  ## Load MTS package
colnames(zt) <- c("ln(GDP)","Unrate")
MTSplot(zt,tdx) ## Obtain Figure 1.1 of the textbook
dzt=diffM(zt)   ## Take first difference of each time series
colnames(dzt) <- c("GDP growth","Change rate")
MTSplot(dzt,tdx[2:256]) ## Obtain Figure 1.2 of the textbook
plot(dzt[,1],dzt[,2],xlab="GDP growth",ylab="Change in rate") ## Obtain Figure 1.3 of the textbook
hstarts=read.table("m-hstarts-3divisions.txt",header=T)## Load housing starts data
dim(hstarts)
[1] 198   5
head(hstarts)
year mon New.England Middle.Atlantic Pacific
1 1995   1        1991            4556    8749
2 1995   2        1569            3950   11407
3 1995   3        3084            7154   12064
4 1995   4        3712            7553   12832
5 1995   5        3605            8438   14385
6 1995   6        3543            8509   17613
tdx=hstarts[,1]+hstarts[,2]/12
MTSplot(hstarts[,3:5],tdx)  ## Obtain Figure 1.4 of the textbook
rate=read.table("m-unemp-states.txt",header=T) ## Load states unemployment rates
dim(rate)
[1] 429  50
head(rate)
AL  AK   AZ  AR  CA  CO  CT  DE   FL  GA  HI  ID  IL  IN  IA  KS  KY  LA  ME
1 6.4 7.1 10.5 7.3 9.3 5.8 9.4 7.7 10.0 8.3 9.9 5.5 6.4 6.9 4.2 4.3 5.7 6.2 8.8
2 6.3 7.0 10.3 7.2 9.1 5.7 9.3 7.8  9.8 8.2 9.8 5.4 6.4 6.6 4.2 4.2 5.6 6.2 8.6
3 6.1 7.0 10.0 7.1 9.0 5.6 9.2 7.9  9.5 8.1 9.6 5.4 6.4 6.4 4.1 4.2 5.5 6.2 8.5
4 6.0 7.0  9.8 7.0 8.9 5.5 9.1 8.1  9.3 8.0 9.4 5.3 6.4 6.2 4.1 4.2 5.5 6.3 8.4
5 6.0 7.0  9.6 6.9 8.9 5.5 9.0 8.3  9.1 7.9 9.2 5.3 6.5 6.0 4.0 4.2 5.4 6.4 8.3
6 6.0 7.1  9.5 6.8 8.9 5.6 9.0 8.5  9.0 7.9 9.0 5.3 6.6 5.8 4.0 4.1 5.4 6.6 8.3
MD   MA   MI  MN  MS  MO  MT  NE  NV  NH   NJ  NM   NY  NC  ND  OH  OK   OR
1 6.9 11.1 10.0 6.2 7.0 5.8 5.8 3.6 9.8 7.2 10.5 8.9 10.2 6.7 3.2 8.3 6.4 10.1
2 6.7 10.9  9.9 6.0 6.8 5.8 5.7 3.5 9.5 7.1 10.4 8.8 10.2 6.5 3.3 8.2 6.3  9.8
3 6.6 10.6  9.8 5.8 6.6 5.8 5.7 3.3 9.3 7.0 10.4 8.7 10.1 6.3 3.3 8.0 6.1  9.5
4 6.5 10.3  9.7 5.7 6.4 5.9 5.6 3.2 9.0 6.9 10.3 8.6 10.1 6.2 3.4 7.9 5.9  9.3
5 6.4 10.1  9.6 5.6 6.3 5.9 5.6 3.0 8.8 6.8 10.3 8.6 10.1 6.0 3.5 7.7 5.8  9.1
6 6.3  9.8  9.5 5.6 6.3 6.0 5.6 3.0 8.7 6.7 10.3 8.6 10.1 6.0 3.6 7.6 5.7  9.0
PA  RI  SC  SD  TN  TX  UT  VT  VA  WA  WV  WI  WY
1 8.1 7.8 7.6 3.6 5.9 5.9 6.1 8.8 6.2 8.7 8.3 5.9 4.2
2 8.1 7.8 7.4 3.5 5.9 5.9 5.9 8.7 6.1 8.7 8.1 5.7 4.1
3 8.0 7.9 7.2 3.4 5.9 5.8 5.7 8.6 5.9 8.7 7.9 5.6 4.0
4 8.0 7.9 7.0 3.3 6.0 5.8 5.6 8.6 5.8 8.7 7.6 5.5 3.9
5 7.9 7.9 6.9 3.2 6.0 5.8 5.5 8.5 5.7 8.7 7.4 5.4 3.9
6 7.9 8.0 6.8 3.2 6.1 5.8 5.4 8.5 5.6 8.8 7.3 5.4 3.9
tdx=c(1:429)/12+1976
ym=max(rate)  ## maximum unemployment rate, for scaling the plots.
### The following commands create Figure 1.5 of the textbook.
plot(tdx,rate[,1],xlab='Year',ylab='Rate',ylim=c(0,ym+1),type='l')
for(i in 2:50){
  + lines(tdx,rate[,i],lty=i)
  + }
q()  ## exit R 

1.2
m2 = VARMAsim(200,malags = c(1),theta = C,sigma = S)#模拟生成AR MA过程的函数
zt = m2$series
da=read.table("q-fdebt.txt",header = T)
debt=log(da[,3:5])
MTSplot(debt)
tdx=da[,1]+da[,2]/12
MTSplot(debt,tdx)
zt=diffM(debt)
MTSplot(zt,tdx[-1])
mq(zt,lag = 10)











