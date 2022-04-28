******************************************************************
*                                                                *
*              四、sum2docx t2docx reg2docx corr2docx             *
*                                                                *
******************************************************************
//安装四个命令
net install sum2docx, from("https://stata-club-1257787903.cos.ap-chengdu.myqcloud.com/sum2docx") replace
net install t2docx, from("https://stata-club-1257787903.cos.ap-chengdu.myqcloud.com/t2docx") replace
net install reg2docx, from("https://stata-club-1257787903.cos.ap-chengdu.myqcloud.com/reg2docx") replace
net install corr2docx, from("https://stata-club-1257787903.cos.ap-chengdu.myqcloud.com/corr2docx") replace

*1.sum2docx输出描述性统计结果到docx文件
clear all
cd E:\财务金融\结果输出
sysuse auto, clear
sum2docx price mpg rep78 foreign using 描述性统计.docx, replace ///
	stats(N mean sd skewness kurtosis min median max)
*shellout 描述性统计.docx

sum2docx price mpg rep78 foreign using 描述性统计.docx, append ///
	stats(N mean(%9.2f) sd(%9.2f) skewness kurtosis min median max) ///
	title("Table 1: Summary Statistics") note("auto.dta") ///
	font("黑体",10,brown)
shellout 描述性统计.docx

*2.t2docx输出分组均值t检验结果到docx文件
sysuse auto, clear
t2docx price weight length mpg using 分组均值t检验.docx, replace by(foreign)
*shellout 分组均值t检验.docx
//by(foreign)制定分组变量

t2docx price weight length mpg using 分组均值t检验.docx, append ///
	by(foreign) fmt(%9.2f) p staraux title("this is the t-test table") ///
	note("依据变量foreign分组") font("黑体",9,brown)
shellout 分组均值t检验.docx

//p staraux表示在P值后添加星号

*3.reg2docx输出回归结果到docx文件
clear all
use mydata.dta
reg y x1 x5 x6 ind2-ind10
est store m1
reg y x1 x2 x5 x6
est store m2
reg y x1 x2 x3 x5 x6 ind2-ind10
est store m3
reg y x1 x2 x3 x4 x5 x6
est store m4
reg2docx m1 m2 m3 m4 using 回归结果.docx, replace indicate("ind=ind*") ///
	scalars(N r2 r2_a) b t
*shellout 回归结果.docx

//indicate("ind=ind*")不报告ind=ind变量的回归结果

reg y x1 x5 x6 ind2-ind10
est store m1
reg y x1 x2 x5 x6
est store m2
reg y x1 x2 x3 x5 x6 ind2-ind10
est store m3
reg y x1 x2 x3 x4 x5 x6
est store m4
reg2docx m1 m2 m3 m4 using 回归结果.docx, append indicate("ind=ind*") ///
	drop(x2 x3) order(x1 x6 x5) scalars(N r2(%9.3f) r2_a(%9.2f)) b(%9.3f) p(%7.2f) ///
	title("表2: OLS regression results") mtitles("模型1" "模型2" "模型3" "模型4")
*shellout 回归结果.docx

*工具变量回归结果输出
putdocx begin
putdocx pagebreak
putdocx save 回归结果.docx, append
reg x1 z x2 x3 x4 x5 x6 ind2-ind10 //一阶段
est store m5
ivregress 2sls y (x1=z) x2 x3 x4 x5 x6 ind2-ind10 //两阶段
est store m6
reg2docx m5 m6 using 回归结果.docx, append indicate("ind=ind*") ///
	drop(x2 x3) scalars(N r2(%9.3f) r2_a(%9.2f)) order(x1 z x6 x5) b(%9.3f) se(%7.2f) ///
	title("表3: IV results") mtitles("First Stage" "2SLS")
shellout 回归结果.docx

*4.corr2docx输出相关系数矩阵到docx文件
clear all
sysuse auto
spearman price-length
corr price-length
corr2docx price-length using 相关系数矩阵.docx, replace star landscape
*shellout 相关系数矩阵.docx

*输出价格最高的前30种国产车的相关系数矩阵
putdocx begin
putdocx pagebreak
putdocx save 相关系数矩阵.docx, append
gsort -price
corr2docx price-length in 1/30 if foreign == 0 using 相关系数矩阵.docx, append ///
	star nodiagonal note("The top30 of domestic car sort by price") landscape
*shellout 相关系数矩阵.docx

******
putdocx begin
putdocx pagebreak
putdocx save 相关系数矩阵.docx, append
corr2docx price-length using 相关系数矩阵.docx, append star(* 0.05) fmt(%4.2f) ///
	pearson(ignore) title("Spearman Correlation Coefficient") ///
	note("By 爬虫俱乐部") landscape
shellout 相关系数矩阵.docx
