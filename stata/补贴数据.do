cd "E:\学术论文\C论文\创新激励\实证数据和代码"
use 原始数据.dta,clear



****描述性统计

****描述性统计：Table 2                 
tabstat  frd fpatent fcitation flogpatent flogcitation gs logassets logppe_emp return tobinq lev logtenure logage logedu, s(n mean sd p5 p25 med p75 p95) col(s) f(%6.3f)
***********************************************************************************
***********************************************************************************


***table3

global xv "ind_dummy_* _Iyear_*"

est clear
reg frd          gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m1
reg flogpatent   gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m2
reg flogcitation gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m3
reg flogpatent   gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m4
reg flogcitation gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m5
local mm "m1 m2 m3 m4 m5"
local order "gs rd logassets logppe_emp return tobinq lev logtenure logage logedu"
esttab `mm' using table基本模型.rtf , mtitle(`mm') scalars(N r2_a) compress nogap  ///
        star(* 0.10  ** 0.05  *** 0.01) b(%6.3f)    ///
		drop($xv) order(`order') replace

		
		
	
***table
**工具变量
est clear
ivregress  2sls frd          (gs=gs_nindcd gs_pro)    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m1
ivregress  2sls flogpatent   (gs=gs_nindcd gs_pro)    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m2
ivregress  2sls flogcitation (gs=gs_nindcd gs_pro)    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m3
ivregress  2sls flogpatent   (gs=gs_nindcd gs_pro) rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m4
ivregress  2sls flogcitation (gs=gs_nindcd gs_pro) rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m5
local mm "m1 m2 m3 m4 m5"
local order "gs rd logassets logppe_emp return tobinq lev logtenure logage logedu"
esttab `mm' using table工具变量.rtf , mtitle(`mm') scalars(N r2_a) compress nogap  ///
        star(* 0.10  ** 0.05  *** 0.01) b(%6.3f)    ///
		drop($xv) order(`order') replace		

		
*PSM 注意gs_dum的定义哦???定义反了吧?有问题!!!
g       gs_dum=0 if govgrant>0&govgrant<. //获得政府补贴为0,否则为1 
replace gs_dum=1 if gs_dum==.
order govgrant gs_dum treat _pscore


global p "logassets logppe_emp return tobinq lev logtenure logage logedu"
global y "frd flogpatent flogcitation"
psmatch2 gs_dum $p ind_dummy_* _Iyear_*, n(3) logit qui out($y)     //匹配时不要控制产业和时间固定效应;
pstest $p, both 
		
global p "rd logassets logppe_emp return tobinq lev logtenure logage logedu"
global y "flogpatent flogcitation"
psmatch2 gs_dum $p ind_dummy_* _Iyear_*, n(1) logit qui out($y)
pstest $p, both
	

***PSM自己尝试:		
*匹配对顺序敏感,先随机排序:
set seed 20191109
gen randsort=runiform()
sort randsort

*一对一近邻匹配：
*treat的定义：treat=1获得补贴,treat=0没有补贴
gen treat=1
replace treat=0 if govgrant ==0
save matchdata.dta,replace
global p "logassets logppe_emp return tobinq lev logtenure logage logedu"
global y "frd flogpatent flogcitation"    //三个因变量一起匹配,将会取每个因变量都不缺失的obs,将会损失样本,可以分别进行匹配;
psmatch2 treat $p,out($y) n(1) logit qui ties common //加入产业和年份虚拟变量时,flogpatent和flogcitation的匹配结果不显著;
pstest $p, both graph //通过平衡性测试;
keep if _pscore >= 0.7
psgraph
//此时不再适合控制rd，研究补贴对技术创新效率的影响：
global p "frd logassets logppe_emp return tobinq lev logtenure logage logedu" //rd作自变量,控制rd,研究创新效率;
global y "flogpatent flogcitation"
psmatch2 treat $p,out($y) n(1) logit qui ties common 			//quietly不显示倾向得分估计结果;

*核匹配：默认probit、二次核、带宽0.06；
gen treat=1
replace treat=0 if govgrant ==0
global p "logassets logppe_emp return tobinq lev logtenure logage logedu"
global y "frd flogpatent flogcitation" 
psmatch2 treat $p,out($y) kernel qui ties common 
pstest $p, both


*样条匹配：样条匹配没有提供标准误，使用自助法计算标准误
gen treat=1
replace treat=0 if govgrant ==0
global p "logassets logppe_emp return tobinq lev logtenure logage logedu"
global y "frd flogpatent flogcitation" 
psmatch2 treat $p,out(frd) spline logit qui ties common
pstest $P,both
psmatch2 treat $p,out(flogpatent) spline logit qui ties common
pstest $p, both
psmatch2 treat $p,out(flogcitation) spline logit qui ties common
pstest $p, both
bootstrap r(att),reps(500):psmatch2 treat $p,out(frd) spline qui ties common
bootstrap r(att),reps(500):psmatch2 treat $p,out(flogpatent) spline qui ties common
bootstrap r(att),reps(500):psmatch2 treat $p,out(flogcitation) spline qui ties common



*局部线性回归匹配：
gen treat=1
replace treat=0 if govgrant ==0
global p "logassets logppe_emp return tobinq lev logtenure logage logedu"
global y "frd flogpatent flogcitation" 
psmatch2 treat $p,out($y) llr logit qui ties common

*三个因变量分别进行匹配:
psmatch2 treat $p,outcome(frd) n(1) quietly ties common logit
pstest $p, both
psgraph

psmatch2 treat $p,outcome(flogpatent) n(1) quietly ties common logit
pstest $p, both
psgraph

psmatch2 treat $p,outcome(flogcitation) kernel n(1) quietly ties common logit 
pstest $p, both graph
psgraph

//尝试偏差校正:
gen treat=1
replace treat=0 if govgrant ==0
global p "logassets logppe_emp return tobinq lev logtenure logage logedu"
global y "frd flogpatent flogcitation"
nnmatch $y treat $p,tc(att) m(4) robust(4)    //nnmatch命令不支持多因变量一起匹配,$y会报错,应该分开进行匹配;

nnmatch frd          treat $p,tc(att) m(4) robust(4)
nnmatch flogpatent   treat $p,tc(att) m(4) robust(4)
nnmatch flogcitation treat $p,tc(att) m(4) robust(4)

nnmatch frd          treat $p,tc(att) m(4) robust(4) bias(return tobinq lev)
pstest 
nnmatch flogpatent   treat $p,tc(att) m(4) robust(4) bias(bias)
nnmatch flogcitation treat $p,tc(att) m(4) robust(4) bias(bias)

nnmatch frd          treat $p,tc(att) m(4) robust(4) bias(bias) metric(maha)
nnmatch flogpatent   treat $p,tc(att) m(4) robust(4) bias(bias) metric(maha)
nnmatch flogcitation treat $p,tc(att) m(4) robust(4) bias(bias) metric(maha)

//尝试遗传匹配:
set seed 20191109
gen randsort=runiform()
sort randsort
gen treat=1
replace treat=0 if govgrant ==0
global p "treat govgrant logassets logppe_emp return tobinq lev logtenure logage logedu"
global y "frd flogpatent flogcitation"
global dum "ind_dummy_* _Iyear_*"
keep $y $p $dum
export excel using "genmatch_data.xlsx",replace firstrow(variables) //导出到excel,然后用R来处理:


		
***gs>0
preserve                     
keep if gs>0
global xv "ind_dummy_* _Iyear_*"
est clear
reg frd          gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m1
reg flogpatent   gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m2
reg flogcitation gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m3
reg flogpatent   gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m4
reg flogcitation gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m5
local mm "m1 m2 m3 m4 m5"
local order "gs rd logassets logppe_emp return tobinq lev logtenure logage logedu"
esttab `mm' using tablegs大于零.rtf , mtitle(`mm') scalars(N r2_a) compress nogap  ///
        star(* 0.10  ** 0.05  *** 0.01) b(%6.3f)    ///
		drop($xv) order(`order') replace
restore


***patent>0
preserve                     
keep if patent>0
global xv "ind_dummy_* _Iyear_*"
est clear
reg frd          gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m1
reg flogpatent   gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m2
reg flogcitation gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m3
reg flogpatent   gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m4
reg flogcitation gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m5
local mm "m1 m2 m3 m4 m5"
local order "gs rd logassets logppe_emp return tobinq lev logtenure logage logedu"
esttab `mm' using tablepatent大于零.rtf , mtitle(`mm') scalars(N r2_a) compress nogap  ///
        star(* 0.10  ** 0.05  *** 0.01) b(%6.3f)    ///
		drop($xv) order(`order') replace 
restore



***citation>0
preserve                     
keep if citation>0
global xv "ind_dummy_* _Iyear_*"
est clear
reg frd          gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m1
reg flogpatent   gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m2
reg flogcitation gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m3
reg flogpatent   gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m4
reg flogcitation gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m5
local mm "m1 m2 m3 m4 m5"
local order "gs rd logassets logppe_emp return tobinq lev logtenure logage logedu"
esttab `mm' using tablecitation大于零.rtf , mtitle(`mm') scalars(N r2_a) compress nogap  ///
        star(* 0.10  ** 0.05  *** 0.01) b(%6.3f)    ///
		drop($xv) order(`order') replace 
restore


***双重聚类
cluster2 frd          gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*,fcluster(stkcd) tcluster(year)
est store m1
cluster2 flogpatent   gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, fcluster(stkcd) tcluster(year)
est store m2
cluster2 flogcitation gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, fcluster(stkcd) tcluster(year)
est store m3
cluster2 flogpatent   gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, fcluster(stkcd) tcluster(year)
est store m4
cluster2 flogcitation gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, fcluster(stkcd) tcluster(year)
est store m5
local mm "m1 m2 m3 m4 m5"
local order "gs rd logassets logppe_emp return tobinq lev logtenure logage logedu"
esttab `mm' using table双重聚类.rtf , mtitle(`mm') scalars(N r2_a) compress nogap  ///
        star(* 0.10  ** 0.05  *** 0.01) b(%6.3f)    ///
		drop($xv) order(`order') replace

	
	

***table
**分析师 √√√
est clear
reg frd          gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_anal_no==1, cluster(stkcd)
est store m1
reg frd          gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_anal_no==0, cluster(stkcd)
est store m2
reg flogpatent   gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_anal_no==1, cluster(stkcd)
est store m3
reg flogpatent   gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_anal_no==0, cluster(stkcd)
est store m4
reg flogcitation gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_anal_no==1, cluster(stkcd)
est store m5
reg flogcitation gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_anal_no==0, cluster(stkcd)
est store m6
reg flogpatent   gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_anal_no==1, cluster(stkcd)
est store m7
reg flogpatent   gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_anal_no==0, cluster(stkcd)
est store m8
reg flogcitation gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_anal_no==1, cluster(stkcd)
est store m9
reg flogcitation gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_anal_no==0, cluster(stkcd)
est store m10
local mm "m1 m2 m3 m4 m5 m6 m7 m8 m9 m10"
local order "gs rd logassets logppe_emp return tobinq lev logtenure logage logedu"
esttab `mm' using table分析师.rtf , mtitle(`mm') scalars(N r2_a) compress nogap  ///
        star(* 0.10  ** 0.05  *** 0.01) b(%6.3f)    ///
		drop($xv) order(`order') replace
		
		
		
***table
**机构投资者  √√√
est clear
reg frd          gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_ins==1, cluster(stkcd)
est store m1
reg frd          gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_ins==0, cluster(stkcd)
est store m2
reg flogpatent   gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_ins==1, cluster(stkcd)
est store m3
reg flogpatent   gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_ins==0, cluster(stkcd)
est store m4
reg flogcitation gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_ins==1, cluster(stkcd)
est store m5
reg flogcitation gs    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_ins==0, cluster(stkcd)
est store m6
reg flogpatent   gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_ins==1, cluster(stkcd)
est store m7
reg flogpatent   gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_ins==0, cluster(stkcd)
est store m8
reg flogcitation gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_ins==1, cluster(stkcd)
est store m9
reg flogcitation gs rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_* if d_ins==0, cluster(stkcd)
est store m10
local mm "m1 m2 m3 m4 m5 m6 m7 m8 m9 m10"
local order "gs rd logassets logppe_emp return tobinq lev logtenure logage logedu"
esttab `mm' using table机构投资者.rtf , mtitle(`mm') scalars(N r2_a) compress nogap  ///
        star(* 0.10  ** 0.05  *** 0.01) b(%6.3f)    ///
		drop($xv) order(`order') replace		
		
//补贴政策的不确定性对企业技术创新的影响:重新解释补贴力度的调整和补贴频率的变化,会有新的结果!!!另外一篇文章!!!
cd "E:\学术论文\C论文\创新激励\实证数据和代码"
use 原始数据.dta,clear
drop _Iyear_1991 - _Iyear_2006 //删除多余的时间虚拟变量

sort stkcd accper
by stkcd:egen intensity = sd(govgrant) //各公司收到补贴的标准差,衡量补贴政策的调整力度;
egen gs_adjust = std(intensity) //标准化后再回归
replace gs_adjust = - gs_adjust

gen d1 = date(accper,"YMD")
order stkcd accper d1
by stkcd:gen d2 = d1[_n]-d1[_n-1]
order stkcd accper d1 d2
by stkcd:egen freq = mean(d2) //时间间隔均值;
gen gs_freq = 1/freq //补贴政策的调整频率等于时间的倒数;
egen gs_frequency = std(gs_freq) //标准化以后回归
replace gs_frequency = -gs_frequency //符号相反,解释实际意义的时候需注意;
save 不确定性影响.dta,replace	 // 保存不确定性影响的回归数据:

reg frd          gs_adjust    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m1
reg flogpatent   gs_adjust    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m2
reg flogcitation gs_adjust    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m3
reg flogpatent   gs_adjust    frd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m4
reg flogcitation gs_adjust    frd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m5
reg2docx m1 m2 m3 m4 m5 using adjust_regresult1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("IV results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")        //year=*year不显示年份虚拟变量,改为year 控制状态"yes"
		
reg frd          gs_frequency    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m1
reg flogpatent   gs_frequency    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m2
reg flogcitation gs_frequency    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m3
reg flogpatent   gs_frequency    frd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m4
reg flogcitation gs_frequency    frd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m5
reg2docx m1 m2 m3 m4 m5 using frequency_regresult1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("IV results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")

//用Baker经济不确定性指数进行稳健性检验:
cd "E:\学术论文\C论文\创新激励\实证数据和代码"
import excel using "SCMP_China_Policy_Uncertainty_Data.xlsx",case(lower) first clear
drop in 300 			
rename chinanewsbasedepu epu 		
sort year month
destring year,replace
keep if year >= 2006 & year<=2015
bysort year:egen yepu = prod(epu) //12个月连乘
gen year_epu = yepu^(1/12)        //开12次方
drop month epu yepu
rename year_epu epu
duplicates drop
egen epu1 = std(epu)
drop epu
rename epu1 epu
save epu.dta,replace

use 实际数据.dta,clear
destring year,replace
merge m:1 year using epu.dta
drop if _merge == 2
save 实际数据_EPU.dta,replace

reg frd          epu    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m1
reg flogpatent   epu    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m2
reg flogcitation epu    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m3
reg flogpatent   epu    frd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m4
reg flogcitation epu    frd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m5
reg2docx m1 m2 m3 m4 m5 using epu_regresult1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("IV results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")

//用公司股票当年交易日收益率标准差代替补贴政策的不确定性进行稳健性检验,用下面合并最全数据中的stockvolatility
cd "E:\学术论文\C论文\创新激励\实证数据和代码"
use 最全数据.dta,clear
reg frd          stockvolatility    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(_ID)
est store m1
reg flogpatent   stockvolatility    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(_ID)
est store m2
reg flogcitation stockvolatility    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(_ID)
est store m3
reg flogpatent   stockvolatility    frd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(_ID)
est store m4
reg flogcitation stockvolatility    frd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(_ID)
est store m5
reg2docx m1 m2 m3 m4 m5 using epu_regresult2.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("IV results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")


//其它有用信息合并进来:将发明家高管的文章数据合并进来:
cd "E:\学术论文\C论文\创新激励\实证数据和代码"
use 实际数据_EPU.dta,clear
drop _merge
//use 加入补贴数据.dta,clear
rename stkcd _ID
order _ID year
sort _ID year
merge 1:1 _ID year using 加入补贴数据.dta
keep if _merge == 3
save 最全数据.dta,replace //共5447个样本
//用最全的数据进行回归,研发和专利授权数据为正,专利引用次数数据为负,结果怎么解释??会是一篇好文章!
reg frd          epu    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(_ID)
est store m1
reg flogpatent   epu    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(_ID)
est store m2
reg flogcitation epu    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(_ID)
est store m3
reg flogpatent   epu    frd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(_ID)
est store m4
reg flogcitation epu    frd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(_ID)
est store m5
reg2docx m1 m2 m3 m4 m5 using epu_regresult3.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("IV results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")

//描述性统计
cd "E:\学术论文\C论文\创新激励\实证数据和代码"
use 不确定性影响.dta,clear
sum2docx frd fpatent fcitation gs_adjust gs_frequency logassets logppe_emp return tobinq lev logtenure logage logedu using sumresults1.docx, ///
replace stats(N mean(%9.2f) sd skewness kurtosis min(%9.2f) median max(%9.2f)) ///
title("Summary Statistics")

//企业所有制性质:国有企业or民营企业
cd "E:\学术论文\C论文\创新激励\实证数据和代码"
use 不确定性影响.dta,clear
rename stkcd _ID
order _ID year
sort _ID year
merge 1:1 _ID year using 加入补贴数据.dta
keep if _merge == 3
save 补贴政策不确定性合并发明高管.dta,replace

//SOE与调整力度交互  很显著   所有回归去掉聚类在公司层面的标准误
use 补贴政策不确定性合并发明高管.dta,clear
reg frd          gs_adjust c.gs_adjust#SOEfirm SOEfirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
reg flogpatent   gs_adjust c.gs_adjust#SOEfirm SOEfirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
reg flogcitation gs_adjust c.gs_adjust#SOEfirm SOEfirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
reg flogpatent   gs_adjust c.gs_adjust#SOEfirm SOEfirm rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
reg flogcitation gs_adjust c.gs_adjust#SOEfirm SOEfirm rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5

reg2docx m1 m2 m3 m4 m5 using SOE_adjust_regresult11.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("SOE调整力度交互 results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")
//SOE与调整频率交互 显著不够
reg frd          gs_frequency c.gs_frequency#SOEfirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
reg flogpatent   gs_frequency c.gs_frequency#SOEfirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
reg flogcitation gs_frequency c.gs_frequency#SOEfirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
reg flogpatent   gs_frequency c.gs_frequency#SOEfirm rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
reg flogcitation gs_frequency c.gs_frequency#SOEfirm rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5

reg2docx m1 m2 m3 m4 m5 using SOE_freq_regresult1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("SOE调整频率交互 results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")

//合并时province重名,修改后再合并:
use 加入补贴数据.dta,clear
rename province provin
save 加入补贴数据.dta,replace

//Scale企业规模与补贴政策不确定性的交互 显著
use 补贴政策不确定性合并发明高管.dta,clear
reg frd          gs_adjust c.gs_adjust#largefirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
reg flogpatent   gs_adjust c.gs_adjust#largefirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
reg flogcitation gs_adjust c.gs_adjust#largefirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
reg flogpatent   gs_adjust c.gs_adjust#largefirm rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
reg flogcitation gs_adjust c.gs_adjust#largefirm rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5

reg2docx m1 m2 m3 m4 m5 using largefirm_adjust_regresult1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("SOE调整力度交互 results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")
//Scale与调整频率交互 不显著
reg frd          gs_frequency c.gs_frequency#largefirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
reg flogpatent   gs_frequency c.gs_frequency#largefirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
reg flogcitation gs_frequency c.gs_frequency#largefirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
reg flogpatent   gs_frequency c.gs_frequency#largefirm rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
reg flogcitation gs_frequency c.gs_frequency#largefirm rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5

reg2docx m1 m2 m3 m4 m5 using largefirm_freq_regresult1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("SOE调整频率交互 results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")

//Cycle企业生命周期与补贴政策不确定性的交互 不够显著
use 补贴政策不确定性合并发明高管.dta,clear
reg frd          gs_adjust c.gs_adjust#maturefirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
reg flogpatent   gs_adjust c.gs_adjust#maturefirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
reg flogcitation gs_adjust c.gs_adjust#maturefirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
reg flogpatent   gs_adjust c.gs_adjust#maturefirm rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
reg flogcitation gs_adjust c.gs_adjust#maturefirm rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5

reg2docx m1 m2 m3 m4 m5 using maturefirm_adjust_regresult1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("SOE调整力度交互 results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")
//与调整频率交互 显著
reg frd          gs_frequency c.gs_frequency#maturefirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
reg flogpatent   gs_frequency c.gs_frequency#maturefirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
reg flogcitation gs_frequency c.gs_frequency#maturefirm logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
reg flogpatent   gs_frequency c.gs_frequency#maturefirm rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
reg flogcitation gs_frequency c.gs_frequency#maturefirm rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5

reg2docx m1 m2 m3 m4 m5 using maturefirm_freq_regresult1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("SOE调整频率交互 results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")

//制度环境与补贴政策不确定性的交互 显著
use 补贴政策不确定性合并发明高管.dta,clear
rename 是否市场化程度较高是取1否取0 highmarket
reg frd          gs_adjust c.gs_adjust#highmarket logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
reg flogpatent   gs_adjust c.gs_adjust#highmarket logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
reg flogcitation gs_adjust c.gs_adjust#highmarket logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
reg flogpatent   gs_adjust c.gs_adjust#highmarket rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
reg flogcitation gs_adjust c.gs_adjust#highmarket rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5

reg2docx m1 m2 m3 m4 m5 using highmarket_adjust_regresult1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("SOE调整力度交互 results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")
//与调整频率交互 不够显著
reg frd          gs_frequency c.gs_frequency#highmarket logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
reg flogpatent   gs_frequency c.gs_frequency#highmarket logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
reg flogcitation gs_frequency c.gs_frequency#highmarket logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
reg flogpatent   gs_frequency c.gs_frequency#highmarket rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
reg flogcitation gs_frequency c.gs_frequency#highmarket rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5

reg2docx m1 m2 m3 m4 m5 using highmarket_freq_regresult1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("SOE调整频率交互 results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")

//删除为零的样本
use 不确定性影响.dta,clear
keep if gs>0  //政府补贴大于0
reg frd          gs_adjust    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m1
reg flogpatent   gs_adjust    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m2
reg flogcitation gs_adjust    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m3
reg flogpatent   gs_adjust    frd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m4
reg flogcitation gs_adjust    frd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m5
reg2docx m1 m2 m3 m4 m5 using adjust_regresult0.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("IV results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")        //year=*year不显示年份虚拟变量,改为year 控制状态"yes"
		
reg frd          gs_frequency    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m1
reg flogpatent   gs_frequency    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m2
reg flogcitation gs_frequency    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m3
reg flogpatent   gs_frequency    frd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m4
reg flogcitation gs_frequency    frd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, cluster(stkcd)
est store m5
reg2docx m1 m2 m3 m4 m5 using frequency_regresult0.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("IV results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")

//双重聚类稳健标准误
use 不确定性影响.dta,clear
cluster2 frd          gs_adjust    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*,fcluster(stkcd) tcluster(year)
est store m1
cluster2 flogpatent   gs_adjust    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, fcluster(stkcd) tcluster(year)
est store m2
cluster2 flogcitation gs_adjust    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, fcluster(stkcd) tcluster(year)
est store m3
cluster2 flogpatent   gs_adjust rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, fcluster(stkcd) tcluster(year)
est store m4
cluster2 flogcitation gs_adjust rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, fcluster(stkcd) tcluster(year)
est store m5
reg2docx m1 m2 m3 m4 m5 using cluster2_regresult.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("IV results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")

cluster2 frd          gs_frequency    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*,fcluster(stkcd) tcluster(year)
est store m1
cluster2 flogpatent   gs_frequency    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, fcluster(stkcd) tcluster(year)
est store m2
cluster2 flogcitation gs_frequency    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, fcluster(stkcd) tcluster(year)
est store m3
cluster2 flogpatent   gs_frequency rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, fcluster(stkcd) tcluster(year)
est store m4
cluster2 flogcitation gs_frequency rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*, fcluster(stkcd) tcluster(year)
est store m5
reg2docx m1 m2 m3 m4 m5 using cluster2_freq_regresult.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("IV results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")

//工具变量法
use 不确定性影响.dta,clear
sort stkcd accper
by stkcd:egen indus = sd(gs_nindcd)
egen gs_indus = std(indus)
replace gs_ind = - gs_indus

by stkcd:egen provi = sd(gs_pro)
egen gs_provi = std(provi)
replace gs_provi = - gs_provi

ivregress  2sls frd          (gs_adjust=gs_ind gs_provi)    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
ivregress  2sls flogpatent   (gs_adjust=gs_ind gs_provi)    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
ivregress  2sls flogcitation (gs_adjust=gs_ind gs_provi)    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
ivregress  2sls flogpatent   (gs_adjust=gs_ind gs_provi) rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
ivregress  2sls flogcitation (gs_adjust=gs_ind gs_provi) rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5
reg2docx m1 m2 m3 m4 m5 using IV_adjust_regresult1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("IV results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")

ivregress  2sls frd          (gs_frequency=gs_ind gs_provi)    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
ivregress  2sls flogpatent   (gs_frequency=gs_ind gs_provi)    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
ivregress  2sls flogcitation (gs_frequency=gs_ind gs_provi)    logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
ivregress  2sls flogpatent   (gs_frequency=gs_ind gs_provi) rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
ivregress  2sls flogcitation (gs_frequency=gs_ind gs_provi) rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5
reg2docx m1 m2 m3 m4 m5 using IV_freq_regresult1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("IV results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")

//管理层短视
cd "E:\学术论文\C论文\创新激励\实证数据和代码"
use 补贴政策不确定性合并发明高管.dta,clear
drop _merge
merge 1:1 _ID year using shortinv_ratio.dta
keep if _merge == 3
egen shortinv = std(shortinv_ratio)
drop shortinv_ratio
rename shortinv short_sight
save short_不确定性数据.dta,replace

use short_不确定性数据.dta,clear
reg frd          gs_adjust c.gs_adjust#c.short_sight short_sight logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
reg flogpatent   gs_adjust c.gs_adjust#c.short_sight short_sight logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
reg flogcitation gs_adjust c.gs_adjust#c.short_sight short_sight logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
reg flogpatent   gs_adjust c.gs_adjust#c.short_sight short_sight rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
reg flogcitation gs_adjust c.gs_adjust#c.short_sight short_sight rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5

reg2docx m1 m2 m3 m4 m5 using short_sight_adjust_regresult1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("SOE调整力度交互 results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")
//管理层短视与调整频率交互 不显著
reg frd          gs_frequency c.gs_frequency#c.short_sight short_sight logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
reg flogpatent   gs_frequency c.gs_frequency#c.short_sight short_sight logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
reg flogcitation gs_frequency c.gs_frequency#c.short_sight short_sight logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
reg flogpatent   gs_frequency c.gs_frequency#c.short_sight short_sight rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
reg flogcitation gs_frequency c.gs_frequency#c.short_sight short_sight rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5

reg2docx m1 m2 m3 m4 m5 using short_sight_freq_regresult1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("SOE调整频率交互 results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")

//边际效应图
reg flogpatent   gs_adjust c.gs_adjust#c.short_sight short_sight logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
marginscontplot2 short_sight gs_adjust, at1(-0.3(1)6.6) at2(-1.45(0.6)0.9053)

reg flogpatent   gs_frequency c.gs_frequency#c.short_sight short_sight logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
marginscontplot2 short_sight gs_frequency,at1(-0.3(1)6.6) at2(-0.39(1.9)7.2)

//分析师机制
use 不确定性影响.dta,clear
reg frd          gs_adjust c.gs_adjust#c.anal_no anal_no logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
reg flogpatent   gs_adjust c.gs_adjust#c.anal_no anal_no logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
reg flogcitation gs_adjust c.gs_adjust#c.anal_no anal_no logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
reg flogpatent   gs_adjust c.gs_adjust#c.anal_no anal_no rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
reg flogcitation gs_adjust c.gs_adjust#c.anal_no anal_no rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5

reg2docx m1 m2 m3 m4 m5 using anal_no_adjust_regresult.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")
//调整频率交互
reg frd          gs_frequency c.gs_frequency#c.anal_no anal_no logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
reg flogpatent   gs_frequency c.gs_frequency#c.anal_no anal_no logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
reg flogcitation gs_frequency c.gs_frequency#c.anal_no anal_no logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
reg flogpatent   gs_frequency c.gs_frequency#c.anal_no anal_no rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
reg flogcitation gs_frequency c.gs_frequency#c.anal_no anal_no rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5

reg2docx m1 m2 m3 m4 m5 using anal_no_freq_regresult.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")

//边际效应图
reg flogpatent   gs_adjust c.gs_adjust#c.anal_no anal_no logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
marginscontplot2 anal_no gs_adjust, at1(0(5)60) at2(-29.31(8)0.0906)

reg flogpatent   gs_frequency c.gs_frequency#c.anal_no anal_no logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
marginscontplot2 anal_no gs_frequency,at1(0(5)60) at2(-0.39(1.9)7.2)

//机构投资者
use 不确定性影响.dta,clear
reg frd          gs_adjust c.gs_adjust#c.ins_proportion ins_proportion logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
reg flogpatent   gs_adjust c.gs_adjust#c.ins_proportion ins_proportion logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
reg flogcitation gs_adjust c.gs_adjust#c.ins_proportion ins_proportion logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
reg flogpatent   gs_adjust c.gs_adjust#c.ins_proportion ins_proportion rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
reg flogcitation gs_adjust c.gs_adjust#c.ins_proportion ins_proportion rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5

reg2docx m1 m2 m3 m4 m5 using ins_proportion_adjust_regresult.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")
//调整频率交互
reg frd          gs_frequency c.gs_frequency#c.ins_proportion ins_proportion logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
reg flogpatent   gs_frequency c.gs_frequency#c.ins_proportion ins_proportion logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
reg flogcitation gs_frequency c.gs_frequency#c.ins_proportion ins_proportion logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
reg flogpatent   gs_frequency c.gs_frequency#c.ins_proportion ins_proportion rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
reg flogcitation gs_frequency c.gs_frequency#c.ins_proportion ins_proportion rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5

reg2docx m1 m2 m3 m4 m5 using ins_proportion_freq_regresult.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")

//研发意愿
use short_不确定性数据.dta,clear
reg frd          gs_adjust c.gs_adjust#c.short_sight short_sight logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
reg flogpatent   gs_adjust c.gs_adjust#c.short_sight short_sight logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
reg flogcitation gs_adjust c.gs_adjust#c.short_sight short_sight logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
reg flogpatent   gs_adjust c.gs_adjust#c.short_sight short_sight rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
reg flogcitation gs_adjust c.gs_adjust#c.short_sight short_sight rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5

reg2docx m1 m2 m3 m4 m5 using short_sight_adjust_regresult1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("SOE调整力度交互 results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")
//管理层短视与调整频率交互 不显著
reg frd          gs_frequency c.gs_frequency#c.short_sight short_sight logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m1
reg flogpatent   gs_frequency c.gs_frequency#c.short_sight short_sight logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m2
reg flogcitation gs_frequency c.gs_frequency#c.short_sight short_sight logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m3
reg flogpatent   gs_frequency c.gs_frequency#c.short_sight short_sight rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m4
reg flogcitation gs_frequency c.gs_frequency#c.short_sight short_sight rd logassets logppe_emp return tobinq lev logtenure logage logedu ind_dummy_* _Iyear_*
est store m5

reg2docx m1 m2 m3 m4 m5 using short_sight_freq_regresult1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("SOE调整频率交互 results") /// 
mtitles("rd" "patent" "citation" "patent" "citation") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=ind_dummy_*" "year=_Iyear_*")
