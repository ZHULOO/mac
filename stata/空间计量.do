*       ==========================
*          第29章  空间计量经济学
*       ==========================

*29.1地理学第一定律：所有事物都与其它事物相关联，但是较近的事物比较远的事物更关联。

*29.2空间权重矩阵：地理距离、社交距离、经济距离

*29.3空间自相关
*莫兰指数I：
*1、介于（-1，1）之间，大于0表示正自相关，高值与高值相邻，低值与低值相邻，小于0表示负自相关，高值与低值相邻；
*2、莫兰散点图，Moran csatterplot 莫兰指数就是指该散点图的斜率。
*3、标准化的莫兰指数服从渐近标准正态分布
*4、全局莫兰指数(Global Moran's I)：考察的是整个空间的序列空间集聚情况。局部莫兰指数(Local Moran's I)：考察的是局部区域i附近的空间集聚情况。

*吉尔里指数C
*5、(Geary's C)(Geary,1954),也称为吉尔里相邻比率Geary's Contiguity Ratiao:
*6、介于（0，2）之间，大于1表示负相关，等于1不相关，小于1正相关；与莫兰指数成反向变动，比莫兰指数局部空间自相关更敏感，但是二者均无法区别热点和冷点；
*7、标准化的吉尔里指数服从渐近标准正态分布。

*Getis-Ord指数G
*8、Getis and ord（1992），样本中高值聚集在一起，G较大；样本中低值聚集在一起，G较小；
*9、G>E(G)存在热点区域；反之存在冷点区域，标准化的G也服从标准正太分布；
*10、G>1.96拒绝无空间自相关的原假设，认为存在空间正自相关，且存在热点区域，G<-1.96拒绝无空间自相关的原假设，认为存在空间正自相关，且存在冷点区域，
*11、局部Getis-Ord指数G，可以考察局部区域i是否为热点或冷点

*安装空间自相关命令
	net install sg162.pkg //下载以spat开头的一系列命令
	//spatwmat 定义空间权重矩阵
	//spatgsa 全局空间自相关检验
	//spatlsa 局部空间自相关检验
	//spatcorr 考察空间自相关指标对距离临界值d的依赖性，小于d取1，大于d取0
	//spatdiag 针对OLS回归结果，诊断是否存在空间效应
	//spatreg 估计空间滞后和空间误差模型

*空间案例
	cd e:\data
	use columbusswm.dta,clear //空间权重矩阵
	br

	use columbusdata.dta,clear //犯罪数据
	br

	spatwmat using columbusswm.dta,name(W) //生成空间权重矩阵W
	matrix list W
	use columbusdata.dta,clear
	spatgsa crime,weights(W) moran geary go twotail //计算三个指数，并进行双边检验，结果均拒绝无空间自相关的原假设，认为存在空间自相关,twotail表示双尾检验；
	spatlsa crime,w(W) moran twotail 			 	//计算局部莫兰指数，很多p值很小的区域，拒绝无空间自相关的原假设，认为存在空间自相关；
//结果：
Measures of global spatial autocorrelation


Weights matrix
--------------------------------------------------------------
Name: W
Type: Imported (binary)
Row-standardized: No
--------------------------------------------------------------

Moran's I
--------------------------------------------------------------
          Variables |    I      E(I)   sd(I)     z    p-value*
--------------------+-----------------------------------------
              crime |  0.521  -0.021   0.087   6.212   0.000
--------------------------------------------------------------

Geary's c
--------------------------------------------------------------
          Variables |    c      E(c)   sd(c)     z    p-value*
--------------------+-----------------------------------------
              crime |  0.584   1.000   0.109  -3.835   0.000
--------------------------------------------------------------

Getis & Ord's G
--------------------------------------------------------------
          Variables |    G      E(G)   sd(G)     z    p-value*
--------------------+-----------------------------------------
              crime |  0.126   0.099   0.006   4.714   0.000 //三个空间全局自相关指标均强烈拒绝“无空间自相关”的原假设，认为存在空间自相关；
--------------------------------------------------------------
*2-tail test


*29.4空间自回归模型
*1、Pure SAR y = λWy+ε ，纯空间自回归模型。
*2、一般线性回归模型：y = λWy+Xβ+ε，原假设λ=0，来检验是否存在空间效应。
*3、空间计量模型的真谛：一个区域的解释变量会对任意区域的被解释变量可能产生影响。
*	直接效应：区域的变量对本区域被解释变量的效应；
*	平均直接效应：主对角线上元素进行平均
*	平均总效应：所有元素平均
*	平均间接效应=平均总效应-平均直接效应

*29.5空间杜宾模型(SDM Spatial Durbin Model)
*y = Xβ +WXδ + ε，WXδ表示来自邻居的自变量的影响，δ为系数向量，犯罪率不仅依赖于本区域的警力，还依赖于相邻区域的警力。
*可以与空间自回归模型合并为y = λWy + Xβ + WXδ + ε

*29.6空间误差模型(SEM Spatial Errors Models)
*y = Xβ + u，u= ρMu +ε，误差项存在空间自相关
*空间误差模型的stata操作：
	reg crime hoval income //利用spatdiag诊断是否存在空间效应，需要先进行OLS回归。
	spatdiag,weights(W) //一部分P值<0.05，拒绝无空间自相关的原假设。
	spatwmat using columbusswm.dta,name(W) eigenval(E) //需要首先计算权重矩阵W的特征值E。
	matrix list E
	spatreg crime hoval income,weights(W) eigenval(E) model(lag) nolog //model(lag)表示估计空间自回归SAR模型，还可以使用robust稳健标准误选项。
	//自回归系数rho的估计值为0.055，p值很小，拒绝原假设认为存在空间自回归效应，下面估计空间误差模型SEM：
	spatreg crime hoval income,weights(W) eigenval(E) model(error) nolog //估计SEM模型
	//误差项的空间自回归系数记为λ=0.036，并且显著不为0，SEM对自变量回归系数的估计结果与OLS很接近，表示SEM模型正确，OLS模型也是一致的估计量，只不过MLE估计量更有效。

*29.7一般空间计量模型
*1、更一般的空间计量模型将SAR和SEM结合起来，y = λWy+Xβ+u ；u= ρMu +ε，SAR对应于ρ=0的情形。SEM对应于λ=0的情形。
*2、W为被解释变量y的空间权重矩阵，M为扰动项u的空间权重矩阵，二者可以相等；
*3、带空间自回归误差项的空间自回归模型，Spatial Autoregressive Model with Spatial Autoregressive Disturbance：SARAR
*4、SAR SEM以及SARAR统称为Cliff-Ord模型，（Cliff and Ord，1973，1981；Ord，1975）
*5、扰动项不服从独立的正态分布，则QMLE估计量不是一致的。Kelejian and Prucha（1999，1998，2004，2010）提出使用工具变量；
*6、通过GMM来估计SARAR模型，广义空间二阶段最小二乘（GS2SLS)，Arraiz（2010）证明此IV估计量在异方差情况下也是一致的，更为稳健；
*7、GS2SLS方法，需要有外生的解释变量，所以不适用于没有外生变量的纯SAR模型,使用{X,WX,MX...}作为工具变量。
*8、SARAR模型可通过非官方的命令spreg来实现：
	which spreg //发现已安装
	spmat //定义和管理空间权重矩阵
	spreg //估计SARAR模型
	spivreg //估计含内生解释变量的SARAR模型
	cd e:\data
	use columbusswm.dta,clear
	spmat dta w1 a1-a49 //用dta格式的数据集来生成空间权重矩阵w1
	use columbusdata,clear
	spreg ml crime hoval income,id(id) dlmat(w1) elmat(w1) nolog //ml表示mle估计，id表示确定横截面变量
	//dlmat(w1)表示空间自回归方程的权重矩阵W， elmat(w1)空间误差方程Nederland空间权重矩阵M。
	//空间自回归系数λ显著，空间误差系数ρ不显著。以下用GS2SLS进行估计：
	spreg gs2sls crime hoval income,id(id) dlmat(w1) elmat(w1) het nolog //het表示使用异方差稳健标准误，默认为同方差。
	//由于空间误差系数ρ很不显著，下面估计不含空间误差的SAR模型：
	spreg gs2sls crime hoval income,id(id) dlmat(w1) het nolog	//只有自回归权重矩阵

