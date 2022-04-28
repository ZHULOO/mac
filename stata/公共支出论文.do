*原始数据处理
cd "E:\学术论文\C论文\Data\govern expenditures\"
import excel using govexp.xlsx,case(lower) clear
br
nrow
labone,nrow(1,2) //将第一行obs作为标签。注意：不加逗号，提示"factor-variable and time-series operators not allowed"错误
drop in 1/2
findname,local(varname)
rename (`varname') (year area ybys ggfw wjzc gfzc ggaq jyzc kxjs whty shbz ylws hjbh cxsq nlss jtys qtbl)
destring,replace
drop if area == "中国" 
sort area year
save govexp.dta,replace

cd "E:\学术论文\C论文\Data\govern expenditures\"
import excel using Gdp.xlsx,case(lower) clear //加入sheet(sheet1)选项，可以读取不同工作簿下的数据
br
drop B
drop D
nrow
labone,nrow(1,2)
drop in 1/2
destring,replace
rename Prvcnm area
rename (Sgnyea Gdp0116) (year gdp)
drop if area == "中国"
sort area year
save gdp.dta,replace

*合并数据
cd "E:\学术论文\C论文\Data\govern expenditures\"
use govexp.dta,clear
merge 1:1 area year using gdp.dta //合并后总是出现一个出问题，因为多一个空格,2017年的黑龙江省多出一个空格，导致合并出错
drop _merge
save huizong.dta,replace

*汇总其它指标
cd "E:\学术论文\C论文\Data\govern expenditures\"
import excel using 金融发展程度.xls,case(lower) clear
labone,nrow(1)
rename (A B C D E F) (year area rmbck rmbdk gdp jrfzcp)
drop in 1
save 存贷款.dta,replace

drop rmbck rmbdk gdp
save jrfzsp.dta,replace
destring,replace
drop if year <2007
*将所有地区补齐为全称：
replace area = area+"省" //所有地区加上“省”字
replace area= "北京市" if area == "北京省"
replace area= "天津市" if area == "天津省"
replace area= "上海市" if area == "上海省"
replace area= "重庆市" if area == "重庆省"
replace area= "内蒙古自治区" if area == "内蒙古省"
replace area= "宁夏回族自治区" if area == "宁夏省"
replace area= "广西壮族自治区" if area == "广西省"
replace area= "新疆维吾尔自治区" if area == "新疆省"
replace area= "西藏自治区" if area == "西藏省"
save jrfzsp2007-2017.dta,replace


cd "E:\学术论文\C论文\Data\govern expenditures\"
import excel using 人力资本水平.xlsx,case(lower) clear
nrow
label variable rlzbsp "人力资本水平（在校生数量与总人口的比值）"
destring,replace
replace area = area+"省" //所有地区加上“省”字
replace area= "北京市" if area == "北京省"
replace area= "天津市" if area == "天津省"
replace area= "上海市" if area == "上海省"
replace area= "重庆市" if area == "重庆省"
replace area= "内蒙古自治区" if area == "内蒙古省"
replace area= "宁夏回族自治区" if area == "宁夏省"
replace area= "广西壮族自治区" if area == "广西省"
replace area= "新疆维吾尔自治区" if area == "新疆省"
replace area= "西藏自治区" if area == "西藏省"
save 人力资本水平.dta,replace

drop if year<2007
save rlzysp2007-2017.dta,replace

cd "E:\学术论文\C论文\Data\govern expenditures\"
import excel using 劳动力增长率.xlsx,case(lower) clear
nrow
label variable ldlzzl "劳动力增长率"
destring,replace
replace area = area+"省" //所有地区加上“省”字
replace area= "北京市" if area == "北京省"
replace area= "天津市" if area == "天津省"
replace area= "上海市" if area == "上海省"
replace area= "重庆市" if area == "重庆省"
replace area= "内蒙古自治区" if area == "内蒙古省"
replace area= "宁夏回族自治区" if area == "宁夏省"
replace area= "广西壮族自治区" if area == "广西省"
replace area= "新疆维吾尔自治区" if area == "新疆省"
replace area= "西藏自治区" if area == "西藏省"
save 劳动力增长率.dta,replace
drop if year<2007
save ldlzzl2007-2017.dta,replace

cd "E:\学术论文\C论文\Data\govern expenditures\"
import excel using 从业人员数.xlsx,case(lower) clear
drop in 2
drop AG
nrow
drop in 42/88
findname,local(varname)
disp "`varname'"
gather 北京 天津 河北 山西 内蒙古 辽宁 吉林 黑龙江 上海 江苏 浙江 安徽 福建 江西 ///
山东 河南 湖北 湖南 广东 广西 海南 重庆 四川 贵州 云南 西藏 陕西 甘肃 青海 宁夏 ///
新疆,variable(area) value(cyrys) //宽变长
label variable cyrys "从业人员数"
destring,replace
replace area = area+"省" //所有地区加上“省”字
replace area= "北京市" if area == "北京省"
replace area= "天津市" if area == "天津省"
replace area= "上海市" if area == "上海省"
replace area= "重庆市" if area == "重庆省"
replace area= "内蒙古自治区" if area == "内蒙古省"
replace area= "宁夏回族自治区" if area == "宁夏省"
replace area= "广西壮族自治区" if area == "广西省"
replace area= "新疆维吾尔自治区" if area == "新疆省"
replace area= "西藏自治区" if area == "西藏省"
save 从业人员数.dta,replace
drop if year<2007
save cyrys2007-2017.dta,replace

cd "E:\学术论文\C论文\Data\govern expenditures\"
import excel using 对外开放度.xlsx,case(lower) first clear
label variable dwkfd "对外开放度"
replace area = area+"省" //所有地区加上“省”字
replace area= "北京市" if area == "北京省"
replace area= "天津市" if area == "天津省"
replace area= "上海市" if area == "上海省"
replace area= "重庆市" if area == "重庆省"
replace area= "内蒙古自治区" if area == "内蒙古省"
replace area= "宁夏回族自治区" if area == "宁夏省"
replace area= "广西壮族自治区" if area == "广西省"
replace area= "新疆维吾尔自治区" if area == "新疆省"
replace area= "西藏自治区" if area == "西藏省"
save 对外开放度.dta,replace
drop if year<2007
save dwkfd2007-2017.dta,replace
*整理市场化指数数据：
cd "E:\学术论文\C论文\Data\govern expenditures\"
import excel using "2000－2017市场化指数－樊纲王小鲁.xls",case(lower) first clear
keep _id year area total
rename _id _ID
sort _ID year
save 市场化指数2000-2017.dta,replace
keep if year >= 2007 & year <=2017
encode area,generate(area1)
drop area
save 市场化指数2007-2017.dta,replace

dir *2007-2017.dta
use huizong.dta,clear
merge 1:1 area year using cyrys2007-2017.dta
drop _merge
merge 1:1 area year using czhsp2007-2017.dta
drop _merge
merge 1:1 area year using dwkfd2007-2017.dta
drop _merge
merge 1:1 area year using jrfzsp2007-2017.dta
drop _merge
merge 1:1 area year using rlzysp2007-2017.dta
drop _merge
encode area,gen(province)
drop area
rename province area
order area year gdp

save zongshuju.dta,replace

***加入地图数据，整理成空间面板：
cd "E:\学术论文\C论文\Data\govern expenditures\"
use province34.dta,clear //打开地图文件
spset 					 //依然关联shp文件
drop in 32/34  			 //删除港澳台地区
save province31.dta,replace //保存为31个地区的地图
spcompress                  //生成province31_shp.dta子文件


use province31.dta,clear
spset

use zongshuju.dta,clear  //打开公共支出数据
egen _ID = group(area)
order _ID
merge m:1 _ID using province31.dta  
keep if _merge==3
drop _merge
order _ID year area name 
xtset _ID year
spset
save zongshuju_map.dta,replace
spset

use zongshuju_map.dta,clear
grmap gdp,t(2017)
spset 		//显示已经进行了面板数据设定
describe 	//显示各变量信息
gen lngdp = log(gdp)
gen lnggfw = log(ggfw)
gen lnjyzc = log(jyzc)
gen lnkxjs = log(kxjs)
gen lncyrys = log(cyrys)
gen lnrlzbsp = log(rlzbsp)
	save zhichu.dta,replace //生成和保存新数据及shp文件
	spcompress				//相应修改了shp文件，但是需要保存
	save,replace
	use zhichu.dta,clear
*普通面板回归及hausman检验
xtreg lngdp lnggfw lnjyzc lnkxjs lncyrys czhsp dwkfd jrfzcp rlzbsp,re
estimates store re
xtreg lngdp lnggfw lnjyzc lnkxjs lncyrys czhsp dwkfd jrfzcp rlzbsp,fe
estimates store fe
hausman fe re 									//拒绝原假设，应该适用固定效应模型

*空间面板回归：
	*首先生成相邻权重矩阵
	spmatrix create contiguity W if year ==2017 //报错，当前内存中已有同名矩阵；
	spmatrix dir 								//显示当前内存已经存在的权重矩阵；
	spmatrix clear 								//当前内存已经存在的权重矩阵全部清除；
	spmatrix drop W 							//只删除之前的W矩阵；
	spmatrix drop M 
	spmatrix create contiguity W if year ==2017 //再生成权相邻重矩阵W；
	spmatrix create idistance M if year ==2007
	*moran检验	
	regress lngdp lnggfw if year ==2017 		//要用moran检验，必须是截面数据进行了回归之后；
	estat moran ,errorlag(W)					//拒绝原假设认为存在显著的空间效应；
	estat moran ,errorlag(M)					//M矩阵结果不显著；
	*下面用空间面板进行回归：
	spxtregress lngdp lnggfw lnjyzc lnkxjs lncyrys czhsp dwkfd jrfzcp rlzbsp,fe errorlag(W) //SEM
	spxtregress lngdp lnggfw lnjyzc lnkxjs lncyrys czhsp dwkfd jrfzcp rlzbsp,fe dvarlag(W) //SAR
	estat impact 						//会计算出每一个自变量的直接和间接效应；
	estat impact lnggfw 				//计算单个自变量lnggfw的直接和间接效应；
	estat impact lnggfw if year == 2007 //计算单个变量单个年份的直接和间接效应；
	estat impact lnggfw if year == 2010
	estat impact lnggfw if year == 2016
	spxtregress lngdp lnggfw lnjyzc lnkxjs lncyrys czhsp dwkfd jrfzcp rlzbsp,fe ivarlag(W:lnggfw) //SDM
	spxtregress lngdp lnggfw lnjyzc lnkxjs lncyrys czhsp dwkfd jrfzcp rlzbsp,fe dvarlag(W) errorlag(W) ivarlag(W:lnjyzc) ivarlag(M:lnkxjs) //多种空间滞后

***开始写作:
	cd "E:\学术论文\C论文\Data\govern expenditures\begining"
	use zongshuju_map.dta,clear
	brows
	spset
	grmap ybys,t(2017) name(general1)
	grmap gdp,t(2017) name(gdp) //命名可以同时显示多个图像窗口
	describe
	rename ybys general
	*各支出变量
	rename ggfw pubser_exp 
	rename gfzc defind_exp
	rename ggaq security_exp
	rename jyzc edu_exp
	rename kxjs science_exp
	rename whty culture_exp
	rename shbz social_exp
	rename ylws medical_exp
	rename hjbh envir_exp
	rename cxsq community_exp
	rename nlss agricul_exp
	rename jtys transport_exp
	rename qtbl others
	*控制变量
	rename cyrys employ_ctr
	rename czhsp urbanize_ctr
	rename dwkfd openness_ctr
	rename jrfzcp fianace_ctr
	rename rlzbsp hr_ctr
	save zhengshi.dta,replace //论文最完整数据,变量名称修改完毕

***聚类分析:
 **准备聚类分析数据:
	*首先计算每个省2007-2017年的均值:F3快捷键,选择下一个相同对象
	use zhengshi.dta,clear
	bysort _ID:egen m_gdp=mean(gdp) //按个体计算每个变量2007-2017年的均值
	bysort _ID:egen m_pubser_exp=mean(pubser_exp)
	bysort _ID:egen m_defind_exp=mean(defind_exp)
	bysort _ID:egen m_security_exp=mean(security_exp)
	bysort _ID:egen m_edu_exp=mean(edu_exp)
	bysort _ID:egen m_science_exp=mean(science_exp)
	bysort _ID:egen m_culture_exp=mean(culture_exp)
	bysort _ID:egen m_social_exp=mean(social_exp)
	bysort _ID:egen m_medical_exp=mean(medical_exp)
	bysort _ID:egen m_envir_exp=mean(envir_exp)
	bysort _ID:egen m_community_exp=mean(community_exp)
	bysort _ID:egen m_agricul_exp=mean(agricul_exp)
	bysort _ID:egen m_transport_exp=mean(transport_exp)
	keep if year ==2007
	save cluster.dta,replace //聚类数据整理完毕,并保存.
 **聚类分析:
 	clear
	use cluster.dta,clear	
	findname,local(varname)
	disp "`varname'"
	global clu_var m_gdp m_pubser_exp m_defind_exp m_security_exp m_edu_exp m_science_exp ///
m_culture_exp m_social_exp m_medical_exp m_envir_exp m_community_exp m_agricul_exp ///
m_transport_exp	
	
 *动态聚类:kmeans和kmedians
	cluster kmeans $clu_var,k(3) start(firstk) name(km3)
	cluster list km3
	bysort km3:list name,sep(31)

	cluster kmedians $clu_var,k(3) start(krandom) name(kmd3)
	cluster list kmd3
	bysort kmd3:list name,sep(31)

	cluster kmedians $clu_var,k(3) start(krandom(147258)) name(kmd3)
	cluster list kmd3
	bysort kmd3:list name,sep(31) //聚类结果最理想	

 *系统聚类,几种聚类方法的比较:
	*singlelinkage方法,结果不理想
	cluster singlelinkage $clu_var,name(slink3) 
	cluster stop slink3   			 //默认停止准则calinski,值大的理想,聚类结果不理想
	cluster stop slink3,rule(duda)   //停止准则duda,值小的理想,聚类结果不理想
	cluster tree slink3,labels(name) xlabel(,angle(45) labsize(*.75)) name(slink3)
	cluster generate sgroup3 =group(3),name(slink3) 
	bysort sgroup3:list name,sep(31)
	
	*completelinkage方法,结果较理想
	cluster completelinkage $clu_var,name(comlink3)
	cluster stop comlink3 			 //最大距离聚类,calinski准则显示聚为3类较好
	cluster stop comlink3,rule(duda) //duda准则也显示聚为3类较好
	cluster tree comlink3,labels(name) xlabel(,angle(45) labsize(*.75)) name(comlink3)
	cluster generate comgroup3 =group(3),name(comlink3) 
	bysort comgroup3:list name,sep(31) //结果较理想
	
	*centroidlinkage方法,结果较理想,和completelinkage方法结果一致
	cluster centroidlinkage $clu_var,name(cenlink3)
	cluster stop cenlink3 //重心法也显示聚为3类,结果较理想
	cluster tree cenlink3,labels(name) xlabel(,angle(45) labsize(*.75)) name(cenlink3)
		//centroidlinkage方法不能使用聚类树命令
	cluster generate cengroup3 =group(3),name(cenlink3) 
	bysort cengroup3:list name,sep(31)
	
	*wardslinkage方法,结果不理想,但是结果和complete,centroi方法结果一致
	cluster wardslinkage $clu_var,name(ward3)
	cluster stop ward3 //重心法也显示聚为3类
	cluster generate ward3 =group(3),name(ward3) 
	bysort ward3:list name,sep(31)	 
	
 *综合以上聚类结果,分为三类较理想,3 4 24,保存为clus变量,最终聚类结果以wards方法为准:
 	rename ward3 clus
 	save clustresult.dta,replace
 	*只保留一个变量clus,并保存文件
 	keep _ID clus
 	sort _ID
 	save clus.dta,replace
	*合并clus到zhengshi.dta中
 	clear
 	use zhengshi.dta,clear
 	merge m:1 _ID using clus.dta //合并聚类结果
 	drop _merge
 	save zhengshi_clus.dta,replace
 	use zhengshi_clus.dta,clear
 	use 市场化指数2007-2017,clear
 	merge 1:1 _ID year using 市场化指数2007-2017.dta //合并市场化指数数据
 	order _ID year area1
 	drop area1
 	drop _merge
 	rename total marindex_ctr
 	label variable marindex_ctr "樊纲，市场化指数"
 	save zhengshi_clus.dta,replace
 	
 	*输出聚类结果:用log方法输出结果:
 	log using log2docx.txt,text replace nomsg 	
 	use clustresult.dta,clear
 	bysort clus:list name,sep(31)
 	log close 

 	putdocx clear
 	putdocx begin
 	putdocx paragraph,style("Heading1")
 	putdocx text ("ward 's cluster result"),font(, 20)
 	file open fh using log2docx.txt,read
 	file read fh ling
 	putdocx paragraph,font("Courier", 9.5)
 	while r(eof) ==0{
 		putdocx text (`"`line'"'),linebreak
 		file read fh line
 	}
 	file close fh
 	putdocx save clustresult.docx,replace
 	di as txt`"(output written to {browse clustresult.docx})"'
 	erase log2docx.txt 	

***因子分析***
	clear
	cd "E:\学术论文\C论文\Data\govern expenditures\begining"
	use zhengshi_clus.dta,clear
	findname,local(varname)
	disp "`varname'"
	global fac_var pubser_exp defind_exp security_exp edu_exp science_exp culture_exp ///
		social_exp medical_exp envir_exp community_exp agricul_exp transport_exp //小心去掉wjzc数据,缺失太多
 **因子分析几种方法
	*pf法:
	factor $fac_var //默认pf法
	factor $fac_var,pf factors(3) //和上面的结果一样
	*一下命令大概看一下因子分析的结果：
	screeplot
	estat factors 	//极大似然法估计各因子的极大似然值,Heywood case表示是边界最优解
	estat structure //显示因子载荷矩阵,各变量和公因子之间的相关矩阵;
	estat common 	//显示各公因子相关矩阵
	estat residual,obs fit //显示原变量相关矩阵,拟合各变量相关矩阵,以及二者之差
	estat residual,sres    //标准化残差相关矩阵,小于1,模型可信
	estat smc  			   //显示复相关系数(correlation between one variables and the others)
 	estat kmo 			   //kmo检验(比较0.7),越大越适合因子分析;
	rotate  			   //默认正交旋转,varimax列方差平方和最大;
	estat rotatecompare    //比较旋转前后结果;
 	rotate,oblimin oblique //斜交旋转
 	*保存因子分析结果到word文件： 	
 	factor $fac_var,pf factors(3)
 	putdocx clear 
 	putdocx begin
 	*输出特征值矩阵：
 	putdocx table eigen = matrix(e(Ev)'), colnames rownames nformat(%7.4f) border(all, nil) border(top) border(bottom) 
 	putdocx table eigen(1,.),border(bottom)  //第一行有下边框
 	putdocx table eigen(.,2),halign(right) //所有数据右对齐
 	*输出因子载荷矩阵：
 	putdocx table load = matrix(e(L)),colnames rownames nformat(%7.4f) border(all,nil) border(top) border(bottom)
 	putdocx table load(1,.),border(bottom)
 	putdocx table load(.,2/4),halign(right)
 	*输出旋转后的因子载荷矩阵：
 	rotate
 	putdocx pagebreak
 	putdocx table load = matrix(e(r_L)),colnames rownames nformat(%7.4f) border(all,nil) border(top) border(bottom)
 	putdocx table load(1,.),border(bottom)
 	putdocx table load(.,2/4),halign(right)
 	*etable方法不可用：
 	//putdocx pagebreak
 	//putdocx table etab = etable,width(100%)
 	putdocx save factorresult.docx, replace
	di as txt `"(output written to {browse factortable.docx})"' //生成保存的mytable.docx超链接，点击可以打开该文件；
	shellout factorresult.docx

 	*计算因子得分
 	factor $fac_var,pf factors(3)
 	rotate
 	predict fund_exp effic_exp guard_exp,bartlett //基本,效率和保障支出3个公因子,brrstat是无偏的，方差较大，能提取出更多信息；
 	*以旋转后的公因子加权计算得到各地区的综合因子得分
 	--------------------------------------------------------------------------
         Factor  |     Variance   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      4.04554      0.37729            0.3868       0.3868
        Factor2  |      3.66824      1.00385            0.3508       0.7376
        Factor3  |      2.66439            .            0.2548       0.9924
    --------------------------------------------------------------------------
    				//以此特征值为权重，计算公因子综合得分：
    gen general_factors = (4.04554*fund_exp+3.66824*effic_exp+2.66439*guard_exp)/(4.04554+3.66824+2.66439)
    save zhengshi_factor.dta,replace
/*
***用因子得分再聚类看结果***聚类结果不理想
	use zhengshi_factor.dta,clear
	keep if year ==2017
	*completelinkage方法,北京上海一类，广东一类，其它28个一类，结果不理想。
	cluster completelinkage fund_exp effic_exp guard_exp,name(factclust3)
	cluster stop factclust3 			 //最大距离聚类,calinski准则显示聚为3类较好
	cluster stop factclust3,rule(duda) //duda准则也显示聚为3类较好
	cluster tree factclust3,labels(name) xlabel(,angle(45) labsize(*.75)) name(factclust3)
	cluster generate comgroup3 =group(3),name(factclust3) 
	bysort comgroup3:list name,sep(31) //结果较理想
*/
***使用聚类和因子得分结果进行回归
	cd "E:\学术论文\C论文\Data\govern expenditures\begining"
	use zhengshi_factor.dta,clear
	browse
	*人均gdp标准化
	summarize gdp
	gen sdgdp = (gdp-41955.82)/23819.12 //标准化的gdp进行回归
	
*缺失数据的处理,面板数据的线性插值:
	list employ_ctr year if employ_ctr ==.
	list hr_ctr year if hr_ctr ==.
		//employ_ctr和hr_ctr两个变量有缺失值:
	xtline employ_ctr
	xtline hr_ctr //可以看出二者随时间线性变化,可以使用对时间的线性插值法
	by _ID:mipolate employ_ctr year, gen(employ1_ctr) linear epolate //epolate指定外部线性插值
	list employ_ctr employ1_ctr year if employ_ctr ==.
	list employ_ctr employ1_ctr year in 1/50

	drop employ_ctr
	rename employ1_ctr employ_ctr
	save zhengshi_factor_miss.dta,replace

*开始回归:
	use zhengshi_factor_miss.dta,clear //使用缺失值处理过的数据
	
*混合回归:
	reg sdgdp i.clus##c.(fund_exp effic_exp guard_exp) *_ctr //混合回归结果很显著,使用聚类稳健标准误看结果:
	estimates store pooled
	reg sdgdp i.clus##c.(fund_exp effic_exp guard_exp) *_ctr,vce(cluster _ID)
	estimates store rpooled
	reg2docx pooled rpooled using pooledresult.docx,replace ///
	title("混合回归法产生的基本回归结果") mtitles("混合回归" "混合回归(聚类稳健标准误)") note("(* 0.1 ** 0.05 *** 0.01)")
		//混合回归结果很显著,但是考虑到存在固定效应,估计结果可能是不一致的,先进行Hausman检验:
*Hausman检验
	xtset _ID year
	*同方差下：
	xtreg sdgdp fund_exp effic_exp guard_exp *_ctr,re
	estimates store RE
	xtreg sdgdp fund_exp effic_exp guard_exp *_ctr,fe
	estimates store FE
	hausman FE RE,constant sigmamore //拒绝原假设，应该使用固定效应模型；
	*异方差下：
	xtreg sdgdp fund_exp effic_exp guard_exp *_ctr,re r //此时使用了聚类稳健标准误,存在异方差的情况下,hausman检验不再适用;
	xtoverid //拒绝了原假设，应该使用固定效应模型；
	
*hansman检验，存在固定效应，下面使用固定效应模型进行回归：
	xtreg sdgdp fund_exp effic_exp guard_exp *_ctr,fe //没有区域交互项时，fund_exp和guard_exp系数不显著，基本和保障支出已经不能较好地促进经济增长；
	estimates store Nointer		
	xtreg sdgdp fund_exp effic_exp guard_exp *_ctr,fe vce(cluster _ID) //固定效应模型,并且使用聚类稳健标准误处理异方差问题；
		//下面加入区域交互项：
	xtreg sdgdp fund_exp effic_exp guard_exp i.clus#c.(fund_exp effic_exp guard_exp) *_ctr,fe
	estimates store inter
		//系数变得显著，交互项系数个别地区也变得显著；
	
	*考虑其它影响机制，加入城镇化水平的交互项：
	xtreg sdgdp fund_exp effic_exp guard_exp i.clus#c.(fund_exp effic_exp guard_exp) c.fund_exp#c.urbanize_ctr#i.clus *_ctr,fe
	estimates store urban

	xtreg sdgdp fund_exp effic_exp guard_exp i.clus#c.(fund_exp effic_exp guard_exp) i.clus#c.urbanize_ctr *_ctr,fe
	estimates store urban#clus //三类地区的城镇化水平对相对较低,城镇化对经济增长的贡献还存在较大潜力,城镇化对经济增长的贡献显著为正,高于一,二类地区;

	xtreg sdgdp fund_exp effic_exp guard_exp i.clus#c.(fund_exp effic_exp guard_exp) c.fund_exp#c.fianace_ctr#i.clus *_ctr,fe
	estimates store fianace

	xtreg sdgdp fund_exp effic_exp guard_exp i.clus#c.(fund_exp effic_exp guard_exp) i.clus#c.fianace_ctr *_ctr,fe
	estimates store fian#clus //三类地区,系数显著为负,金融发展水平较差,金融服务经济发展能力较差,对经济增长的贡献显著低于一,二类地区

	*结果输出
 	reg2docx Nointer inter urban fianace using regresult.docx,replace ///
    title("区域差异回归") mtitles("Noarea" "area" "urban" "fianace") note("(* 0.1 ** 0.05 *** 0.01)") ///    
    drop(urbanize_ctr openness_ctr fianace_ctr hr_ctr marindex_ctr employ_ctr ///
	1b.clus#co.fund_exp 1b.clus#co.effic_exp 1b.clus#co.guard_exp)
 


*边际效应图:
	xtreg sdgdp fund_exp effic_exp guard_exp i.clus *_ctr
	estimates store Nointer
	marginscontplot2 effic_exp clus,var1(2) lineopts(lpattern(solid dash dash_dot)) //此时只有effic_exp的系数显著;
	
	xtreg sdgdp fund_exp effic_exp guard_exp i.clus i.clus#c.(fund_exp effic_exp guard_exp) *_ctr
	estimates store inter
	marginscontplot2 effic_exp clus,at1(-2(2)8) lineopts(lpattern(solid dash dash_dot))
	marginscontplot2 fund_exp clus,var1(2) lineopts(lpattern(solid dash dash_dot))
	marginscontplot2 guard_exp clus,var1(2) lineopts(lpattern(solid dash dash_dot))
	
	*考虑其它影响机制，加入城镇化水平的交互项：
	xtreg sdgdp fund_exp effic_exp guard_exp i.clus i.clus#c.(fund_exp effic_exp guard_exp) c.fund_exp#c.urbanize_ctr#i.clus *_ctr
	estimates store urban
	marginscontplot2 effic_exp clus,var1(2) lineopts(lpattern(solid dash dash_dot))  //明显看出三类区域,effic_exp对gdp增长影响的差异
	
	
	xtreg sdgdp fund_exp effic_exp guard_exp i.clus i.clus#c.(fund_exp effic_exp guard_exp) i.clus#c.urbanize_ctr *_ctr
	estimates store urban#clus
	marginscontplot2 effic_exp clus,var1(2) lineopts(lpattern(solid dash dash_dot))
	graph export bmi`v'.png
	marginscontplot2 fund_exp clus,var1(2) lineopts(lpattern(solid dash dash_dot))
	graph export bmi`v'.png
	marginscontplot2 guard_exp clus,var1(2) lineopts(lpattern(solid dash dash_dot))
	graph export bmi`v'.png

	putdocx begin
	putdocx table tbl = (2,2), border(all,nil) note(Figure 1: Predictive margins of agegrp) halign(center)
	putdocx table tbl(1,1)=image(bmi10.png) 
	putdocx table tbl(1,1)=("(a) bmi=10"), append halign(center)
	putdocx table tbl(1,2)=image(bmi20.png)
	putdocx table tbl(1,2)=("(b) bmi=20"), append halign(center)
	putdocx table tbl(2,1)=image(bmi30.png)
	putdocx table tbl(2,1)=("(c) bmi=30"), append halign(center)
	putdocx table tbl(2,2)=image(bmi40.png)
	putdocx table tbl(2,2)=("(d) bmi=40"), append halign(center)
	putdocx table tbl(3,.), halign(center) bold
	putdocx save marginsresult.docx,append
	di as txt `"(output written to {browse margingsresult.docx})"'

	



	xtreg sdgdp fund_exp effic_exp guard_exp i.clus#c.(fund_exp effic_exp guard_exp) c.fund_exp#c.fianace_ctr#i.clus *_ctr
	estimates store fianace

