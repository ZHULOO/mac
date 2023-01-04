//

cd "E:\BaiduNetdiskWorkspace\others'data\yaping"
import excel using "数据7.12.xlsx",case(lower) first clear
labone,nrow(1)
drop in 1
destring,replace


//回归之前:
//删除年龄中的年份数据:
keep if hjnl_sl < 100
	/*生成二次项进行回归
	gen bkld2 = bkld^2 
	gen qbldpcgn2 = qbldpcgn^2*/
//生成本科大学层次变量
//levelsof bkcc,sep(,)
gen bklb= 1 if bkcc == "专科" | bkcc == "中专" | bkcc == "自考"
replace bklb =3 if bkcc == "211"
replace bklb =4 if bkcc == "985" |bkcc == "香港"
replace bklb =2 if bklb ==.
replace hjnl_xs = hjnl_xs + 4
save data1.dta,replace
save data2.dta,replace

//相关系数表
corr2docx hjnl_sl hjnl_xs bkld kqyld kfyqld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm sfys sex jxlx  jgxz ///
using corrresults.docx, replace star pearson(pw) spearman(ignore) ///
title("相关系数表") note("By ZHULOO") landscape 

//描述统计表
sum2docx hjnl_sl hjnl_xs bkld kqyld kfyqld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm sfys sex jxlx  jgxz ///
using sumresults1.docx,replace stats(N mean(%9.2f) sd skewness kurtosis min(%9.2f) ///
median max(%9.2f)) title("描述统计表")

//基本回归:
//在进行模型回归前，我们先看下因变量的分布情况:
histogram hjnl_sl,discrete freq
histogram hjnl_xs,discrete freq
kdensity hjnl_sl
kdensity hjnl_xs
sum hjnl_sl 
//均值为标准差的9倍,过度分散,考虑负二项回归,样本量足够大,也可以直接用泊松回归;
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz,r 
estimates store m1
//reg hjnl_sl kqyld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz,r
//estimates store m2
reg hjnl_sl kfyqld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz,r
estimates store m3

reg hjnl_xs bkld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz,r
estimates store m4
//reg hjnl_xs kqyld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz,r
//estimates store m5
reg hjnl_xs kfyqld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz,r
estimates store m6

reg2docx m1 m3 m4 m6 using regresult1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
depvar order(bkld kqyld kfyqld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm) ///
note("(* 0.1 ** 0.05 *** 0.01)") landscape

cd "E:\BaiduNetdiskWorkspace\others'data\yaping"
use data1.dta,clear
keep if bkld != .
//
bysort bkld:sum hjnl_sl
//子样本回归
//学科大类子样本 不显著
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz if xkdl == 1,r 
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz if xkdl == 2,r
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz if xkdl == 3,r
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz if xkdl == 4,r
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz if xkdl == 5,r

//自然科学 不显著
keep if xkdl == 1
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz ,r 
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz if zrkx == 1,r 
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz if zrkx == 2,r
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz if zrkx == 3,r
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz if zrkx == 4,r
reg hjnl_sl bkld  i.zrkx c.bkld#i.zrkx gshjsl bkxxcxnl scdjnf xkdl hjcs bkpm i.sfys i.sex i.jxlx i.jgxz,r

//方差分析
anova hjnl_sl i.bkld 
anova hjnl_sl i.zrkx
anova hjnl_sl i.bkld i.zrkx i.bkld#i.zrkx
i.bkld#i.zrkx
//工程技术类 显著
use data1.dta,clear
keep if xkdl == 2
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz,r
estimates store m1
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz if gcjsfl == 1,r 
estimates store m2
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz if gcjsfl == 2,r
estimates store m3
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz if gcjsfl == 3,r
estimates store m4
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf hjcs bkpm i.sfys i.sex i.jxlx  i.jgxz if gcjsfl == 4,r
estimates store m5
reg2docx m1 m2 m3 m4 m5 using regresult2.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
depvar  note("(* 0.1 ** 0.05 *** 0.01)") landscape ///
order(bkld gshjsl bkxxcxnl scdjnf hjcs bkpm)

//稳健性检验
use data2.dta,clear
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf xkdl hjcs i.sfys i.sex i.jxlx  i.jgxz,r 
estimates store m1
reg hjnl_sl kfyqld gshjsl bkxxcxnl scdjnf xkdl hjcs i.sfys i.sex i.jxlx  i.jgxz,r
estimates store m2

