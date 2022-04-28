**********************************DEA********************************
//stata关于DEA的相关命令：由厦门大学杜克锐开发
//个人主页:https://kerrydu.gitee.io/
//github:https://github.com/kerrydu
//gitee: https://gitee.com/kerrydu/
//dea:过于简单
//teradial:径向效率
//tenonradial:非径向效率
//teradialbc:bootstrap方法偏差矫正的径向技术效率,bootstrap方法取决于下面的独立性检验;
//nptestind:径向技术效率独立性的检验,效率与投入组合,效率与产出组合是否独立,是否独立决定了使用什么bootstrap方法,独立时使用平滑同质性bootstrap,否则使用平滑异质性bootstrap;
//nptestrts:径向技术效率模型的规模报酬检验,

//ddfeff:Directional Distance Function,基于方向距离函数的效率测算,与teddf语法结构一致,完全能被teddf代替;

//nddfeff: Non-radial Directional Distance Function,基于非径向方向距离函数的效率测算,与teddf语法结构一致,teddf命令中nonradial选项即可完成对非径向距离函数效率的测算;

//sbmeff: Slacks-Based Measure,该命令已被合并入gtfpch命令;

//teddf: 考虑非期望产出,以及面板数据,能代替上面的ddfeff和nddfeff;
//gtfpch:在malmq2的基础上考虑了非期望产出的影响;

****************************************DEA、malmq************************************
search malmq
help malmq2
cd "E:\data"
use "https://raw.githubusercontent.com/kerrydu/malmq2/master/exdata.dta"
copy "https://raw.githubusercontent.com/kerrydu/malmq2/master/exdata.dta" exdata.dta,replace
help dea
help malmq2
use exdata,clear
br
xtset dmu year
malmq2 K L= Y, global 				//stata 16中,17会报错
malmq2 K L= Y, seq ort(o) fgnz
malmq2 K L= Y, ort(o) rd sav(tfp_result,replace)

cd "E:\学术论文\zhaojian\DEA"
import excel using "(1)00-18旅游金融数据（DEA）.xls",case(lower) first clear
encode 地区,generate(province)
rename province dmu
rename 时间 year
rename 金融机构人民币存款年底余额亿 ck
rename 金融机构人民币贷款年底余额亿 dk
rename 保费收入亿元 bf
rename 一般公共财政支出亿元 czzc
rename 固定资产投资亿元 gdzc
rename 接待国内旅游人数万人次 rs
rename 接待国内游客收入亿元 sr
order dmu year
xtset dmu year
malmq2 ck dk bf czzc gdzc = rs sr,global ort(o) sav(malmq_result,replace)
use "E:\学术论文\zhaojian\DEA\malmq_result.dta" 
export excel using "malmq_result.xlsx",replace firstrow(variables)


******************************Stata-DEA：数据包络分析一文读懂*************************
//lianxh dea
//参考:https://www.lianxh.cn/news/45464d6ce18f3.html
cd "E:\data"
findit st0193                   // 包含案例数据
net install st0193.pkg,replace  // 安装命令,要重新安装,可能会出错;
net get     st0193.pkg          // 下载范例数据和 dofile
//基本DEA命令
use "coelli_table6.4.dta", clear 
br
dea i_x = o_q,rts(vrs) ort(in)   //投入导向规模报酬可变
dea i_x = o_q, rts(crs) ort(out) stage(2) saving(dea1_result)  //产出导向规模报酬不变
dea i_x = o_q, rts(vrs) ort(out) stage(2) saving(dea2_result)  //产出导向规模报酬可变

