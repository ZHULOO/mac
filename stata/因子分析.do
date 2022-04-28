
***因子分析***
 1.当p个原始变量的单位不同,或者单位相同而数值相差很大时,需要对原始数据进行标准化;
 2.标准化以后的变量协方差矩阵就是相关系数矩阵.
 *pcf主成分法:默认的方法,共同度假设为1;
 *pf主因子法:用xi和其它x的复相关系数的平方(smc),来计算共同度;
 *ipf迭代主因子法:迭代使用主因子法,直到解稳定为止;
 *ml极大似然法:和上面三个方法不同,当因字数增加时,原来因子的估计载荷及对x的贡献将发生变化.

***案例***
	cd e:\data\mv
	use http://www.stata-press.com/data/r15/bg2,clear
	save bg2.dta,replace
 *原始数据因子分析
	use bg2.dta,clear
	browse
	factor bg2cost1-bg2cost6 //默认主因子法pf,用复相关系数的平方估计共同度,根据默认的mineigen(0),给出三个公因子的结果;
	factor, altdivisor 		 //不是用特征值的和做分母,使用相关系数矩阵的迹作为累计方差贡献的分母;
	factor bg2cost1-bg2cost6,pcf //主成分法pcf, 共同度假设为1;
	factor bg2cost1-bg2cost6,ipf //迭代主因子法ipf,迭代使用pf,直到得出稳定解;会给出全部因子;
	factor bg2cost1-bg2cost6,ipf factors(2) blanks(.30)
		//给出两个公因子的结果,小于0.30的显示为空;
	factor bg2cost1-bg2cost6,ml factors(2) //极大似然法ml,给出2个公因子的结果;
	factor bg2cost1-bg2cost6,ml factors(2) protect(50) //增加迭代次数,保证极大似然是全局最优解;

 *相关矩阵因子分析 	
 	matrix C = (1.000, 0.943, 0.771 \ /// //手工输入矩阵C
				0.943, 1.000, 0.605 \ ///
				0.771, 0.605, 1.000)
 	matrix list C
 	factormat C, n(979) names(visual hearing taste) fac(1) ipf //矩阵C行列名称不一致时,告诉stata使用names识别;
 	matrix Cup = (1.000, 0.943, 0.771, 1.000, 0.605, 1.000) //一行的矩阵,可以通过shape(upper)说明上三角矩阵
 	matrix Clow = (1.000, 0.943, 1.000, 0.771, 0.605, 1.000) //shape(lower)下三角;
 	factormat Cup, n(979) shape(upper) fac(2) names(visual hearing taste)
 	factormat Clow, n(979) shape(lower) fac(2) names(visual hearing taste) //和上面的结果是一样的;

***factors后命令***
 *计算因子得分的两种方法
  1.默认是回归法,有偏,均方误差最小
  2.加权最小二乘法,Bartlett法,无偏,均方误差大

 *smc:squared multiple correlations 复相关系数的平方=共同度=1-特殊方差
 	factor bg2cost1-bg2cost6,factors(2) ml //ml方法,提取两个公因子
 	estat smc 							   //估计复相关系数的平方

 *模型选择准则:选择几个公因子
  1.screenplot碎石图
  2.estat factors //信息准则AIC BIC
	estat factors

 *结构矩阵和可观测的相关系数矩阵
 	estat structure //生成变量和公因子对应的表格,正交旋转和未旋转的结果是相同的,公因子之间是正交的
 	estat common 	//可以看到,正交旋转和未旋转的情况下,公因子之间相关系数为0,但是斜交旋转后公因子之间不是正交的
 	estat residuals,obs fit //生成原相关矩阵,拟合相关矩阵,二者之差
 	estat residuals,sres 	//标准化的残差矩阵

 *碎石图 the screen plot
 	cd e:\data\mv
 	use http://www.stata-press.com/data/r15/sp2,clear
 	save sp2.dta,replace
 	use sp2.dta,clear
 	factor ghp31-ghp05,pcf //pcf法默认选取特征值大于1的公因子,即mineigen(1);
 	screeplot,mean //以特征值的平均值画了一条参考线.

 *因子载荷图 factor loading plot
 	loadingplot, xline(0) yline(0) aspect(1) note(unrotated principal factors) //aspect(1)画图区域分配
 	loadingplot, factors(3) combined xline(0) yline(0) aspect(1) ///
	xlabel(-0.8(0.4)0.8) ylabel(-0.8(0.4)0.8)

 *因子得分变量图 score variables plot
 	scoreplot, msymbol(smcircle) msize(tiny) //smcircle小圆点,tiny图例显示小;

 *这些图都是未旋转的因子分析结果,旋转以后,将会显示最近旋转过以后的因子分析结果图
 *name(names)显示在不同窗口,同时打开两个图像窗口:
 	loadingplot,norotated name(name1) //显示未旋转的因子碎石图
 	loadingplot,name(name2) 			 //没有norotated选项,显示旋转过的因子碎石图

 *先保存图像结果,再显示在同一个窗口:
 	loadingplot,norotated saving(name1)
 	loadingplot,saving(name2)
 	graph combine name1.gph name2.gph

 *因子载荷旋转
 	*正交旋转 orthogonal varimax rotation
 	use bg2.dta,clear
 	factor bg2cost1-bg2cost6,pcf factors(2)
 	rotate
 	use sp2.dta,clear
 	factor ghp31-ghp05,factors(3)
 	rotate,varimax
 	*斜交旋转 oblique oblimin rotation
 	factor ghp31-ghp05,factors(2)
 	estat common 		 //发现旋转后的公因子相关系数不为零,是相关的
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

 *计算因子得分
 	factor headroom rear_seat trunk
 	predict f1 //得到f1公因子,公因子均值不为0,接近于0,方差不为1,接近于1
 		//均值不等于0,方差不等于1的原因是:数据近似和模型误差

