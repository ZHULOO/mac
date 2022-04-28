***宏与循环操作:
	help macro
	help quotes
*1.local
	clear 
	set obs 100
	gen oldvar = _n
	gen oldvar1 =  _n*2+1
	
	local var1 oldvar oldvar1
	disp `var1'   				//显示结果:13;

	local var1 oldvar oldvar1
	disp "`var1'" 				//显示结果:oldvar oldvar1,此处表示对var1局部宏内容的引用;

	local var1 oldvar oldvar1
	disp `"var1"' 				//显示结果:var1,先加了引号,此时var1不是一个局部宏,而是一个字符;

	local var1 "oldvar oldvar1"
	disp `var1'   				//显示结果:13;
	
	local var1 "oldvar oldvar1" 
	disp "`var1'"   			//显示结果:oldvar oldvar1,此处表示对var1局部宏内容的引用;

	local var1 "oldvar oldvar1" 
	disp `"var1"' 				//显示结果:var1,先加了引号,此时var1不是一个局部宏,而是一个字符;

	local var1 oldvar
	disp "`var1'"

	local var1 oldvar2   
	disp `var1' 				//显示结果:出错,此时oldvar2是一个变量,未发现此变量,会报错;

	local var1 123456   		
	disp `var1'					//显示结果:123456,此时123456赋值给var1;

	local var1 "123456"   	 	//显示结果:123456,此时123456赋值给var1;	
	disp `var1'

	local one 4
	disp `one' 					//显示结果:4;
	local two=`one'+3
	disp `two' 					//显示结果:如果和上面的一起运行显示为7,单独运行显示为3;			

	local x : display %9.4f sqrt(2)
	disp `x' 					//显示结果:1.4142,计算2的平方根并按照%9.4f的格式显示出来;

*2.global
	global a "myvar" 		
	disp $a 				   //和上面的local类似,此时出错,未发现myvar变量;

	macro list 				   //列出当前内存中的全局宏;
*3.local和macro的交叉应用:
	global a "myvar"
	generate $a = oldvar       //相当于:generate myvar = oldvar
	generate a = oldvar        //generate a = oldvar
	
	local a "myvar1"
	generate `a' = oldvar      //相当于:generate myvar1 = oldvar
	generate a = oldvar        //generate a = oldvar
	
	global a "newvar"
	global i = 2
	generate $a$i = oldvar     //相当于:generate newvar2 = oldvar
	
	local a "newvar"
	local i = 3
	generate `a'`i' = oldvar   //相当于:generate newvar3 = oldvar
	
	global b1 "newvar"
	global i=1
	generate ${b$i} = oldvar   //相当于:generate newvar = oldvar
	
	local b1 "newvar4"
	local i=1
	generate `b`i'' = oldvar   //相当于:generate newvar4 = oldvar
	
	global b1 "newvar5"
	global a "b"  			   //a=b
	global i = 1
	generate ${$a$i} = oldvar  //相当于:generate newvar5 = oldvar
	
	local b1 "newvar6"
	local a "b"
	local i = 1
	generate ``a'`i'' = oldvar //相当于:generate newvar6 = oldvar

*local和global的对应关系:
	
	local name "Bill" 		 //	global _name "Bill"
	macro list _name

*案例:局部宏与文件操作
	help extended macro functions:
	local list : dir . files "*"  				//返回当前目录下("*")匹配的所有的文件;
	local list : dir . files "s*" 				//返回当前目录下("s*")匹配的以s开头的文件;
	local list : dir . dirs "*" 				//返回当前目录下的子目录;
	local list : dir . other "*" 				//返回当前目录下的所有其它文件;
	local list : dir "\mydir\data" files "*" 	//返回\mydir\data目录下("*")匹配的所有的文件;
	local list : dir "subdir" files "*" 		//返回当前目录的子目录下("*")匹配的所有文件;

*案例:
	sysuse auto,clear
	local x : type mpg 							//将mpg的type赋值给局部x; 
	display "`x'" 								//结果显示:int;
	macro list _x

	local myname : permname foreign 			//permname建议生成新的变量名
	macro list myname 							//和下面的_myname对比;
	macro list _myname 							//显示结果:_myname: foreign1;

	local aname : permname displacement, length(8)
	macro list _aname 							//将变量名缩写为长度8位的并赋值给aname显示为:_aname: displace

