getwd()
setwd("E:/MyGit/r/semipar")
### install.packages("checkpoint") 安装以后不再需要;
library("checkpoint")
checkpoint("2019-02-01") # 会自动安装此脚本下2019-02-01下的"SemiParSampleSel"和"haven"包,
# 最新的R已更新到4.0,默认的最新R包可能已经不支持4.0之前版本的R了;
### 不用再单独使用install.packages()命令来下载包了;
.libPaths()
checkpointArchives()
library(SemiParSampleSel)
sessionInfo()
??SemiParSampleSel
??mgcv
library(help=mgcv)
??gamm
library(haven)
rm(list = ls())


# R语言变量滞后较难, 可以在stata中生成滞后变量后这里直接用
ND <- read_dta("E:/学术论文/Data/hudata/实证一二数据/实证122.dta")
View(ND)
### SemiParSampleSel使用实例:
# 
SE <- rdsubsidy ~ lnrdperson + llnrdsubs + lnpatent + lnsize + age + growth + lnmarket + lev + cash_shortdebt + lnrelproductivity
OE <- rdspendsumratio ~ llnrdsubs + lnpatent + lnsize + age + growth + lnmarket + lev + cash_shortdebt + lnrelproductivity

SE <- rdsubsidy ~ s(lnrdperson) + s(llnrdsubs) + s(lnpatent) + s(lnsize) + s(age) + s(growth) + s(lnmarket) + s(lev) + s(cash_shortdebt) + s(lnrelproductivity)
OE <- rdspendsumratio ~ s(llnrdsubs) + s(lnpatent) + s(lnsize) + s(age) + s(growth) + s(lnmarket) + s(lev) + s(cash_shortdebt) + s(lnrelproductivity)

SE <- rdsubsidy ~ lnrdperson + llnrdsubs + lnpatent + s(lnsize) + s(age) + s(growth) + lnmarket + lev + cash_shortdebt + lnrelproductivity
OE <- rdspendsumratio ~ llnrdsubs + lnpatent + s(lnsize) + s(age) + s(growth) + lnmarket + lev + cash_shortdebt + lnrelproductivity
#选lnpatent age growth
SE <- rdsubsidy ~ lnrdperson + llnrdsubs + s(lnpatent) + lnsize + s(age) + s(growth) + lnmarket + lev + cash_shortdebt + lnrelproductivity
OE <- rdspendsumratio ~ llnrdsubs + s(lnpatent) + lnsize + s(age) + s(growth) + lnmarket + lev + cash_shortdebt + lnrelproductivity

#选age growth lev
SE <- rdsubsidy ~ lnrdperson + llnrdsubs + lnpatent + lnsize + s(age) + s(growth) + lnmarket + s(lev) + cash_shortdebt + lnrelproductivity
OE <- rdspendsumratio ~ llnrdsubs + lnpatent + lnsize + s(age) + s(growth) + lnmarket + s(lev) + cash_shortdebt + lnrelproductivity

#选age growth lev
SE <- rdsubsidy ~ lnrdperson + llnrdsubs + lnpatent + lnsize + age + s(growth) + lnmarket + s(lev) + cash_shortdebt + s(lnrelproductivity)
OE <- rdspendsumratio ~ llnrdsubs + lnpatent + lnsize + age + s(growth) + lnmarket + s(lev) + cash_shortdebt + s(lnrelproductivity)


out_N <- SemiParSampleSel(list(SE, OE), data = ND,BivD = "N")

out_C <- SemiParSampleSel(list(SE, OE), data = ND, BivD = "C90")

out_J <- SemiParSampleSel(list(SE, OE), data = ND, BivD = "J0")

out_FGM <- SemiParSampleSel(list(SE, OE), data = ND, BivD = "FGM")# 结果较好

out_F <- SemiParSampleSel(list(SE, OE), data = ND, BivD = "F")

out_AMH <- SemiParSampleSel(list(SE, OE), data = ND, BivD = "AMH")

out_G <- SemiParSampleSel(list(SE, OE), data = ND, BivD = "G90")

AIC(out_N)
AIC(out_C)
AIC(out_J)
AIC(out_FGM)
AIC(out_F) # 最小
AIC(out_AMH) 
AIC(out_G)
AIC(out_N)

ss.checks(out_F)

set.seed(1)
summary(out_N)
summary(out_C)
summary(out_J)
summary(out_FGM) # 结果较好
summary(out_F)
summary(out_AMH)
summary(out_G)
summary(out_N)

plot(out_N, eq = 2, pages = 1, scale = 0, shade = TRUE, seWithMean = TRUE,
     cex.axis = 1.6, cex.lab = 1.6)
plot(out_F, eq = 2, pages = 1, scale = 0, shade = TRUE, seWithMean = TRUE,
     cex.axis = 1.6, cex.lab = 1.6)
plot(out_G, eq = 2, pages = 1, scale = 0, shade = TRUE, seWithMean = TRUE,
     cex.axis = 1.6, cex.lab = 1.6)
plot(out_C, eq = 2, pages = 1, scale = 0, shade = TRUE, seWithMean = TRUE,
     cex.axis = 1.6, cex.lab = 1.6)
plot(out_J, eq = 2, pages = 1, scale = 0, shade = TRUE, seWithMean = TRUE,
     cex.axis = 1.6, cex.lab = 1.6)
plot(out_FGM, eq = 2, pages = 1, scale = 0, shade = TRUE, seWithMean = TRUE,
     cex.axis = 1.6, cex.lab = 1.6)
