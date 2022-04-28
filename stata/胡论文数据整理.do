cd "E:\学术论文\Data\hudata"
import excel using "inno_sub.xlsx",case(lower) first clear
br
gen year = substr(accper,1,4)
drop accper
destring year,replace
rename (fn05602 fn05603) (current_sub pre_sub)
order stkcd year subsidy nonsub current_sub pre_sub
save subsidy.dta,replace


//区别创新补助和非创新补助：
use subsidy.dta,clear
drop pre_sub
bysort stkcd year subsidy:egen inno_sub = total(current_sub) //对同一公司、同一年下的所有创新补助、非创新补助求和；
order stkcd year subsidy nonsub current_sub inno_sub 
drop current_sub subsidy1 subsidy2
duplicates drop stkcd year inno_sub,force //按同一公司、年份、补助类型去重，得到某公司某年分下的创新补助和非创新补助，0、1分别求和；
format inno_sub %15.2f
by stkcd:gen inno_subsidy = inno_sub if year[_n] == year[_n-1] //创新补助和非创新补助放在同一列了，同一年份的创新补助和非创新补助显示为两行，需要提取出一行；
format inno_subsidy %15.2f
order stkcd year subsidy nonsub inno_sub inno_subsidy 
by stkcd:gen noinno_subsidy = inno_sub if subsidy == 0 //将非创新补助提取为单独一列；
format noinno_subsidy %15.2f
order stkcd year subsidy nonsub inno_sub inno_subsidy noinno_sub
gen inno_subs = inno_subsidy[_n+1] //将创新补助上移一行；
format inno_subs %15.2f
order stkcd year subsidy nonsub inno_sub inno_subsidy noinno_sub inno_subs
drop if inno_subsidy != . //删除同一年下的创新补助，因为已将其提出为单独一列；
by stkcd:replace inno_subs =  inno_sub if subsidy == 1 //将某一年只有创新补助的金额提取出来
by stkcd:replace subsidy =  1 if inno_subs != . //将创新补助不为空对应的虚拟变量取值为1
rename (subsidy nonsub) (subs_i nonsubs_i)
drop inno_sub inno_subsidy fn05601 fnother
rename (noinno_subsidy inno_subs) (nonsubs subs)
order stkcd year subs_i nonsubs_i subs nonsubs
label variable stkcd "公司代码"
label variable year "年份"
label variable subs_i "创新补助虚拟变量"
label variable nonsubs_i "非创新补助虚拟变量"
label variable subs "创新补助"
label variable nonsubs "非创新补助"
label define subs_i 1 "创新补助" 0 "非创新补助和其它"
label define nonsubs_i 1 "非创新补助" 0 "创新补助和其它"
label data "创新补助和非创新补助数据"
save subsidy_all.dta,replace

//其它数据整理：
cd "E:\学术论文\Data\hudata\实证一二数据"
import excel using "短期负债（流动负债）FS_Combas.xlsx",case(lower) first clear
br
labone,nrow(1,2)
drop in 1/2
gen year = substr(accper,1,4)
rename a002100000 short_debt
destring stkcd year short_debt,replace
order stkcd year short_debt 
keep stkcd year short_debt 
format short_debt %20.2f
sort stkcd year
save short_debt.dta,replace


import excel using "樊纲王小鲁市场化指数2007－2019（人大经济论坛下载）.xlsx",case(lower) first clear //非面板数据,改成面板数据
br
rename region province
label var mkt "市场化指数"
save mkt.dta,replace



import excel using "07-09出口数据.xlsx",case(lower) clear //非面板数据,改成面板数据
br
rename (A B C) (stkcd year isexport)
labone,nrow(1)
drop in 1
save export7_9.dta,replace

import excel using "10-14出口数据.xlsx",case(lower) clear //非面板数据,改成面板数据
br
rename (A B C) (stkcd year isexport)
labone,nrow(1)
drop in 1
save export10_14.dta,replace

import excel using "15-19出口数据.xlsx",case(lower) clear //非面板数据,改成面板数据
br
rename (A B C) (stkcd year isexport)
labone,nrow(1)
drop in 1
keep stkcd year isexport
save export15_19.dta,replace

