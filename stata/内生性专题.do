***内生性专题*** 第10章，工具变量，2SLS与GMM

*一、计量分析的大致过程:

*(一)、建模首先要考虑是否存在内生性：（无偏性、一致性：估计量的期望等于真实值或者依概率收敛于真实值） 
*1、内生性导致估计系数是有偏或非一致的，存在系统性偏误。
*2、只有保证了估计的无偏或一致性，再考虑估计量的有效性才是有意义的。
*3、如果不存在内生性,则估计量是一致的,此时分别考虑扰动项是否iid
  *-扰动项为iid时,OLS和MM方法都是有效的;
  *-扰动项非iid时,MM方法比OLS有效,此时可以使用MM/GLS/WLS/FGLS方法,也可以使用OLS方法+异方差稳健标准误;
*4、如果存在内生性：
  *-扰动项为iid时,IV、2SLS和GMM是等价的,此时2SLS是最有效的,IV适用恰好识别,而2SLS和GMM适用过度识别的情况;
  *-扰动项非iid时,GMM比2SLS有效;

*(二)、其次考虑异方差和序列相关：（有效性：估计量方差最小）
*1、先解决了内生性，估计量才可能是无偏和一致的。
*2、解决了内生性之后，再消除异方差等带来的非有效性影响。
*3、异方差一般存在于截面数据，序列相关一般存在于时间序列数据。

*(三)、检验内生性的时要考虑是否存在异方差性
*1、不存在异方差，普通Hausman检验。
*2、存在异方差，Bootstrap方法或者Durbin-Wu-Hausman检验。

*(四)、矩估计
*1、IV法也是一种矩估计
*2、OLS也是一种矩估计
*3、OLS也是一种IV，OLS相当于所有的解释变量都是前定的外生变量的IV法的一种特殊情况，将自己作为工具变量

*二、内生性检验（决定OLS or IV）
*是否存在内生解释变量，要进行Hausman检验，检验模型是否含有内生解释变量，分两种情况：
*1、模型无异方差的情况
*传统的Hausman检验，因为原假设是所有解释变量都是外生的，如果无异方差性，则OLS是BLUE估计
cd E:\data
use grilic.dta,clear
qui reg lw iq s expr tenure rns smsa
estimates store ols
qui ivregress 2sls lw s expr tenure rns smsa (iq = med kww)
estimates store iv
hausman iv ols,constant sigmamore
*结果如下：
            ---- Coefficients ----
             |      (b)          (B)            (b-B)     sqrt(diag(V_b-V_B))
             |       iv          ols         Difference          S.E.
-------------+----------------------------------------------------------------
          iq |    .0139284     .0032792        .0106493        .0054318
           s |    .0607803     .0927874        -.032007        .0163254
        expr |    .0433237     .0393443        .0039794        .0020297
      tenure |    .0296442      .034209       -.0045648        .0023283
         rns |   -.0435271    -.0745325        .0310054        .0158145
        smsa |    .1272224     .1367369       -.0095145        .0048529
       _cons |    3.218043     3.895172       -.6771285        .3453751
------------------------------------------------------------------------------
                       b = consistent under Ho and Ha; obtained from ivregress
          B = inconsistent under Ha, efficient under Ho; obtained from regress

    Test:  Ho:  difference in coefficients not systematic

                  chi2(1) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =        3.84
                Prob>chi2 =      0.0499 //0.05显著性水平上拒绝原假设，所有变量为外生的，认为存在内生性
                (V_b-V_B is not positive definite)
*2、模型存在异方差的情况
*传统Hausman检验不再适用，因为此时OLS存在异方差，不是BLUE估计，有两种方法解决
*①Bootstrap方法计算D
*②杜宾-吴-豪斯曼检验(Dubin-Wu-Hausman Test)：异方差稳健的DWH检验，命令如下
estat endogenous //使用在ivregress 2sls命令之后
*结果如下：
Tests of endogeneity
  Ho: variables are exogenous

  Durbin (score) chi2(1)          =  3.87962  (p = 0.0489)
  Wu-Hausman F(1,750)             =  3.85842  (p = 0.0499) //p值小于0.05拒绝原假设，认为iq是内生的
