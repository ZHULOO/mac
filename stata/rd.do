      *       ==========================
          *          第十六讲  断点回归
		  *       ==========================
  
*===================
*-> 一、断点回归简介  
*===================	
 
	*断点回归可分为两种类型。一种类型是“精确断点回归”(Sharp Regression Discontinuity
	*，简记 SRD)，其特征是在断点 x = c 处，个体得到处理的概率从 0 跳跃为 1。
 
	*另一种类型为“模糊断点回归”(Fuzzy Regression Discontinuity，简记 FRD)，
	*其特征是在断点x=c 处，个体得到处理的概率从 a跳跃为 b，其中0＜a＜b＜1

*=============================
*-> 二、rd断点回归的操作案例  
*=============================
   
*******2.1、语法格式****** 
	ssc inst rd,replace
	help rd
***语法格式为：
	help rd

	rd [varlist] [if] [in] [weight] [, options]
  * 其中options选项包括以下:
	mbw(numlist) //用来指定最优带宽的倍数，默认值为mbw(50  100 200);
	z0(real)     //用来指定断点的位置，默认值为z0(0)，即断点为原点;
  D            //如果此处省去D，则为精确断点回归，并根据分组变量X来计算处理变量;
	strineq      //根据严格不等式，来计算处理变量，如果X大于断点z0，则D取1，否则，取0;
	x(varlist)   //表示检验这些协变量在断点处是否存在跳跃（估计跳跃值和显著性;

	ddens requests a computation of a discontinuity in the density of Z.  This is
    computed in a relatively ad hoc way, and should be redone using McCrary's
    test described at http://www.econ.berkeley.edu/~jmccrary/DCdensity/.

	s(stubname) requests that estimates be saved as new variables beginning with
    stubname.

	graph requests that local linear regression graphs for each bandwidth be
    produced. //根据每一带宽，画出局部线性回归图

	noscatter suppresses the scatterplot on those graphs.

	cluster(varlist) requests standard errors robust to clustering on distinct
    combinations of varlist (e.g. stratum psu).

	scopt(string) supplies an option list to the scatter plot.

	lineopt(string) supplies an option list to the overlaid line plots.

	n(real) specifies the number of points at which to calculate local linear
    regressions.  The default is to calculate the regressions at 50 points above
    the cutoff, with equal steps in the grid, and to use equal steps below the
    cutoff, with the number of points determined by the step size.

	bwidth(real) allows specification of a bandwidth for local linear regressions.
    The default is to use the estimated optimal bandwidth for a "sharp" design
    as given by Imbens and Kalyanaraman (2009).  The optimal bandwidth minimizes
    MSE, or squared bias plus variance, where a smaller bandwidth tends to
    produce lower bias and higher variance. Note that the optimal bandwidth will
    often tend to be larger for a fuzzy design, due to the additional variance
    that arises from the estimation of the jump in the conditional mean of
    treatment.

	bdep requests a graph of estimates versus bendwidths. //根据画图来考察断点回归估计量对带宽的依赖性

	bingraph requests a graph of binned means instead of a scatterplot, in bins
    defined by binvar.

	binvar(varname) specifies the variable across which binned means should be
    calculated.

	oxline adds a vertical line at the default bandwidth. //表示在此图的默认带宽上画出一条直线，以便识别

	kernel(rectangle) requests the use of a rectangle (uniform) kernel. The default
    is a triangle (edge) kernel.  //表示使用均匀核（矩阵核），默认使用三角核

	covar(varlist) adds covariates to Local Wald Estimation, which is generally a
    Very Bad Idea.  It is possible that covariates could reduce residual
    variance and improve efficiency, but estimation error in their coefficients
    could also reduce efficiency, and any violations of the assumptions that
    such covariates are exogenous and have a linear impact on mean treatment and
    outcomes could greatly increase bias.  //表示用来指定加入局部线性回归的协变量


***关于rd命令的语法格式汇总如下:	
	rd y d x， z0(real) strineq mbw(numlist) graph   bdep oxline kernel(rectangle) covar(varlist) x(varlist)

	mbw(numlist)       //用来指定最优带宽的倍数，默认值为mbw(50  100 200)，
	z0(real)           //用来指定断点的位置，默认值为z0(0)，即断点为原点
