cd "e:\data\hu"
import excel using "R 使用数据.xlsx",case(lower) first clear
br
rename 年份 year
rename 湖北文化及相关产业增加值亿元 culture //Y
rename 年度gdp gdp_year  //X
rename 定基年度cpi cpi_year
rename 年份季度 season
rename 当季gdp gdp_season  //Z
rename 当季cpi2007100 cpi_season
rename 当季人均可支配收入 inc_season

reg culture gdp_year
rvpplot gdp_year
estat imtest,white //white检验
estat hettest,rhs iid //BP检验

