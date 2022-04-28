*****使用制造业和知识密集型服务业的公司为样本进行回归
cd "E:\学术论文\Data\hudata\实证一二数据" //家里台式机
cd "H:\data\hudata\实证一二数据"         //U盘上的数据
use 实证2.dta,clear
//保留制造业和知识密集型服务业
gen pro_code = substr(industrycode,1,1)
keep if pro_code == "C" | industrycode == "J66" | industrycode == "J67" | industrycode == "J68" | industrycode == "J69" | industrycode == "L72" ///
 | industrycode == "M73" | industrycode == "M74" | industrycode == "M75" | industrycode == "I63" | industrycode == "I64" | industrycode == "I65"
//处理所有制 equitynature变量为虚拟变量
label define ownershiplbl 1 "国企" 2 "民营" 3 "外资" 4 "其它"
label list ownershiplbl
destring equitynatureid,replace
label value equitynatureid ownershiplbl
rename equitynatureid ownership
save 实证12.dta,replace

//进行描述行统计:
//是否获得创新补助分组描述:
local varlist "size rdspendsum rdspendsumratio rdperson rdpersonratio patent age growth isexport market lev relproductivity cash_shortdebt"
estpost tabstat `varlist', by(rdsubsidy) statistics(mean sd p25 p50 p75) columns(statistics) listwise nototal
esttab using summary11.rtf, ///
	cells("mean(fmt(2)) sd(fmt(2)) p25(fmt(2)) p50(fmt(2)) p75(fmt(2))") ///
	noobs compress replace title(esttab_Table: Descriptive statistics)
//是否获得非创新补助分组描述
local varlist "size rdspendsum rdspendsumratio rdperson rdpersonratio patent age growth isexport market lev relproductivity cash_shortdebt"
estpost tabstat `varlist', by(nrdsubsidy) statistics(mean sd p25 p50 p75) columns(statistics) listwise nototal
esttab using summary12.rtf, ///
	cells("mean(fmt(2)) sd(fmt(2)) p25(fmt(2)) p50(fmt(2)) p75(fmt(2))") ///
	noobs compress replace title(esttab_Table: Descriptive statistics)

