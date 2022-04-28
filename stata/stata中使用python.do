//stata中python的设置与使用:
1.1 配置stata中的python;
python search       									//在全盘搜索Python的安装目录;
python set exec "D:\Anaconda\python.exe", permanently   //设置python路径;
1.2 进入Python环境;
　　在Stata界面下进入Python环境的方式有3种：

　　//完全进入

　　键入python可完全进入Python环境，命令提示符从.变为>>>。此后，我们可以自由输入Python代码，直到输入end命令退出该环境。举例如下：

. python
----------------------------------------------- python (type end to exit) ---------------
>>> print('Hello NJUPT!')
Hello NJUPT!
>>> city = 'NJUPT'[:2]
>>> print('I LOVE', end=' '); print(city)
I LOVE NJ
>>> end
-----------------------------------------------------------------------------------------

　　//半完全进入

　　键入python:可进入Python环境，但这种进入并不稳定，一旦出现错误就会回到Stata环境中。举例如下：

. python:
----------------------------------------------- python (type end to exit) ---------------
>>> print('I am a teacher.')
I am a teacher.
>>> print(1/0)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ZeroDivisionError: division by zero
-----------------------------------------------------------------------------------------
r(7102);


　　//非完全进入

　　在python:后直接键入一个或多个命令，可以在不跳出Stata环境的前提下，临时性地执行Python语法。举例如下：

sysuse auto,clear
python: print('I Love You.'); print('I Love You, too.')
describe

I Love You.
I Love You, too.

非完全进入非常有用，能使我们在撰写Stata小程序时直接调用Python的方法。

1.3 在Python环境下调用Stata;

　　当（半）完全地进入Python环境时，又如何临时调用Stata命令呢？很简单，使用stata:前缀即可。举例如下：
直接运行一下命令:
python
stata: sysuse auto,clear
stata: describe
print("hello world")
end

结果为:

. python
----------------------------------------------- python (type end to exit) ---------------
>>> stata: sysuse auto.dta, clear
(1978 Automobile Data)
>>> stata: regress price weight, nohead nocons
------------------------------------------------------------------------------
       price |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
------------- ----------------------------------------------------------------
      weight |   2.041977   .0926943    22.03   0.000     1.857238    2.226717
------------------------------------------------------------------------------
>>> end
-----------------------------------------------------------------------------------------

　　1.4 数据类型不兼容问题

　　刚拿到Stata16，我还无法完全摸清Stata和Python在数据类型上的兼容性，比如：

. python
----------------------------------------------- python (type end to exit) ---------------
>>> a = 1 1
>>> stata: display a
a not found
r(111);
>>> stata: scalar x = a
>>> stata: display x
2
>>> end
-----------------------------------------------------------------------------------------

　　为了保证代码执行的正确性，我们尽可能在两种软件的数据类型转换上做到“全手动”。下一节可以帮助我们了解这种转换的基本规律。

2 数据交互

　　本节介绍如何在Stata的数据类型和Python的数据类型之间进行转换。其适用情境为：

　　数据已经在Stata内存（数据编辑器）中，但想要使用Python的方法；比如，我们已经加载auto.dta数据集，但希望使用Python的matplotlib库
绘制一个以length为横轴、weight为纵轴、price为尺寸的散点图，并保存为dpi为300的png格式。

　　使用Python获取数据或运算出数据结果，但想要使用Stata的命令；比如，我们通过tushare获取财经数据，但希望使用Stata进行Garch(1,1)估计，求出长期波动率。

　　当然更复杂的是两者间相互调用，一方的执行结果决定了另一方的执行内容，反之亦然。

　　2.1 Stata Function Interface （sfi）

　　首先必须明确，sfi是一个Python库，因此我们始终在Python环境下载入和使用它。sfi的文档在以下地址中：

　　https://www.stata.com/python/api16/

　　从功能（而非模块）上梳理SFI的命令，主要包括以下4类：

　　创建数据表的命令，主要包括设置样本量和添加变量，形式上以add开头

　　将Stata数据转化为Python数据的命令，形式上以get开头

　　将Python数据转化为Stata数据的命令，形式上以store或set开头

　　其他命令，比如删除变量、处理异常、管理内存等

　　第4类命令其实很奇怪，我们完全不需要使用sfi库中的相关命令，转换之后使用Stata或Python自带的功能处理就好。因此，我们主要介绍前3类。

　　2.2 add族

　　当你希望将Python数据集转换为Stata数据集时，这一步非常重要。因为此时，Stata内存中什么也没有，没有数据、没有变量、甚至没有工作表；
因此我们需要先告诉Stata，从Python转过来的数据集有怎样的“长”和“宽”，Stata才能准确接纳该数据集。

