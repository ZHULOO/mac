install.packages("Matching")
##### 倾向得分匹配:
rm(list = ls())
library("Matching")
data("lalonde")
attach(lalonde)   ## 将数据框放到R的搜索路径中
Y<-lalonde$re78   ## 结果变量;
Tr<-lalonde$treat ##政策处理变量;
glm1<-glm(Tr~age+educ+black+hisp+married+nodegr+re74+re75,family = binomial,data=lalonde) ##logit模型预测倾向得分值;
rr1=Match(Y=Y,Tr=Tr,X=glm1$fitted)        ##基于倾向得分值进行1对1匹配;
summary(rr1) ##匹配结果描述;
MatchBalance(Tr~age+I(age^2)+educ+I(educ^2)+black+hisp+married+nodegr+re74+I(re74^2)+re75+I(re75^2)+u74+u75+I(re74*re75)+I(age*nodegr)+I(educ*re74)+I(educ*re75),match.out = rr1,nboots = 10,data = lalonde)
## 检验各协变量及平方项和交叉项在处理组和控制组之间的平衡性;
MatchBalance(Tr~re74,match.out = rr1,nboots = 1000,data = lalonde) ##检验re74的平衡性;
qqplot(lalonde$re74[rr1$index.control],lalonde$re74[rr1$index.treated]) ##画QQ图看是否符合正态分布;

##结果解释:
summary(rr1)
Estimate...  2624.3  ##平均处理效应ATT=2624.3且在1%水平下显著;
AI SE......  802.19 
T-stat.....  3.2714 
p.val......  0.0010702 

Original number of observations..............  445 
Original number of treated obs...............  185 #185个处理组的观测值都得到了匹配;
Matched number of observations...............  185 
Matched number of observations  (unweighted).  344 

MatchBalance(Tr~re74,match.out = rr1,nboots = 1000,data = lalonde) #检验一个变量re74的平衡性
***** (V1) re74 *****
                    Before Matching 	 	 After Matching
mean treatment........     2095.6 	 	     2095.6 
mean control..........       2107 	 	     2193.3  ##re74在处理组和控制组的均值;
std mean diff.........   -0.23437 	 	    -2.0004  ##匹配后的re74均值差距绝对值更小

mean raw eQQ diff.....     487.98 	 	     869.16  ##re74在原始未标准化QQ图中的均值,中位数和最大值差异;
med  raw eQQ diff.....          0 	 	          0 
max  raw eQQ diff.....       8413 	 	      10305 

mean eCDF diff........   0.019223 	 	   0.054701  ##re74在标准化QQ图中的均值,中位数和最大值差异;
med  eCDF diff........     0.0158 	 	   0.050872 
max  eCDF diff........   0.047089 	 	    0.12209 

var ratio (Tr/Co).....     0.7381 	 	    0.75054  ##方差在处理组和控制组间的比例;
T-test p-value........    0.98186 	 	    0.84996  ##处理组和控制组均值差异的t检验;
KS Bootstrap p-value..      0.585 	 	 < 2.22e-16  ##ks检验看re74在处理组和控制组有显著的分布差异;
KS Naive p-value......    0.97023 	 	   0.011858 
KS Statistic..........   0.047089 	 	    0.12209 

