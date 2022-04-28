
Stata 函数大全

数值型函数
abs(x) 绝对值 abs(-9)=9
comb(n,k) 从n中取k个的组合 comb(10,2)=45
exp(x) 指数 exp(0)=1
fill() 自动填充数据
int(x) 取整 int(5.6) = 5, int(-5.2) = -5.
ln(x) 对数 ln(1)=0
log10(x) 以10为底的对数 log10(1000)=3
mod(x,y) = x - y*int(x/y) mod(9,2)=1
round(x) 四舍五入 round(5.6)=6
sqrt(x) 开方 sqrt(16)=4
sum(x) 求和

随机函数
uniform() 均匀分布随机数
invnormal(uniform()) 标准正态分布随机数

字符函数
real(s) 字符型转化为数值型
string(n) 数值型转化为字符型
substr(s,n1,n2) 从S的第n1个字符开始，截取n2个字符 Substr(“this”,2,2)=is
word(s,n) 返回s的第n个字符 Work(“this”,3)=i
char(n) 返回字符的ASCII码
indexnot(s1,s2) 返回s1中第一个在s2中找不到的字母的位置，若s1所有的字母在s2中均可以找到，则返回0
例如：indexnot("12disxl","2fsd1")=4 indexnot("12disxl","2fsd1ixs")=7
indexnot("12disxl","2fsd1lixs")=0
itrim(s) 将字符间多于一个空格缩减为一个空格
例如：itrim("hello there") = "hello there"
length(s) 返回字符串s的长度
例如：length("ab") = 2
lower(s) 将s中的字母变为小写
例如：lower("THIS") = "this"
ltrim(s) 将字符串s中首字母之前的空格去掉
例如：ltrim(" this") = "this"
plural(n,s) or plural(n,s1,s2)如果n！=+/-1, plural(n,s)就是将"s"加到s后。如果s2前有"+"，表示将s2加到s1后，如果s2前为"-"，则返回s1中去掉s2 字符串后剩下的字符串。如果s2前既没有"+"也没有"-",则plural(n,s1,s2)=s2.
例如：plural(1, "horse") = "horse"
plural(2, "horse") = "horses"
plural(2, "glass", "+es") = "glasses"
plural(1, "mouse", "mice") = "mouse"
plural(2, "mouse", "mice") = "mice"
plural(2, "abcdefg", "-efg") = "abcd"
proper(s) 将首字母大写，而且将紧接着非字母字符后的字母大写，其他的字母小写
例如：proper("mR. joHn a. sMitH") = "Mr. John A. Smith"
proper("jack o'reilly") = "Jack O'Reilly"
proper("2-cent's worth") = "2-Cent'S Worth"
real(s) 将s字符串转化为数字后返回，或返回“.”
例如：real("5.2")+1 = 6.2
real("hello") = .
reverse(s) 将字符串颠倒过来
例如：reverse("hello") = "olleh"
rtrim(s) 去掉字符串末尾的空格
例如：rtrim("this ") ="this".
string(n) 将数字n转化为字符串
例如： string(4)+"F" = "4F"
string(1234567) = "1234567"
string(12345678) = "1.23e+07"
string(.) = "."
string(n,s) 将数字n转化为字符串
例如：string(4,"%9.2f") = "4.00"
string(123456789,"%11.0g") = "123456789"
string(123456789,"%13.0gc" = "123,456,789"
string(0,"%td") = "01jan1960"
string(225,"%tq") = "2016q2"
string(225,"not a format") = ""
strmatch(s1,s2) s2与s1的形式相同则返回1，否则返回0
例如：strmatch("17.4","1??4")=1 在s2中？代表此处有一个字符，*表示0或更多的字符
• strpos(s1,s2) s2在s1中第一次找到的位置，否则为0
例如：strpos("this","is") = 3
strpos("this","it") = 0
subinstr(s1,s2,s3,n) 返回s1，将s1中第n次出现s2时的s2替换成s3 ，若n为”.”,则将所有s1中的s2字符串替换成s3
例如：subinstr("this is this","is","X",1) = "thX is this"
subinstr("this is this","is","X",2) = "thX X this"
subinstr("this is this","is","X",.) = "thX X thX"
substr(s,n1,n2) 返回s1的子集，从s1中第n1个字符开始抽取，抽n2个字符
例如: substr("abcdef",2,3) = "bcd"
substr("abcdef",-3,2) = "de"
substr("abcdef",2,.) = "bcdef"
substr("abcdef",-3,.) = "def"
substr("abcdef",2,0) = ""
substr("abcdef",15,2) = ""
trim(s) 将字符串s的首字母之前和末尾的空格去掉
例如：trim(" this ") ="this"
upper(s) 将字符串s中的字母变为大写
例如：upper("this") ="THIS"
word(s,n) s中第n个单词
例如：word("glass tass a td",2)=tass
word("glass tass a td",.)=.
wordcount(s) s中单词数
例如：wordcount("glass tass a td")=4

系统变量
_n 当前观察值的序号
_N 共有多少观察值
_pi π

数学函数
Abs(x) x的绝对值
Acos（x） 反余弦函数
Asin(x) 反正弦函数
Atan(x) 反正切函数
atanh(x) 反双曲正切函数
ceil(x) 返回大于或等于自变量的最小的整数。
Floor(x) 返回小于或等于自变量的最大的整数
Int(x) 返回自变量的整数部分
Round(x,y) 返回与y的单位最接近的数x，x为真数，y为近似单位
例如：round(5.2,1)= round(4.8,1)=5 round(2.234,0.1)=2.2 round(2.234,0.01)=2.23

cloglog(x) 返回ln{-ln(1-x)}的值
comb(n,k) 从n中取k个的组合，即comb(n,k)=n!/{k!(n - k)!}
例如：comb(10,5)=252 comb(6,2)=15
cos(x) 余弦函数
digamma(x) 返回digamma函数值，这是lngamma(x)的一阶导数
exp(x) 指数函数
invcloglog(x) 返回invcloglog(x) = 1 - exp{-exp(x)}的值
ln(x) 自然对数函数
lnfactorial(n) 返回N阶乘的自然对数，即lnfactorial(n)= ln(n!) ，计算n！时用round(exp(lnfactorial(n)),1)函数保证得出的结果是一个整数。求n的阶乘的对数比单纯求阶乘更有用，因为存在溢出值问题。
lngamma(x) 返回.gamma函数的自然对数
log10(x) 以10为底对数函数
logit(x) 返回logit函数值 logit(x)= ln{x/(1-x)}
max(x1,x2,...,xn) 求x1, x2, ..., xn中的最大值
min(x1,x2,...,xn) 求x1, x2, ..., xn中的最小值
例如：min(1,2,3)=3
mod(x,y) 求x除以y的余数, 即mod(x,y) = x - y*int(x/y)
reldif(x,y) 返回x，y的相对差异值，reldif(x,y)= |x-y|/(|y|+1).如果x和y都是相同类型的缺失值，则返回0；如果只有一个为缺失值或x、y为不同类型的缺失值，则返回缺失值。
sign(x) 求x的符号，如果为负数，则返回-1；如果为0，则返回0；如果为正数，则返回1；如果是缺失值，则返回缺失值
sin(x) 正弦函数
sqrt(x) 求x的平方根，x只能为非负数
例如:sqrt(100)=10
sum(x) 返回x的和，将缺失值看成是0
tan(x) 正切函数
tanh(x) 双曲正切函数
trigamma(x) 返回lngamma(x)的二阶导数
trunc(x) 将数据截为特定的长度

概率分布和密度函数
• betaden(a,b,x) 返回β分布的概率密度，a，b为参数，如果x < 0或者 x > 1，返回0
• binomial(n,k,p) n次贝努里试验，取得成功次数小于或等于k次的概率，其中一次p为事件成功的概率 若k<0 返回1 ；若k>n 返回0
• binomialtail(n,k,p) n次贝努里试验，取得成功次数大于或等于k次的概率，其中一次p为事件成功的概率 若k<0 返回1 ；若k>n 返回0
• binormal(h,k,r) 返回自由度为n的卡方的分布，chi2(n,x) = gammap(n/2,x/2)。若x<0 ，则返回0
• chi2tail(n,x) chi2tail(n,x) = 1 - chi2(n,x)。若x<0 ，则返回1
• dgammapda(a,x) 返回gammap(a,x)分布函数关于a的偏微分，a>0. 若x<0 ，则返回0
• dgammapdada(a,x) 返回gammap(a,x)分布函数关于a的二阶偏微分，a>0. 若x<0 ，则返回0
• dgammapdadx(a,x) 返回gammap(a,x)分布函数关于a和x的二阶偏微分，a>0. 若x<0 ，则返回0
• dgammapdx(a,x) 返回gammap(a,x)分布函数关于x的偏微分，a>0. 若x<0 ，则返回0
• dgammapdxdx(a,x) 返回gammap(a,x)分布函数关于x的二阶偏微分，a>0. 若x<0 ，则返回0
• F(n1,n2,f) 返回分子自由度为n1，分母自由度为n2的F分布函数。若f<0 ，则返回0
• Fden(n1,n2,f) 分子自由度为n1，分母自由度为n2的F分布函数的概率密度函数。若f<0 ，则返回0
• gammap(a,x) gamma分布
• ibeta(a,b,x) β分布
• normal(z) 正态分布函数
• normalden(z) 标准正态分布密度函数
• tden(n,t) t分布的概率密度函数

日期时间函数
• date(date, mask) 返回date与1960年1月1日相距的天数，其中mask的形式为“MDY”或“YMD”或“DMY”,表示date中年月日的顺序
• weekly(date, mask) 返回date与1960年1月1日相距的星期数
• monthly(date, mask) 返回date与1960年1月1日相距的月数
• quarterly(date, mask) 返回date与1960年1月1日相距的季度数
• halfyearly(date, mask) 返回date与1960年1月1日相距的星期数
• yearly(date, mask) 返回date与1960年1月1日相距有多少个半年
• clock(date, mask) 返回date与1960年1月1日相距的秒数
• mdyhms(M, D, Y, h, m, s) 从年月日，小时，分钟，秒得到stata日期时间值
• dhms(td, h, m, s) 从日期，小时，分钟，秒得到stata日期时间值
• hms(h, m, s) 从小时，分钟，秒返回一个stata日期时间值
• mdy(M, D, Y) 从月，日，年中得到一个stata日期值
• yw(Y, W) 从年，星期得到一个stata日期值，表示距1960年1月1日有多少个星期
• ym(Y, M) 从年，月得到一个stata日期值，表示距1960年1月1日有多少个月
• yq(Y, Q) 从年，季度得到一个stata日期值，表示距1960年1月1日有多少个季度
• yh(Y, H) 从年，半年得到一个stata日期值，表示距1960年1月1日有多少个半年
• year(d) 从stata日期中得到年份
• month(d) 从stata日期中得到月份
• day(d) 从stata日期中得到当前日期（一个月内的日期）
• doy(d) 从stata日期中得到当前日期（一年内的日期）
• quarter(d) 从stata日期中得到当前季度
• week(d) 从stata日期中得到当前星期
• dow(d) 从stata日期中得到当前星期几，其中 0为星期天，3为星期三
例：请算算你活了多少天？示例：一个生于1975 年12 月27 日的家伙，他活了？
.di date(“1975/12/27”,”YMD”)
