
*****受限因变量*****随机试验*****处理效应*****

*****一,受限因变量模型:

***断尾回归:
	//因变量只有满足y>=c(常数)的数据被观测到,由于没有y<c的数据而造成左边断尾;
	//左边段位,OLS估计是不一致的,使用MLE能得到一致估计:
cd "E:\data"
cd "/Users/zhulu/Files/data"
use laborsub.dta,clear
tabulate lfp //lfp频数统计表:
1 if woman |
  worked in |
       1975 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        100       40.00       40.00 //lfp=0 未就业就没有whrs工资数据;
          1 |        150       60.00      100.00
------------+-----------------------------------
      Total |        250      100.00
	//如果只使用有工作的150人样本进行OLS回归,是非一致的,另外100人不工作的样本数据就无法利用,造成断尾;
reg whrs kl6 k618 wa we if whrs >0
	//使用断尾回归的命令如下:
truncreg whrs kl6 k618 wa we,ll(0) nolog //nolog不显示迭代计算过程的信息;

***在零处断尾的泊松回归和负二项回归:
	//样本中仅包含因变量y不等于0的观测值,不包括为0的观测值造成0断尾;
cd "e:\data"
use CRIME1.dta,clear
drop if narr86 == 0 //去点因变量为0的观测值后回归:
reg narr86 pcnv avgsen tottime ptime86 qemp86 inc86 black hispan born60,r //正常回归和下面的零断尾泊松回归对比:
ztp narr86 pcnv avgsen tottime ptime86 qemp86 inc86 black hispan born60,r nolog
	//回归系数大不相同,下面进行零断尾负二项回归:
ztnb narr86 pcnv avgsen tottime qemp86 inc86 black hispan ,r //迭代不收敛,去掉最不显著的两个变量
	//迭代收敛,但是结果已变化;

***偶然断尾和样本选择:
	//被解释变量y的断尾和另一个变量z有关,这被称为偶然断尾或样本选择(样本选择也称为TypeⅡTobit模型);
	//如果是否工作的变量z=1,则y代表工作时间才有数据,否则z=0,则y断尾;
	//y是否可观测取决于z=0或1,z取决于z*,(z*>0,z=1,否则z=0),z*=ωγ + u 不可观测;
	//使用Heckman两步法解决:
	//第一步:Probit或Logit估计方程P(z=1|ω)=Φ(ω'γ),得到γ的估计值,计算得到λ(-ω'γ)和其它解释变量一起进入第二部回归;
	//第二部:用OLS估计y--x和λ(-ω'γ),得到回归系数.
	//以妇女工作womenwk.dta为例,工作时间lw取决于是否工作(工作了才可以观测到工作时间),是否工作又取决于
	//(age married等变量),用Heckman两步法:
use womenwk.dta,clear
heckman lw education age children,select(age married children education)    	 //默认MLE,选择方程的被解释变量为lw;
heckman lw education age children,select(age married children education) twostep //两步法,选择方程的被解释变量为lw;
heckman lw education age children,select(work = age married children education) //MLE,选择方程的被解释变量为work;
	//MLE直接构造似然函数回归,两步法是先估计一个λ和其它自变量一起进行OLS回归,二者结果不同.同为MLE方法的选择方程的被解释变量为lw或者work对结果没有影响;
Heckman selection model                         Number of obs     =      2,000
(regression model with sample selection)              Selected    =      1,343
                                                      Nonselected =        657

                                                Wald chi2(3)      =     454.78
Log likelihood = -1052.857                      Prob > chi2       =     0.0000

------------------------------------------------------------------------------
             |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
lw           |
   education |   .0397189   .0024525    16.20   0.000     .0349121    .0445256
         age |   .0075872   .0009748     7.78   0.000     .0056767    .0094977
    children |  -.0180477   .0064544    -2.80   0.005    -.0306981   -.0053973
       _cons |   2.305499   .0653024    35.30   0.000     2.177509     2.43349
