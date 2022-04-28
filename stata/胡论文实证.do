**************************初步处理*********************************
cd "E:\学术论文\Data\hudata\实证一二数据"
use 实证11.dta,clear
br
rename subs_i rdsubsidy
rename nonsubs_i nrdsubsidy
rename subs rdsubs
rename nonsubs nrdsubs
// R&Deffort = rdspendsumratio 研发投入占营业收入比例
// Humancapital = rdperson
//patent = 发明\外观\实用新型等数据
//生成age
rename employee size
gen estabdate = substr(startdate,1,4)
destring estabdate,replace
gen age = year - estabdate
label var age "公司年龄(当前日期-成立日期)"
drop estabdate
//growth = growth
//股权性质
gen market = income/cost
label var market "市场结构"
rename captal_debt lev
label var lev "财务杠杆"
gen relproductivity = income/size
label var relproductivity "相对生产率"
gen cash_shortdebt = cash/short_debt
label var cash_shortdebt "现金流除以短期负债"
//发明专利=联合发明专利+独立发明专利
gen patent = indep_invention_got + union_invention_got
save 实证111.dta,replace

*********************************************************实证一**********************************************************************
cd "E:\学术论文\Data\hudata\实证一二数据"
use 实证111.dta,replace
xtset stkcd year

//描述性统计：
tabstat size rdspendsum rdspendsumratio rdperson rdpersonratio patent age growth isexport market lev relproductivity cash_shortdebt,statistics(mean sd p25 p50 p75) by(rdsubsidy) nototal long col(stat)

//输出到word：
local varlist "size rdspendsum rdspendsumratio rdperson rdpersonratio patent age growth isexport market lev relproductivity cash_shortdebt"
estpost tabstat `varlist', by(rdsubsidy) statistics(mean sd p25 p50 p75) columns(statistics) listwise nototal
esttab using summary11.rtf, ///
	cells("mean(fmt(2)) sd(fmt(2)) p25(fmt(2)) p50(fmt(2)) p75(fmt(2))") ///
	noobs compress replace title(esttab_Table: Descriptive statistics)

//生成区域虚拟变量
//此方法不可取, 使用encode命令可自动生成值标签;
replace area = "1" if area == "华中"
replace area = "2" if area == "华北"
replace area = "3" if area == "华南"
replace area = "4" if area == "西北"
replace area = "5" if area == "东北"
replace area = "6" if area == "西南"
replace area = "7" if area == "华东"
destring area,replace

//使用encode命令后,变量由字符型的红色变为蓝色
encode area, generate(area1) label(arealbl)
drop area
rename area1 area
label list arealbl //查看各区域对应的数字

//部分变量取对数后回归
gen lnrdspendsum = ln(rdspendsum)
gen lnrdsubs = ln(rdsubs)
gen lnrdperson = ln(rdperson)
gen lnpatent = ln(patent+1)
gen lnsize = ln(size)
gen lnmarket = ln(market)
gen lnrelproductivity = ln(relproductivity)
save 实证2.dta,replace


//1.双变量probit模型：
use 实证2.dta
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.relproductivity L.size L.hightech,r
estimates store m1
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.relproductivity L.size L.hightech L.patent,r
estimates store m2
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.relproductivity L.size L.hightech L.(rdspendsumratio),r
estimates store m3
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.relproductivity L.size L.hightech L.(age),r
estimates store m4
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.relproductivity L.size L.hightech L.(rdperson),r
estimates store m5
reg2docx m1 m2 m3 m4 m5 using regresult11.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m1" "m2" "m3" "m4" "m5") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*") 

biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.relproductivity L.size L.hightech,r
estimates store m6
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.relproductivity L.size L.hightech L.(isexport),r
estimates store m7
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.relproductivity L.size L.hightech L.(growth),r
estimates store m8
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.relproductivity L.size L.hightech L.(market),r
estimates store m9
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.relproductivity L.size L.hightech L.(lev),r
estimates store m10
reg2docx m6 m7 m8 m9 m10 using regresult12.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m1" "m2" "m3" "m4" "m5") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*")

biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.relproductivity L.size L.hightech,r
estimates store m11
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.relproductivity L.size L.hightech L.(cash_shortdebt),r
estimates store m12
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.relproductivity L.size L.hightech L.(ownership),r
estimates store m13
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.relproductivity L.size L.hightech i.area,r //区域虚拟变量
estimates store m14
reg2docx m11 m12 m13 m14 using regresult13.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m1" "m2" "m3" "m4") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*")

//敏感性测试
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.relproductivity L.size L.hightech,r
estimates store m15
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L2.rdsubsidy L2.nrdsubsidy L.relproductivity L.size L.hightech,r
estimates store m16
reg2docx m15 m16 using regresult14.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m15" "m16") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*")

//2.部分变量取对数后回归:
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech,r
estimates store m1
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.lnpatent,r
estimates store m2
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(rdspendsumratio),r
estimates store m3
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(age),r
estimates store m4
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(lnrdperson),r
estimates store m5
reg2docx m1 m2 m3 m4 m5 using lnregresult11.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m1" "m2" "m3" "m4" "m5") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*") 


biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech,r
estimates store m6
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(isexport),r
estimates store m7
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(growth),r
estimates store m8
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(lnmarket),r
estimates store m9
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(lev),r
estimates store m10
reg2docx m6 m7 m8 m9 m10 using lnregresult12.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m1" "m2" "m3" "m4" "m5") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*")

biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech,r
estimates store m11
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(cash_shortdebt),r
estimates store m12
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(ownership),r
estimates store m13
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech i.area,r //区域虚拟变量
estimates store m14
reg2docx m11 m12 m13 m14 using lnregresult13.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m1" "m2" "m3" "m4") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*")

//敏感性测试
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech,r
estimates store m15
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L2.rdsubsidy L2.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech,r
estimates store m16
reg2docx m15 m16 using lnregresult14.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m15" "m16") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*")

//3.使用制造业和知识密集型服务业的公司为样本进行回归
use 实证2.dta,clear
//保留制造业和知识密集型服务业
gen pro_code = substr(industrycode,1,1)
keep if pro_code == "C" | industrycode == "J66" | industrycode == "J67" | industrycode == "J68" | industrycode == "J69" | industrycode == "L72" ///
 | industrycode == "M73" | industrycode == "M74" | industrycode == "M75" | industrycode == "I63" | industrycode == "I64" | industrycode == "I65"

//进行描述行统计:
local varlist "size rdspendsum rdspendsumratio rdperson rdpersonratio patent age growth isexport market lev relproductivity cash_shortdebt"
estpost tabstat `varlist', by(rdsubsidy) statistics(mean sd p25 p50 p75) columns(statistics) listwise nototal
esttab using summary11.rtf, ///
	cells("mean(fmt(2)) sd(fmt(2)) p25(fmt(2)) p50(fmt(2)) p75(fmt(2))") ///
	noobs compress replace title(esttab_Table: Descriptive statistics)

