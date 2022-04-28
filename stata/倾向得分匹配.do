          *========================================
          *      高级计量经济学及stata应用
          *========================================

      *       ===================================
      *             第十五讲  倾向匹配得分
		  *          PSM: Propensity Score Matching
		  *       ===================================

*================
*-> 1  PSM 简介   
*================	
  *-经济学中常希望评估某项目或政策实施后的效应，比如政府推出的就业培训项目
  *-(job training program)。此类研究称为“项目效应评估”(program evaluation)，
  *-而项目效应也称为“处理效应”(treatment effect)项目参与者的全体构成“实验组”
  *-或“处理组”(treatment group，或 the treated)，而未参与项目者则构成“控制组”
  *-(control group)或“对照组”考虑就业培训的处理效应评估。
  *-一个天真的做法是直接对比实验组与控制组的未来收入或就业状况。
  *-但参加就业培训者的未来收入比未参加者通常更低。难道就业培训反而有害？
  *-是否参加培训是参加者自我选择(self  selection)的结果，岗位好收入高的人群
  *-不需要参加培训，而参加者多为失业或低收入者。   
  *-读北大有助于提高收入吗？ 	    
  *-读文科有助于成功吗?  
  *-读大学究竟有什么用?  
  *-股权激励有效吗?  
  *-风险投资的市场激励对新能源企业创新有用吗？  
  *-政府RD补贴对企业RD投入有效吗？  

*--------------------
*-1.2 PSM 相关参考文献

*-详细介绍了PSM和-psmatch2-的应用
    shellout "F:\Books\statabook\PSM\Grilli_2011_ppt_PSM.pdf" //极力推荐,解释的很到位！
 
	
*========================
*-> 2  PSM 命令及分析过程   
*========================	
  
*--------------------
*-2.1 PSM 相关命令

    help psmatch2 
    help nnmatch  // Abadie et al., 2004
    help psmatch
    help pscore   // Becker and Ichino, 2002	
  	

*持续获取最新的 PSM 信息和程序
    
    findit propensity score
    findit matching
    
    *psmatch2 is being continuously improved and developed. Make sure to keep
    *your version up-to-date as follows

    ssc install psmatch2, replace

    *where you can check your version as follows:
    which psmatch2  
	 
*--------------------
*-2.2 PSM 相关命令


    help psmatch2

    psmatch2 depvar [indepvars] [if exp] [in range] [, outcome(varlist)
                     pscore(varname) neighbor(integer) radius caliper(real)
                     mahalanobis(varlist) ai(integer) population altvariance
                     kernel llr kerneltype(type) bwidth(real) spline
                     nknots(integer) common trim(real) noreplacement
                     descending odds index logit ties quietly w(matrix) ate]
 
    where indepvars and mahalanobis(varlist) may contain factor variables;
                     see fvvarlist.

    psmatch2 D x1 x2 x3, outcome(y)
                     pscore(varname) neighbor(integer) radius caliper(real)
                     mahalanobis(varlist) ai(integer) population altvariance
                     kernel llr kerneltype(type) bwidth(real) spline
                     nknots(integer) common trim(real) noreplacement
                     descending odds index logit ties quietly w(matrix) ate]				 
	*D 处理变量
	*[indepvars]     //协变量
	*x1 x2 x3        //协变量
	*outcome(y)		 // 结果变量
	*logit           //选择项logit来估计倾向得分，默认probit
	*ties            //选择项ties表示所有倾向得分相同的并列个体，默认按照数据排序选择其中一位个体
	*ate             //表示同时汇报ATE、ATU与ATT，默认仅汇报ATT
	*common          //表示仅对共同取值范围的个体进行匹配，默认对所有个人体进行匹配
	*pscore(varname) //表示用来指定某变量作为倾向得分，默认通过x1 x2 x3估计倾向得分
	*quietly         //表示不汇报倾向得分匹配的过程
	*neighbor(integer) 最近邻匹配 (k-Nearest neighbors matching)
	*radius (Radius matching)
	*caliper(real)	 //可以将不满足卡尺约束的处理组个体删除,因为无法从对照组匹配到合适的个体进行匹配,保留差距太大的个体反而无用;
	*核匹配 (Kernel matching)	  
    *其他匹配方法
	*广义精确匹配(Coarsened Exact Matching)  || help cem
    *局部线性回归匹配 (Local linear regression matching)
    *样条匹配 (Spline matching)
    *马氏匹配 (Mahalanobis matching)