-------------+----------------------------------------------------------------
work         | //选择方程的被解释变量是work和lw结果是一样的;
         age |   .0350233   .0042344     8.27   0.000     .0267241    .0433225
     married |   .4547724   .0735876     6.18   0.000     .3105434    .5990014
    children |   .4538372   .0288398    15.74   0.000     .3973122    .5103621
   education |   .0565136   .0110025     5.14   0.000     .0349492    .0780781
       _cons |  -2.478055   .1927823   -12.85   0.000    -2.855901   -2.100208
-------------+----------------------------------------------------------------
     /athrho |   .3377674   .1152251     2.93   0.003     .1119304    .5636045 //ρ的绝对值小于1的限制不利于似然函数最大化求解,进行ρ的双曲反正切athrho代换;
    /lnsigma |  -1.375543   .0246873   -55.72   0.000    -1.423929   -1.327156 //σ的值必须大于0也不利于似然函数求极值,取对数lnsigma进行代换;
-------------+----------------------------------------------------------------
         rho |   .3254828   .1030183                      .1114653    .5106469
       sigma |   .2527024   .0062385                      .2407662    .2652304
      lambda |   .0822503   .0273475                      .0286501    .1358505
------------------------------------------------------------------------------
LR test of indep. eqns. (rho = 0):   chi2(1) =     5.53   Prob > chi2 = 0.0187 //ρ=0的原假设被拒绝,认为应该使用样本选择模型;

***归并回归:
	//y>c或(<c)时,都归并为y=c时的回归;用子样本和全样本进行OLS回归都是非一致的；TypeⅠTobit模型,MLE估计可以得到一致估计,但是
	//要求服从正态分布和同方差,需要进行检验:
	//正态性检验:tobcm外部命令来实现,仅适用于左归并;
net install tobcm.pkg
tobcm,pbs //pbs表示自助法获得临界值;
*案例:
clear
cd "e:\data"
use womenwk.dta,clear
reg lwf age married children education,r
hist lwf  //画lwf的直方图,相当多的点lwf取值为0,由此进行归并回归,假设左归并点为0:
tobit lwf age married children education,ll(0) //下面使用tobcm检验扰动项是否服从正态分布:
tobcm,pbs //stata14之前的版本才可以计算,15/16版本出现错误;结果拒绝扰动项服从正态分布的假设,考虑非正态情况下clad方法:

	//同方差检验:辅助回归构造LM统计量来检验;
	//发现扰动项不服从正态分布或者存在异方差,可以使用"归并最小绝对离差法"CLAD,CLAD进要求iid,非正态或异方差也能得到一致估计.
