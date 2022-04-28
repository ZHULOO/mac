*************************python*************************
* PyStata module — Python中调用stata
* -------------- — stata中调用python
python
word = 'Python'
word[0], word[-1]
len(word)
squares = [1,4,9,16,25]
from math import pi
[str(round(pi, i)) for i in range(1,8)]
for i in range(3):
	print(i)
stata: regress mpg weight foreign
end 
//do文件中定义python函数,并且在python中执行:
*******************begin pyex1.do*******************
version 17.0
local a = 2
local b = 3
python:
from sfi import Scalar
def calcsum(num1, num2):
	res = num1 + num2
	Scalar.setValue("result", res)
calcsum(`a', `b')
end
display result
*******************end** pyex1.do*******************

//do文件中定义python函数,python:执行
*******************begin pyex2.do*******************
version 17.0
local a = 2
local b = 3
python:
from sfi import Scalar
def calcsum(num1, num2):
	res = num1 + num2
	Scalar.setValue("result", res)  //将python变量赋值给stata变量
end
python: calcsum(`a', `b')
display result
*******************end** pyex2.do*******************

//do文件中执行pyex.py脚本:
'''python
from sfi import Macro, Scalar
def calcsum(num1, num2):
	res = num1 + num2
	Scalar.setValue("result", res)

pya = int(Macro.getLocal("a"))
pyb = int(Macro.getLocal("b"))
calcsum(pya, pyb)
'''
*******************begin pyex3.do*******************
version 17.0
local a = 2
local b = 3
python script pyex.py //执行上面的py脚本;
display result
*******************end** pyex3.do*******************

//pyex2.py脚本后带参数
'''python
import sys
pya = int(sys.argv[1])
pyb = int(sys.argv[2])
from sfi import Macro, Scalar
	def calcsum(num1, num2):
	res = num1 + num2
Scalar.setValue("result", res)
calcsum(pya, pyb)
'''
*******************begin pyex4.do*******************
version 17.0
local a = 2
local b = 3
python script pyex2.py, args(`a' `b')
display result
*******************end** pyex4.do*******************

//ado文件中使用python函数
*******************begin varsum.ado*******************
program varsum
	version 17.0
	syntax varname [if] [in]
	marksample touse
	python: calcsum("`varlist'", "`touse'")
	display as txt " sum of `varlist': " as res r(sum)
end

version 17.0
python:
from sfi import Data, Scalar
def calcsum(varname, touse):
	x = Data.get(varname, None, touse)
	Scalar.setValue("r(sum)", sum(x))
end
*******************end** varsum.ado*******************
sysuse auto,clear
varsum price

//pyex3.py
'''python
from sfi import Data, Scalar
def calcsum(varname, touse):
	x = Data.get(varname, None, touse)
	Scalar.setValue("r(sum)", sum(x))
'''
*******************begin varsum.ado*******************
program varsum
	version 17.0
	syntax varname [if] [in]
	marksample touse
	python: calcsum("`varlist'", "`touse'")
	display as txt " sum of `varlist': " as res r(sum)
end

version 17.0
python:
from pyex3 import calcsum
end
*******************end** varsum.ado*******************



*******************python和stata数据互通*******************
//参见:https://www.stata.com/python/api17/
//参见:https://www.stata.com/python/api17/Data.html
from sfi import Data
stata: sysuse auto, clear
Data.getAt(0, 0)
Data.get(0, 0)
Data.get(var='price')
Data.get(obs=0)
Data.get([0,2,3], [0,2,4,6])
Data.get(var='foreign')
Data.get(var='foreign', valuelabel=True)
Data.getVarLabel(0)
Data.getVarLabel('price')
Data.setVarLabel(1, 'Retail Price')
Data.setVarLabel('mpg', 'Mileage per Gallon')
Data.renameVar(0, 'make2')
Data.renameVar('price', 'price2')
Data.dropVar("make2")
Data.dropVar("price2 mpg rep78")
Data.dropVar(0)
Data.dropVar([0,2,3])
Data.get(var='rep78', missingval=-100)
Data.get(var='rep78', missingval=None)
import numpy as np
Data.get(var='rep78', missingval=np.nan)

sysuse auto, clear
local varlist price mpg rep78 headroom
summarize `varlist'



//
from sfi import Data, Macro, Missing, SFIToolkit
//obtain list of the variables to summarize
varlist = Macro.getLocal("varlist")
vars = varlist.split(" ")
nobs = Data.getObsTotal()

//display the header
SFIToolkit.displayln("\n" +   "    " + "Variable {c |}        Obs        Mean    Std. Dev.       Min        Max")
SFIToolkit.displayln("{hline 13}{c +}{hline 57}")

for var in vars:
    sum = 0
    maxv = 0
    minv = Missing.getValue()
    avgv = 0
    stddev = 0
    count = 0

    //skip the variable if it is string
    if not Data.isVarTypeStr(var):

        //calculate mean, max, min
        for obs in range(nobs):
            //obtain the observation value
            value = Data.getAt(var, obs)

            //skip the missing observations
            if Missing.isMissing(value):
                continue

            if value > maxv:
                maxv = value
            if value < minv:
                minv = value

            sum += value
            count += 1

        avgv = sum / count

        //calculate std. dev.
        d2sum = 0
        for obs in range(nobs):
            value = Data.getAt(var, obs)
            if Missing.isMissing(value):
                continue

            d2sum += pow(value-avgv,2)

        stddev = pow(d2sum/(count-1), 0.5)

        //display the results
        out = "%12s {c |}%11s" % (var, SFIToolkit.formatValue(count, "%11.0gc"))
        if count>0:
            out += "   %9s" % (SFIToolkit.formatValue(avgv,  "%9.0g"))
            out += "   %9s" % (SFIToolkit.formatValue(stddev,"%9.0g"))
            out += "  %9s" % (SFIToolkit.formatValue(minv,   "%9.0g"))
            out += "  %9s" % (SFIToolkit.formatValue(maxv,   "%9.0g"))

            SFIToolkit.displayln(out)












*******************end** pyex1.do*******************