***手工生成数据,进行因子分析
	clear
	set seed 12345
	set obs 10000
	generate ftrue = rnormal() //生成一个正态分布的公因子ftrue
	generate x1 = 0.4*ftrue+sqrt(0.84)*rnormal() //根据公因子及载荷0.4生成x1变量
	generate x2 = 0.6*ftrue+sqrt(0.64)*rnormal()
	generate x3 = 0.8*ftrue+sqrt(0.36)*rnormal()
	summarize x1 x2 x3
	factor x1 x2 x3,ipf factors(1)
	predict freg //默认回归法计算因子得分
	predict fbar,bartlett //加权最小二乘法计算因子得分;
	reg freg ftrue //回归比较回归法因子得分和真实因子的关系,发现回归系数0.717<1,回归法是有偏的,但是均方误差较小;
	reg fbar ftrue //回归系数为1,bartlett法是无偏的,计算的因子得分期望等于真实值因子得分;无偏但是以准确为代价,均方误差较大;
	generate dbar = (fbar-ftrue)^2
	generate dreg = (freg-ftrue)^2 //计算两种因子得分方法计算的因子得分相对于真实值的均方误差,比较大小;
	summarize ftrue fbar freg dbar dreg
	correlate freg fbar ftrue
		//选择哪种方法计算因子得分不是很重要.

***因子分析结果输出到word***
	clear all
	sysuse auto,clear
	factor price mpg weight length turn displacement gear_ratio,factors(3)
	*因子分析结果的保存：
	matrix list e(sds) 	 //各变量的方差 1xn
    matrix list e(means) //各变量的均值 1xn
    matrix list e(C) 	 //保存着各变量的相关系数矩阵
    matrix list e(Phi)   //保存着公因子相关矩阵
    matrix list e(L) 	 //保存着因子载荷矩阵
    matrix list e(Psi) 	 //保存着特殊方差
    matrix list e(Ev) 	 //每个公因子对应的特征值

	putdocx clear 
	putdocx begin
	//将e(L)中保存的因子载荷矩阵赋值给创建的表格a，，显示列名，行名，7位宽，4位小数，所有边框，nil不显示竖向边框，显示最上和最下的边界线；
	putdocx table a = matrix(e(L)), colnames rownames nformat(%7.4f) border(all, nil) border(top) border(bottom)
	//对表格a进行属性设置：
	putdocx table a(2,.), border(top) 				//第二行有上边界线；
	putdocx table a(.,2/4), halign(right) 			//第2到4列数据靠右对齐；
	putdocx table a(3,2/4), border(bottom) 			//第3行，2到4列显示下边界线；
	putdocx table a(1,2), colspan(1) halign(center) //第1行第2个单元格，列宽1，居中对齐；
	putdocx save mytable.docx, replace
	di as txt `"(output written to {browse mytable.docx})"' //生成保存的mytable.docx超链接，点击可以打开该文件；
	shellout mytable.docx  //或者命令打开保存的mytable文档

	*简单的标准三线式表格
	clear all
	sysuse auto
	factor price mpg weight length turn displacement gear_ratio,factors(3)
	putdocx clear 
	putdocx begin
	putdocx table a = matrix(e(L)), colnames rownames nformat(%7.4f) border(all, nil) border(top) border(bottom)
	putdocx table a(2,.), border(top)
	putdocx table a(.,2/4), halign(right)
	putdocx save factortable.docx, replace
	di as txt `"(output written to {browse factortable.docx})"' //生成保存的mytable.docx超链接，点击可以打开该文件；
	shellout factortable.docx