reg hjnl_xs bkld gshjsl bkxxcxnl scdjnf xkdl hjcs i.sfys i.sex i.jxlx  i.jgxz,r
estimates store m3
reg hjnl_xs kfyqld gshjsl bkxxcxnl scdjnf xkdl hjcs i.sfys i.sex i.jxlx  i.jgxz,r
estimates store m4

reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf hjcs i.sfys i.sex i.jxlx  i.jgxz if hjqzyld != 1,r
estimates store m5
reg hjnl_sl bkld gshjsl bkxxcxnl scdjnf hjcs i.sfys i.sex i.jxlx  i.jgxz if hjqfyqld != 1,r
estimates store m6
 

reg2docx m1 m2 m3 m4 m5 m6 using regresult3_1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("稳健性检验") ///
depvar  note("(* 0.1 ** 0.05 *** 0.01)") ///
order(bkld gshjsl bkxxcxnl scdjnf hjcs)

//异质性分析
reg hjnl_sl bkld c.bkld#i.hjzqldzw gshjsl bkxxcxnl scdjnf xkdl hjcs i.sfys i.sex i.jxlx  i.jgxz,r 
estimates store m1
reg hjnl_sl bkld c.bkld#i.mzrc gshjsl bkxxcxnl scdjnf xkdl hjcs i.sfys i.sex i.jxlx  i.jgxz,r 
estimates store m2
reg hjnl_sl bkld c.bkld#i.bklb gshjsl bkxxcxnl scdjnf xkdl hjcs i.sfys i.sex i.jxlx  i.jgxz,r 
estimates store m3
reg2docx m1 m2 m3 using regresult4_1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("异质性分析") ///
depvar  note("(* 0.1 ** 0.05 *** 0.01)") ///
order(bkld gshjsl bkxxcxnl scdjnf hjcs)




//2021-11-19新
cd "E:\BaiduNetdiskWorkspace\others'data\yaping"
import excel using "回归数据11.18.xlsx",case(lower) first clear
br
labone,nrow(1)
drop in 1
destring,replace
save 11_18.dta

//实证1、	全部流动频次对成才时间的影响
//全部变量 ccsj czzq qgld bkld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts gzddb jqld xkxf ys ldzw mzrc bkcc bscc dyh bh ///
//相关系数表
corr2docx ccsj czzq qgld bkld xl hwjl lxjy jgnl hjcs jxlx xkdl jgxz ///
using corrresults11_19.docx, replace star pearson(pw) spearman(ignore) ///
title("相关系数表") landscape 

//描述统计表
sum2docx ccsj czzq qgld bkld xl hwjl lxjy jgnl hjcs xb jxlx xkdl jgxz gzdts gzddb jqld xkxf ys ldzw mzrc bkcc bscc dyh bh ///
using sumresults11_19.docx,replace stats(N mean(%9.2f) sd skewness kurtosis min(%9.2f) ///
median max(%9.2f)) title("描述统计表")

//主回归1
twoway (scatter ccsj qgld, msymbol(+) msize(*0.4) mcolor(black*0.3))
rdplot ccsj qgld, c(3) p(1) graph_options(title(线性拟合))   // 线性拟合图
rdplot ccsj qgld, c(3.7) p(2) graph_options(title(二次型拟合)) //二次型拟合图

asdoc reg ccsj qgld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts, save(regresult_11_19.doc)


//稳健性
reg ccsj qgld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts,r
estimates store m1
reg ccsj qgld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts if xkdl == 2 
estimates store m2
reg ccsj bkld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
estimates store m3
reg ccsj qgld xl hwjl lxjy jgnl ys xb jxlx hjnf xkxf jgxz gzdts
estimates store m4
reg ccsj qgld xl hwjl lxjy jgnl ys xb jxlx hjnf xkdl jgxz gzdts
estimates store m5

reg2docx m1 m2 m3 m4 m5 using regresult11_22.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
depvar note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("state=*state" "year=year*") landscape ///
order(qgld bkld)


//异质性
reg ccsj qgld c.qgld#i.ldzw xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
estimates store m1
// reg ccsj qgld c.qgld#i.mzrc xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
// estimates store m2
reg ccsj qgld c.qgld#i.bkcc xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts if bkcc !=4
estimates store m2
// reg ccsj qgld c.qgld#i.bsfc xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
// estimates store m2
reg ccsj qgld c.qgld#i.dyh xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
estimates store m3
// reg ccsj qgld c.qgld#i.bh xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
// estimates store m2
reg ccsj qgld c.qgld#i.gzddb xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
estimates store m4

reg2docx m1 m2 m3 m4 using regresult11_22_r.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
depvar note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("state=*state" "year=year*") landscape

//内生性
ivregress 2sls ccsj (qgld=qgky) xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts gzddb,first
estat firststage

//2021-11-23 实证二
cd "E:\BaiduNetdiskWorkspace\others'data\yaping"
import excel using "11.23.xlsx",case(lower) first clear
br
labone,nrow(1)
drop in 1
destring,replace
save 11_23.dta

//合并
use 11_18.dta,clear
merge 1:1 name using 11_23.dta
drop _merge
save 11_18_23.dta
//11.25再合并
cd "E:\BaiduNetdiskWorkspace\others'data\yaping"
import excel using "11.25.xlsx",case(lower) first clear
br
labone,nrow(1)
drop in 1
destring,replace
save 11_25.dta

use "11_18_23.dta",clear
merge 1:1 name using 11_25.dta
drop _merge
save 11_18_23_25.dta

//11.25 比较工作地几类之间的差异
use 11_18_23_25.dta,clear
//回归
asdoc reg ccsj ib(1).gzdts if gzdts != 4, save(gzdts.doc)
asdoc reg ccsj ib(3).gzdts if gzdts != 4, save(gzdts.doc) append

asdoc reg ccsj ib(4).gzdts, save(gzdts_4b.doc)
asdoc reg ccsj ib(3).gzdts if gzdts != 4, save(gzdts.doc) append



//
asdoc reg ccsj ib(1).dnd if dnd == 1 | dnd == 2, save(gzdts.doc) append
 

//描述 astx命令
bysort gzdts: sum ccsj
astx ccsj, stat(mean sd median min max) by(gzdts)  //输出到excel表格
astx ccsj, stat(mean sd median min max) by(dnd)

//按gzdts分类描述统计:
asdoc sum ccsj, stat(N mean sd median min max) by(gzdts) save(gzdts_sum.doc) //输出到word格式
asdoc sum ccsj, stat(N mean sd median min max) by(dnd) save(dnd_sum.doc)



//2022-1-17
cd "E:\BaiduNetdiskWorkspace\others'data\yaping"
import excel using "职务晋升.xlsx",case(lower) first clear
br
labone,nrow(1)
drop in 1
destring,replace
save 职务晋升.dta,replace
asdoc reg zwjs qgld zwdts zwddb xl hwjl lxjy xb bh dwcc dj, save(职务晋升.doc) append


cd "E:\BaiduNetdiskWorkspace\others'data\yaping"
import excel using "职称晋升.xlsx",case(lower) first clear
labone,nrow(1)
drop in 1
destring,replace
save 职称晋升.dta,replace
use 职称晋升.dta,clear
asdoc reg jszq qgld zcddb rzxl xb lxjy rzbh zcdts xl hwjl gxcc dj, save(职称晋升.doc) append


cd "E:\BaiduNetdiskWorkspace\others'data\yaping"
import excel using "成才时间.xlsx",case(lower) first clear
br
labone,nrow(1)
drop in 1
destring,replace
rename b name
keep name dzx dj csdedu
save 成才时间.dta,replace


//2022-1-17
// 使用11_18.dta加入以下三个新变量
//合并dzx,dj,csdedu
use 11_18.dta,clear
merge 1:1 name using 成才时间.dta
keep if _merge == 3
drop _merge
//实证1、	全部流动频次对成才时间的影响
//全部变量 ccsj czzq qgld bkld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts gzddb jqld xkxf ys ldzw mzrc bkcc bscc dyh bh ///
//相关系数表
corr2docx ccsj czzq qgld bkld xl hwjl lxjy jgnl hjcs jxlx xkdl jgxz dzx dj ///
using corrresults1_17.docx, replace star pearson(pw) spearman(ignore) ///
title("相关系数表") landscape 

//描述统计表
sum2docx ccsj czzq qgld bkld xl hwjl lxjy jgnl hjcs xb jxlx xkdl jgxz gzdts gzddb jqld xkxf ys ldzw mzrc bkcc bscc dyh bh dzx dj ///
using sumresults1_17.docx,replace stats(N mean(%9.2f) sd skewness kurtosis min(%9.2f) ///
median max(%9.2f)) title("描述统计表")