//winsor2处理:是否必要? 虚拟变量?
local varlist "size rdspendsum rdspendsumratio rdperson rdpersonratio patent age growth isexport market lev relproductivity cash_shortdebt"
winsor2 `varlist',replace

biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech,r
estimates store m1
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.lnpatent,r
estimates store m2
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(rdspendsumratio),r
estimates store m3
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(age),r
estimates store m4
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(lnrdperson),r
estimates store m5
reg2docx m1 m2 m3 m4 m5 using lnregresult11.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m1" "m2" "m3" "m4" "m5") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*") 


biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech,r
estimates store m6
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(isexport),r
estimates store m7
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(growth),r
estimates store m8
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(lnmarket),r
estimates store m9
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(lev),r
estimates store m10
reg2docx m6 m7 m8 m9 m10 using lnregresult12.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m1" "m2" "m3" "m4" "m5") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*")



//生成区域虚拟变量
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech,r
estimates store m11
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(cash_shortdebt),r
estimates store m12
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(ownership),r
estimates store m13
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech i.area,r //区域虚拟变量
estimates store m14
reg2docx m11 m12 m13 m14 using lnregresult13.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m1" "m2" "m3" "m4") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*")

//敏感性测试
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech,r
estimates store m15
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L2.rdsubsidy L2.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech,r
estimates store m16
reg2docx m15 m16 using lnregresult14.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m15" "m16") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*")



******************************************实证二*************************************************
cd "E:\学术论文\Data\hudata\实证一二数据"
use 实证2.dta,clear
//merge m:m industrycode year using industry_invest.dta //合并上行业固定资产投资额
gen lnrdspendsum = ln(rdspendsum)
gen lnrdsubs = ln(rdsubs)
gen lnrdperson = ln(rdperson)
gen lnpatent = ln(patent+1)
gen lnsize = ln(size)
gen lnmarket = ln(market)

reg lnrdspendsum lnrdsubs L.(lnrdspendsum rdspendsumratio hightech lnrdperson lnpatent lnsize age growth i.isexport lnmarket lev cash_shortdebt) i.area i.ownership,r
estimates store m1
heckman lnrdspendsum lnrdsubs L.(rdspendsumratio hightech lnrdperson lnpatent lnsize age growth i.isexport lnmarket lev cash_shortdebt), ///
select(rdsubsidy = L.(rdsubsidy rdspendsumratio hightech lnrdperson lnpatent lnsize age growth i.isexport lnmarket lev cash_shortdebt))
estimates store m2
heckman lnrdspendsum lnrdsubs L.(rdspendsumratio hightech lnrdperson lnpatent lnsize age growth i.isexport lnmarket lev cash_shortdebt), ///
select(rdsubsidy = L.(rdsubsidy rdspendsumratio hightech lnrdperson lnpatent lnsize age growth i.isexport lnmarket lev cash_shortdebt)) twostep
estimates store m3
//处理效应：
treatreg lnrdspendsum lnrdsubs L.(rdspendsumratio hightech lnrdperson lnpatent lnsize age growth i.isexport lnmarket lev cash_shortdebt), ///
treat(rdsubsidy = L.(rdsubsidy rdspendsumratio hightech lnrdperson lnpatent lnsize age growth i.isexport lnmarket lev cash_shortdebt))

reg2docx m1 m2 m3 using regresult21.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m1" "m2" "m3") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*")