　　假设我们使用tushare库获取了浦发银行的日线行情数据，我们必须先确定要将多长、多宽的数据放入Stata；本例中，我们希望放入全部的
样本（索引）和2个变量（trade_date/close），确定工作表大小的代码如下：

python
import tushare as ts
tstoken = 'c10e0c9b10018b79710773962110a678fb75025abc2ff21bfe699bb0'
pro = ts.pro_api(tstoken)
df = pro.daily(ts_code = '600000.SH')
df.shape
end

. python
----------------------------------------------- python (type end to exit) ---------------
>>> import tushare as ts
>>> tsToken = 'c10e0c9b10018b79710773962110a678fb75025abc2ff21bfe699bb0'
>>> pro = ts.pro_api(tsToken)
>>> df = pro.daily(ts_code='600000.SH')
>>> df.shape
(4000, 11)
>>> end

　　我们通过数据框的shape属性了解到df数据框中有4000行（样本）和11列（变量），根据我们的要求，最终进入Stata的是一个4000×2的数据集。
接下来，我们就可以通过addObs和addVar*命令新建行列。

python
from sfi import Data
Data.addObs(len(df))
Data.addVarStrL('date')
Data.addVarFloat('price')
end

. python
----------------------------------------------- python (type end to exit) ---------------
>>> from sfi import Data       # 引入sfi.Data
>>> Data.addObs(len(df))       # 创建与df行数一致的样本量
>>> Data.addVarStrL('Date')    # 创建字符串变量Date
>>> Data.addVarFloat('Price')  # 创建浮点型变量Price
>>> end
-----------------------------------------------------------------------------------------

　　打开数据编辑器，我们会看到工作表中已经有两个变量和4000行了，其中Date是空格，Price是缺失值符号.。其实，这两步完全可以在Stata环境下完成，
使用Python环境的优势在于我们有len函数可以确定df数据框的样本量，这是一个动态过程。

　　2.3 store族

　　确定了工作表的长宽后，我们就可以使用store命令将Python数据存入Stata中。本例中，我们将df数据框中的trade_date列存入Stata的Date列，
将df数据框中的close列存入Stata的Price列；操作如下：

python
Data.store('date',None,df['trade_date'])
Data.store('price',None,df['close'])
end

. python
----------------------------------------------- python (type end to exit) ---------------
>>> Data.store('Date',None,df['trade_date'])
>>> Data.store('Price',None,df['close'])
>>> end
-----------------------------------------------------------------------------------------

　　我们来了解一下store命令的参数。store命令的形式为store(var, obs, val[, selectvar])。参数var表示目标列名称，可以是数值/字符串/列表/None；
参数obs表示样本量，可以是数值/列表/None，None列示全部样本；参数val表示待存入的数据，要求是数组。selectvar是一个可选参数，默认为None，
表示对存入变量的选取。需要特别注意的是obs选项，因为没有缺省值，我们不能省略None。

　　2.4 get族

　　get族命令用于Python读取Stata数据（和一些非数据内容）。根据读取的数据类型差异，我们分成Data、Scalar、Matrix和Macro这4种主要类型来讲：

　　Data.get和Data.getAsDict

　　因为Python是动态类型语言，因此不需要先确定数据的存储类型和名称。以读取auto数据集为例：
sysuse auto,clear
python
from sfi import Data
lst = Data.get('price weight length')
lst[0]
dct = Data.getAsDict('price weight length')
import pandas as pd
df = pd.DataFrame(dct)
df.head(1)
end

. python
----------------------------------------------- python (type end to exit) ---------------
>>> from sfi import Data
>>> lst = Data.get('price weight length')        # 列表形式
>>> lst[0]
[4099, 2930, 186]
>>> dct = Data.getAsDict('price weight length')  # 字典形式
>>> import pandas as pd
>>> df = pd.DataFrame(dct)                       # 转化为数据框
>>> df.head(1)
   price  weight  length
0   4099    2930     186
>>> end
-----------------------------------------------------------------------------------------

　　get命令提取出的数据是列表形式，丢失了列标签；getAsDict命令提取出的数据是字典形式，保留了列标签（键）。我个人建议使用后者，
并及时保存为数据框格式。此外，当我们只需要数据集中的单个值时，可以使用Data.getAt命令，该命令通过变量参数和索引参数确定唯一的位置并提取对应元素。

　　Scalar.getValue和Scalar.getString

　　除了数据集外，我们还会在Stata中使用一些“单值”，比如常数、结果、参数值等等。我们使用sfi.Scalar模块来读取这些内容。举例如下：

. scalar s = "I Love You."
. display s
I Love You.
. quietly regress price weight length
. display e(r2)
.34756307

python
from sfi import Scalar
Scalar.getString('s')
Scalar.getValue('e(r2)')
end

