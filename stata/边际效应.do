***margins***
	help margins
* margins example
// Examples: obtaining margins of responses

    //Setup
  		cd E:\data\margins
        webuse margex,clear
        save margex.dta,replace
        use margex,clear

    //A simple case after regress
    	regress y i.sex 
    	matrix list e(b)
    	ereturn list
    	bysort sex:summarize(y)
    	margins sex
    	margins,dydx(sex)
    	scalar c = r(b)[1,2] - r(b)[1,1]
    	display c
    	regress y i.sex 


        regress y i.sex i.group
        margins sex

    //A simple case after logistic
        logistic outcome i.sex i.group
        margins sex

    //Average response versus response at average
        margins sex
        margins sex, atmeans

    //Multiple margins from one margins command
        margins sex group

    //Margins with interaction terms
        logistic outcome i.sex i.group sex#group
        margins sex group

    //Margins with continuous variables
        logistic outcome i.sex i.group sex#group age
        margins sex group

    //Margins of continuous variables
        logistic outcome i.sex i.group sex#group age
        margins sex group
        margins, at(age=40)
        margins, at(age=(30 35 40 45 50))
    //Or, equivalently
        margins, at(age=(30(5)50))

    //Margins of interactions
        margins sex#group

    //Margins of a specified prediction
        tobit ycn i.sex i.group sex#group age, ul(90)
        margins sex, predict(ystar(.,90))
        margins sex

    Margins of a specified expression
        margins sex, expression( predict(ystar(.,90)) / predict(xb) )

    Margins with multiple outcomes (responses)
        mlogit group i.sex age
        margins sex
        margins sex, predict(outcome(1))

    Margins with multiple equations
        sureg (y = i.sex age) (distance = i.sex i.group)
        margins sex
        margins sex, predict(equation(y))
        margins sex, expression(predict(equation(y)) - predict(equation(distance)))

    Margins evaluated out of sample
        webuse margex
        tobit ycn i.sex i.group sex#group age, ul(90)
        webuse peach
        margins sex, predict(ystar(.,90)) noesample


Examples: obtaining marginal effects

    Setup
        webuse margex
        logistic outcome treatment##group age c.age#c.age treatment#c.age

    Average marginal effect (partial effects) of one covariate
        margins, dydx(treatment)

    Average marginal effects of all covariates
        margins, dydx(*)

    Marginal effects evaluated over the response surface
        margins group, dydx(treatment) at(age=(20(10)60))


Examples: obtaining margins with survey data and representative samples

    Inferences for populations, margins of response
        webuse margex
        logistic outcome i.sex i.group sex#group age, vce(robust)
        margins sex group, vce(unconditional)

    Inferences for populations, marginal effects
        margins, dydx(*) vce(unconditional)

    Inferences for populations with svyset data
        webuse nhanes2
        svyset
        svy: logistic highbp sex##agegrp##c.bmi
        margins agegrp, vce(unconditional)


Examples: obtaining margins as though the data were balanced

    Setup
        webuse acmemanuf

    Balancing using asbalanced
        regress y pressure##temp
        margins, asbalanced

    Balancing nonlinear responses
        logistic acceptable pressure##temp
        margins, asbalanced

    Treating a subset of covariates as balanced
        webuse margex
        regress y arm##sex sex##agegroup
        margins, at((asbalanced) arm)
        margins, at((asbalanced) arm agegroup)
        margins, at((asbalanced) arm agegroup sex)

    Balancing in the presence of empty cells
        webuse estimability
        regress y sex##group
        margins sex, asbalanced
        margins sex, asbalanced emptycells(reweight)

