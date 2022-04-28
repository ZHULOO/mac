*****graph twoway
	cd e:\data\r15
	use "http://www.stata-press.com/data/r15/uslifeexp2.dta",clear
	save uslifeexp2.dta
***twoway族命令，都有如下格式
	graph twoway scatter le year,graphregion(color(white))
	twoway scatter le year 
	scatter le year ,name(g1)
	scatter le year,yscale(alt) 
	twoway line
	twoway lfit
	twoway qfitci
	twoway connected
	...
	sysuse auto,clear
	twoway (qfitci mpg weight, stdf) (scatter mpg weight), by(foreign)
	twoway (qfitci mpg weight) (scatter mpg weight), by(foreign)
	twoway qfitci mpg weight, stdf || scatter mpg weight ||, by(foreign)
	twoway qfitci mpg weight, stdf || scatter mpg weight, by(foreign)
	twoway qfitci mpg weight, stdf by(foreign) || scatter mpg weight
	scatter mpg weight || qfit mpg weight ||, by(foreign, total row(1))
	scatter mpg weight, xscale(log) || qfit mpg weight,scheme(sj)  //stata journal方案
***graphregion/plotregion
	sysuse auto,clear
	line mpg weight,graphregion(fcolor(red)) name(g1)
	line mpg weight,graphregion(ifcolor(blue)) name(g2)
	line mpg weight,plotregion(fcolor(green)) name(g3)
	line mpg weight,plotregion(ifcolor(yellow)) name(g4)


*****graph matrix



*****graph combine
	use uslifeexp,clear
	*硬盘中:
	line le_male year,saving(male)
	line le_female year,saving(female)
	graph combine male.gph female.gph
	*内存中:
	line le_male year,name(male)
	line le_female year,name(female)
	graph combine male female 						//默认一行显示
	graph combine male female,col(1) iscale(1)  	//一列显示,iscale(1)可以防止字体缩放
	graph combine male female,col(1) iscale(0.5)  	//一列显示,字体缩放0.5倍
	graph combine male female,ycommon 				//共用y轴
	*高级应用:
	use lifeexp, clear
	generate loggnp = log10(gnppc)
	label var loggnp "Log base 10 of GNP per capita"
	scatter lexp loggnp,ysca(alt) xsca(alt)	xlabel(, grid gmax) saving(yx)
	twoway histogram lexp, fraction	xsca(alt reverse) horiz saving(hy)
	twoway histogram loggnp, fraction ysca(alt reverse)	ylabel(,nogrid)	xlabel(,grid gmax) saving(hx)
	graph combine hy.gph yx.gph hx.gph,	hole(3)	imargin(0 0 0 0) graphregion(margin(l=22 r=22))	title("Life expectancy at birth vs. GNP per capita") note("Source: 1998 data from The World Bank Group")
	*改变图片大小再合并:
	generate loggnp = log10(gnppc)
	label var loggnp "Log base 10 of GNP per capita"
	scatter lexp loggnp,ysca(alt) xsca(alt)	xlabel(, grid gmax) saving(yx)
	twoway histogram lexp, fraction	xsca(alt reverse) horiz saving(hy)
	twoway histogram loggnp, fraction ysca(alt reverse)	ylabel(,nogrid)	xlabel(,grid gmax) saving(hx)
	graph combine hy.gph yx.gph hx.gph,	hole(3)	imargin(0 0 0 0) graphregion(margin(l=22 r=22))	title("Life expectancy at birth vs. GNP per capita") note("Source: 1998 data from The World Bank Group")

*****graph management
	graph replay
	graph print
	set printcolor
*graph export:将图形保存到硬盘
graph export mygraph.pdf
graph export mygraph,as(pdf)
graph export mygraph.png
graph export mygraph,as(png)
graph export mygraph.eps,name(Mygraph) replace
graph export mygraph.png,width(600) height(450) 
graph export mygraph.png,tmargin(0.5) lmargin(0.5) logo(off) //距top和lift边界0.5英寸,stata logo关闭;
graph export mygraph.png,orientation(landscape) 			 //横向;

	graph display
	graph dir
	graph describe
	graph rename
	graph copy
	graph drop
	graph close
	graph query,schemes 
	query graphics
	set scheme
	graph set