//winsor2处理:是否必要? 虚拟变量?
local varlist "size rdspendsum rdspendsumratio rdperson rdpersonratio patent age growth isexport market lev relproductivity cash_shortdebt"
winsor2 `varlist',replace

//动态面板probit模型
//取了自然对数的变量:
/*
gen lnrdspendsum = ln(rdspendsum)
gen lnrdsubs = ln(rdsubs)
gen lnrdperson = ln(rdperson)
gen lnpatent = ln(patent+1)
gen lnsize = ln(size)
gen lnmarket = ln(market)
*/
use 实证12.dta,clear
xtset stkcd year
xtdescribe
*-计算具有动态变化特征变量的初始值
bys stkcd(year):gen rdsubsidy_0 = rdsubsidy[1]
bys stkcd(year):gen nrdsubsidy_0 = nrdsubsidy[1]

*-计算具有动态变化特征变量的个体均值
bys stkcd(year):egen m_lnrelproductivity = mean(lnrelproductivity)
bys stkcd(year):egen m_rdspendsumratio = mean(rdspendsumratio)
bys stkcd(year):egen m_market = mean(market)
bys stkcd(year):egen m_cash_shortdebt = mean(cash_shortdebt)
*-研发投入中位数以上的企业
bys stkcd(year):egen med_rdspendsum = median(rdspendsum)

*-模型
biprobit rdsubsidy nrdsubsidy L.rdsubsidy rdsubsidy_0 L.nrdsubsidy nrdsubsidy_0 lnrelproductivity m_lnrelproductivity lnsize hightech
estimates store m1
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy lnrelproductivity lnsize hightech
estimates store m2
biprobit rdsubsidy nrdsubsidy L.rdsubsidy rdsubsidy_0 L.nrdsubsidy nrdsubsidy_0 lnrelproductivity m_lnrelproductivity lnsize hightech rdspendsumratio m_rdspendsumratio
estimates store m3
biprobit rdsubsidy nrdsubsidy L.rdsubsidy rdsubsidy_0 L.nrdsubsidy nrdsubsidy_0 lnrelproductivity m_lnrelproductivity lnsize hightech age
estimates store m4
reg2docx m1 m2 m3 m4 using regresult1234.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m1" "m2" "m3" "m4") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*")

biprobit rdsubsidy nrdsubsidy L.rdsubsidy rdsubsidy_0 L.nrdsubsidy nrdsubsidy_0 lnrelproductivity m_lnrelproductivity lnsize hightech market m_market
estimates store m5
biprobit rdsubsidy nrdsubsidy L.rdsubsidy rdsubsidy_0 L.nrdsubsidy nrdsubsidy_0 lnrelproductivity m_lnrelproductivity lnsize hightech cash_shortdebt m_cash_shortdebt
estimates store m6
//研发投入中位数以上的子样本
preserve
keep if rdspendsum > med_rdspendsum
biprobit rdsubsidy nrdsubsidy L.rdsubsidy rdsubsidy_0 L.nrdsubsidy nrdsubsidy_0 lnrelproductivity m_lnrelproductivity lnsize hightech
estimates store m7
restore

biprobit rdsubsidy nrdsubsidy L.rdsubsidy rdsubsidy_0 L.nrdsubsidy nrdsubsidy_0 lnrelproductivity m_lnrelproductivity lnsize hightech isexport
estimates store m8
reg2docx m5 m6 m7 m8 using regresult5678.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m5" "m6" "m7" "m8") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*")

biprobit rdsubsidy nrdsubsidy L.rdsubsidy rdsubsidy_0 L.nrdsubsidy nrdsubsidy_0 lnrelproductivity m_lnrelproductivity lnsize hightech growth
estimates store m9
biprobit rdsubsidy nrdsubsidy L.rdsubsidy rdsubsidy_0 L.nrdsubsidy nrdsubsidy_0 lnrelproductivity m_lnrelproductivity lnsize hightech ownership
estimates store m10
biprobit rdsubsidy nrdsubsidy L.rdsubsidy rdsubsidy_0 L.nrdsubsidy nrdsubsidy_0 lnrelproductivity m_lnrelproductivity lnsize hightech area
estimates store m11
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L2.rdsubsidy rdsubsidy_0 L.nrdsubsidy L2.nrdsubsidy nrdsubsidy_0 lnrelproductivity m_lnrelproductivity lnsize hightech 
estimates store m12
reg2docx m9 m10 m11 m12 using regresult9101112.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m9" "m10" "m11" "m12") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*")

//合并专利引证次数数据:
cd "H:\data\hudata\实证一二数据"         //U盘上的数据
use 实证2.dta,clear
br

use "原始数据2019-11-5.dta",clear
keep stkcd accper fcitation flogcitation //仅保留专利印证次数数据, 合并
gen year = substr(accper,1,4)
destring year,replace
drop accper
order stkcd year
sort stkcd year
save citation_zhu.dta,replace

use 实证2.dta,clear
merge 1:1 stkcd year using citation_zhu.dta
keep if _merge == 3
keep if industrycode == "C26" //只保留化工行业
save shizheng_last.dta,replace
//描述性统计
use shizheng_last,clear
//keep if fcitation != 0
local varlist "fcitation rdsubs cash_shortdebt growth size rdspendsumratio"
sum2docx `varlist' using sumresults_last.docx, ///
replace stats(N mean(%9.3f) sd(%9.3f) min(%9.3f) median(%9.3f) max(%9.3f)) ///
title("table titile")


cd "E:\数据\数据与代码\QE_code\1_Data"
use spatial_oligopoly.dta,clear

//有序Probit回归
cd "H:\data\hudata\实证一二数据"
use shizheng_last,clear
br
gen st1 = substr(shortname,1,3)
gen deci_y = 1 if st1 == "*ST"
replace deci_y = 2 if st1 != "*ST" & rdspendsum == .
replace deci_y = 3 if deci_y == .

export excel using "shizheng_last.xlsx",replace firstrow(variables)

//20210605合并新数据:
//import excel 营业利润
cd "H:\data\hudata\实证一二数据"         //U盘上的数据
import excel using "FS_Comins.xlsx",case(lower) first clear
br
labone,nrow(1,2)
drop in 1/2
gen fu1 = substr(accper,6,10)
keep if fu1 == "12-31" & typrep == "A"
gen year = substr(accper,1,4)
rename b001300000 profit
order stkcd year profit
sort stkcd year
destring stkcd year profit,replace
keep stkcd year profit
format profit %20.2f
save profit.dta,replace
//与实证2.dta合并到一起
use 实证2.dta,clear
br
keep stkcd year rdsubs rdspendsum income cost relproductivity cash_shortdebt industryname industrycode
merge 1:1 stkcd year using profit.dta
keep if _merge == 3
drop _merge
keep if industrycode == "C26"
save shizheng_last2.dta,replace