* 1 借助margins命令计算边际效应：
	cd E:\data\margins
	clear 
	sysuse auto
	reg price c.mpg##c.length
	foreach v of var mpg length {
		sum `v' if e(sample)
		local low_`v' = r(mean) - r(sd)
		dis "low_`v'  = " `low_`v''
		local high_`v'= r(mean) + r(sd)
		dis "high_`v' = " `high_`v''
	}
	margins,at(mpg = (`low_mpg' `high_mpg') ///
			length = (`low_length' `high_length'))
	marginsplot,xlabel(`low_mpg' "LOW" `high_mpg' "HIGH") ///
				ytitle("mpg") ///
				ylabel(,angle(horizontal) nogrid) ///
				ytitle("price") ///
				legend(position(3) col(1) stack) ///
				title("Moderation") noci

* 2 手动计算边际效应的过程
//两个变量先乘积再回归的情况：
cd "e:/data"
sysuse nlsw88.dta,clear
gen grade_x_ttl = grade*ttl 	//先计算两个变量的乘积，然后作为一个整体进行回归：
reg wage grade ttl grade_x_ttl  //模型中变量的系数分别存储在矩阵b和V中;
ereturn list
matrix list e(V)
dis %4.2f sqrt(0.0173019) //计算grade系数的标准误;
//从矩阵中可以分别提取回归系数和它们的方差、协方差：
matrix b = e(b)
matrix V = e(V)
matrix list b
matrix list V
scalar b1 = b[1,1]
scalar b3 = b[1,3]
scalar varb1 = V[1,1]
scalar varb3 = V[3,3]
scalar covb1b3 = V[1,3]
scalar list
scalar list covb1b3 
//计算边际效应还要找到ttl的均值，然后带入边际效应公式
sum ttl
scalar ttl_mean = r(mean)
dis "margins = " b1+b3*ttl_mean
dis "Std.Err = " sqrt(varb1+2*ttl_mean*covb1b3+ttl_mean^2*varb3)
//绘制边际效应图：需要知道grade的边际效应随着ttl如何变化
//首先，要得到一系列变化的ttl的值，最小0.16，最大28.9，间隔0.01
set obs 2875
gen mvz = (_n+15)/100
//然后，分别计算每个mvz对应的X的边际效应、标准误以及置信区间：
gen bx = b1+b3*mvz
gen sebx = sqrt(varb1+varb3*mvz^2+2*mvz*covb1b3)
gen ax = 1.96*sebx
gen upbx = bx+ax
gen lowbx = bx-ax
//根据计算的值作出边际效应及其置信区间图：
gen where = -0.045
gen pipe = "|"
gen yline = 0
graph twoway hist ttl,width(0.5) percent color(gs14) yaxis(2) ///
	|| scatter where ttl,plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(pipe) mlabpos(6) legend(off) ///
	|| line bx mvz,lpattern(solid) lwidth(medium) lcolor(black) yaxis(1) ///
	|| line upbx mvz,lpattern(dash) lwidth(thin) lcolor(black) ///
	|| line lowbx mvz,lpattern(dash) lwidth(thin) lcolor(black) ///
	|| line yline mvz,lpattern(dash) lwidth(thin) lcolor(black) ///
	|| , ///
		xlabel(0 5 10 15 20 25 30,nogrid labsize(2)) ///
		ylabel(-0.2 0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6,axis(1) nogrid labsize(2)) ///
		ylabel(0 1 2 3 4 5,axis(2) nogrid labsize(2)) ///
		yscale(noline alt) ///
		yscale(noline alt axis(2)) ///
		xscale(noline) ///
		legend(off) ///
		xtitle("",size(2.5)) ///
		ytitle("",axis(2) size(2.5)) ///
		xsca(titlegap(2)) ///
		ysca(titlegap(2)) ///
		scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

// 直接交乘符号进行回归
cd "e:/data"
sysuse nlsw88.dta,clear
reg wage c.grade##c.ttl_exp     //直接交互项放入回归方程，
ereturn list
matrix list e(V)
matrix list e(b)

gen grade_x_ttl = grade*ttl 	//先计算两个变量的乘积，然后作为一个整体进行回归：
reg wage grade ttl grade_x_ttl
matrix list e(V)
matrix list e(b) 				//和上面的e(V)和e(b)相等，所以经过手动计算的边际效应是一样的；


//从矩阵中可以分别提取回归系数和它们的方差、协方差：
matrix b = e(b)
matrix V = e(V)
matrix list b
matrix list V
scalar b1 = b[1,1]
scalar b3 = b[1,3]
scalar varb1 = V[1,1]
scalar varb3 = V[3,3]
scalar covb1b3 = V[1,3]
scalar list
scalar list covb1b3 
//计算边际效应还要找到ttl的均值，然后带入边际效应公式
sum ttl
scalar ttl_mean = r(mean)
dis "margins = " b1+b3*ttl_mean
dis "Std.Err = " sqrt(varb1+2*ttl_mean*covb1b3+ttl_mean^2*varb3)
//绘制边际效应图：需要知道grade的边际效应随着ttl如何变化
//首先，要得到一系列变化的ttl的值，最小0.16，最大28.9，间隔0.01
set obs 2875
gen mvz = (_n+15)/100
//然后，分别计算每个mvz对应的X的边际效应、标准误以及置信区间：
gen bx = b1+b3*mvz
gen sebx = sqrt(varb1+varb3*mvz^2+2*mvz*covb1b3)
gen ax = 1.96*sebx
gen upbx = bx+ax
gen lowbx = bx-ax
//根据计算的值作出边际效应及其置信区间图：
gen where = -0.045
gen pipe = "|"
gen yline = 0
graph twoway hist ttl,width(0.5) percent color(gs14) yaxis(2) ///
	|| scatter where ttl,plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(pipe) mlabpos(6) legend(off) ///
	|| line bx mvz,lpattern(solid) lwidth(medium) lcolor(black) yaxis(1) ///
	|| line upbx mvz,lpattern(dash) lwidth(thin) lcolor(black) ///
	|| line lowbx mvz,lpattern(dash) lwidth(thin) lcolor(black) ///
	|| line yline mvz,lpattern(dash) lwidth(thin) lcolor(black) ///
	|| , ///
		xlabel(0 5 10 15 20 25 30,nogrid labsize(2)) ///
		ylabel(-0.2 0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6,axis(1) nogrid labsize(2)) ///
		ylabel(0 1 2 3 4 5,axis(2) nogrid labsize(2)) ///
		yscale(noline alt) ///
		yscale(noline alt axis(2)) ///
		xscale(noline) ///
		legend(off) ///
		xtitle("",size(2.5)) ///
		ytitle("",axis(2) size(2.5)) ///
		xsca(titlegap(2)) ///
		ysca(titlegap(2)) ///
		scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))


* margins命令图示边际效应在两种回归方程形势下的对比，grade*ttl_exp 和 grade#ttl_exp
sysuse nlsw88.dta,clear
sum grade ttl
gen grade_x_ttl = grade*ttl
eststo clear
eststo:reg wage grade ttl grade_x_ttl
eststo:reg wage c.ttl_exp##c.grade
esttab //可以看出两种形式的回归结果是一样的；

//先相乘再回归和交互项回归系数是一样的，但是二者的边际效应图是不一样的；
reg wage grade ttl grade_x_ttl //没有把相乘项当成交互项，而是当成第三个变量，所以做出的边际效应图是互项平行的；
margins,at(ttl_exp = (0.115 12.53 28.88) grade = (0 13 18)) //此时带入计算的是grade_x_ttl的平均值；
marginsplot,noci
dis (6.2563-0.934+0.144*0.115)/0.032
dis (9.52638-0.934-0.252*13+0.144*0.115)/0.032
marginscontplot2 ttl_exp grade,at1(0.115(4)28.88) at2(6(6)18)

reg wage c.ttl_exp##c.grade 
margins,at(ttl_exp = (0.115 12.53 28.88) grade = (0 13 18)) //此时是将二者的真实乘积带入计算
marginsplot,noci
dis 0.934-0.144*0.115
dis 0.934+0.252*13-0.144*0.155+0.032*0.115*13
marginscontplot2 ttl_exp grade,at1(0.115(4)28.88) at2(6(6)18)
 //两种回归方程的系数是相同的，当时用margins命令做边际效应图是不一样的，并且上面的一种情况是不对的。

//三个变量交乘的情况：
* 计算union=1时，grade的边际效应：
reg wage grade ttl grade_x_ttl if union == 1
matrix b_1 = e(b)
matrix V_1 = e(V)
scalar b1_1 = b_1[1,1]
scalar b3_1 = b_1[1,3]
scalar varb1_1 = V_1[1,1]
scalar varb3_1 = V_1[3,3]
scalar covb1b3_1 = V_1[1,3]

sum ttl if union == 1
scalar ttl_mean_1 = r(mean)
dis "Margins_1 = " b1_1+b3_1*ttl_mean_1
dis "Std.Err = " sqrt(varb1_1+varb3_1*ttl_mean_1^2+2*covb1b3_1)

set obs 2875
gen mvz = (_n+15)/100

gen bx_1 = b1_1+b3_1*mvz
gen sebx_1 = sqrt(varb1_1+varb3_1*mvz^2+2*mvz*covb1b3_1)
gen ax_1 = 1.96*sebx_1
gen upbx_1 = bx_1+ax_1
gen lowbx_1 = bx_1-ax_1

* 计算union=0时，grade的边际效应：
reg wage grade ttl grade_x_ttl if union == 0
matrix b_0 = e(b)
matrix V_0 = e(V)
scalar b1_0 = b_0[1,1]
scalar b3_0 = b_0[1,3]
scalar varb1_0 = V_0[1,1]
scalar varb3_0 = V_0[3,3]
scalar covb1b3_0 = V_0[1,3]

sum ttl if union == 0
scalar ttl_mean_0 = r(mean)
dis "Margins_1 = " b1_0+b3_0*ttl_mean_0
dis "Std.Err = " sqrt(varb1_0+varb3_0*ttl_mean_0^2+2*covb1b3_0)

gen bx_0 = b1_0+b3_0*mvz
gen sebx_0 = sqrt(varb1_0+varb3_0*mvz^2+2*mvz*covb1b3_0)
gen ax_0 = 1.96*sebx_0
gen upbx_0 = bx_0+ax_0
gen lowbx_0 = bx_0-ax_0

gen yline = 0
graph twoway line bx_1 mvz,lpattern(solid) lwidth(medium) lcolor(blue) ///
		  || line upbx_1 mvz,lpattern(dash) lwidth(thin) lcolor(blue) ///
		  || line lowbx_1 mvz,lpattern(dash) lwidth(thin) lcolor(blue) ///
		  || line bx_0 mvz,lpattern(solid) lwidth(medium) lcolor(red) ///
		  || line upbx_0 mvz,lpattern(dash) lwidth(thin) lcolor(red) ///
		  || line lowbx_0 mvz,lpattern(dash) lwidth(thin) lcolor(red) ///
		  || line yline mvz,lpattern(dash) lwidth(thin) lcolor(black) ///
		  || , ///
		  	xlabel(0 5 10 15 20 25 30,nogrid labsize(2)) ///
		  	ylabel(-0.2 0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6,nogrid labsize(2)) ///
		  	legend(off) ///
		  	xtitle("",size(2.5)) ///
		  	xsca(titlegap(2)) ///
		  	ysca(titlegap(2)) ///
		  	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

*自变量为虚拟变量的边际效应:
	cd E:\data\margins
	sysuse auto,clear
	reg mpg i.foreign weight
	margins foreign //foreign为虚拟变量,分别求出foreign=0,1时对mpg的边际效应
	margins weight  //出错，非分类变量；
	dis 21.78785-20.13782


	preserve
	replace foreign = 0 //将foreign=1的值替换为0,即22个Foreign(1)替换为Domestic(0)
	sum foreign
	predict margin0 	//计算mpg的估计值
	summarize margin0 	//估计值的均值
	restore

	preserve
	replace foreign = 1 //将foreign=0的值替换为1,即52个Domestic(0)替换为Foreign(1)
	predict margin1 	//计算mpg的估计值
	summarize margin1 	//估计值的均值
	restore

	regress mpg i.foreign##c.weight //存在交互项时的边际效应较复杂,但是虚拟变量的边际效应依然使用margins
	margins foreign //此时margins依然可以计算虚拟变量foreign的边际效应,但是连续性数值变量weight的边际效应无法计算:
	margins c.weight //提示仅仅因子变量和它们的交互效应才可以使用margins计算,连续性变量使用以下方法:
	margins,at(weight = 3000) //可以计算weight取一个值3000时的边际效应
	margins foreign,at(weight = 3000)

*自变量为连续数值型变量的边际效应:
 *此时自变量取值太多,无法估计自变量每一个取值对应的边际效应,使用marginsplot画图展示:
 	reg mpg i.foreign weight

 	margins foreign
 	marginsplot

 	margins,at(weight= (1760(100)4840)) //对应计算了weight取31个值的边际效应,并可以画图如下:
 	reg mpg i.foreign weight
 	//检查以下margins计算的边际效应和手动计算的边际效应是否相等：
 	preserve
 	margins,at(weight = 1760) //=29.59447
 	replace weight = 1760
 	predict margins_1760 
 	sum margins_1760
 	dis `r(mean)' 			  //=29.59447,手动计算的weight=1760时的边际效应和上面的margins,at(weight = 1760)相等；
 	dis 29.59447  //margins命令计算的weight=1760时的边际效应就相当于；
 	restore
 	marginsplot

 	margins foreign,at(weight = (1760(100)4840))
 	marginsplot //无交叉项，为加法模型，foreign=0或1的两条线是平行的；
 	marginscontplot2 weight foreign 

 	*marginscontplot命令可以画出连续性变量边际效应的图,外部命令需要安装:
 	sysuse auto,clear
 	marginscontplot weight,ci
 	regress mpg i.foreign##c.weight
 	marginscontplot weight, ci
 	marginscontplot2 weight, ci
 	marginscontplot weight,ci var1(20)	          //weight间隔20取值
 	marginscontplot2 weight,ci var1(20)	          
 	marginscontplot weight,ci at1(2000(500)4500)  //weight按照2000,2500,3000...4500范围取值
 	marginscontplot2 weight,ci at1(2000(500)4500)  
 	marginscontplot weight,ci at1(%1 10 25 50 75 90 95(1)99)
 	marginscontplot2 weight,ci at1(%1 10 25 50 75 90 95(1)99)
 	marginscontplot weight,ci margopts(predict(xb))
 	marginscontplot2 weight,ci margopts(predict(xb))
 	*生存分析案例:
 	cd e:/data
 	webuse brcancer.dta,clear
 	save brcancer.dta,replace
 	stset rectime,failure(censrec)
 	stcox x5e x6
 	marginscontplot x6,ci //x6的全部取值范围,此时是对log边际效应;
 	marginscontplot x6,ci at1(%1 10 25 50 75 90 95(1)99) //x6的1%至99%取值范围;
 	marginscontplot x6,ci margopts(predict(xb)) //predict(xb)线性边际效应预测;
 	*变形的x案例:
 	sysuse auto.dta,clear
 	generate logwt = ln(weight)
 	reg mpg logwt i.foreign c.logwt#i.foreign
 	twoway (scatter mpg logwt) (lfit mpg logwt)
 	marginscontplot logwt,ci //此时画出的是对log(weight)的边际效应,依然是直线,要想画出对weight的边际效应,使用下面的方法:
 	marginscontplot logwt foreign,ci //置信区间存在重合,会画到两个图中;
 	marginscontplot logwt foreign   //两个边际效应画到一个图中;


 	summarize weight
 	range w r(min) r(max) 20
 	generate logw = ln(w)
 	marginscontplot weight(logwt),var1(w(logw)) ci //weight以对数logwt进入方程,w是weight间隔20取出来的变量;
 												   //边际效应图以logw的范围画出,横轴变量和weight进入方程的形式(log)一致;
 	
	sysuse auto.dta,clear
	reg mpg weight i.foreign c.weight#i.foreign
	marginscontplot weight
	marginscontplot foreign weight //针对第二个变量weight的每一个取值,分别画许多个foreign的边际效应图;
	marginscontplot weight foreign //针对第二个变量的每一个取值foreign=0,1分别画两个weight的边际效应图;
	marginscontplot2 weight
	marginscontplot2 weight foreign
	marginscontplot2 weight foreign,ci

	*尝试sin形式：
	sysuse auto,clear
	gen sin_w = sin(weight)
	reg mpg sin_w i.foreign c.sin_w#i.foreign
	marginscontplot sin_w
	sum weight
	range w r(min) r(max) 20
	gen sinw = sin(w)
	marginscontplot weight(sin_w),var1(w(sinw))

 	*Fractional polynomials分数多项式形式的边际效应:
 	fracpoly:reg mpg weight foreign
 	summarize weight
 	range w r(min) r(max) 20
 	generate wa = (w/1000)^-2-0.1096835742
 	generate wb = (w/1000)^-2*ln(w/1000)-0.121208886
 	marginscontplot weight(Iweig__1 Iweig__2),var1(w(wa wb)) ci //分数多项式中weight的边际效应画到图中;weight和mpg复相关;
 	marginscontplot weight(Iweig__1 Iweig__2) foreign,var1(w(wa wb)) //以foreign分组,画出各组的weight边际效应图,(1/weight^2)和mpg正相关;

 	drop weight_1 weight_2

 	fracgen weight -2 -2
 	local fp2_weight `r(names)' //局部变量,作用区域很短.这些命令行必须一起运行,才能有作用;
 	display "`fp2_weight'"
 	reg mpg i.foreign `fp2_weight'
 	marginscontplot weight(`fp2_weight'),var1(20) ci

 *更复杂的回归边际效应案例:
 	cd e:/data
 	webuse nhanes2f.dta,clear
 	save nhanes2f.dta,replace
	gen map = (bpsystol+2*bpdiast)/3
	gen bmi = weight/((height/100)^2)
	fracgen age -2 -1
	reg map age_1 age_2 i.race bmi hgb race#c.(age_1 age_2) c.bmi#c.(age_1 age_2) c.hgb#c.(age_1 age_2)
		//复杂的回归模型,求出age的边际效应:
	marginscontplot age(age_1 age_2)     	//panel a age的边际效应;
	marginscontplot age(age_1 age_2) race 	//Panel b agexrace的边际效应;

	marginscontplot age(age_1 age_2) bmi,at1(20(2)30 35(5)60 70) at2(20(5)40) ///
	plotopts(lpattern(l - _ _- -.) lwidth(medthick ..) name(g4, replace) ///
	title("(c) Age x BMI", placement(west)) legend(label(1 "20") label(2 "25") ///
  	label(3 "30") label(4 "35") label(5 "40") row(1))) //Panel c agexbmi的边际效应;

  	marginscontplot age(age_1 age_2) hgb,at2(13(1)16) //Panel d

***marginscontplot2***
	help marginscontplot2 //安装
 *帮助文件中的案例:
	cd E:\data\margins
	copy E:\data\r15\nhanes2f.dta nhanes2f.dta,replace
	use nhanes2f.dta,clear
	gen map = (bpsystol+2*bpdiast)/3 //map,mean arterial pressure生成平均动脉压;
	regress map age i.race
	marginscontplot2 age race, ci //按种族分组显示age对map的边际效应图,ci显示置信区间;
	marginscontplot2 age race, ci areaopts(lcolor(cyan) lpattern(-)) //置信区域线cyan蓝绿色的,-虚线
	marginscontplot2 age race, ci areaopts(lcolor(cyan) lpattern(-)) lineopts(lcolor(red)) //lineopts中心线红色
	marginscontplot2 age race, ci areaopts(lcolor(cyan) lpattern(-)) lineopts(lcolor(red)) name(my_graph)
		//保存为my_graph名称
	marginscontplot2 age race, ci combopts(title(My graph) l1title(map) b2title(Age) saving(my_graph1, replace))
		//title(My graph)主标题,l1title(map)纵轴标题,b2title(Age)横轴标题,saving(my_graph1, replace)保存为my_graph1,combopts将上面选项联合在一起;
	marginscontplot2 age race, lineopts(lcolor(red cyan brown) lpattern(l . --))
		//lineopts中心拟合值线的选项,lcolor(red cyan brown)三条线三个颜色,lpattern(l - --)三种线型;三条线显示在一起;

 *Basic examples
    sysuse auto, clear
    regress mpg i.foreign weight
    marginscontplot2 weight, name(my_graph2)
    marginscontplot2 weight, at1(2000(100)4500) ci     //at1表示横轴weight的取值范围
    marginscontplot2 weight foreign, var1(20) //at2(0 1) //var1表示间隔20
    marginscontplot2 weight foreign, var1(20) at2(0 1) ci combopts(ycommon imargin(small))

*Example using a log-transformed covariate
    gen logwt = log(weight)
    regress mpg i.foreign c.logwt i.foreign#c.logwt
    summarize weight
    range w1 r(min) r(max) 20
    generate logw1 = log(w1)
    marginscontplot2 weight (logwt), var1(w1(logw1)) ci
    	//weight以logwt的形式回归,以w1(logw1)来分割weight(logwt);

*Example using a fractional polynomial model,分数多项式模型
    fracpoly: regress mpg weight foreign
    marginscontplot2 weight (Iweig__1 Iweig__2) foreign, var1(20) ci

*Example using the new fp fractional polynomial command,新的命令
    fp <weight>: regress mpg <weight> turn i.rep78
    marginscontplot2 weight (weight_1 weight_2) rep78, at1(2000(500)5000)
    	//以rep78分组显示weight对mpg的边际效应曲线
    marginscontplot2 weight (weight_1 weight_2) rep78, var1(20) ci
    	//加了ci,显示置信区间,就没法显示在同一个图形中,分5个图形显示.rep78不同取值对应不同的边际效益曲线;

*Do-it-yourself fractional polynomial example,自助设置参数的分数多项式模型
    fracgen weight -2 -2
    summarize weight
    range w1 r(min) r(max) 20
    generate w1a = (w1/1000)^-2
    generate w1b = (w1/1000)^-2 * ln(w1/1000) //对应weight分数多项式的参数生成w1a和w1b两个变量
    regress mpg i.foreign##c.(weight_1 weight_2)
    marginscontplot2 weight (weight_1 weight_2), var1(w1(w1a w1b)) ci
    	//weight以分数多项式的形式进入回归,计算边际效应的时候,还原;
    marginscontplot2 weight (weight_1 weight_2) foreign, var1(w1(w1a w1b))
    	//以foreign变量分组显示边际效应曲线;

*Simplified version of the above,简便方法,使用生成weight分数多项式的方法生成分割变量w1_1和w1_2;
    fracgen weight -2 -2
    summarize weight
    range w1 r(min) r(max) 20
    fracgen w1 -2 -2
    regress mpg i.foreign##c.(weight_1 weight_2)
    marginscontplot2 weight (weight_1 weight_2) foreign, var1(w1 (w1_1 w1_2))



***y=sin(x)复杂形式的边际效应
clear
set obs 1000
gen x = _n
gen x1 = cos(x)
gen x2 = sin(x)
gen e1 = uniform()
gen y =3*x1+2*x2+e1
scatter x2 x

reg y x1 x2
summarize x
range w1 r(min) r(max) 70
gen w11 = cos(w1)
gen w12 = sin(w1)

marginscontplot2 x(x1 x2),var1(w1(w11 w12))


clear 
set obs 1000
gen x = _n
gen x1 = sin(x)
gen e1 = uniform()
gen y =3*x1+e1

reg y x1
summarize x
range w1 r(min) r(max) 20
gen w11 = sin(w1)

marginscontplot2 x(x1),var1(w1(w11)) //x以sin(x)的形式进入方程,画出的是x对y的边际效应,正弦曲线;
marginscontplot2 x1,var1(w1) 		 //x以sin(x)的形式进入方程,画出的是sin(x)对y的边际效应,一条直线
marginscontplot2 x1,at1(-1(0.2)1)   //x1=sin(x)取值(-1,1),在此范围内取值,做出sin(x)边际效应图;
marginscontplot2 x1,at1(1(1)10)     //x1取1-10的之间间隔1的位置的数做边际效应图;
marginscontplot2 x1,at1(1(10)200)     //x1取1-200,间隔10的位置的数做边际效应图.
marginscontplot2 x1

*****marginscontplot2:
marginscontplot2 x1 x2,var1() var2() at1() at2():
1.表示根据x2取值的不同,x1对y的边际效应图,可以根据图形判断x1对y的作用随着x2的变化如何变化,来判断x1和x2的交互效应;
2.如果x1和x2不交互,则x2取值的不同,x1对y的作用没有影响,图形是互相平行的;
3.x1和x2如果是虚拟变量,取值有限,可以直接画出边际效应图;
4.x1和x2如果是连续变量,取值无限,不能直接画出边际效应图,需要对x1和x2取特殊值处理:
 -使用at1(a(b)c)命令给出大概取值点;sum(x1) a=min(x1),c=max(x1),b根据取值多少设定间隔;
 -使用var(x3)命令表示根据x3变量作为取值点,x3可以由summarize x和range x3 r(min) r(max) 20 计算得到.


cd "E:\学术论文\C论文\Data\govern expenditures\begining"
use zhengshi_factor_miss.dta,clear
xtreg sdgdp fund_exp effic_exp guard_exp i.clus i.clus#c.(fund_exp effic_exp guard_exp) *_ctr
sum urbanize_ctr
sum effic_exp
marginscontplot2 effic_exp urbanize_ctr,at1(-1(2)7) at2(0.215(0.2)0.9) //effic_exp和urbanize_ctr无交互作用,此时直线是互相平行的;
xtreg sdgdp fund_exp effic_exp guard_exp i.clus i.clus#c.(fund_exp effic_exp guard_exp) *_ctr c.effic_exp#c.urbanize_ctr
marginscontplot2 effic_exp urbanize_ctr,at1(-1(2)7) at2(0.215(0.2)0.9) name(urban_effic) //此时effic_exp和urbanize_ctr有交互作用,
 		//随着urbanize_ctr取值的不同,effic_exp对gdp的作用不同.urbanize_ctr越大,effic_exp的作用越强;
xtreg sdgdp fund_exp effic_exp guard_exp i.clus i.clus#c.(fund_exp effic_exp guard_exp) *_ctr
marginscontplot2 effic_exp clus,at1(-1(2)7) lineopts(lpattern(solid dash dash_dot)) name(clus_effi) //effic_exp对经济增长的作用,clus1 2大于3
bysort clus:sum urbanize_ctr







marginscontplot2 effic_exp clus,at1(-2(2)8) lineopts(lpattern(solid dash dash_dot)) //







***几种回归的区别:
xtreg sdgdp fund_exp effic_exp guard_exp,fe  //固定效应模型
xtreg sdgdp fund_exp effic_exp guard_exp     //默认是随机效应
reg sdgdp fund_exp effic_exp guard_exp       //混合回归



