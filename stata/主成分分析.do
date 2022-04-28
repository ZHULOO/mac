***主成分分析***
*主成分对变量度量敏感,使用协方差矩阵和相关矩阵是不一样的,各变量单位统一时,使用协方差矩阵才有意义.
*案例1:
	cd e:\data\mv
	use http://www.stata-press.com/data/r15/audiometric,clear
	save audiometric.dta,replace
	use audiometric.dta,clear
	correlate lft* rght* //计算个变量的相关系数矩阵;
	summarize lft* rght*,sep(4) //描述统计,每4各变量显示一组;
	pca lft* rght*
	pca lft* rght*,components(4) //只显示4个主成分;
	pca l* r*,components(2) vce(normal)
	estat vce
*协方差矩阵代替相关矩阵
	pca l* r*,comp(4) covariance //结果对变量的度量很敏感
*使用相关矩阵和协方差矩阵进行主成分分析
	correlate lft*,cov //计算左耳四个变量的协方差矩阵
	matrix cfull = r(C)
	matrix list cfull
	pcamat cfull,comp(2) n(100) names(lft500 lft1000 lft2000 lft4000)

*主成分后续命令:
	use audiometric.dta,clear
	pca l* r*,comp(4)
	estat loadings 				//主成分载荷矩阵,各列平方和等于1
	estat loadings,cnorm(eigen) //各列平方和等于相应特征值
	estat residual,fit format(%7.3f) //显示observed和fitted的相关矩阵
	estat smc //某变量和其它变量的复相关系数,越大越适合进行主成分分析,太小说明该变量和其它变量相关性很小,可以剔除出模型;
	estat anti,nocov format(%7.3f) //anti-image correlation,它越大,该变量和其它变量相关性越小,越不适合进行主成分分析;
	estat kmo //kmo检验,越大越适合进行主成分分析;
	screeplot,mean 		//碎石图;
	screeplot,mean ci 	//带置信区间的碎石图;
	loadingplot 		//画出两个主成分的载荷图,软件自行判断2个主成分是合适的;
	loadingplot,comp(3) combined //三个主成分的载荷图;
	rotate 	//旋转该变量主成分对应的特征值,第一主成分不再对应最大方差;默认是列方差平方和最大化的正交旋转;
	rotate,oblimin oblique //斜交旋转,旋转后的主成分不再正交,最新旋转结果保持激活状态;
	pca,norotated //再次使用未旋转的主成分结果,需要加norotated选项;
	loadingplot,norotated //再次使用未旋转的主成分,画出载荷图;
	estat rotatecompare //对比是否旋转的主成分载荷矩阵
	rotate,clear  //清除保存的旋转结果;

*主成分得分:
	predict pc1 //计算第一主成分,保存为pc1变量;
	predict f_1-f_8,fit	//用前四个主成分拟合的八个变量的值.