//主回归1
asdoc reg ccsj qgld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts dzx dj, save(regresult_1_17.doc)


//稳健性
reg ccsj qgld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts dzx dj,r
estimates store m1
reg ccsj qgld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts dzx dj if xkdl == 2 
estimates store m2
reg ccsj bkld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts dzx dj
estimates store m3
reg ccsj qgld xl hwjl lxjy jgnl ys xb jxlx hjnf xkdl jgxz gzdts dzx dj
estimates store m4
reg ccsj qgld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkxf jgxz gzdts dzx dj
estimates store m5

reg2docx m1 m2 m3 m4 m5 using regresult1_17_robust.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
depvar note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("state=*state" "year=year*") landscape ///
order(qgld bkld)


//异质性
reg ccsj qgld c.qgld#i.ldzw xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
estimates store m1
// reg ccsj qgld c.qgld#i.mzrc xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
// estimates store m2
reg ccsj qgld c.qgld#i.bkcc xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts if bkcc !=4
estimates store m2
// reg ccsj qgld c.qgld#i.bsfc xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
// estimates store m2
reg ccsj qgld c.qgld#i.dyh xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
estimates store m3
// reg ccsj qgld c.qgld#i.bh xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
// estimates store m2
reg ccsj qgld c.qgld#i.gzddb xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
estimates store m4

reg2docx m1 m2 m3 m4 using regresult11_22_r.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
depvar note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("state=*state" "year=year*") landscape

//2022_1_20
cd "E:\BaiduNetdiskWorkspace\others'data\yaping"
import excel using "1.18.xlsx",case(lower) first clear
br
labone,nrow(1)
drop in 1
destring,replace
keep b cczqbs fyqld jqxl
rename b name
save 1_18.dta,replace
use 11_18.dta,clear
merge 1:1 name using 成才时间.dta
keep if _merge == 3
drop _merge
merge 1:1 name using 1_18.dta
drop _merge

//
asdoc 
reg cczqbs fyqld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts dzx dj


reg ccsj qgld hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts dzx dj
estat vif

, save(regresult_1_17.doc)


keep if xl == 3
corr2docx cczqbs qgld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts dzx dj using corrresults_1_20.docx,landscape replace


//内生性
ivregress 2sls ccsj (qgld=csdedu) xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts gzddb dzx dj,first r
ivregress liml ccsj (qgld=csdedu) xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts gzddb dzx dj,first r
ivreg2 ccsj (qgld=csdedu) xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts gzddb dzx dj,first r

estat firststage

//2022.3.24
cd "E:\BaiduNetdiskWorkspace\others'data\yaping"
import excel using "3.24.xlsx",case(lower) first clear
br
labone,nrow(1)
drop in 1
destring,replace
save 3_24.dta,replace
use 3_24.dta,clear

//删除获奖前是院士的样本

//回归
asdoc reg zgcczz i.qbld xlcc hwjl lxedu gender jghjnl jxlx schjnf xklb hjjgxz, save(regresult_3_24_1.doc)
asdoc reg bkcczq i.qbld xlcc hwjl lxedu gender jghjnl jxlx schjnf xklb hjjgxz, save(regresult_3_24_2.doc) 
asdoc reg bkcczq i.hjdts xlcc hwjl lxedu gender jghjnl jxlx schjnf xklb hjjgxz, save(regresult_3_24_3.doc)
asdoc reg zgcczz i.hjdts xlcc hwjl lxedu gender jghjnl jxlx schjnf xklb hjjgxz, save(regresult_3_24_4.doc)


reg zccsj sfks xlcc sfys hwjl lxedu gender jghjnl jxlx schjnf xklb hjjgxz jxcs djtz

reg zccsj qbld xlcc sfys hwjl lxedu gender jghjnl jxlx schjnf xklb hjjgxz jxcs djtz
estimates store m1
reg zccsj hjdts xlcc sfys hwjl lxedu gender jghjnl jxlx schjnf xklb hjjgxz jxcs djtz
estimates store m1
reg zccsj hjdts hjddb xlcc sfys hwjl lxedu gender jghjnl jxlx schjnf xklb hjjgxz jxcs djtz if sfks == 1
estimates store m1



