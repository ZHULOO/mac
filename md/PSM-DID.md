# PSM-DID
## 一、双重差分
+ 两期面板模型：
$$
y_{it}=\beta_0+\beta_1 G_i \cdot D_t+\beta_2G_i+\gamma D_t+\epsilon_{it} \qquad  (i = 1,2, \cdots ,n; t = 1,2)  
$$
+ 当  $t=1$ 时，上式可以写为：
$$
y_{i1}=\beta_0+\beta_2G_i+\epsilon_{i1}
$$
+ 当  $t=2$ 时，上式可以写为：
$$
y_{i2}=\beta_0+\beta_1G_i \cdot D_2 +\beta_2G_i +\gamma +\epsilon_{i2}
$$
+ 上面两式作差可得：
$$
\Delta y_i = \gamma + \beta_1 G_i \cdot D_2 +(\epsilon_{i2}-\epsilon_{i1})=\gamma + \beta_1 x_{i2} +\Delta \epsilon_i
$$
+  $G_iD_t$(时期和处理虚拟变量的交互项)的系数  $\hat{\beta}_1$ 即双重差分估计量； 
+  stata双重差分估计量，可手工计算也可使用非官方`diff`命令：

```stata
ssc install diff
diff y,treat(varname) period(varname) cov(z1 z2) robust report test
```  
+ y为结果变量，treat为处理虚拟变量，period实验期虚拟变量；
+ robust汇报稳健标准误，cov()为协变量，report汇报协变量系数的估计结果；
+ test检验在基期时，各变量在实验组和控制组的均值是否相等。

```stata
//手工计算：
cd e:\data
use cardkrueger1994,clear
gen gd = t*treated 
reg fte gd treated t,r
reg fte gd treated t bk kfc roys,r
//diff命令：
diff fte,t(treated) p(t) robust
diff fte,t(treated) p(t) cov(bk kfc roys) robust
diff fte,t(treated) p(t) cov(bk kfc roys) robust test
```

## 二、倾向得分匹配
+ 非官方命令`psmatch2`

```stata
ssc install psmatch2
psmatch2 D x1 x2 x3,outcome(y) logit ties ate common odds pscore(varname) quietly
```
+ D为处理变量，x1 x2 x3为协变量，outcome为结果变量；
+ logit使用logit来估计倾向得分，默认为probit；
+ ties倾向得分相同的个体并列，默认按照数据排序选择其中一位个体；
+ ate表示同时汇报ATE、ATU和ATT，默认仅汇报ATT；
+ common表示对共同取值范围内的个体进行匹配，默认对所有个体进行匹配；
+ odds使用几率比（p/(1-p)）进行匹配，默认使用倾向得分p进行匹配；
+ pscore指定变量作为倾向得分，默认使用x1 x2 x3等协变量来估计倾向得分；
+ quietly表示不汇报对倾向得分的估计过程；
+ 另外还有不同的匹配方法选项：
    + neighbor(k)表示k近邻匹配，默认k=1，一对一匹配；
    + noreplacement表示无放回匹配，默认有放回；
    + radius表示进行半径匹配，其中caliper(real)用来指定卡尺real，必须为正实数；
    + neighbor(k)和caliper(real)同时使用表示卡尺范围内进行k近邻匹配；
    + kernel kerneltype(type)表示核匹配，type用来指定核函数，默认epan kernel表示二次核；
    + bwidth(real)用来指定带宽，默认带宽为0.06；
    + llr表示局部线性回归匹配；
    + spline表示使用样条匹配；
    + mahal(varlist)表示进行马氏匹配，并指定计算马氏距离的变量varlist；
    + ai(m)表示使用Abadie and Imbens(2006)提出的异方差稳健标准误，该选项仅适用于马氏距离的k近邻匹配；
        + 其中m为正整数，表示用于计算稳健标准误的近邻个数；
        + 一般可让m=k，此时无法使用commen和ties选项；
+ 还有两个估计后命令：
    + `pstest x1 x2 x3,both graph`：检验协变量匹配后是否平衡，并画图显示倾向得分的共同取值范围；
        + both表示同时显示匹配前的数据平衡情况，默认仅显示匹配后的情形；
        + graph图示各变量匹配前后的平衡情况；
    + `psgraph,bin`：画直方图显示倾向得分的共同取值范围；
        + bin(#)指定直方图的分组数，默认为20组（处理组和控制组各分为10组）；

+ 实例见："倾向得分匹配.do"

## 三、双重差分倾向得分匹配
### 操作步骤
+ 1、根据处理变量  $D_i$ 与协变量  $x_i$ 估计倾向得分；
+ 2、对于处理组的每位个体 $i$ ，确定与其匹配的全部控制组个体;
+ 3、对于处理组的每位个体 $i$ ，计算其结果变量的前后变化 $(y_{1ti}-y_{0t'i})$ ;
+ 4、对于处理组的每位个体 $i$ ，计算与其匹配的全部控制组个体的前后变化 $(y_{0tj}-y_{0t'j})$ ;
+ 5、带入以下公式进行倾向得分核匹配或局部线性回归匹配，即  $\widehat{ATT}$ 
$$
\widehat{ATT}=\frac{1}{N_1}\sum\nolimits_{i:i\in{I_1\cap S_P}}[(y_{1ti}-y_{0t'i})-\sum\nolimits_{j:j\in{I_0\cap S_P}}w(i,j)(y_{0tj}-y_{0t'j})]
$$
+ 使用diff进行双重差分PSM估计的语法：
```stata
diff outcome_var,treat(varname) period(varname) id(varname) kernel ktype(kernel) cov(varlist) report logit support test
```
+ diff只提供核匹配方法，默认二次核，其它选项的含义同上；
+ 实例见："PSM-DID.do"

