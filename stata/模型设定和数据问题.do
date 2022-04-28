*****第9章,模型设定和数据问题*****
***9.1遗漏变量***

**1,遗漏变量和方程中的解释变量不相关:OLS估计是一致的,但是遗漏变量增大了扰动项的方差,影响OLS的估计精确度;
**2,遗漏变量和方程中的解释变量相关:OLS估计不是一致的,存在遗漏变量偏差.
**遗漏变量本身并不要紧,可以说对遗漏变量不感兴趣,但问题的关键是遗漏变量不能与方程内的解释变量相关;
**解决遗漏变量偏差的方法有:
*1,加入尽可能多的解释变量;
*2,使用代理变量(Proxy variable);
*3,工具变量法;
*4,使用面板数据;
*5,随机试验与自然实验.

**理想的代理变量满足:
*1,多余性:代理变量仅通过遗漏变量影响被解释变量;智商作为能力的代理变量,如果有能力变量,使用智商变量将会是多于的;
*2,剩余独立性:遗漏变量中不受代理变量影响的剩余部分与所有解释变量均不相关;

**遗漏变量问题总是存在的,专业论文几乎总是需要说明,它是如何在存在遗漏变量的情况下避免遗漏变量偏差的.

***9.2无关变量***
**1,引入无关变量:OLS估计仍然是一致的;
**2,受到无关变量的干扰,已知解释变量的系数β的方差一般会增大;
**解释变量的选择要遵循经济理论的指导.

***9.3建模策略***
**1,由小到大:小模型开始逐渐增加解释变量;
**2,由大到小:由尽可能大的模型开始,逐步剔除不显著的解释变量;
**  实际研究一般是二者折中的方案.

***9.4解释变量个数的选择***
**1,校正可决系数,选择解释变量个数K最大化校正可决系数;
**2,AIC:选择K使目标函数最小,第1项奖励:残差平方和最小,第2项惩罚:变量过多的惩罚,二者之和最小;
**3,BIC:或SIC,解释变量个数K增加时,第二项惩罚更严厉,更强调模型的简洁性;
**4,HQIC:也是选择K使得目标函数值最小,实践中HQIC不常用;
**5,时间序列,滞后阶数选择时,BIC和HQIC计算的p是一致的,AIC计算的滞后阶数p不是一致的;
**6,实践中AIC和SIC比较常用,大样本中BIC是一致估计,AIC不是一致估计,但是实际中样本通常有限,BIC导致模型过小,所以AIC依然很常用;
**案例:计算信息准则
	cd e:\data
	use icecream.dta,clear
	quietly reg consumption temp price income
	estat ic //计算AIC BIC信息准则,加入气温的一阶滞后项,解释变量增加,重新计算信息准则:
	quietly reg consumption temp L.temp price income
	estat ic //AIC和BIC均变小,引入气温滞后项是有效的,进一步增加气温二阶滞后项:
	quietly reg consumption temp L.temp L2.temp price income
	estat ic //AIC和BIC又增加了,说明气温二阶滞后项无效,不应该引入.

***9.5对函数形式的检验***
**1,Ramsey's RESET :模型加入y估计值的高次2,3,4项回归,原假设高次项系数为0,接受原假设,应该使用线性模型.
**  此检验的缺点是无法提供具体遗漏了哪些高次项的信息;
	reg y x1 x2 x3
	estat ovtest 	 //y估计值的2,3,4作为非线性项;
	estat ovtest,rhs //x的幂作为非线性项;
**2,link test:模型加入y估计值的1,2次项,原假设y估计值的2次项系数为0,接受原假设,应该使用线性模型;
	reg y x1 x2 x3
	linktest
**案例:函数形式的检验案例
	cd e:\data
	use nerlove.dta,clear
	quietly reg lntc lnq lnpl lnpk lnpf
	linktest // _hat和 _hatsq表示y估计值及其平方的系数,拒绝原假设(高次项系数为0),认为模型设定有误;
	estat ovtest
	estat ovtest,rhs //均拒绝了没有遗漏变量高次项的假设,认为遗漏了高阶非线性项,予以修正,加入高次项:
	g lnq2 = lnq^2
	reg lntc lnq lnq2 lnpl lnpk lnpf //加入了解释变量lnq的平方项;
	linktest
	estat ovtest //检验均显示接受了原假设,没有遗漏高次项,模型设定较好.

***9.6多重共线性*** 此部分内容在异方差和序列相关的部分进行了学习