*也可以使用ivreg2命令进行稳健的内生性检验 ssc install ivreg2
ivreg2 lw s expr tenure rns smsa (iq = med kww),r endog(iq) //endog(iq) //endog(iq)检验iq是否为内生变量,这里使用了r选项,假设扰动项非iid
*结果如下：
IV (2SLS) estimation
--------------------

Estimates efficient for homoskedasticity only
Statistics robust to heteroskedasticity

                                                      Number of obs =      758
                                                      F(  6,   751) =    61.10
                                                      Prob > F      =   0.0000
Total (centered) SS     =  139.2861498                Centered R2   =   0.2775
Total (uncentered) SS   =  24652.24662                Uncentered R2 =   0.9959
Residual SS             =  100.6291971                Root MSE      =    .3644

------------------------------------------------------------------------------
             |               Robust
          lw |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
          iq |   .0139284   .0060393     2.31   0.021     .0020916    .0257653
           s |   .0607803   .0189505     3.21   0.001      .023638    .0979227
        expr |   .0433237   .0074118     5.85   0.000     .0287968    .0578505
      tenure |   .0296442    .008317     3.56   0.000     .0133432    .0459452
         rns |  -.0435271   .0344779    -1.26   0.207    -.1111026    .0240483
        smsa |   .1272224   .0297414     4.28   0.000     .0689303    .1855146
       _cons |   3.218043   .3983683     8.08   0.000     2.437256    3.998831
------------------------------------------------------------------------------
Underidentification test (Kleibergen-Paap rk LM statistic):             24.223 //不可识别检验，拒绝
                                                   Chi-sq(2) P-val =    0.0000 //原假设（不可识别）
------------------------------------------------------------------------------ 
Weak identification test (Cragg-Donald Wald F statistic):               14.906 //弱工具变量检验，需要iid假设
                         (Kleibergen-Paap rk Wald F statistic):         13.403 //弱工具变量检验，不需要iid假设
Stock-Yogo weak ID test critical values: 10% maximal IV size             19.93 //上面的F值和此处Yogo提供临界值
                                         15% maximal IV size             11.59 //比较，做出判断
                                         20% maximal IV size              8.75
                                         25% maximal IV size              7.25
Source: Stock-Yogo (2005).  Reproduced by permission.
NB: Critical values are for Cragg-Donald F statistic and i.i.d. errors.
------------------------------------------------------------------------------
Hansen J statistic (overidentification test of all instruments):         0.151 //上面模型使用了r,假设模型扰动项非iid,这里提供了Hansen J统计量
                                                   Chi-sq(1) P-val =    0.6972 //过度识别检验,接受原假设所有工具变量都是外生的
-endog- option:
Endogeneity test of endogenous regressors:                               3.615 //iq变量的内生性检验
                                                   Chi-sq(1) P-val =    0.0573 //接近0.05，可以10%拒绝
Regressors tested:    iq                                                       //原假设iq外生
------------------------------------------------------------------------------
Instrumented:         iq
Included instruments: s expr tenure rns smsa
Excluded instruments: med kww
------------------------------------------------------------------------------
*三、存在内生性解释变量，使用工具变量法

***使用工具变量法时，必须对工具变量的有效性进行检验***

***工具变量法***
*-若检验存在内生性，使用工具变量法IV：
*-GMM之于2SLS，正如GLS之于OLS，可以如下理解：
*-OLS-- GLS 满足经典假定时（球型扰动项），OLS有效，否则用GLS；
*-2SLS--GMM 满足经典假定时（球型扰动项），2SLS有效，否则用GMM。

***IV--2SLS--GMM***
*-这里的IV 2SLS GMM都是工具变量法的一种情况
*-IV   仅适用于恰好识别的情形，过度识别时，直接扔掉包含有用信息的多余工具变量是无效的，可以使用2SLS和GMM
*-2SLS 适用于球型扰动项、过度识别的条件，此时2SLS是渐近有效的
*-GMM  适用非球型扰动项(即存在异方差或序列相关)、过度识别的情况下，此时GMM方法更有效。具体可以分为以下情况：

