***金融面板数据的各类标准误***
*参见：https://www.kellogg.northwestern.edu/faculty/petersen/htm/papers/se/se_programming.htm#_Simulated_Data_Sets
*数据集和命令都在此网站下载。
cd E:\data
use test_data.dta,clear
br 

*1、Clustered(Rogers) Standerd Errors-one dimmension 一维的聚类标准误
	reg y x                          //OLS回归
	reg y x,robust                   //OLS回归+异方差稳健标准误（white standerd error）
	
	reg y x,robust cluster(firmid)	 //OLS回归+按firmid聚类的稳健标准误（近似普通标准误的2倍），和下面命令相同.
	reg y x ,vce(cluster firmid)    
	
	reg y x,robust cluster(year)     //按年份聚类的稳健标准误
	reg y x ,vce(cluster year)    
	
*2、Clustered Standerd Errors-Two dimmension 二维的聚类标准误
	cluster2 y x,fcluster(firmid) tcluster(year) //按公司和年份双重聚类的稳健标准误

*3、Fama-MacBeth Standerd Errors
	tsset firmid year //需要首先定义个体和时间变量，和下面命令一样的结果
	xtset firmid year
	fm y x,byfm(year) //第一步：每一时期的所有个体分别回归，第二部：取各期回归系数的平均值，等价于下面的xtfmb命令
	xtfmb y x,verbose //verbose表示显示第一步各期回归的系数，然后进行平均,lag(#)表示使用异方差自相关稳健标准误

*4、Newey West Standerd Errors 异方差自相关稳健标准误 
	tsset firmid year
	newey y x,lag(2) force  //Newey West异方差自相关稳健标准误，不加force会出错，因为是面板数据，需要用newey2命令
	newey2 y x,lag(2) 		//面板异方差自相关稳健标准误的命令，和上面加force的结果相同。

*5、Fixed Effects 虚拟变量回归
	areg y x,absorb(firmid) 	  //设置公司虚拟变量，进行回归，只能设置一个虚拟变量,absorb用来设置分类很多的虚拟变量，但是不报告结果（虚拟变量太多）。
	tabulate firmid,gen(firm_dum) //也可以手工生成虚拟变量，然后进行回归
	xi:areg y x i.year,absorb(firmid) //不报告公司虚拟变量的回归结果，因为太多了
	xi:reg y x i.year i.firmid 		  //公司虚拟变量太多，超出stata范围，报错
	

*6、Generalized Least Squares
	xtreg y x,r               //面板数据，默认使用聚类稳健标准误，和下面的命令结果相同
	xtreg y x,cluster(firmid) //按firmid聚类的稳健标准误
	xtreg y x,re r

*7、Bootstrap Standard Errors
	bootstrap _b _se,reps(100):reg y x //回归20次，如果组内自相关存在，则自助法标准误是有偏的，需要修改如下：
	
