		  
*       ==========================
*          第十讲  面板数据
*       ==========================

*本章节主要内容分为面板数据的描述性分析、回归分析、单位根检验、协整检验等内容

***面板理论***

*一、固定效应or随机效应

*二、混合回归：
*   -不存在个体效应（个体效应以两种不同的形态存在：固定效应和随机效应）情况下使用；
*   -面板数据的特点：往往不同个体扰动项之间不相关，同一个体不同时期的扰动项相关；
*   -此时对标准误的估计应该使用聚类稳健标准误；
*   -聚类稳健标准误：不同聚类的观测值之间不相关，同一聚类下的不同观测值存在相关性。

*三、个体固定效应模型：Fixed Effects，ui
*   -组内平均值差分：利用了每个个体的组内离差信息，也称为组内估计量；  
*   -不随时间而变的变量被差分掉了，无法估计这些变量的影响；
*   -均值包含了各期的信息，要求各期解释变量与扰动项均不相关，较强的假定；   
*   -与LSDV方法具有同样的结果（不含截距项时引入n个虚拟变量）；   
*   -LSDV的优点是可以得到对个体异质性ui的估计，缺点是n很大，变量很多，stata无法估计。   

*四、时间固定效应：λt
*   -双向固定效应（Two-way FE）：既考虑了个体固定效应又考虑了时间固定效应；

*五、一阶差分法：First Differencing Estimator
*   -方程一阶差分后消除个体固定效应； 
*   -T=2时FD与FE等效，T>2 FE比FD更有效；
*   -实际上，主要使用FE。

*六、随机效应模型
*   -随机效应外生，OLS估计是一致的。然而扰动项不是球型扰动项，所以OLS不是有效率的；
*   -不同个体之间的扰动项不相关。由于ui的存在，同一个体的不同时期扰动项之间存在自相关；
*   -同一个体的不同时期扰动项自相关系数ρ（rho）不随时间之间的距离而改变；
*   -可以用FGLS来估计原模型得到随机效应估计量RE，OLS来估计广义离差模型；
*   -theta=O 混合回归，theta=1 组内估计量。

*七、组间估计量：
*   -每个个体不同时间观测值平均后直接回归。

*八、固定效应和随机效应检验
*   -同方差：Hausman检验，原假设是解释变量和扰动项不相关（RE），拒绝用FE；
*   -异方差：用Bootstrap或辅助回归，原假设ρ=0，RE模型，拒绝了原假设用FE

***面板案例***

*以下都是常用面板命令：
    xtset        Declare a dataset to be panel data
    xtdescribe   Describe pattern of xt data
    xtsum        Summarize xt data
    xttab        Tabulate xt data
    xtdata       Faster specification searches with xt data
    xtline       Line plots with xt data
    xtreg        Fixed-, between- and random-effects, and population-averaged linear models
    xtregar      Fixed- and random-effects linear models with an AR(1) disturbance
    xtmixed      Multilevel mixed-effects linear regression
    xtgls        Panel-data models using GLS
    xtpcse       OLS or Prais-Winsten models with panel-corrected standard errors
    xthtaylor    Hausman-Taylor estimator for error-components models
    xtfrontier   Stochastic frontier models for panel data
    xtrc         Random coefficients models
    xtivreg      Instrumental variables and two-stage least squares for panel-data models
    xtunitroot   Panel-data unit-root tests
    xtabond      Arellano-Bond linear dynamic panel-data estimator
    xtdpdsys     Arellano-Bond/Blundell-Bond estimation
    xtdpd        Linear dynamic panel-data estimation
    xttobit      Random-effects tobit models
    xtintreg     Random-effects interval-data regression models
    xtlogit      Fixed-effects, random-effects, & population-averaged logit models
    xtprobit     Random-effects and population-averaged probit models
    xtcloglog    Random-effects and population-averaged cloglog models
    xtpoisson    Fixed-effects, random-effects, & population-averaged Poisson models
    xtnbreg      Fixed-effects, random-effects, & population-averaged negative binomial models
    xtmelogit    Multilevel mixed-effects logistic regression
    xtmepoisson  Multilevel mixed-effects Poisson regression
    xtgee        Population-averaged panel-data models using GEE
  
