***聚类分析***
 *分为Partition cluster-analysis和Hierarchical cluster-analysis
 
 *距离的计算方法：
  *连续变量之间的距离
 	1.Minkowski距离（q=1绝对值距离、q=2欧式距离、q=无穷大切比雪夫距离）一般先对各变量标准化处理;
 	2.Lance & Williams兰氏距离,对大的数据不敏感,适用于高度偏斜数据;
 	3.Mahalanobis马氏距离,考虑到了变量之间的相关性,并且与变量的单位无关,S变化,马氏距离不是理想的距离;
  	4.斜交空间距离，当变量之间不相关时，退化为欧氏距离.
  *名义变量或有序变量之间的距离
 	1.matching;
 	2.Jaccard;
 	3.Russell;
 	4.Hamann;
 	...
  *相似系数,相似系数越大,变量之间的相似程度就越高,距离(相异度)=1-相似系数(相似度);
 
 *系统聚类的方法:linkage
 	1.singlelinkage 最短距离法;
 	2.averagelinkage 类平均法;
 	3.completelinkage 最长距离法;
 	4.waveragelinkage 加权类平均法;
 	5.medianlinkage 中间距离法;
 	6.centroidlinkage 重心法;
 	7.wardslinkage Wald最小离差平方和法,优于重心法,但是对异常值敏感;

**分区聚类 Partition cluster-analysis,或称为动态聚类,适用于大数据集的情况,n越大,优越性越突出.
 *步骤:
 	1.样本分为k个初始类,将k个类的均值或中位数作为初始凝聚点;
 	2.对凝聚点之外的所有样本逐个归类,每个样本归入离他最近的那个凝聚点的类(一般使用欧式距离),凝聚点更新为新的均值或中位数;
 	3.重复2知道所有样本不能再分配为止.
	cluster kmeans 	 //均值最近
	cluster kmedians //中位数最近
*cluster kmeans案例
	use http://www.stata-press.com/data/r15/physed,clear
	save physed.dta,replace
	use physed.dta,clear
	summarize flex speed strength
	graph matrix flex speed strength //矩阵图
	cluster k flex speed strength, k(4) name(g4abs) s(kr(385617)) mea(abs) keepcen
	//聚成4类,命名为g4abs,初始随机抽取4个,abs聚类方法,保留4类均值为4个新个体(81-84)
	cluster list g4abs //显示聚类对象g4abs的情况
	table g4abs //看一下聚类的频率表
	list flex speed strength in 81/L,abbrev(12) //查看生成的四类均值保存的新个体
	drop in 81/L //删除生成的4个个体
	tabstat flex speed strength,by(g4abs) stat(min mean max) //看4类个体的大致情况
	graph matrix flex speed strength, m(i) mlabel(g4abs) mlabpos(0) //矩阵图看4类个体的聚类情况

*cluster kmeans和kmedians聚类的案例：
	use wclub.dta,clear
	cluster kmeans bike-fish, k(5) measure(Jaccard) st(firstk) name(gr5)
	cluster kmed bike-fish, k(5) measure(Jaccard) st(firstk) name(kmedian5)
	//聚成5类，Jaccard聚类方法，第一批k个个体做初始类
	table gr5 kmedian5, row col //如果平均分成几桌，坐一起交流，means方法比较合适，比较平均

**系统聚类 Hierarchical cluster-analysis
 *agglomerative：组内个体有少到多
 *divisive：组内个体由多到少
 *cluster subcommand，对个体聚类
 *clustermat subcommand，根据相似或相异矩阵聚类、对变量聚类

**聚类后命令
	cluster stop 		//根据准则终止聚类
	cluster dendrogram  //聚类树
	cluster generate 	//生成分类变量
**聚类管理工具
	cluster notes 		//给聚类分析添加标记
	cluster dir 		//或者cluster list，列出聚类对象
	cluster drop 		//移除一个聚类对象
	cluster use 		//使用一个聚类对象
	cluster rename 		//重命名聚类对象
	cluster renamevar	//重命名聚类对象的变量
**clustermat命令聚类案例：
*首先生成相异矩阵数据，然后聚类
	use http://www.stata-press.com/data/r15/iris,clear
	save iris.dta,replace
	use iris.dta,replace
	sum
	matrix dissimilarity irisD = seplen sepwid petlen petwid,l1 //生成相异矩阵，l1表示绝对值
	mat list irisD
	egen rtot =rowtotal(seplen sepwid petlen petwid) //每一行求和
	forvalues a = 1/150 {
		forvalues b = 1/150 {
			mat irisD[`a',`b'] = irisD[`a',`b']/(rtot[`a']+rtot[`b']) //矩阵的第ij各元素除以（第i个obs的行求和+第j个obs的行求和）
		}
	}
	matlist irisD[1..5,1..5] //列出矩阵的5X5，
*下面用相异矩阵进行聚类
	clustermat averagelink irisD,name(iris) add //add追加在后边，clear删除原变量
	clustermat stop,variables(seplen sepwid petlen petwid) 
	//用四个变量计算的the Cali´nski–Harabasz pseudo-F index终止准则
+---------------------------+
|             |  Calinski/  |
|  Number of  |  Harabasz   |
|  clusters   |  pseudo-F   |
|-------------+-------------|
|      2      |   502.82    | //大
|      3      |   299.96    | //大
|      4      |   201.58    |
|      5      |   332.89    | //大，此终止准则取较大值，推测2、3、5类较合适
|      6      |   288.61    |
|      7      |   244.61    |
|      8      |   252.39    |
|      9      |   223.28    |
|     10      |   268.47    |
|     11      |   241.51    |
|     12      |   232.61    |
|     13      |   233.46    |
|     14      |   255.84    |
|     15      |   273.96    |
+---------------------------+
	clustermat stop,variables(seplen sepwid petlen petwid) rule(duda) 
	//用四个变量计算的the Duda–Hart Je(2)/Je(1) index终止准则
+-----------------------------------------+
|             |         Duda/Hart         |
|  Number of  |             |  pseudo     |
|  clusters   | Je(2)/Je(1) |  T-squared  |
|-------------+-------------+-------------|
|      1      |   0.2274    |   502.82    |
|      2      |   0.8509    |    17.18    |
|      3      |   0.8951    |     5.63    | //小
|      4      |   0.4472    |   116.22    |
|      5      |   0.6248    |    28.23    |
|      6      |   0.9579    |     2.55    | //小
|      7      |   0.5438    |    28.52    |
|      8      |   0.8843    |     5.10    | //小，此准则取较小值，可以推测分成3、6、8类，比较合适
|      9      |   0.5854    |    40.37    |
|     10      |   0.0000    |        .    |
|     11      |   0.8434    |     6.68    |
|     12      |   0.4981    |    37.28    |
|     13      |   0.5526    |    25.91    |
|     14      |   0.6342    |    16.15    |
|     15      |   0.6503    |     3.23    |
+-----------------------------------------+
	cluster generate g = groups(2/6) //生成聚类变量，g2、g3...分别显示分成2、3...类的结果
	tabulate g2 iris //根据变量g2和iris生成二维频率统计表

           |           Iris species
        g2 |    setosa  versicolo  virginica |     Total
-----------+---------------------------------+----------
         1 |        50          0          0 |        50 
         2 |         0         50         50 |       100 
-----------+---------------------------------+----------
     Total |        50         50         50 |       150 
	tabulate g3 iris //根据变量g3和iris生成二维频率统计表

           |           Iris species
        g3 |    setosa  versicolo  virginica |     Total
-----------+---------------------------------+----------
         1 |        50          0          0 |        50 
         2 |         0         46         50 |        96 
         3 |         0          4          0 |         4 
-----------+---------------------------------+----------
     Total |        50         50         50 |       150 