//3.2 技术效率统计推断的系列命令基本操作:teradial 和 tenonradial
findit teradial
net install st0444
net get 	st0444 
help teradial
set more off
use "ccr81.dta", clear 
teradial    y1 y2 y3 = x1 x2 x3 x4 x5, rts(crs)  base(output) tename(TErdCRSo) //产出导向，CCR模型,保存为TErdCRSo变量;
teradial    y1 y2 y3 = x1 x2 x3 x4 x5, rts(vrs)  base(output) tename(TErdVRSo) //产出导向，VRS径向，BCC模型
tenonradial y1 y2 y3 = x1 x2 x3 x4 x5, rts(crs)  base(output) tename(TEnrCRSo) //产出导向，CRS非径向
tenonradial y1 y2 y3 = x1 x2 x3 x4 x5, rts(nirs) base(output) tename(TEnrNRSo) //产出导向，NIRS非径向
tenonradial y1 y2 y3 = x1 x2 x3 x4 x5, rts(vrs)  base(output) tename(TEnrVRSo) //产出导向，VRS非径向
list TErdCRSo TErdVRSo TEnrCRSo TEnrNRSo TEnrVRSo in 1/7


     +------------------------------------------------------+
     | TErdCRSo   TErdVRSo   TEnrCRSo   TEnrNRSo   TEnrVRSo |
     |------------------------------------------------------|
  1. | 1.087257   1.032294    1.11721    1.05654    1.05654 |
  2. | 1.110133   1.109314   1.383089   1.277123   1.277123 |
  3. | 1.079034   1.068429    1.17053   1.116582   1.116582 |
  4. | 1.119434   1.107413   1.489086   1.471301   1.471301 |
  5. | 1.075864          1   1.196779   1.196779          1 |
     |------------------------------------------------------|
  6. | 1.107752   1.105075   1.380214   1.378378   1.378378 |
  7. | 1.125782   1.119087   1.575288   1.547186   1.547186 |
     +------------------------------------------------------+
//从上述结果可以看出，在相同规模报酬下，非径向技术效率大于等于径向技术效率。一般来说，当存在非零松弛时，径向测度方法要求投入产出同比例变动，会高估决策单元的效率。此处虽然结果相反，但径向并没有比非径向技术效率小太多。无论径向还是非径向，不同规模报酬下的技术效率表现为 CRS 大于等于 NIRS 大于等于 VRS。对于决策单元 1、2、3、4、7 而言，NIRS 和 VRS 下两种技术效率相等；对于决策单元 5 和 6，NIRS和 CRS 下两种技术效率相等。

//nptestind
//原假设互相独立;
matrix testsindpv = J(2, 3, .)    //生成三行两列的矩阵均为空值
matrix colnames testsindpv = CRS NiRS VRS  //三列标题分别命名为CRS NIRS VRS
matrix rownames testsindpv = output-based input-based //两行分别命名为output input
nptestind y1 y2 y3 = x1 x2 x3 x4 x5, rts(crs)  base(output) reps(999) alpha(0.05)  //判断
matrix testsindpv[1,1] = e(pvalue) 
nptestind y1 y2 y3 = x1 x2 x3 x4 x5, rts(nirs) base(output) reps(999) alpha(0.05) noprint
matrix testsindpv[1,2] = e(pvalue) 
nptestind y1 y2 y3 = x1 x2 x3 x4 x5, rts(vrs)  base(output) reps(999) alpha(0.05) noprint
matrix testsindpv[1,3] = e(pvalue) 
nptestind y1 y2 y3 = x1 x2 x3 x4 x5, rts(crs)  base(input)  reps(999) alpha(0.05) noprint
matrix testsindpv[2,1] = e(pvalue)  
nptestind y1 y2 y3 = x1 x2 x3 x4 x5, rts(nirs) base(input)  reps(999) alpha(0.05) noprint
matrix testsindpv[2,2] = e(pvalue) 
nptestind y1 y2 y3 = x1 x2 x3 x4 x5, rts(vrs)  base(input)  reps(999) alpha(0.05) noprint
matrix testsindpv[2,3] = e(pvalue) 
matrix list testsindpv   //列出矩阵进行判断

testsindpv[2,3]
                    CRS       NiRS        VRS
output-based  .06806807  .21121121  .03903904 
 input-based  .02902903    .004004  .22522523
//可以看出，在基于产出导向的非参模型中，只有 VRS 技术的独立性检验 p 值是 0.041，即在该技术下，独立性假设在 5% 显著水平被拒绝。在基于投入导向的非参模型中，结果恰好相反，只有 VRS 技术下的独立性假设在 5% 水平没有被拒绝。由于我们以产出导向为例，所以按照前述理论，对于 VRS 技术下的非参模型，应该使用平滑异质性 bootstrap 方法。

//teradialbc 
teradial   y1 y2 y3 = x1 x2 x3 x4 x5, rts(vrs) base(output)  ///
            tename(TErdVRSo1) noprint   //估算出原始的径向技术效率

teradialbc y1 y2 y3 = x1 x2 x3 x4 x5, rts(vrs) base(output)  ///
             heterogeneous reps(200) tebc(TErdVRSoBC2) biassqvar(TErdVRSoBC2bv) ///
             telower(TErdVRSoLB2) teupper(TErdVRSoUB2) noprint  //平滑异质性 bootstrap