*对比一下三种结果:
	local var1 "what"
	disp `var1'

	local var1 "what"
	disp "`var1'"

	local var1 "what"
	macro list _var1

	constraint 1 price = weight
	constraint 2 mpg > 20
	local myname : constraint 2
	macro list _myname 							//显示结果:_myname: mpg > 20,约束2赋值给myname;
	local aname : constraint dir
	macro list _aname 							//显示结果:_aname: 2 1,内存中的约束列表赋值给aname;

	constraint 1 price = weight
	local myname : constraint 1
	macro list _myname  						//显示结果:_myname price = weight;
	local lmyname : strlen local myname
	macro list _lmyname 						//显示结果:_lmyname: 14;

***foreach循环:
	clear
	set obs 100
	gen x1=rnormal()
	gen x2=rnormal()
	gen x3=rnormal()
	gen x4=rnormal()
	gen x5=rnormal()

	foreach var in x1 x2 x3 x4 x5 { 			//只对当前几个值循环;
	disp ""
	disp ""
	disp "T-Test: the mean of variable `var' is 0:"
	ttest `var'=0 								//循环对几个变量var=0做t检验;			
	}

***forvalues循环:
	clear
	set obs 100
	gen x1=rnormal()
	gen x2=rnormal()
	gen x3=rnormal()
	gen x4=rnormal()
	gen x5=rnormal()

	forvalues i=1(1)5 {
	disp ""
	disp ""
	disp "T-Test: the mean of variable x`i' is 0:"
	ttest x`i'=0
	}

	clear
	forvalues i=65(1)90{
	display  _char(`i') _continue _skip(2)
	}

***while循环:
	local i = 1
	while `i'<=10 {
	disp `i'
	local i = `i'+1
	}

	mat A=J(5,5,.)
	local i = 1
	while `i'<=5 {
	local j = 1
	while `j'<= `i' {
	mat A[`i',`j']=`i'*`j'
	local j = `j'+1
	}
	local i = `i'+1
	}

	mat list A

***编程:
	program rng
	args n a b
	clear
	set obs `n'
	generate x = (_n-1)/(_N-1)*(`b'-`a')+`a'
	end

***几个解析函数:一般用在编程中,也可以交互使用;
**syntax:







**tokenize:解析一串字符,每一部分指定给一个局部位置宏,根据指定的分隔符;
	*一般空格:
	tokenize some words
	disp "1=|`1'|,2=|`2'|,3=|`3'|"
	*带引号:
	tokenize "some more words"
	disp "1=|`1'|,2=|`2'|,3=|`3'|,4=|`4'|"
	*外加符合引号,内加引号:
	tokenize `""Marcello Pagane""Rino Bellocco""'
	disp "1=|`1'|,2=|`2'|,3=|`3'|"
	*宏的二次引用:
	local str "A strange++string"
	tokenize `str'
	disp "1=|`1'|,2=|`2'|,3=|`3'|"
	*指定解析分隔符:
	local str "A strange++string"
	tokenize `str',parse(" +") 								//注意parse(" +")中的空格;
	disp "1=|`1'|,2=|`2'|,3=|`3'|,4=|`4'|,5=|`5'|,6=|`6'|"

**gettoken:
	gettoken emname1 [emname2] : emname3 [,parse("pchars") quotes qed(lmacname) match(lmacname) bind]
	//从3中解析"pchars"前的第一部分保存在1中,如果定义了2,则剩余的部分保存在2中;
	//parse()指定解析符;
	//quotes不剥离解析后的引号;
	//qed()
	//match()
	//bind
	local str "cat+dog mouse++horse"
	gettoken left :str
	disp `"`left'"'
	disp `"`str'"'

	local str "cat+dog mouse++horse"
	gettoken left str:str,parse(" +") //以" +"为解析符,分离出str的第一部分保存于left中,剩余的部分继续保存在str中;
	disp `"`left'"'
	disp `"`str'"'
	gettoken next str:str,parse(" +") //继续以" +"为解析符,
	disp `"`next'"'
	disp `"`str'"'

	global weird "`""some" string"' are `"within "string""'"    
	gettoken (local)left (global)right:(global)weird
	disp `"`left'"'
	disp `"$right"'
	gettoken (local)left (global)right:(global)weird,quotes //quotes不剥离解析后第一部分的引号
	disp `"`left'"'
	disp `"$right"'

	local pstr "(a (b c)) ((d e f) g h)"
	gettoken left right:pstr
	disp `"`left'"'
	disp `"`right'"'
	local pstr "(a (b c)) ((d e f) g h)"
	gettoken left right:pstr,match(parns) 					//算括号
	disp `"`left'"'
	disp `"`right'"'
	disp `"`parns'"'





**tokenget:

**tokens:

**invtokens:


