cd "D:\Program Files\stata15\datasets" //进入目标文件夹(数据集）
use XXX.dta //打开某数据集
sysuse auto.dta,clear //打开系统自带数据集

//日期函数使用
日期显示格式：format var1 %td
季度数据 tq
月度数据 tm
季度数据不能直接提取出年和季度，先用dofq()将quarterly date转换为regular date，q转化为d

clear all
set more off
use https://www.ssc.wisc.edu/sscc/pubs/files/dates.dta

gen date1=date(dateString1,"MDY")
gen date2=date(dateString2,"MDY")
gen date3=date(dateString3,"YMD###")
gen date4=mdy(month,day,year)
format date? %td

gen year1=year(date1)
gen month1=month(date1)
gen day1=day(date1)

gen before2010=(date1< td(1,1,2010))
gen after2010=(date1>date("January 1 2010","MDY"))

gen duration=ending-beginning
gen durationInMonths=(year(ending)-year(beginning))*12+month(ending)-month(beginning)

gen tenDaysLater=date1+10
gen yesterday=date1-1
format tenDaysLater yesterday %td

clear
use https://www.ssc.wisc.edu/sscc/pubs/files/moredates.dta

gen monthlyDate=mofd(date)
gen oneMonthLater1=monthlyDate+1
gen oneYearLater1=monthlyDate+12
format monthlyDate oneMonthLater1 oneYearLater1 %tm

gen oneMonthLater2=date+30
gen oneYearLater2=date+365
format oneMonthLater2 oneYearLater2 %td

gen oneMonthLaterTemp=dofm(mofd(date)+1)
gen oneMonthLater3=mdy(month(oneMonthLaterTemp),day(date),year(oneMonthLaterTemp))
egen numInvalid=total(oneMonthLater3==.) // calculate number of dates that are invalid
local i 1 // number of days to subtract from invalid dates
while (numInvalid>0) { 
replace oneMonthLater3=mdy(month(oneMonthLaterTemp),day(date)-`i',year(oneMonthLaterTemp)) if oneMonthLater3==.
local i=`i'+1 // increase number of days to subtract
drop numInvalid
egen numInvalid=total(oneMonthLater3==.) // see if we still have invalid dates
}
drop oneMonthLaterTemp numInvalid
format oneMonthLater3 %td

//VAR例子
use varexample.dta
tsline inflation unrate fedfunds,lpattern("-" "_") xline(169) //画出三个变量的时间趋势图，在t=169的位置画一条垂直线
sum inflation unrate fedfunds if date <=tq(2002q1) //2002年第一季度前的数据进行描述统计，tq(2002q1)只能对一个季度数据使用，返回一个数值
varsoc inflation unrate fedfunds if date <=tq(2002q1),maxlag(13) //计算不同滞后期的信息准则，最大滞后期为13
var inflation unrate fedfunds if date <=tq(2002q1),lags(1/5) //估计滞后5阶的之后模型
varwle //检验各阶系数的联合显著性
varlmar //检验残差是否为白噪声，原假设是残差无自相关
varstable,graph //检验此VAR系统是否平稳，并画出单位圆图形
varnorm //检查var模型的残差是否服从正态分布，原假设是服从正态分布
fcast compute f_,step(40) //预测40个季度也就是10年的变量取值
fcast graph f_inflation f_unrate f_fedfunds,observed lpattern("_") //三个预测值画图，以虚线来表示预测值
vargranger //对变量进行格兰杰因果关系检验，原假设是x不是y的格兰杰原因
xcorr inflation unrate if date <=tq(2002q1),name(iu) 
xcorr inflation fedfunds if date <=tq(2002q1),name(ir)
xcorr unrate fedfunds if date <=tq(2002q1),name(ur) //依次画出inflation、unrate、fendunds之间的交叉相关图，并命名为iu ir ur
graph combine iu ir ur //将三个图形显示在一个页面上
xcorr inflation unrate if date <=tq(2002q1),table //如果从图中不容易看出哪个交叉系数最大，可以输出为表格格式
irf creat iuf,set(macrovar) step(20) //计算结果命名为iuf（变量顺序为inflation、unrate、fedfunds），存入新建立的脉冲文件macrovar.irf中，step(20)表示计算20期的脉冲响应函数，默认为step(8)
describe using macrovar.irf //查看macrovar.irf文件
irf graph oirf,yline(0) //画正交脉冲响应图，并在y=0的位置画一条参考线
irf graph oirf,yline(0) i(unrate) r(inflation) //画两个变量的脉冲响应图，impulse脉冲变量，response响应变量
irf table fevd,r(inflation) noci //以inflation为响应变量，noci表示不显示置信区间，fevd表示预测方差，给出各阶预测方差分解表格
irf graph fevd,r(inflation) //以inflation为响应变量，画出方差分解图
irf graph fevd,r(unrate) //以unrate为响应变量，画出方差分解图
irf graph fevd //画出所有预测方差分解图
irf creat ifu,order(inflation fedfunds unrate) step(20) //以新的变量顺序inflation fedfunds unrate做脉冲响应分析，考察结果的稳健性
irf graph oirf,i(fedfunds) r(inflation) yline(0) noci //画出两种变量排序iuf和ifu下，inflation对fedfunds脉冲的响应图
irf graph fevd,i(fedfunds) r(inflation) yline(0) noci //画出两种变量排序iuf和ifu下，inflation的预测方差来源于fedfunds的比重图

//单位根检验