***识别问题***
*-L<K，不可识别

*-L=K，恰好识别，唯一解：
*①  球型扰动项：适用2SLS方法。
*②非球型扰动项：适用 GMM方法。此时GMM就还原为普通的工具变量法（IV），也是传统矩估计法（MM）。

*-L>K，过度识别，无解：
*①  球型扰动项：适用2SLS方法。
*②非球型扰动项：适用 GMM方法。必须使用GMM法:可以使用异方差自相关稳健标准误的gmm法。


*(一)、首先工具变量有效性检验：
cd E:\data
use grilic.dta,clear

*1、不可识别检验,原假设:不可识别,L<K
*-假设扰动项为iid,使用Anderson LM 统计量
*-不作扰动项为iid的假设,使用Kleibergen-Paap rk LM statistic统计量
ivreg2 lw s expr tenure rns smsa (iq = med kww) //ivreg2命令会报告不可识别检验、弱工具变量检验
                                                //以及过度识别检验，结果见上表
*2、弱工具变量检验,原假设:存在弱工具变量,一般当F值>10可以拒绝原假设,不用考虑弱工具变量问题;
*-扰动项为iid时,使用Cragg-Donald Wald F statistic统计量和Stock-Yogo weak ID test critical values临界值比较；
*-扰动项不为iid时,使用Kleibergen-Paap rk Wald F statistic统计量和Stock-Yogo weak ID test critical values临界值比较；
*ivreg2命令汇报上面结果，见上表及注释
*或者使用以下命令:
ivregress 2sls lw s expr tenure rns smsa (iq = med kww),r first //使用了r稳健标准误一般默认方程式非iid,可能存在异方差;
estat firststage,all forcenonrobust                             //或者使用ivreg2命令也汇报弱工具变量检验的结果;
*结果如下表，已给与注释
 First-stage regression summary statistics
  --------------------------------------------------------------------------
               |            Adjusted      Partial       Robust
      Variable |   R-sq.       R-sq.        R-sq.      F(2,750)   Prob > F
  -------------+------------------------------------------------------------
            iq |  0.3066      0.3001       0.0382       13.4028    0.0000  //p值小于0.05，拒绝
  --------------------------------------------------------------------------
                                                     //此F值大于10，拒绝：存在弱工具变量的原假设

  Shea's partial R-squared
  --------------------------------------------------
               |     Shea's             Shea's
      Variable |  Partial R-sq.   Adj. Partial R-sq.
  -------------+------------------------------------
            iq |     0.0382             0.0305  //较低的R方 才能构成弱工具变量
  --------------------------------------------------


  Minimum eigenvalue statistic = 14.9058 //多个内生解释变量的情况，比较此最小特征值统计量和以下临界值的大小

  Critical Values                      # of endogenous regressors:    1 //弱工具变量的原假设和临界值
  Ho: Instruments are weak             # of excluded instruments:     2
  ---------------------------------------------------------------------
                                     |    5%     10%     20%     30%
  2SLS relative bias                 |         (not available)
  -----------------------------------+---------------------------------
                                     |   10%     15%     20%     25%
  2SLS Size of nominal 5% Wald test  |  19.93   11.59    8.75    7.25 //14.9507>11.59临界值，拒绝原假设
  LIML Size of nominal 5% Wald test  |   8.68    5.33    4.42    3.92
  ---------------------------------------------------------------------
*弱工具变量的解决办法：
*-寻找更强的工具变量
*-使用对弱工具变量更不敏感的“有限信息最大似然估计法”(LIMI)
ivregress limi lw s expr tenure rns smsa (iq = med kww),r
*-如果有较多弱工具变量，可舍弃弱工具变量，进行冗余检验，原假设：指定的工具变量(kww)是多余的;
ivreg2 lw s expr tenure rns smsa (iq = med kww),r redundant(kww) //检验kww是否冗余;

