*------------
*   简  介
*------------
* 该部分内容主要包括多重共线性、异方差、自相关的检验和修正
            
*==============
*   多重共线性     第9章 9.6多重共线性 第123页
*==============

* 多重共线性检验方法

    * (1)统计意义检验，虽然模型的R2非常高，但多数解释变量都不显著，
	  * (2)经济意义检验：甚至系数符号都不对
    * (3) VIF 膨胀因子  VIF_j = 1/(1-R2_j)
      //VIF 的均值 < 10 可以不用担心多重共线性 
      //VIF的最大值 >10 存在共线性 
*计算VIF
cd E:\data
use nerlove.dta,clear
qui reg lntc lnq lnpl lnpk lnpf
estat vif
  Variable |       VIF       1/VIF  
-------------+----------------------
        lnpf |      1.21    0.824250 //最大的vif为1.21远小于10，不必担心存在多重共线性
        lnpl |      1.21    0.829013
        lnpk |      1.09    0.918113
         lnq |      1.04    0.960914
-------------+----------------------
    Mean VIF |      1.14 		  
* 多重共线性处理方法
    *（1）不关心具体系数，只关心总体方程的解释能力，不用理会多重共线性；
    *（2）关心的回归系数不受影响，可以不用理会多重共线性；
    *（3）影响到关心的具体回归系数，增加样本容量，提出共线性变量，修改模型等；
    *（4）逐步回归。
      sw reg
      stepwise reg //逐步回归

*===================
*  ***异方差****       第7章 异方差与GLS
*===================

   *一、异方差检验方法
   *(1)画残差图
   cd E:\data
   use nerlove.dta,clear
   *lntc(总成本对数total cost)
   *lnq（总产量对数total output）
   *lnpl（劳动力价格price of labor）
   *lnpk（user cost of capital）
   *lnpf（price of fuel）
   reg lntc lnq lnpl lnpk lnpf
   rvfplot //画残差图（residual—versus-fitted plot）残差对拟合值
   rvpplot lnpf //(residual—versus-predictor plot）残差对解释变量

   *(2)white检验 原假设：不存在异方差
   *white检验优点：可以检验任何形式的异方差，缺点：检验存在异方差的情况下，不能给出异方差的具体形式
   estat imtest,white         //estat "post-estimation statistics"(估计后统计量)
                              //imtest "information matrix test"***
                              //findit  whitetst 外部命令，需要安装
   *结果如下：
                              //ssc install whitetst
White's test for Ho: homoskedasticity
         against Ha: unrestricted heteroskedasticity

         chi2(14)     =     73.88
         Prob > chi2  =    0.0000 //p值为0，强烈拒绝原假设（同方差）

Cameron & Trivedi's decomposition of IM-test

---------------------------------------------------
              Source |       chi2     df      p
---------------------+-----------------------------
  Heteroskedasticity |      73.88     14    0.0000
            Skewness |      22.79      4    0.0001
            Kurtosis |       2.62      1    0.1055
---------------------+-----------------------------
               Total |      99.29     19    0.0000 
---------------------------------------------------

   *(3)BP检验 原假设：同方差
   *BP检验是white检验的特例，可以给出异方差的具体形式：残差做被解释变量

   estat hettest              //默认使用被解释变量拟合值回归，此时扰动项是假设服从正态分布的
   estat hettest,iid          //假设随机扰动项不必服从正太分布，独立同分布即可
   estat hettest,rhs iid      //rhs使用方程右边的所有解释变量回归，且扰动项不必是正态分布，独立同分布即可
   Breusch-Pagan / Cook-Weisberg test for heteroskedasticity 
         Ho: Constant variance
         Variables: lnq lnpl lnpk lnpf

         chi2(4)      =    36.16
         Prob > chi2  =   0.0000 //p值为0，强烈拒绝原同方差的假设
   estat hettest lnq,iid         //使用lnq回归，且扰动项不必是正太分布，独立同分布即可

   *二、异方差处理方法
   *(1)使用OLS+稳健标准误
   *(2)广义最小二乘法GLS
   *(3)加权最小二乘法WLS 
    qui reg lntc lnq lnpl lnpk lnpf
    predict e1 ,res
    gen e2 = e1^2
    gen lne2 = log(e2)
    reg lne2 lnq ,noc
    predict lne2f                            //计算上式辅助回归的拟合值
    gen e2f = exp(lne2f)                     //去掉上面拟合值的对数
    reg lntc lnq lnpl lnpk lnpf [aw = 1/e2f] //加权最小二乘
   *(4)可行广义最小二乘法FGLS，WLS GLS都是假设扰动项协方差矩阵已知，实际上首先需要用样本数据估计；
   *(5)究竟是用“OLS+稳健标准误”还是FWLS，“OLS+稳健标准误”更稳健，万金油，建议大多数情况下使用；
   *   FWLS更有效，尤其是大样本下，特效药，但容易失效或起反作用
   reg lntc lnq lnpl lnpk lnpf,r //异方差稳健标准误

   ***WLS过程***
   log using time_series.smcl,replace
   qui reg lntc lnq lnpl lnpk lnpf
   predict e1,res
   gen e2=e1^2
   gen lne2=log(e2)
   reg lne2 lnq,noc
   predict lne2f
   gen e2f=exp(lne2f)
   reg lntc lnq lnpl lnpk lnpf [aw=1/e2f]
   log close
  
