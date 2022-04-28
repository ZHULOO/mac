webuse nhanes2l
br
cd "E:\data\r15"
save nhanes2l.dta,replace

*****collect命令*****
* 1.收集回归结果
//先设置collect style:
collect style cell,nformat(%5.2f)
collect style _cons last
collect layout (colname) (result)
collect style save myreg,replace

collect:regress bpsystol weight
collect:regress bpsystol weight i.sex i.agegrp
collect:regress bpsystol weight i.sex i.agegrp i.sex#i.agegrp

collect style use myreg,override
collect export mreg.docx
