		  
*       ==========================
*          第16章  长面板和动态面板
*       ==========================

*16.1长面板的估计策略
*1、短面板的T较小，无法探讨扰动项的自相关问题，一般假设扰动项为iid；
*2、长面板的T较大，可以放松扰动项iid的假定，考虑扰动项存在异方差和自相关的问题；
*3、长面板的T较大，n较小，由于可能存在固定效应，只需要加入个体虚拟变量即可（LSDV），
*  对于时间效应，生成虚拟变量太多，损失自由度；
*4、考虑扰动项存在异方差和自相关的几个情形：不同个体截面数据容易产生异方差，同一个体不同时间的时间序列数据容易产生自相关
*	组间异方差：个体i的扰动项方差各不相同；
*	组内自相关：同一个体不同时间上的扰动项相关；
*	组间同期相关：截面相关，同一时期，不同个体之间的扰动项相关，也称空间相关。
*5、有两种方法处理组间异方差、组内自相关和组间同期相关问题：
*	方法一：LSDV方法来估计系数，只对标准误差进行校正（面板校正标准差）；
*	方法二：对异方差和自相关的形式进行假设，然后用FGLS进行估计。

*16.2面板校正标准误
*1、如果模型扰动项存在组间异方差和组间同期相关，使用LSDV估计是一致的。
*2、此时只需要使用"组间异方差、组间同期相关"稳健的标准误（面板校正标准误PCSE）即可，stata命令：
	cd E:\data
	use mus08cigar.dta,clear
	br

	gen t = year-62
	reg lnc lnp lnpmin lny i.state t,vce(cluster state) //LSDV法，双向固定效应模型，为了节省参数，仅引入一个时间趋势项t，代替T-1个时间虚拟变量；
	estimates store OLS
	//此时稳健标准误未考虑可能存在的组间异方差和组间同期相关，为此可以使用面板校正标准误：
	xtpcse lnc lnp lnpmin lny i.state t
	estimates store PCSE
	//上面reg和xtpcse估计的系数是一样的，只是标准误不同，面板校正标准误差似乎反而更小。

*16.3解决组内自相关的FGLS
*1、假设扰动项存在组内一阶自回归；
*2、使用Paris-Winsten估计法对原模型进行广义差分变换，即可得到FGLS估计量。stata命令：
    //xtpcse y x1 x2 x3,corr(ar1) corr(psar1) //ar1每个个体的自回归系数ρ相等，psar1每个个体有自己的自回归系数ρ
*3、使用xtpcse除了提供面板校正标准误，还提供当存在组内自相关时的选项，corr(ar1):
	xtpcse lnc lnp lnpmin lny i.state t,corr(ar1) //除了组间异方差和组间同期相关，还存在组内自相关的情况
	estimates store AR1
	//和上面没考虑组内自相关的情形比较，系数变化较大，继续考虑组内自相关，且自回归系数不同的组内自相关情形：
	xtpcse lnc lnp lnpmin lny i.state t,corr(psar1) //组内自相关系数不同组内自相关
	estimates store PSAR1

	//将以上集中结果输出到同一表格，对比结果：
	reg2docx OLS PCSE AR1 PSAR1 using e:\temp\panelar1.docx,replace ///
    scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("psar results") ///
    mtitles("OLS" "PCSE" "AR1" "PSAR1") note("(* 0.1 ** 0.05 *** 0.01)")
    //比较LSDV、PCSE以及"仅考虑组内自相关的PCSE"，结果，究竟选择哪一种需要要下面的组内自相关检验

*16.4全面FGLS  
*1、上面的xtpcse提供了组间异方差和组间同期相关稳健的面板校正标准误差，进行FGLS时仅考虑了组内自相关，并未同时考虑组间异方差和组间同期相关；
*2、全面的FGLS：同时考虑组间异方差、组间同期相关和组内自相关的三个因素。stata命令如下：
	//xtgls y x1 x2 ,panels(option) corr(option) igls 
	//panels(iid)假定组间同期无自相关且同方差；
	//panels(het)假定组间同期无自相关，但异方差；
	//panels(cor)假定组间同期相关且组间异方差；
	//corr(option) ar1每个个体组内自相关，且自回归系数相同，psar1每个个体组内自相关，自回归系数不同
	//igls迭代FGLS
	xtgls lnc lnp lnpmin lny i.state t,panels(cor) cor(ar1)   //全面FGLS:组间同期相关、组间异方差并且组内自相关同时存在的情况，各组自回归系数相同
	xtgls lnc lnp lnpmin lny i.state t,panels(cor) cor(psar1) //各组自回归系数不同
	//使用何种FGLS，取决于组间异方差、组间同期相关和组内自相关的检验
