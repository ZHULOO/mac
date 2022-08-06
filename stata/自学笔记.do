set timeout1 600
set timeout2 600

*****快捷键*****
*****win10快捷键*****
	win+I 设置
	win+E 打开我的电脑
	win+A 操作中心
	win+S 打开搜索
	win+K 连接设备
	win+V 剪切板
	win+shift+s 截图
	win+ctrl+D 创建虚拟桌面
	win+ctrl+F4关闭虚拟桌面
	win+ctrl+向左 切换虚拟桌面
	win+ctrl+向右

*****stata快捷键*****
	ctrl+9 打开do文件窗口
	ctrl+8 打开data编辑窗口
	变量快捷输入方法：	
	数据与变量的输入快捷键，在command窗口输入变量，只需要输入首字母，然后tab
	在command窗口输入多行命令时用ctrl+enter换行
	help limits 查看stata各种限制

	data窗口字体颜色
	红色 字符型
	黑色 数值型
	蓝色 虚拟变量

*****sublime快捷键*****
	分屏显示功能:
	alt+shift+1         横向单屏显示
	alt+shift+2         横向双屏显示
	alt+shift+8         竖向双屏显示
	alt+shift+9         竖向三屏显示

	home	             移动到行首
	end	                 移动到行尾
	shift+home	         选择到行首
	shift+end	         选择到行尾
	shift+left	         移动并选择
	shift+right	         移动并选择
	shift+up	         移动并选择
	shift+down	         移动并选择
	ctrl+home	         移动到页首行头
	ctrl+end	         移动到页尾行尾
	ctrl+shift+home	     选择到页首行头
	ctrl+shift+end	     选择到页尾行尾
	ctrl+]	             缩进
	ctrl+[	             不缩进
	ctrl+l	             选择行，重复可依次增加选择下一行
	ctrl+shift+enter	 在当前行前插入新行
	ctrl+shift+backspace 左侧全部删除
	ctrl+left	         按\w规则移动（跳跃）
	ctrl+right	         按\w规则移动（跳跃）
	ctrl+shift+left	     按\w规则移动并选择（跳跃）
	ctrl+shift+right	 按\w规则移动并选择（跳跃）
	alt+left	         按单词移动
	alt+right	         按单词移动
	alt+shift+left	     按单词移动并选择
	alt+shift+right	     按单词移动并选择
	ctrl+alt+up	         选择多行进行编辑
	ctrl+alt+down	     选择多行进行编辑
	shift+f3             上一个匹配项 
	ctrl+f3              下一个匹配项
	alt+F3               全选当前字段

	编辑区
	ctrl+N         新建
	ctrl+F2        设置书签
	F2             跳转到下一书签
	ctrl+shift+F2  删除所有书签
	
	ctrl+J           合并多行为一行
	alt+shift+down   复制当前行
	ctrl+shift+K     删除当前行
	alt+enter        直接换行
	alt+up/down      向上或下移动行

*****命令操作*****
	ssc hot, n(10)                 //可以呈现过去三个月关注度最高的 10 个命令
	ssc new                        //最近一个月发布了哪些新的外部命令
	ado                            //查看已经安装的所有外部命令
	adoupdate                      //更新这些外部命令
	// ado uninstall               //卸载这些外部命令，慎用，以防不小心卸载了自己下载的命令
	help
	ssc install +cmd
	findit                         //三种安装外部命令的方法
	ssc describe x                 //列出所有以x开头的外部命令
	ado, find(esttab)              //查询外部命令
	ado
	which+cmd                      //显示命令版本号等内容，组合非常重要，需要掌握

*****路径操作*****
	sysdir 							//列出stata系统目录
	sysdir list 					//和上面的命令一样
	sysdir set 						//重设stata系统目录
	personal						//列出个人ado目录
	personal dir 					//列出个人ado目录下的所有文件
	adopath							//显示ado文件的所有路径
	adopath + c:\myprogs			//添加myprogs到ado文件路径的最后
	adopath ++ c:\myprogs			//添加myprogs到ado文件路径的开始
	adopath - c:\myprogs			//删除myprogs
	display "`c(sysdir_stata)'"		//显示stata安装路径
	display "`c(pwd)'" 				//显示当前目录
	sysdir set PLUS "`c(sysdir_stata)'ado\plus"    		    //设置外部命令的存放位置
  	sysdir set PERSONAL "`c(sysdir_stata)'ado\personal"  	//设置个人文件夹位置

*****文件操作*****
	d                                            //change directory
	dir                                          //列出当前目录文件
	pwd                                          //当前工作路径
	`c(pwd)'                                     //引用当前工作路径
	mkdir e:\temp                                //新建文件夹
	rmdir e:\temp                                //删除文件夹
	copy myauto.txt e:\temp\myauto.txt ,replace  //复制文件到
	rm myauto.txt                                //删除文件
	rm myauto*.txt                               //删除文件，不支持通配符*
	!del *.txt                                   //调用DOS命令操作删除，支持通配符
	注意慎用用菜单下save按钮，会修改原始数据

	outsheet using temp.txt,replace              //输出为txt格式
	shellout temp.txt
	browse 或 br                                 //浏览数据
	edit 或 ed                                   //编辑数据

1.外部命令：
	ssc install expl, replace
	expl 分类显示当前目录所有文件
	dirtools- 命令: 高效管理文件的外部命令
	lall              // 列示所有文件
	ldta              // 列示 .dta 数据文件
	lado              // 列示 .ado 文件
	expl              // 分类列示当前目录下的文件，以及打开我的电脑
	rmfiles           //help rmfiles外部命令，移除当前路径下的所有文件
	cd D:\stata12\utilities //设置当前工作路径
	cdout                   //打开当前路径文件夹 

2.stata官方命令  -dir-, -mkdir-, -rmdir-
	pwd                 	 // 获取当前目录
	dir              		 // 显示当前目录下的所有文件
	dir *.txt         		 // 显示后缀为 ".txt" 的所有文件
	dir xt*         	     // 显示以 "xt" 开头的所有文件
	sysdir                   // 显示satata相关路径
	sysuse dir               // 列出所有系统自带的数据dta
	mkdir `c(pwd)'\mystata   // 当前当前目录下新建mystata文件夹
	rmdir `c(pwd)'\mystata   // 删除当前目录下的mystata文件夹 
	erase                    // 删除文件
	fileexists("temp.txt")   //判断当前路径下temp.txt文件是否存在，存在返回1，否则返回0，前面加！表示相反的情况。

3.mvfiles                  //移动文件
	ssc install mvfiles
	其他相关命令
	help msdirb //列示指定文件夹中的文件名，存储于 .dta 文件中
	help lmsdirb //列示指定文件夹中的文件名，存储于暂元中
	help rcd //遍历文件夹及所有子文件夹，文件名存储于返回值中，便于后续循环调用。rcd.ado 是个自循环程序，牛！
	help dirtools //一系列管理文件的快捷命令
	help renfiles // renaming set of matched files
	help rmfiles // removing set of matched files
	mvfiles,infolder(string) outfolder(string) match(string) subs(string) makedirs erase oldstx
	/*各个选项含义如下：
	infolder()  设定待搜寻的文件所在的文件路径
	outfolder() 设定目标文件路径
	match()     设定文件匹配准则
	subs()     确定匹配准则是否应用于子文件夹
	makedirs  如果目标文件夹不存在，则自动生成
	erase     旧文件被移动后自动删除
	oldstx    兼容 Stata 9.0 以下版本，较少使用
	*/
	cap mkdir e:\data
	cd e:\data
	sysuse auto,clear
	forvalues i =1(1)5{                                              
		export excel auto`i'.xlsx,replace                                  //循环输出5个auto*.xlsx和5个sub*.xlsx文件，用于移动
		export excel sub`i'.xlsx,replace
	}
	cdout
	mvfiles,infolder(".") outfolder(".\move") match("sub*") makedirs erase //将当前文件夹下的sub*.xlsx移动到move文件夹下，如果move不存在
	                                                                       //将新建，erase删除源文件，相当于剪切
	mvfiles,infolder(".") outfolder(".\move") match("auto*")               //将当前文件夹下的所有excel文件移动到movie下

	forvalues i = 1(1)5{
		cap mkdir "e:\data\auto`i'"
		cap mkdir "e:\data\sub`i'"
		cd "e:\data\auto`i'"
		sysuse auto,clear
		export excel autosub`i'.xlsx,replace                                  //分别生成10个子文件夹，每个文件夹下面输出对应名字的excel文件
		cd "e:\data\sub`i'"
		sysuse auto,clear
		export excel sub`i'.xlsx,replace
	}
	cd e:\data   //循环结束进入了sub5路径
	mvfiles,infolder(".") outfolder(".\moveauto") match("autosub*") subs("auto*") makedirs //将auto子文件夹下的autosub的文件复制到moveauto

	普通图片文件试用
	cd E:\BaiduNetdiskDownload\李丽莎
	mvfiles,infolder(".") outfolder(".\李丽莎") match("*") subs("*") makedirs

*****读入数据*****
	set obs 10                                               //生成序列前设置总观测值数
	egen v =seq()            								 //egen命令 区别于gen命令
	egen v =seq(),b(n)      								 //生成十个数，每个数重复n次
	egen d =seq(),to(4)     								 //反复生成1到4的序列
	egen e =seq(),f(10)t(1)  								 //生成从10到1的序列

	sysuse auto,clear           							 //读入系统自带数据
	insheet using temp.txt,clear 							 //读入txt和csv格式数据
1、读入excel格式数据
	cd E:\财务金融\财务报表\资产负债表
	import excel using FS_Combas.xls,first case(lower) clear //first读入时，第一行作为变量名读入，case(lower)变量名小写
														 ////加入sheet(sheet1)选项，可以读取不同工作簿下的数据	
2、重塑数据
	reshape
	tidy                                                      //外部命令，安装ssc install tidy
	
	//普通宽变长
	sysuse educ99gdp.dta, clear
	gather public private
	
	//宽变长：把聚合变量重命名
	sysuse educ99gdp.dta, clear
	gather public private, variable(sector) value(gdp)
	
	//长变宽
	sysuse educ99gdp.dta, clear
	gather public private, variable(sector) value(gdp)
	//反向操作,长变宽
	spread  sector gdp 

*****导出数据*****
1、导出数据文件
	save name.dta,replace

2、导出分析结果
	实证结果完整性输出docx.do
	reg2docx ols_no_iq ols_with_iq tsls liml gmm igmm using e:\temp\iv.docx,append /// append同一个word下追加结果，replace新建word替换
	scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("IV results") /// scalars表示输出ereturn list中的一些值 N r2_a r2_p,title表头，mtitles列标题
	mtitles("OLS" "OLS IQ" "TSLS" "LIML" "GMM" "IGMM") note("(* 0.1 ** 0.05 *** 0.01)") //note表格备注内容

*****文件转码*****

1、源文件转码
	clear                                //转码前要clear内存，是对文件夹下的源文件直接转码，此时数据文件尚未读入stata
	cd E:\temp
	copy "http://vip.stock.finance.sina.com.cn/corp/go.php/vCB_AllBulletin/stockid/600900.phtml" temp.txt,replace
	insheet using temp.txt,clear         //可以看到读入后都是乱码，用一下命令直接对temp.txt转码
	clear                                //转码前先clear
	unicode encoding set gb18030
	unicode translate temp.txt,transutf8 // 直接对源文件转码操作
	unicode erasebackups,badidea         // 删除转码生成的备份文件，不是一个好主意
	insheet using temp.txt,clear         // 再次读入没有乱码
	help unicode                         //注意：运行这三个命令前，当前目录需是你欲转换文件所在目录，且内存中不能有stata数据文件，也就是转码前必须clear

2、读入stata后转码
	clear
	copy "http://vip.stock.finance.sina.com.cn/corp/go.php/vCB_AllBulletin/stockid/600900.phtml" temp.txt,replace
	insheet using temp.txt,clear           //先将数据读入stata
	replace v1 = ustrfrom(v1,"gb18030",1)  //将原本gb18030格式转为utf-8格式

3、读入时直接转码
	clear
	copy "http://vip.stock.finance.sina.com.cn/corp/go.php/vCB_AllBulletin/stockid/600900.phtml" temp.txt,replace
	import delimited using temp.txt,clear delimiter("fa.;/;'",asstring) encoding("gb18030")
	//升级版的insheet命令 stata13版本以上用import delimited替代了,默认用逗号和tab分隔。delimiter("fa.;/;'",asstring),随便制定
	//一个不存在的符号分割，读入是就不再分割了，否则将以默认的逗号或tab分割，读入很多变量。
	//用encoding指定转码方法

4、dta原数据中乱码
	help unicode -- unicode translate //查看帮助文件
	unicode analyze my.dta       //先分析查看数据中乱码的情况
	unicode encoding set gb18030 //再设置转码格式
	unicode translate my.dta     //最后再转码


*****读入后初步整理*****

1、关于标签label
*label
	cd e:\data\r15
	use hbp4,clear
 	describe
	label data "fictional blood pressure data" 			//定义数据标签,用来描述数据;
	label variable hbp "high blood pressure" 			//定义变量标签,用来描述变量;
	label define yesno 0 "no" 1 "yes" 					//定义一个值标签yesno:0表示no,1表示yes;
	label list 			 								//显示当前内存中的值标签和详细内容,此时有sexlbl和yesno两个值标签;		
	label list yesno 									//只显示yesno值标签的详细内容;
	label dir  											//显示当前内存中的值标签名称;
	label copy yesno yesnomaybe 						//复制值标签yesno,命名为yesnomaybe;
	label define yesnomaybe 2 "maybe", add 				//为值标签yesnomaybe增加一个值2表示maybe;
	label list yesnomaybe 								//显示yesnomaybe值标签的详细内容;
	label define yesnomaybe 2 "don't know", modify 		//修改yesnomaybe值标签中的2表示don't know;
	label list yesnomaybe
	list in 1/4
	label values hbp yesnomaybe 						//对变量hbp使用yesnomaybe值标签;
	list in 1/4
	label save sexlbl using mylabel  					//保存值标签sexlbl为mylabel.do文件;
	type mylabel.do 	 								//查看保存的mylabel.do文件的内容;			 
	label drop sexlbl 									//删除值标签sexlbl
	label dir 											
	do mylabel  				     					//可以直接执行mylabel.do文件修改
	label dir

*labone
	批量处理标签命令 labone 外部命令，安装help labone
	cd E:\财务金融\财务报表\资产负债表
	import excel using FS_Combas.xls,first case(lower) clear 
	labone,nrow(1 2)                //将第1 2行合并作为全部变量的标签，默认中间以空格连接
	labone A B C,nrow(3/4) nospace  //将第3 4行合并作为A B C变量的标签，中间无空格连接
	labone,nrow(5 3 4) concat(: +)  //将第5 3 4行以：和+连接后作为标签
	值标签命令:
	labellist var1 					//列出变量var1的值对应的标签 例如: 1 上海市,2 云南省

2、关于变量
	rename _all (v1 v2 v3)          //批量重命名
	rename (v1 v2 v3) (姓名 性别 身高)
	rename(v1-v3) (姓名 性别 身高)   //对v1-v3的变量批量命名
	rename _all ori= 				//所有变量前面加一个前缀ori
	rename aori* *  				//所有以aori开头的变量名去掉aori前缀
3、变量名称操作                      //ssc install findname 外部命令findname
findname命令：                           //列出所有变量名称
	findname, type(string)             //列出所有字符型变量
	edit `r(varlist)'                  //编辑列出的字符型变量
	findname, type(numeric)            //列出所有数值型变量
	order `r(varlist)'                 //将列出的数值型变量，调整为第一个变量
	order varlist,options
	options           Description
    -----------------------------------------------------------------------------------------------------
    first             move varlist to beginning of dataset; the default
    last              move varlist to end of dataset
    before(varname)   move varlist before varname
    after(varname)    move varlist after varname
    alphabetic        alphabetize varlist and move it to beginning of dataset
    sequential        alphabetize varlist keeping numbers sequential and move it to beginning of dataset
    -----------------------------------------------------------------------------------------------------
	findname, type(numeric)            //列出所有数值型变量
	summarize `r(varlist)'             //描述列出的数值型变量
	nrow                               //直接以第一行obs命名每一个变量，然后删除第一行
	findname,loc(varname)              //将所有变量名称赋值给varname变量，然后引用`varname'可对全部变量名进行操作
	rename (`varname') (var1 var2）    //批量全部重新命名

	findname,loc(varname)    
	foreach var in `varname' {         //循环操作变量
		replace `var' = log(`var')     //每一个变量取对数       
		replace `var' =. if `var' ==0  //将变量为0的值替换为缺失
	}
ds命令：
	sysuse auto,clear
	help ds
renvarlab命令:
	ssc install renvarlab
	help renvarlab
	sysuse auto,clear
	renvarlab make,lab //用标签将其命名




4、单个修改变量类型
	encode varname [if] [in] , generate(newvar) [label(name) noextend] //单个修改变量类型，将字符型varname改成数值型newvar
	                                                                   //encode将字符型变量编码成数值型变量，每个变量对应一个数字
	webuse hbp2,clear
	encode sex, generate(gender)               //将sex中的字符转为数值 生成gender变量，红色变蓝色
	list sex gender in 1/4                     //有标签的时候，sex和gender显示是一样的
	list sex gender in 1/4, nolabel            //没有标签，sex显示字符，gender显示对应的数字
	encode sex, generate(gender) label(sexlbl) //同时生成一个变量值标签
	label list sexlbl                          //显示变量值标签
	decode female,gen(sex)                     //与decode相反操作
	decode varname [if] [in] , generate(newvar) [maxlength(#)]            //数值型修改为字符型

5、批量修改变量类型
	destring price percent, gen(price2 percent2) ignore("$ ,%")           //同时修改price和percent变量为数值型
	tostring varlist , {generate(newvarlist)|replace} [tostring_options]  //同时修改变量为字符型
	destring,replace                                                      //全部变量由字符型转数值型
	sxpose,clear                                                          //字符转置 需要安装

6、变量排序
	order varlist
	order var1,first
	order var1,last

7、缺失值处理
	mvencode _all, mv(999)             //将所有缺失值替换为999，如果用replace更改了其中的缺失值，此命令将出错，可用下面第三行命令
	mvdecode _all, mv(999)             //上面的反向操作
	mvencode _all, mv(999) override
	mvdecode rep78, mv(998=. \ 999=.a)

8、获取部分数据作为案例
	dataex in 1/5                      //运行后复制代码获取前5行数据作为样本

9、变量基本操作
	keep in 1/6
	keep if 
	drop var
	keep var
	
	expand 3                             //生成2遍数据，加上原始数据重复3次，详见help expand
	expand 2 in 1/2                      //只生成前两个观测值，一共重复2次
	expand v                             //很奇怪的命令，第n个observation 重复v变量的第n个值代表的次数，详情查看help expand
	
	duplicates                           //去重命令，详见help duplicates
	duplicates report                    //报告重复情况
	duplicates examples                  //列出重复的例子
	duplicates list                      //列出所有重复的观测值
	duplicates tag, generate(dup)        //生成一个变量dup，变量值等于该观测值重复的次数，不重复则等于0
	list if dup==1                       //列出重复次数等于1的观测值
	duplicates drop                      //删除所有重复值，仅保留第一次出现的值
	duplicates drop varlist [if] [in] , force //按变量varlist去重
	
	by foreign (make):  summarize rep78  //出错，因为没有先对foreign和make排序，下面操作才正确
	sort foreign make                    //排序，才可以进行下面的操作
	sort foreign (make)                  //主要按照froeign排序
	by foreign (make): summarize rep78
	或者
	by foreign (make),sort: summarize rep78 //先按foreign排序，然后foreign内按照make排序。
	bysort foreign (make): summarize rep78  //只按foreign分组，和下面的命令一样
	bysort foreign: summarize rep78         //和下面的命令不同
	bysort foreign make: summarize rep78    //同时按foreign和make分组
*描述统计
	sysuse auto,clear
	bysort foreign: summarize rep78 
	summarize foreign
	tabulate foreign	
	tabulate foreign,summarize(rep78)      //不统计rep78变量里的缺失值
	tabulate foreign,summarize(price)
	tabulate rep78 							//有5个缺失值

	sysuse census,clear
	tabulate region           			   //频数统计
	tabulate region,summarize(pop)
	tabulate region, sort
	tabulate region, gen(reg)    		   //生成虚拟变量
10、条件语句 if
	list make price mpg gear rep78 if(mgp>22) | (price>8000 & gear<3.5) //与或非
	list make price mpg rep78 if mpg>22 & !missing(rep78)
	list make mpg if mpg<22 in 2/20
	list make mpg if mpg>25
	list make mpg if mpg>25 & mpg<30
	list make mpg if mpg>25 | mpg<10
	regress mpg weight displ if foreign==1

11、增加观测值observation
	insobs 3,after(n) before(m)

12、数据中心化和标准化
	help center
	sysuse auto,clear
	center mpg price weight 						//中心化
	sum c_mpg c_price c_weight
	center mpg price weight,prefix(s_) standardize  //标准化
	sum s_mpg s_price s_weight
	bysort rep78: center mpg price weight, replace
	center mpg, generate(mpg0)  					//中心化生成新变量mpg0

13、in : list列出一定范围内的观测数据
	sysuse auto,clear

	list price in 10
	list price in 10/20
	list price in 60/l     					//L=l:最后
	list price in 60/L 						
	list price in f/10 						//F=f：第一
	list price in F/10
	list price in 50/-1
	list price in -10/-1 					//负数表示倒数

*****数据整理*****
  
1、纵向合并                                 //批量合并dta文件
	openall                            //安装ssc install openall,可以合并所有dta文件，但是速度非常慢。用以下命令较快
	append纵向合并
	clear
	local files: dir "." file "*.dta"  //将当前路径中的所有dta文件名称 赋给局部变量files，然后用循环合并
	foreach file in `files' {
		append using "`file'"          //append实现批量纵向合并
	}
	save "深交所评级.dta", replace      //合并完成后保存

函数
	mod(x,y)                   //x除以y的余数
	split var,parse("")        //以p("")中的字符，分割变量var
	substr(var,i,j)            //截取变量var中，自i至j位置的字符
	subinstr(v, "<td>", "", .) //将v中所有的<td>替换为空

cnstock          //获取中国股票代码 
	sample 10        //抽取10%的样本
	sample 10,count  //抽取10个样本

描述统计                
	sum
	tabstat 

*****merge合并数据*****
	merge     //横向合并
 ***1:1的情形:
	cd e:\data\r15
	use autosize,clear
	list
	use autoexpense,clear
	list

	use autosize,clear
	merge 1:1 make using autoexpense
	use autosize,clear
	merge 1:1 make using autoexpense,keep(match) nogen //仅保留matched结果,不生成_merge变量
 ***m:1的情形:
	use dollars,clear
	list
	use sforce,clear
	list

	use sforce,clear
	merge m:1 region using dollars
 ***
 	use overlap1,clear
 	list,sepby(id)
 	use overlap2,clear
 	list

 	use overlap1,clear
 	merge m:1 id using overlap2
 	list
 	merge m:1 id using overlap2,update
 	list
	merge m:1 id using overlap2,update replace
 	list 
	merge 1:1 _n using overlap2

	append    //纵向合并
相关系数
	corr
	pwcorr
	pwcorr_a 
回归
	predict yhat,xb    //生成y估计值
	predict e,residual //生成残差
	reg y x1 x2,robust //文件标准误
	estat vif          //计算方差膨胀因子
	stepwise reg       //逐步回归 sw reg代替
 
*****正则表达式*****
基本字符:
	.     			//匹配所有字符
	\.  			//转义字符,匹配"."
	[a-z]			//匹配所有小写字母
	[^a-z]  		//匹配所有非小写字母
	"AB*"   		//匹配A和任意个B(包括0)
	"AB+"   		//匹配A和至少一个B
	"AB?"   		//匹配A和0或者1个B
	"AB{3}"   		//匹配到A和3个B
	"AB{1,3}"   	//匹配到A和1-3个B
	"AB{3,}"   		//匹配到A和大于3个B
	"a"				//匹配到a字符
	"^a"			//匹配到a开始的字符
	"a$" 			//匹配到a结尾的字符


	replace v =subinstr(v,"")直接替换麻烦，可以用正则表达式替换的好处
	//分开来记 ustr reg ex r a    ustr  regular expression replace all
	replace v =ustrregexra(v,"<table>.*?</table>","")        //删除表格，<table> </table>之间的内容表示一个表格
	replace v =ustrregexra(v,"<.*?>","")                     //   .匹配任意字符， *表示它前面一个字符重复任意次或空，?表示只匹配一次，否则是贪婪匹配，
	                                                         //"<.*?>"放在一起表示匹配任意的尖括号
	replace v =ustrregexra(v,"\s","")                        //  \s匹配任意空白字符
	replace v =ustrregexra(v,"\r|\n","")                     //删除回车符和换行符，.匹配不了回车符和换行符，所以要单独匹配并删除

	clear
	set obs 1
	gen result="blue|glue"
	gen result2=ustrregexs(1) if ustrregexm(result,"|(.*)")  //
	gen result3=ustrregexs(1) if ustrregexm(result,"\|(.*)") //若想识别出"|",必须前面加转义符"\"
	list
	ustrregexm(s,re[,noc])                                   //在s中匹配re，如果能匹配到返回1，否则返回0，noc为零或缺省，为精准匹配，为其它数值，模糊匹配，可忽略大小写
	disp ustrregexm("12345", "([0-9]){5}") = 1
	disp ustrregexm("de TRÈS près", "rès") = 1
	disp ustrregexm("de TRÈS près", "Rès") = 0               //缺省noc或为0表示精准匹配
	disp ustrregexm("de TRÈS près", "Rès", 1) = 1            //模糊匹配，忽略了大小写
案例
	clear
	input str10 income 
	"abc"
	"aB"
	"aa"
	"abcd"
	"Aad"
	"a1"
	"aab123"
	"cdf12345"
	"123"
	end
	gen index1 = ustrregexm(income, "[[:lower:]]") //存在小写字母，返回1，否则返回0
	gen index2 = ustrregexm(income, "[[:upper:]]") //存在大写字母，返回1，否则返回0
	gen index3 = ustrregexm(income, "[[:digit:]]") //存在数字，返回1，否则返回0

	ustrregexs(n)                                  //n=0 返回ustrregexm(s,re[,noc])中re匹配到的全部内容，n=1返回ustrregexm(s,re[,noc])中re第一块匹配到的内容

	clear
	input strL report_text
	"indication I want this 1 view"
	"indication I want this 2 views"
	"indications I want this 3 view"
	"indications I want this 4 views"
	"history I want this 5 view"
	"history I want this 6 views"
	"xxx I dont want this yyy"
	"indication I dont want this either yyy"
	"xxx nor this view"
	end
	gen indication0=ustrregexs(0) if ustrregexm(lower(report_text),"^(indications|indication|history)(.*)(views|view)$") //
	gen indication1=ustrregexs(1) if ustrregexm(lower(report_text),"^(indications|indication|history)(.*)(views|view)$")
	gen indication2=ustrregexs(2) if ustrregexm(lower(report_text),"^(indications|indication|history)(.*)(views|view)$")
	gen indication3=ustrregexs(3) if ustrregexm(lower(report_text),"^(indications|indication|history)(.*)(views|view)$")
	list
	/* ustrregexm(lower(report_text),"^(indications|indication|history)(.*)(views|view)$")中的正则表达式
	^(indications|indication|history)(.*)(views|view)$可以分为三个子块儿，
	n=0时表示返回匹配到的全部字符串；
	n=1表示返回第1个正则表达式子块儿对应的字符串。
	*/

*****反爬虫*****
	时间戳
	案例：百度新闻高级搜索应用
	https://news.baidu.com/ns?from=news&cl=2&bt=1546272000&y0=2019&m0=1&d0=1&y1=2019&m1=5&d1=4&et=1556985599&q1=%D6%D0%B9%FA%D2%F8%D0%D0&submit=%B0%D9%B6%C8%D2%BB%CF%C2&q3=&q4=&mt=0&lm=&s=2&begin_date=2019-1-1&end_date=2019-5-4&tn=newstitledy&ct=0&rn=20&q6=
	此网址中bt对应的是起始时间戳，et对应的是结束时间戳
	tc(1 jan 2016 00:00:00)                                       //函数返回括号内时间距1960-01-01 00:00:00.00 的毫秒数
	时间戳是距离 1970-01-01 00:00:00 的秒数
	使用tc函数得到一个时间的时间戳
	bt = (tc(1 Jan 2016 00:00:00)-tc(1 Jan 1970 08:00:00))/1000  //起始于2016年1月1日 0时0分0秒的时间戳
	et = (tc(31 Dec 2016 23:59:59)-tc(1 Jan 1970 08:00:00))/1000 //结束于2016年12月31日 0时0分0秒时间戳

	/*
	深交所网站
	查看网页源代码，看不到我们需要的信息 
	F12 network 排除 png js css gif 等格式
	最后一个文件，然后点击下一页 ，最后一项就是data我们要的数据
	右键copy link address
	尝试删除无规则网址后缀能否打开网站
	之前讲的都是get请求方式
	http://vip.stock.finance.sina.com.cn/corp/go.php/vCI_CorpManager/stockid/600900.phtml

	不同于post请求方式，链接地址总是不变
	year:2017
	season:2
	安装curl文件
	bin文件夹下的三个文件复制到system32文件夹中 !打开CMD后输入curl出现for help信息代表安装成功

	http://stock.finance.sina.com.cn/hkstock/history/00001.html
	*/
	!curl "http://stock.finance.sina.com.cn/hkstock/history/00001.html",--data "year=2017&season=3" -o temp.txt

*****log文档,记录工作日志*****	 
	*-log file开始与结束	

	cd E:\stata\results
	log using 国庆培训.log, text replace // log_-begin-__    

	use "E:\stata\data\FDI.dta", clear
	xtset var1 year
	cd E:\stata\results
	xtreg lngdp lnfdi lnie lnex lnim  lnci lngp,re
	est store re
	xtreg lngdp lnfdi lnie lnex lnim  lnci lngp,fe
	est store fe
	hausman fe re
	est table re fe, b(%6.3f) star(0.1 0.05 0.01) 
	outreg2 [fe re] using 晚安.doc,stats(coef,tstat) addstat(Ajusted R2,`e(r2_a)') replace 	

	log close                          // log_-over-
	logout, save(c:\tables\logout_means) excel replace

	shellout 国庆培训.log

	translate 国庆培训.log 国庆培训.pdf,translator(log2pdf)     
	shellout 国庆培训.pdf

	*-shellout为外部命令需要下载安装


*****greshape*****
	ssc install gtools       //参考网址https://gtools.readthedocs.io/en/latest/index.html
	cd E:\Codelearning\Stata //greshape操作
	use reshape.dta,clear
	rename (inc80r-inc82r) (var90 var91 var92)
	drop ue82
	rename (ue80 ue81) (ue90 ue91)
	list
	//wide to long 宽边长
	greshape long var ue, by(id) keys(nian)
	greshape long var@ ue, by(id) keys(nian)
	greshape long var ue@, by(id) keys(nian)
	greshape long var[nian] ue, by(id) keys(nian) match([nian])
	//long to wide 长变宽
	greshape wide var[nian] ue, by(id) keys(nian) match([nian])

	use huojiang.dta,clear
	greshape long y ,by(province) keys(year) //宽变长
	greshape wide y ,by(province) keys(year) //长变宽

*****graph twoway*****
	cd e:\data
	use http://www.stata-press.com/data/r15/uslifeexp2,clear
	save uslifeexp2.dta,replace
	use uslifeexp2.dta,clear
	twoway scatter le year  //散点图
	twoway line le year 	//折线图
	twoway connected le year //散点连线图
	twoway (scatter le year) (lfit le year) //散点图和线性拟合图
	sysuse auto.dta,clear
	twoway (scatter mpg weight if foreign, msymbol(O)) ///
	(scatter mpg weight if !foreign, msymbol(Oh)) if mpg>20

*****stata命令结果的保存***
	sysuse auto,clear
	factor price mpg weight length turn displacement gear_ratio,factors(3)
	return list   //r族结果保存
	ereturn list  //e族结果保存

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
	
***preserve和restore,起死回生术
	cd E:\财务金融\CSSCI	
	infix strL var 1-200 using C刊目录源数据.txt, clear
	drop if var=="期刊名称"
	drop if var=="主办（管）单位"
	drop if var=="CN号"
	drop if var==""
	drop if regexm(var,"（[0-9]+种）")
	gen id = (mod(_n,3)==1)
	replace id = sum(id)

	preserve //preserve要和下面的restore之间的代码同时运行，代码完成后，数据依然不变，本来数据经过代码运行已经发生了变化；
	keep if mod(_n,3)==1
	rename var journal
	sort id
	save 期刊名称,replace
	restore

	preserve //再次使用提取主办单位名称数据保存，而不改变原数据
	keep if mod(_n,3)==2
	rename var publisher
	sort id
	save 主办单位,replace
	restore

	preserve 
	keep if mod(_n,3)==0
	rename var CN
	sort id
	save CN号,replace
	restore 
	//上面三次使用preserve和restore，分别提取了期刊名称、主办单位和CN号等信息并分别保存位dta文件
	//下面将上面三个dta文件合并
	use 期刊名称,clear
	sort id
	merge 1:1 id using 主办单位
	drop _m 

	sort id
	merge 1:1 id using CN号
	drop _m
	drop id
	save CSSCI, replace

***运算符 operator***
	                                                  Relational
         Arithmetic              Logical            (numeric and string)
    --------------------     ------------------     ---------------------
     +   addition                &   and               >   greater than
     -   subtraction             |   or                <   less than
     *   multiplication          !   not               >=  > or equal
     /   division                ~   not               <=  < or equal
     ^   power                                         ==  equal
     -   negation                                      !=  not equal
     +   string concatenation                          ~=  not equal

***if循环***
	program power 				//定义power函数,有两个参数(var,n),运行结果:生成一个变量z=var^n;
	if `2'>0 { 					//`1' `2'表示函数的两个参数
	generate z=`1'^`2'
	label variable z "`1'^`2'"
	}
	else if `2'==0 {
	generate z=log(`1')
	label variable z "log(`1')"
	}
	else {
	generate z=-(`1'^(`2'))
	label variable z "-`1'^(`2')"
	}
	end

	power age 2 //生成一个变量z=age^2 

	set obs 100
	gen age = 2*_n+1

***egen***
	cd E:\data\r15
	use egenxmpl.dta,clear
	egen avg = mean(cholesterol) //产生avg变量等于括号内变量的均值
	gen devidation = cholesterol-avg

	use egenxmpl2,clear
	by dcode,sort:egen medstay = median(los) //以dcode分组,产生每组内los的中位数
	bysort dcode:egen medstay1 = median(los) //和上面的命令一样,需要sort才能执行
 *整列求和,累计求和
	clear
	set obs 10
	gen a = _n
	gen sum1 = sum(a)    				//对变量a累计求和生成sum1变量
	egen sum2 = total(a) 				//对变量a的所有值求和,生成变量sum2
	egen sum3 = sum(a) 	 				//对变量a的所有值求和,生成变量sum3,区分sum和total函数
	egen mod1 = mode(a)  				//mode计算众数,默认a如果缺失也返回众数
	egen mod2 = mode(a) if !missing(a)  //如果a缺失,对应众数也缺失
	egen mod3 = mode(a) if a < .
	egen mod4 = mode(a) if a != .
 *生成序列的方法;fill range seq
	clear 
	set obs 12
	egen a = fill(1 2)     		//obs=12,生成1 2 3 4...12
	egen b = fill(100 99)  		//生成100 99 98...89
	egen c = fill(22 17)   		//生成等差数列
	egen d = fill(1 1 2 2) 		//生成1 1 2 2 3 3 4 4 ...6 6 
	egen e = fill(7 7 7 8 8 8)  //生成777888999
	egen f = fill(0 0 1 0 0 1)
	egen g = _n
	range h 1 _N  				//1到N的序列
	egen i = seq(),b(2)         //每两个一循环的序列
	egen j = seq(),t(6) 		//序列最大值只能到6,然后循环
	egen k = seq(),f(1) t(10)   //序列1到10,然后循环
	gen l = 1+int((_n-1)/2)  	//取整,每2个值一样,逐步增加
	gen m = 1+mod((_n-1),3) 	//求余数,每3个一循环
 *判断变量之间的差异
	use egenxmpl3,clear
	egen byte differ = diff(inc*) //判断inc1,inc2和inc3之间是否存在差异,是返回1,否则返回0
 *排序,根据变量大小生成序号
	use auto,clear
	keep in 1/10
	keep mpg
	egen r = rank(mpg) 		 	//生成mpg每个值得序号,第几,由小到大
	egen r_r = rank(-mpg) 	 	//mpg倒序的序号,倒数第几
	egen r_f = rank(mpg),field 	//生成和位置对应的序号,第几(几和位置有关)大,存在并列情况
	egen r_t = rank(mpg),track 	//和field相反,倒序
	egen r_u = rank(mpg),unique //生成由小到大的序号,不存在并列情况
 *标准化
 	use states1,clear
 	egen stdage = std(age) 				  //age变量标准化
 	summarize age stdage    			  //age标准化以后均值为0,方差为1
 	correlate age stdage 				  //age标准化以后和原变量依然完全相关,相关系数为1
 	egen newage = std(age),mean(2) std(4) //指定标准化的均值和方差,默认为0和1
 	summarize age newage
 *行操作
 	use egenxmpl4,clear
 	egen hsum = rowtotal(a b c)  			//a b c三个变量对应的三列数据横向求和
 	egen sum = sum(hsum) 		 			//hsum变量的全部求和
 	gen  vsum = sum(hsum)  		 			//hsum变量累计求和
 	egen avg = rowmean(a b c) 	 			//a b c三个变量对应的三列数据横向求均值
 	egen median = rowmedian(a b c)  	    //a b c三个变量对应的三列数据横向中位数
 	egen pct25 = rowpctile(a b c),p(25) 	//a b c三个变量对应的三列数据横向25%分为数
 	egen std = rowsd(a b c) 				//a b c三个变量对应的三列数据横向标准差
 	egen n = rownonmiss(a b c) 				//a b c三个变量对应的三列数据横向非缺失值个数
 	egen exclude = rowmiss(a b c) 			//a b c三个变量对应的三列数据横向缺失值个数
 	rowmax() 最大值
 	rowmin() 最小值
 	rowfirst()第一个值
 	rowlast() 第二个值
 *判断变量是否存在某些值 anyvalue anymatch anycount并返回值
 	use auto,clear
 	egen hirep = anyvalue(rep78),v(3/5)  		//生成hirep变量,返回rep78=3,4,5对应的值,其余缺省;
 	egen irep  = anymatch(rep78),v(3/5) 		//如果rep78=3 4 5,返回1,否则返回0;
 	egen crep1  = anycount(rep78 trunk),v(3/5)  //如果rep78和trunk都同时含有3 4 5,则返回2,如果只有一个变量,返回值和anymatch是一样的
 *group()分组函数
 	use egenxmpl6,clear 
 	egen racesex = group(race sex)  		//根据race和sex的取值组合生成分组变量,缺失值分为缺失组	
 	egen racesex1 = group(race sex),missing //根据race和sex的取值组合生成分组变量,缺失值也参与分为新的组	
***补齐位数***
	clear
	input str2 month
	1
	2
	3
	4
	5
	6
	7
	8
	9
	10
	11
	12
	end
	gen str6 month2 = month //转换为字符型
	replace month2 = "00000" + month if length(month) == 1
	replace month2 = "0000" + month if length(month) == 2
	destring month2,replace //还可以还原为数值型
***面板数据***
	tsset 										//显示当前数据个体和时间设置格式
	tsset,clear  								//清除时间序列或者面板设置
	tsset tvar									//设置tvar为时间序列变量
	tsset tvar, weekly							//每1周为间隔的时间序列
	tsset tvar, weekly delta(2) 				//每2周为间隔的时间序列
	tsset pvar tvar 							//面板数据声明
	tsset pvar tvar, daily  					//每日间隔的面板数据
	tsset pvar tvar, daily delta(3 days) 		//每3日间隔的面板数据
	 //声明了时间序列或面板数据以后才可以使用下面的运算符:
***时间序列运算符***
	Operator Meaning
	L. lag xt-1
	L2. 2-period lag xt-2
	: : :
	F. lead xt+1
	F2. 2-period lead xt+2
	: : :
	D. difference xt - xt-1
	D2. difference of difference xt - xt-1 - (xt-1 - xt-2) = xt - 2xt-1 + xt-2
	: : :
	S. “seasonal” difference xt - xt-1
	S2. lag-2 (seasonal) difference xt - xt-2
***面板数据的特殊处理***
 
 **1.tsappend后面追加的方法:
	tsappend,add(10)
	tsappend,last(1993m3) tsfmt(tm)
	tsappend,add(2) panel(333)
 *案例:时间序列增加日期
 	cd e:\data\r15
 	use tsappend1,clear  					//时间序列数据
 	reg y l.y
 	ereturn list
 	matrix b = e(b) 						//将系数矩阵赋值给b
 	matrix list b 							//显示矩阵b
 	matrix colnames b = L.xb one 			//矩阵b的列命名为L.xb和one
 	*方法1:
 	tsappend,add(12) 						//增加12期
 	tsset
 	predict xb if t2<=tm(2000m2)
 	gen one = 1
 	matrix score xb = b if t2>=tm(2000m2),replace
	line y xb t2 if t2>=tm(1995m1),ytitle("") xtitle("time")
	*方法2:
	tsappend,last(2001m1) tsfmt(tm) 		//以月为单位增加至2001年1月
 *案例:面板数据增加日期
 	*方法1:
 	use tsappend3,clear
 	xtdescribe 								//描述面板数据信息
 	tsappend,add(6) 						//每个个体的时间都向后增加了6期,如果增加前结束日期不一致,增加后依然不一致;
 	*方法2:
 	use tsappend2,clear
 	tsappend,last(2000m7) tsfmt(tm) 		//每个个体的结束日期统一增加至2000m7
 
 **2.tsfill填充的方法:
 	tsfill
 	tsfill,full
 *时间数据案例:tsfill只补齐中间间断的日期,不增加日期
 	use tsfillxmpl,clear 					//时间序列数据
 	tsfill 									//补上时间序列中间间断的数据,不增加日期数据
 	ipolate income mdate,gen(ipinc) 		//插值法补齐中间缺失的数据



 *面板数据案例:tsfill,full补齐中间间断的日期,同时增加日期以补齐个体跨度不统一的日期
 	use tsfillxmpl2,clear
 	tsfill 									//只补齐每个个体中间间断的日期数据
 	tsfill,full 							//会增加日期以统一每个个体的日期跨度

 **面板数据出现重复的处理办法:
 *方法1:tssmooth ma
 	cd e:\data
 	clear
 	input ID year var1 var2 var3
 	1 2006 34 45 65
 	1 2007 45 43 41
 	1 2007 3 56 59
 	1 2008 39 54 76
 	1 2009 41 57 68
 	end
 	save panelexmp.dta,replace
 	drop if year == 2007 				//删除掉重复的年份
 	tsset ID year 						
 	tsfill 								//填充删除的间断的年份,数值是缺失的,下面插值法填充
 	forvalues i =1/3{
 		tssmooth ma v`i' = var`i',w(1,0,1)
 		replace var`i' = v`i' if var`i' ==.
 	}
 	drop v?
 		//tssmooth ma移动平均插值法
 *方法2:duplicates tag
 	duplicates tag ID year,gen(mistake) //重复值用mistake变量标识出来
 	bysort ID year:keep if (_n == 1) 	//同一个ID和year下只保留第一个obs
 	foreach v of varlist var1 var2 var3{
 		replace `v' = (`v'[_n-1]+`v'[_n+1])/2 if mistake
 	}

***模拟生成数据***
	clear
	set obs 1000
	gen theta = _n*2*_pi/360
	gen r = sin(theta)*cos(theta)
	gen y = r*sin(theta)
	gen x = r*cos(theta)
	line y x

	clear
	set obs 1000
	gen theta = _n*2*_pi/360
	gen r = 4*cos(theta/3)^3
	gen y = r*sin(theta)
	gen x = r*cos(theta)
	line y x

	clear
	set obs 1000
	gen theta = _n*2*_pi/360
	gen r = theta
	gen y = r*sin(theta)
	gen x = r*cos(theta)
	line y x

	clear
	set obs 1000
	gen theta = runiform()*2*_pi
	sort theta
	gen y = sin(theta)
	line y theta

	clear
	set obs 1000
	gen theta = 2*_pi*_n/1000
	gen y = cos(theta)
	line y theta

***display: 参见:http://blog.sina.com.cn/s/blog_d200979d0102wfpt.html
*-1.3.1列印文字
	disp 3 + 5*7 + sqrt(20)  				//disp的计算器功能;
	disp in g sin(_pi*0.5)+cos(0.9) 		//以green绿色显示计算结果;
	di _n(2) _dup(3) "I Love This GAME! " //_n(2)空两行,_dup(3)重复三次
	display "This is a pretty girl!"
	dis `"This is a "pretty" girl!"'
*-1.3.2 列印的颜色
* 颜色1：red green yellow white
	dis in green "I like stata!"
	dis in w     "This " in y "is " in g "a " in red "pretty" in g " girl" //分别以不同颜色显示不同单词;
* 颜色2：as text(绿色)| as result(黄色)| as error(红色)| as input(白色)
	dis as result "Stata is Good !"
*-1.3.3 列印的位置
*   副命令  |             定义                   
*   _col(#) | 从第 # 格开始列印
*   _s(#)   | 跳过 # 格开始列印
*   _n(#)   | 从第 # 行开始列印
*   _c      | 下次列印接着列印而无须从起一行
*   _dup(#) | 重复列印 # 次
	display "Stata is good"
	display _col(12) "Stata is good"
	display "Stata is good" _s(8) "I like Stata"
	display _dup(3) "Stata is good！ "
	display "Stata is good","I like it"
	display "Stata is good",,"I like it"
	display _n(3) "Stata is good"

***smcl更精美的列印方式:
	help smcl        //stata markup and control language
	disp "you can output {it:italics} using SMCL"
	disp "this is SMCL"
	disp "{title:this is SMCL,too}"
	disp "now we will try {help summarize:clicking}"  			//点击显示summarize的帮助文件;

	sysuse auto,clear
	disp "now we will try {stata summarize mpg:clicking}" 		//点击显示mpg的描述统计;
	disp "now we will try {stata reg price mpg:clicking}"		//点击显示reg回归的结果;
**help text:Text in graphs		第718页,各种特殊字符代码			//设置图片中的文字格式;
	scatter mpg weight, title("This is {it:italics} in a graph title")
	scatter mpg weight, caption("{bf:Source}: {it:Consumer Reports}, used with permission") 			//bf黑体,it斜体;
	twoway function y = 2*exp(-2*x), range(0 2) title("{&function}(x)=2e{superscript:-2x}") 			//上下标;
	scatter mpg weight, title("Here are {stSerif:serif},{stSans:sans serif}, and {stMono:monospace}") 	//stSerif,stSans和stMono不同的字体;
	scatter mpg weight, title(`"Text in {fontface "Century Schoolbook":a different font}"') 			//调用操作系统字体 Century Schooolbook;
	twoway function y = gammaden(1.5,2,0,x), range(0 10) title("{&chi}{sup:2}(3) distribution") 		//自由度为3的卡方分布,{&chi} 希腊字符;
		//{&Alpha} {&Beta}大写,{&alpha} {&beta}小写. 

***日期函数:
	disp "`c(current_date)'"
	disp "`c(current_time)'"
	disp date("2019-5-2","YMD") //返回距离1960-1-1的天数
	disp %dCY-N-D date("2019-5-2","YMD") //根据date的天数返回日期值按%dCY-N-D格式
	disp %dCY-N-D mdy(1,1,2014)+5
	
	local date:disp %dCY-N-D mdy(1,1,2014)+5
	disp `date'

	local date:disp %dCY-N-D mdy(1,1,2014)+5
	disp "`date'"

***levelsof函数:返回一个变量的所有取值水平,储存于r(levels)中:
	levelsof(rep78)
	sysuse auto

    levelsof rep78
    display "`r(levels)'"

    levelsof rep78, miss local(mylevs)
    display "`mylevs'"

    levelsof rep78, sep(,)
    display "`r(levels)'"

***虚拟变量
	webuse grunfeld,clear
	gen province = "新疆" if company >5 & company < 8
	replace province = "河南" if company >= 8
	replace province = "浙江" if company <= 5
	*数值类型的虚拟变量,直接可以用i.进行回归:
	reg invest mvalue kstock i.year         //加入年份虚拟变量;
	reg invest mvalue kstock i.company      //此时数据中不会生成对应的虚拟变量;
	*如果虚拟变量为文本,直接加i.进行回归则报错:
	reg invest mvalue kstock i.province      //报错,此时前加xi:
	xi:reg invest mvalue kstock i.province   //此时数据中会自动生成对应的虚拟变量,并进行回归;
	//xi:相当于以下过程:
	egen province1 = group(province)         //生成对应的数值型变量;
	reg invest mvalue kstock i.province1     //再用i.直接进行回归;
	*xi:命令的作用:
	//1.文本型变量直接进行虚拟变量回归会出错,xi:会自动生成对应的虚拟变量并进行回归;
	//2.在数据中生成对应的虚拟变量,以"_I"开头;
	//3.xi:生成虚拟变量的原则:
		//默认放弃最普遍的类型,剩下的类型生成虚拟变量;
		char _dta[omit] prevalent 
		//设置放弃的变量取值,剩下的值生成虚拟变量;
		char agegrp[omit] 3
		//通用设置语法:
		char varname[omit] string-literal
	//以上面为例:
	tabulate province //可以看到新疆有40个数据,最少
	//默认:忽略新疆,河南和浙江生成两个虚拟变量;
	char province[omit] //等价于:
	char province[omit] "新疆"
	//手动设置忽略河南,而新疆和浙江生成两个虚拟变量
	char province[omit] "河南"
	xi:reg invest mvalue kstock i.province
	*xi命令设置交互项,x数值型连续变量,d分类变量:
	xi:reg y i.d1*i.d2 //D1,D2和D1*D2都是自变量进行了回归,等价于:
	xi:reg y i.d1 i.d2 i.d1*i.d2
	xi:reg y i.d1*x1  //d1,x和i.d1*x都参与了回归;
	xi:reg y i.d1|x1  //d1没有参与回归,x和交互项i.d1*x参与了回归;

***help ivreg2


***help weight


***help prefix


***help uniform

cd "/users/zhulu/files/data"
sysuse auto,clear
reg price mpg
estimates store m1
reg price weight
estimates store m2
reg2docx m1 m2 using regresult.docx

***post命令
tempname sim 			//临时生成一个sim文件；
postfile `sim' mean var using results, replace //将mean，var名称post到sim，然后使用results保存最终结果；
forvalues i = 1/100 {
	drop _all
	set obs 110
	generate z = exp(rnormal())
	summarize z
	post `sim' (r(mean)) (r(Var)) //将返回结果r(mean)和r(var)post到sim；
	}
postclose `sim'
use results,clear

***xtile
 // 根据指定的百分位数定义类别变量，例如把25%定义为1,50%定义为2等等。
***ptile

***astile
//astile比 state 官方提供的xtile命令处理速度更快。 它的高效性在数据集较大或者当分组类别被多次创建时更加明显，比如说，我们可能需要根据每个年份或者月份分别创建分组。