*===================
*  ***自相关****          第8章 自相关
*===================

   *一、自相关检验

   *(1)画图,画残差和之后一期的残差散点图或者ac、pac命令，直观但是补准确
   cd E:\data
   use icecream.dta,clear
   tsset time
   reg consumption temp price income
   predict e1,residual
   scatter e1 L.e1
   ac e1
   pac e1
   *(2)BG检验 原假设：不存在自相关
   estat bgodfrey         //默认滞后阶数p=1
   estat bgodfrey,lags(p)
   estat bgodfrey,nomiss0 //不添加0的BG检验
   Breusch-Godfrey LM test for autocorrelation
---------------------------------------------------------------------------
    lags(p)  |          chi2               df                 Prob > chi2
-------------+-------------------------------------------------------------
       1     |          4.237               1                   0.0396 //小于p=0.05，拒绝原假设无自相关
---------------------------------------------------------------------------
                        H0: no serial correlation

   *(3)Box-Pierce Q 检验 原假设：不存在自相关
   *Ljung-Box Q检验 原假设：白噪声，无自相关
   reg consumption temp price income
   predict e1,residual
   wntestq e1          //默认滞后期，white noise test Q
   wntestq e1,lags(p)  //指定滞后期p
Portmanteau test for white noise
---------------------------------------
 Portmanteau (Q) statistic =    26.1974
 Prob > chi2(13)           =     0.0160 //小于p=0.05，拒绝原假设无自相关

   *(4)DW检验 根据DW值判断 只能判断是否一阶自相关
   estat dwatson //显示DW统计量


   *二、自相关处理

   *(1)使用“OLS+异方差自相关稳健标准误(HAC)”，Newey-West估计法
   newey    
   *(2)使用“OLS+聚类稳健标准误”，前提是聚类中的个体数少，聚类数量很多，且不要求是同方差，所以聚类稳健标准误是
   *   异方差稳健的，异方差与组内自相关的情况下依然成立， 面板数据时经常使用聚类稳健标准误，见第15章
   reg  ,cluster(state)
   *(3)可行广义最小二乘法（FGLS），估计出残差自相关系数，然后加权差分
   prais                //默认的PW估计法Prais-Winstern
   prais ,corc          //使用CO估计法  Cochrane-Orcutt
   *(4)修改模型设定，可能是遗漏了自相关的解释变量，或者将动态（含有滞后被解释变量）模型设为静态模型了

   *自相关案例
   use icecream.dta,clear
   tsset time
   *consumption 人均冰淇淋消费量
   *income 平均家庭收入
   *price 冰淇淋价格
   *temp  温度
   *time 时间
   graph twoway connect consumption temp100 time,msymbol(triangle)
                //画consumption（三角）和stemp100（圆形）时间序列趋势图,看到二者正相关，进行如下回归
   reg consumption temp price income
   predict e1,res
   g e2=L.e1
   twoway (scatter e1 e2) (lfit e1 e2)        // linear fit线性拟合e1 e2
   ac e1                                      //一阶自相关
   pac e1
   estat bgodfrey                             //BG检验 原假设是不存在自相关
   wntestq e1                                 //残差e1进行白噪声检验，原假设无自相关
   newey consumption temp price income,lag(3) //一般建议p=n^(1/4)=2.34,和OLS标准误比较
   prais consumption temp price income,corc   //corc表示CO方法检验存在自相关，OLS不再是BLUE，使用FGLS和OLS比较
   prais consumption temp price income,nolog  //prais-winstern方法，不显示迭代过程，PW估计法改进了，但是系数符号相反，没有OLS稳健了
   reg consumption temp L.temp price income   //改用OLS，考虑模型设定不正确，增加temp滞后期变量
   estat bgodfrey                             //进一步检验自相关，发现已无自相关


















