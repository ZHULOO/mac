******************************************* 
*      手动估计动态面板Probit模型 
* By-hand replication of model estimation            
*******************************************

*-Step1：手动计算相关初始值、个体均值

  *-数据概况
    cd "e:/data"
    use poverty.dta,clear
    xtset id year
    xtdes
    br
  *-去掉缺失值
    gen sample = !mi(id, year, poor, black, age, edu, emp, marstat) //这些变量非缺失的sample=1
  *-计算具有动态变化特征变量的初始值
    local i "poor age emp marstat"
    foreach var of varlist `i' {
    bys sample id (year): gen `var'__0 = `var'[1] /// 循环生成新变量等于每个变量的初始值;
    if sample & sample[1]==1	
  	}
  *-计算具有动态变化特征变量的个体均值
    bys sample id : egen m__age = mean(age)
    bys sample id : egen m1__emp = mean(emp==1)
    bys sample id : egen m2__emp = mean(emp==2)
    bys sample id : egen m1__marstat = mean(marstat==1)
    bys sample id : egen m2__marstat = mean(marstat==2)

*-Step2：估计模型 -xtprobit- -meprobit-
	
  *-用 xtprobit 估计动态数据模型
    xtset id year
    xtprobit poor iL.poor black c.age i.edu i.emp i.marstat ///
  		i.poor__0 age__0 i.emp__0 i.marstat__0 ///
  		m__age m1__emp m2__emp m1__marstat m2__marstat
    est store xtp
  	
  *-用 meprobit 估计动态数据模型 
    meprobit poor iL.poor black c.age i.edu i.emp i.marstat ///
  		i.poor__0 age__0 i.emp__0 i.marstat__0 ///
  		m__age m1__emp m2__emp m1__marstat m2__marstat || ///
		id : , intpoints(12)
    est store mep

******************************************* 
*新方法:外部命令xtpdyn估计动态面板Probit模型             
*******************************************

net get xtpdyn.pkg   // 下载数据
use "poverty.dta", clear 
xtset id year
xtpdyn poor black c.age i.edu i.emp i.marstat, ///
            uh(i.emp i.marstat age) re(vce(robust))

Iteration 0:   log pseudolikelihood = -2101.8697  (not concave)
…… (output omitted) ……
Iteration 7:   log pseudolikelihood =  -1963.425  

Mixed-effects probit regression                 Number of obs     =      6,173
Group variable:              id                 Number of groups  =      1,112

                                                Obs per group:
                                                              min =          3
                                                              avg =        5.6
                                                              max =          9

Integration method: mvaghermite                 Integration pts.  =         12

                                                Wald chi2(20)     =    1154.68
Log pseudolikelihood =  -1963.425               Prob > chi2       =     0.0000
                                   (Std. Err. adjusted for 1,112 clusters in id)
--------------------------------------------------------------------------------
               |               Robust
          poor |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
---------------+----------------------------------------------------------------
               |
        L.poor |
         Poor  |   .5744007   .0813891     7.06   0.000      .414881    .7339205
               |
         black |   .5225842   .0688626     7.59   0.000     .3876159    .6575525
           age |  -.0649581   .0129398    -5.02   0.000    -.0903197   -.0395966
               |
           edu |
  High School  |  -.2264437   .0768907    -2.95   0.003    -.3771466   -.0757407
 More than HS  |  -.5724683   .0960026    -5.96   0.000    -.7606299   -.3843067
               |
           emp |
    Part-time  |  -.4357227   .1355535    -3.21   0.001    -.7014027   -.1700426
    Full-time  |   -1.23497   .1408088    -8.77   0.000     -1.51095   -.9589893
               |
       marstat |
       Single  |  -.6937395   .2385683    -2.91   0.004    -1.161325   -.2261542
  Div/sep/wid  |  -.5112024   .1342855    -3.81   0.000    -.7743972   -.2480076
               |
     1.poor__0 |    .923642    .095303     9.69   0.000     .7368516    1.110432
               |
        emp__0 |
            1  |   -.148413   .1406438    -1.06   0.291    -.4240698    .1272438
            2  |  -.1200204   .1545567    -0.78   0.437    -.4229458    .1829051
               |
    marstat__0 |
            1  |  -.3251233   .1983599    -1.64   0.101    -.7139016     .063655
            2  |  -.2616084   .1915875    -1.37   0.172     -.637113    .1138962
               |
        age__0 |  -.0311116   .0313137    -0.99   0.320    -.0924852    .0302621
       m1__emp |   .2515403   .2492729     1.01   0.313    -.2370256    .7401062
       m2__emp |  -.1801458    .261989    -0.69   0.492    -.6936349    .3333432
   m1__marstat |     1.0849   .3453074     3.14   0.002     .4081096     1.76169
   m2__marstat |   1.051389   .2589864     4.06   0.000     .5437854    1.558993
        m__age |    .081758   .0334461     2.44   0.015     .0162049     .147311
         _cons |  -.1005763    .244535    -0.41   0.681    -.5798561    .3787036
---------------+----------------------------------------------------------------
id             |
     var(_cons)|   .3355826   .0634519                      .2316618     .486121
--------------------------------------------------------------------------------
// Setup
use poverty,clear
xtset id year

// Dynaminc random-effects probit model with unobserved heterogeneity
xtpdyn poor black c.age i.edu i.emp i.marstat, uh(i.emp i.marstat age)
probat,stats(edu = 1)

// Dynaminc random-effects probit model with unobserved heterogeneity and robust variance
xtpdyn poor black c.age i.edu i.emp i.marstat, uh(i.emp i.marstat age) re(vce(robust))

// Generate variables contributing to unobserved heterogeneity
xtpdyn, keep
