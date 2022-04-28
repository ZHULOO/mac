

	 
          *========================================
          *      高级计量经济学及stata应用
          *========================================

		  
		  
		  *        计量经济学服务中心
		  *              2017年8月
		  
		 
		  
		  
          *       ==========================
          *          第十六讲  门限回归
		  *       ==========================


 
  
 
*--------------------
*->  门槛模型
*--------------------


*------------
*----1、简介
*------------

1、简介 ******
	
  
    ********主要命令******

    *- Panel Threshold Model: xtthres，连玉君老师编写
    *- - FE (Fixed Effect Model): xtreg, fe 、xtptm
    *-stata15.0 进行门限回归新命令threshold    
  
    ********参考文献******
    shellout "E:\stata\personal18\ref\Hansen_1999.pdf"
    shellout "E:\stata\personal18\ref\Wang2015_xthreg"

 
*------------------
*----2、门槛模型
*------------------

 
*************2、面板门槛模型 ******
  
  
    shellout "E:\stata\personal18\ref\Hansen_1999.pdf"
  
    *          { u[i] + b1*X[it] + e[it]  if q[it]<=gamma
	*  y[it] = {                                              (1)
	*          { u[i] + b2*X[it] + e[it]  if q[it]> gamma
	*
	*- y[it] -- 被解释变量
	*- X[it] -- 解释变量
	*- q[it] -- 门槛变量
	
	

*---------------------------------------
*----3、王群勇老师论文中的的结果  xthreg
*---------------------------------------



*************stata code*****
  
*-------------------------------
*-           估计 
*---------- begin -------------
   
   
   cap log close
   E:\stata\results
   log using 计量经济学服务中心2018年上海stata研讨班hansen1999-xthreg, text replace

   xthreg需要stata13及以上版本

   语法格式为：
   xthreg depvar [indepvars] [if] [in], rx(varlist) qx(varname) 
   [thnum(#) grid(#) trim(numlist) bs(numlist) thlevel(#) gen(newvarname)
   noreg nobslog thgiven options] 

 
   depvar被解释变量，indepvars 解释变量，qx(varname) is the threshold variable，
   门限变量，thnum(#) is the number of thresholds，
   在stata13.0中门槛值是必要项目，需要等于大于1，小于等于3，默认值为1，
   也就是至少存在三个门槛值。
   grid(#) ：网格点数，默认为grid(300)。
   trim(numlist) ：估计每个门限值时的修整比例，修整比例的个数
                必须与th中num(#)中的#相等，默认trim(0.01)。

   bs(numlist) ：bootstrap迭代次数。若不设置bs()，xthreg将不会使用bootstrap进行门限效应检验。
   thlevel(#) ：置信区间，默认为95%，即thlevel(95)。
   gen(newvarname) ：对每个制度生成0,1,2,...的新分类变量。默认为gen(_cat)
   noreg ：不显示回归结果。
   nobslog ：不显示bootstrap迭代过程。
   thgiven ：基于以前的结果拟合模型。
   options ：xtreg中的选项。

   
   门槛回归的案例  
   
   clear all
   set memory  200m      // 设定分配给 Stata 的内存空间
   
   
   cd E:\stata\results                    //设置工作路径，保存输出结果
   use E:\stata\data\hansen1999, clear   // 调入 Hansen99 数据
	

   Estimate a single-threshold model 
   xthreg i q1 q2 q3 d1 qd1, rx(c1) qx(d1) thnum(1) trim(0.01) grid(400) bs(300)

	
	
   Estimate a triple-threshold model given the estimated result above
   xthreg i q1 q2 q3 d1 qd1, rx(c1) qx(d1) thnum(3) trim(0.01 0.01 0.05) grid(400) bs(300 300 300)

   绘图：
   Plot the confidence interval using likelihood-ratio (LR) statistics
   _matplot e(LR21), columns(1 2) yline(7.35, lpattern(dash)) connect(direct) msize(small) mlabp(0) mlabs(zero) ytitle("LR Statistics") xtitle("First Threshold") recast(line) name(LR21) nodraw
   _matplot e(LR22), columns(1 2) yline(7.35, lpattern(dash)) connect(direct) msize(small) mlabp(0) mlabs(zero) ytitle("LR Statistics") xtitle("Second Threshold") recast(line) name(LR22) nodraw
   graph combine LR21 LR22, cols(1)

   输出结果包括四个部分。第一部分输出门限估计值和自举法的结果。
   第二部分列表输出门限值及置信区间，Th-1代表单一门限估计值，

   Th-21 和Th-22代表双门限回归的两个估计值，有时Th-21和Th-1相同。
   第三部分列出了门限检验，包括RSS、MSE、F统计量及概率值，以及
   10%、5%、1%的置信水平。第四部分是固定效应回归结果。
   
   log close
  
*--------------------------------- over --------------
  
   shellout 计量经济学服务中心2018年上海stata研讨班hansen1999-xthreg.log  // 查看日志文件
	
  
*---------------------------------------
*----4、Hansen 论文中的结果  xtthres
*---------------------------------------

 
 
*************stata code*****

    shellout "E:\stata\personal18\ref\Hansen_1999.pdf"  
  
    cap log close
    log using E:\stata\results\计量经济学服务中心2018年上海stata研讨班xtthres_Hansen99.log, text replace
    clear all
    set memory  200m      // 设定分配给 Stata 的内存空间
    cd E:\stata\results                    //设置工作路径，保存输出结果
    use E:\stata\personal18\data\hansen1999, clear   // 调入 Hansen99 数据
    
	set seed 20180113    
    gen mu = uniform()
    sort mu
    keep if mu<0.6 // 随机抽取一些样本	 
	   
    
	
	*-Table 1: Summary statistics
    tabstat i q1 c1 d1, s(min p25 p50 p75 max) ///
	                       format(%6.3f) c(s)
	   
    *-Estimating
    
	xtthres i q1 q2 q3 d1 qd1, th(d1) d(c1)  ///
        min(120) bs1(300) bs2(300) bs3(200)
		
		
	xtthres i q1 q2 q3 d1 qd1, th(d1) d(c1)  ///
               min(120) bs1(3) bs2(3) bs3(2)
			   
			   
    *-Graphing
       xttr_graph
	   graph export E:\stata\results\\Hansen_Fig01.wmf, replace 
       xttr_graph, m(22)
	   graph export E:\stata\results\\Hansen_Fig02.wmf, replace	  
       xttr_graph, m(21)
	   graph export E:\stata\results\\Hansen_Fig03.wmf, replace	
	   log close  
	   shellout E:\stata\results\计量经济学服务中心2018年上海stata研讨班xtthres_Hansen99.log.log  // 查看日志文件

   *--------------------------------- over --------------
 
 


*---------------------------------------
*----5、stata15.0  门限新命令threshold
*---------------------------------------


  
*************threshold***** 


   //在Stata 15中，进行门槛回归的命令为

   threshold y x1 x2, threshvar(q) regionvars(x3 x4) nthresholds(#) optthreh(#)

   //其中，y 为被解释变量，x1 与 x2 为回归系数不随区制（regime）而变的解释变量
   （也可以不设）。必选项 threshvar(q) 表示变量 q 为门槛变量，
   选择项 regionvars(x3 x4) 表示，x3 与 x4 为回归系数随区制
   （regime）而变的解释变量。此处的 region，其实就是文献中的 regime（区制）。

   这个命令默认只有一个门槛值。也可以通过选择项 nthresholds(#) 
   来指定多个门槛值，比如 nthresholds(2) 表示有 2 个门槛值，即将世界分为 3 个区制。

   更一般地，也可以通过选择项 optthreh(#) 来计算最优的门槛个数
   （默认使用BIC信息准则进行选择）；比如，optthreh(5)，表示最多允许有5个门槛值。
  
  
  *---------------------------------threshold code-------------
   
   cap log close
   cd E:\stata\results                  //设置工作路径，保存输出结果

   log using 计量经济学服务中心stata15.0门限新命令2.log 
    	
	help threshold
    threshold depvar [indepvars] [if] [in], threshvar(varname) [options]
	 
    下面以美联储如何制定联邦基金利率的季度数据集为例
    use http://www.stata-press.com/data/r15/usmacro
    webuse usmacro
    先看一下联邦基金利率的时间趋势图。

    tsline fedfunds
    save "E:\stata\personal18\高级计量经济学\A12-hansen\usmacro.dta"
    file E:\stata\personal18\高级计量经济学\A12-hansen\usmacro.dta saved

    threshold fedfunds, regionvars(l.fedfunds inflation ogap) threshvar(l.fedfunds)

    此命令表示，门槛回归的被解释变量为 fedfunds（联邦基金利率），
    门槛变量为 l.fedfunds（联邦基金利率的滞后），而 l.fedfunds，
    inflation（通胀率）与 ogap（产出缺口）为回归系数随区制而变的解释变量。

    上表显示，联邦基金利率滞后的门槛估计值为 9.35%，其对应的残差平方和（SSR）为 
    155.43。遗憾的是，此命令没有汇报门槛值的置信区间。

    回归结果中的 Region1 与 Region2，在文献中通常称为 Regime 1 
    与 Regime 2。结果显示，当联邦基金利率滞后（l.fedfunds）小于或等于
    9.35%，即处于 Region1 时，联邦基金利率高度依赖于其滞后（自回归系数为 
    0.93，且在 1% 水平上显著），而对于通胀水平（inflation）不敏感
    （p 值为 0.133），但产出缺口（ogap）的作用显著为正。

    另一方面，当联邦基金利率滞后（l.fedfunds）大于 9.35%，
    即处于 Region2 时，联邦基金利率对于其滞后的依赖性减弱
    （自回归系数降为 0.70，仍在 1% 水平上显著），而对于通胀水平
    （inflation）变得敏感（p 值为0.002），但产出缺口（ogap）的作用则变得不显著。

    Fit a threshold regression model that estimates one threshold for l2.ogap and coefficients that vary across the two regions
    threshold fedfunds, regionvars(l.fedfunds inflation ogap) threshvar(l2.ogap)

    Same as above, but select the optimal number of thresholds from a maximum of five
    threshold fedfunds, regionvars(l.fedfunds inflation ogap) threshvar(l2.ogap) optthresh(5)

    log close
    shellout  计量经济学服务中心stata15.0门限新命令2.log
	
	
	
	