*3、OLS+面板校正标准误差最为稳健，
*	全面FGLS最有效率
*	仅解决组内自相关的FGLS介于二者之间

*16.5组间异方差的检验
*1、Greene提供了一个组间异方差的Wald检验，原假设组间时同方差的；
*2、此Wald检验使用非官方命令xttest3进行，该命令只能在xtreg , fe或者xtgls之后使用：
	ssc install xttest3
	qui xtreg lnc lnp lnpmin lny t,r fe 
	xttest3 
	//或者如下，结果是一样的：
	qui xtgls lnc lnp lnpmin lny i.state t
	xttest3 //结果拒绝原假设，认为存在组间异方差

*16.6组内自相关的检验
*1、Greene提供了一个组内自相关的Wald检验，原假设不存在组内自相关；
*2、此Wald检验使用非官方命令xtseria进行，output选项表示现实一阶差分回归的结果
	tabulate state ,gen(state) //xtserial不接受i.state表示的虚拟变量，先生成州虚拟变量；
	xtserial lnc lnp lnpmin lny state2-state10 t //p值小于0.05，拒绝原假设，认为存在组内自相关。

*16.7组间同期相关的检验
*1、Greene提供了一个组间同期相关的Breusch-Pagan LM检验，原假设不存在组间同期相关；
*2、此检验使用非官方命令xttest2进行，该命令只能在xtreg , fe、xtgls和ivreg2之后使用：
	ssc install xttest2 //安装；
	xtreg lnc lnp lnpmin lny t,fe 
	xttest2 //p值小于0.05，拒绝原假设，认为存在同期相关。

*3、以上LM检验缺陷，仅适用于长面板，另一个非官方命令xtcsd（cross-sectional dependence）
*	还适用于短面板，，原假设不存在同期相关，xtcsd必须在xtreg之后使用。
	ssc install xtcsd 
	xtcsd,pesaran abs show //Pesaran(2004)
	xtcsd,friedman abs show //friedman(1937)
	xtcsd,frees abs show //frees(1995,2004) show显示残差的相关系数矩阵，abs显示该矩阵的非主对角线元素绝对值之平均。
	xtreg lnc lnp lnpmin lny t,fe
	xtcsd,pesaran //p值小于0.05，拒绝原假设，认为存在同期相关。

*16.8变系数模型
*长面板，样本容量大，每个个体可以拥有自己的截距项和时间趋势项之外，每个个体的回归方程斜率也可以不同
*可变系数可视为常数和随机变量

*1、将可变系数视为常数，对每个个体分别回归，效率不高，忽略了个体之间扰动项相关的可用信息。
*2、所有个体方程堆叠，然后使用似不相关回归SUR，对整个方程系统进行系统估计，但是估计参数较多，损失自由度。
*3、可以考虑部分变系数模型，即β中的部分系数依个体而变，其余系数不变。不再适用SUR,方程扰动项相关，不变的系数造成跨方程约束。
*4、此时可以使用LSDV方法，引入个体虚拟变量，以及虚拟变量与可变系数之解释变量的交互项：
	reg lnc lnp lnpmin lny i.state i.state#c.lny t,vce(cluster state) //交互项显著，说明应该使用变系数模型

*5、将可变系数视为随机系数，β视为随机变量，Swamy（1970）提出可用FGLS来估计此模型
*6、随机系数stata命令
	//xtrc y x1 x2 ,betas //betas表示显示每组系数的估计，原假设为各组系数都相等，拒绝原假设则认为应该使用变系数模型。
	xtrc lnc lnp lnpmin lny,beta //显示每个个体的回归系数，并检验是否相同