***9.7极端数据***
**第i个观测值对回归系数的"影响力"或"杠杆作用"通过投影矩阵的第i个主对角线元素来表示;
**比较稳健的做法:同时汇报全样本和剔除极端数据后的子样本的回归结果;
**计算影响力levi的stata命令:
	reg y x1 x2 x3
	predict lev,leverage
	gsort -lev //降序
	sum lev 
	list lev in 1/3
**案例:计算各观测值对回归系数的影响力
	cd e:\data
	use nerlove.dta,clear
	qui reg lntc lnq lnpl lnpk lnpf
	predict lev,leverage
	sum lev
	disp r(max)/r(mean) //3.41,对回归系数影响最大的观测值是平均影响力的3.41倍,似乎也不大;
	gsort -lev
	list lev in 1/3 //降序后,看影响较大的三个值.

***9.8虚拟变量***
**1,仅引入虚拟变量本身:会影响回归直线的截距,回归线会发生平移;
**2,引入虚拟变量本身的同时,引入虚拟变量和自变量的交互项,交互项影响回归线的斜率.
**生成虚拟变量的命令:
	gen d = (year>=1978) //1978年以后的样本取值为1
	tabulate province,generate(pr) //以省份生成虚拟变量

***9.9经济结构变动的检验***
**1,结构变动日期已知:
*原假设:无结构变动
*传统邹检验:计算F统计量,全样本的方差平方和,78年以前的样本方差平方和,78年以后的样本方差平方和,计算三者的关系;
*虚拟变量法:通过引入虚拟变量本身和自变量的交互项,检验回归系数是否为0,同时检验截距项和系数是否发生变动,
**2,结构变动如期未知:
*匡特似然比检验QLR:计算(1950,2000)之间每一年所对应的F统计量,取F统计量最大值对应的那个日期t就是结构变动日期;
*QLR统计量小于临界值,则接受无结构变动的原假设;
**结构变动案例
	cd e:\data
	use consumption_china.dta,clear
	graph twoway connect c y year,msymbol(circle) msymbol(triangle) //走势图可以看到:c和y二者有较强的相关性
	reg c y //做二者简单的回归,看1992年是否发生结构变动;
	scalar ssr = e(rss) //将回归残差平方和赋值给变量ssr(标量);
	reg c y if year<1992
	scalar ssr1=e(rss)
	reg c y if year>=1992
	scalar ssr2=e(rss)
	disp ((ssr-ssr1-ssr2)/2)/((ssr1+ssr2)/25) //计算的邹检验F统计量等于13.56;
	*使用虚拟变量法进行结构变动检验:
	gen d = (year>1991)
	gen yd = y*d
	reg c y d yd 
	test d yd //检验d和yd的联合显著性,F=13.56,并且也拒绝原假设,认为存在结构变动;
	reg c y d yd,r //上面是同方差假设,异方差下使用稳健标准误,检验d和yd的联合显著性:
	test d yd //异方差情况下,依然拒绝无机构变动的原假设.

***9.10缺失数据和线性插值***
**stata会自动将缺失值从样本中删除掉,导致样本容量损失;
**线性插值:变量以线性速度均匀地变化,如果变量有指数增长趋势,应该先取对数再进行线性插值,
**插值结束,取反对数还原.
**插值案例:
	cd e:\data
	use consumption_china.dta,clear
	scatter y year
	gen y1 = y
	replace y1 = . if year==1980 | year ==1990 | year ==2000 //产生三个缺失值;
	ipolate y1 year,gen(y2) //生成y2变量,将缺失的数据进行了线性插值,非缺失值不变;
		//人均GDP有指数增长趋势,更好的做法是先取对数,再进行线性插值,最后反对数还原:
	gen lny1 = log(y1)
	ipolate lny1 year,gen(lny2)
	gen y3 = exp(lny2) //对数值还原
	list year y y2 y3 if year==1980 | year ==1990 | year ==2000 //对比插值的结果.
	*面板数据线性插值:
	by prov:ipolate lnedu1 year, gen (lnedu3)
*ipolate 只能补中间缺失值,不能补两端缺失值,补两端缺失值使用mipolate;
**mipolate插值的用法:
	help mipolate //外部命令,需要安装;	
	mipolate yvar xvar [if] [in] , generate(newvar) [ linear cubic spline pchip idw[(power)] forward backward
    nearest groupwise ties(ties_rule) epolate ]
    *面板外部线性插值:按个体分组,然后进行插值
	by id:mipolate var year, gen(var1) linear e //e指epolate,指定两端数据缺失插值,否则指内部数据缺失插值

***9.11变量单位的选择***
**选择变量单位时,尽量避免变量间数量级差别过于悬殊,以免计算机运算出现较大误差.





