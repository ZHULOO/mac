	cd E:\data
***安装官网以外的命令***
**使用github命令
*下载 github 命令
 	net install github,from("https://haghish.github.io/github/") replace
*下载 lxh 命令
	github install arlionn/lxh, replace //也安装到了ado文件夹下
	github uninstall devtools 			//卸载命令
	ado uninstall github      			//卸载ado命令
	adoupdate moremata, update 			//升级moremata命令
**net install命令
	net install lxh,from(https://raw.github.com/arlionn/lxh/master/) replace
*连接超时，将连接时间设置到100分钟
	set timeout1 6000
	set timeout2 6000

***xi:***
*如果命令不适用因子变量，前面加xi:,如果命令适用因子变量，则直接适用命令
	sysuse auto,clear
	regress price i.rep78    //直接用rep78生成的虚拟变量回归，原数据不变;
	xi:regress price i.rep78 //xi:会在数据中生成rep78的虚拟变量，然后回归,如果数据中已生成过虚拟变量,则不再生成;
	reg price weight length i.rep78 //加法式,对应rep78=2,3,4,5的情况生成四个虚拟变量,都为0时对应rep78=1;
	reg price weight length c.weight#i.rep78 //c表示连续性变量和i表示的虚拟变量交互项;
	reg price length c.weight##i.rep78 //双#号,对两个变量本身以及交互项都加入回归;
*下面命令是等价的：
	xi:reg mpg i.rep78*price //先用rep78虚拟变量和price乘积生成新的变量作为自变量进行回归;
		//相当于下面两步的内容:
	xi:i.rep78*price 	   //根据rep78生成虚拟变量，生成的虚拟变量和price相乘生成新的变量
	reg mpg _Irep78* _IrepXprice*

*Factor variables:因子变量 
There are five factor-variable operators:
Operator  Description
         -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
         i.        unary operator to specify indicators
         c.        unary operator to treat as continuous
         o.        unary operator to omit a variable or indicator
         #         binary operator to specify interactions
         ##        binary operator to specify factorial interactions
		 i.group           indicators for levels of group
         i.group#i.sex     indicators for each combination of levels of group and sex, a two-way interaction
         group#sex         same as i.group#i.sex
         group#sex#arm     indicators for each combination of levels of group, sex, and arm, a three-way interaction
         group##sex        same as i.group i.sex group#sex
         group##sex##arm   same as i.group i.sex i.arm group#sex group#arm sex#arm group#sex#arm
         sex#c.age         two variables -- age for males and 0 elsewhere, and age for females and 0 elsewhere; if age is also in the model, one of the two virtual variables will be treated as a base
         sex##c.age        same as i.sex age sex#c.age
         c.age             same as age
         c.age#c.age       age squared
         c.age#c.age#c.age age cubed
You can specify the base level of a factor variable by using the ib. operator.  The syntax is

         Base          
         operator(*)    Description
         ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
         ib#.           use # as base, #=value of variable
         ib(##).        use the #th ordered value as base (**)
         ib(first).     use smallest value as base (the default)
         ib(last).      use largest value as base
         ib(freq).      use most frequent value as base
         ibn.           no base level
         ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
         (*) The i may be omitted.  For instance, you may type ib2.group or b2.group.
         (**) For example, ib(#2). means to use the second value as the base.
    	 Thus, if you want to use group=3 as the base in a regression, you can type
         regress y  i.sex ib3.group
Examples                  Expansion
         -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
         i.(group sex arm)         i.group i.sex i.arm
         group#(sex arm cat)       group#sex group#arm group#cat
         group##(sex arm cat)      i.group i.sex i.arm i.cat group#sex group#arm group#cat
         group#(c.age c.wt c.bp)   i.group group#c.age group#c.wt group#c.bp
         group#c.(age wt bp)       same as group#(c.age c.wt c.bp)



***reghdfe*** 解决多重固定效应和多重聚类标准误的问题！
	*https://github.com/sergiocorreia/reghdfe
	*Within Stata, it can be viewed as a generalization of areg/xtreg, with several additional features:
	1.Supports two or more levels of fixed effects.
	2.Supports fixed slopes (different slopes per individual).
	3.It can estimate not only ols regressions but two-stage least squares, instrumental-variable regressions, 
	  and linear gmm (via the ivreg2 and ivregress commands).
	4.Two-way and multi-way clustering.
	5.Advanced options for computing standard errors, thanks to the avar command.
	6.Careful estimation of degrees of freedom, taking into account nesting of fixed effects within clusters, 
	  as well as many possible sources of collinearity within the fixed effects.
	7.Iterated elimination of singleton groups.
	8.Even with only one level of fixed effects, it is faster than areg/xtreg.
* Install ftools (remove program if it existed previously)
cap ado uninstall ftools
net install ftools, from("https://raw.githubusercontent.com/sergiocorreia/ftools/master/src/")

* Install reghdfe 5.x
ado uninstall reghdfe
net install reghdfe, from("https://raw.githubusercontent.com/sergiocorreia/reghdfe/master/src/")

* Install boottest for Stata 11 and 12,stata15不用安装
if (c(version)<13) cap ado uninstall boottest
if (c(version)<13) ssc install boottest

* Install moremata (sometimes used by ftools but not needed for reghdfe)
	ssc install moremata	//安装时间太长，下面通过
*手动安装的四个步骤：
	1. Download "moremata.zip" from http://fmwww.bc.edu/repec/bocode/m/moremata.zip
	2. Unzip "moremata.zip" into a temporary directory on your hard disk (e.g. c:\temp).
	3. Start Stata and type -net from C:\ado\moremata- or wherever you unzipped the files.
		net from C:\ado\moremata   
	4. Type -net install moremata, replace-.
	net install moremata, replace
	adoupdate moremata, update  //安装完可以升级看是不是最新的
	ftools, compile
	reghdfe, compile
*reghdfe命令适用案例：	
	use auto,clear
*Simple case - one fixed effect
	reghdfe price weight length,absorb(rep78)	//rep78分类的固定效应；
*As above, but also compute clustered standard errors
	reghdfe price weight length, absorb(rep78) vce(cluster rep78) //同时适用rep78聚类的稳健标准误；
	reghdfe price weight length, absorb(rep78 turn##c.price)
*Two and three sets of fixed effects
	webuse nlswork,clear
	save nlswork.dta,replace
	use nlswork,clear
	reghdfe ln_w grade age ttl_exp tenure not_smsa south , absorb(idcode year)
	reghdfe ln_w grade age ttl_exp tenure not_smsa south , absorb(idcode year occ) //三重固定效应；
*IV regression (this does NOT work anymore, please use the ivreghdfe package instead
	ssc install ivreghdfe
	use auto,clear
	ivreghdfe price weight (length=head), absorb(rep78) //还提供了过度识别、不可识别和弱工具变量检验的结果；
	ivreghdfe price weight (length=head), absorb(rep78, resid)

fsum命令：给出多个变量的描述统计表,类似与tabstat命令
	sysuse auto,clear
	fsum price weight length foreign
    fsum price weight length foreign, f(10.3) s(n abspct mean median p95 sum)
    fsum price weight length foreign, s(N mean median lci uci sum) u l 	//uselabel选项表示显示变量标签,label变量标签显示在表格右边
    fsum price weight length foreign,mcat(foreign) cat(foreign) 		//cat或者mcat显示分类变量各类的描述统计
    fsum price weight length foreign, not(foreign) f(%9.1f) 			//not(foreign)不显示foreign的描述统计
    tabstat price weight mpg rep78, by(foreign) stat(mean sd min max) nototal long col(stat)

eststo命令：快捷制表
	findit eststo
	reg risei male age
	eststo
	reg risei male age feduy fisei
	eststo
	reg risei male age feduy fisei educ_y
	eststo
	esttab using table.rtf, b(3) se(3) star(+0.10 * 0.05 ** 0.01 *** 0.001) nogaps r2 replace 
	eststo clear

carryforward命令:用前面的值填充缺失值
	ssc install carryforward

assertky命令:判断变量是不是唯一代表obs的键值
	assertky make  						//make无重复值,每个取值都是唯一的;
	assertky mpg,gen_n(n) gen_N(N) 		//gen_n给每个重复值组内编号,gen_N生成每个值重复的次数;


isid命令：判断变量是否唯一地表示obs
	sysuse auto,clear
	isid mpg
	isid make
	replace make = "" in 1
	isid make,missok
	use grunfeld,clear
	isid company year

contract命令：变量的每一个组合对应的obs个数
	contract foreign rep78 			//foreign和rep78的每一个取值组合对应的频数
	contract foreign rep78, zero 	//每一个可能的组合都显示,包括频率为0的

expand命令：扩充obs的数量为n倍
	expand 3
duplicates命令：报告、标记或删除重复的obs
	sysuse auto,clear
    keep make price mpg rep78 foreign
    expand 3 in 1/2 				//将前两个obs扩展为2倍
    duplicates report 				//所有obs重复的情况
    duplicates examples 			//列出重复的obs
    duplicates tag,gen(dup)
    duplicates list
    duplicates drop 				//去重
    
fs命令:列出当前目录下的文件			//help fs 
	ssc install fs
	fs *.csv //列出文件名列表并保存在local变量r(files)中
	fs s*.dta
	`r(files)'






macro 		//help macro
    


clickout
    ldta
    ltex
    cdout
    fastcd