use export7_9.dta,clear
append using export10_14.dta
append using export15_19.dta
rename year year1
gen year = substr(year1,1,4)
drop year1
order stkcd year
destring,replace
sort stkcd year
label define isexport 1 "出口" 0 "无出口"
save isexport.dta,replace


import excel using "公司成立日期STK_LISTEDCOINFOANL.xlsx",case(lower) first clear //也是季度数据
br
labone,nrow(1,2)
drop in 1/2
gen startdate = substr(establishdate,1,10)
keep symbol shortname startdate enddate
order symbol shortname startdate enddate
drop enddate
sort symbol shortname
duplicates drop symbol shortname,force
rename symbol stkcd
destring stkcd,replace 
label var startdate "公司成立日期"
drop shortname
duplicates drop stkcd,force
save establishdate.dta,replace


import excel using "公司所属地区IPO_Cobasic.xlsx",case(lower) first clear
br
labone,nrow(1,2)
drop in 1/2
destring stkcd,replace
sort stkcd
rename (regadd regplc f) (address city province)
drop stknme
save address.dta,replace



import excel using "公司所属行业STK_LISTEDCOINFOANL.xlsx",case(lower) first clear
br
labone,nrow(1,2)
drop in 1/2
rename symbol stkcd
gen year = substr(enddate,1,4)
drop enddate
order stkcd year
destring stkcd year,replace
sort stkcd year
export excel using "industry.xlsx",replace firstrow(variables)
save industry.dta,replace


import excel using "股权性质EN_EquityNatureAll.xlsx",case(lower) first clear
br
labone,nrow(1,2)
drop in 1/2
rename symbol stkcd
gen year = substr(enddate,1,4)
order stkcd year
drop enddate
destring stkcd year,replace
sort stkcd year
replace equitynatureid = "3" if equitynatureid == "2,3"
replace equitynatureid = "2" if equitynatureid == "1,2"
replace equitynatureid = "3" if equitynatureid == "1,2,3"
replace equitynatureid = "3" if equitynatureid == "1,3"
gen st1 = regexm(shortname,"ST")
label var st1 "是否标记为ST"
label define st1 1 "是ST" 0 "非ST"
rename equitynatureid ownership
destring ownership,replace
save equitynature.dta,replace //简称和地址比较详细,包含ST变量



import excel using "经营活动产生的现金流FS_Comscfd.xlsx",case(lower) first clear
br
labone,nrow(1,2)
drop in 1/2
gen year = substr(accper,1,4)
order stkcd year
destring stkcd year,replace
sort stkcd year
drop accper
rename c001000000 cash
destring cash,replace
format cash %20.2f
drop typrep
save cash.dta,replace




import excel using "内控质量指标IC_EvaluationRepInfo.xlsx",case(lower) first clear
br
labone,nrow(1,2)
drop in 1/2
rename symbol stkcd
gen year = substr(enddate,1,4)
drop enddate
order stkcd year
destring stkcd year isvalid isdeficiency,replace
sort stkcd year
label define isvalid 1 "是" 2 "否"
label define isdeficiency 1 "是" 2 "否"
save evaluationrepinfo.dta,replace



import excel using "企业成长能力FI_T8.xlsx",case(lower) first clear
br
labone,nrow(1,2)
drop in 1/2
gen year = substr(accper,1,4)
drop accper
order stkcd year
drop typrep
rename f081602c growth
destring stkcd year growth,replace
sort stkcd year
save growth.dta,replace



import excel using "行业固定资产投资额CME_Msectorinvestfixasset1.xlsx",case(lower) first clear
br
labone,nrow(1,2)
drop in 1/2
gen year = substr(month,1,4)
drop month
order industrycode year
rename fixassetinvest industry_invest
destring year industry_invest,replace
save industry_invest.dta,replace





import excel using "研发人员数量、占比、研发投入及占比PT_LCRDSPENDING.xlsx",case(lower) first clear
br
labone,nrow(1,2)
drop in 1/2
gen year = substr(enddate,1,4)
rename symbol stkcd
drop enddate statetypecode
order stkcd year
destring stkcd year rdperson rdpersonratio rdspendsum rdspendsumratio,replace
format rdspendsum %20.2f
sort stkcd year
save rd.dta,replace



