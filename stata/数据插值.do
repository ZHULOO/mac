**********************************数据缺失处理****************************************
*参见:https://stats.oarc.ucla.edu/stata/seminars/mi_in_stata_pt1_new/
*数据缺失原因:
*1.Missing completely at random (MCAR)
*2.Missing at random (MAR)
*3.Missing not at random (MNAR)
cd "E:\data"
use hsb2,clear
regress read write i.female math ib3.prog
***缺失数据的常用处理方式
*1.Complete case analysis (listwise deletion)
//完全所有参与回归变量删除缺失的obs
use hsb2_mar.dta,clear
sum  										//可以看到多个变量存在缺失值;
regress read write i.female math ib3.prog   //只有130个obs参加了回归,回归结果产生了很大变化,;
keep if female !=. & prog !=. & read !=. & write !=. & math !=. //相当于保留了所有回归变量中删除70个缺失值后再回归;
sum
*2.Available case analysis (pairwise deletion)
//没有上面的方式删除的obs个数多,计算相关矩阵和协方差时,只忽略变量两两同时缺失的情形,除非是MCAR,否在也是有偏估计;

*3.Mean Imputation
//使用均值插值
use hsb2_mar.dta,clear
tab prog,gen(progcat)
//存在缺失值时,描述统计和相关系数矩阵
sum female write read math progcat1 progcat2,sep(6)
corr female write read math progcat1 progcat2
//均值插值后,描述统计和相关系数矩阵
sum female
replace female = `r(mean)' if female ==.
sum write
replace write = `r(mean)' if write ==.
sum read
replace read = `r(mean)' if read ==.
sum math
replace math = `r(mean)' if math ==.

sum female write read math progcat1 progcat2,sep(6)
corr female write read math progcat1 progcat2

*4.Single Imputation
//使用回归或条件均值插值,结果依然有偏;

*5.Stochastic Imputation
//优于以上方法,生成一个服从正太分布(期望和方差等于回归方程残差的期望和方差)的残差序列,从中抽取残差再加到回归预测结果上;

***总的来看,在缺失数据的情况下,使用极大似然估计和多重插值方法优于以上传统的缺失数据处理方法***

************************************Multiple Imputation(多重插值)************************
*MI有三个基本阶段:
*1. Imputation或Fill-in阶段:用估计值填充缺失的数据，并创建完整的数据集。这个填充过程重复m次。
*2. 分析阶段:使用感兴趣的统计方法(如线性回归)分析每一个完整的数据集。
*3. 汇集阶段:从每个分析数据集获得的参数估计(例如系数和标准误差)，然后结合起来进行推断。
*您选择的imputation方法取决于缺失信息的模式以及缺失信息的变量类型。

*Preparing to conduct MI:
cd "E:\data"
*1.First step: Examine the number and proportion of missing values among your variables of interest. Let’s reload our dataset and use the mdesc command to count the number of missing observations and proportion of missing for each variable.
use hsb2_mar,clear
mdesc female write read math prog //查看个变量缺失值情况,缺失个数及其占比;
*2.Second Step: Examine Missing Data Patterns among your variables of interest.
//help mi styles :四种格式
//style wide
webuse miproto
save miproto.dta,replace
use miproto,clear
list //宽格式,形如:
    +--------------------------------------------------+
     | a   b   c   _1_b   _2_b   _1_c   _2_c   _mi_miss |
     |--------------------------------------------------|
  1. | 1   2   3      2      2      3      3          0 |
  2. | 4   .   .    4.5    5.5    8.5    9.5          1 |
     +--------------------------------------------------+
//style flong
mi convert flong, clear
list, separator(2) //形如:重复显示非缺失obs,并补充缺失数据;

     +-------------------------------------------+
     | a     b     c   _mi_miss   _mi_m   _mi_id |
     |-------------------------------------------|
  1. | 1     2     3          0       0        1 |
  2. | 4     .     .          1       0        2 |
     |-------------------------------------------|
  3. | 1     2     3          .       1        1 |
  4. | 4   4.5   8.5          .       1        2 |
     |-------------------------------------------|
  5. | 1     2     3          .       2        1 |
  6. | 4   5.5   9.5          .       2        2 |
     +-------------------------------------------+
//style mlong
mi convert mlong,clear
list //形如:非缺失数据保持不动,补全的缺失数据附在后面;
    +-------------------------------------------+
     | a     b     c   _mi_miss   _mi_m   _mi_id |
     |-------------------------------------------|
  1. | 1     2     3          0       0        1 |
  2. | 4     .     .          1       0        2 |
  3. | 4   4.5   8.5          .       1        2 |
  4. | 4   5.5   9.5          .       2        2 |
     +-------------------------------------------+
//style flongsep:生成新的单独的补全缺失值的数据;
mi convert flongsep example_flongsep,clear
list  //原数据不变, 生成两份新的补全缺失值的数据;
use example_flongsep,clear
list
use _1_example_flongsep,clear
list
use _2_example_flongsep,clear
list
drop _all 
mi erase example_flongsep   //同时删除上面生成的几份数据;