*面板数据回归分析：

    cd E:\stata\data\
    use traffic.dta,clear
    xtset state year             //设置面板数据的两个维度    
    xtdes                        //（显示面板数据的结构，是否为平衡面板数据）
    xtsum fatal beertax spircons //（显示组间组内与整体统计指标）
    xttab mlda                   //（显示组间组内的分布频率）
    xtline fatal                 //（显示每个个体fatal变量的时间序列图，如果需要叠放，可以加上overlay）
    reg fatal beertax spircons unrate perinck,vce(cluster state) //混合回归,以state为聚类变量，使用聚类稳健标准误
    est sto OLS //结果如下：

Linear regression                               Number of obs     =        336
                                                F(4, 47)          =      17.43
                                                Prob > F          =     0.0000
                                                R-squared         =     0.3019
                                                Root MSE          =     .47929

                                 (Std. Err. adjusted for 48 clusters in state)
------------------------------------------------------------------------------
             |               Robust
       fatal |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
     beertax |   .0971997    .116884     0.83   0.410    -.1379406      .33234
    spircons |   .1623471   .1070988     1.52   0.136     -.053108    .3778021
      unrate |  -.0291014   .0208687    -1.39   0.170    -.0710838     .012881
     perinck |  -.1584291   .0371404    -4.27   0.000     -.233146   -.0837122
       _cons |   4.118674   .6765746     6.09   0.000     2.757581    5.479766
------------------------------------------------------------------------------
    
    xtreg fatal beertax spircons unrate perinck,fe r  //fe固定效应,robust稳健标准误，得到组内估计量，
                                                      //和下面的非稳健标准误结果近似，只是标准误有差异。
    est sto FE_robust                                 //和上面混合普通回归，面板回归xtreg多了下面的结果输出：

-------------+----------------------------------------------------------------
     sigma_u |  1.1181913
     sigma_e |  .15678965
         rho |  .98071823   (fraction of variance due to u_i) 
------------------------------------------------------------------------------

    xtreg fatal beertax spircons unrate perinck,fe                       //固定效应模型和下面的LSDV方法的结果近似
    est sto FE
    reg fatal beertax spircons unrate perinck i.state,vce(cluster state) //大多数个体虚拟变量p值很小，可以拒绝原假
                                                                         //设个体虚拟变量都为0，认为存在个体效应。
    est sto LSDV
    xtserial fatal beertax spircons unrate perinck,output                //没有直接执行一阶差分法的命令，组内自相关检验命令提供一阶差分法的结果,output选项表示输出回归结果;
    est sto FD //结果如下：

Linear regression                               Number of obs     =        288
                                                F(4, 47)          =       3.66
                                                Prob > F          =     0.0113
                                                R-squared         =     0.0814
                                                Root MSE          =     .19047

                                 (Std. Err. adjusted for 48 clusters in state)
------------------------------------------------------------------------------
             |               Robust
     D.fatal |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
     beertax |
         D1. |   .1187701   .2276875     0.52   0.604     -.339278    .5768183
             |
    spircons |
         D1. |    .523584   .1633135     3.21   0.002     .1950396    .8521285
             |
      unrate |
         D1. |    .003399   .0118903     0.29   0.776    -.0205212    .0273192
             |
     perinck |
         D1. |   .1417981   .0468699     3.03   0.004      .047508    .2360882
------------------------------------------------------------------------------

Wooldridge test for autocorrelation in panel data
H0: no first-order autocorrelation
    F(  1,      47) =      6.246
           Prob > F =      0.0160 //拒绝原假设，认为存在一阶自相关

    tabulate year,gen(year)       //手工生成时间虚拟变量
    xtreg fatal beertax spircons unrate perinck year2-year7,fe r //加入时间虚拟变量，双向固定效应模型
    est sto FE_TW
    test year2 year3 year4 year5 year6 year7 //检验所有年度虚拟变量的联合显著性，拒绝“无时间效应”的原假设，认为模型中应该包含时间效应
    
 (1) year2 = 0
 (2) year3 = 0
 (3) year4 = 0
 (4) year5 = 0
 (5) year6 = 0
 (6) year7 = 0

       F(  6,    47) =    8.21
            Prob > F =    0.0000 //拒绝“无时间效应”的原假设，认为存在时间效应。

    xtreg fatal beertax spircons unrate perinck i.year,fe r //此命令直接生成时间虚拟变量，进行双向固定效应模型，不必手动生成，和上面的手动生成时间虚拟变量后回归结果是一样的。
    xtreg fatal beertax spircons unrate perinck,re r theta  //随机效应模型，此处有r，使用了稳健标准误，后面的hausman检验报错
    est sto RE
    xttest0 //LM检验sigma u=0的原假设（不存在个体随机效应），结果如下：