import excel using "营业收入、营业成本用于计算市场结构以及相对生产率FS_Comins.xlsx",case(lower) first clear
br
labone,nrow(1,2)
drop in 1/2
gen year = substr(accper,1,4)
drop accper
order stkcd year
drop typrep
rename (b001101000 b001201000 ) (income cost)
destring,replace
sort stkcd year
format income cost %20.2f
by stkcd:gen growth = (income[_n]-income[_n-1])/income[_n-1]
save income.dta,replace


import excel using "员工人数CG_Ybasic.xlsx",case(lower) first clear
br
labone,nrow(1,2)
drop in 1/2
gen year = substr(reptdt,1,4)
drop reptdt
order stkcd year
rename y0601b employee
destring,replace
sort stkcd year
save employee.dta,replace



import excel using "资产负债率FI_T1.xlsx",case(lower) first clear
br
labone,nrow(1,2)
drop in 1/2
gen year = substr(accper,1,4)
drop accper
order stkcd year
drop typrep
destring,replace
sort stkcd year
rename f011201a captal_debt
save captal_debt.dta,replace



import excel using "是否高新技术企业QUA_QUALIFINFOSTA.xlsx",case(lower) first clear
br
labone,nrow(1,2)
drop in 1/2
rename sgnyear year
order stkcd year
destring,replace
sort stkcd year
label define hightech 1 "高技术企业" 0 "非高技术企业"
by stkcd:gen dup = 1 if year[_n] == year[_n-1] //去除同一公司的重复年份
drop if dup == 1
save hightech.dta,replace



import excel using "专利申请和授权1990-2019年.xlsx",case(lower) clear
br
labone,nrow(1)
drop in 1
drop B
rename A stkcd
rename C year
rename D comtype

rename E indep_invention
rename F indep_utility
rename G indep_design

rename H union_invention
rename I union_utility
rename J union_design

rename K indep_invention_got
rename L indep_utility_got
rename M indep_design_got

rename N union_invention_got
rename O union_utility_got
rename P union_design_got

destring,replace
sort stkcd year comtype
keep if year >=2007
keep if comtype == "集团公司合计"
save patent.dta,replace

//下面只有公司代码数据,首先合并address.dta和establishdate.dta数据:
use address.dta,clear
duplicates drop stkcd,force
merge 1:1 stkcd using "establishdate.dta" //公司成立日期
keep if _merge == 3
drop _merge
save address_establish.dta,replace


****************************************************************************************
//合并总数居
cd "E:\学术论文\Data\hudata\实证一二数据"
dir *.dta
/*
address.dta       
captal_debt.dta   
cash.dta          
employee.dta      
equitynature.dta  
establishdate.dta 
evaluationrepinfo.dta
income.dta        
industry.dta      
mkt.dta           
patent.dta        
rd.dta            
short_debt.dta    
专利申请和授权1990-2019年.dta
*/
//开始合并:

use subsidy_all.dta,clear
br
keep if year >=2007

merge 1:1 stkcd year using "captal_debt.dta"
keep if _merge == 3
drop _merge

merge 1:1 stkcd year using "cash.dta"
keep if _merge == 3
drop _merge

merge 1:1 stkcd year using "employee.dta"
keep if _merge == 3
drop _merge

merge 1:1 stkcd year using "evaluationrepinfo.dta" //from master较多,仅删除from using;
drop if _merge == 2
drop _merge

merge 1:1 stkcd year using "income.dta"
keep if _merge == 3
drop _merge

merge 1:1 stkcd year using "patent.dta" //from master = 769 ,仅删除from using = 1770
keep if _merge == 3
drop _merge

merge 1:1 stkcd year using "rd.dta"    //缺失太多
keep if _merge == 3
drop _merge

merge 1:1 stkcd year using "short_debt.dta"
keep if _merge == 3
drop _merge

merge 1:1 stkcd year using "industry.dta"
keep if _merge == 3
drop _merge

merge 1:1 stkcd year using "equitynature.dta"
keep if _merge == 3
drop _merge

merge 1:1 stkcd year using "isexport.dta"
keep if _merge == 3
drop _merge

//上面是公司,年份面板数据的合并, 下面是公司不随年份变化的的变量:
merge m:m stkcd using "address_establish.dta"
keep if _merge == 3
drop _merge