********k近邻匹配******
    psmatch2 D x1 x2 x3, outcome(y) neighbor(k) noreplacement
	
*neighbor(k)表示进行k近邻匹配，k为整数，默认进行一对一匹配，noreplacement表示
*无放回匹配，默认有放回匹配，即一对一匹配

********半径匹配（卡尺匹配）******
    psmatch2 D x1 x2 x3, outcome(y)  radius caliper(real)
    //半径匹配（卡尺匹配）方法在匹配时,只对满足半径条件的处理组个体进行匹配,半径外的处理组个体则放弃不进行匹配;

********核匹配******		 
    
	*使用默认的核函数和带宽
    psmatch2 D x1 x2 x3, outcome(y)  kernel kerneltype(type)  bwidth(real) 

    *kernel 表示进行核匹配，kerneltype(type)表示用来指定核函数，默认二次核，bwidth(real) 
	*用来指定带宽，默认0.06
	 	
********局部线性回归匹配******		

*使用默认的核函数和带宽
    psmatch2  D x1 x2 x3, outcome(y) llr 

********pstset******	

    *估计后命令，用来检验数据是否平衡，以及画图显示倾向得分的共同取值范围
    pstest x1 x2 x3，both graph

	*检查变量 x1 x2 x3是否平衡了数据，both表示对匹配前后进行进行查看是否匹配，默认
    *只对匹配后的数据显示，graph还对各变量匹配前后的平衡情况进行说明

********psgraph******	
    psgraph

*画出直方图，显示倾向得分的共同取值范围
	
	
*=======================================
*->           3  PSM 应用举例:
*-> 参加培训是否有助于获得更高的工资吗？    
*=======================================

*--------------
*-3.1 变量介绍


Data used by Lalonde (1986)We are interested in the possible eﬀect of 
participation in a job training program on individuals earnings in 1978
This dataset has been used by many authors ( Abadie et al. 2004,
Becker and Ichino, 2002, Dehejia and Wahba, 1999).

    cd E:\data                               //设置工作路径，调用数据
    use "ldw_exper.dta", clear               //打开cd设置工作路径下面的数据


*-------------------
*-3.2 变量描述性分析                           

    label var t " 处理变量 是否参加培训 "
    label var age " 年龄 "
    label var educ " 受教育年限"
    label var black  " 是否黑人 "
    label var hisp  " 是否拉丁裔 "
    label var married  " 是否已婚 "
    label var nodegree " 文化水平"
    label var re74 " 1974年实际收入 "
    label var re75 " 1975年实际收入 "
    label var re78 " 结果变量 1978年实际收入 "
    label var u74  " 74年是否失业 "
    label var u75  " 1975年是否失业 "
    desc

*----------------
*-3.3 PSM操作过程 
    
    

********描述性分析********
    tabulate t, summarize(re78) means standard

********结果为********
participati |     Summary of real
  on in job |  earnings in 1978 (in
   training |  thousands of 1978 $)
    program |        Mean   Std. Dev.
------------+------------------------
          0 |   4.5548023   5.4838368
          1 |   6.3491454   7.8674047
------------+------------------------
      Total |   5.3007651   6.6314934

********回归分析******
    reg re78 t //,r
	
*结果为:
Linear regression                               Number of obs     =        445
                                                F(1, 443)         =       7.15
                                                Prob > F          =     0.0078
                                                R-squared         =     0.0178
                                                Root MSE          =     6.5795

------------------------------------------------------------------------------
             |               Robust
        re78 |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
           t |   1.794343   .6708247     2.67   0.008      .475949    3.112737
       _cons |   4.554802   .3402038    13.39   0.000     3.886188    5.223416
