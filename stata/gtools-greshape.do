***footls***
ssc install ftools
//对于大数据,collapse,merge等命令会花费很长时间,例如:
set obs 1000
gen int id = ceil(runiform()*100)
gen double x = runiform()
collapse (sum) x,by(id) fast 

bysort id:replace x = sum(x)
by id:keep if _n == _N
//依靠bysort的命令:egen,merge,reshape,等会花费很多时间;
//使用hash table替换bysort;
//hash table已在pandas,julia,spark和R中;
//在stata中的使用:
mata:hash1("john",100)
85

***greshape***
*先将案例数据保存为本地，加快运行速度
cd e:\data\
webuse reshape1, clear
save reshape1.dta,replace
webuse reshape2, clear
save reshape2.dta,replace
webuse reshape3, clear
save reshape3.dta,replace
webuse reshape4, clear
save reshape4.dta,replace
webuse reshape5, clear
save reshape5.dta,replace

use reshape1, clear
list
greshape long inc ue, i(id) j(year) //用inc变量和ue变量中共有的年份信息80、81、82（数值型）生成year变量，此处的，由宽变长；
list, sepby(id)
greshape wide inc ue, i(id) j(year) //和上面的操作相反，由长变宽；
//更清晰的是用下面的by和keys的方式：

use reshape1, clear //共有信息是数值型80 81 82
list
greshape long inc ue, by(id) keys(year) //和上面的操作命令一样，使用by和keys的方式，更加清晰好懂；
list, sepby(id)
greshape wide inc ue, by(id) keys(year)
//此时，string选项不是必须的，看下面的需要加上string选项：

use reshape4, clear //共有信息是字符型f m 
list
greshape long inc, by(id) keys(sex) string //从incf和incm变量中提取f、m（字符型）信息生成性别变量（string），此处string是必须的选项；
list, sepby(id)
greshape wide inc, by(id) keys(sex)

use reshape5, clear
list
greshape wide inc, by(hid) keys(year sex) cols(_) //year sex和inc三个变量合成一个，由长变宽。
l
Complex stub matches
@ syntax is supported and can be modified via match() //可以用@复杂匹配

use reshape3, clear
list
greshape long inc@r ue, by(id) keys(year) //用inc和r字符中间的80 81 82生成年份变量
list, sepby(id)
greshape wide inc@r ue, by(id) keys(year) //年份信息80 81 82还原到inc和r字符之间
list

use reshape3, clear
list
greshape long inc[year]r ue, by(id) keys(year) match([year]) //[]的方式用inc和r字符中间的信息生成year变量
list, sepby(id)
greshape wide inc[year]r ue, by(id) keys(year) match([year])
list
	Note that stata variable syntax is only supported for long to wide, //stata变量语法的形式只适用于由长变宽
	and cannot be combined with @ syntax. For complex pattern matching from wide to long, //由宽变长的时候可以使用正则表达式
	use match(regex) or match(ustrregex). With regex, the first group is taken to be the group 
	to match (this can be modified via /#, e.g. r(e)g(e)x/2 matches the 2nd group). With ustrregex, 
	every part of the match outside lookarounds is matched (e.g. (?<=(foo|bar)[0-9]{0,2}stub)([0-9]+)(?=alice|bob) matches ([0-9]+)).

use reshape3, clear
greshape long inc([0-9]+).+ (ue)(.+)/2, by(id) keys(year) match(regex)
greshape wide inc@r u?, by(id) keys(year)
	Note for ustrregex (Stata 14+ only), Stata does not support matches of indeterminate length inside
	lookarounds (this is a limitation that is not uncommon across several regex implementations).

Gather and Spread
use reshape1, clear
greshape gather inc* ue*, values(var3) keys(sector)
greshape spread var3, keys(sector) //抛出错误
//tidy的方法正常：
gather inc* ue*,variable(sector) value(var3)
spread sector var3

//tidy命令中的gather用法，对比greshape下的gather用法：
sysuse educ99gdp.dta, clear
gather public private, variable(sector) value(gdp)
spread  sector gdp

greshape gather public private,values(gdp) keys(sector)
greshape spread gdp,keys(sector) //依然出错，还原不了。
