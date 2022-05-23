*********************bootstrap**********************
set seed #
bootstrap exp list, reps(#): command
//Example 1
sysuse auto,clear
regress mpg weight gear foreign
bootstrap, reps(100) seed(1): regress mpg weight gear foreign
regress mpg weight gear foreign,vce(bootstrap) //支持bootstrap选项的命令，后边直接使用vce(bootstrap)
bootstrap diff=(_b[weight]-_b[gear]): regress mpg weight gear foreign

//Example 2
summarize mpg
disp r(max) - r(min)

bootstrap range=(r(max)-r(min)), reps(1000): summarize mpg
//等价于：
bootstrap max=r(max) min=r(min), reps(1000) saving(mybs): summarize mpg
use mybs, clear
generate range = max - min
bstat range, stat(29) //bstat报告bootstrap结果


*******************bstat************************
* Creating a bootstrap dataset
sysuse auto,clear
regress mpg weight length
matrix b = e(b)
local n = e(N)
predict res, residuals  //估计残差
set seed 54321
generate rid = int(_N*runiform())+1
matrix score double y = b //生成估计的 y = xb
gen resrid = res[rid]
replace y = y + res[rid]  //res[rid]:res的第rid个数
regress y weight length

*******************bstat************************
*******************bstat************************
*******************bstat************************
*******************bstat************************