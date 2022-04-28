install.packages("sp")
install.packages("spdep")
install.packages("spatialreg")
library(sp)
library(Matrix)
library(spdep)
library(spatialreg)
library(haven)


# spdep包 ------------------------------------------------------------------


# 数据 ----------------------------------------------------------------------
mat2listw()  # 将方形空间矩阵转换为权重列表对象，spdep包直接可以使用；
nb2listw()
nb2mat()





#空间相关性检验
columbusswm <- read_dta("E:/data/columbusswm.dta")
columbusdata <- read_dta("E:/data/columbusdata.dta")
colww <- mat2listw(as.matrix(columbusswm),style="W")   ##生成空间权重矩阵,可以读取原始矩阵格式
moran.test(as.matrix(columbusdata)[,4],listw=colww)    ##全局空间自相关检验，原假设不存在空间自相关
#莫兰散点图
moran.plot(as.matrix(columbusdata)[,4],listw=colww,xlab="Crime",ylab="Crimae.lag")


# 论文 ----------------------------------------------------------------------
getwd()
setwd("E:\\BaiduNetdiskWorkspace\\郑大")
swm <- read_dta("")
swm <- read_sav("")

w1 <- mat2listw(as.matrix(swm),style = "W")
moran.plot(as.matrix(data)[,1],listw = w1,xlab = "geff",ylab = "geff_lag")



localmoran(as.matrix(columbusdata)[,4],listw=colww) ##局部空间自相关检验，尚未解决

colfm=crime~hoval+income
cololsfit=lm(colfm,data=columbusdata);summary(cololsfit)  #OLS 回归
moran.test(as.matrix(cololsfit$residuals),listw=colww)    #模型滞后、误差项空间相关性检验，尚未解决
moran.mc(cololsfit$residuals, colww, 999)    #蒙特卡洛MoranI检验
lm.morantest(cololsfit,listw=colww)       #与上两式结果基本相同

res <- lm.LMtests(cololsfit, listw = colww, test = "all")
tres <- t(sapply(res, function(x) c(xstatistic,xstatistic, xparameter,+ x$p.value)))
colnames(tres) <- c("Statistic", "df", "p-value")
printCoefmat(tres)

#截面空间回归
collag1 = lagsarlm(colfm, data=columbusdata, colww,type="lag");summary(collag1)     #空间滞后模型 
collag2 = lagsarlm(colfm, data=columbusdata, colww,type="mixed");summary(collag2)   #空间混合模型，与杜宾模型基本一致
collag3 = lagsarlm(colfm, data=columbusdata, colww,type="Durbin");summary(collag3)  #空间杜宾模型
colgm <- GMerrorsar(colfm, data =columbusdata, listw = colww);summary(colgm)


impacts(collag1,listw=colww)
impacts(collag2,listw=colww)
impacts(collag3,listw=colww)

colsem = errorsarlm(colfm, data=columbusdata, colww);summary(colsem) #空间误差模型

collag_2SLS <- stsls(colfm, data =columbusdata, listw = colww);summary(collag_2SLS) #两阶段空间滞后模型
collag_2SL_robust <- stsls(colfm, data =columbusdata,listw=colww,robust = TRUE);summary(collag_2SL_robust)


#空间面板回归
library(splm)
library(plm)
data("usaww")
proww=mat2listw(usaww,style="W")
product <- read_dta("E:/data/product.dta")
product=pdata.frame(product,index = c("state", "year"))
profm=log(gsp)~log(pcap)+log(pc)+log(emp)+unemp
proplm=plm(profm,data=product,model="within",effect="individual");summary(proplm)

prosplm=spml(profm,data=product,listw=proww);summary(prosplm)
prosplm2=spml(profm,data=product,listw=proww,model="within",effect="individual");summary(prosplm2)
prosplm3=spml(profm,data=product,listw=proww,model="within",effect="individual",lag=TRUE);summary(prosplm3)
prosplm4=spml(profm,data=product,listw=proww,model="random",effect="individual",spatial.error=="none");summary(prosplm4)
impacts(prosplm4,listw=proww)
impac1 <- impacts(prosplm3, listw = mat2listw(usaww, style = "W"),time=17)
impac1
test.hausman=sphtest(prosplm3,prosplm4)
test.hausman

#SDM模型
#空间杜宾模型
profm_SDM=log(gsp)~log(pcap)+log(pc)+log(emp)+unemp+slag(log(pcap), listw= proww) + slag(log(pc), listw = proww)+slag(log(emp), listw = proww)+slag(unemp, listw = proww)
prosplm_SDM1=spml(profm_SDM,data=product,listw=proww,model="random",effect="individual",spatial.error=="none",lag=TRUE);summary(prosplm_SDM1)
impac2 <- impacts(prosplm_SDM1, listw = mat2listw(usaww, style = "W"),time=17)
impac2

test1 <- sphtest(x = fm, data = Produc, listw = mat2listw(usaww),spatial.model = "error", method = "GM")  #空间回归huasman检验