参见:https://mp.weixin.qq.com/s/G4Fu4K5N4p9HHlM9WzmkNg

          *       ==========================
          *          第十三讲  合成控制法
		  *       ==========================

********一、合成控制法简介******

    *Abadie, Diamond, and Hainmueller (2010)首次证明了合成控制法的基本性质，并将其
    *应用于研究美国加州1988年99法案的政策效果。1988年11月，美国加州政府通过了香烟
    *控制99法案，将加州香烟的消费税每包提升25美分，1989年1月，99法案正式实施。    
    *以此为背景，本文利用了合成控制法来估计美国加州实施的香烟控制99法案对加州香烟消费的影响。


********二、数据来源及介绍******

    *这篇文章采用的是1970-2000年的各个州的面板数据，选择这个时间段是因为1970年开始
    *香烟的销售数据才可以获得，并且到了2000年以后，禁烟举措在全国很多州都普遍实施，
    *使得控制组的个体不再具有比较价值。文章的控制组个体排除了在1970-2000年期间采取了
    *大型香烟控制项目的州，以及提升香烟消费税税率到达或者超过50美分的州，
    *最后共有38个州进入控制组。文章最终比较的结果变量为各州内每人每年的香烟消费量，
    *用平均每人每年香烟销售包数衡量。同时，用来预测香烟流行程度的变量（协变量）
    *包括香烟零售价、各州人均收入、15-24岁人群的比例，每人年均啤酒的消费量等。	

    *合成控制法有两个基本假设，首先，干预组和控制组之间不能存在交互影响，也就是说
    *干预组受到政策干预后的结果对控制组个体不产生影响，没有结果的外溢。
    *另外，构造合成控制组时基于的变量应该是不受政策影响或者干预前变量。
    *在本文中则表现为加州实施99法案后，其他38个州不受加州结果的影响。
    *文章认为可能存在的交互影响包括禁烟情绪会传播到其他州，一些香烟公司会
    *转移其他州用来促销香烟的广告费到加州，这都会降低控制组的香烟消费量，
    *最终影响政策评价效果。但是，作者认为这一交互现象并不明显，所以可以忽视。
    *同时作者认为99法案实施后带来的香烟走私活动和跨洲购买也不活跃。

********三、合成控制法应用案例讲解******
 