*3、过度识别检验，原假设：过度识别，所有工具变量都是外生的。
* -扰动项为iid,使用Sargan统计量与临界值比较，如果拒绝原假设,则认为有工具变量不是外生的;
* -扰动项不为iid时,使用Hansen J统计量
* 也不能证明这些工具变量的外生性，过度识别检验也不能告诉我们那些工具变量是无效的。   
estat overid //或者使用ivreg2命令也汇过度识别检验的结果

*(二)、其次使用工具变量法：
*2SLS法的使用
ivregress 2sls lw s expr tenure rns smsa (iq = med kww mrt age)
*GMM法的使用

*1、GMM过度识别检验(Overidentification Test or Hanson's J Test),原假设：所有工具变量均是外生的
ivregress gmm
ivregress gmm
estat overid

*2、检验部分工具变量的正交性；如果拒绝了过度识别的原假设，则部分工具变量不满足正交性，是内生的
*  构造C统计量=两次GMM估计的Sargan-Hansen统计量之差，L（过度识别）-L1（恰好识别）
ivreg2 lw s expr tenure rns smsa (iq = med kww mrt age),gmm2s robust orthog(mrt age) //ivreg2默认使用2SLS，
* 加上选择项gmm2s robust两步最优gmm估计量，orthog检验mrt和age是否满足正交性

*3、存在自相关的情况下使用GMM
*异方差的情况下，GMM依然是稳健与最优的。如果同时存在自相关，也可以使用GMM，只要采用异方差自相关稳健标准误Newey-West标准误
ivregress gmm lw s expr tenure rns smsa (iq = med kww),vce(hac nwest[#])

*(三)、工具变量法案例：
cd E:\data
use grilic.dta,clear
reg lw s expr tenure rns smsa,r //先做一个OLS作为参考，发现系数存在问题，可能存在遗漏变量问题
iveregress 2sls lw s expr tenure rns smsa (iq= med kww mrt age),r //增加iq作为解释变量，并使用工具变量
estat overid //简易过度识别检验，拒绝所有工具变量外生的原假设，存在内生的工具变量
ivreg2 lw s expr tenure rns smsa (iq= med kww mrt age),r orthog(mrt age) //根据C统计量检验mrt和age是否满足外生性
------------------------------------------------------------------------------
Hansen J statistic (overidentification test of all instruments):        51.545
                                                   Chi-sq(3) P-val =    0.0000
-orthog- option:
Hansen J statistic (eqn. excluding suspect orthog. conditions):          0.116
                                                   Chi-sq(1) P-val =    0.7333
C statistic (exogeneity/orthogonality of suspect instruments):          51.429
                                                   Chi-sq(2) P-val =    0.0000
Instruments tested:   mrt age
------------------------------------------------------------------------------
     //ivreg2 还会报告不可识别检验、弱工具变量检验、过度识别检验结果，具体参考上面工具变量检验结果表格
ivregress 2sls lw s expr tenure rns smsa (iq= med kww),r first //删除过度识别的变量再次回归，结果更加理想
estat overid //再次过度识别检验发现，接受med和kww都是外生的原假设
estat firststage,all forcenonrobust //检验是否存在弱工具变量，拒绝存在弱工具变量的原假设
ivregress liml lw s expr tenure rns smsa (iq= med kww),r //为零稳健起见，使用对弱工具不敏感的有限信息
     //极大似然法（LIML），结果与2SLS非常接近，进一步印证了不存在弱工具变量。
ivreg2 lw s expr tenure rns smsa (iq= med kww),r redundant(kww) //进一步检验kww是否冗余，
------------------------------------------------------------------------------
Underidentification test (Kleibergen-Paap rk LM statistic):             24.223
                                                   Chi-sq(2) P-val =    0.0000
-redundant- option:
IV redundancy test (LM test of redundancy of specified instruments):    22.222
                                                   Chi-sq(1) P-val =    0.0000
Instruments tested:   kww
------------------------------------------------------------------------------
Weak identification test (Cragg-Donald Wald F statistic):               14.906
                         (Kleibergen-Paap rk Wald F statistic):         13.403
Stock-Yogo weak ID test critical values: 10% maximal IV size             19.93
                                         15% maximal IV size             11.59
                                         20% maximal IV size              8.75
                                         25% maximal IV size              7.25
Source: Stock-Yogo (2005).  Reproduced by permission.
NB: Critical values are for Cragg-Donald F statistic and i.i.d. errors.
------------------------------------------------------------------------------
Hansen J statistic (overidentification test of all instruments):         0.151 //robust选项，非iid扰动项
                                                   Chi-sq(1) P-val =    0.6972 //过度识别检验提供Hansen J统计量
------------------------------------------------------------------------------

//如果认为不存在异方差和自相关，即扰动项为iid，去掉robus选项（不建议，仅演示）
ivreg2 lw s expr tenure rns smsa (iq= med kww) 
------------------------------------------------------------------------------
Sargan statistic (overidentification test of all instruments):           0.130 //iid扰动项下，提供的是Sargan统计量
                                                   Chi-sq(1) P-val =    0.7185 
------------------------------------------------------------------------------
*使用工具变量法的前提是存在内生解释变量，为此进行Hausman检验，原假设：所有解释变量均外生
qui reg lw iq s expr tenure rns smsa
est sto ols
qui ivregress 2sls lw s expr tenure rns smsa (iq= med kww)
est sto iv
hausman iv ols,constant sigmamore 							            //传统的Hausman检验
estat endogenous                  							            //异方差稳健的DWH检验
ivreg2 lw s expr tenure rns smsa (iq = med kww),r endog(iq) //ivreg2进行稳健的内生性检验
ivregress gmm lw s expr tenure rns smsa (iq= med kww)       //如果存在异方差，gmm比2sls更有效，结果发现二者很接近
estat overid                                                //过度识别检验，结果发现所有工具变量外生
ivregress gmm lw s expr tenure rns smsa (iq= med kww)，igmm //迭代gmm与上面的两步最优gmm相差无几

*将所有估计法的系数估计值及标准误等输出到同一张表格，可使用如下命令：
qui reg lw s expr tenure rns smsa,r
est sto ols_no_iq 
qui reg lw iq s expr tenure rns smsa,r
est sto ols_with_iq
qui ivregress 2sls lw s expr tenure rns smsa (iq= med kww),r
est sto tsls
qui ivregress liml lw s expr tenure rns smsa (iq= med kww),r
est sto liml
qui ivregress gmm lw s expr tenure rns smsa (iq= med kww)
est sto gmm
qui ivregress gmm lw s expr tenure rns smsa (iq= med kww),igmm
est sto igmm
reg2docx ols_no_iq ols_with_iq tsls liml gmm igmm using e:\temp\iv.docx,append /// append同一个word下追加结果，replace新建word替换
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("IV results") /// scalars表示输出ereturn list中的一些值 N r2_a r2_p,title表头，mtitles列标题
mtitles("OLS" "OLS IQ" "TSLS" "LIML" "GMM" "IGMM") note("(* 0.1 ** 0.05 *** 0.01)") //note表格备注内容

***对比扰动项是否为iid的情况下,ivreg2输出的工具变量检验统计量的差异:
*(1)选项中加入r,适用了稳健标准误,此时模型是非iid的:
ivreg2 lw s expr tenure rns smsa (iq = med kww),r  //默认2SLS方法,加入r选项时,假设扰动项非iid
ivreg2 lw s expr tenure rns smsa (iq = med kww),gmm2s r  //此时扰动项非iid,gmm比2sls结果有效,结果有差异;
//结果如下:
IV (2SLS) estimation
--------------------

Estimates efficient for homoskedasticity only
Statistics robust to heteroskedasticity

                                                      Number of obs =      758
                                                      F(  6,   751) =    61.10
                                                      Prob > F      =   0.0000
Total (centered) SS     =  139.2861498                Centered R2   =   0.2775
Total (uncentered) SS   =  24652.24662                Uncentered R2 =   0.9959
Residual SS             =  100.6291971                Root MSE      =    .3644

------------------------------------------------------------------------------
             |               Robust
          lw |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
          iq |   .0139284   .0060393     2.31   0.021     .0020916    .0257653
           s |   .0607803   .0189505     3.21   0.001      .023638    .0979227
        expr |   .0433237   .0074118     5.85   0.000     .0287968    .0578505
      tenure |   .0296442    .008317     3.56   0.000     .0133432    .0459452
         rns |  -.0435271   .0344779    -1.26   0.207    -.1111026    .0240483
        smsa |   .1272224   .0297414     4.28   0.000     .0689303    .1855146
       _cons |   3.218043   .3983683     8.08   0.000     2.437256    3.998831
------------------------------------------------------------------------------
Underidentification test (Kleibergen-Paap rk LM statistic):             24.223 //非iid
                                                   Chi-sq(2) P-val =    0.0000
------------------------------------------------------------------------------
Weak identification test (Cragg-Donald Wald F statistic):               14.906 //iid
                         (Kleibergen-Paap rk Wald F statistic):         13.403 //非iid
Stock-Yogo weak ID test critical values: 10% maximal IV size             19.93
                                         15% maximal IV size             11.59
                                         20% maximal IV size              8.75
                                         25% maximal IV size              7.25
Source: Stock-Yogo (2005).  Reproduced by permission.
NB: Critical values are for Cragg-Donald F statistic and i.i.d. errors.
------------------------------------------------------------------------------
Hansen J statistic (overidentification test of all instruments):         0.151 //非iid
                                                   Chi-sq(1) P-val =    0.6972
------------------------------------------------------------------------------
Instrumented:         iq
Included instruments: s expr tenure rns smsa
Excluded instruments: med kww
------------------------------------------------------------------------------

*(2)选项中无r,此时模型扰动项是iid的:
ivreg2 lw s expr tenure rns smsa (iq = med kww)
ivreg2 lw s expr tenure rns smsa (iq = med kww),gmm2s //此时扰动项是iid的情形下,gmm和2sls是等价的,结果一样;
//结果如下:
IV (2SLS) estimation
--------------------

Estimates efficient for homoskedasticity only
Statistics consistent for homoskedasticity only

                                                      Number of obs =      758
                                                      F(  6,   751) =    61.94
                                                      Prob > F      =   0.0000
Total (centered) SS     =  139.2861498                Centered R2   =   0.2775
Total (uncentered) SS   =  24652.24662                Uncentered R2 =   0.9959
Residual SS             =  100.6291971                Root MSE      =    .3644

------------------------------------------------------------------------------
          lw |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
          iq |   .0139284   .0058572     2.38   0.017     .0024485    .0254084
           s |   .0607803   .0186481     3.26   0.001     .0242306    .0973301
        expr |   .0433237   .0070053     6.18   0.000     .0295935    .0570539
      tenure |   .0296442   .0085218     3.48   0.001     .0129418    .0463466
         rns |  -.0435271   .0347602    -1.25   0.210    -.1116558    .0246016
        smsa |   .1272224   .0299973     4.24   0.000     .0684288    .1860161
       _cons |   3.218043   .3830327     8.40   0.000     2.467313    3.968774
------------------------------------------------------------------------------
Underidentification test (Anderson canon. corr. LM statistic):          28.978 //iid
                                                   Chi-sq(2) P-val =    0.0000
------------------------------------------------------------------------------
Weak identification test (Cragg-Donald Wald F statistic):               14.906 //iid
Stock-Yogo weak ID test critical values: 10% maximal IV size             19.93
                                         15% maximal IV size             11.59
                                         20% maximal IV size              8.75
                                         25% maximal IV size              7.25
Source: Stock-Yogo (2005).  Reproduced by permission.
------------------------------------------------------------------------------
Sargan statistic (overidentification test of all instruments):           0.130 //iid
                                                   Chi-sq(1) P-val =    0.7185
------------------------------------------------------------------------------
Instrumented:         iq
Included instruments: s expr tenure rns smsa
Excluded instruments: med kww
------------------------------------------------------------------------------