------------------------------------------------------------------------------

    *t值为1.794343 ，p为0.008 ，说明参加培训能使收入提高1794元，单位千美元，
    *1%显著，由于存在显著偏差，R2比较小，因此加入协变量，进行多元回归
	
********多元回归分析******
   
    reg re78 t age edu black hisp married re74 re75 u74 u75,r

Linear regression                               Number of obs     =        445
                                                F(10, 434)        =       2.53
                                                Prob > F          =     0.0057
                                                R-squared         =     0.0582
                                                Root MSE          =     6.5093

------------------------------------------------------------------------------
             |               Robust
        re78 |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
           t |   1.672042   .6617972     2.53   0.012     .3713161    2.972768
         age |   .0536677    .040388     1.33   0.185    -.0257127     .133048
        educ |   .4029471   .1610925     2.50   0.013     .0863287    .7195655
       black |  -2.039466   1.038581    -1.96   0.050    -4.080739    .0018068
        hisp |   .4246486   1.427471     0.30   0.766    -2.380968    3.230265
     married |  -.1466618   .8640396    -0.17   0.865    -1.844884    1.551561
        re74 |   .1235727    .127147     0.97   0.332    -.1263278    .3734731
        re75 |   .0194585     .14063     0.14   0.890    -.2569421    .2958591
         u74 |   1.380999   1.554643     0.89   0.375    -1.674566    4.436564
         u75 |  -1.071817   1.408301    -0.76   0.447    -3.839755    1.696121
       _cons |   .2214288   2.824293     0.08   0.938    -5.329565    5.772422
------------------------------------------------------------------------------

    *计量经济学服务中心psm.doc文档中显示t，平均处理效应为1.672，，变化不大，
    *并且在1%显著性水平下接近显著
	
    *协变量中只有educ（教育年限）、black（黑人）在5%水平下显著，其余变量均不显著

********倾向匹配得分******

*现在进行倾向匹配得分，先进行随机排序
    
	  set seed 10101
    gene ranorder=runiform()
    order ranorder

***一般步骤:
  *1假设符合无混淆性假定;
  *2用Logit模型估计倾向得分:
logit t age educ black hisp married re74 re75 u74 u75
  *3倾向得分等于logit模型的预测值:
predict pscore
  *4进行倾向得分匹配估计:
psmatch2 t,pscore(pscore) outcome(re78) common noreplacement
  //common只匹配处理组倾向得分在共同取值范围内的个体,倾向得分在共同取值范围外的个体则放弃,结果显示处理组有2个在范围外的个体,匹配时放弃它们;
  //noreplacement无放回;
  //默认1对1匹配;
  *5平衡性检验
pstest age educ black hisp married re74 re75 u74 u75,both

*下面进行一对一匹配，样本不大，进行有放回匹配，

    local v1 "t"
    local v2 "age educ black hisp married re74 re75 u74 u75"
    global x "`v1' `v2' "
	psmatch2 $x,out(re78) neighbor(1) ate ties logit common // 1:1 匹配

Logistic regression                             Number of obs     =        445
                                                LR chi2(9)        =      11.70
                                                Prob > chi2       =     0.2308
Log likelihood = -296.25026                     Pseudo R2         =     0.0194

------------------------------------------------------------------------------
           t |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
         age |   .0142619   .0142116     1.00   0.316    -.0135923    .0421162
        educ |   .0499776   .0564116     0.89   0.376     -.060587    .1605423
       black |   -.347664   .3606532    -0.96   0.335    -1.054531    .3592032
        hisp |   -.928485     .50661    -1.83   0.067    -1.921422    .0644523
     married |   .1760431   .2748817     0.64   0.522    -.3627151    .7148012
        re74 |  -.0339278   .0292559    -1.16   0.246    -.0912683    .0234127
        re75 |     .01221   .0471351     0.26   0.796    -.0801731    .1045932
         u74 |  -.1516037   .3716369    -0.41   0.683    -.8799987    .5767913
         u75 |  -.3719486    .317728    -1.17   0.242    -.9946841    .2507869
       _cons |  -.4736308   .8244205    -0.57   0.566    -2.089465    1.142204
