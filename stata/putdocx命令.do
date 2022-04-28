*****putdocx导出stata结果到WORD*****
cd E:\data\putdocx
putdocx clear
putdocx begin
putdocx paragraph,halign(center) //
putdocx text ("This is paragraph text"),bold
putdocx table tbl1 = (3,4)
putdocx table tbl1(1,2) = ("Cell 2"),halign(right)
sysuse auto
regress price mpg weight
//line price mpg
//graph export "Graph.png"
//summarize mpg
putdocx table tbl2 = etable
putdocx paragraph
putdocx image shishen.png
putdocx save myfile1.docx,replace
di as txt `"(output written to {browse myfile1.docx})"'

putdocx begin
putdocx table tbl3 = (2,1)
putdocx table tbl3(1,1) = image("shishen.png")
putdocx table tbl3(2,1) = image("Graph.png")
putdocx save myfile2.docx
putdocx append myfile1 myfile2 //2合并到1;
di as txt `"(output written to {browse myfile2.docx})"'

***可以完整运行以下命令,然后查看example.docx文档,看保存的结果:
***一、支持etable的命令运行结果的导出***
*支持将相关命令运行的结果通过r()和e()直接调用
	*案例1：添加一个段落，直接调用一般命令返回值r()	
	sysuse dir //列出系统自带数据集;
	! taskkill /F /IM WINWORD.EXE /T //关闭当前运行的word；
	
	sysuse auto,clear
	summarize mpg
	return list
	ereturn list
	putdocx clear //已经使用过putdocx begin，内存中存在一个docx了，再次使用begin前需要clear
	putdocx begin
	putdocx paragraph
	putdocx text ("In this dataset,there are `r(N)'")
	putdocx text ("models of automobiles. The maxmum MPG among them is " )
	putdocx text (r(max)),bold
	putdocx text (".")
	/*
	putdocx save example.docx //保存以后，内存中的文档就删除了，再次写入还需要begin
	di as txt `"(output written to {browse example.docx})"'
	shellout example.docx
	*/

	*案例2：导出stata命令产生的图像
	scatter mpg price
	cap graph export auto.png //将图像输出保存到当前目录
	putdocx paragraph,halign(center) //产生一个段落，存放图像
	putdocx image auto.png
	
	*案例3：导出描述统计的表格
	preserve //如果当前命令产生新的数据覆盖了之前的内存中的数据，需要将之前内存中的数据保存起来；
	statsby Total=r(N) Average=r(mean) Max=r(max) Min=r(min), by(foreign):summarize mpg
		//按照foreign分组，收集summarize命令产生的各组样本数、均值、最大值和最小值,暂存到内存数据表格中；
		//原来内存中的auto数据删除了，后面还要使用auto的情况下，需要preserve和restore配对使用；
	rename foreign Origin
	putdocx table tbl1 = data("Origin Total Average Max Min"),varnames /// //使用上面statsby收集暂存的数据，导出到tabl1；
	border(start,nil) border(insideV,nil) border(end,nil) 				   //3个border去掉竖向边框；
		//上面几个命令改变了内存中在使用的data，后面使用restore恢复；
	*案例4：表格格式	
	putdocx table tbl1(., 2/5), halign(right)
	restore  
	//上面和preserve之间的代码改变了数据，运行完代码后恢复运行之前的数据；
	regress mpg gear_ratio turn foreign,noheader cformat(%9.3f) //回归的时候限定数据格式，
		//后面调用回归结果的表格数据格式就是统一的,只对etable导出结果的方式有效；
	putdocx table reg = etable //使用etable将reg命令的结果导出到reg表格中
	putdocx describe reg //描述生成的reg表格

	*案例5：有选择地导出估计结果，先用etable导出的整个结果，再对表格进行删减操作，修改相应格式：
	putdocx table tbl2 = etable, width(100%)
	putdocx table tbl2(.,5), drop  				//drop p-value column
	putdocx table tbl2(.,4), drop  				//drop t column
	putdocx table tbl2(.,3), drop  				//drop SE column
	putdocx table tbl2(1,1) = ("") 				// erase the content of first cell "mpg"
	putdocx table tbl2(.,1), border(right, nil)
	putdocx table tbl2(.,2/4), nformat(%9.3f)
	*案例6：输出估计结果中的矩阵：
	regress mpg gear_ratio turn foreign,noheader cformat(%9.3f)
	matrix list r(table)      //9x4
	matrix rtable = r(table)' 
	matrix list rtable //4x9 转置后
	matrix r_table = rtable[1...,1],rtable[1...,5..6] //间断选择第1列，然后选择第5、6列；
	matrix list r_table
	//
	putdocx table tbl3 = matrix(r_table),nformat(%9.3f) rownames colnames ///
		border(start,nil) border(insideH,nil) border(insideV,nil) border(end,nil)
	putdocx table tbl3(1,2) = ("Coef."),halign(right)
	putdocx table tbl3(1,3) = ("[95% Conf.Interval]"),halign(right) colspan(2)
	putdocx table tbl3(1,.),border(bottom)
	putdocx table tbl3(2/5,.),halign(right)
	*案例7：先创建部分表格，再连接起来：
	 *先创建一个1x2表格tbl41，并写入内容作为表头部分；
	putdocx table tbl41 = (1,2),memtable border(all,nil) //memtable选项表示tbl41先保存在内存中，
		//不输出到begin创建的document中；后面再将tbl41和其它表格拼接；
	putdocx table tbl41(1,1) = ("Coef."),halign(right)
	putdocx table tbl41(1,2) = ("[95% Conf .Interval]"),halign(right)
	 *再创建一个表格tbl42，存放上面的r_table矩阵的数据：
	putdocx table tbl42 = matrix(r_table),memtable border(all,nil) nformat(%9.3f) rownames
	putdocx table tbl42(.,.),halign(right)
	 *再创建一个2x1表格tbl4，分别装入上面的表头tbl41和数据tbl42：
	putdocx table tbl4 = (2,1),border(start,nil) border(end,nil)
	putdocx table tbl4(1,1) = table(tbl41)
	putdocx table tbl4(2,1) = table(tbl42)
	*案例8：创建一个动态表格：下面的第2中情况，
	 *1、表格维度已知，先创建表格mxn，然后再入数据；
	 *2、表格维度未知，先创建简易部分表格，再逐步添加行或列。例如将回归结果的系数、标准误、观测值数和可决系数等
	  //逐步增加行输入到表格中：先创建一个1x2的表头，
	putdocx pagebreak //分页符
	putdocx table tbl5 = (1,2),border(all,nil) width(4) halign(center) note("Note:standard errors in parentheses")
	putdocx table tbl5(1,1)=("mpg"),halign(right) colspan(2) border(top) border(bottom)
	 *使用循环逐步放入各变量名称、估计系数、标准误等：
	local row 1
	local vari 1
	foreach x in gear_ratio turn foreign _cons {
		putdocx table tbl5(`row',.),addrows(2) 					//先在表头下面增加2行；
		local b:display %9.3f rtable[`vari',1] 					//先将rtable中的第1行第1列代表的gear_ratio的系数取出赋值为b=4.856；
			local se:display %9.3f rtable[`vari',2] 			//将rtable中的第1行第2列代表的gear_ratio的系数标准误取出赋值为se=1.522；
			local ++vari 										//vari = vari+1 然后vari从1增加到2；

		local ++row 											//row增加为2；
			putdocx table tbl5(`row',1) = ("`x'"),halign(right) //tbl5表格的第2行，第1列填入变量gear_ratio的名称；
			putdocx table tbl5(`row',2) = ("`b'"),halign(right) //tbl5表格的第2行，第2列填入变量gear_ratio的估计系数b；
			local ++row 										//row增加为3；
			local se = strtrim("`se'") 							
			putdocx table tbl5(`row',2) = ("(`se')"),halign(right) //tbl5表格的第3行，第2列填入变量gear_ratio的估计标准误se=(1.522)；
	}
	putdocx table tbl5(`row',.),addrows(2) 						   //循环结束后，表格后面再增加2行，存放N和R方的值
	local ++row 
	putdocx table tbl5(`row',1) = ("N"),border(top) halign(right)
	putdocx table tbl5(`row',2) = (e(N)),border(top) halign(right)
	local ++row 
	local r2:display %9.3f e(r2)
	putdocx table tbl5(`row',1) = ("R2"),border(bottom) halign(right)
	putdocx table tbl5(`row',2) = (`r2'),border(bottom) halign(right)
	*案例9：多个图形嵌套输出：
	cd "e:\data"
	use http://www.stata-press.com/data/r15/nhanes2, clear
	save nhanes2.dta,replace
	use nhanes2.dta,clear
	reg bpsystol agegrp##sex##c.bmi
	cd "e:\data\putdocx"
	forvalues v=10(10)40{
		margins agegrp ,over(sex) at(bmi=`v') //计算agegrp变量的边际效应，按性别分别显示
		marginsplot
		graph export bmi`v'.png
	}
	//将上面循环生成的4个编辑效应图保存到一个2x2的表格中,嵌套输出:
	putdocx pagebreak
	putdocx table tbl6 = (2,2), border(all,nil) note(Figure 1: Predictive margins of agegrp) halign(center)
	putdocx table tbl6(1,1)=image(bmi10.png) 
	putdocx table tbl6(1,1)=("(a) bmi=10"), append halign(center)
	putdocx table tbl6(1,2)=image(bmi20.png)
	putdocx table tbl6(1,2)=("(b) bmi=20"), append halign(center)
	putdocx table tbl6(2,1)=image(bmi30.png)
	putdocx table tbl6(2,1)=("(c) bmi=30"), append halign(center)
	putdocx table tbl6(2,2)=image(bmi40.png)
	putdocx table tbl6(2,2)=("(d) bmi=40"), append halign(center)
	putdocx table tbl6(3,.), halign(center) bold

	putdocx save example.docx //,append
	di as txt `"(output written to {browse example.docx})"'
	shellout example.docx


***二、不支持etable的命令结果的导出***
 **1、自己写命令导出数据、估计表格和矩阵等
 **2、直接将log文件整齐地写入WORD文档
  *将log中的内容完整地读入WORD文档：
 	cls
	log using log2docx.txt, text replace nomsg

	sysuse auto, clear
	regress mpg weight foreign
	table make
	tabulate foreign

	log close 

	putdocx clear
	putdocx begin
	putdocx paragraph, style("Heading1")
	putdocx text ("Chapter 8: Add log files"), font(, 20)
	file open fh using log2docx.txt, read
	file read fh line
	putdocx paragraph, font("Courier", 9.5)
	while r(eof)==0 {
		putdocx text (`"`line'"'), linebreak
		file read fh line
	}
	file close fh
	putdocx save log2docx.docx, replace
	di as txt `"(output written to {browse log2docx.docx})"'

	erase log2docx.txt //删除掉log文件