net install sg153.pkg
clad y x1 x2 x3,ll(#) ul(#)
clad lwf age married children education,ll(0)
	//clad于tobit结果应该相差不多,但是如果区别较大,可以认为tobit模型设定有误,倾向于clad模型;
	//归并数据的两部分模型,通常假设两个部分相互独立,故可以分别进行估计,第一部分决定是否参与工作,称为参与决策;第二部分决定工作时间,称为数量决策,
	//满足第一阶段的参与决策,才能进行第二阶段的数量决策,也称"跨栏模型",例如:
gen lwd=(lwf>0)
probit lwd age married children education //第一部分进行是否工作的probit估计,结果显示各解释变量对受否工作的概率有显著影响,
	//如果两部分相互独立,则使用有工作的子样本进行第二部分OLS估计:如果两部分不相互独立,则应使用样本选择模型
reg lwf age married children education if lwd == 1,r
	//直接进行常规的异方差检验:
estat imtest,white //结果拒绝同方差的原假设,认为存在异方差,计算残差进行进一步正态性检验:
predict lwf_resid,resid //计算残差
sktest lwf_resid        //残差正态性检验,拒绝性的原假设,画出核密度图直观来看:
kdensity lwf_resid 		//核密度图直观看到双峰,所以不服从正态分布;
	//含内生解释变量的Tobit模型,可进行工具变量Tobit估计:
ivtobit y x1 x2 (y2 = z1 z2),ll(#) ul(#) r first twostep //默认MLE估计也可进行
*案例:
use laborsup.dta,clear
ivtobit fem_inc fem_educ kids (other_inc = male_educ),ll 
ivtobit fem_inc fem_educ kids (other_inc = male_educ),ll first  //显示第一阶段的估计结果;
ivtobit fem_inc fem_educ kids (other_inc = male_educ),ll twostep //两步法,默认进行MLE估计;
ivtobit fem_inc fem_educ kids (other_inc = male_educ),ll first twostep

*****二,随机试验:
	//个体被分配到实验组或控制组完全是随机的,个体被分配到那一组或接受什么处理于个体其它特征或影响实验结果的其他因素完全独立;
	//解释变量x代表处理水平,完全是随机的,与被遗漏的扰动项ε是不相关的,这样就避免了遗漏变量或内生变量的影响;

***DID:
ssc install diff
diff y,treat(varname) period(varname) cov(z1 z2) robust report test
	//y:结果变量;treat指定处理变量,处于实验组还是控制组;period指定实验期变量,处于实验前还是试验后;cov指定其它解释变量;
	//robust汇报稳健标准误;report汇报对协变量系数的估计结果;test检验基期时,协变量在实验组和控制组的均值是否相等;
	//案例:
use cardkrueger1994.dta,clear 
gen gd = t*treated     //手动DID,先计算处理变量和实验期的交叉项,进行回归;
reg fte gd treated t,r //交互项的系数即为处理效应;
diff fte,t(treated) p(t) robust
	//加入协变量:
reg fte gd treated t bk kfc roys,r
diff fte,t(treated) p(t) cov(bk kfc roys) robust
diff fte,t(treated) p(t) cov(bk kfc roys) robust report test

*****三,处理效应:
*****处理效应:
	//面临"选择难题",个体根据参加项目的预期收益自我选择是否参加项目.无论Di=0或1,yi均可观测;例如:上大学对个人收入的影响.
	//个人根据上大学能否提高收入决定是否上大学,而无论是否上大学,个人收入都可观测.随机分组解决分组难题

*****样本选择:
	//所获样本是否为总体代表性样本,样本能否代表总体,样本是否随机.yi是否可观测取决于Di(Di=1,yi可观测;Di=0,yi不可观测);
	//例如:妇女工作时间yi的影响因素,参加工作Di=1时则yi可观测,不工作Di=0则yi不可观测.使用heckman两步法解决;

*****依可测变量选择:
	//个体i对Di的选择(个体自己选择是否参与某一项目)取决于可观测的xi,此时满足可忽略性假定.可使用的方法有:匹配和RD,
	//可忽略性假定是一个很强的假定,方程包含了所有相关变量,不存在任何与解释变量相关的遗漏变量;

*匹配根据可测变量xi,在控制组中找到一个与实验组个体尽可能相似的个体:
	*(1)马氏匹配:找到和个体i马氏距离最近的个体j进行匹配,缺点:协变量较多或样本容量不够大,不容易找到好的匹配;
	*(2)PSM:倾向得分匹配
		//根据个体进入处理组的概率(倾向得分)进行匹配;需要满足以下假定:
		//重叠假定:倾向得分在处理组和控制组存在共同取值范围;
		//匹配假定;

*步骤:
	*1选择协变量xi,尽可能将相关的影响y和D的变量都包含进来,保证可忽略性假定得到满足
	*2尽量使用形式灵活的logit模型,例如包含xi的高次项和交互项;
	*3进行倾向得分匹配,匹配后的处理组和控制组均值比较接近,标准化偏差不超过10%,超过则重新估计倾向得分或改变具体的匹配方法;
	*4根据匹配后的样本计算ATT(参与者平均处理效应),ATE(整个样本平均处理效应),ATU(未参加者平均处理效应);

*匹配方法:
	*1k近邻匹配:一对一或一对多;
	*2卡尺匹配或半径匹配:限定倾向得分插值的距离,|pi-pj|<ε=0.25σ(倾向得分的样本标准差);
	*3卡尺内近邻匹配;
	*4核匹配:根据核函数计算的权重进行加权平均得到的值;
	*5样条匹配:更加光滑的三次样条来估计权重进行加权平均;

*PSM缺点:
	*1一般要求较大的样本容量以获得高质量匹配;
	*2处理组和控制组要有较大的共同取值范围,否则丢失较多观测值,剩下的样本不具有代表性;
	*3PSM只控制了可测变量的影响,如果存在不可测变量的影响将会带来"隐形偏差";

*PSM实例:
ssc install psmatch2,replace
psmatch2 D x1 x2 x3,outcome(y) logit ties ate common odds pscore(varname) quietly neighbor(k) noreplacement radius caliper(ε) 
	//D处理变量;x协变量;y结果变量;
	//logit来估计倾向得分,默认probit;
	//ties允许得分相同的个体并列,默认选取第一个得分相同的个体;
	//ATE表示全部汇报ATT ATE ATU,默认仅汇报ATT;common对共同取值范围内的个体进行匹配,默认对所有个体进行匹配;
	//odds使用p/(1-p)进行匹配,默认用得分p进行匹配;pscore(varname)指定varname作为倾向得分,默认利用协变量估计倾向得分进行匹配;
	//quietly表示不汇报对倾向得分的估计过程;
	//neighbor(k)表示k紧邻匹配;
	//radius表示半径或卡尺匹配,caliper(ε)指定ε未卡尺;处理组个体与每一个对照组个体匹配,不满足卡尺的处理组个体将被删除,避免差距过大的个体进行匹配;
	//kerneltype(type) bwidth(real),type指定核匹配的和函数,默认epan kernel二次核,bwidth()指定带宽,默认为0.06;
	//llr局部线性回归匹配,此时kerneltype(type)指定核函数,默认tricubic kernel三三核,bwidth()指定带宽,默认0.8;
	//spline样条匹配;
	//mahal(varlist)马氏匹配,指定varlist为计算马氏距离的协变量,ai(m)使用异方差稳健标准误,m为计算稳健标准误的近邻个数,一般m=k,此时无法使用ties和common选项;
	//两个估计后命令:
pstest x1 x2 x3,both graph //检验这些协变量在匹配后是否平衡,both表示同时显示匹配前的数据平衡情况;
psgraph,bin(#) //画直方图显示倾向得分的共同取值范围,bin(#)指定直方图的分组数,默认20组,处理组和控制组各10组;
	//或者先估计倾向得分,再匹配:
logit t age educ black hisp married re74 re75 u74 u75
predict pscore
psmatch2 t,pscore(pscore) outcome(re78) common noreplacement

cd "/Users/zhulu/Files/data"
use ldw_exper.dta,clear
reg re78 t,r //先直接用结果变量对处理变量进行回归,看是否显著,然后加入协变量进行回归:
reg re78 t age educ black hisp married re74 re75 u74 u75,r //只有两个变量显著其余均不显著,考虑倾向得分匹配:
set seed 10101
gen ranorder = runiform()
sort ranorder 
psmatch2 t age educ black hisp married re74 re75 u74 u75,outcome(re78) n(1) ate ties logit common

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
----------------------------------------------------------------------------------------
        Variable     Sample |    Treated     Controls   Difference         S.E.   T-stat
----------------------------+-----------------------------------------------------------
            re78  Unmatched | 6.34914538   4.55480228   1.79434311   .632853552     2.84 //未匹配的结果,与re78对t回归的结果完全一样;
                        ATT | 6.40495818   4.99436488    1.4105933   .839875971     1.68 //T=1.68<1.96不显著;
                        ATU | 4.52683013   6.15618973    1.6293596            .        .
                        ATE |                           1.53668776            .        .
----------------------------+-----------------------------------------------------------
Note: S.E. does not take into account that the propensity score is estimated. //没有考虑倾向得分时估计得到的,即假设倾向得分为真实值,然后推导的标准误,
																			  //此标准误的另一假设为同方差也可能不成立,所以可以使用自助法来得到标准误:
 psmatch2: |   psmatch2: Common
 Treatment |        support
assignment | Off suppo  On suppor |     Total
-----------+----------------------+----------
 Untreated |        11        249 |       260 //控制组有11个不在共同取值范围中;
   Treated |         2        183 |       185 //处理组有2个不在共同取值范围中;
-----------+----------------------+----------
     Total |        13        432 |       445 
*自助法得到标准误:
set seed 10101
bootstrap r(att) r(atu) r(ate),reps(500):psmatch2 t age educ black hisp married re74 re75 u74 u75,outcome(re78) n(1) ate ties logit common
Bootstrap results                               Number of obs     =        445
                                                Replications      =        500

      command:  psmatch2 t age educ black hisp married re74 re75 u74 u75, outcome(re78) n(1)
                    ate ties logit common
        _bs_1:  r(att)
        _bs_2:  r(atu)
        _bs_3:  r(ate)

------------------------------------------------------------------------------
             |   Observed   Bootstrap                         Normal-based
             |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
       _bs_1 |   1.410593   .8860627     1.59   0.111    -.3260577    3.147244 //ATT的标准误0.93;
       _bs_2 |    1.62936   .9156438     1.78   0.075    -.1652692    3.423988 //也给出了ATU和ATE标准误和P值,在10%水平上显著;
       _bs_3 |   1.536688   .7132009     2.15   0.031     .1388396    2.934536
------------------------------------------------------------------------------
	//下面pstest来检验此匹配结果是否较好地平衡了数据.
quietly psmatch2 t age educ black hisp married re74 re75 u74 u75,outcome(re78) n(1) ate ties logit common
pstest age educ black hisp married re74 re75 u74 u75,both graph 
	//both同时显示数据匹配前的平衡情况,默认仅显示匹配后的情况;
	//graph作图显示个变量匹配前后的平衡情况;

----------------------------------------------------------------------------------------
                Unmatched |       Mean               %reduct |     t-test    |  V(T)/    
Variable          Matched | Treated Control    %bias  |bias| |    t    p>|t| |  V(C)     //%bias标准化偏差,绝大多数变量匹配后标准化偏差小于10%;
--------------------------+----------------------------------+---------------+----------
age                    U  | 25.816   25.054     10.7         |   1.12  0.265 |  1.03     //大多数t检验的P值都接受处理组和控制组无系统差异的原假设;
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
re74                   U  | 2.0956    2.107     -0.2         |  -0.02  0.982 |  0.74* //re74标准化偏差变大;
                       M  | 2.0672   1.9222      2.7 -1166.6 |   0.27  0.784 |  0.88
                          |                                  |               |
re75                   U  | 1.5321   1.2669      8.4         |   0.87  0.382 |  1.08
                       M  | 1.5299   1.6446     -3.6    56.7 |  -0.32  0.748 |  0.82
                          |                                  |               |
u74                    U  | .70811      .75     -9.4         |  -0.98  0.326 |     .
                       M  | .71038   .75956    -11.1   -17.4 |  -1.06  0.288 |     . //u74标准化偏差变大;
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
	//画条形图来显示共同取值范围:
psgraph //显示大多数观测值的倾向得分在共同取值范围中
	//下面进行k=4的一对四匹配
psmatch2 t age educ black hisp married re74 re75 u74 u75,outcome(re78) n(4) ate ties logit common quietly
	//quietly表示不显示对倾向得分进行估计的结果,下面进行一对四卡尺内匹配,先计算倾向得分的标准差,再乘以0.25
sum _pscore
dis 0.25*r(sd) //=0.1979237
psmatch2 t age educ black hisp married re74 re75 u74 u75,outcome(re78) n(4) caliper(0.01) ate ties logit common quietly
	//与一对四匹配结果类似,说明大多数一对四匹配发生在卡尺0.01的范围内,不存在太远近邻,下面进行半径卡尺匹匹配:
psmatch2 t age educ black hisp married re74 re75 u74 u75,outcome(re78) radius caliper(0.01) ate ties logit common quietly
	//此匹配结果然类似,下面进行核匹配:
psmatch2 t age educ black hisp married re74 re75 u74 u75,outcome(re78) kernel ate ties logit common quietly
	//结果一然类似,下面进行局部线性匹配:
psmatch2 t age educ black hisp married re74 re75 u74 u75,outcome(re78) llr ate ties logit common quietly
	//如果为汇报标准误,可以使用bootstrap方法,下面进行样条匹配:需要先安装spline
net install snp7_1.pkg
findit snp7_1
psmatch2 t age educ black hisp married re74 re75 u74 u75,outcome(re78) spline ate ties logit common quietly
	//样条匹配未计算标准误,使用bootstrap计算标准误:
bootstrap r(att) r(atu) r(ate),reps(500):psmatch2 t age educ black hisp married re74 re75 u74 u75,outcome(re78) spline ate ties logit common quietly
	//经计算标准误,样条匹配结果依然显著,和上面个匹配方法结果类似,下面进行马氏匹配:
psmatch2 t,outcome(re78) mahal(age educ black hisp married re74 re75 u74 u75) n(4) ai(4) ate
	//马氏匹配的结果和倾向得分匹配结果类似,这也说明了结果依然稳健;

*偏差校正匹配估计量:
	//PSM第一阶段使用probit或logit模型估计倾向得分时存在不确定性,模型设定取决于研究者,具有一定的主观性;
	//而回到马氏匹配进行又放回且允许并列的k近邻匹配,研究者在匹配估计量时只需做少量的主观决定;
	//更重要的是,非精确匹配一般存在偏差.可以通过回归的方法来估计偏差,得到"偏差校正匹配估计量",还可以通过处理组和控制组内部进行二次匹配得到异方差条件下也成立的稳健标准误;
	//偏差校正匹配估计量使用非官方nnmatch命令来实现:
ssc install nnmatch,replace
nnmatch y D x1 x2 x3,metric(maha) tc(att) tc(atc) m(k) robust(#) biasadj(bias|varlist) pop
	//metric(maha)马氏距离,权重矩阵为样本协方差矩阵之逆矩阵;
	//tc(att) 估计ATT,atc估计ATU,c表示control;
	//m(k)表示k紧邻匹配;
	//robust(#)计算稳健标准误的近邻个数;
	//biasadj(bias)表示使用原来的协变量进行偏差校正,biasadj(varlist)指定用于偏差校正的协变量列表;
	//pop估计总体平均处理效应;
*案例:
	//先进性一对四匹配估计ATT,不做偏差校正,但是用异方差稳健标准误:
use ldw_exper.dta,clear
nnmatch re78 t age educ black hisp married re74 re75 u74 u75,tc(att) m(4) robust(4)
	//重复上述命令,使用偏差校正:
nnmatch re78 t age educ black hisp married re74 re75 u74 u75,tc(att) m(4) robust(4) bias(bias)
	//进行马氏距离匹配
nnmatch re78 t age educ black hisp married re74 re75 u74 u75,tc(att) m(4) robust(4) bias(bias) metric(maha)
	//结果很类似;

*****依不可测变量选择:
	//如果存在不可测变量影响个体i对Di的选择,此时不满足可忽略性假定,,有以下几种处理办法:
		*(1)尽可能多的可测变量,以满足可忽略性假定,然后使用匹配估计量.如果可测变量太少,显然不太可能满足可忽略性假定;
		*(2)如果影响个体i对处理变量Di的决定的不可测变量不随时间而改变,ui,而且有面板数据,可使用双重差分倾向得分匹配PSM-DID;
		*(3)使用断点回归法;
		*(4)局部平均处理效应IV估计量和处理效应模型;

*PSM-DID:
	//有两期面板数据,实验前和试验后,处理组个体试验前后的变化减去与其匹配的控制组个体试验前后的变化:
diff outcome(y),treat(varname) period(varname) id(varname) kernel ktype(kernel) cov(varlist) report logit support test
	//id指定个体ID变量;kernel核匹配,diff只提供核匹配;ktype指定核类型,默认二次核;
use cardkrueger1994.dta,clear
diff fte,t(treated) p(t) kernel id(id) logit cov(bk kfc roys) report support



