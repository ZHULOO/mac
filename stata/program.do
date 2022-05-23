***** 格式：
capture program drop hello
program hello
	display "hi there"
end

*****宏*****
***局部宏：`'
sysuse auto,clear
local vars "price mpg weight"
local cmd "summarize"
`cmd' `vars' //相当于执行：summarize price mpg weight;

local one 2+2
disp `one' // 4

local one1 "2+2"
disp `one1' // 4 

local one1 "2+2"
disp "`one1'" // 2+2

local two = 2+2
disp `two'

local res = substr("this",1,2) + "at"
disp "`res'"

local res = substr("this",1,2) + "at"
disp `res'  //会报错，因为将res = that看作变量，that没有内容，而复合双引号是将res作为字符串that输出；

local a "example"
local b = "example"
disp "`a'" 
disp `b'

***全局宏:$
global vars "price mpg"
summarize $vars //可以和局部宏同名，引用方式不同可以区别开来

***** 双引号
if "`answ'" == "yes" {    //局部宏`answ'的内容当做字符串；
: : :
}
else {
: : :
}
***区别于：
if "yes" == "yes"     //判断两个字符串是否相同；
if yes == "yes"		  //当yes变量等于“yes”时；

***下面两种形式双引号的区别：
* 内层宏引号，将宏内容作为字符串处理：
regress lnwage age ed if sex == "`x'"
generate outa = outcome if drug == "`firstdrug'"
use "`filename'"
* 下面是复合双引号(`"  "')效果等同于双引号：(" ")，但是当字符串本身就包含双引号时，可以很好的加以区分；
regress lnwage age educ if sex==`"female"'
generate outa = outcome if drug==`"A"'
use `"person file"'
* 不错的用法
local a `"example"'
if `"`answ'"' == `"yes"' {	//`"example"'和`"yes"'复合双引号作为一般双引号使用，但`"`answ'"'就是一个很好的用法了，如果 answ = "I "think" so"本身就包含双引号，外层双引号使用`" "'的复合双引号就可以避免混淆；
: : :
}

***区别
disp `"I `"think"' so"'
disp "A"B"C"
disp `"A`"B"'C"'
disp `"A"'B`"C"'

***循环递加
local ++i
local --i

local i = 0
while (`++i' < 10) {	//++i和i++的区别：先叠加再判断，先判断再叠加
	disp `i'
}

local i = 0
while (`i++' < 10) {
	disp `i'
}

***宏函数
local lbl : variable label myvar
local filenames : dir "." files "*.dta"	//后边命令的结果赋值给前面的局部宏
local xi : word `i' of `list'
//creturn族函数：
creturn list
local today "`c(current_date)'"
local curdir "`c(pwd)'"
local newn = c(N)+1

local curdir = c(pwd)
local curdir : pwd

***宏表达式
summarize u4
summarize u`=2+2'
summarize u`=4*(cos(0)==1)'
replace `var' = `group'[`=`j'+1']
format y `:format x'

***为定义的宏默认为空
local alpha my
local beta var
disp "`alpha'`beta'`gamma'" //gamma未定义，默认为空

***高级全局宏
//全局宏使用美元符号定义的
global i 6
global x this
disp "$x$i"

global drive "b:"  //为了得到b:myfile.dta,中间无空格时需要使用大括号；
disp "$drivemyfile.dta"   //不行，需要加大括号
disp "${drive}myfile.dta"

disp "$x"
disp "\$x"  //转义符，此时就是美元符号，而不是全局宏；

//下面加不加转义符的区别：
//不加转义符时改变baseset
global baseset "myvar thatvar"
global bigset "$baseset thisvar"
disp "$bigset"
global baseset "myvar thatvar othvar" //后面修改baseset不影响bigset内容；
disp "$bigset"
//加转义符后改变baseset：
global baseset "myvar thatvar"
global bigset "\$baseset thisvar"
disp "$bigset"
global baseset "myvar thatvar othvar" //修改baseset的内容时，上面的bigset内容也随之而修改；
disp "$bigset"

***为了区别转义符\和windows下的路径/
e:\myfile.dta   //识别为转义符，需要使用/来表示路径
e:/myfile.dta 	//stata在所有平台下使用/表示路径

***参数
reg price mpg weight

`0' ：用户输入的全部内容,即：reg price mpg weight
`1' the first argument (first word of `0')
`2' the second argument (second word of `0')
`3' the third argument (third word of `0')
: : : : : :
`*' the arguments `1', `2', `3', : : : , listed one after the other
and with one blank in between; similar to but different from `0'
because odd spacing and double quotes are removed

//例子
//定义函数xyz：求相关系数矩阵：
program xyz
	correlate `1' `2'
end

sysuse auto,clear

xyz mpg price

cap program drop listargs
program listargs
	display "The 1st argument you typed is: `1'"
	display "The 2nd argument you typed is: `2'"
	display "The 3rd argument you typed is: `3'"
	display "The 4th argument you typed is: `4'"
end

listargs this is a test
listargs "this is a test"

//一般不直接使用数字表示参数，而是使用命名，便于理解：
program progname
	args varname n oldval newval
	: : :
end

//例如生成n个(a,b)之间的数
program rng // arguments are n a b
	clear
	set obs `1'
	generate x = (_n-1)/(_N-1)*(`3'-`2')+`2'
end
//上面使用位置参数不太好理解，而下面使用命名参数就比较好理解了：
program rng
	args n a b
	clear
	set obs `n'
	generate x = (_n-1)/(_N-1)*(`b'-`a')+`a'
end

***函数参数较多时，使用循环判断参数位置：
//例如一个参数price时描述统计和两个参数时描述统计：
summarize price mpg

program : : :
	local i = 1
	while "``i''" != "" {   //`i'表示1， ``i''表示`1',第一个参数
	logic stated in terms of ``i++''
	}
end

***两种stata参数方式：位置式，语法式；
//args does the first. The first argument is assigned to macroname1, the second to macroname2,
and so on. In the program, you later refer to the contents of the macros by enclosing their names in
single quotes: `macroname1', `macroname2', : : : :
program myprog
	version 17.0
	args varname dof beta
	(the rest of the program would be coded in terms of `varname', `dof', and `beta')
	: : :
end
//syntax does the second. You specify the new command’s syntax on the syntax command; for
instance, you might code
program myprog
	version 17.0
	syntax varlist [if] [in] [, DOF(integer 50) Beta(real 1.0)]
	(the rest of the program would be coded in terms of `varlist', `if', `in', `dof', and `beta')
	: : :
end
//语法式：
Standard Stata syntax is
cmd [varlist ｜ namelist ｜ anything]
	[if]
	[in]
	[using filename]
	[= exp]
	[weight]
	[, options]

















