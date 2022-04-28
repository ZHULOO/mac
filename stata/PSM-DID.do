*****PSM-DID*****
***DID的stata操作
*手动计算：
cd e:\data
use cardkrueger1994,clear
gen gd = t*treated 
reg fte gd treated t,r
reg fte gd treated t bk kfc roys,r
*diff命令：
diff fte,t(treated) p(t) robust
diff fte,t(treated) p(t) cov(bk kfc roys) robust
diff fte,t(treated) p(t) cov(bk kfc roys) robust test

***双重差分倾向得分匹配
cd e:\data
use cardkrueger1994,clear
diff fte,t(treated) p(t) kernel id(id) logit cov(bk kfc roys) report support
//结果如下：
//倾向得分的计算：
Logistic regression                               Number of obs   =        404
                                                  LR chi2(3)      =       2.91
                                                  Prob > chi2     =     0.4053
Log likelihood =  -196.7636                       Pseudo R2       =     0.0073

------------------------------------------------------------------------------
     treated |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
          bk |   .3108387   .3561643     0.87   0.383    -.3872306    1.008908
         kfc |   .6814511   .4335455     1.57   0.116    -.1682824    1.531185
        roys |    .520356   .4011747     1.30   0.195     -.265932    1.306644
       _cons |    1.05315   .2998708     3.51   0.000      .465414    1.640886
------------------------------------------------------------------------------
//倾向得分匹配后双重差分：
Number of observations in the DIFF-IN-DIFF: 795
            Before         After    
   Control: 78             76          154
   Treated: 326            315         641
            404            391
--------------------------------------------------------
 Outcome var.   | fte     | S. Err. |   |t|   |  P>|t|
----------------+---------+---------+---------+---------
Before          |         |         |         | 
   Control      | 20.040  |         |         | 
   Treated      | 17.065  |         |         | 
   Diff (T-C)   | -2.975  | 0.943   | -3.16   | 0.002***
After           |         |         |         | 
   Control      | 17.449  |         |         | 
   Treated      | 17.499  |         |         | 
   Diff (T-C)   | 0.050   | 0.955   | 0.05    | 0.958
                |         |         |         | 
Diff-in-Diff    | 3.026   | 1.342   | 2.25    | 0.024**
--------------------------------------------------------
