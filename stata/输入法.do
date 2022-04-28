corr,2=
corr2docx price-length using corrresults.docx, append star ///
title("Pearson & Spearman Correlation Coefficient") note("By 爬虫俱乐部")
export,2=export excel using ".xlsx",replace firstrow(variables)
import,2=import excel using ".xls",case(lower) first clear
log,2=
log using log2docx.txt, text replace nomsg

use auto.dta, clear
regress mpg weight foreign

log close 

putdocx clear
putdocx begin
putdocx paragraph, style("Heading1")
putdocx text ("Chapter 8: Add log files"), font(, 20)
file open fh using log2docx.txt, read
file read fh line
putdocx paragraph, font("Courier", 9.5)
while r(eof)==0 {
	putdocx text (`"`line'"'), linebreak
	file read fh line
}
file close fh
putdocx save log2docx.docx, replace
di as txt `"(output written to {browse log2docx.docx})"'
erase log2docx.txt
reg,2=
reg2docx FE LSDV FD RE MLE BE using e:\temp\panel.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("IV results") /// 
mtitles("" "" "" "" "" "") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("state=*state" "year=year*") landscape
sum,2=
sum2docx price-length using sumresults.docx, ///
append stats(N mean(%9.2f) sd skewness kurtosis min(%9.2f) median max(%9.2f)) ///
title("Summary Statistics")