Breusch and Pagan Lagrangian multiplier test for random effects

        fatal[state,t] = Xb + u[state] + e[state,t]

        Estimated results:
                         |       Var     sd = sqrt(Var)
                ---------+-----------------------------
                   fatal |   .3251209       .5701938
                       e |    .024583       .1567897
                       u |   .1736861       .4167567

        Test:   Var(u) = 0 //检验sigma u=0
                             chibar2(01) =   550.22
                          Prob > chibar2 =   0.0000 //拒绝原假设（sigma u=0不存在个体随机效应），认为存在个体随机效应   

    xtreg fatal beertax spircons unrate perinck,mle nolog   //也提供一个sigma u=0的原假设（不存在个体固定效应）的检验
    est sto MLE
    xtreg fatal beertax spircons unrate perinck,be  //组间估计量，用每一个个体的平均值进行回归
    est sto BE
    hausman FE RE,constant sigmamore //前面保存了结果，直接进行Hausman检验。如果使用了vce(cluster id)聚类稳健标准误，
                                     //stata无法进行Hausman检验（只适用于同方差）。只能用xtoverid外部命令。

                 ---- Coefficients ----
             |      (b)          (B)            (b-B)     sqrt(diag(V_b-V_B))
             |       FE           RE         Difference          S.E.
-------------+----------------------------------------------------------------
     beertax |   -.4840728     .0442768       -.5283495        .1462601
    spircons |    .8169652     .3024711         .514494        .0663028
      unrate |   -.0290499    -.0491381        .0200882        .0037898
     perinck |    .1047103    -.0110727         .115783        .0140556
       _cons |    -.383783     2.001973       -2.385756        .3078253
------------------------------------------------------------------------------
                           b = consistent under Ho and Ha; obtained from xtreg
            B = inconsistent under Ha, efficient under Ho; obtained from xtreg

    Test:  Ho:  difference in coefficients not systematic

                  chi2(5) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =       90.46
                Prob>chi2 =      0.0000 //拒绝原假设，认为存在固定效应，应该使用固定效应模型。
                (V_b-V_B is not positive definite)

    xtreg fatal beertax spircons unrate perinck,re r
    xtoverid  //在上一行的命令后使用此命令，存在异方差的时候进行的Hausman检验，并且适用于非平衡面板。结果如下：

Test of overidentifying restrictions: fixed vs random effects
Cross-section time-series model: xtreg re  robust cluster(state)
Sargan-Hansen statistic  63.427  Chi-sq(4)    P-value = 0.0000 //拒绝原假设（随机效应），认为应该使用固定效应模型。

    
*完整运行并输出结果：
    qui reg fatal beertax spircons unrate perinck,vce(cluster state) 
    est sto OLS
    qui xtreg fatal beertax spircons unrate perinck,fe r 
    est sto FE_robust
    qui xtreg fatal beertax spircons unrate perinck,fe 
    est sto FE
    qui reg fatal beertax spircons unrate perinck i.state,vce(cluster state)
    est sto LSDV
    qui xtserial fatal beertax spircons unrate perinck,output 
    est sto FD
    qui xtreg fatal beertax spircons unrate perinck year2-year7,fe r 
    est sto FE_TW
    qui xtreg fatal beertax spircons unrate perinck,re r theta
    est sto RE
    qui xtreg fatal beertax spircons unrate perinck,mle nolog
    est sto MLE
    qui xtreg fatal beertax spircons unrate perinck,be
    est sto BE

    reg2docx OLS FE_robust FE LSDV FD FE_TW RE MLE BE using e:\temp\panel.docx,replace /// append同一个word下追加结果，replace新建word替换
    scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("IV results") /// scalars表示输出ereturn list中的一些值 N r2_a r2_p,title表头，mtitles列标题
    mtitles("OLS" "FE_robust" "FE" "LSDV" "FD" "FE_TW" "RE" "MLE" "BE") note("(* 0.1 ** 0.05 *** 0.01)") ///note表格备注内容
    indicate("state=*state" "year=year*") landscape //indicate设置显示控制了那些变量，landscape横向输出

