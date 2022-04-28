***介绍***参见网页：https://mp.weixin.qq.com/s/nn8tCIR9DmxYaDVfZ2MfJg
安装:
net install rdrobust,from(http://www-personal.umich.edu/~cattaneo/rdrobust)
help rdrobust
*案例：
1.例如，如果你关心政府奖金对大学入学情况有怎样的影响，你可能会想要将那些获得政府奖金的学生
和未获得政府奖金的学生进行比较。但这种方法是存在问题的，因为获得政府奖金的低收入家庭学生与
未获得政府奖金的学生可能在多方面均存在差异。然而，由于确认资格的收入分界线是未知的，在断点
两侧小邻域内的个体可以被视为是相同的。因此，我们有理由认为未知的收入线外生随机地将断点附近
的个体分成了两组，一组收到了政府奖金，一组未收到。
2.高考分数线
*生成断点案例数据
clear
set obs 10000
gen income = 3^((runiform()-0.75)*4)
label var income "Reported Income"
sum income
gen perfo=ln(income)+sin((income-r(min))/r(max)*4*_pi)/3+3
scatter perfo income
gen perf1=perfo+rnormal()*0.5
label var perf1 "performance index-with noise"
scatter perf1 income
help rcspline 					//安装rcspline:
rcspline perf1 income,nknots(7) showknots title(Cubic Spline)
gen grant=income<0.5
sum grant
gen income_center=income-0.5
gen perf2=perf1+0.5*grant-0.1*income_center*grant
label var perf2 "observed performance"
scatter perf2 income
*首先尝试ols
reg perf2 income grant
rdrobust perf2 income_center
gen nincome_center=income_center*(-1)
rdrobust perf2 nincome_center //对比传统rd
rd perf2 nincome_center
