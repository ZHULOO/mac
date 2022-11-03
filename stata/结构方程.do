*********************************sem和gsem命令*********************************
*******************Example 1 — Single-factor measurement model****************
cd "/Users/zhulu/Files/data"
use https://www.stata-press.com/data/r17/sem_1fmm, clear
save sem_1fmm.dta,replace
use sem_1fmm,clear
sum 
notes
//
sem (x1 x2 x3 x4 <- X)  //默认将其中x1系数设置为1，均值为0，等价于下面的命令：
sem (X@1->x1) (X->x2) (X->x3) (X->x4), means(X@0)
sem (X->x1) (X@1->x2) (X->x3) (X->x4), means(X@100) //将x2的系数设置为1，均值设置为100；
sem (X->x1) (X->x2) (X->x3) (X@1->x4), means(X@0)
//使用不服从正态时的稳健标准误：
sem (x1 x2 x3 x4 <- X),vce(sbentler)

//也可以使用gsem命令，这种情况下结果是非常接近的：
gsem (x1 x2 x3 x4 <- X) 
rename x4 y 
reg y x1
reg y x2 
reg y x3 
//sem_1fmm.dta的生成过程：
set seed 83216
set obs 500
gen X = round(rnormal(0,10))
gen x1 = round(100 + X + rnormal(0, 10))
gen x2 = round(100 + X + rnormal(0, 10))
gen x3 = round(100 + X + rnormal(0, 10))
gen x4 = round(100 + 7*X + rnormal(0, 10))
drop X
sem (x1 x2 x3 x4 <- X) 
//一般要求X服从正态分布，下面用卡方分布模拟非正态的情形：
set seed 83216
set obs 500
gen X = (rchi2(2)-2)*(10/2)
gen x1 = round(100 + X + rnormal(0, 10))
gen x2 = round(100 + X + rnormal(0, 10))
gen x3 = round(100 + X + rnormal(0, 10))
gen x4 = round(100 + 7*X + rnormal(0, 10))
drop X
sem (x1 x2 x3 x4 <- X) 


//大样本，此时x4的系数6.99781很接近于真实值7了；
clear
set seed 83216
set obs 100000
gen X = round(rnormal(0,10))
gen x1 = round(100 + X + rnormal(0, 10))
gen x2 = round(100 + X + rnormal(0, 10))
gen x3 = round(100 + X + rnormal(0, 10))
gen x4 = round(100 + 7*X + rnormal(0, 10))
drop X
sum
sem (x1 x2 x3 x4 <- X) 

*******************Example 2 — Creating a dataset from published covariances******************
* ssd命令 — Making summary statistics data (sem only)，help ssd
clear all
ssd init a1 a2 a3 a4 a5 c1 c2 c3 c4 c5
ssd set obs 216
/* #delimit ;
#delimit cr */
ssd set cov 2038.035 \ ///
1631.766 1932.163 \ ///
1393.567 1336.871 1313.809 \ ///
1657.299 1647.164 1273.261 2034.216 \ ///
1721.830 1688.292 1498.401 1677.767 2061.875 \ ///
659.795 702.969 585.019 656.527 775.118 630.518 \ ///
779.519 790.448 653.734 764.755 871.211 500.128 741.767 \ ///
899.912 879.179 750.037 897.441 1008.287 648.935 679.970 1087.409 \ ///
775.235 739.157 659.867 751.860 895.616 550.476 603.950 677.865 855.272 \ ///
821.170 785.419 669.951 802.825 877.681 491.042 574.775 686.391 622.830 728.674  //输入一个协方差矩阵，下三角
br
save sem_2fmm
ssd status
ssd describe
label data "Affective and cognitive arousal"
label var a1 "affective arousal 1"
label var a2 "affective arousal 2"
label var a3 "affective arousal 3"
label var a4 "affective arousal 4"
label var a5 "affective arousal 5"
label var c1 "cognitive arousal 1"
label var c2 "cognitive arousal 2"
label var c3 "cognitive arousal 3"
label var c4 "cognitive arousal 4"
label var c5 "cognitive arousal 5"

notes: Summary statistics data containing published covariances ///
from Thomas O. Williams, Ronald C. Eaves, and Cynthia Cox, ///
2 Apr 2002, "Confirmatory factor analysis of an instrument designed to measure affective and cognitive arousal", ///
_Educational and Psychological Measurement_, vol. 62 no. 2, 264-283.