//合成控制法的Stata命令，Abadie et al. (2010)提供了合成控制法的Stata程序 synth，
//由于该命令是一个外部命令，因此需要下载。
    ssc install synth, replace   
    命令synth的基本句型为：
    synth  y  x1  x2  x3 ,trunit(#)  trperiod(#)  counit(numlist)  xperiod(numlist) //
    mspeperiod()  figure  resultsperiod()  nested  allopt  keep(filename) 
  
    //加州控烟法有效吗？面板数据集。Abadie et al. (2010)使用的数据为美国1970-2000年
    //的州际面板数据。最后剩下38个州作为潜在的控制地区。
    //变量介绍:
    *该研究的结果变量为 cigsale（人均香烟消费量，包/年）
    *预测变量包括 retprice（平均香烟零售价格）、lnincome（人均收入对数）、
    *age15to24（15-24岁人口所占总人口比重，年轻人为吸烟主力）、
    *beer（人均啤酒消费量，烟酒不分家）。
    *这些预测变量均为1980-1988年的州平均值，
    *另外还使用1975、1980与1988年的人均香烟消费量作为三个额外的预测变量。
    *另外，面板变量为 state（州），而时间变量为 year（年）。  
  
//stata操作   
    sysuse smoking
    xtset state year    
	synth cigsale retprice lnincome age15to24 beer cigsale(1975) cigsale(1980)  ///
    cigsale(1988), trunit(3) trperiod(1989) xperiod(1980(1)1988) figure nested keep(smoking_synth)
    *其中，“cigsale(1975) cigsale(1980) cigsale(1988)” 分别表示人均香烟消费在
    *1975、1980与1988年的取值。必选项 “trunit(3)” 表示第3个州（即加州）为处理地区；
    *必选项 “trperiod(1989)” 表示控烟法在1989年开始实施。
    *选择项 “xperiod(1980(1)1988)” 表示将预测变量在1980-1988年期间进行平均，
    *其中 “1980(1)1988” 表示始于1980年，以1年为间隔，而止于1988年；
    *其效果等价于 “1980 1981 1982 1983 1984 1985 1986 1987 1988”，
    *而前者的写法显然更为简洁。选择项 “keep(smoking_synth)” 
    *将估计结果存为Stata数据集 smoking_synth.dta（放在Stata的当前工作路径）。
    *估计结果如下。

  
********四、log日志操作整理*****
  
  
    cd E:\stata\results
    log using 计量经济学服务中心synth.log, text replace // log_-begin-__    
    
	help synth
   
    sysuse smoking
    cd "E:\stata\personal18\高级计量经济学\A13-synth\data"
    
	use smoking, clear
    xtset state year
    synth cigsale retprice lnincome age15to24 beer cigsale(1975) cigsale(1980) cigsale(1988), ///
    trunit(3) trperiod(1989) xperiod(1980(1)1988) figure nested keep(计量经济学服务中心20180102smoking_synth)

	
    sset state year
    synth cigsale beer lnincome retprice age15to24 cigsale(1988) cigsale(1980) cigsale(1975) , ///
    trunit(3) trperiod(1988) xperiod(1980(1)1988)  fig nested allopt keep(estout, replace)
	

    use E:\stata\高级计量经济学\A13-synth\data\计量经济学服务中心smoking_synth.dta, clear
    gen effect= _Y_treated - _Y_synthetic
    label variable _time "year"
    label variable effect "gap in per-capita cigarette sales (in packs)"
    line effect _time, xline(1988,lp(dot) lc(black)) yline(0,lp(dash) lc(black))   ///
    text(-25 1988 "Passage of Proposition 99  {&rarr}  ", placement(sw)) /// placement() et a. options for text()
    xtitle(year) ytitle("gap in per-capita cigarette sales (in packs)") lc(black) xlabel(1970(5)2000)	///
    title("政策效应：加州与合成加州人均香烟销售量差异")  ///
             subtitle("2017.10.01")  ///
             note("计量经济学服务中心2017.10")


    help line
    gen te= _Y_treated- _Y_synthetic 
    line te _time, xline(1988,lp(dot) lc(black)) yline(0,lp(dash) lc(black)) ///
    text(-25 1988 "Passage of Proposition 99  {&rarr}  ", placement(sw)) /// placement() et a. options for text()
    xtitle(year) ytitle("gap in per-capita cigarette sales (in packs)") lc(black) xlabel(1970(5)2000)	
 
 
 
 
********五、参考文献***** 
*Abadie, Alberto and Javier Gardeazabal, "The Economic Costs of Conflict: A Case Study of the Basque Country," American Economic Review, 2003, 93(1), 113-132.
*Abadie, Alberto, Alexis Diamond, and Jens Hainmueller, "Synthetic Control Methods for Comparative Case Studies: Estimating the Effect of California’s Tobacco Control Program," Journal of the American Statistical Association, 2010, 105(490), 493-505. 
*Abadie, Alberto, Alexis Diamond, and Jens Hainmueller, "Comparative Politics and the Synthetic Control Method," American Journal of Political Science, 2015, 59(2), 495-510.
*Bai, Jushan, "Panel Data Models with Interactive Fixed Effects," Econometrica, 2009, 77(4), 1229-1279.
*Billmeier, Andreas and Tommaso Nannicini, "Assessing Economic Liberalization Episodes: A Synthetic Control Approach," Review of Economics and Statistics, 2013, 95(3), 983-1001. 
*Bohn, Sarah, Magnus Lofstrom, and Steven Raphael, "Did the 2007 Legal Arizona Workers Act Reduce the State's Unauthorized Immigrant Population?" Review of Economics and Statistics, 2014, 96 (2), 258-69.
*Xu, Yiqing, "Synthetic Control Methods," 2014, MIT lecture notes. 下载地址：http://www.mit.edu/~xyq/teaching/17802/synth.pdf
*Xu, Yiqing, "Generalized Synthetic Control Method for Causal Inference with Time-Series Cross-Sectional Data," 2016, UCSD working paper. 
*刘甲炎、范子英，《中国房产税试点的效果评估：基于合成控制法的研究》，《世界经济》，2013年第11期，第117-135页。
*苏治、胡迪，《通货膨胀目标制是否有效？——来自合成控制法的新证据》，《经济研究》，2015年第6期，第74-88页。
*王贤彬、聂海峰，《行政区划调整与经济增长》，《管理世界》，2010年第4期，第42-53页
 

 
 
 
 
 
 
 
 
 
