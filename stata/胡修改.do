use 实证12.dta,clear
//四段代码分别对应那四个word,要加入那些变量的初始值和均值??
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech,r
estimates store m1
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.lnpatent,r
estimates store m2
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(rdspendsumratio),r
estimates store m3
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(age),r
estimates store m4
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(lnrdperson),r
estimates store m5
reg2docx m1 m2 m3 m4 m5 using lnregresult11.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m1" "m2" "m3" "m4" "m5") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*") 


biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech,r
estimates store m6
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(isexport),r
estimates store m7
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(growth),r
estimates store m8
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(lnmarket),r
estimates store m9
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(lev),r
estimates store m10
reg2docx m6 m7 m8 m9 m10 using lnregresult12.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m1" "m2" "m3" "m4" "m5") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*")

biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech,r
estimates store m11
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(cash_shortdebt),r
estimates store m12
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech L.(ownership),r
estimates store m13
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech i.area,r //区域虚拟变量
estimates store m14
reg2docx m11 m12 m13 m14 using lnregresult13.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m1" "m2" "m3" "m4") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*")

//敏感性测试
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech,r
estimates store m15
biprobit rdsubsidy nrdsubsidy L.rdsubsidy L.nrdsubsidy L2.rdsubsidy L2.nrdsubsidy L.lnrelproductivity L.lnsize L.hightech,r
estimates store m16
reg2docx m15 m16 using lnregresult14.docx,replace ///
scalars(N r2_a(%9.3f) r2_p(%9.2f)) t(%7.2f) title("table titile") ///
mtitles("m15" "m16") note("(* 0.1 ** 0.05 *** 0.01)") ///
indicate("stkcd=*stkcd" "year=year*")