**对变量聚类的两种办法：
*xpose转置后再聚类；
*matrix dissimilarity生成相异矩阵然后结合clustermat命令的方法.
*第二种方法：变量聚类的案例:35个变量进行聚类，相同类型的变量放在一起
	use http://www.stata-press.com/data/r15/wclub, clear
	save wclub.dta,replace
	use wclub.dta,replace
	describe //30个妇女回答的35个问题组成的变量
	matrix dissimilarity clubD = , variables Jaccard dissim(oneminus)
	//variables表示对变量聚类，Jaccard一种分类变量距离的计算方法，oneminus表示相异度（1-相似度）
	matrix dir 	//显示当前内存中的矩阵
	matlist clubD[1..5,1..5] //显示clubD矩阵的5x5内容，可以看到已经是变量之间的相异矩阵了
	clustermat singlelink clubD, name(club) clear labelvar(question)
	//用clubD矩阵聚类，聚类对象命名为club，clear清楚聚类的变量，labelvar将变量标签命名为question
	describe
	cluster dendrogram club, labels(question) /// //上面club对象的聚类树，question变量标签
	xlabel(, angle(90) labsize(*.75)) ///x轴标签垂直90度显示，
	title(Single-linkage clustering) ///
	ytitle(1 - Jaccard similarity, suffix)

*一般聚类的案例
	use http://www.stata-press.com/data/r15/labtech,clear
	save labtech.dta,replace
	use labtech.dta,clear
	cluster completelinkage x1 x2 x3 x4, name(L2clnk)
	cluster dendrogram L2clnk, labels(labtech) xlabel(, angle(90) labsize(*.75)) //labels(labtech)以labtech为标签显示聚类情况
	cluster tree L2clnk, labels(labtech) xlabel(, angle(45) labsize(*.5)) //45度显示，字体减小0.5
	cluster dendrogram L2clnk, quick labels(labtech) xlabel(, angle(90) labsize(*.75))
	//quick选项创建的聚类树形状不同
	cluster generate g3 = group(3) //groups和group是一样的
	tabulate g3 labtech
	cluster tree if g3 == 3 //只显示第三类中的个体聚类情况
	cluster tree, cutnumber(3) showcount //只显示第三阶聚类情况，以及每一类下面的个体数
	
	cluster tree, cutvalue(75.3) //cutvalue指定以75.3值为界，修剪聚类树
	countprefix("(") countsuffix(" obs)") countinline //以(n obs)的格式和标签名称显示在countinline同一行
	ylabel(, angle(0)) horizontal //horizontal水平显示
*生成不同聚类数的变量的方法：
	cluster generate g = groups(4/7),name(L2clnk) //使用L2clnk聚类对象的结果，生成分为4、5、6、7类的变量
	cluster generate g2 = group(2), name(L2clnk)
	cluster generate g2cut = cut(200)
	codebook g2

*group()报错的情形,使用ties选项:
	use http://www.stata-press.com/data/r15/homework, clear
	save homework.dta,replace
	use homework.dta,clear
	cluster singlelinkage a1-a60, measure(matching)
	cluster tree
	cluster generate g4 = group(4) //报错，不能生成4类，可以使用下面三种方法；
	cluster generate more4 = group(4),ties(more) //使用ties(more)生成大于4类的情形；
	cluster generate less4 = gr(4),ties(fewer)   //使用ties(fewer)生成少于4类的情形；
	cluster generate group = gr(4/20),ties(skip) //skip选项生成4至20类中可以生成的情形；
	summarize more4 less4 	//可以看到，小于4生成了3类，大于4生成了5类；
	summarize group*		//4至20类中只能生成5、9、13和18类；

***聚类案例***
*一般的聚类案例操作:
	cd e:\data\mv
	use labtech.dta,clear
	br
	cluster singlelinkage x1-x4,name(sngeuc) //最短距离系统聚类法,默认欧氏距离;
	cluster list sngeuc //查看上面聚类对象sngeuc的情况
	cluster dendrogram sngeuc,xlabel(,angle(90) labsize(*.75)) //聚类树发现中间一类异常,矩阵图看异常
	graph matrix x1-x4 //矩阵图未发现异常,改用labtech变量做图例标签:
	cluster dendrogram sngeuc ,labels(labtech) xlabel(,angle(90) labsize(*.75)) //发现异常类是名叫sam的obs