------------------------------------------------------------------------------
There are observations with identical propensity score values.
The sort order of the data could affect your results.
Make sure that the sort order is random before calling psmatch2.
----------------------------------------------------------------------------------------
        Variable     Sample |    Treated     Controls   Difference         S.E.   T-stat
----------------------------+-----------------------------------------------------------
            re78  Unmatched | 6.34914538   4.55480228   1.79434311   .632853552     2.84
                        ATT | 6.40495818   4.99436488    1.4105933   .839875971     1.68
                        ATU | 4.52683013   6.15618973    1.6293596            .        .
                        ATE |                           1.53668776            .        .
----------------------------+-----------------------------------------------------------
Note: S.E. does not take into account that the propensity score is estimated.

 psmatch2: |   psmatch2: Common
 Treatment |        support
assignment | Off suppo  On suppor |     Total
-----------+----------------------+----------
 Untreated |        11        249 |       260 
   Treated |         2        183 |       185 
-----------+----------------------+----------
     Total |        13        432 |       445 	
	  
    *上表上部显示了logit回归结果，ATT估计值为 1.41059331 。对应t值为1.68.
    *小于1.96临界值，因此不显著
    
	  *上表下部显示了观测值是否在共同取值范围内，在总共445个观测值内，控制组
    *共有11个不在取值范围内，处理组共同2个不在取值范围内，其余432个均在取值范围内
	
********匹配效果是否较好的平衡了数据******	
*匹配效果是否较好的平衡了数据
	
*下面用pstest查看匹配效果是否较好的平衡了数据
	
    psmatch2 $x,out(re78) neighbor(1) ate ties logit common	
    pstest $v2,both graph

----------------------------------------------------------------------------------------
                Unmatched |       Mean               %reduct |     t-test    |  V(T)/
Variable          Matched | Treated Control    %bias  |bias| |    t    p>|t| |  V(C)
--------------------------+----------------------------------+---------------+----------
age                    U  | 25.816   25.054     10.7         |   1.12  0.265 |  1.03
                       M  | 25.781   25.383      5.6    47.7 |   0.52  0.604 |  0.91
                          |                                  |               |
educ                   U  | 10.346   10.088     14.1         |   1.50  0.135 |  1.55*
                       M  | 10.322   10.415     -5.1    63.9 |  -0.49  0.627 |  1.52*
                          |                                  |               |
black                  U  | .84324   .82692      4.4         |   0.45  0.649 |     .
                       M  | .85246   .86339     -2.9    33.0 |  -0.30  0.765 |     .
                          |                                  |               |
hisp                   U  | .05946   .10769    -17.5         |  -1.78  0.076 |     .
                       M  | .06011   .04372      5.9    66.0 |   0.71  0.481 |     .
                          |                                  |               |
married                U  | .18919   .15385      9.4         |   0.98  0.327 |     .
                       M  | .18579   .19126     -1.4    84.5 |  -0.13  0.894 |     .
                          |                                  |               |
re74                   U  | 2.0956    2.107     -0.2         |  -0.02  0.982 |  0.74*
                       M  | 2.0672   1.9222      2.7 -1166.6 |   0.27  0.784 |  0.88
                          |                                  |               |
re75                   U  | 1.5321   1.2669      8.4         |   0.87  0.382 |  1.08
                       M  | 1.5299   1.6446     -3.6    56.7 |  -0.32  0.748 |  0.82
                          |                                  |               |
u74                    U  | .70811      .75     -9.4         |  -0.98  0.326 |     .
                       M  | .71038   .75956    -11.1   -17.4 |  -1.06  0.288 |     .
                          |                                  |               |
u75                    U  |     .6   .68462    -17.7         |  -1.85  0.065 |     .
                       M  | .60656   .63388     -5.7    67.7 |  -0.54  0.591 |     .
                          |                                  |               |
----------------------------------------------------------------------------------------
* if variance ratio outside [0.75; 1.34] for U and [0.75; 1.34] for M

-----------------------------------------------------------------------------------
 Sample    | Ps R2   LR chi2   p>chi2   MeanBias   MedBias      B      R     %Var
