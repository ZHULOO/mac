cd e:\data
display "Hello,Stata"
sysuse auto.dta,clear
tabulate foreign headroom
use "https://stats.idre.ucla.edu/stat/stata/notes/hsb2", clear
save hsb2.dta,replace
cdout
cd e:\data
use hsb2.dta,clear
scatter read math,title("Reading score vs Math score")
reg read math
quietly scatter math science // 不输出图形;
***Magics魔法命令
%help reg
%locals --help //魔法命令后接 --help可以查看该魔法命令的帮助文件;
%help --help
%browse --help
%head --help
%tail --help
%browse 10 price mpg
//浏览price和mpg变量的前10行;
%head price
//默认浏览某变量的前10行;
%tail
//默认浏览后10行;
%delimit
//查看当前分隔符;
#delimit ;
//修改当前分隔符;
%html,%latex
//和esttab命令配合将命令结果显示为html格式,latex格式;
sysuse auto,clear
eststo clear
eststo:qui reg price weight mpg
eststo:qui reg price weight mpg foreign
help esttab
%html
esttab,label nostar title(regression table) html
%latex
esttab,label title(regression table) tex
pwd
%locals,%globals
//列出局部或全局宏;
%set graph_width500
//设置图片宽度为500
%show_gui
%hide_gui
//显示或隐藏图形界面;
%status
reg price weight
