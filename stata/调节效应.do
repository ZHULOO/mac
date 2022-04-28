//stata图示调节效应：
// 1.首先进行一个调节效应的回归，将结果保存：
clear
sysuse auto,clear
reg price c.length##c.mpg

// 2.分别求自变量以及调节变量在均值上加减一个标准差的值：
foreach v of var length mpg {
	sum `v' if e(sample)   //相当于if e(sample)==1,只使用上一次进行回归用到的样本观测值描述统计；
	local low_`v'=r(mean)-r(sd)
	local high_`v'=r(mean)+r(sd)
}
// 3.借助边际效应margins命令做出调节效应图
// 利用margins命令求预测值，并用marginsplot绘制图形；
margins,at(mpg = (`low_mpg' `high_mpg') /// 
	length = (`low_length' `high_length'))
marginsplot , xlabel(`low_mpg' "Low IV" `high_mpg' "High IV")  ///
              ytitle("Dependent variable")       ///
              ylabel(,angle(horizontal) nogrid) ///
              legend(col(2) stack)   ///
              title("长度的调节作用") noci ///
              graphregion(fcolor(white) ilcolor(white) lcolor(white))
// 对比marginscontplot2命令：
sum mpg length
marginscontplot2 mpg length,at1(12(5)41) at2(150(45)233)




*** 先让变量相乘再进行回归：和上面的直接交互项进行回归然后计算margins的结果对比：
gen len_mpg = length*mpg
reg price length mpg len_mpg //此种先让变量相乘，作为交互项进行回归，然后margins做出的图是不对的；

foreach v of var length mpg {
	sum `v' if e(sample)   //相当于if e(sample)==1,只使用上一次进行回归用到的样本观测值描述统计；
	local low_`v'=r(mean)-r(sd)
	local high_`v'=r(mean)+r(sd)
}
// 3.借助边际效应margins命令做出调节效应图
// 利用margins命令求预测值，并用marginsplot绘制图形；
margins,at(mpg = (`low_mpg' `high_mpg') /// 
	length = (`low_length' `high_length'))
marginsplot , xlabel(`low_mpg' "Low IV" `high_mpg' "High IV")  ///
              ytitle("Dependent variable")       ///
              ylabel(,angle(horizontal) nogrid) ///
              legend(col(2) stack)   ///
              title("长度的调节作用") noci ///
              graphregion(fcolor(white) ilcolor(white) lcolor(white))
// 对比marginscontplot2命令，和上面的先计算margins再plot结果是一致的：
sum mpg length
marginscontplot2 mpg length,at1(12(5)41) at2(150(45)233)