-----------+-----------------------------------------------------------------------
 Unmatched | 0.019     11.75    0.227     10.2       9.4      33.1*   0.82     50
 Matched   | 0.008      3.87    0.920      4.9       5.1      20.6    1.09     25
-----------------------------------------------------------------------------------
* if B>25%, R outside [0.5; 2]	
	
    *匹配后，大部分变量的标准化偏差小于10%，只有变量u74的% bias为11.1%，基本
    *可以接受，大部分的t检验结果不拒绝处理组与对照组无系统性差异的原假设，
    *u75 and re75除外，表明匹配后[t-test]结果表明，Treat-Control组的差异不显著，
    *表明 balancing 假设得到满足;
    *另外，匹配前后，大多数变量的标准化偏差均减小，除了re74和u74，不但没有
    *减小反而增加了	
    *各变量标准化偏差VS共同取值范围
pstest $v2,both graph
psgraph
	
*=========================
*-> 4  PSM 应用其他匹配方法 
*==========================	
	
	
********K近邻匹配******	
    psmatch2  $x, out(re78) n(4)  ate   ties logit common  quietly 

There are observations with identical propensity score values.
The sort order of the data could affect your results.
Make sure that the sort order is random before calling psmatch2.
----------------------------------------------------------------------------------------
        Variable     Sample |    Treated     Controls   Difference         S.E.   T-stat
----------------------------+-----------------------------------------------------------
            re78  Unmatched | 6.34914538   4.55480228   1.79434311   .632853552     2.84
                        ATT | 6.40495818   4.37141145   2.03354673   .727464025     2.80
                        ATU | 4.52683013   5.97560717   1.44877703            .        .
                        ATE |                           1.69649197            .        .
----------------------------+-----------------------------------------------------------
Note: S.E. does not take into account that the propensity score is estimated.

 psmatch2: |   psmatch2: Common
 Treatment |        support
assignment | Off suppo  On suppor |     Total
-----------+----------------------+----------
 Untreated |        11        249 |       260 
   Treated |         2        183 |       185 
-----------+----------------------+----------
     Total |        13        432 |       445 


	 
********半径匹配******		
    psmatch2  $x, out(re78) radius cal(0.01)  ate   ties logit common  quietly 
----------------------------------------------------------------------------------------
        Variable     Sample |    Treated     Controls   Difference         S.E.   T-stat
----------------------------+-----------------------------------------------------------
            re78  Unmatched | 6.34914538   4.55480228   1.79434311   .632853552     2.84
                        ATT | 6.40495818   4.54598746   1.85897071   .704721737     2.64
                        ATU | 4.51395698   6.14730708   1.63335009            .        .
                        ATE |                           1.73004464            .        .
----------------------------+-----------------------------------------------------------
Note: S.E. does not take into account that the propensity score is estimated.

 psmatch2: |   psmatch2: Common
 Treatment |        support
assignment | Off suppo  On suppor |     Total
-----------+----------------------+----------
 Untreated |        16        244 |       260 
   Treated |         2        183 |       185 
-----------+----------------------+----------
     Total |        18        427 |       445 

	 
********核匹配******
		 
*使用默认的核函数和带宽

    psmatch2  $x, out(re78)  kernel  ate   ties logit common  quietly 
----------------------------------------------------------------------------------------
        Variable     Sample |    Treated     Controls   Difference         S.E.   T-stat
----------------------------+-----------------------------------------------------------
            re78  Unmatched | 6.34914538   4.55480228   1.79434311   .632853552     2.84
                        ATT | 6.40495818   4.58467178   1.82028639   .685942087     2.65
                        ATU | 4.52683013   6.13018214     1.603352            .        .
                        ATE |                           1.69524782            .        .
----------------------------+-----------------------------------------------------------
Note: S.E. does not take into account that the propensity score is estimated.

 psmatch2: |   psmatch2: Common
 Treatment |        support
assignment | Off suppo  On suppor |     Total
-----------+----------------------+----------
 Untreated |        11        249 |       260 
   Treated |         2        183 |       185 
-----------+----------------------+----------
     Total |        13        432 |       445 


 	