. python
----------------------------------------------- python (type end to exit) ---------------
>>> from sfi import Scalar
>>> Scalar.getString('s')     # 提取字符串
'I Love You.'
>>> Scalar.getValue('e(r2)')  # 提取数值
0.3475630724239044
>>> end
-----------------------------------------------------------------------------------------

　　当我们需要重复使用Stata命令时，Python迭代可能比Stata自己的循环效率更高，提取并记录单值就显得格外重要。

　　Matrix.get

　　当数据结果为矩阵时，我们使用Matrix.get命令实现提取。举例如下：（接上例回归结果）

. matrix list e(b)
e(b)[1,3]
        weight      length       _cons
y1   4.6990649  -97.960312   10386.541

python
from sfi import Matrix
Matrix.get('e(b)')
end

. python
----------------------------------------------- python (type end to exit) ---------------
>>> from sfi import Matrix
>>> Matrix.get('e(b)')
[[4.699064878412987, -97.9603118181582, 10386.540540844977]]
>>> end
----------------------------------------------------------------------------------------- 

　　单使用Matrix.get命令会丢失矩阵的行列名称，因此Stata还提供了Matrix.getColNames和Matrix.getRowNames来提取行列名称。
与Data.getAt类似，我们也可以通过Matrix.getAt命令提取矩阵中的单个元素，注意该命令的参数有3个，分别是矩阵名、行和列。

　　Macro.getLocal和Macro.getGlobal

　　在Stata中，Macro被称为“宏”，分为局部宏（local）和全局宏（global）两种；宏名称在细分类中不能重复，但局部宏和全局宏的
名称可以相同（实际上只是命名时相同，存储时并不同）。同样，我们可以通过Macro.getLocal和Macro.getGlobal获取宏。举例如下：

. local x 1 1
. display `x'
2

. python
----------------------------------------------- python (type end to exit) ---------------
>>> from sfi import Macro
>>> Macro.getLocal('x')          # 切记：宏是即用即解的
'1 1'
>>> Macro.getGlobal('e(model)')  # ereturn的宏是全局宏
'ols'
>>> end
-----------------------------------------------------------------------------------------

3 小结

　　正如上文所言，我们的最终目的是将Python的方法封装到Stata程序中，或者将Stata的命令封装到Python函数中。当我们实现了数据类型的转换后，封装命令就一点也不难了。

　　但以我刚接触的感受来讲，Stata16的SFI真的非常蠢，写到这里我竟一时间不知道如何解释下去：

　　变量的长度不能自适应，我们必须先通过set obs或add obs来确定样本量

　　Python的数据框（来自pandas）和Stata的数据集之间不能直接转换

　　变量要先创建再填充，目标数据类型需要手动设置，缺少获取变量名称列表的函数

　　缺少获取数字-文字对照表的函数，也没有提取全部命令结果（包括图形命令结果）的函数

　　特别地，如果我们希望将Stata数据集完整的读入Python或反过来，我个人建议使用Excel工作表作中介。效率上差一点，但节约很多代码。举例如下：

. python // Stata-> Python
----------------------------------------------- python (type end to exit) ---------------
>>> import pandas as pd
>>> stata: sysuse auto.dta
(1978 Automobile Data)
>>> stata: export excel price weight length using "D:\auto.xlsx" if rep78!=., firstrow(variables) replace
>>> df = pd.read_excel(r'd:\auto.xlsx',header=0)
>>> df.head(1)
   price  weight  length
0   4099    2930     186
>>> end
-----------------------------------------------------------------------------------------

. python // Python -> Stata
----------------------------------------------- python (type end to exit) ---------------
>>> import tushare as ts
>>> import pandas as pd
>>> tsToken = 'f***7'
>>> pro = ts.pro_api(tsToken)
>>> df = pro.daily(ts_code='600000.SH')
>>> df.to_excel(r'd:\quotes.xlsx',header=True,index=False)
>>> stata: import excel "D:\quotes.xlsx", sheet("Sheet1") firstrow
(11 vars, 4,000 obs)
>>> end

-----------------------------------------------------------------------------------------

文章作者： 金融系程老师（微信公众号）
最后，启发大家去读一读SFI的手册，我留下了set族命令没有介绍。这是一类在Python中设定Stata单值、暂元、
矩阵等元素的命令，使用方法和get族非常类似，希望同学们有空去了解一下。

// sfi
python
from sfi import Data
import tushare as ts

// 创建数据集和变量
df = ts.get_deposit_rate()
Data.addObs(df.shape[0])
Data.addVarStrL('date')
Data.addVarStrL('deposit_type')
Data.addVarStrL('rate')

// 存储数据
Data.store('date', None, df.iloc[:,0])
Data.store('deposit_type', None, df['deposit_type'])
Data.store('rate', None, df['rate'])

end
br