//还原miproto.dta数据的生成过程:
 drop _all
 input a b
a  b
1  2 
4  .
end
mi set wide
mi set M = 2 
mi register regular a
mi register imputed b
replace _1_b = 4.5 in 2
replace _2_b = 5.5 in 2
mi passive: gen c = a + b
order a b c _1_b _2_b _1_c _2_c _mi_miss
save miproto.dta,replace   //即可生成原数据

//关于mi的详细操作,事后再详细学习


*继续使用hsb_mar数据集的案例
use hsb2_mar,clear
mi set mlong
mi misstable summarize female write read math prog
mi misstable patterns female write read math prog 

*3.If necessary, identify potential auxiliary variables




//mi impute :Impute missing values
help mi impute
webuse mheart1s0,clear
save mheart1s0.dta,replace
use mheart1s0,clear
mi describe
mi impute regress bmi attack smokes age female hsgrad, add(20)






************************之前简单插值********************************
cd E:\data
import excel using "插值.xlsx",case(lower) first clear
drop gdp_*
mipolate gdp t, gen(gdp_line) linear epolate //线性插值
mipolate gdp t, gen(gdp_spline) spline epolate //线性插值
line gdp_line t,name(gra1,replace)
line gdp_spline t,name(gra2,replace)
graph combine gra1 gra2
line gdp_line gdp_spline t

//ipolate:官方命令,线性插值
help ipolate
//截面数据
use https://www.stata-press.com/data/r17/ipolxmpl1,clear
save ipolxmpl1.dta,replace

use ipolxmpl1,clear
list, sep(0)
ipolate y x, gen(y1)
ipolate y x, gen(y2) epolate
list, sep(0)
//面板数据
use https://www.stata-press.com/data/r17/ipolxmpl2, clear
save ipolxmpl2.dta,replace

use ipolxmpl2,clear
by magazine: ipolate circ year, gen(icirc)
line circ icirc year if magazine == "mag0"


//help mipolate:多种插值,线性、样条、三次方等
help mipolate
cd "E:\data"
* Setup
    use ipolxmpl1,clear

* List the data
    list, sep(0)

* Create ly1, cy1, sy1, py1, ny1 containing interpolations of y on x for missing values of y
 
    mipolate y x, linear gen(ly1) 		//线性插值,默认
    mipolate y x, cubic gen(cy1) 		//三次插值
    mipolate y x, spline gen(sy1)		//样条插值
    //上面三种默认内插,不能外插,也可使用epolate指定线性外插,下面几种可以外插,不能使用epolate选项;
    mipolate y x, pchip gen(py1)        //piecewise cubic Hermite interpolation,分段三次Hermite插值
    mipolate y x, idw gen(iy1) 			//距离倒数权重插值,power=2,权重为1,1/4,1/9...
    mipolate y x, forward gen(fy1) 		//向前插值,复制缺失值之前的值2,3,____
    mipolate y x, backward gen(by1) 	//向后插值,复制缺失值后面的值___,2,3
    mipolate y x, nearest gen(ny1) 		//使用离缺失值前后最近的数插值,如果前后距离一样,默认使用二者平均数插值,也可使用ties()指定:after使用后边的数,before使用前面的数,minimum使用二者中较小的数,maximum使用二者中大的数;
    mipolate y x, groupwise gen(gy1) 	//每一组只有一个值是非缺失的,剩余的缺失值都用这一个非缺失值插值,如此插值后同一组的值都相同;

* Use alternative rules for handling ties:
    foreach r in after before max min {
     mipolate y x, nearest ties(`r') gen(ny`r')
    }

* List the results
    list, sep(0)


* Setup
	cd "E:\data"
    use ipolxmpl2,clear
    replace circ = . in 10
    replace circ = . in 11

* Show years for which the circulation data are missing
    tabulate circ year if circ == . , missing

* Create pchipcirc containing a pchip interpolation of circ on year for missing values of circ and perform this calculation separately for each magazine
    by magazine: mipolate circ year, gen(pchipcirc)


* Moler's example
    clear
    set obs 6
    matrix y = (16, 18, 21, 17, 15, 12)'
    gen y = y[_n, 1]
    gen x = _n
    set obs 61
    replace x = (_n + 1)/10 in 7/L   //L表示最后
    mipolate y x, pchip gen(pchip)
    line pchip x, sort || scatter y x


* Sandbox for groupwise:
    clear
    set obs 10
    gen x = _n
    gen group = 1 in 1
    replace group = 2 in 2/3
    replace group = 3 in 4/6
    replace group = 4 in 7/10
    gen y = .
    replace y = 2 in 2
    replace y = 5 in 5
    replace y = 10 in 10
    bysort group: mipolate y x, gen(y1) c   //groupwise
    list, sepby(group)
    replace y = 9 in 9
* should fail:
    bysort group: mipolate y x, gen(y2) groupwise