********局部线性回归匹配******		

*使用默认的核函数和带宽
    psmatch2  $x, out(re78)  llr  ate   ties logit common  quietly 

    There are observations with identical propensity score values.
    The sort order of the data could affect your results.
    Make sure that the sort order is random before calling psmatch2.
----------------------------------------------------------------------------------------
        Variable     Sample |    Treated     Controls   Difference         S.E.   T-stat
----------------------------+-----------------------------------------------------------
            re78  Unmatched | 6.34914538   4.55480228   1.79434311   .632853552     2.84
                        ATT | 6.40495818   4.71399307   1.69096511   .839875971     2.01
                        ATU | 4.52683013   6.20121299   1.67438286            .        .
                        ATE |                           1.68140728            .        .
----------------------------+-----------------------------------------------------------
Note: S.E. does not take into account that the propensity score is estimated.

 psmatch2: |   psmatch2: Common
 Treatment |        support
assignment | Off suppo  On suppor |     Total
-----------+----------------------+----------
 Untreated |        11        249 |       260 
   Treated |         2        183 |       185 
-----------+----------------------+----------
     Total |        13        432 |       445 

	上表没有汇报ATT的标准误，现在使用自助法得到自助标准误，比较耗费时间
	 
    set seed 10101
    bootstrap r(att) r(atu) r(ate) ,reps(500):psmatch2  $x,   //
    out(re78) llr  ate   ties logit common  quietly 
	 
    bootstrap r(att) r(atu) r(ate) ,reps(500): psmatch2 $x, out(re78) llr  ate   ties logit common  quietly 
    (running psmatch2 on estimation sample)

Bootstrap replications (500)
----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5 
..................................................    50
..................................................   100
..................................................   150
..................................................   200
..................................................   250
..................................................   300
..................................................   350
..................................................   400
..................................................   450
..................................................   500

Bootstrap results                               Number of obs     =        445
                                                Replications      =        500

      command:  psmatch2 t age edu black hisp married re74 re75 u74 u75, out(re78) llr ate ties logit
                    common quietly
        _bs_1:  r(att)
        _bs_2:  r(atu)
        _bs_3:  r(ate)

------------------------------------------------------------------------------
             |   Observed   Bootstrap                         Normal-based
             |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
       _bs_1 |   1.690965    .711263     2.38   0.017     .2969153    3.085015
       _bs_2 |   1.674383   .7000881     2.39   0.017     .3022353     3.04653
       _bs_3 |   1.681407   .6733855     2.50   0.013     .3615959    3.001219
------------------------------------------------------------------------------

*=======================================
*->           6  PSM 应用举例:
*->     新能源企业创新的市场化激励
*-> ——基于风险投资和企业专利数据的研究    
*=======================================

********中国工业经济2017年12月******
//打开文章:
    shellout "E:\stata\ref\psm新能源企业创新的市场化激励——基于风险投资和企业专利数据的研究.pdf"
    
    cd "E:\stata\data" 
    use psm2新能源.dta,clear
    duplicates report code year
    duplicates drop code year, force
    xtset code year

    cd E:\stata\results                  //设置工作路径，保存输出结果
//描述性统计
    ttest lnpat,by(da)
    ttest lnvc,by(da)
    sum2docx lnpat-lnl using sumresults.docx, ///
    replace stats(N mean(%9.2f) sd skewness kurtosis min(%9.2f) median max(%9.2f)) ///
    title("Summary Statistics")

//回归模型

    global  sun "lnvc"
    global  shine "lnrd lnl lnta roa lnsub lev age gov"
    xtreg lnpat  $sun $shine,fe
    estimates store fe
    xtreg lnpat  $sun $shine,re
    estimates store re
    hausman fe re,constant sigmamore
    ereturn list
    esttab fe re using hauseman.rtf, ///
    mtitles("model 1" "model 2"  ) ///
    title("This is the regression table") ///
    append star( * 0.10 ** 0.05 *** 0.01 ) staraux r2 nogaps 	

    xtreg lnpat lnvc l.lnvc  $shine,fe
    estimates store fe
    xtreg lnpat lnvc l.lnvc  $shine,re
    estimates store re
    hausman fe re,constant sigmamore

    xtreg lnpat lnvc l.lnvc l2.lnvc lnrd lnl lnta roa lnsub lev age gov,fe
    estimates store fe
    xtreg lnpat lnvc l.lnvc l2.lnvc lnrd lnl lnta roa lnsub lev age gov,re
    estimates store re
    hausman fe re,constant sigmamore