***如果此处省去D,则为精确断点回归，并根据分组变量X来计算处理变量	
	graph              //根据每一带宽，画出局部线性回归图
	bdep               //根据画图来考察断点回归估计量对带宽的依赖性
	oxline             //表示在此图的默认带宽上画出一条直线，以便识别
	kernel(rectangle)  //表示使用均匀核（矩阵核），默认使用三角核
	covar(varlist)     //表示用来指定加入局部线性回归的协变量
	x(varlist)         //表示检验这些协变量在断点处是否存在跳跃（估计跳跃值和显著性）




*******2.2、操作***** 
    *这个案例主要介绍了美国国会选区，如果有民主党众议员，对该选区的联邦政府的开支具有一定影响。
    *传统意义上，民主党会更倾向于大政府，故一个选区如果有民主党众议员，则该议员可能为该选取争取更多联邦政府的开支。然而直接对二者进行回归，
    *可能会遗漏变量问题或者双向因果关系。

    *为此选择该民主党候选人的得票比例作为分组变量，以0.5为断点（在民主党与共和党的政治中，
    *如果得票比例大于或者等于0.5，则当选，反之落选），进行断点回归，rd估计了两个方面的局部线性回归
    
    *votex数据为系统自带的数据，包含的主要变量为:
    *lne   //选取联邦政府开支的对数
    *d    //分组变量，民主党派候选人的得票比例减去0.5，以标准化
    *win  //民主党派候选人当选
    *另外还包括一些协变量

********2.3  rd code******

    clear
    cd E:\data
    cd E:\stata\data                    
    use  "votex.dta", clear  
    describe       

//1.回归模型
*首先使用所有变量直接进行线性回归，发现结果：    
	reg lne win i votpop bla-vet

      Source |       SS           df       MS      Number of obs   =       349
-------------+----------------------------------   F(13, 335)      =     12.40
       Model |  21.1835907        13  1.62950698   Prob > F        =    0.0000
    Residual |  44.0386648       335  .131458701   R-squared       =    0.3248
-------------+----------------------------------   Adj R-squared   =    0.2986
       Total |  65.2222555       348  .187420274   Root MSE        =    .36257

------------------------------------------------------------------------------
         lne |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
         win |   .0417002   .0447146     0.93   0.352    -.0462566     .129657
           i |   .0087295    .060656     0.14   0.886    -.1105852    .1280442
      votpop |   .7657785   .7660158     1.00   0.318    -.7410287    2.272586
       black |   .1237281   .2185986     0.57   0.572    -.3062708     .553727
     blucllr |  -4.639677    1.88317    -2.46   0.014    -8.344006   -.9353476
      farmer |   4.001597   2.088776     1.92   0.056    -.1071728    8.110368
     fedwrkr |  -4.617619   1.668737    -2.77   0.006    -7.900144   -1.335095
     forborn |   1.391259   .4649527     2.99   0.003     .4766639    2.305853
       manuf |  -1.681957   1.025185    -1.64   0.102    -3.698567    .3346539
    unemplyd |   2.372895   2.986064     0.79   0.427    -3.500903    8.246694
       union |  -5821.583   1809.906    -3.22   0.001    -9381.796    -2261.37
       urban |  -.9144764   .1568328    -5.83   0.000    -1.222978   -.6059753
    veterans |   1.941931   1.999632     0.97   0.332    -1.991486    5.875349
       _cons |   21.80585   .5792415    37.65   0.000     20.66644    22.94526
-----------------------------------------------------------------------------

//上述回归分析结果，虽然win表示当选了，会增加lne的支出，但是不显著


//2.进行断点回归
*首先选择默认的带宽以及三角核进行断点回归，命令为
    rd lne d, gr mbw(100)
*结果为:
    rd lne d, gr mbw(100)
Two variables specified; treatment is 
assumed to jump from zero to one at Z=0. 

 Assignment variable Z is d
 Treatment variable X_T unspecified
 Outcome variable y is lne

