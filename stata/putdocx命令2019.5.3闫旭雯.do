******************************************************************
*                                                                *
*                          一、putdocx                            *
*                                                                *
******************************************************************

*1.编辑docx文件中的文字内容
clear all
cd E:\财务金融\结果输出
! taskkill /F /IM WINWORD.EXE /T 
putdocx begin, pagesize(A4) landscape
putdocx paragraph, halign(left)
putdocx text ("实证结果展示 Empirical Results"), ///
	font("华文楷体",20,black) bold shading(yellow) linebreak
putdocx text ("实证结果展示 Empirical Results"), ///
	font("Times New Roman",20,blue) bold
putdocx paragraph, halign(center) spacing(line,0.3)
putdocx text ("实证结果展示 Empirical Results"), ///
	font("宋体",20,red) bold italic linebreak
putdocx text ("实证结果展示 Empirical Results"), ///
	font("黑体",20,black) bold
putdocx save mytable.docx, replace
shellout mytable.docx

*2.插入表格
clear all
! taskkill /F /IM WINWORD.EXE /T
putdocx begin
putdocx pagebreak
putdocx table table1 = (3,4)
putdocx table table1(2,1) = ("变量"), halign(center) border(all,double,red)
putdocx save mytable.docx, append 
shellout mytable.docx

*3.输出内存中的list结果
clear all
! taskkill /F /IM WINWORD.EXE /T
putdocx begin
putdocx paragraph, halign(center) 
putdocx text ("Auto.dta"), font("Times New Roman",50,blue) bold linebreak
putdocx text ("list结果展示"), font("华文楷体",50,black) bold 
putdocx save list.docx, replace
********输出1行到20行观测值的list表格
sysuse auto, clear
putdocx begin
putdocx pagebreak
putdocx paragraph, halign(center)
putdocx text ("Auto,list in 1/20"), bold
putdocx table table2 = data("make price weight length") in 1/20, ///
	varnames layout(autofitcontents) indent(2)
putdocx table table2(1,.), bold shading(blue) font(,,white)
forvalues row = 2(2)20 {
	putdocx table table2(`row',.), shading(lightblue)
}
putdocx save list.docx, append 

********输出21行到40行观测值的list表格
putdocx begin
putdocx pagebreak
putdocx paragraph, halign(center)
putdocx text ("Auto,list in 21/40"), bold
putdocx table table3 = data("make price weight length") in 21/40, ///
	varnames width(6) halign(center) cellspacing(0.08)
putdocx save list.docx, append 
shellout list.docx

*4.输出矩阵
clear all
sysuse auto
reg mpg price rep78 weight
// mat list r(table) 列出r(table)
// mat rt = r(table)' 转置
mat list rt 
! taskkill /F /IM WINWORD.EXE /T
putdocx begin
putdocx table table4 = matrix(r(table)'), colnames rownames nformat(%7.2f)
putdocx save matrix.docx, replace
shellout matrix.docx 

*5.输出图形
clear all
sysuse auto
histogram mpg
graph export hist.png, replace
! taskkill /F /IM WINWORD.EXE /T
putdocx begin
putdocx paragraph, halign(center) spacing(line,0.15)
putdocx text ("每加仑英里数直方图"), font("宋体",20,black) bold linebreak
putdocx image hist.png, width(6)
putdocx save hist.docx, replace
shellout hist.docx

*6.使用putdocx append合并文件并打开
! taskkill /F /IM WINWORD.EXE /T
putdocx append list.docx matrix.docx hist.docx, saving(all.docx,replace)
shellout all.docx