teradialbc y1 y2 y3 = x1 x2 x3 x4 x5, rts(vrs) base(output) ///
             subsampling reps(200) tebc(TErdVRSoBC3) biassqvar(TErdVRSoBC3bv)   ///
             telower(TErdVRSoLB3) teupper(TErdVRSoUB3) noprint  //分样本 bootstrap

list TErdV* in 1/10 
     +--------------------------------------------------------------------------------------------------+
     | TErdVR~1   TErdV~C2   TErd~2bv   TErd~LB2   TErd~UB2   TErdV~C3   TErd~3bv   TErd~LB3   TErd~UB3 |
     |--------------------------------------------------------------------------------------------------|
  1. | 1.032294   1.177806   50.49028   1.110428   1.316515   1.147707   3.225391   1.040042   1.399043 |
  2. | 1.109314   1.219526   28.53432   1.146316   1.322456   1.183598   5.468737   1.118565   1.310247 |
  3. | 1.068429    1.15755   46.98428   1.117826   1.220525   1.138947   5.924676   1.078423   1.255616 |
  4. | 1.107413    1.14609   18.86327   1.122365   1.188839    1.13566   7.017749    1.11043   1.165413 |
  5. |        1          .          .          .          .          .          .          .          . |
     |--------------------------------------------------------------------------------------------------|
  6. | 1.105075   1.320676   19.63704   1.206336   1.774137   1.181873   1.898257    1.11969   1.574749 |
  7. | 1.119087   1.156273   26.95008   1.136962   1.190188   1.150161   7.849801   1.123182   1.179673 |
  8. | 1.104236   1.357608   47.08212   1.240192   1.665242   1.271391   3.493933   1.107031   1.673079 |
  9. | 1.160721    1.20168    21.0967   1.175617   1.239486   1.215681   8.116729   1.163576   1.272846 |
 10. | 1.054515   1.171699   45.61283   1.113947   1.261039   1.146046   4.037031   1.058351   1.327538 |
     +--------------------------------------------------------------------------------------------------+
//从结果可以看出，对于分样本 bootstrap 方法而言，其方差波动值要远远小于平滑异质性 bootstrap 方法下的结果，这说明分样本 bootstrap 方法估计值的方差要更大，而且校正偏差的效率估计值的均方误差也要比原始效率的均方误差更大，即比起分样本 bootstrap 方法，平滑异质性 bootstrap 方法更适用于该样本。值得注意的是，第 5 个决策单元在平滑异质性 bootstrap 方法下没有结果，这是因为该观测值位于 bootstrap 构建的边界之内，造成线性规划无解。

//nptestrts
nptestrts y1 y2 y3 = x1 x2 x3 x4 x5, base(output) heterogeneous reps(200) ///
alpha(0.05) testtwo sefficient(SEffnt_het) sineffdrs(SiDRS_het)   //前文检验支持平滑异质性bootstrap
table SEffnt_het
----------------------------------------------------------------
                                                    |  Frequency
----------------------------------------------------+-----------
Indicator variable if statistically scale efficient |           
  scale efficient                                   |         70
  Total                                             |         70
----------------------------------------------------------------
//从上面的估计结果可以看出，使用平滑异质性 bootstrap 方法，由于 test#1 的 p 值为 1.0164，说明无法拒绝全域生产技术是 CRS 的原假设，进一步对 70 个决策单元的规模效率进行检验，发现所有的决策单元都是规模有效的，因此无需再进行 test#2 的检验。
table SiDRS_het
variable SiDRS_het not found
//上述变量 SEffnt_het 是表述决策单元规模有效的指示变量，由于所有决策单元均是规模有效的，因此频数为样本数 70；变量 SiDRS_het 是表述决策单元规模无效的指示变量，由于在上述样本估计中，不存在规模无效的样本，因此无法生成该变量，所以会显示该变量无法找到。