Command used for graph: lpoly; Kernel used: triangle (default)
Bandwidth: .29287776; loc Wald Estimate: -.07739553
Estimating for bandwidth .2928777592534939
------------------------------------------------------------------------------
         lne |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
       lwald |  -.0773955   .1056062    -0.73   0.464      -.28438    .1295889
------------------------------------------------------------------------------


上面结果表明，局部沃尔德估计量（loc Wald Estimate: -.07739553）为负，且很不显著，说明拥有民主党派候选人当选的选区
并不能显著的增加联邦政府开支
*图使用最优带宽和三角核进行断点回归结果图.wmf表明只有在断点d=0处才有稍微跳跃并且是向下的
    shellout E:\stata\personal18\高级计量经济学\A16-rd\使用最优带宽和三角核进行断点回归结果图.wmf
//加入协变量进行断点回归，但是省略作图
    rd lne d, mbw(100) cov(i votpop black  blucllr farmer fedwrkr  forborn manuf  unemplyd union urban veterans)
*结果为
    rd lne d, mbw(100) cov(i votpop black  blucllr farmer fedwrkr  forborn manuf  un
> emplyd union urban veterans)
Two variables specified; treatment is 
assumed to jump from zero to one at Z=0. 

 Assignment variable Z is d
 Treatment variable X_T unspecified
 Outcome variable y is lne

Estimating for bandwidth .2928777592534939
------------------------------------------------------------------------------
         lne |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
       lwald |   .0543733   .0921634     0.59   0.555    -.1262636    .2350102
----------------------------------------------------------------------------

上表显示估计值虽然为正，但是依然不显著
//去掉协变量，同时估计三种带宽，并画出估计值对带宽的依赖性
    rd lne d, gr bdep oxline

*结果为
    rd lne d, gr bdep oxline
Two variables specified; treatment is 
assumed to jump from zero to one at Z=0. 

 Assignment variable Z is d
 Treatment variable X_T unspecified
 Outcome variable y is lne

Command used for graph: lpoly; Kernel used: triangle (default)
Bandwidth: .29287776; loc Wald Estimate: -.07739553
Bandwidth: .14643888; loc Wald Estimate: -.09491495
Bandwidth: .58575552; loc Wald Estimate: -.0543086
Estimating for bandwidth .2928777592534939
Estimating for bandwidth .146438879626747
Estimating for bandwidth .5857555185069878
------------------------------------------------------------------------------
         lne |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
       lwald |  -.0773955   .1056062    -0.73   0.464      -.28438    .1295889
     lwald50 |  -.0949149   .1454442    -0.65   0.514    -.3799804    .1901505
    lwald200 |  -.0543086   .0911788    -0.60   0.551    -.2330157    .1243985
------------------------------------------------------------------------------

*结果显示，改变带宽对估计值有一定的影响，但是三个估计值全部为负，且依然不显著
*可以看出，各个断点回归估计量对带宽的依赖性不大。
//进行断点回归，还需要对其进行检验，检验协变量在断点处的条件密度是否存在跳跃
    rd lne d, mbw(100) x(i votpop black  blucllr farmer fedwrkr  forborn manuf  unemplyd union urban veterans)
*结果为
    rd lne d, mbw(100) x(i votpop black  blucllr farmer fedwrkr  forborn manuf  unem
> plyd union urban veterans)
Two variables specified; treatment is 
assumed to jump from zero to one at Z=0. 

 Assignment variable Z is d
 Treatment variable X_T unspecified
 Outcome variable y is lne