*FD模型的输出结果：
    qui xtserial fatal beertax spircons unrate perinck,output 
    est sto FD
    reg2docx FD using e:\temp\panel.docx,replace ///
    scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("IV results") ///
    mtitles("FD") note("(* 0.1 ** 0.05 *** 0.01)")


*
*非平衡面板数据 
	help xtbalance	
	xtbalance,range(1998 2005)	
	xtbalance,range(1998 2005) miss(invest market)

 
*固定效应与随机效应检验汇总
 
	help hausman
 
	hausman name-consistent [name-efficient] [, options]
   
   
	name-consistent  总是一致估计结果   
	name-efficient   代表原假设下有效估计结果
   
	因此需要先将fe放在前面   
	sigmamore  使用有效估计量的误差项方差来计算两个方程的协方差矩阵
	sigmaless 使用一致估计量的误差项方差来计算两个方程的协方差矩阵   
   
   
	hausman fe re   
	小于0.05，认为拒绝原假设，原假设随机效应与固定效应系数无差异，即随机效应模型的估计不一致，应该选择固定效应

 
***第三讲  面板数据检验***
 
*面板数据的单位根检验
 
 
*在计量经济学中，为了避免“伪回归”的出现，确保估计结果的有效性，通常要对时间序列

*数据和面板数据进行平稳性分析，即通过单位根检验来检验数据过程

*是否平稳。单位根检验的方法分为两大类，分别是针对同质面板假设的LLC、Breintung方法

*和针对异质面板假设的IPS 、ADF-Fisher和PP-Fisher方法。为使检验结果具备较强的

*稳健性和说服力，本文同时采用LLC检验、IPS、Fisher-ADF和Fisher-PP检验，如果在两种

*检验中均拒绝存在单位根的原假设，我们就说此序列是平稳的，反之则不平稳。

 
*所以面板数据一般平稳性检验方法有LLC检验、IPS、Fisher-ADF和Fisher-PP检验等，这些

*检验方法与eviews软件中的原理以及使用方法一样。
 
 
*从 Stata 13 开始，就已提供面板单位根检验的命令，参见 help xtunitroot 
 
    use "E:\stata\data\FDI.dta", clear
    xtset year
    xtdes
	
	xtunitroot llc lnrxrate if g7, lags(aic 10)
    xtunitroot ht lnrxrate
 
*面板数据平稳性检验
 
	help xtunitroot 

	*--- levinlin 命令 ---     Levin, Lin and Chu (LLC, 2002)
 
  
    use "E:\stata\data\FDI.dta", clear
    xtset var1 year
    xtdes 
    
    levinlin lngdp, lag(2)
          
    levinlin D.lngdp , lag(2) trend
	 
    help levinlin
 
    Examples

    use http://fmwww.bc.edu/ec-p/data/hayashi/sheston91.dta,clear

    levinlin rgdppc if country<11, lag(2)

    levinlin rgdppc if country<11, lag(2 2 2 3 3 3 4 4 4 4)

    levinlin D.rgdppc if country<11, lag(2) trend


 *--- hadrilm 命令 ---   Hadri (2000)
 
    
	
    help hadrilm
    hadrilm lngdp
    help hadrilm
    hadrilm D.lngdp
 
    Examples

    use http://fmwww.bc.edu/ec-p/data/hayashi/sheston91.dta,clear

    hadrilm rgdppc if country<11

    hadrilm D.rgdppc if country<11


 *--- ipshin 命令 ---    Im, Pesaran and Shin (IPS, 2003)
 
 
  
    ipshin lngdp, lag(2) 
   
    ipshin D.lngdp, lag(2) trend
	help   ipshin 
	  
    Examples

    use http://fmwww.bc.edu/ec-p/data/hayashi/sheston91.dta,clear

    ipshin rgdppc if country<11, lag(2)

    ipshin rgdppc if country<11, lag(2 2 2 3 3 3 4 4 4 4) nodemean

    ipshin D.rgdppc if country<11, lag(2) trend

	
