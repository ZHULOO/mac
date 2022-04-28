cd "E:\学术论文\C论文\高管薪酬与创新激励"
use "数据.dta", clear
sum2docx frd fpatent fcitation flogpatent flogcitation salary ownship logassets logppe_emp ///
return tobinq lev logtenure logage logedu using sumresults.docx, ///
replace stats(N mean sd skewness kurtosis min median max) ///
title("Summary Statistics")
cdout