*****scheme_option:使用不同的方案自动配置图形选项
	sysuse auto,clear
	graph query,schemes   //查询电脑上已安装的可用的scheme
	update query 		  //升级scheme
	search scheme 	      //搜索其它scheme
	set scheme economist  //设置默认的scheme为economist
	set scheme economist, permanently //永久设置为economist,慎用.默认的是s2color
	scatter mpg weight,scheme(schemename)

*****addplot()****
//graph命令不允许addplot()选项；
//histogram命令可以；
cd e:\data\r15
use "http://www.stata-press.com/data/r15/cancer",clear
save cancer.dta,replace
use cancer.dta,clear
stset studytime,fail(died) noshow
sts graph //经验估计图
streg,distribution(exponential)
predict S,surv
graph twoway line S _t,sort //指数估计图
//两个图放在一起
sts graph,addplot(line S _t,sort)
sts graph || line S _t,sort


sysuse auto,clear
graph twoway scatter mpg price || lfit mpg price
twoway lfit mpg weight,pred(resid) recast(scatter)

***交互效应图
sysuse auto,clear
br
reg price weight c.length##i.foreign
sum length
local low_length = r(mean)-r(sd)
local high_length = r(mean)+r(sd)
margins,at(length = (`low_length' `high_length') foreign=(0 1))
marginsplot,noci graphregion(lpattern(dash))

*****************************kdensity****************************
//Univariate kernel density estimation:单变量的核密度估计;
kdensity varname [if] [in] [weight] [, options]
/*
kernel(kernel) 				specify kernel function; default is kernel(epanechnikov)
bwidth(#) 					half-width of kernel
generate(newvarx newvard) 	store the estimation points in newvarx and the density estimate in newvard
n(#) 						estimate density using # points; default is min(N, 50)
at(varx) 					estimate density using the values specified by varx
nograph 					suppress graph
Kernel plot
							cline options affect rendition of the plotted kernel density estimate
Density plots
normal 						add normal density to the graph
normopts(cline options) 	affect rendition of normal density
student(#) 					add Student’s t density with # degrees of freedom to the graph
stopts(cline options) 		affect rendition of the Student’s t density
Add plots
addplot(plot) 				add other plots to the generated graph
Y axis, X axis, Titles, Legend, Overall
twoway options 				any options other than by() documented in [G-3] twoway options

kernel Description
epanechnikov 				Epanechnikov kernel function; the default
epan2 						alternative Epanechnikov kernel function
biweight 					biweight kernel function
cosine 						cosine trace kernel function
gaussian 					Gaussian kernel function
parzen 						Parzen kernel function
rectangle 					rectangle kernel function
triangle 					triangle kernel function
*/

//example1
cd e:\data
copy https://www.stata-press.com/data/r17/trocolen.dta trocolen.dta
use trocolen,clear
histogram length, bin(18)
kdensity length
return list
display r(bwidth)    //窗宽近似于直方图中箱体数的倒数,越小提供的细节越多,越大越平滑,通常指窗宽的一半,1/2h;
kdensity length,bwidth(10)
kdensity length,bwidth(15)
kdensity length,bwidth(20)
kdensity length,bwidth(20) nograph

//example2:不同的核函数产生不同的结果
use https://www.stata-press.com/data/r17/auto,clear
keep weight foreign
kdensity weight, kernel(epanechnikov) nograph generate(x epan)   //x表示在哪一点上,epan在该点上的概率密度
kdensity weight, kernel(parzen) nograph generate(x2 parzen)
label var epan "Epanechnikov density estimate"
label var parzen "Parzen density estimate"
line epan parzen x, sort ytitle(Density) legend(cols(1))  //sort按x变量排序,legend(cols(1))图例按一列显示;
line epan parzen x, sort ytitle(Density) legend(row(1))  //sort按x变量排序,legend(cols(1))图例按一行显示;

//example3:附加正正态密度曲线
kdensity weight, kernel(epanechnikov) normal

//example4:比较两种密度
sort weight
kdensity weight, nograph generate(x fx)
kdensity weight if foreign==0, nograph generate(fx0) at(x)
kdensity weight if foreign==1, nograph generate(fx1) at(x)
label var fx0 "Domestic cars"
label var fx1 "Foreign cars"
line fx0 fx1 x, sort ytitle(Density)
