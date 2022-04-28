#VAR模型####
install.packages("vars")#下载vars包
data1 <- read.csv("C:/Users/User/Desktop/data1.txt", sep="")#读取数据
View(data1)#预览数据
save(data1,file = "E:/Codelearning/Rstudio/data1.Rdata")#保存数据
save(data2,file = "E:/Codelearning/Rstudio/data2.Rdata")
#####VARselect（）函数给出了不同滞后阶数模型的信息值，其中y设定内生变量数据集，exogen设定外生变量数据集，lag.max设定最大滞后阶数，我们设定为6，
type设定确定性部分的类型，可选择的包括const截距，trend趋势，both同时包含截距和趋势，none不包含截距和趋势
VARselect(y=data1,lag.max=6,type="const",exogen=data2)
$selection
AIC(n)  HQ(n)  SC(n) FPE(n) 
4      4      4      5
$criteria
1           2            3    4    5    6
AIC(n)     9.588271    10.07365     7.637841 -Inf -Inf -Inf
HQ(n)      9.579220    10.06007     7.619740 -Inf -Inf -Inf
SC(n)     10.437931    11.34814     9.337162 -Inf -Inf -Inf
FPE(n) 16817.321879 41461.93286 12450.487405  NaN    0    0


#####VAR（）函数给出了VAR的估计结果，我们将其保存在变量rvar中。VAR（）函数设定的参数包括，y为内生变量，exogen为外生变量，ic为可选的信息准则，
p为滞后阶数，type为确定性部分，其与VARselect（）函数相同。我们通过names（）函数查看rvar中VAR（）的回归结果。由于VAR（）保存为S3类型，可以直
接通过$调用，如rvar$varresult调用第一个list。
rvar=VAR(y=data1,p=3,type="const",exogen=data2,ic=c("AIC","SC","HQ","FPE"))
names(rvar)
[1] "varresult"    "datamat"      "y"            "type"         "p"            "K"           
[7] "obs"          "totobs"       "restrictions" "call"        


#####SVAR（）函数给出了SVAR的估计结果，我们将其保存在变量rsvar中。在使用SVAR估计之前，我们需要定义A矩阵，即模型内生变量的当期影响。需要说明的是，
由于内生变量方程中不可能与自身的当期值相关，因此A矩阵的对角线全部为1，其它为带估计参数。我们首先定义了一个全部为NA的3*3矩阵（3个内生变量），然
将对角线元素全部设定为1，保存在amat变量中。SVAR（）需要设置的参数包括已经回归的VAR（）对象，即上一步中的rvar，定义的A矩阵，即amat，估计方法选择
的是直接使用极大似然估计“direct”。同样的，我们可以通过names（）查看估计结果的名称，其中包括A矩阵和B矩阵的系数及系数标准误。SVAR的关键在于Amat矩阵，
如果已经知道某些变量不存在当期相关，则可以通过amat[i，j]=0将该元素固定。

amat=matrix(NA,3,3)
amat[1,1]=amat[2,2]=amat[3,3]=1
rsvar=SVAR(x=rvar,estmethod="direct",Amat=amat,Bmat=NULL,)
#####irf（）和fevd（）函数的设置相似，需要设置VAR（）或者SVAR（）估计对象，我们使用的是保存在rvar中的VAR（）估计对象。irf（）函数需要设定冲击变量
和相应变量的名称，我们可以通过names（）函数查看内生变量数据集中的变量名，n.ahead设定冲击响应的时期数，如果不设置则默认全部内生变量都进行分析。
fevd（）的参数设置与此一致。注意，irf（）和fevd（）返回的是脉冲响应和方差分解的数值，而不是图形。我们通过plot（）函数简单的呈现。
rirf=irf(rvar,impulse="m1",response="cpii",n.ahead=20)
names(rirf)
[1] "irf"        "Lower"      "Upper"      "response"   "impulse"    "ortho"      "cumulative"
[8] "runs"       "ci"         "boot"       "model"     
rfevd=fevd(rvar,n.ahead=20)
names(rfevd)
[1] "m1"   "gdp"  "cpii"
plot(rirf$irf$m1,type="l")