*16.9面板工具变量法
*虽然面板数据在一定程度上解决了遗漏变量造成的内生性问题，但是模型本身包含内生解释变量，仍然需要工具变量法
*一般分为两步：第一步首先使用FE或RE进行变换以解决遗漏变量问题，第二步对变换后的模型使用2SLS
*1、对固定效应模型，先进性离差变换，再使用工具变量法，均值差分或者一阶差分后，使用2SLS
	xtivreg y [varlist1] (varlist2 = varlist_iv),fe //或者fd fe表示均值差分 fd表示一阶差分
*2、随机效应模型使用工具变量法，先进行FGLS变换后，再进行2SLS回归
	xtivreg y [varlist1] (varlist2 = varlist_iv),re //re表示随机效应模型，先离差变换再2SLS
	//xtivreg不提供聚类稳健标准误选项，使用vce(bootstrap)得到自助标准误
*3、当工具变量个数多于内生解释变量的个数时，对面板数据进行GMM估计会更有效率，但是需要外部命令xtivreg2，
*	该命令只能处理固定效应模型，先进行FE  FD变换后再使用GMM估计：
	ssc install xtivreg2
	xtivreg2 y [varlist1] (varlist2 = varlist_iv),fe gmm
	xtivreg2 y [varlist1] (varlist2 = varlist_iv),fd gmm
*4、面板工具变量法的过度识别检验
*	非官方命令xtoverid来实现，运行在xtreg xrivreg xtivreg2 和xthtaylor命令之后，ssc install xtoverid

*16.0豪斯曼-泰勒估计量
*固定效应模型差分掉了个体不随时间而变得变量，无法估计它们的系数，例如，性别和受教育程度等 
*如果有工具变量，直接使用工具变量法进行估计，需要找到与内生解释变量相关，但是与个体效应ui无关的工具变量
*对以上情况使用2SLS估计，就得到Hausman-Taylor估计量，Amemiya and Macurdy（1986）提出所有外生变量的均值差分也作为工具变量
*Hausman-Taylor估计量的stata命令：
	xthtaylor depvar indepvar,endog(varlist) amacurdy 

*16.11 动态面板
*滞后被解释变量作为解释变量，组内估计量FE也是不一致的，称为“动态面板偏差”。均值差分后的被解释变量与均值差分后的扰动项是相关的。
*n较小 T较大的动态长面板偏差较小，可通过校正偏差的方法得到一致估计；
*n较大 T较小的短动态面板：
*1、差分GMM：先一阶差分消除个体效应，再用滞后变量作为差分变量的的工具变量进行2SLS估计，Anderson-Hsiao估计量（1981）；
*	所有可能的滞后变量作为工具变量，此时工具变量个数多于内生变量的个数，使用GMM估计，Arellano-Bond估计量，称为差分GMM；
*2、差分GMM的前提是不存在组内自相关
*3、水平GMM：对水平方程进行回归，使用差分被解释变量作为工具变量；
*4、水平GMM的前提是，扰动项不存在组内自相关，而且差分被解释变量与个体效应ui不相关；
*5、系统GMM：将差分GMM和水平GMM作为一个方程系统进行GMM估计

*16.12动态面板的stata命令及实例
*1、差分GMM
	xtabond depvar indepvar ,lags(p) maxldep(q) twostep vce(robust) pre(varlist) endogenous(varlist) inst(varlist)
	//indepvar 严格外生的解释变量；
	//lags(p) 使用被解释变量的p阶滞后值作为解释变量，默认p=1；
	//maxldep(q) 最多使用q阶被解释变量作为工具变量，默认使用所有可能的滞后值；
	//twostep表示使用GMM，默认方法使用2SLS；
	//vce(robust)使用文件标准误，允许扰动项存在异方差；
	//inst(varlist)指定额外的工具变量

*2、系统GMM
	xtdpdsys depvar indepvar,lags(p) maxldep(q) twostep vce(robust) pre(varlist) endogenous(varlist) inst(varlist)	

