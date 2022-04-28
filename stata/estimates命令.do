***estimates命令:保存和操作估计结果***
help estimates
*1.可以保存估计结果到文件;
*2.可以保存估计结果到内存,可以切换不同的估计结果,组合不同的估计结果;

*保存到磁盘:
estimates save filename //保存回归结果到文件;
estimates use filename  //从磁盘读取回归结果;
//实例:
cd "e:\data"
use auto,clear
reg mpg weight displacement foreign
estimates save mymodel  //估计的结果mymodel.ster被保存;
estimates use mymodel
reg 					//直接重现上面的回归结果;
test foreign == 0		//检验foreign的回归系数是否为0;
test displacement == 0

estimates describe using filename
estimates esample

*保存到内存:
estimates store name
estimates restore name
estimates query
estimates dir
estimates drop namelist
estimates clear
//实例:
sysuse auto,clear
reg mpg weight displacement
reg 						//直接可以重现上面的回归结果;
estimates store myreg
estimates restore myreg 
estimates dir 				//列出内存中保存的估计结果;

	

*设置标题和笔记:
estimates title: text
estimates title

estimates notes: text
estimates
estimates notes list
estimates notes drop
//实例:
sysuse auto,clear
reg mpg weight displacement if foreign
estimates notes:file `c(filename)'
datasignature
estimates notes:datasignature report `r(datasignature)'
estimates save foreign,replace //保存前使用notes做笔记,会连笔记的内容一起保存;
estimates notes list
//或者
estimates use foreign
estimates notes

*报告:
estimates describe
// 实例:
sysuse auto,clear
reg mpg weight displacement foreign price

estimates store m1
estimates describe m1 				//和上面的store命令配合使用,描述store保存到内存的m1的命令;
return list

estimates save mymodel1,replace
estimates describe using mymodel1	//和上面的save命令配合使用,描述save保存到磁盘的估计结果;
return list

estimates replay m1 //保存的回归结果m1再现;

*表格和统计输出:
estimates table
//实例:
sysuse auto,clear
reg mpg weight displacement
estimates store base
reg mpg weight displacement foreign
estimates store alt
estimates table base alt,b(%7.2f) se(%7.2f) stats(N r2_a) p(%4.3f) varlabel keep(weight _cons)
estimates table base alt,star varlabel keep(weight _cons) //此命令会产生

estimates selected
//实例:
estimates selected base alt,sort(name) display(coef)

estimates stats //计算AIC,BIC
//实例:
estimates stats base alt,n(1000)

estimates for namelist:
//实例:
reg mpg i.foreign i.foreign#c.weight displacement
estimates store reg
qreg mpg i.foreign i.foreign#c.weight displacement
estimates store qreg //分位数回归;
estimates for reg qreg: test 0.foreign#c.weight == 1.foreign#c.weight //分别检验普通回归和分位数回归中的回归系数是否相等;

sysuse auto,clear