#####
### 从上面可以看到,PSM的ATT效应是非常显著的,但是匹配协变量的平衡性存在很大的问题,所以不能说存在明显的处理效应.
### 看遗传匹配是否能够让re74取得较好的平衡性:
install.packages("rgenoud")
library("rgenoud")
X<-cbind(age,educ,black,hisp,married,nodegr,re74,re75,u74,u75) ##匹配的协变量;
BalanceMatrix<-cbind(age,I(age^2),educ,I(educ^2),black,hisp,married,nodegr,re74,I(re74^2),re75,I(re75^2),u74,u75,I(re74*re75),I(age*nodegr),I(educ*re74),I(educ*re75))
# 不仅仅检验x向量的平衡性,还可以检验匹配协变量的平方项和交叉项的平衡性;
gen1<-GenMatch(Tr=Tr,X=X,BalanceMatrix = BalanceMatrix,pop.size = 1000) # 遗传匹配得到权重矩阵；
mgen1<-Match(Y=Y,Tr=Tr,X=X,Weight.matrix = gen1) # 使用上一步遗传匹配gen1得到的权重矩阵进行匹配；
summary(mgen1)
# 平衡性检验
MatchBalance(Tr~age+I(age^2)+educ+I(educ^2)+black+hisp+married+nodegr+re74+I(re74^2)+re75+I(re75^2)+u74+u75+I(re74*re75)+I(age*nodegr)+I(educ*re74)+I(educ*re75),match.out = mgen1,nboots = 1000,data = lalonde)
MatchBalance(Tr~re74,match.out = mgen1,nboots = 1000,data = lalonde)
qqplot(lalonde$re74[mgen1$index.control],lalonde$re74[mgen1$index.treated])

### 并行运算,提高运行速度:
install.packages("snow")
library("snow")
help("snow")
??snow
## Not run: 
## Two workers run on the local machine as a SOCK cluster.
cl <- makeCluster(c("localhost","localhost"), type = "SOCK")
clusterApply(cl, 1:2, get("+"), 3)
stopCluster(cl)
## Another approach to running on the local machine as a SOCK cluster.
cl <- makeCluster(2, type = "SOCK")
clusterApply(cl, 1:2, get("+"), 3)
stopCluster(cl)
## A SOCK cluster with two workers on Mac OS X, two on Linux, and two
## on Windows:
macOptions <-
  list(host = "owasso",
       rscript = "/Library/Frameworks/R.framework/Resources/bin/Rscript",
       snowlib = "/Library/Frameworks/R.framework/Resources/library")
lnxOptions <-
  list(host = "itasca",
       rscript = "/usr/lib64/R/bin/Rscript",
       snowlib = "/home/luke/tmp/lib")
winOptions <-
  list(host="192.168.1.168",
       rscript="C:/Program Files/R/R-2.7.1/bin/Rscript.exe",
       snowlib="C:/Rlibs")
cl <- makeCluster(c(rep(list(macOptions), 2), rep(list(lnxOptions), 2), #三台机器同时运作
                    rep(list(winOptions), 2)), type = "SOCK")
clusterApply(cl, 1:6, get("+"), 3)
stopCluster(cl)

list(winOptions)
rep(list(winOptions),2)
cols <- c(rep(list(macOptions), 2), rep(list(lnxOptions), 2), rep(list(winOptions), 2))

#组建自己的集群：
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
stopCluster(cl)





## End(Not run)

## 使用双核运行遗传匹配:
cl <- makeCluster(2, type = "SOCK")
clusterApply(cl, 1:2, get("+"), 3)
genout<-GenMatch(Tr=Tr,X=X,pop.size = 1000,cluster = cl)
stopCluster(cl)

## 使用四核运行遗传匹配:
cl <- makeCluster(4, type = "SOCK")
clusterApply(cl, 1:4, get("+"), 3)
genout<-GenMatch(Tr=Tr,X=X,pop.size = 1000,cluster = cl)
stopCluster(cl)



### 遗传算法求函数最大值：
# 先定义函数claw()：
claw<-function(xx){
  x<-xx;
  y <- (0.46*(dnorm(x,-1.0,2.0/3.0) + dnorm(x,1.0,2.0/3.0)) + 
          (1.0/300.0)*(dnorm(x,-0.5,.01) + dnorm(x,-1.0,.01) + dnorm(x,-1.5,.01)) + 
          (7.0/300.0)*(dnorm(x,0.5,.07) + dnorm(x,1.0,.07) + dnorm(x,1.5,.07))) ; 
  return(y)
}
help("plot")
x <- seq(-3,3,0.001)
y<-claw(x)
plot(x,y,type = "l")

x<-seq(-2*pi,2*pi,0.001)
y <-sin(x)
plot(x,y,type = "l")

# 再用genoud求解函数最大值
library("rgenoud")
claw1<- genoud(claw,nvars = 1,max = TRUE,pop.size = 3000)















