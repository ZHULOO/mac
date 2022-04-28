***************************************mata操作*****************************

mata
mata help
mata describe
mata drop
mata matsave      		//将当前mata变量数据保存为.mmat格式
mata matuse      		//载入.mmat格式数据
mata matdescribe      	//描述.mmat格式数据
//将矩阵X写入mymatrix.myfile文件
fh = fopen("mymatrix.myfile", "w")
fputmatrix(fh, X)
fclose(fh)
//读取mymatrix.myfile,并赋值给X
fh = fopen("mymatrix.myfile", "r")
X = fgetmatrix(fh)
fclose(fh)
mata memory 			//报告内存使用情况
mata clear	 			//清理mata使用内存
mata set 	 			//
mata rename 			//
mata query	 			//
mata stata  			//不退出mata执行stata命令
mata memory 			//

*****putmata
//将stata变量创建为mata向量
sysuse auto,clear
putmata * 							//将auto所有变量创建为mata向量
putmata mpg weight displ    		//将三个变量创建为mata向量,可以简写displ
putmata mileage=mpg pounds=weight  	//
putmata y=mpg x=(weight displ) 		//
putmata y=mpg x=(weight displ 1) 	//
putmata mpg foreign x=(weight displ) z=(foreign 1)	//
putmata mpg foreign X=(weight displ) Z=(foreign 1), replace
putmata y=mpg X=(weight displ 1), omitmissing
putmata y=mpg X=(weight displ 1) if !missing(mpg) & !missing(weight) ///
& !missing(displ)

*****getmata
//将mata向量或矩阵创建为stata变量
getmata x1 x2
getmata myvar1=x1 myvar2=x2
getmata (firstvar secondvar)=X
getmata (myvar*)=X
getmata r1 r2 final=r3 (rplus*)=X
getmata r1 r2 final=r3 (rplus*)=X, replace
*****二者配合使用
putmata myid y X=(x1 x2 1) if male
mata
b = invsym(X'X)*X'y
yhat = X*b
end
getmata yhat, id(myid)

*****案例
sysuse auto, clear
regress mpg weight displacement
putmata make y=mpg X=(weight displacement 1)
mata
b = invsym(X'X)*X'y
yhat = X*b
end
getmata yhat,id(make)

*****在空间计量里的应用*****
//复制到当前内存，直接use
copy https://www.stata-press.com/data/r17/exports.dta .
use export,clear
//复制到当前目录
cd "E:\data"
copy https://www.stata-press.com/data/r17/exports.dta exports.dta
use export
describe
tomata from to exports gdp
mata
g = J(196, 1, 0)
E = J(196, 196, 0)
for (k=1; k<=length(exports); k++) {
	i = from[k]
	j = to[k]
	g[i] = gdp[k]
	E[i,j] = exports[k]
}
mata describe
W = (E+E'):/g
id = 1::196
end
spmatrix spfrommata Wt = W id //将W矩阵和和id向量输出为空间权重矩阵;
spmatrix summarize Wt
spmatrix matafromsp W id = Wt //相反,将空间权重矩阵转化为mata矩阵W和向量id;
getmata (var*) = W   		  //将mata中W矩阵转化为stata变量;



