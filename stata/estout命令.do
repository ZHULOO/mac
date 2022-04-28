*****estout命令*****
***estout包含以下命令：
* 1.esttab：
* 2.estout
* 3.eststo：储存估计结果集，和官方命令estimates store类似；
* 4.estadd
* 5.estpost

** eststo储存估计结果:eststo [name] [,options] [:estimation_command]
sysuse auto.dta,clear
reg price weight mpg
