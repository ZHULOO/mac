******************************************************************
*                                                                *
*                     五、实证结果完整输出docx                      *
*                                                                *
******************************************************************

	clear all
	cap mkdir E:\财务金融\结果输出
	cd E:\财务金融\结果输出
	! taskkill /F /IM WINWORD.EXE /T

*封面
	putdocx begin
	putdocx paragraph, halign(center)
	putdocx text ("实证结果展示"), font("华文楷体",70,black) bold linebreak
	putdocx text ("Empirical Results"), font("Times New Roman",50,red) ///标题
		bold linebreak
	putdocx text ("Prof. Chuntao Lee"), font("Times New Roman",30,purple) ///作者
		bold linebreak
	putdocx text ("Email："), font("Times New Roman",30,black) bold  
	putdocx text ("chtl@zuel.edu.cn"), font("Times New Roman",30,blue) ///联系方式
		bold underline(single) 
	putdocx pagebreak
	putdocx save 实证结果输出.docx, replace

*摘要
	use 3500常用汉字.dta, clear
	putdocx begin
	putdocx paragraph, halign(left)
	putdocx text ("Abstract"), font("Times New Roman",30,black) bold linebreak 
	forvalue linenum = 1/30 {
		local length = int(5+uniform()*20)
		forvalue j = 1/`length' {
			local i = int(3500*uniform()+1) 
			putdocx text (words in `i') 
		}
		putdocx text ("。")
	}
	putdocx pagebreak
	putdocx save 实证结果输出.docx, append

*描述性统计结果
	sysuse auto.dta, clear
	sum2docx price-length using 实证结果输出.docx, ///
		append stats(N mean(%9.2f) sd skewness kurtosis min(%9.2f) median max(%9.2f)) ///
		title("Summary Statistics")
	putdocx begin
	putdocx pagebreak
	putdocx save 实证结果输出.docx, append

*相关系数矩阵
	corr2docx price-length using 实证结果输出.docx, append star ///
		title("Pearson & Spearman Correlation Coefficient") note("By 爬虫俱乐部")
	putdocx begin
	putdocx pagebreak
	putdocx save 实证结果输出.docx, append

*分组均值t检验结果
	t2docx price-length using 实证结果输出.docx, append by(foreign) ///
		fmt(%9.2f) star title("this is the t-test table")
	putdocx begin
	putdocx pagebreak
	putdocx save 实证结果输出.docx,append

*回归结果
	reg length price-weight
	est store m1
	probit foreign price-weight
	est store m2
	reg2docx m1 m2 using 实证结果输出.docx, append scalars(N r2_a(%9.3f) r2_p(%9.2f)) ///
		t(%7.2f) title("regression results") mtitles("OLS" "probit")
	putdocx begin
	putdocx pagebreak
	putdocx save 实证结果输出.docx, append

*输出绘图
	clear all
	sysuse auto
	histogram mpg
	graph export hist.png, replace
	putdocx begin
	putdocx paragraph, halign(center) spacing(line,0.15)
	putdocx text ("每加仑英里数直方图"), font("宋体",20,black) bold linebreak
	putdocx image hist.png, width(6)
	putdocx save 实证结果输出.docx, append
	shellout 实证结果输出.docx

*输出因子分析结果
	cd E:\data\result
	*插入因子载荷矩阵：
	clear all
	sysuse auto
	factor price mpg weight length turn displacement gear_ratio,factors(3)
	*因子分析结果的保存：
	matrix list e(sds) 	 //各变量的方差
    matrix list e(means) //各变量的均值
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
	putdocx table a(2,.), border(top) 				//第二行有下边界线；
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
