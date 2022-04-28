*-------------------前期处理------------------------------------
cd "E:\stata系列\wmt_test\comparison"
sysuse nlsw88.dta, clear 
tab race, gen(race_num)
drop race_num1

******************************************************************
*                                                                *
*                        Word 输出                               *
*                                                                *
******************************************************************

*-----------------描述性统计输出-------------------------------
**-asdoc
! taskkill /F /IM WINWORD.EXE /T
local varlist "wage age race married grade collgrad south union occupation"
asdoc sum `varlist', save(Myfile.doc) replace ///
	stat(N mean sd min p50 max)  dec(3) ///
	title(asdoc_Table: Descriptive statistics)
/*
1. 在将结果导入到 word 的途中，Stata 界面也能看到相应的结果(下同)。
2. 该命令不支持中文。
3. 若有字符串变量，命令会报错。
*/


**-sum2docx
! taskkill /F /IM WINWORD.EXE /T
local varlist "wage age race married grade collgrad south union occupation"
sum2docx `varlist' using Myfile.docx,replace ///
	stats(N mean(%9.2f) sd(%9.3f) min(%9.2f) median(%9.2f) max(%9.2f)) ///
	title(sum2docx_Table: Descriptive statistics)
/*
1. 在将结果导入到 word 的途中，Stata 界面不能看到相应的结果(下同)。
2. 该命令支持中文。
3. 若有字符串变量，命令会报错。
4. 能分别设置每个统计量的小数点位数。
*/