*动态面板实例  //官方命令xtabond和xtdpdsys出错了，用xtabond2非官方命令。
	use mus08psidextract.dta,clear
	xtabond lwage occ south smsa ind,lags(2) maxldep(3) twostep vce(robust) pre(wks,lag(1,2)) endogenous(ms,lag(0,2)) endogenous(union,lag(0,2))
	est sto DiffGMM
	//pre(wks,lag(1,2))表示wlk的一阶滞后为前定解释变量，而使用2个更高阶的(即wlk的2阶和3阶)滞后值为工具变量；
	//endogenous(ms,lag(0,2))表示ms为内生解释变量，不包含任何滞后情况，而使用2个更高阶的(即ms的2阶和3阶)滞后值为工具变量。
	estat abond //检验扰动项是否存在自相关
	estat abond,artests(3) //检验是否存在更高阶（3阶）的自相关
	//由于使用了过多的工具变量，需要进行过度识别检验，去掉vce(robust)项，再次xtabond估计
	xtabond lwage occ south smsa ind,lags(2) maxldep(3) twostep pre(wks,lag(1,2)) endogenous(ms,lag(0,2)) endogenous(union,lag(0,2))
	estat sargan //过度识别检验，下面使用系统GMM来估计
	xtdpdsys lwage occ south smsa ind,lags(2) maxldep(3) twostep vce(robust) pre(wks,lag(1,2)) endogenous(ms,lag(0,2)) endogenous(union,lag(0,2))
	est sto sysGMM
	estat abond //检验扰动项是否存在自相关
	estat sargan //过度识别检验
*3、官方命令xtabond和xtdpdsys均不提供异方差稳健的hansen统计量（仅提供基于iid的假设的sargan统计量）
*	使用非官方命令xtabond2，提供hansen统计量：稳健，受工具变量过多的影响
*	Sargan统计量；不够稳健，但是不受工具变量过多的影响
	ssc install xtabond2
	xtabond2 y l.y l2.y x1 x2 x3,gmmstyle(varlist) ivstyle(varlist) nolevel twostep vce(robust)
	//l.y l2.y被解释变量的两阶滞后作为解释变量
	//gmmstyle(varlist)指定GMM式工具变量
	//ivstyle(varlist)指定iv式工具变量
	//nolevel不估计水平方程，即估计差分方程。默认的是系统GMM
	xtabond2 lwage L(1/2).lwage L(0/1).wks ms union occ south smsa ind,gmm(lwage,lag(2 4)) gmm(wks ms union,lag(2 3)) iv(occ south smsa ind) nolevel twostep robust //nolevel不估计水平GMM，估计的是差分GMM
	//iv(occ south smsa ind)表示使用自身的IV式工具变量，假设他们是外生工具变量。
	xtabond2 lwage L(1/2).lwage L(0/1).wks ms union occ south smsa ind,gmm(lwage,lag(2 4)) gmm(wks ms union,lag(2 3)) iv(occ south smsa ind) level twostep robust //level估计水平GMM
	xtabond2 lwage L(1/2).lwage L(0/1).wks ms union occ south smsa ind,gmm(lwage,lag(2 4)) gmm(wks ms union,lag(2 3)) iv(occ south smsa ind) twostep robust //默认是系统GMM

*16.13偏差校正LSDV法
*差分GMM和系统GMM主要适用于短动态面板，IV和GMM估计是一致估计量；
*n较小 T较大的长面板则可能存在较严重偏差，可以使用“偏差校正LSDV法”（LSDVC），对于长面板，LSDVC法明显优于差分GMM和系统GMM。
*通过非官方命令xtlsdvc来实现（Bruno，2005）
	xtlsdvc y x1 x2 x3,initial(estimator) bias(#) vcov(#)
	//initial(estimator)，initial(ab)表示Arellano-Bond差分GMM作为起始值，initial(ah)表示使用Anderson-Hasio估计量作为起始值，i(bb)表示使用Blundell-Bond系统GMM估计作为起始值。
	//bias(#)指定偏差校正的精确度，1 2 3等更高阶的近似;
	//vcov(#)指定方差协方差矩阵自助法重复抽样的次数，一般设为vcov(50).
	use mus08cigar.dta,clear
	gen t =year-62
	ssc install xtlsdvc
	set matsize 11000 //当前400不够用，设为更大值，stata MP版本最大11000. 
	xtlsdvc lnc lnp lnpmin lny t,initial(ab) vcov(50) bias(3) //可能费时较长。