*29.8含内生解释变量的SARAR模型
*1、y = λWy+Xβ+Zδ+u ；u= ρMu +ε，Z为内生解释变量，假设income是内生解释变量，hoval是工具变量，使用spivreg命令：
	spivreg crime  (income=hoval),id(id) dlmat(w1) elmat(w1) het nolog 

*29.9空间面板模型

	net install spcs2xt.pkg //截面权重矩阵转空间权重矩阵
	help spcs2xt //得到很多空间面板命令
	
*1、类似于面板数据模型：固定效应的空间自回归模型，差分变换去掉个体效应以后，再用类似于横截面的空间自回归模型进行MLE估计；
*2、随机效应的空间自回归模型，先做广义离差变换，然后再进行MLE估计，决定使用固定还是随机，还是Hausman检验；
*3、空间面板模型的MLE估计，使用一般式的xsmle命令：
*4、y =τy +ρwy+xβ+dxδ+ui+γt+ε；ε=λMε+v
*	τ=0，λ=0，空间杜宾模型SDM；
*	τ=0，λ=0且δ=0，空间自回归模型SAR；
*	τ=0，δ=0，空间自相关模型SAC，即上文的SARAR模型； 
*	τ=ρ=0，δ=0，空间误差模型SEM.
	xsmle y x1 x2 x3 ,wmat(name) emat(name) dmat(name) durbin(varlist) model(sdm) model(sac) model(sem) re fe robust dlag type(ind) type(time) type(both) noeffects
	//durbin(varlist)用于指定空间滞后的解释变量，默认所有解释变量；
	//model()指定SDM SEC SAC模型类型；
	//re fe 表示随机效应和固定效应，默认是随机效应；
	//dlag表示加入被解释变量一阶滞后作为解释变量，即动态面板，默认为静态面板(τ=0)；
	//type()指定个体效应、时间效应，both表示既有个体效应和时间效应；
	//noeffects表示不显示直接效应、间接效应与总效应。 默认是不显示效应。