**-outreg2
! taskkill /F /IM WINWORD.EXE /T
local varlist "wage age race married grade collgrad south union occupation"
outreg2 using Myfile, sum(detail) replace word eqkeep(N mean sd min p50 max) ///
	fmt(f) keep(`varlist') sortvar(wage age grade) ///
	title(outreg2_Table: Descriptive statistics)
/*
1. 在将结果导入到 word 的途中，Stata 界面能看到相应的结果(下同)。
2. 该命令不支持中文。
3. 若有字符串变量，命令会在窗口说明什么变量是字符型，并在报告列表中自动剔除该变量。
4. 支持变量排序。
*/


**-esttab
! taskkill /F /IM WINWORD.EXE /T
local varlist "wage age race married grade collgrad south union occupation"
estpost summarize `varlist', detail
esttab using Myfile.rtf, ///
	cells("count mean(fmt(2)) sd(fmt(2)) min(fmt(2)) p50(fmt(2)) max(fmt(2))") ///
	noobs compress replace title(esttab_Table: Descriptive statistics)
/*
1. 在将结果导入到 word 的途中，Stata 界面能看到相应的结果(下同)。
2. 该命令不支持中文(有些教程说可以对中文进行 gb18030 转码后导入，但本文试验不成功)。
3. 若有字符串变量，命令仍会直接运行，在输出列表中字符型变量名会写上去，但后面的统计量为空白。
4. 能分别设置每个统计量的小数点位数。
*/


**小结
/*
1. 在将结果导入到 word 的途中，命令 asdoc、outreg2、esttab能在 Stata 界面能看到相应的结果，而 sum2docx 不行(下同)。
2. 仅 sum2docx 支持中文，其余命令不支持。
3. 若变量里有字符串变量，outreg2 命令的处理最智能化。
4. sum2docx 和 esttab 能分别设置每个统计量的小数点位数，其他的命令不行。
5. 仅 outreg2 支持变量排序。
*/



*-----------------分组 T 均值检验输出------------------------------
**-asdoc
! taskkill /F /IM WINWORD.EXE /T
local common_exp "save(Myfile.doc) by(south) stat(obs mean p)"
asdoc ttest wage, `common_exp' replace title(asdoc_Table: T_test by group)
asdoc ttest age, `common_exp' rowappend 
asdoc ttest race, `common_exp' rowappend
asdoc ttest married, `common_exp' rowappend
asdoc ttest grade, `common_exp' rowappend
asdoc ttest collgrad, `common_exp' rowappend
asdoc ttest union, `common_exp' rowappend
/*
1. 每次只能检验一个变量, 当然它可以通过 rowappend 进行叠加，但这样麻烦不少。
2. 内容不完整，本身没有也无法添加 MeanDiff 一列。
*/


**-t2docx
! taskkill /F /IM WINWORD.EXE /T
local varlist "wage age race married grade collgrad union"
t2docx `varlist' using Myfile.docx,replace ///
	not by(south) title(t2docx_Table: T_test by group)
/*
1. 表格报告的内容剔除了所输入变量中包含缺漏值的观测值，且该操作无法被禁止。
2. 支持中文。
3. 有 MeanDiff 一列，并默认以"* p < 0.1 ** p < 0.05 *** p < 0.01"的方式标注星号。
*/


**-logout
! taskkill /F /IM WINWORD.EXE /T
local varlist "wage age race married grade collgrad union"
logout, save(Myfile) word replace: ttable2 `varlist', by(south)
/*
1. 能一次性分组 T 均值检验所有变量
2. 有 MeanDiff 一列，并默认以"* p < 0.1 ** p < 0.05 *** p < 0.01"的方式标注星号
3. 该命令不能书写表格标题。
*/


**-esttab
! taskkill /F /IM WINWORD.EXE /T
local varlist "wage age race married grade collgrad union"
estpost ttest `varlist', by(south)
esttab using Myfile.rtf, ///
	cells("N_1 mu_1(fmt(3)) N_2 mu_2(fmt(3)) b(star fmt(3))") starlevels(* 0.10 ** 0.05 *** 0.01) ///
	noobs compress replace title(esttab_Table: T_test by group) 
/*
1. 能一次性分组 T 均值检验所有变量。
2. 有 MeanDiff 一列，可设置以"* p < 0.1 ** p < 0.05 *** p < 0.01"的方式标注星号
3. 能分别设置每一列的小数点位数。
*/


**小结
/*
1. t2docx 表格报告的内容剔除了所输入变量中包含缺漏值的观测值，且该操作无法被禁止，研究者在查看输出结果时需要注意。其他的命令无此问题。
2. 在将结果导入到 word 的途中，命令 asdoc、logout、esttab能在 Stata 界面能看到相应的结果，而 t2docx 不行。
3. logout、esttab 和 t2docx 能一次性分组 T 均值检验所有变量，而 asdoc 需要多行命令，不太方便。
4. asdoc 输出的内容不完整，没有 MeanDiff 一列，更无法设置相应的星号标注，而其他命令无此问题。
5. logout 无法书写表格标题，而其他命令无此问题。
6. esttab 能设置每一列的小数点位数，而其他命令不行。
7. t2docx 支持中文，而其他的命令不行。
*/



*-----------------相关系数矩阵输出------------------------------
**-asdoc
! taskkill /F /IM WINWORD.EXE /T
local varlist "wage age race married grade collgrad"
asdoc cor `varlist', save(Myfile.doc) replace nonum dec(3) ///
	title(asdoc_Table: correlation coefficient matrix)
/*
1. 无法使用 asdoc pwcorr 命令，而简易的 asdoc cor 命令不能报告 p 值(显著性)，不能标星号。
*/


**-corr2docx
! taskkill /F /IM WINWORD.EXE /T
local varlist "wage age race married grade collgrad"
corr2docx `varlist' using Myfile.docx, replace spearman(ignore) pearson(pw) ///
	star title(corr2docx_Table: correlation coefficient matrix)
/*
1. 支持中文
2. 不能报告 p 值，但能以"* p < 0.1 ** p < 0.05 *** p < 0.01"的方式标注星号
*/


**-logout
! taskkill /F /IM WINWORD.EXE /T
local varlist "wage age race married grade collgrad"
logout, save(Myfile) word replace : pwcorr_a `varlist', ///
	star1(0.01) star5(0.05) star10(0.1)
/*
1. 可设置以"* p < 0.1 ** p < 0.05 *** p < 0.01"的方式标注星号。
2. 表格会有串行的问题，需要后期自己手动调整。
3. 不能设置表格标题。
*/
	

**-esttab
! taskkill /F /IM WINWORD.EXE /T
local varlist "wage age race married grade collgrad"
estpost correlate `varlist', matrix listwise
esttab using Myfile.rtf, ///
	unstack not noobs compress nogaps replace star(* 0.1 ** 0.05 *** 0.01) ///
	b(%8.3f) p(%8.3f) title(esttab_Table: correlation coefficient matrix)
/*
1. 能报告 p 值，可设置以"* p < 0.1 ** p < 0.05 *** p < 0.01"的方式标注星号。
*/


**小结
/*
1. corr2docx 支持中文，而其他命令不行。
2. esttab 既能报告 p 值，也能以一般文献的要求报告星号，logout 也可以，但有串行的问题；corr2docx 只能标注星号；asdoc 都不能做。
3. logout 不能设置表格标题，而其他的命令可以。
*/



*-----------------回归结果输出------------------------------
**-asdoc
! taskkill /F /IM WINWORD.EXE /T
asdoc reg wage age married occupation, save(Myfile.doc) nest replace ///
	cnames(OLS-1) rep(se) add(race, no)
asdoc reg wage age married collgrad occupation, save(Myfile.doc) nest append ///
	cnames(OLS-2) add(race, no)
asdoc reg wage age married collgrad occupation race_num*, save(Myfile.doc) nest append ///
	add(race, yes) cnames(OLS-3) dec(3) drop(occupation race_num*) ///
	stat(r2_a, F, rmse, rss) title(asdoc_Table: regression result)
/*
1. 可添加不同列的列名。
2. 没有诸如 indicate("race=race_num*") 的选项，需用 add(race, yes) 代替。
3. 不能对变量进行排序。
4. 表格布局与一般的文献不同，且不能用命令调整。
*/


**-reg2docx
! taskkill /F /IM WINWORD.EXE /T
reg wage age married occupation
est store m1
reg wage age married collgrad occupation
est store m2
reg wage age married collgrad occupation race_num*
est store m3
reg2docx m1 m2 m3 using Myfile.docx, replace indicate("race=race_num*") ///
	b(%9.2f) se(%7.2f) scalars(r2(%9.3f) r2_a(%9.2f) N) ///
	drop(occupation) order(married) ///
	title(reg2docx_Table: regression result) ///
	mtitles("OLS-1" "OLS-2" "OLS-3") 
/*
1. 可添加不同列的列名
2. 有诸如 indicate("race=race_num*") 的选项。
3. 命令运行之后会将所有已经储存的回归结果清除，导致后面无法再继续使用前面的回归结果。
4. 支持中文。
*/


**-outreg2
! taskkill /F /IM WINWORD.EXE /T
local subexp "nor2 noobs e(r2 r2_a F N) fmt(f) bdec(2) sdec(2) drop(occupation race_num*) sortvar(married)"
reg wage age married occupation
outreg2 using Myfile, word replace title(outreg2_Table: regression result) ///
	ctitle(OLS-1) `subexp' addtext(race, no)
	
reg wage age married collgrad occupation
outreg2 using Myfile, word append ctitle(OLS-2) `subexp' addtext(race, no)

reg wage age married collgrad occupation race_num*
outreg2 using Myfile, word append ctitle(OLS-3) `subexp' addtext(race, yes)
/*
1. 可添加不同列的列名。
2. 没有诸如 indicate("race=race_num*") 的选项，需用 addtext(race, yes) 代替。
*/

**-esttab
! taskkill /F /IM WINWORD.EXE /T
reg wage age married occupation
est store m1
reg wage age married collgrad occupation
est store m2
reg wage age married collgrad occupation race_num*
est store m3
esttab m1 m2 m3 using Myfile.rtf, ///
	replace star( * 0.10 ** 0.05 *** 0.01 ) nogaps compress ///
	order(married) drop(occupation) b(%20.3f) se(%7.2f)  ///
	r2(%9.3f) ar2 aic bic obslast scalars(F)  ///
	indicate("race=race_num*") mtitles("OLS-1" "OLS-2" "OLS-3") ///
	title(esttab_Table: regression result) 
/*
1. 可添加不同列的列名。
2. 有诸如 indicate("race=race_num*") 的选项。
3. 表格形式最符合一般文献报告表格的格式。
*/


**小结
/*
1. 都可添加不同列的列名。
2. reg2docx 和 esttab 都有诸如 indicate("race=race_num*") 的选项，而其他命令都需要手动添加。
3. reg2docx 运行之后会将所有已经储存的回归结果清除，导致后面无法再继续使用前面的回归结果。而 esttab 无此问题。
4. reg2docx 支持中文，而其他命令不能。
5. 相对于其他命令，esttab 输出到 Word 的表格形式最符合一般文献报告表格的格式。
*/




******************************************************************
*                                                                *
*                        LaTeX 代码输出                          *
*                                                                *
******************************************************************
/*
以上四个命令中，只有 out_log 和 esttab 支持 LaTeX 代码输出
*/

*-------------------------out_log 系列------------------------------
*描述性统计输出
local varlist "wage age race married grade collgrad south union occupation"
outreg2 using Myfile, sum(detail) replace tex eqkeep(N mean sd min p50 max) ///
	fmt(f) keep(`varlist') sortvar(wage age grade) ///
	title(outreg2_Table: Descriptive statistics)
/*
默认：输出一个完整的可以编译的但格式较为简易 .tex 文件，表格默认居左对齐。
outreg2 的 tex() 的专有选项：
1. fragment：只输出表格本身。
2. pretty：在默认的基础上增加了更为丰富的格式，并将表格居中对齐。
3. landscape：横置页面。
*/


*分组 T 均值检验输出
local varlist "wage age race married grade collgrad union"
logout, save(Myfile) tex replace: ttable2 `varlist', by(south)
/*
1. LaTeX 输出不能增加表格标题。
2. logout 的 tex 没有选项，只有默认形式。
*/


*相关系数矩阵输出
local varlist "wage age race married grade collgrad"
logout, save(Myfile) tex replace : pwcorr `varlist', ///
	star(0.05) listwise
/*
1. 表格会有串行的问题，需要后期自己手动调整。
2. LaTeX 输出不能增加表格标题。
3. logout 的 tex 没有选项，只有默认形式。
*/


*回归结果输出
local subexp "tex nor2 noobs e(r2 r2_a F N) fmt(f) bdec(2) sdec(2) drop(occupation race_num*) sortvar(married)"
reg wage age married occupation
outreg2 using Myfile, replace title(outreg2_Table: regression result) ///
	ctitle(OLS-1) `subexp' addtext(race, no)
reg wage age married collgrad occupation
outreg2 using Myfile, append ctitle(OLS-2) `subexp' addtext(race, no)
reg wage age married collgrad occupation race_num*
outreg2 using Myfile, append ctitle(OLS-3) `subexp' addtext(race, yes)


*小结
/*
1. out_log 针对每个输出部分都能导出结果，但每个部分前后不能 append 在一起。
本文测试过，如果用命令强行 append，表格内容会乱套。所以，如果要使用该命令
导出 LaTeX 代码，建议自己先写一个总的 LaTeX 框架，然后针对每个导出的部分
采用 \input{} 命令即可。
2. 表格本身也存在着一些小问题，如采用 logout 命令的部分无法书写表格标题，表格可能会出现串行。
*/


*-------------------------esttab 系列------------------------------
*描述性统计输出
local varlist "wage age race married grade collgrad south union occupation"
estpost summarize `varlist', detail
esttab using Myfile.tex, ///
	cells("count mean(fmt(2)) sd(fmt(2)) min(fmt(2)) p50(fmt(2)) max(fmt(2))") ///
	noobs compress replace title(esttab_Table: Descriptive statistics) ///
	booktabs  page(array, makecell) alignment(cccccc) width(\hsize)
/*
esttab 的 LaTeX 输出的专有选项：
1. booktabs: 用 booktabs 宏包输出表格(三线表格)。
2. page[(packages)]: 创建完成的 LaTeX 文档以及添加括号里的宏包
3. 如果写了 booktabs 选项，则 page[(packages)] 将自动添加\usepackage{booktabs}。
4. alignment(cccccc)：定义从第二列开始的列对齐方式(默认居中)。
5. width(\hsize)：可以使得表格宽度为延伸至页面宽度
6. fragment：不输出表头表尾，只输出表格本身内容，其不能与 page[(packages)] 选项共存。
*/


*分组 T 均值检验输出
local varlist "wage age race married grade collgrad union"
estpost ttest `varlist', by(south)
esttab using Myfile.tex, ///
	cells("N_1 mu_1(fmt(3)) N_2 mu_2(fmt(3)) b(star fmt(3))") starlevels(* 0.10 ** 0.05 *** 0.01) ///
	noobs compress append title(esttab_Table: T_test by group) ///
	booktabs  page width(\hsize)
/*
1. 这里的 page 选项可以将本部分附着在先前的 document 环境中，从而形成一个整体。
*/


*相关系数矩阵输出
local varlist "wage age race married grade collgrad"
estpost correlate `varlist', matrix listwise
esttab using Myfile.tex, ///
	unstack not noobs compress nogaps append star(* 0.1 ** 0.05 *** 0.01) ///
	b(%8.3f) p(%8.3f) title(esttab_Table: correlation coefficient matrix) ///
	booktabs  page width(\hsize)


*回归结果输出
reg wage age married occupation
est store m1
reg wage age married collgrad occupation
est store m2
reg wage age married collgrad occupation race_num*
est store m3
esttab m1 m2 m3 using Myfile.tex, ///
	append star( * 0.10 ** 0.05 *** 0.01 ) nogaps compress ///
	order(married) drop(occupation) b(%20.3f) se(%7.2f)  ///
	r2(%9.3f) ar2 aic bic obslast scalars(F)  ///
	indicate("race=race_num*") mtitles("OLS-1" "OLS-2" "OLS-3") ///
	title(esttab_Table: regression result) booktabs  page width(\hsize)
*小结
/*
1. 这里所有的表格都可以生成标题，也没有串行的问题。
2. 与 out_log 不一样，esttab 能形成一个整体，所有的表格都能完美的 append 在一起，
并且可以设置生成导言区和正文区的 document 环境。所以以上命令生成的 .tex 文件可以
直接拿去编译，并生成所有表格，一步到位。之后我们再统一做一些微调就可以放在 LaTeX
正文中了。
*/