//计算专利存量后再合并
import excel using "专利申请和授权1990-2019年.xlsx",case(lower) clear
br
labone,nrow(1)
drop in 1
drop B
rename A stkcd
rename C year
rename D comtype
rename E indep_invention

destring,replace
sort stkcd year comtype
keep stkcd year comtype indep_invention
keep if year >=2007
keep if comtype == "集团公司合计"
drop comtype
xtset stkcd year
tsfill,full //平衡面板
forvalues i = 1/12{
	gen inv_`i' = L`i'.indep_invention
}

forvalues i =1/12{
	replace inv_`i' = 0 if inv_`i' == .
}

gen invention = indep_invention+0.85*inv_1+0.85^2*inv_2+0.85^3*inv_3+0.85^4*inv_4 ///
	+0.85^5*inv_5+0.85^6*inv_6+0.85^7*inv_7+0.85^8*inv_8+0.85^9*inv_9+0.85^10*inv_10 ///
	+0.85^11*inv_11+0.85^12*inv_12

keep stkcd year invention

save invention.dta,replace

//将发明专利存量合并到数据
use shizheng_last2.dta,clear
merge 1:1 stkcd year using invention.dta
keep if _merge == 3
drop _merge

//计算除自身外竞争对手的平均值
sort year
by year,sort:egen totals = total(invention)
by year,sort:egen nums = count(invention)
gen invention_others = (totals-invention)/(nums-1)
keep if profit >= 0

sort stkcd year
xtset stkcd year
save shizheng_last3.dta,replace

//回归
cd "G:\data\hudata\实证一二数据" //home U盘
use shizheng_last3.dta,replace
gen lnrdspendsum = log(rdspendsum)
gen lnrdsubs = log(rdsubs)
gen lnincome = log(income)
gen lncost = log(cost)
gen lnprofit = log(profit)
gen lninvention = log(invention+1)
gen lninvention_others = log(invention_others+1) 
gen lnrelproductivity = log(relproductivity)
//描述
sum2docx lnrdspendsum lnrdsubs lnincome lncost lnprofit lninvention lninvention_others lnrelproductivity using sumresults_last.docx, ///
replace stats(N mean(%9.3f) sd(%9.3f) min(%9.3f) median(%9.3f) max(%9.3f)) ///
title("table titile")

//relproductivity中位数,生成虚拟变量
bys year:egen med_relproductivity = median(relproductivity)
bys year:gen dum_relproduct = (relproductivity>=med_relproductivity)

xtreg lnrdspendsum lninvention lninvention_others c.lnrdsubs#c.lninvention c.lnrdsubs#c.lninvention_others 
estimates store m1
xtreg lnrdspendsum lninvention lninvention_others c.lnrdsubs#c.lninvention c.lnrdsubs#c.lninvention_others i.year
estimates store m2
xtreg lnrdspendsum lninvention lninvention_others c.lnrdsubs#c.lninvention c.lnrdsubs#c.lninvention_others,fe 
estimates store m3
xtreg lnrdspendsum lninvention lninvention_others c.lnrdsubs#c.lninvention c.lnrdsubs#c.lninvention_others i.dum_relproduct#c.lninvention i.dum_relproduct#c.lninvention_others,fe 
estimates store m4
reg2docx m1 m2 m3 m4 using regresult_last1.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.3f)) t(%7.3f) title("table titile") ///
mtitles("m1" "m2" "m3" "m4") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*") // landscape

xtreg lnincome lnrdspendsum lninvention lninvention_others c.lnrdspendsum#c.lninvention_others c.lninvention#c.lninvention_others,fe
estimates store m5
xtreg lnincome lnrdspendsum lninvention lninvention_others c.lnrdspendsum#c.lninvention_others c.lninvention#c.lninvention_others i.dum_relproduct#c.lninvention i.dum_relproduct#c.lnrdspendsum,fe
estimates store m6
reg2docx m5 m6 using regresult_last2.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.3f)) t(%7.3f) title("table titile") ///
mtitles("m5" "m6") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*")

save shizheng_last4.dta,replace
export excel using "shizheng_last4.xlsx",replace firstrow(variables)
