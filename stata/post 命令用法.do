**********************POST Program1********************************
	postfile mypost str16 station str10 arrive_time temperature using e:\财务金融\post\mypost.dta, replace
	post mypost ("武汉") ("10：17") (5.7)
	postclose mypost

**********************POST Program2********************************
	capture postclose mypost
	postfile mypost str16 station str10 arrive_time temperature using e:\财务金融\post\mypost.dta, replace
	post mypost ("武汉") ("10：17") (5.7)
	post mypost ("郑州") ("11：17") (3.7)
	post mypost ("北京") ("14：16") (-3.7)
	postclose mypost 						//close以后才会将数据保存到mypost.dta
	use e:\财务金融\post\mypost.dta, clear

**********************POST Program3 with Loops********************************

	capture postclose mypost
	postfile mypost obs_id str10 date str10 time ran_number using e:\财务金融\post\mypost.dta, replace
	forval i = 1(1) 10 {
	local sysdate = c(current_date)
	local systime = c(current_time)
	local myrand = uniform()
	post mypost (`i') ("`sysdate'") ("`systime'") (`myrand')
	sleep 1000
	}
	postclose mypost
	use e:\财务金融\post\mypost.dta, clear

*****post操作命令:
	postfile postname newvarlist using filename [, every(#) replace] 	//定义post过程
	post postname (exp) (exp) ... (exp) 								//post传递数据
	postclose postname 													//关闭post过程

	postutil dir 														//显示当前内存中的post
	postutil clear 														//清楚当前内存中的post

*****保存多次回归的R方:
****保存中国银行和沪深300的数据进行回归:
	clear
	cd e:\财务金融\post\

	cap postclose syn
	postfile syn stkcd year syn using syn.dta,replace
	cntrade 300,index
	keep date rmt
	sort date
	save HS300,replace

	cntrade 601988
	keep date rit
	sort date
	merge date using HS300,nokeep
	drop _m

	forvalue y = 2001/2018{
	preserve
	keep if year(date)==`y'
	if _N>=100 {
	qui reg rit rmt
	post syn (601988) (`y') (e(r2))  //将每一年回归的R方post到syn.dta中;
	}
	restore
	}

	postclose syn
	use syn,clear
	br

*****只保留了下x1>0.6的样本:
	clear
	set obs 100
	gen id = mod(_n,25)+1
	gen x1 = uniform()
	gen x2 = rnormal()*2+3.5
	gen x3 = exp(x2)
	sum x1 if x1>.6
	capture postclose mypost
	postfile mypost obs_id x1 x2 x3 using d:\mypost.dta, replace
	forval i = 1(1) 100 {
		if x1[`i']>0.6 {
			local id = id[`i']
			local x1 = x1[`i']
			local x2 = x2[`i']
			local x3 = x3[`i']
			post mypost (`id') (`x1') (`x2') (`x3') //只保留了下x1>0.6的样本
	}
	}
	postclose mypost
	use d:\mypost.dta, clear

