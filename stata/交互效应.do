*****交互效应*****

 cd "E:\stata\吴愈晓《应用线性回归分析》全六讲材料及对应PPT\吴愈晓《应用线性回归分析》全六讲材料及对应PPT\吴愈晓订阅课 第四讲材料及对应PPT"
** Sample do file for lecture4
** 交互效应模型
** Yuxiao Wu, Jan 15th, 2019

clear
drop _all
capture log close
log using lecture4.log, replace

use cgss2010s, clear


global xlist s5-misei

foreach v of varlist $xlist {
	replace `v'=. if `v'<0
}


* 处理教育变量：类别（程度）和连续（年限）
tab edu
tab edu, nol
recode edu 1/3=1 4=2 5/8=3 9/13=4 *=3, g(school)
tab school
recode edu -3 14=. 1=0 2=2 3=6 4=9 5=11 6 7=12 8=11 9 10=15 ///
	11 12=16 13=20, g(educ_y)
tab educ_y

* 年龄
gen age=2010-y_birth
sum age

* 性别
gen male=sex==1

* 政治面貌
tab poleve
gen party=polevel==1
tab party

* 对收入变量进行均值替代
bysort school: egen minc=mean(ytincome)
tab minc
bysort school: replace ytincome=minc if ytincome==.
sum ytincome

sum ytincome
gen lninc=log(ytincome+1)
gen inc10k=ytincome/10000

drop if height<140 /*删除奇异值*/
keep if age<=70


**交互模型：interaction effects

* interaction model (I)：两个虚拟变量的交互
gen male_p=male*party
gen wage=ywincome/12
drop if wage>30000 & wage!=. /*drop the outliers*/

reg wage male party male_p
tab male party, sum(wage) nost nof

reg wage male if party==0
reg wage male if party==1
reg wage party if male==0
reg wage party if male==1
reg wage male##party

* interaction model (II)：连续变量与虚拟变量的交互
gen feduy_m=feduy*male
reg educ_y feduy male feduy_m
reg educ_y c.feduy##male
predict y
sum y if feduy==0 & male==0
sum y if feduy==0 & male==1

twoway (scatter educ_y feduy) (lfit educ_y feduy if male==0) ///
	(lfit educ_y feduy if male==1)

* Margins plot
reg educ_y c.feduy##male b1.region
margins male, at(feduy=(0(2)20))
marginsplot, noci 
marginscontplot2 feduy male //该命令更简单

* interaction model (IIa) 连续变量和多类别虚拟变量的交互,region变量有三个类别
tab region, gen(region)
gen inter1=region2*educ_y
gen inter2=region3*educ_y
reg wage educ_y region2 region3 inter1 inter2

reg wage b1.region##c.educ_y
reg wage b2.region##c.educ_y
reg wage b3.region##c.educ_y
twoway (scatter wage educ_y) (lfit wage educ_y if region==1) ///
	(lfit wage educ_y if region==2) (lfit wage educ_y if region==3)

* Margins plot
reg wage b1.region##c.educ_y
margins region, at(educ_y=(0(2)20))
marginsplot, noci
marginscontplot2 educ_y region

* interaction model (III)：两个连续变量的交互
gen age_e=age*educ_y
reg wage educ_y age age_e
reg wage c.educ_y##c.age

* margins plot
reg wage c.educ_y##c.age
marginscontplot2 educ_y age,at2(20(20)60) //不同级别的age分组下,educ_y对wage正向的作用减弱;
marginscontplot2 age educ_y,at2(0(5)20)   //不同的educ_y分组下,age对wage的正向作用减弱;

margins, at(educ_y=(0(2)20) age=(20(10)60))
_marg_save, saving(temp1, replace)
preserve
use temp1, clear
tw contour _margin _at1 _at2, ccut(-1000(500)5000) crule(lin) sc(gs15) ec(gs2) saving(g1, replace)
restore

log close
exit
