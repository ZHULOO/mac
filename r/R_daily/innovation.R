rm(list = ls())
#读入数据：
library(haven)
data1 <- read_stata("matchdata.dta")
#倾向得分:
library("Matching")
attach(data1)
Y<-data1$frd   ## 结果变量;
Tr<-data1$treat ##政策处理变量;
glm1<-glm(Tr~logage+logassets+logppe_emp+return+lev+tobinq+logtenure+logedu,
          family = binomial,data=data1) ##logit模型预测倾向得分值;
rr1=Match(Y=Y,Tr=Tr,X=glm1$fitted,M=1)        ##基于倾向得分值进行1对1匹配;
summary(rr1) ##匹配结果描述;
MatchBalance(Tr~logage+logassets+logppe_emp+return+lev+tobinq+logtenure+logedu,
             match.out = rr1,nboots = 1000,data = data1)
MatchBalance(Tr~return,match.out = rr1,nboots = 1000,data = data1)
qqplot(data1$return[rr1$index.control],data1$return[rr1$index.treated])


#遗传匹配：
library("rgenoud")  #遗传算法包
library("snow")     #并行运算包
balance_cov<-cbind(logage,logassets,logppe_emp,return,lev,tobinq,logtenure,logedu)
cl <- makeCluster(4, type = "SOCK")
clusterApply(cl, 1:4, get("+"), 3)
gen1<-GenMatch(Tr=Tr,X=balance_cov,BalanceMatrix = balance_cov,pop.size = 1000,cluster = cl) # 遗传匹配得到权重矩阵；
stopCluster(cl)
mgen1<-Match(Y=Y,Tr=Tr,X=balance_cov,Weight.matrix = gen1) # 使用上一步遗传匹配gen1得到的权重矩阵进行匹配；
summary(mgen1)
#所有变量的平衡性检验：
MatchBalance(Tr~logage+logassets+logppe_emp+return+lev+tobinq+logtenure+logedu,
             match.out = mgen1,nboots = 1000,data = data1)
#单个变量平衡性检验：
MatchBalance(Tr~return,match.out = mgen1,nboots = 1000,data = data1)
qqplot(data1$return[mgen1$index.control],data1$return[mgen1$index.treated])



cl <- makeCluster(4, type = "SOCK")
clusterApply(cl, 1:4, get("+"), 3)
genout<-GenMatch(Tr=Tr,X=X,pop.size = 1000,cluster = cl)
stopCluster(cl)

#两台电脑：
winOptions1 <-
  list(host="192.168.3.50",
       rscript="C:/Program Files/R/R-3.6.1/bin/Rscript.exe",
       snowlib="C:/Rlibs")
winOptions2 <-
  list(host="192.168.3.115",
       rscript="C:/Program Files/R/R-3.6.2/bin/Rscript.exe",
       snowlib="C:/Rlibs")
cl <- makeCluster(c(rep(list(winOptions1), 2),rep(list(winOptions2), 4)), type = "SOCK")
clusterApply(cl, 1:6, get("+"), 3)
genout<-GenMatch(Tr=Tr,X=X,pop.size = 1000,cluster = cl)
stopCluster(cl)





library(haven)
data1 <- read_stata("matchdata.dta")
#倾向得分:
library("Matching")
attach(data1)
Y<-data1$frd   ## 结果变量;
Tr<-data1$treat ##政策处理变量;
glm1<-glm(Tr~logage+logassets+logppe_emp+return+lev+tobinq+logtenure+logedu,
          family = binomial,data=data1) ##logit模型预测倾向得分值;
rr1=Match(Y=Y,Tr=Tr,X=glm1$fitted,M=1)        ##基于倾向得分值进行1对1匹配;
summary(rr1) ##匹配结果描述;
MatchBalance(Tr~logage+logassets+logppe_emp+return+lev+tobinq+logtenure+logedu,
             match.out = rr1,nboots = 1000,data = data1)
MatchBalance(Tr~return,match.out = rr1,nboots = 1000,data = data1)
qqplot(data1$return[rr1$index.control],data1$return[rr1$index.treated])



library("rgenoud")
library("snow")
library("Matching")
library(haven)
data <- read_stata("matchdata.dta")
attach(data)
Y <- data$frd
Tr <- data$treat
balance_cov <- cbind(logage,logassets,logppe_emp,return,lev,
                   tobinq,logtenure,logedu)
winOptions1 <-
  list(host="192.168.3.50",
       rscript="C:/Program Files/R/R-3.6.2/bin/Rscript.exe",
       snowlib="C:/Rlibs")
winOptions2 <-
  list(host="192.168.3.115",
       rscript="C:/Program Files/R/R-3.6.2/bin/Rscript.exe",
       snowlib="C:/Rlibs")
winOptions3 <-
  list(host="192.168.3.80",
       rscript="C:/Program Files/R/R-3.6.2/bin/Rscript.exe",
       snowlib="C:/Rlibs")
cl <- makeCluster(c(rep(list(winOptions1), 4),rep(list(winOptions2), 4),
                    rep(list(winOptions3), 4), type = "SOCK"))
clusterApply(cl, 1:12, get("+"), 3)
gen <- GenMatch(Tr=Tr,X=balance_cov,BalanceMatrix = balance_cov,pop.size = 1000,cluster = cl)
stopCluster(cl)
mgen <- Match(Y=Y,Tr=Tr,X=balance_cov,Weight.matrix = gen)
summary(mgen)

MatchBalance(Tr~logage+logassets+logppe_emp+return+lev+tobinq+logtenure+logedu,
             match.out = mgen,nboots = 1000,data = data)



