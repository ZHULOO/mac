[TOC]
# estout系列命令
+ `estout`包提供了一套处理回归表格的一般化程序，引擎，在它的基础上开发出以下常用命令：
  + `eststo`可以作为官方`estimates store`命令的备选，保存估计结果以备后续作表使用；
  + `esttab`提供大众化的回归表格，友好地显示在结果窗口，或者输出为CSV、RTF、HTML 或 LATEX格式；
  + `estadd`添加额外的结果到已知的估计结果集，以便于后续将其制成表格；
  + `estpost`将各种非e-class命令的结果发布，以便于后续用来制成表格。
+ 安装和更新：
```stata
ssc install estout
net install estout, replace from(https://raw.githubusercontent.com/benjann/estout/master/)
adoupdate estout
```

## 1.eststo 储存估计集
### 1.1 基本用法
+ `eststo [name] [,options] [:estimation_command]`；
+ 和官方命令`estimates store`用法类似；
+ `eststo dir`
+ `eststo drop`
+ `eststo clear`
+ 实例：
```stata
cd e:\data
use income.dta,clear
browse
help eststo
help return
help esample 
//分组回归：
eststo clear
eststo:qui reg inc exp edu if male == 0
eststo m1:qui reg inc exp edu if male == 0
eststo:qui reg inc exp edu if male == 1
eststo m2:qui reg inc exp edu if male == 1
//交互项：
eststo:qui reg inc exp edu male c.exp#male c.edu#male
eststo dir

esttab
estout
```

## esttab
+  esttab [ namelist ] [ using filename ] [ , options ]