//PSM
//最邻近匹配
    psmatch2 da $shine i.year, out(lnpat) logit n(4) ate com

//卡尺匹配
    psmatch2 da $shine i.year, out(lnpat) logit radius cal(0.05) ate com

//核匹配
    psmatch2 da $shine i.year, out(lnpat) logit kernel ate com

//变量平衡表
    pstest $shine bus1 bus2 bus3 bus4 bus5 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 i.year

*****文章的完整程序:
cd "F:\DownLoad\中国工业经济\新能源企业创新的市场化激励"
save 新能源企业创新的市场化激励.dta,replace


use 新能源企业创新的市场化激励.dta,clear

//设置面板(以下使用总样本数据）
duplicates report code year
duplicates drop code year, force
xtset code year

//描述性统计
ttest lnpat,by(da)
ttest lnvc,by(da)
ttest lnmon,by(da)
ttest lnrd,by(da)
ttest lnl,by(da)
ttest lnta,by(da)
ttest roa,by(da)
ttest lnsub,by(da)
ttest lev,by(da)
ttest age,by(da)
ttest gov,by(da)


//1.净效应模型
xtreg lnpat lnvc lnrd lnl lnta roa lnsub lev age gov,fe
estimates store fe
xtreg lnpat lnvc lnrd lnl lnta roa lnsub lev age gov,re
estimates store re
hausman fe re,constant sigmamore

xtreg lnpat lnvc l.lnvc lnrd lnl lnta roa lnsub lev age gov,fe
estimates store fe
xtreg lnpat lnvc l.lnvc lnrd lnl lnta roa lnsub lev age gov,re
estimates store re
hausman fe re,constant sigmamore

xtreg lnpat lnvc l.lnvc l2.lnvc lnrd lnl lnta roa lnsub lev age gov,fe
estimates store fe
xtreg lnpat lnvc l.lnvc l2.lnvc lnrd lnl lnta roa lnsub lev age gov,re
estimates store re
hausman fe re,constant sigmamore

xtreg lnpat lnvc l.lnvc lnrd lnl lnta roa lnsub lev age gov i.year,fe
estimates store fe
xtreg lnpat lnvc l.lnvc lnrd lnl lnta roa lnsub lev age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

//PSM
//最邻近匹配
psmatch2 da lnrd lnl lnta roa lnsub lev age gov i.year, out(lnpat) logit n(4) ate com

//卡尺匹配
psmatch2 da lnrd lnl lnta roa lnsub lev age gov i.year, out(lnpat) logit radius cal(0.05) ate com

//核匹配
psmatch2 da lnrd lnl lnta roa lnsub lev age gov i.year, out(lnpat) logit kernel ate com

//变量平衡表
pstest lnrd lnl lnta roa lnsub lev age gov,both

//2.中介效应模型
//2.1 资金增加效应
xtreg lnpat l.lnvc lnsub age gov i.year,fe    //lnpat~lnvc
estimates store fe
xtreg lnpat l.lnvc lnsub age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

xtreg l.lnmon l.lnvc lnsub age gov i.year,fe //lnmon~lnvc
estimates store fe
xtreg l.lnmon l.lnvc lnsub age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

xtreg lnpat l.lnvc l.lnmon lnsub age gov i.year,fe //lnpat~lnvc + lnmon
estimates store fe
xtreg lnpat l.lnvc l.lnmon lnsub age gov i.year,re
estimates store re
hausman fe re,constant sigmamore
  //hausman检验均含有个体固定效应,使用个体固定效应模型进行回归:
xtreg lnpat l.lnvc lnsub age gov i.year,fe
estimates store y_x
xtreg l.lnmon l.lnvc lnsub age gov i.year,fe
estimates store z_x
xtreg lnpat l.lnvc l.lnmon lnsub age gov i.year,fe  
estimates store y_xz
reg2docx y_x z_x y_xz using regresult.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("中介效应模型") /// 
mtitles("lnpat" "lnmon" "lnpat") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("year=*year")

//2.2 创新倾向提高效应
//R&D资本
xtreg lnpat l.lnvc lnsub age gov i.year,fe
estimates store fe
xtreg lnpat l.lnvc lnsub age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

xtreg lnrd l.lnvc lnsub age gov i.year,fe
estimates store fe
xtreg lnpat l.lnvc lnsub age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

xtreg lnpat l.lnvc lnrd lnsub age gov i.year,fe
estimates store fe
xtreg lnpat l.lnvc lnrd lnsub age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

//R&D劳动力
xtreg lnpat l.lnvc lnsub age gov i.year,fe
estimates store fe
xtreg lnpat l.lnvc lnsub age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

xtreg lnl l.lnvc lnsub age gov i.year,fe
estimates store fe
xtreg lnl l.lnvc lnsub age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

xtreg lnpat l.lnvc lnl lnsub age gov i.year,fe
estimates store fe
xtreg lnpat l.lnvc lnl lnsub age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

//2.3 学习曲线效应
//企业规模
xtreg lnpat l.lnvc lnsub age gov i.year,fe
estimates store fe
xtreg lnta l.lnvc lnsub age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

xtreg lnta l.lnvc lnsub age gov i.year,fe
estimates store fe
xtreg lnta l.lnvc lnsub age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

xtreg lnpat l.lnvc lnta lnsub age gov i.year,fe
estimates store fe
xtreg lnpat l.lnvc lnta lnsub age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

//盈利能力
xtreg lnpat l.lnvc lnsub age gov i.year,fe
estimates store fe
xtreg lnpat l.lnvc lnsub age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

xtreg roa l.lnvc lnsub age gov i.year,fe
estimates store fe
xtreg roa l.lnvc lnsub age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

xtreg lnpat lnvc roa lnsub age gov i.year,fe
estimates store fe
xtreg lnpat lnvc roa lnsub age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

//3.异质性模型
gen lnrlnvc = lnrd*l.lnvc //交互项
gen lnllnvc = lnl*l.lnvc
gen sizlnvc = lnta*l.lnvc
gen levlnvc = lev*l.lnvc

xtreg lnpat lnvc l.lnvc lnrlnvc lnrd lnl lnta roa lnsub lev age gov i.year,fe
estimates store fe
xtreg lnpat lnvc l.lnvc lnrlnvc lnrd lnl lnta roa lnsub lev age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

xtreg lnpat lnvc l.lnvc lnllnvc lnrd lnl lnta roa lnsub lev age gov i.year,fe
estimates store fe
xtreg lnpat lnvc l.lnvc lnllnvc lnrd lnl lnta roa lnsub lev age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

xtreg lnpat lnvc l.lnvc sizlnvc lnrd lnl lnta roa lnsub lev age gov i.year,fe
estimates store fe
xtreg lnpat lnvc l.lnvc sizlnvc lnrd lnl lnta roa lnsub lev age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

xtreg lnpat lnvc l.lnvc levlnvc lnrd lnl lnta roa lnsub lev age gov i.year,fe
estimates store fe
xtreg lnpat lnvc l.lnvc levlnvc lnrd lnl lnta roa lnsub lev age gov i.year,re
estimates store re
hausman fe re,constant sigmamore

//PSM（以下使用子样本数据）
//设置面板
duplicates report code year
duplicates drop code year, force
xtset code year

//最邻近匹配
psmatch2 da lnrd lnl lnta roa lnsub lev age gov i.year, out(lnpat) logit n(4) ate com

//卡尺匹配
psmatch2 da lnrd lnl lnta roa lnsub lev age gov i.year, out(lnpat) logit radius cal(0.05) ate com

//核匹配
psmatch2 da lnrd lnl lnta roa lnsub lev age gov i.year, out(lnpat) logit kernel ate com