reg zccsj hjdts xlcc sfys hwjl lxedu gender jghjnl jxlx schjnf xklb hjjgxz jxcs djtz
estimates store m2
reg zccsj hjddb xlcc sfys hwjl lxedu gender jghjnl jxlx schjnf xklb hjjgxz jxcs djtz
estimates store m3
reg2docx m1 m2 m3 using regresult_3_24.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("col1 col2 col3") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("state=*state" "year=year*") order(qgld bkld) landscape



//2022-1-17---------------------------->3-24
// 使用11_18.dta加入以下三个新变量
//合并dzx,dj,csdedu
use 11_18.dta,clear
merge 1:1 name using 成才时间.dta
keep if _merge == 3
drop _merge
//实证1、	全部流动频次对成才时间的影响
//全部变量 ccsj czzq qgld bkld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts gzddb jqld xkxf ys ldzw mzrc bkcc bscc dyh bh ///
//相关系数表
corr2docx ccsj czzq qgld bkld xl hwjl lxjy jgnl hjcs jxlx xkdl jgxz dzx dj ///
using corrresults1_17.docx, replace star pearson(pw) spearman(ignore) ///
title("相关系数表") landscape 

//描述统计表
sum2docx ccsj czzq qgld bkld xl hwjl lxjy jgnl hjcs xb jxlx xkdl jgxz gzdts gzddb jqld xkxf ys ldzw mzrc bkcc bscc dyh bh dzx dj ///
using sumresults1_17.docx,replace stats(N mean(%9.2f) sd skewness kurtosis min(%9.2f) ///
median max(%9.2f)) title("描述统计表")

//主回归1
asdoc reg ccsj i.qgld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts dzx dj, save(regresult_3_24.doc)
asdoc reg ccsj i.qgld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz ib(4).gzdts dzx dj, save(regresult_3_24.doc)
reg ccsj qgld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts dzx dj
reg ccsj qgld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts dzx


reg ccsj i.qgld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts gzddb dzx



//3-25
asdoc reg ccsj i.qgld xl hwjl lxjy jgnl xb jxlx hjnf xkdl jgxz dzx, save(regresult_1_18_1.doc)

asdoc reg ccsj ib(4).gzdts xl hwjl lxjy jgnl xb jxlx hjnf xkdl jgxz dzx, save(regresult_1_18_2.doc)


//
asdoc reg hjcs i.qgld xl hwjl lxjy jgnl xb jxlx hjnf xkdl jgxz dzx, save(regresult_1_18_3.doc)

asdoc reg hjcs ib(4).gzdts xl hwjl lxjy jgnl xb jxlx hjnf xkdl jgxz dzx, save(regresult_1_18_4.doc)


//
reg czzq i.qgld xl hwjl lxjy jgnl xb jxlx hjnf xkdl jgxz dzx

reg czzq ib(4).gzdts xl hwjl lxjy jgnl xb jxlx hjnf xkdl jgxz dzx






//稳健性
reg ccsj i.qgld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts dzx dj,r
estimates store m1
reg ccsj i.qgld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts dzx dj if xkdl == 2 
estimates store m2
reg ccsj i.bkld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts dzx dj
estimates store m3
reg ccsj i.qgld xl hwjl lxjy jgnl ys xb jxlx hjnf xkdl jgxz gzdts dzx dj
estimates store m4
reg ccsj i.qgld xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkxf jgxz gzdts dzx dj
estimates store m5

reg2docx m1 m2 m3 m4 m5 using regresult1_17_robust.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
depvar note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("state=*state" "year=year*") landscape ///
order(qgld bkld)


//异质性
reg ccsj i.qgld i.qgld#i.ldzw xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
estimates store m1
// reg ccsj qgld c.qgld#i.mzrc xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
// estimates store m2
reg ccsj qgld c.qgld#i.bkcc xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts if bkcc !=4
estimates store m2
// reg ccsj qgld c.qgld#i.bsfc xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
// estimates store m2
reg ccsj qgld c.qgld#i.dyh xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
estimates store m3
// reg ccsj qgld c.qgld#i.bh xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
// estimates store m2
reg ccsj qgld c.qgld#i.gzddb xl hwjl lxjy jgnl hjcs xb jxlx hjnf xkdl jgxz gzdts
estimates store m4

reg2docx m1 m2 m3 m4 using regresult11_22_r.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
depvar note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("state=*state" "year=year*") landscape