*30个obs,60个0,1类型的variables的案例:使用不同的系统聚类方法
	use homework.dta,clear	
	cluster s a1-a60,measure(matching) gen(zstub) //singlelinkage方法,matching距离,强制生成的聚类变量名称为zstub
	cluster tree //可以看到分成三类较好
	cluster generate grp3 = group(3) //生成分为三类的变量grp3
	table grp3 truegrp //对比聚成的三类和原本三类的情况
	cluster medianlinkage a1-a60,measure(match) name(medlink) //更换medianlinkage方法聚类
	cluster list medlink
	cluster tree //medianlinkage方法无法生成聚类树,生成聚类变量的方法
	cluster generate medgrp3 = group(3)
	table medgrp3 truegrp //对比聚成的三类和原本三类的情况
	cluster wardslinkage a1-a60,measure(match) name(wardlink) //medianlinkage方法无法使用聚类树命令,换wardsinkage方法
	cluster list wardlink
	cluster tree wardlink //显示聚类树
	cluster generate wardgrp3 = group(3)
	table wardgrp3 truegrp
*对变量聚类的案例:30个obs,35个vars
	use wclub.dta,clear
	matrix dissimilarity clubD = ,variables Jaccard dissim(oneminus)
	matrix list clubD //variables表示用变量生成相异矩阵,对变量聚类;
	matrix dissimilarity club = , Jaccard dissim(oneminus)
	matrix list club  //没有variables选项,表示用obs生成相异矩阵,对obs聚类;
	matrix dir 		  //clubD为35x35的,35个变量间的差异矩阵,club为30x30,30个obs之间的差异矩阵;
	*先对变量聚类,使用变量相异矩阵clubD
	clustermat waverage clubD,name(clubDwav) clear labelvar(quest) //生成quest变量存储变量名称标签;
	*或者:
	clear 			  //数据表格原本是30行的,按变量聚类是35行的,所以要先clear;
	clustermat waverage clubD,name(clubDwav) add labelvar(quest) //上面没有clear的话,add会出错;
	cluster dendrogram clubDwav,labels(quest) /// 	//对35个变量聚类的聚类树,横轴以quest变量名标签显示
	xlabel(,angle(90) labsize(*.75)) title(weighted-average linkage clustering) ///
	ytitle(1-Jaccard dissimilarity,suffix)
	*再对obs聚类:
	clustermat waverage club,name(clubwav) add labelvar(obs) 		 //此处对obs聚类,30行个数是对的,add不会出错;
	cluster dendrogram clubwav,labels(obs) /// //对30个obs聚类的聚类树,
	xlabel(,angle(90) labsize(*.75)) title(weighted-average linkage clustering) ///
	ytitle(1-Jaccard dissimilarity,suffix)
	
***cluster notes的操作***
	cluster dir									 //显示当前内存中聚类对象的列表
	cluster note clubDwav : 按35个变量聚类的结果  //对clubDwav聚类对象注释
	cluster notes 								//显示cluster对象及注释的内容
	cluster notes club* 						//可以使用* ?等通配符

***cluster编程***
 *编写子程序命令	
  *命令使用格式:cluster mycrosstab clname1 clname2 [,tabulate_options]
	
	program cluster_mycrosstab
		version 15.1
		gettoken clname1 0 : 0 , parse(" ,")
		gettoken clname2 rest : 0 , parse(" ,")
		cluster query `clname1'
		local groupvar1 `r(groupvar)'
		cluster query `clname2'
		local groupvar2 `r(groupvar)'
		tabulate `groupvar1' `groupvar2' `rest'
	end
 *运行程序
	use e:\data\auto.dta,clear
	cluster kmeans gear head tr, L1 k(5) name(cl1) start(krandom(55234)) gen(cl1gvar)
	cluster kmeans tr tu mpg, L(1.5) k(5) name(cl2) start(krandom(22132)) gen(gvar2)
	cluster list, type method dissim var
	cluster mycrosstab cl1 cl2, chi2 //调用上面的cluster mycrosstab命令,结果如下:
***cluster对象的操作***
	cluster dir 	 	  //列出当前内存中的cluster对象;
	cluster list cl1 	  //显示cl1对象的详细信息;
	cluster list 		  //显示内存中所有对象的详细信息;
	cluster list c*, vars //显示所有以c开头对象的vars
	cluster rename oldcluster newcluster
	cluster drop clustername
	cluster renamevar oldvar newvar,name(clustername) //对cluster对象内的变量重命名;
	cluster use clustername 