Estimating for bandwidth .2928777592534939
------------------------------------------------------------------------------
         lne |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
           i |  -.0044941   .1208008    -0.04   0.970    -.2412592    .2322711
      votpop |  -.0082128   .0062347    -1.32   0.188    -.0204326    .0040071
       black |  -.0036113    .020048    -0.18   0.857    -.0429046    .0356821
     blucllr |   .0026193   .0057316     0.46   0.648    -.0086144     .013853
      farmer |  -.0078737   .0037566    -2.10   0.036    -.0152366   -.0005109 //
     fedwrkr |   .0001617   .0037584     0.04   0.966    -.0072046    .0075281
     forborn |   -.015235   .0120682    -1.26   0.207    -.0388882    .0084183
       manuf |   .0147223   .0100352     1.47   0.142    -.0049463    .0343908
    unemplyd |  -.0007393   .0019069    -0.39   0.698    -.0044769    .0029982
       union |  -2.25e-06   3.66e-06    -0.61   0.540    -9.43e-06    4.94e-06
       urban |   .0370978   .0559882     0.66   0.508     -.072637    .1468326
    veterans |   .0015796   .0036205     0.44   0.663    -.0055164    .0086756
       lwald |  -.0773955   .1056062    -0.73   0.464      -.28438    .1295889
------------------------------------------------------------------------------

    *结果显示，可以看出 除了变量farmer的概率值为 0.036，其余的协变量的条件密度函数在断点处
    *都是连续的，即只有变量farmer（农民占人口比例）是存在跳跃的；

***模拟数据案例:
作者：连玉君
链接：https://www.zhihu.com/question/51676548/answer/215676606
来源：知乎

补充一个，rdrobust, rdplot 配合使用是很好的选择。如下几篇文章对这两个命令进行了详细的介绍，内含数据和范例：  
  Calonico, S., M. D. Cattaneo, M. H. Farrell, and R. Titiunik. 2016. Regression discontinuity designs using covariates.  Working Paper, University of Michigan.  http://www-personal.umich.edu/~cattaneo/papers/Calonico-Cattaneo-Farrell-Titiunik_2016_wp.pdf.    
  Calonico, S., M. D. Cattaneo, M. H. Farrell, and R. Titiunik.  2017.  rdrobust: Software for regression-discontinuity designs.  Stata Journal 17: 372-404.    Calonico, S., M. D. Cattaneo, and R. Titiunik. 2014a. Robust data-driven inference in the regression-discontinuity design.  Stata Journal 14: 909-946.
 