//export excel using "no_mkt.xlsx",replace firstrow(variables) //查看和mkt中省份名称不对应的情况,然后修改:
replace province = "湖北" if province == "中国" & city == "中国湖北武汉"
replace province = "重庆" if province == "中国" & city == "中国重庆市"
replace province = "四川" if province == "成都" 
replace province = "辽宁" if province == "大连" 
replace province = "广东" if province == "佛山" 
replace province = "福建" if province == "福州" 
replace province = "广东" if province == "广州" 
replace province = "浙江" if province == "杭州" 
replace province = "安徽" if province == "合肥" 
replace province = "黑龙江" if province == "黑龙" 
replace province = "广东" if province == "惠州" 
replace province = "山东" if province == "济南" 
replace province = "山东" if province == "龙口" 
replace province = "河南" if province == "洛阳" 
replace province = "四川" if province == "绵阳" 
replace province = "江苏" if province == "南京" 
replace province = "江苏" if province == "南通" 
replace province = "内蒙古" if province == "内蒙" 
replace province = "浙江" if province == "宁波" 
replace province = "湖北" if province == "潜江" 
replace province = "山东" if province == "青岛" 
replace province = "福建" if province == "厦门" 
replace province = "广东" if province == "汕头" 
replace province = "浙江" if province == "上饶" 
replace province = "广东" if province == "深圳" 
replace province = "辽宁" if province == "沈阳" 
replace province = "江苏" if province == "苏州" 
replace province = "青海" if province == "乌兰" 
replace province = "江苏" if province == "无锡" 
replace province = "安徽" if province == "芜湖" 
replace province = "湖北" if province == "武汉" 
replace province = "陕西" if province == "西安" 
replace province = "山东" if province == "烟台" 
replace province = "江苏" if province == "宜兴" 
replace province = "广东" if province == "湛江" 
replace province = "湖南" if province == "长沙" 
replace province = "广东" if province == "肇庆" 
replace province = "河南" if province == "郑州" 
replace province = "广东" if province == "珠海" 
replace province = "湖南" if province == "株洲" 
replace province = "山东" if province == "淄博" 
replace province = subinstr(province," ","",.)

//province变量统一后再合并:
merge m:m province year using "mkt.dta"
keep if _merge == 3
drop _merge
save 实证1.dta,replace

//合并是否高新技术企业指标
use 实证1.dta,clear
sort stkcd year
merge 1:1 stkcd year using "hightech.dta"
drop if _merge == 2
drop _merge dup
replace hightech = 0 if hightech == . 
//合并成长能力
merge 1:1 stkcd year using "growth.dta"
keep if _merge == 3
drop _merge
//加入area区域变量
gen area = province
replace area = "华中" if area == "河南" | area == "湖南" | area == "湖北"
replace area = "华北" if area == "北京" | area == "天津" | area == "河北" | area == "山西" | area == "内蒙古"
replace area = "华南" if area == "广东" | area == "广西" | area == "海南"
replace area = "西北" if area == "陕西" | area == "甘肃" | area == "青海" | area == "宁夏" | area == "新疆"
replace area = "东北" if area == "辽宁" | area == "吉林" | area == "黑龙江" 
replace area = "西南" if area == "四川" | area == "贵州" | area == "云南" | area == "西藏" | area == "重庆"
replace area = "华东" if area == "上海" | area == "江苏" | area == "浙江" | area == "安徽" | area == "江西" | area == "福建" | area == "山东"
save 实证11.dta,replace



//各数据概况:
cd "E:\学术论文\Data\hudata\实证一二数据"
use captal_debt.dta,clear //资产负债率  
use cash.dta,clear     //经营活动产生的现金流量净额          
use employee.dta,clear //雇员数      
use evaluationrepinfo.dta,clear //内部控制是否有效
use income.dta,clear //营业收入和营业成本       
use patent.dta,clear //专利       
use rd.dta,clear //研发人员/金额            
use short_debt.dta,clear //流动负债
use industry.dta,clear //行业 每一年对应的行业/行业代码/简称是最全的   
use equitynature.dta,clear  //简称/注册地址/股权性质/股权性质代码,有stkcd和每一年的面板对应的地址

use address.dta,clear //只能以公司代码匹配,获取上市日期/注册地址/所在城市/省份,无year变量
use establishdate.dta,clear //成立日期和address里的上市日期是否重复,代码有重复,最后合并

use mkt.dta,clear //以省为单位,市场化指数2008-2019          

//