notes: a1-a5 report scores from 5 miniscales designed to measure affective arousal.
notes: c1-c5 report scores from 5 miniscales designed to measure cognitive arousal.
notes: The series of tests, known as the VST II (Visual Similes Test II) were administered to 216 children ages 10 to 12. The miniscales are sums of scores of 5 to 6 items in VST II. ;
ssd describe
save sem_2fmm, replace
ssd list

*******************Example 3 — Two-factor measurement model******************
use sem_2fmm,clear
ssd describe
notes
sem (Affective -> a1 a2 a3 a4 a5) (Cognitive -> c1 c2 c3 c4 c5)
sem, standardized       //显示标准化系数，标准化系数就是相关系数；a1和Affective之间的相关系数为0.9，由Affective解释的a1的方差的分数是0.90^2 = 0.81，并且未解释的是1 - 0.81 = 0.19。我们可以使用estat eqgof命令，而不是手动计算指标解释的方差比例:
estat eqgof 
//结果解读：
------------------------------------------------------------------------------
   Dependent |             Variance            |
   variables |    Fitted  Predicted   Residual | R-squared        mc       mc2
-------------+---------------------------------+------------------------------
Observed     |                                 | //由Affective解释的a1的方差的分数是0.90^2 = 0.81，并且未解释的是1 - 0.81 = 0.19;
          a1 |  2028.598   1644.463   384.1359 |  .8106398  .9003553  .8106398 //R-squared = mc2 = mc * mc
          a2 |  1923.217   1565.865   357.3524 |  .8141903  .9023249  .8141903
          a3 |  1307.726   1152.775   154.9507 |  .8815113  .9388883  .8815113
          a4 |  2024.798   1528.339   496.4594 |  .7548104  .8687982  .7548104
          a5 |  2052.328   1860.643   191.6857 |  .9066009  .9521559  .9066009
          c1 |  627.5987   455.9349   171.6638 |  .7264752  .8523351  .7264752
          c2 |  738.3325    566.527   171.8055 |  .7673061  .8759601  .7673061
          c3 |  1082.374   806.3598   276.0144 |  .7449917   .863129  .7449917
          c4 |   851.311   627.1116   224.1994 |  .7366422  .8582786  .7366422
          c5 |  725.3002   578.4346   146.8655 |  .7975107  .8930346  .7975107
-------------+---------------------------------+------------------------------
     Overall |                                 |  .9949997
------------------------------------------------------------------------------
mc  = Correlation between dependent variable and its prediction.
mc2 = mc^2 is the Bentler–Raykov squared multiple correlation coefficient.

//生成路径图
webgetsem sem_2fmm      

*******************Example 4 — Goodness-of-fit statistics******************
use sem_2fmm,clear
sem (Affective -> a1 a2 a3 a4 a5) (Cognitive -> c1 c2 c3 c4 c5)
estat gof, stats(all)
//结果，estat gof提供了很多统计检验结果，不需要都汇报，不同领域关注不同
----------------------------------------------------------------------------
Fit statistic        |      Value   Description
---------------------+------------------------------------------------------
Likelihood ratio     |
         chi2_ms(34) |     88.879   model vs. saturated
            p > chi2 |      0.000   //和上面的sem结果中的卡方检验一样，和饱和模型结果一样好；
         chi2_bs(45) |   2467.161   baseline vs. saturated
            p > chi2 |      0.000   //基准模型和饱和模型也一样好；
---------------------+------------------------------------------------------
Population error     |
               RMSEA |      0.087   Root mean squared error of approximation 
 90% CI, lower bound |      0.065                                            
         upper bound |      0.109                                            
              pclose |      0.004   Probability RMSEA <= 0.05                
/* 在总体误差下，报告RMSEA值及其90%置信区间的上下限。一般检查下限是否低于0.05或上限是否高于0.10。如果下限低于0.05，
那么他们就不会拒绝拟合接近的假设，认为拟合接近。如果上限高于0.10，他们就不会拒绝拟合较差的假设。逻辑是在90%置信区间
的每一端执行一个测试，从而对结果有95%的信心。该模型的拟合不接近，其上限刚好超过了“差”的界限。
pclose是RMSEA值小于0.05的概率，解释为预测矩接近总体矩的概率。这个模型拟合不接近。 */
---------------------+------------------------------------------------------
Information criteria |
                 AIC |  19120.770   Akaike's information criterion
                 BIC |  19191.651   Bayesian information criterion //信息准则，越小越好；
