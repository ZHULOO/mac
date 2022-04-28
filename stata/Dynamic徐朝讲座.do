***putdocx生成动态文档
	cls
* load data
	sysuse auto, clear

	putdocx clear
	putdocx begin

	putdocx paragraph, style("Heading1")
	putdocx text ("Chapter 2: Add estimation tables"), font(, 20)

* coefficient table，etable命令生成表格
	regress mpg i.foreign weight
	putdocx table a1 = etable, title("Table 1: coefficient table")
	putdocx table a1(1,1), font(, 15) bold halign(center)


* estimates table
	regress mpg foreign weight headroom trunk length turn displacement
	est store Model1

	regress mpg foreign weight headroom
	est store Model2

	regress mpg foreign weight
	est store Model3

	estimates table Model1 Model2 Model3, stats(N r2) star b("%9.3f") stfmt("%9.3f")
	//estimates命令产生etable表格,可以直接引用: estimates命令用法参见estimates命令.do;
	putdocx table a2 = etable, title("Table 2: estimation results comparation")

	putdocx table a2(1,1), font(, 15) bold halign(center)

	* margins
	//use margex, clear
	//logistic outcome i.sex i.group sex#group

	//margins sex group, cformat("%9.3f")

	sysuse auto,clear
	reg mpg i.foreign weight headroom trunk length i.turn displacement
	margins foreign turn,cformat("%9.3f")

	putdocx table a3 = etable, title("Table 3: Marginal effect") //margins命令产生etable;
	putdocx table a3(1,1), font(, 15) bold halign(center)

	putdocx save esttable.docx, replace
	di as txt `"(output written to {browse esttable.docx})"' //命令结束的地方给出保存的文件超链接





	cd e:\data\result
	help putdocx
	putdocx
	putdocx begin
	putdocx paragraph
	putdocx text
	putdocx image  //图片是段落的一部分
	putdocx table mytable=etable //格式设置，添加删除行、列很多选项可以用 
	putdocx save  //保存为空白文档或者追加append
	sectionbreak  //分节符，横向和纵向，不同的页眉页脚设置
**putdocx输出表格
	clear all
	sysuse auto,clear
	regress mpg i.foreign weight
	putdocx clear
	putdocx begin
	putdocx table a1 = etable, title("Table 1: coefficient table")
	putdocx table a1(1,1), font(, 15) bold halign(center)
	putdocx save regtable.docx,replace
	di as txt `"(output written to {browse regtable.docx})"'
**因子分析结果案例
	putdocx clear
	putdocx begin
	sysuse auto,clear
	factor price mpg weight length turn displacement gear_ratio,factors(3)
	putdocx table a1 = etable, title("Table 1: factor table") //出错,factor命令不产生etable;
	putdocx save factortable.docx,replace
	di as txt `"(output written to {browse factortable.docx})"'


	return list
	ereturn list

	matrix list e(sds) 	 //各变量的方差
    matrix list e(means) //各变量的均值
    matrix list e(C) 	 //保存着各变量的相关系数矩阵
    matrix list e(Phi)   //保存着公因子相关矩阵
    matrix list e(L) 	 //保存着因子载荷矩阵
    matrix list e(Psi) 	 //保存着特殊方差
    matrix list e(Ev) 	 //每个公因子对应的特征值
	
	rotate
	ereturn list
	matrix list e(r_L) //旋转后的因子载荷矩阵
	
	! taskkill /F /IM WINWORD.EXE /T //写入word之前关闭内存中的word进程
	putdocx begin
	putdocx paragraph, halign(left) //写入一段文字，将段落内容左对齐
	putdocx text ("This is the first paragraph"), bold linebreak //输入加粗的文本"This is the first paragraph"，并在结尾处换行。
	putdocx text ("这是一个粗体字"), bold linebreak underline(dotted) //输入加粗的文本"这是一个粗体字"，给文本加上点式下划线，并在结尾处换行
	putdocx text (""), linebreak //不输入文本内容，直接换行
	putdocx text ("这是一个粗体字"), font("华文楷体",30,red) bold underline(dash) //输出加粗文本"这是一个粗体字"，字体为华文楷体，字号为30，颜色为红色，给文本内容加上虚下划线。
	putdocx paragraph, halign(center) //再重新开始一段新的文本内容，使文本内容居中。
	putdocx text ("这是一个粗体字"), font("华文隶书",80,blue) //输入文本"这是一个粗体字"，字体为华文隶书，字号为80，颜色为蓝色。
	//我们要把以上输入的这段文字保存在.docx文件里面，这时候需要用到命令putdocx save。
	putdocx save mytable.docx, replace //将文本内容保存成D盘的mytable.docx文件。
	shellout mytable.docx

	*插入因子载荷矩阵：
	clear all
	sysuse auto
	factor price mpg weight length turn displacement gear_ratio,factors(3)
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







tab2docx //exports tabulation tables to MS Word
tabulate2docx

putpdf //直接产生pdf文档，语法结构和putdocx相似
dyndoc //处理markdown，生成html文件 .md .txt 等转换成HTML文件
dyntext //stata结果插入到latex文本中，latex文档中加入"stata命令部分"运行保存到当前目录中，运行latex时，直接调用保存的stata运行结果生成pdf文档

stata表格导入到word
putdocx table a = etable 估计的结果
margins 
putdocx table b = etable
estimate table model1 model2 model3 ,stats 
putdocx table c = etable
 //nil 竖线不显示

tabout命令 结合putdocx将表格输出到word
tabstat
tabulate //等表格输出到word

四个图片放到一个2x2表格显示
cls //清屏
log 结果写入到word
log等txt文件逐行读入

***编写自己的命令
plugin