*-1- 生成一份模拟数据

  clear
  set obs 4000
  set seed 123
  gen x = runiform()
  gen z = rnormal()*0.5  //其他影响 y 的因素
  gen T=0
  replace T=1 if x>0.5

  gen g0 = 0 + 3*log(x+1) + sin(x*6)/3
  gen g1 = T + 3*log(x+1) + sin(x*6)/3
    scatter g0 x, msize(*0.5) 
  scatter g1 x, msize(*0.5) 
  gen e = rnormal()/5      // noise
  gen y1 = g1 + 0.5*z + e 
  gen y0 = g0 + 0.5*z + e

  gen xc = x-0.5 

  label var y1 "Outcome variable (y)"
  label var y0 "Outcome variable (y)"
  label var x  "Assignment variable (x)"
  label var xc "Centered Assignment variable (x-c)"
  label var T  "T=1 for x>0.5, T=0 otherwise"

  save "RDD_simu_data0.dta", replace  //保存一份数据以备后用

  *---
  *-2- RDD 图示  

      *-With Treat effect                             -------图2-----begin--
      twoway (scatter y1 x, msymbol(+) msize(*0.4) mcolor(black*0.3)) 
      (qfit y1 x if T==0, lcolor(red)  msize(*0.4))  ///
      (qfit y1 x if T==1, lcolor(blue) msize(*0.4)), ///
      xline(0.5, lpattern(dash) lcolor(gray))       ///
      text(3.5 0.3 "Control") text(3.5 0.7 "Treat") ///
      legend(off) xlabel(0 0.5 "Cut point" 1)       ///
      ytitle("毕业当年月薪(万元)")
    *                                             ----------------over---

    local method "qfit"   //二次函数
    //local method "lpoly"  //核加权多项式
    local h=0.1
    local cL = 0.5 - `h' 
    local cR = 0.5 + `h'
    dropvars left right
    gen left  = (x>0.5-`h')&(x<0.50)  //0.4 < x < 0.5,带宽为0.1;
    gen right = (x>0.50)&(x<0.5+`h')  //0.5 < x < 0.6
      twoway (scatter y1 x, msymbol(+) msize(*0.4) mcolor(black*0.3)) ///
        (`method' y1 x if T==0, lcolor(red) msize(*0.4))  ///
        (`method' y1 x if T==1, lcolor(red) msize(*0.4))  ///    
        (lfit y1 x if (T==0&left==1) , lcolor(blue) msize(*0.4))   ///
        (lfit y1 x if (T==1&right==1), lcolor(blue) msize(*0.4)),  ///
        xline(0.5, lpattern(dash) lcolor(gray))       ///
        xline(`cL' `cR', lp(dash) lc(black*0.2))      ///
        text(3.5 0.3 "Control") text(3.5 0.7 "Treat")   ///
        legend(off) xlabel(0 `cL' 0.5 "CP(.5)" `cR' 1)  ///
        ytitle("毕业当年月薪(万元)")  xtitle("")      
    *------------------------------------------------------------over---   
*-先指定一个带宽 h, 例如 h=0.1
*-在 [-h< xc < +h] 的窗口范围内，分别在 xc=0 左右两侧执行 OLS 估计
* 左侧:
local h=0.1                     //带宽
reg y1 xc if (xc>-`h')&(xc<0)   // Left

      Source |       SS       df       MS              Number of obs =     393
-------------+------------------------------           F(  1,   391) =    0.50
       Model |  .053888311     1  .053888311           Prob > F      =  0.4796
    Residual |  42.0806724   391  .107623203           R-squared     =  0.0013
-------------+------------------------------           Adj R-squared = -0.0013
       Total |  42.1345607   392  .107486124           Root MSE      =  .32806

------------------------------------------------------------------------------
          y1 |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
          xc |   .4113711   .5813524     0.71   0.480    -.7315965    1.554339
       _cons |   1.276515   .0342345    37.29   0.000     1.209209    1.343822
------------------------------------------------------------------------------
* 右侧:
local h 0.1
reg y1 xc if (xc>0)&(xc<`h')    // Right

      Source |       SS       df       MS              Number of obs =     371
-------------+------------------------------           F(  1,   369) =    0.25
       Model |  .027425073     1  .027425073           Prob > F      =  0.6153
    Residual |  40.0101949   369  .108428712           R-squared     =  0.0007
-------------+------------------------------           Adj R-squared = -0.0020
       Total |  40.0376199   370  .108209784           Root MSE      =  .32929

------------------------------------------------------------------------------
          y1 |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
          xc |   .2955909   .5877454     0.50   0.615    -.8601598    1.451342
       _cons |   2.236744    .034326    65.16   0.000     2.169245    2.304243
------------------------------------------------------------------------------

dis "ATE = " %4.3f  2.236744-1.276515
ATE = 0.960

* 或者，也可以执行混合估计：  
global h=0.1
reg y1 T xc if (xc>=-$h)&(xc<=$h)  // -0.1 < xc < 0.1 断点两侧放在一起混合回归;

      Source |       SS       df       MS              Number of obs =     764
-------------+------------------------------           F(  2,   761) =  878.57
       Model |  189.551232     2  94.7756158           Prob > F      =  0.0000
    Residual |  82.0929862   761  .107875146           R-squared     =  0.6978
-------------+------------------------------           Adj R-squared =  0.6970
       Total |  271.644218   763  .356021255           Root MSE      =  .32844

------------------------------------------------------------------------------
          y1 |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
           T |   .9602386   .0484458    19.82   0.000     .8651352    1.055342
          xc |   .3538983   .4130398     0.86   0.392    -.4569344    1.164731
       _cons |   1.273553   .0269789    47.21   0.000     1.220591    1.326515
------------------------------------------------------------------------------

***rdrobust***
search rdrobust
findit rdrobust
use "use http://www.stata-press.com/data/r15/rdrobust_rdsenate.dta",clear
use "https://gitee.com/arlionn/data/raw/master/data01/rdrobust_rdsenate.dta", clear
cd e:\data
use "rdrobust_rdsenate.dta",clear