---------------------+------------------------------------------------------
Baseline comparison  |
                 CFI |      0.977   Comparative fit index  //越接近于1拟合越好；
                 TLI |      0.970   Tucker–Lewis index
---------------------+------------------------------------------------------
Size of residuals    |
                SRMR |      0.022   Standardized root mean squared residual //越小越好，一般标准小于0.08；
                  CD |      0.995   Coefficient of determination   //类似于R^2，小于1越大拟合越好；
----------------------------------------------------------------------------

*******************Example 5 — Modification indices******************
use sem_2fmm,clear
sem (Affective -> a1 a2 a3 a4 a5) (Cognitive -> c1 c2 c3 c4 c5)
//上面默认潜变量是相关的，下面看不相关的情况
sem (Affective -> a1 a2 a3 a4 a5) (Cognitive -> c1 c2 c3 c4 c5), cov(Affective*Cognitive@0)
//修正指数（modification indices）报告所有遗漏路径和协方差的统计。例如上面没有协方差的模型：
estat mindices
//结果如下
Modification indices

-----------------------------------------------------------------------
                        |                                      Standard
                        |        MI     df   P>MI        EPC        EPC
------------------------+----------------------------------------------
Measurement             | //MI:modification indices,如果添加了路径，模型拟合度变化的近似
  a5                    | //df：卡方统计量增加的自由度，P>MI：卡方统计量的显著性，EPC：期望的参数变化，参数如果没有约束为0时的近似
              Cognitive |     8.059      1   0.00   .1604476    .075774
  ----------------------+----------------------------------------------
  c5                    |
              Affective |     5.885      1   0.02   .0580897    .087733
------------------------+----------------------------------------------
          cov(e.a1,e.a4)|     5.767      1   0.02   84.81133   .1972802
          cov(e.a1,e.a5)|     7.597      1   0.01  -81.82092  -.2938627
          cov(e.a2,e.a4)|    14.300      1   0.00    129.761   .3110565
          cov(e.a2,e.c4)|     4.071      1   0.04  -45.44807  -.1641344
          cov(e.a3,e.a4)|    21.183      1   0.00  -116.8181  -.4267012
          cov(e.a3,e.a5)|    25.232      1   0.00   118.4674   .6681337
          cov(e.a5,e.c4)|     4.209      1   0.04   39.07999    .184049
          cov(e.c1,e.c3)|    11.326      1   0.00    66.3965   .3098331
          cov(e.c1,e.c5)|     8.984      1   0.00  -47.31483  -.2931597
          cov(e.c3,e.c4)|    12.668      1   0.00  -80.98353   -.333871
          cov(e.c4,e.c5)|     4.483      1   0.03    38.6556   .2116015
cov(Affective,Cognitive)|   128.482      1   0.00   704.4469   .8094959
-----------------------------------------------------------------------
EPC is expected parameter change.
//结果可以看出有很多忽略的路径和协方差

*******************Example 6 — Linear regression******************
//和线性回归的关系
sysuse auto,clear
regress mpg weight c.weight#c.weight foreign
regress,beta //得到标准化的回归系数
//使用sem
generate weight2 = weight^2
sem (mpg <- weight weight2 foreign)
sem,standardized //输出标准化系数
/* 1. sem命令不支持交互项的形式，所以要先生成一个平方项；
2. 对比回归的结果，二者几乎相同，标准误少有差别的原因在于自由度不同，回归的自由度是n = 74，而sem自由度为n-k-1 = 74-3-1 = 70
3. sem汇报的是z统计量，而回归汇报的是t统计量；
4. 置信区间的不同也是因为自由度的区别； */
//回归后生成路径界面：
sysuse auto,clear
generate weight2 = weight^2
regress mpg weight weight2 foreign
webgetsem sem_regress  //显示上面回归的路径图
//使用路径界面回归：

*******************Example 7 — Nonrecursive structural model******************
cd "users/zhulu/files/data"
use https://www.stata-press.com/data/r17/sem_sm1,clear
save sem_sm1.dta,replace
use sem_sm1,clear
ssd describe
notes
ssd status  //可以看到数据是一个相关矩阵，没有方差和均值信息，使用时要小心；
sem (r_occasp <- f_occasp r_intel r_ses f_ses) (f_occasp <- r_occasp f_intel f_ses r_ses), cov(e.r_occasp*e.f_occasp) standardized
//两个潜变量之间有互动
webgetsem sem_sm1 //显示路径图


*******************example 1******************
*******************example 1******************
*******************example 1******************