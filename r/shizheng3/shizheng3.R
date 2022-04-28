getwd()
setwd("E:/MyGit/r/shizheng3")
install.packages("checkpoint")
library("checkpoint")
checkpoint("2017-03-06")

# install dependencies 安装包
install.packages("Rcpp")
install.packages("RcppArmadillo")
install.packages("tictoc")
install.packages("gaussquad")
install.packages("expm")
install.packages("doParallel")
install.packages("doSNOW")
# install actyR 本地安装包
setwd("E:/MyGit/r/shizheng3")
install.packages("actyR", repos = NULL, type = "source", INSTALL_opts = "--no-multiarch --preclean")

# 均已安装：
library("Rcpp")
library("RcppArmadillo")
library("tictoc")
library("gaussquad")
library("expm")
library("doParallel")
library("actyR")
library("doSNOW")
### 
sessionInfo()

###运行代码
source("estimation.R")
source("counterfactuals.R")






###并行运算设置：
.libPaths()
.libPaths('C:/Users/Administrator/Documents/.checkpoint/2017-03-06/lib/x86_64-w64-mingw32/3.3.3')
library(doParallel)
?? doParallel
cl <- makePSOCKcluster(3, outfile='')
registerDoParallel(cl)

clusterEvalQ(cl, library(doParallel))