*实例：
	use product.dta,clear
	gen lngsp = log(gsp)
	gen lnpcap = log(pcap)
	gen lnpc = log(pc)
	gen lnemp = log(emp)
	spmat use usaww using usaww.spmat
	matrix list usaww
	xsmle lngsp lnpcap lnpc lnemp unemp ,wmat(usaww) model(sdm) robust effects nolog //effects显示间接效应等。
	//空间自回归系数ρ显著不为0，但是变量lnpcap,lnpc和unemp的空间滞后项不显著，使用durbin()将它们三个不进行空间滞后。
	xsmle lngsp lnpcap lnpc lnemp unemp ,wmat(usaww) model(sdm) durbin(lnemp) robust noeffects nolog 
	//durbin(lnemp)只对解释变量lnemp进行空间滞后，下面进行fe估计：
	xsmle lngsp lnpcap lnpc lnemp unemp ,wmat(usaww) model(sdm) durbin(lnemp) robust noeffects nolog fe //默认的是re
	//究竟是使用fe还是re，进行hausman检验，需要存储未使用稳健标准误的结果：
	qui xsmle lngsp lnpcap lnpc lnemp unemp ,wmat(usaww) model(sdm) durbin(lnemp) noeffects nolog fe
	est sto fe
	qui xsmle lngsp lnpcap lnpc lnemp unemp ,wmat(usaww) model(sdm) durbin(lnemp) noeffects nolog
	est sto re
	hausman fe re //hausman检验为负数，表示接受原假设，使用随机效应模型
	//输出fe re结果，进行对比
	reg2docx fe re using e:\temp\spanel.docx,replace ///
    scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("IV results") ///
    mtitles("fe" "re") note("(* 0.1 ** 0.05 *** 0.01)")


