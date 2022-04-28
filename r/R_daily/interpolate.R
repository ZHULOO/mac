install.packages("tempdisagg")

library("tempdisagg")

help("tempdisagg")

demo(tempdisagg)

data(swisspharma)

help("ts") # 时间序列数据设定

help("read_xlsx")

#导入数据####
rm(list = ls())
library(readxl)
adjust <- read_excel("adjust.xlsx")
culture<-ts(data = adjust[2],start = 2008,end = 2017,frequency = 1,deltat = 1,names = "文化产业年度GDP",)
ygdp<-ts(data = adjust[3],start = 2008,end = 2017,frequency = 1,deltat = 1,names = "年度GDP")
ycpi<-ts(data = adjust[4],start = 2008,end = 2017,frequency = 1,deltat = 1,names = "定基年度CPI")
qgdp<-ts(data = adjust[6],start = c(2008,1),end = c(2017,4),frequency = 4,deltat = 1,names = "当季GDP")
qcpi<-ts(data = adjust[7],start = c(2008,1),end = c(2017,4),frequency = 4,deltat = 1,names = "当季CPI")
incom<-ts(data = adjust[8],start = c(2008,1),end = c(2017,4),frequency = 4,deltat = 1,names = "当季人均可支配收入")

library(tseries)
adf.test(culture)

m1 <- td(culture ~ 1, to = "quarterly", method = "denton")
summary(m1)
pm1<-predict(m1) # 比例一阶差分

m2 <- td(culture ~ 1, to = "quarterly", method = "denton",criterion = 'additive',h = 1)
summary(m2)
pm2<-predict(m2) # 加法一阶差分

m3 <- td(culture ~ 0 + qcpi, to = "quarterly", method = "denton")
summary(m3)
pm3<-predict(m3)

m4 <- td(culture ~ 0 + qcpi, to = "quarterly", method = "denton",criterion = 'additive',h = 1)
summary(m4)
pm4<-predict(m4)

m5 <- td(culture ~ 1, to = "quarterly", method = "denton-cholette")
summary(m5)
pm5<-predict(m5)

m6 <- td(culture ~ 0 + qcpi, to = "quarterly", method = "denton-cholette")
summary(m6)
pm6<-predict(m6)

m7 <- td(culture ~ 0 + qcpi, to = "quarterly", method = "chow-lin-maxlog")
summary(m7)
pm7<-predict(m7)

m8 <- td(culture ~ 0 + qcpi + qgdp, to = "quarterly", method = "chow-lin-maxlog")
summary(m8)
pm8<-predict(m8)

m9 <- td(culture ~ 0 + qcpi, to = "quarterly", method = "fernandez")
summary(m9)
pm9<-predict(m9)

m10 <- td(culture ~ 0 + qcpi + qgdp, to = "quarterly", method = "fernandez")
summary(m10)
pm10<-predict(m10)

m11 <- td(culture ~ 0 + qcpi, to = "quarterly", method = "litterman-maxlog")
summary(m11)
pm11<-predict(m11)

m12 <- td(culture ~ 0 + qcpi + qgdp, to = "quarterly", method = "litterman-maxlog")
summary(m12)
pm12<-predict(m12)

result<-cbind(pm1,pm2,pm3,pm4,pm5,pm6,pm7,pm8,pm9,pm10,pm11,pm12)
write.csv(result,'result.csv')
result<-cbind(pm8,pm10,pm12)
write.csv(result,'result1.csv')





summary(m1)  # summary statistics 
plot(m1)  # residual plot of regression 

plot(culture)
par(new = TRUE)
plot(pm1)  
par(new = TRUE)
plot(pm2)
par(new = TRUE)
plot(pm3)
par(new = TRUE)
plot(pm4)


help(plot)




# interpolated quarterly series#####

# temporally aggregated series is equal to the annual value 判断是否相等
all.equal(window(ta(predict(mod1), conversion = "sum", to = "annual"),start = 1975), sales.a)



# Table in Denton (1971), page 101: 
round(cbind(d.q, a1, a2, a3, a4, p1, p2, p3, p4))