**************************************3.3 SBM 模型基本操作****************************
*****************************************teddf、gtfpch********************************
/*
** install from github
net install gtfpch, from("https://raw.githubusercontent.com/kerrydu/gtfpch/master/") replace

**install from gitee
net install gtfpch, from(https://gitee.com/kerrydu/gtfpch/raw/master/) replace
*/
//teddf计算效率
//gtfpch计算全要素生产率
*第一种安装方式
net install gtfpch, from("https://raw.githubusercontent.com/kerrydu/gtfpch/master/") force   //如果网络不好可以尝试第二种
*第二种安装方式：下载压缩文件并将其解压缩到计算机磁盘上
copy https://codeload.github.com/kerrydu/gtfpch/zip/master gtfpch-master.zip
unzipfile gtfpch-master.zip
net install gtfpch, from(`c(pwd)'/gtfpch-master) force
*第三种安装方式：如果上述方法均受网速限制，建议手动下载
view browse "https://github.com/kerrydu/gtfpch"  //打开网页下载
net install gtfpch, from(D:\Lianxh\TE_Lianxh\T2_DEA\gtfpch\gtfpch-master)force  //将下载的gtfpch-master.zip放入相应路径，更改路径安装，注：D:\Lianxh\TE_Lianxh\T2_DEA\gtfpch为更改路径
cd "E:\data"
copy "https://gitee.com/kerrydu/gtfpch/raw/master/example_ddf.dta" example_ddf.dta
use example_ddf.dta,clear
*命令 teddf 必须使用面板数据，指定面板变量和时间变量。
/*
inputvars：投入变量；
desirable_outputvars：期望产出；
undesirable_outputvars：非期望产出；
dmu(varname): 指定各决策单元变量 (DMU)，必填项；
time(varname)：指定表示同时期的生产技术 (当年)，指定当年生产投入组合 convex combination 作为技术参考集。设定时期若不写这一项，则默认为全局生产技术 (global production technology)。
gx(varlist)：指定投入调整的方向向量，gx() 中指定的变量顺序应与投入变量中的顺序相同，默认是 gx=(0,..,0)；
gy(varlist)：指定期望产出调整的方向向量。默认 gy=Y，即期望产出观测值，gy() 中指定的变量顺序应与 desirable_outputvars 中的顺序相同；
gb(varlist)：指定非期望产出调整的方向向量。默认 gb=-B，即非期望产出观测值，gb() 中指定的变量顺序应与 undesirable_outputvars 中的顺序相同；
nonradial：指定使用非径向方向距离函数；
wmat(name)：指定用于调整输入和输出变量的权重矩阵 wmat(name) 仅在指定非径向时才可以使用，默认值为 W =（1/n，...，1/n)；
vrs:指定具有可变规模收益的生产技术。默认情况下，j 假定是规模报酬不变 (CRS) 的生产技术；
sup：指定超效率 super-dea 度量，暂时处于调试阶段，还不能使用；
tone:指定了 Tone(2004) 的 SBM 模型，计算松弛变量 (Slack) 分离分析单要素效率；
window(#)：以 ＃ 周期带宽指定窗口生产技术，能够解决不可行解问题，一般窗口设置为 3；
biennial：期指定两年一次的生产技术，能够解决不可行解问题；
sequential：表示指定序列生产技术，技术不会退步假设，DEA 的模型设定根据自身要求，均为先验的；
global：表示指定全局生产技术，解决不可行解问题；
saving(filename[， replace])：以 filename.dta 格式储存结果；
maxiter(#): 指定最大迭代次数，该迭代次数必须为大于 0 的整数。最大迭代次数的默认值为 16000；
tol (real): 收敛标准容差，其值必须大于 0。若不写这项，则默认为 1e-8。
*/
***具体示例如下：
cls
*crs sbm
use example_ddf.dta,clear
qui teddf labor capital energy= gdp: co2, dmu(id) time(t) tone sav(crssbm,replace)  //tone选项表示SBM模型，这里出错，该文章是2020年12月份的，命令更新了；
//SBM-Slack模型保存到crssbm文件，默认crs
qui merge 1:1 id t using crssbm
qui gen EE=1-(S_energy/energy)  //计算单要素投入，根据松弛程度计算能源效率
qui drop _merge 
save tee.dta,replace        //保存crs下计算的效率值
*vrs sbm
use example_ddf.dta,clear
qui teddf labor capital energy= gdp: co2, dmu(id) time(t) tone vrs sav(vrssbm,replace) 
qui merge 1:1 id t using vrssbm
qui gen EE2=1-(S_energy/energy)
qui drop _merge 
save pee.dta,replace        //保存vrs下计算的效率值
*合并数据
use tee.dta,clear
qui merge 1:1 id t using pee.dta,keepusing(EE2)
qui gen SEE=EE/EE2   //计算规模效率
list EE EE2 SEE in 1/10  


*************************杜克锐gtfpch命令里的说明文件里的案例****************************
***********************************teddf**********************************************
***命令结果：
*1、Dv保存的是β，径向模型直接计算相应效率；
*2、B_x、B_y、B_b保存的是各项投入和产出的改进比例，进一步使用相应导向效率计算公式计算效率；
*3、效率计算参考成钢《数据包络分析方法与MaxDEA软件》第105-108页；
cd "E:\data"
copy "https://gitee.com/kerrydu/gtfpch/raw/master/example.dta" example.dta
use example.dta,clear
******************径向***************
***1.径向、非导向
use example.dta,clear
teddf K L= Y: CO2, dmu(Province) time(year) sav(ex.teddf.result,replace)
use ex.teddf.result,clear //查看结果
br  //非导向计算效率,效率计算参考成钢《数据包络分析方法与MaxDEA软件》第105、106页
gen theta1 = (1-Dv)/(1+Dv)
keep Province year theta1
save theta1.dta,replace

***2.径向、产出导向
use example.dta,clear
gen gK=0
gen gL=0    //投入向量为0，可以看出是产出导向
gen gY=Y
gen gCO2=-CO2
teddf K L= Y: CO2, dmu(Province) time(year) gx(gK gL) gy(gY) gb(gCO2) sav(ex.teddf.direction.result,replace)
use ex.teddf.direction.result,clear
br   //产出导向效率
gen theta2 = 1/(1+Dv)
keep Province year theta2
save theta2.dta,replace

***3.径向、投入导向
use example,clear
gen gK = -K
gen gL = -L
gen gY = 0
gen gCO2 = 0
teddf K L=Y:CO2,dmu(Province) time(year) gx(gK gL) gy(gY) gb(gCO2) sav(ex.teddf.inputs.result,replace)
use ex.teddf.inputs.result,clear
gen theta3 = 1-Dv
keep Province year theta3
save theta3.dta,replace

***4.合并三个效率
use example.dta,clear
merge 1:1 Province year using theta1
drop _merge
merge 1:1 Province year using theta2
drop _merge
merge 1:1 Province year using theta3
drop _merge

*****************非径向**************
***1.非径向、非导向、权重:(1 1 1 1),方向:（-K -L Y -CO2)
//效率计算参考成钢《数据包络分析方法与MaxDEA软件》第107、108页
use example,clear
teddf K L= Y: CO2, dmu(Province) time(year) nonr sav(ex.teddf.nonr.result,replace)
use ex.teddf.nonr.result,clear
//默认wmat = (1 1 1 1)
gen theta4 = (1-1/2*(1*B_K+1*B_L))/(1+1/2*(1*B_Y+1*B_CO2)) 

***2.非径向、非导向、权重:(0.5 0.5 1 1),方向:（-K -L Y -CO2)
use example,clear
matrix wmatrix = (0.5,0.5,1,1)
teddf K L= Y: CO2, dmu(Province) time(year) nonr wmat(wmatrix) sav(ex.teddf.nonr.result,replace)
use ex.teddf.nonr.wmat.result,clear
gen theta5 = (1-1/(0.5+0.5)*(0.5*B_K+0.5*B_L))/(1+1/(1+1)*(1*B_Y+1*B_CO2)) 

***3.非径向、产出导向、权重:(0 0 1 1),方向:（0 0 Y -CO2)
use example.dta,clear
gen gK=0
gen gL=0   
gen gY=Y
gen gCO2=-CO2
matrix wmatrix = (0,0,1,1) //产出导向时，投入无需调整，对应的权重只能为0，否则出错；
teddf K L= Y: CO2, dmu(Province) time(year) gx(gK gL) gy(gY) gb(gCO2) nonr wmat(wmatrix) sav(ex.teddf.nonr.outputs.wmat.result,replace)
use ex.teddf.nonr.outputs.wmat.result,clear
gen theta6 = 1/(1+1/2*(B_Y+B_CO2))

***4.非径向、投入导向、权重:(1 1 0 0),方向向量:（-K -L 0 0)
use example,clear
gen gK = -K
gen gL = -L
gen gY = 0
gen gCO2 = 0
matrix wmatrix = (1,1,0,0) //投入导向时，产出无需调整，对应的权重只能为0，否则出错；
teddf K L= Y: CO2, dmu(Province) time(year) gx(gK gL) gy(gY) gb(gCO2) nonr wmat(wmatrix) sav(ex.teddf.nonr.inputs.wmat.result,replace)
use ex.teddf.nonr.inputs.wmat.result, clear
gen theta7 = 1-1/2*(B_K+B_L)
//非径向：权重向量和方向向量要对应，投入导向，产出不变，所以各项产出对应的权重为0；

//gtfpch
use example,clear
egen id=group(Province)
xtset id year
gtfpch K L= Y: CO2, dmu(Province) global sav(ex.gtfpch.result,replace)
gtfpch K L= Y: CO2, dmu(Province) nonr global sav(ex.gtfpch.nonr.result,replace)

*******************************Simar-Wilson两阶段半参数DEA-simarwilson***********************
/*
https://www.lianxh.cn/news/4f3958c242957.html
findit simarwilson
ssc install simarwilson

simarwilson [(outputs = inputs)] [depvar] indepvars [if] [in] [weight] [, options]

其中，主要变量如下：
outputs 代表生产数据集的产出变量;
inputs 代表投入变量，数据均为非负变量，并且投入和产出变量数量不得超过决策单元的数量；
depvar 为指定的被解释变量-效率值，该度量将作为因变量进入回归模型。simarwilson 期望 depvar 是一种径向效率，效率范围在(0,1]区间或[1,+∞)区间。如果 depvar 的某些值小于1，而其他值超过1，则 simarwilson 会发出警告，并根据指定 nounit 的方式忽略观察值；
indepvar 表示解释变量。解释变量和被解释变量均不允许使用带有时间序列运算符等，如 L. 或 F.。

options 主要包括：
algorithm(1|2) 指定命令使用算法 1 还是算法 2。为了计算经偏差校正的效率值，算法 2 涉及 bootstrap DEA 的引导程序。算法 2 要求指定 (output=inoput1 input2 input3)。simarwilson 默认值为算法 1；
notwosided 默认命令 simarwilson 应用截断回归模型，无论效率得分在(0,1]区间还是[1,+∞)区间。对于(0,1]内的效率得分，默认使用双向截断回归模型并从双向截断正态分布中抽样。应用 Simar 和 Wilson(2007) 命令时，只考虑[1,+∞)内的效率值，即在没有指定双向的情况下，simarwilson第二阶段的回归模型在面向产出角度和面向投入的效率之间没有区别，因而不建议在算法 2 中使用 notwoside；
rts(crs|nirs|vrs) 指定在哪种假设下对所考虑的生产过程的规模报酬进行技术效率度量，crs 要求规模报酬不变，nirs 要求规模报酬递增，而 vrs 要求可变规模收益。默认值为 rts(vrs)，rts()一般通过 teradial 起作用。如果使用外部估计的效率值，则指定 rts() 无效；
base(output|input) 指定技术效率的径向度量的方向或基数。产出径向角度一般设定为 base(output)，而投入径向角度则设定为 base(input)。默认值为base(output)；
invert 的设定代表是否使用 Shephard 代替 Farrell计 算技术效率。
*/
//相关文章:lianxh dea
//第一步:安装gciget命令导入数据
cd "E:\data"
ssc install gciget,replace
gciget EOSQ048 EOSQ051 EOSQ144, clear  //直接导入数据会提示错误,使用下面命令导入;

gciget EOSQ048 EOSQ051 EOSQ144, clear nowarnings ///
url(https://file.lianxh.cn/data/g/gci_dataset_2007-2017.xlsx)
save gci_dataset_2007-2017.dta,replace //保存到本地,以后可直接使用;
use gci_dataset_2007-2017,clear

//第二步:合并数据
copy "https://file.lianxh.cn/data/p/pwt90.dta" pwt90.dta //copy到本地,以后可直接使用;
quietly merge 1:1 countrycode year using pwt90.dta

//第三步:生成范例数据,使用teradial命令计算DMU的DEA值
help teradial
quietly generate regu = EOSQ048[_n-1] if countrycode == countrycode[_n-1]
quietly generate prop = EOSQ051[_n-1] if countrycode == countrycode[_n-1]
quietly generate judi = EOSQ144[_n-1] if countrycode == countrycode[_n-1]
quietly generate lpop = ln(pop[_n-1]) if countrycode == countrycode[_n-1]
order year cnNumber countrycode EOSQ* regu prop judi lpop
global g_list "regu prop judi"
global z_list "regu prop judi lpop c.regu#c.lpop c.prop#c.lpop c.judi#c.lpop"
set level 90    			// 90%置信区间
set seed 341566575
teradial rgdpo = ck emp hc if year == 2014 & regu !=. & prop !=. & judi !=. ///
    & lpop !=., tename(te_vrs_o) rts(vrs) base(output) noprint

//第四步:查看主要指标描述统计结果
ereturn list
sum te_vrs_o regu prop judi lpop if e(sample) //描述if条件后的样本特征



//分别使用reg,tobit和truncreg回归
reg te_vrs_o $z_list
reg te_vrs_o $z_list,nolstretch vsquish
//tobit估计,归并
tobit te_vrs_o $z_list, ll(1) nolstretch vsquish
//vsquish: suppress blank space separating factor variables or time-series variables
//nolstretch: do not automatically widen coefficient table for long variable names
margins, dydx($g_list) predict(ystar(1,.)) post
estimates store tobit

//truncreg估计,断尾:会删除 te_vrs_o = 1 的观测值
truncreg te_vrs_o $z_list, ll(1) nolstretch vsquish
qui margins, dydx($g_list) predict(e(1,.)) post
estimates store truncreg

//simarwilson估计
//对比 tobit 和 truncreg 的结果发现部分指标显著性存在较大差异，相关统计结论存在矛盾。作者进而使用simarwilson, algorithm(1)。由于外部估计的效率值已可得，因此并未选择 algorithm(2) 重新测算决策单元DEA。
simarwilson te_vrs_o $z_list, reps(2000)
quietly margins, dydx($g_list) post
estimates store alg_1

//同样，作者也使用了 algorithm(2) 进行对比：通过设定产出变量与投入变量命令 (rgdpo = ck emp hc)，以及规模报酬设定 rts(vrs) base(output)，计算偏差校正的效率值，结果保存为 tebc(tebc_vrs_o)。作者选择在偏差校正程序中进行 1000 次抽样，高于 Simar 和 Wilson (2007) 中建议的默认值 algorithm(1)。在此过程中，使用偏差校正后的效率值仅会对估计系数和相关的估计置信区间产生中等程度的影响。
drop tebc_vrs_o
simarwilson (rgdpo = ck emp hc) $z_list if year == 2014, algorithm(2) rts(vrs) ///
	base(output) reps(2000) bcreps(1000) tebc(tebc_vrs_o)
quietly margins, dydx($g_list) post
estimates store alg_2

//为了定性地解释结果，作者列示了相关指标估计的平均边际效应。
estimates table tobit truncreg alg_1 alg_2, title(Estimated mean marginal effects) p

//特殊情形的估计结果:
//作者使用 Shephard 距离函数代替 Farrell 距离函数计算技术效率的估计结果。
simarwilson (rgdpo = ck emp hc) $z_list if year == 2014, algorithm(2) rts(vrs) ///
	base(output) reps(2000) bcreps(1000) invert
quietly margins, dydx($g_list) post
estimates store alg_2_inv

//技术效率值的范围分布于(0,1]和[1,∞)估计情形。
simarwilson (rgdpo = ck emp hc) $z_list if year == 2014, algorithm(2) rts(vrs) ///
	base(output) reps(2000) bcreps(1000) invert notwosided

//图示边际效应:作者的Stata命令也给出了绘制指标的边际效应代码，为节省篇幅不在此处展示，感兴趣的读者可以尝试绘制相关指标的边际效应。
local h_list "$g_list lpop"
foreach h of varlist `h_list'{
   quietly sum `h' if e(sample)
   local mymin = r(min)*0.98
   local myxmin = ceil(`mymin')
   local mymax = r(max)*1.02
   local myxmax = floor(`mymax')
   local mystep = (`mymax'-`mymin')/25
   foreach g of varlist `h_list'{
     local r_list : list h_list - h
     quietly margins if e(sample), dydx(`g') at(`h' = (`mymin' (`mystep') `mymax')   ///
	(asobserved) `r_list')
     quietly marginsplot, xlabel(`myxmin' (1) `myxmax') recast(line) recastci(rarea) ///
	scheme(s2manual)
     quietly graph export "simarwilson2`g'_`h'.eps", as(eps) preview(off) replace    ///
	fontface(Times)
  }
}








