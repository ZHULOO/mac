***stata15空间计量***
***Three types of Sp data
    *	data with shapefiles,
    *	data without shapefiles but including location information, or
    *	data without shapefiles or location information.

    *ID variables for crosssectional data 截面数据
    	sort area_name
    	generate id = _n //生成个体ID
    *ID variables for panel data 面板数据
    	egen area_id = group(area_name)
help sp
help spmatrix
***从shapefile创建stata格式,以美国为例：
    cd E:\data\shapefile\
    cdout
    *step 2: Translate the shapefile
    unzipfile tl_2016_us_county.zip //解压缩
    spshape2dta tl_2016_us_county   //生成dta格式数据"tl_2016_us_county_shp.dta"和"tl_2016_us_county.dta"
    	                            //spshape2dta将地图文件中的shp和dbf格式的文件，转换为.dta和_shp.dta两个数据集，二者是关联的。
    *step 3: Look at the data
    use tl_2016_us_county_shp.dta,clear //shp文件只含有_ID,_X,_Y等地图信息变量,轮廓和位置;
    browse
    use tl_2016_us_county.dta, clear  //含有_ID,_CX,_CY,NAME等变量,和上面的shp有关联，_ID是是关联变量，共3233个counties，但不是要研究的数据表示法；
    br                               //需要按照研究的样本个体ID生成一个关联变量fips，以便于合并。
    *step 4: Create standard ID variable
    generate long fips = real(STATEFP + COUNTYFP) //real函数转化为数字或缺失值，生成fips变量；
    bysort fips: assert _N==1                     //assert验证是否满足某些条件，按fips排序，确保每个fips对应一个obs
    assert fips != .                              //确保fips变量不存在缺失值
    *step 5: Tell Sp to use standard ID variable
    order _ID fips
    spset fips, modify replace                    //用fips做个体识别变量生成新的_ID变量，shp里的_ID也相应修改了,tl_2016_us_county.dta和tl_2016_us_county_shp.dta依然关联;
    *step 6: Set coordinate units
    spset, modify coordsys(latlong, miles)        //需要根据经纬度换算为miles或者kilometers
    save,replace                                  //保存数据集tl_2016_us_county.dta
**下面把我们要研究的数据和上面生成的shapefile stata格式的数据合并起来：
    *截面数据：
    copy http://www.stata-press.com/data/r15/texas_ue.dta texas_ue.dta,replace
    use texas_ue.dta,clear
    br
    merge 1:1 fips using tl_2016_us_county.dta    //截面数据的合并1：1，上面处理的tl_2016_us_county.dta和研究数据texas_ue.dta合并起来；
                                                  //实际上，相当于将tl_2016_us_county.dta中代表位置的变量和_ID、_CX和_CY合并到研究数据中。
    keep if _merge==3
    drop _merge
    rename NAME countyname
    drop STATEFP COUNTYFP COUNTYNS GEOID
    drop NAMELSAD LSAD CLASSFP MTFCC CSAFP
    drop CBSAFP METDIVFP FUNCSTAT
    drop ALAND AWATER INTPTLAT INTPTLON
    save texas_ue_map.dta,replace                 //保存合并入位置信息的研究数据为texas_ue_map.dta
    *另外一个截面数据的案例：
    copy http://www.stata-press.com/data/r15/project_cs.dta project_cs.dta,replace
    use project_cs.dta,clear
    merge 1:1 fips using tl_2016_us_county.dta
    keep if _merge == 3
    drop _merge
    save project_cs_map.dta,replace

**面板数据：
    copy http://www.stata-press.com/data/r15/project_panel.dta project_panel.dta,replace
    use project_panel.dta,clear
    xtset fips time
    spbalance
    merge m:1 fips using tl_2016_us_county.dta
    keep if _merge == 3
    drop _merge
    save project_panel_map.dta,replace
    spset
    xtset //依然是面板数据


***空间计量的一般过程***
    cd E:\data\shapefile\
    use texas_ue_map.dta,clear
    describe               //整体看一下数据
    summarize unemployment //看一下unemployment变量的
    grmap,activate         //需要先激活grmap模式，help spmap看spmap命令
    grmap unemployment     //根据unemployment变量画地图上的热力图
    regress unemployment college //先进行OLS，结果很显著，进一步检验残差项是否存在空间自相关，the Moran test；
    spmatrix create contiguity W //根据是否共享边界生成近邻矩阵W
    spmatrix dir
    estat moran,errorlag(W)      //the moran test,检验残差是否空间自相关，空间权重矩阵为W，p=0，拒绝无空间自相关的原假设，认为残差存在空间自相关
    spregress unemployment college,gs2sls //此时没有指定空间权重矩阵，虽是空间命令spregress，但结果和regress近似；
    spregress unemployment college,ml
    *加入空间滞后的因变量Wy，分别进行gs2sls和ml回归：
    spregress unemployment college,gs2sls dvarlag(W) //dvarlag(W)空间滞后的因变量，
    spregress unemployment college,ml dvarlag(W)     //gs2sls方法更稳健，速度也快; ml方法需要残差的正态性假设，可以加vce(robust)选项，但是比较耗时；
    *对此模型的解释：
    estat impact //该命令报告直接和间接效应，y的变化除了来自x，也有Wy中的影响，Wy的影响可以细分为直接和间接影响：
    //结果如下：
    progress   :100%

    Average impacts                                 Number of obs     =        254

    ------------------------------------------------------------------------------
                 |            Delta-Method
                 |      dy/dx   Std. Err.      z    P>|z|     [95% Conf. Interval]
    -------------+----------------------------------------------------------------
    direct       | //直接效应，来自于本地区x变量的影响
         college |  -.0907613   .0128641    -7.06   0.000    -.1159745   -.0655482
    -------------+----------------------------------------------------------------
    indirect     | //间接效应：来自于其它地区的y的影响
         college |  -.0368846   .0109843    -3.36   0.001    -.0584133   -.0153558
    -------------+----------------------------------------------------------------
    total        | //总效应=直接效应+间接效应
         college |  -.1276459   .0196293    -6.50   0.000    -.1661186   -.0891733
    ------------------------------------------------------------------------------
    gen unemp100  = unemployment*100             //因变量乘以100，再进行回归，观察对回归系数的影响；
    spregress unemp100 college,gs2sls dvarlag(W) //100*y进行回归和前面的回归系数对比，β1变成100倍，β2是Wy的系数不变；
    estat impact                                 //但是估计的直接和间接效应增加了100倍；

    *加入空间滞后的自变量Wx，进行gs2sls回归：
    spregress unemployment college,gs2sls ivarlag(W:college)
    estat impact //计算直接和间接效应
    //结果如下：
    progress   :100%

    Average impacts //计算的是平均效应，每个地区来自于它自己相邻的地区的间接影响不一样；

    ------------------------------------------------------------------------------
                 |            Delta-Method
                 |      dy/dx   Std. Err.      z    P>|z|     [95% Conf. Interval]
    -------------+----------------------------------------------------------------
    direct       | //直接效应，来自于本地区的x的直接影响
         college |   -.077997   .0138127    -5.65   0.000    -.1050695   -.0509245
    -------------+----------------------------------------------------------------
    indirect     | //间接效应，来自于它相邻地区的x的影响
         college |  -.0715273   .0166314    -4.30   0.000    -.1041243   -.0389303
    -------------+----------------------------------------------------------------
    total        | //总效应
         college |  -.1495243   .0170417    -8.77   0.000    -.1829255   -.1161231
    ------------------------------------------------------------------------------

    *扰动项存在空间自回归的情形，SEM:εi = ρWεj +u
    spregress unemployment college,gs2sls errorlag(W) //误差空间自回归系数ρ=0.77，并且显著
    estat impact //误差空间自相关没有产生间接效应，简介效应为0

    *同时考虑空间滞后因变量、自变量和扰动项空间自相关三种情况,并且有不同的空间权重矩阵W和V的模型：
    spregress y x1 x2,gs2sls dvarlag(W) ivarlag(W:x1 x2) ivarlag(V:x1) errorlag(W)


***空间计量的命令***
    spregress,gs2sls
    spregress,ml
    spivregress
    spxtregress
    spxtregress,re
    spxtregress,fe
    **一般空间命令：
    spregress y x1 x2,gs2sls dvarlag(W) ivarlag(W:x1 x2) ivarlag(V:x1) errorlag(W)
    estat impact //给出平均效应
                 //gs2sls假定误差项是iid，但不必是正态分布的，
                 //heteroskedastic选项，可以放松假定，存在异方差的情况。
    spregress y x1 x2,ml dvarlag(W) ivarlag(W:x1 x2) ivarlag(V:x1) errorlag(W)
                 //ml需要误差项是独立同分布且是正态分布，比较耗时，但是更有效。
                 //如果放松正态性的假定，可以使用vce(robust)选项。
    spivregress y x1 x2 (z = x3),dvarlag(W) ivarlag(W:x1 x2) ivarlag(V:x1) errorlag(W)
                 //也可以使用heteroskedastic选项，处理异方差的情况。
    **工具变量空间回归案例：
        cd E:\data\shapefile\DUI
        copy http://www.stata-press.com/data/r15/dui_southern.dta dui_southern.dta //下载慢或出错，开代理直接复制到浏览器下载
        copy http://www.stata-press.com/data/r15/dui_southern_shp.dta dui_southern_shp.dta
        use dui_southern.dta,clear
        spset
        spmatrix create contiguity W
        spmatrix create idistance M
        spmatrix dir                 //查看当前权重矩阵
        spivregress dui nondui vehicles i.dry (police = elect), dvarlag(W) errorlag(W)
        estat impact
        spivregress dui nondui vehicles i.dry (police = elect), dvarlag(W) errorlag(W) ivarlag(W: i.dry)
        estat impact
        spivregress dui nondui vehicles i.dry (police = elect), dvarlag(W) errorlag(W) ivarlag(W: i.dry) dvarlag(M) errorlag(M) ivarlag(M: i.dry)
    **面板数据空间回归，案例在最后：
    spxtregress y x1 x2,re dvarlag(W) errorlag(W) ivarlag(M:x1 x2)
    spxtregress y x1 x2,re sarpanel dvarlag(W) errorlag(W) ivarlag(M:x1 x2)
                 //sarpanel
    spxtregress y x1 x2,fe dvarlag(W) errorlag(W) ivarlag(M:x1 x2)

    regress y x1 x2
    estat moran,error(W) error(M)
                 //莫兰检验，随机误差项是否存在空间自相关，原假设：无空间自相关。

***莫兰检验案例：
    cd e:\data //先复制案例数据
    copy http://www.stata-press.com/data/r15/homicide1990.dta homicide1990.dta
    copy http://www.stata-press.com/data/r15/homicide1990_shp.dta homicide1990_shp.dta
    use homicide1990.dta,clear
    spset     //定义空间数据，看是否关联_shp.dta数据，结果如下：
        Sp dataset homicide1990.dta
                    data:  cross sectional      //截面数据
         spatial-unit id:  _ID                  //关联变量_ID
             coordinates:  _CX, _CY (planar)    //坐标信息
        linked shapefile:  homicide1990_shp.dta //和_shp.dta关联
    grmap hrate
    spmatrix create contiguity W                //创建空间权重矩阵，共有边界定义的W
    regress hrate                               //只对y进行回归
    estat moran,errorlag(W)
    spmatrix create idistance M                  //创建距离倒数的空间权重矩阵M
    estat moran,errorlag(W) errorlag(M)          //联合检验任意权重矩阵下是否存在空间自相关
    reg hrate ln_population ln_pdensity gini     //一般线性回归后，莫兰检验
    estat moran,errorlag(W)                      //拒绝原假设，存在空间自相关，估计SEM
    spregress hrate ln_population ln_pdensity gini,gs2sls errorlag(W)
        //spregress不能简写

***检验数据是否空间平衡面板 spbalance
    xtset ID time //spbalance之前首先使用xtset命令
    spbalance     //是否平衡
    spbalance,balance //drop obs使得平衡，此时drop掉的是按时间time判断的，如果有个体不存在某个年份，则这个年份的obs全部drop
    *但是一些个体分别存在一些间断的time，则最后所有time的obs都drop了，解决办法：
        cd E:\data\shapefile\america
        spshape2dta County_2010Census_DP1
        use County_2010Census_DP1.dta, clear
        copy http://www.stata-press.com/data/r15/cbp05_14co.dta cbp05_14co.dta
        use cbp05_14co, clear
        merge m:1 GEOID10 using County_2010Census_DP1
        keep if _merge ==3
        drop _merge
        save cbp05_14co_map.dta,replace
        xtset _ID year    //先设置面板数据
        spbalance         //提示数据not strongly balanced
        spbalance,balance //强制平衡，删除了2005-2009年间的所有obs，原因是只有一个个体，只有5年的数据
        use cbp05_14co_map.dta,clear
        order _ID year
        bysort _ID:gen npanel = _N //记住此命令，根据_ID,产生一个新变量npanel等于每个个体的obs
        order npanel
        tabulate npanel            //统计npanel的情况，都等于10，只有5个等于5的，找出它
        list _ID state NAMELSAD10 year npanel if npanel!=10 //将个体年数不等于10的个体显示出来，只有一个县是5年，删除它
        drop if _ID == 400 //删除了只有5年的个体，面板数据就平衡了
        xtset _ID year
        spbalance
        disp `r(balanced)' //r(balanced)返回值为1，则数据是平衡的，否则非平衡

***生成感兴趣的子样本，保存数据后使用spcompress命令，则会对应生成响应的_shp.dta文件，而原来的dta数据不变
    cd E:\data\shapefile
    use tl_2016_us_county.dta,clear
    keep if STATEFP =="48" //生成STATEFP=48的样本子集,共254个obs
    save texas.dta,replace //保存数据，后使用spcompress
    spcompress //texas.dta保存，并生成响应的texas_shp.dta文件，而原来的tl_2016_us_county.dta和tl_2016_us_county_shp.dta数据不变；

***计算两个_ID之间的平面距离
    spdistance 48021 48041 //参数为两个ID的编号，以平面坐标系统计算的
    spset,modify coordsys(latlong,kilometers) //sp假设是平面坐标系统，转换为经纬度系统，并以km表示距离





***按province34.dta地图格式整理中国2007年34个地区的GDP数据
    cd E:\data\shapefile\china\province34
    cd E:\data\shapefile\china\province34\数据备份
    copy "E:\学术论文\Data\govern expenditures\zongshuju.dta" zongshuju.dta,replace
    use zongshuju.dta,clear
    egen area_id = group(area)
    order area_id          //需要修改各地区对应的数字编码,修改为excel按首字母排序，因为要合并的地图文件时按首字母排序的。
    sort area_id year
    rename area_id _ID
    keep _ID area year gdp //全部删除，只保留gdp一个指标，用来画图，
    keep if year ==2007    //只保留2007年的横截面数据，然后手动添加港澳台地区
    save huizong.dta,replace
    use huizong.dta,replace //34个按首字母排序的省份gdp数据已准备好

***整理包含港澳台地区的34个区域的地图 province34.dta/province34_shp.dta
    cd E:\data\shapefile\china\province34
    spshape2dta 省级行政区,saving(province34)

    use province34.dta,clear                   //大致浏览一下数据,34个地区，包含港澳台，但是有乱码，需要转码
    clear                                    //转码前先clear
    unicode encoding set gb18030
    unicode translate province34.dta,transutf8 // 直接对源文件转码操作
    unicode erasebackups,badidea
    use province34.dta,clear //对省重新编码
        //统一区域变量area，各省名称统一
    rename NAME area
    keep _ID _CX _CY Z120401 DZM area //删除其它无关变量，然后修改名称为全称
    replace area = area+"省"     //所有地区加上“省”字
    replace area= "北京市" if area == "北京省"
    replace area= "天津市" if area == "天津省"
    replace area= "上海市" if area == "上海省"
    replace area= "重庆市" if area == "重庆省"
    replace area= "内蒙古自治区" if area == "内蒙古省"
    replace area= "宁夏回族自治区" if area == "宁夏省"
    replace area= "广西壮族自治区" if area == "广西省"
    replace area= "新疆维吾尔自治区" if area == "新疆省"
    replace area= "西藏自治区" if area == "西藏省"
    replace area= "香港" if area == "香港省"
    replace area= "澳门" if area == "澳门省"
    replace area= "台湾" if area == "台湾省"
    gen fips =_n                //然后手动直接修改fips为自己已有的研究数据，顺序
    bysort fips: assert _N==1
    spset fips,modify replace //按照fips关联，生成新的_ID变量
    rename area name          //与研究数据中的area变量重名，合并时出错，所以修改为name
    rename DZM code
    save province34.dta,replace
    use province34.dta,replace
    spset

***合并地图文件到截面数据***
    use huizong.dta,replace
    merge 1:1 _ID using province34.dta  //用对应的_ID变量和地图文件合并
    keep if _merge==3
    drop _merge              //合并以后的文件依然和province34_shp.dta保持关联
    save huatu34.dta         //先保存为画图专用，此处不要加replace，后面生成的子文件才会关联
    spcompress               //为huatu34生成对应的huatu34_shp.dta文件，而不修改原来的province34.dta和province34_shp.dta文件。
                             //此时生成了hautu34.dta和huatu34_shp.dta文件，可以为以后作图专用。
    spset                    //可以看到hautu34.dta和huatu34_shp.dta文件已关联，内存中暂时关联，再次打开和源文件关联
    clear
    use huatu34.dta,clear    //再次打开已经和huatu34_shp.dta失去关联，只是生成的瞬间在内存中时关联的
    spset                    //再次打开整理后spcompress生成的hautu34.dta数据，看是否和huatu34_shp.dta关联
    grmap gdp                //尝试画图看是否存在问题
        //复制到pic34文件夹,重新建立关联
    cd E:\data\shapefile\china\pic34
    use huatu34.dta,clear
    spset,modify shpfile(huatu34_shp) //二者建立关联,关联后要保存！！！
    save huatu34.dta,replace
    grmap gdp                         //已关联成功


*****案例：空间面板*****

**面板数据必须平衡才可以使用spxtregress命令:
// 1.不平衡
cd e:\data 
use unbalance_basic.dta,clear
spset
spxtregress gdp first_ind_p pop employee_transport,dvarlag(W) fe
// 2.平衡
cd e:\data 
use balance_basic.dta,clear
spset
spxtregress gdp first_ind_p pop employee_transport,dvarlag(W) fe

**一般案例:
    cd e:\data
    copy http://www.stata-press.com/data/r15/homicide_1960_1990.dta homicide_1960_1990.dta //数据复制到本地当前文件夹
    copy http://www.stata-press.com/data/r15/homicide_1960_1990_shp.dta homicide_1960_1990_shp.dta
    use homicide_1960_1990,clear
    use homicide_1960_1990_shp.dta,clear    //确定数据都下载到文件夹下面了
    xtset _ID year                          //先定义面板数据
    spset                                   //再定义空间数据，看同路径下是否关联_shp.dta的文件
**随机效应：
    *先用一般面板xtreg命令建立随机效应模型：
    xtreg hrate ln_population ln_pdensity gini i.year,re //非空间命令回归结果为后边空间结果做对比
    *先生成相邻权重矩阵
    spmatrix create contiguity W if year ==1990 //取面板数据的任一年生成相邻权重矩阵，默认已标准化
    spmatrix dir
    spmatrix summarize W 
    *因变量空间滞后、扰动项空间自回归模型：
    spxtregress hrate ln_population ln_pdensity gini i.year,re dvarlag(W) errorlag(W)
    *估计gini变量的直接和间接效应
    estat impact gini
    *生成距离倒数矩阵M
    spmatrix create idistance M if year ==1990
    spmatrix dir //生成的权重矩阵都保存在内存中，此命令可显示内存中所有的已生成的权重矩阵；
    spmatrix summarize M 
    *看gini的影响是否随时间发生变化，加入与时间虚拟变量的交互项：
    spxtregress hrate ln_population ln_pdensity c.gini#i.year,re dvarlag(M) error(M)
    spxtregress hrate ln_population ln_pdensity c.gini##i.year,re dvarlag(M) error(M)
        //两个##号表示，gini和i.year,以及他们的交互项都加入了回归。
-------------------------------------------------------------------------------
        hrate |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
--------------+----------------------------------------------------------------
hrate         |
ln_population |   .7908003   .1764818     4.48   0.000     .4449023    1.136698
  ln_pdensity |  -.1223671    .166526    -0.73   0.462     -.448752    .2040178
         gini |   17.82039   4.278774     4.16   0.000     9.434147    26.20663
              | //两个#表示：gini、 i.year和gini#i.year的系数都估计了
         year |
        1970  |  -2.456656   2.303066    -1.07   0.286    -6.970582     2.05727
        1980  |  -9.470622   2.501527    -3.79   0.000    -14.37352    -4.56772
        1990  |  -22.81817   2.528689    -9.02   0.000    -27.77431   -17.86203
              |
  year#c.gini |
        1970  |   6.664314   6.130435     1.09   0.277    -5.351118    18.67975
        1980  |   24.86122   6.715024     3.70   0.000     11.70002    38.02242
        1990  |   57.40946   6.691097     8.58   0.000     44.29515    70.52376
              |
        _cons |  -11.17804   2.061042    -5.42   0.000    -15.21761   -7.138476
--------------+----------------------------------------------------------------
M             |
        hrate |    .694492   .0496075    14.00   0.000     .5972631    .7917209
      e.hrate |   1.950078   .0513563    37.97   0.000     1.849421    2.050735
--------------+----------------------------------------------------------------
     /sigma_u |   2.696022   .1147302                      2.480277    2.930533
     /sigma_e |   5.645628   .0618616                      5.525674    5.768186
-------------------------------------------------------------------------------
Wald test of spatial terms:          chi2(2) = 1711.10    Prob > chi2 = 0.0000
    //wald检验：拒绝原假设，则认为空间滞后项系数显著不为0。

    *检验交互项是否显著：
    contrasts c.gini#year
    *计算各年份的gini的直接和间接效应：
    estat impact gini if year ==1960
    estat impact gini if year ==1960
    estat impact gini if year ==1960
**带sarpanel选项的随机效应模型：
    spxtregress hrate ln_population ln_pdensity c.gini##i.year,re sarpanel dvarlag(M) error(M)
**固定效应：
    *先估计无空间效应的一般固定效应模型：
    xtreg hrate ln_population ln_pdensity gini,fe
    *带空间滞后因变量的固定效应模型：
    spxtregress hrate ln_population ln_pdensity gini,fe dvarlag(M)
    *fe不能加入i.year变量，因为固定效应每个个体的i.year不同，但是可以加入交互项
    spxtregress hrate ln_population ln_pdensity c.gini#i.year,fe dvarlag(M) errorlag(M)
    *计算直接和间接效应
    estat impact

export excel using "gdp.xlsx",replace firstrow(variables)


*****空间权重矩阵*****
help sp
spmatrix dir            //列出所有权重矩阵
spmatrix drop           //删除某一权重矩阵
spmatrix clear          //删除所有权重矩阵
spmatrix copy           //复制权重矩阵为新名称
spmatrix export         //导出权重矩阵为.txt格式
spmatrix import         //导入权重矩阵
spmatrix note           //给权重矩阵设置备注
spmatrix save           //保存权重矩阵为stata格式(.stswm格式)
spmatrix summarize      //权重矩阵细节
spmatrix use            //使用save的权重矩阵(.stswm格式)
spmatrix create         //根据shp或者loc变量生成权重矩阵,contiguity(相邻),idistance(距离倒数)
spmatrix userdefined    //用户自定义生成权重矩阵
spmatrix matafromsp     //矩阵导入mata环境
spmatrix spfrommata     //mata运算后生成权重矩阵
spmatrix normalize      //标准化,spectral(默认),row,minmax
spmatrix fromdata       //导入stata数据表中的数据生成权重矩阵
*****自行导入已有权重矩阵:
cd "E:\data"
import excel using "经济地理矩阵.xlsx",case(lower) first clear
br
drop jt
drop in 279
gen code = _n
order code
spset code                                                  //会利用code生成_ID变量,对比它们,一摸一样;
order code _ID
spmatrix fromdata W = city1-city278,normalize(none)         //导入权重矩阵, 不标准化,导入前需要spset命令
spmatrix dir 
spmatrix summarize W
spmatrix export W using 经济地理矩阵.txt                     //导出权重矩阵,以txt格式保存
spmatrix import W1 using 经济地理矩阵.txt                    //导入已保存的txt格式
spmatrix dir 
spmatrix summarize W1

spmatrix drop W
spmatrix normalize W, normalize(row)                        //行标准化矩阵
spmatrix normalize W, normalize(spectral)                   //默认除以最大特征值标准化
spmatrix normalize W, normalize(minmax)                     //最小最大值标准化矩阵

*****mata命令运算:将矩阵导入mata运算,再导出
spmatrix matafromsp Ma id = W                               //将上面的权重矩阵W复制进mata,生成Ma矩阵, id = W

mata
for (i=1; i<=rows(Ma); i++) {
    for (j=1; j<=cols(Ma); j++) {
        if (Ma[i,j] >= 1000) Ma[i,j] = 500                   //矩阵中大于1000的值都修改为500
    }
  }
end

spmatrix spfrommata C = Ma id, normalize(none) replace       //经过mata语言运算过的数据再生成权重矩阵C
spmatrix dir 
spmatrix summarize W //比较W和C,mata运算前后变化
spmatrix summarize C
spmatrix save W using weight

*****userdefined权重矩阵
use balance_basic.dta,clear
mata
function SinvD(vi, vj)                       //表示第i个个体和第j个个体之间的距离,vi表示第i个个体的指标向量
{
    return(1/sqrt( (vi-vj)*(vi-vj)' ) )
}
end
spmatrix userdefined Wuser = SinvD(gdp) if year == 2005,replace normalize(none) //使用人均gdp差的平方算术平方根的倒数生成权重矩阵
spmatrix userdefined Wuser = SinvD(gdp gdp_p pop) if year == 2005,replace normalize(none) //使用gdp_p,gdp和pop三维坐标距离的倒数生成权重矩阵
spmatrix dir
spmatrix summarize Wuser
spmatrix save Wuser using Muser.stswm
spmatrix export Wuser using Muser.txt
spmatrix export Wuser using Muser.dta //不能
spmatrix save W using w.dta //不能
spmatrix use Wuser using Muser.stswm

**************************准备数据*******************************
/* 
1.对于有shapefiles的数据可以直接生成距离权重矩阵和相邻矩阵（需要shp文件）;
2.对于没有shp文件而有locations:(_CX,_CY)的数据可以直接生成距离矩阵,而不能生成相邻矩阵;
3.对于没有shp和locations的数据,可以自定义mata函数计算相应距离权重矩阵,例如经济距离矩阵;
4.如果是面板数据,必须要平衡面板,不是平衡面板spset,spxtregress命令无法使用;
*/

*****一、with shapefiles 
cd "E:\data"
//先将数据拷贝到本地:
copy https://www.stata-press.com/data/r17/project_cs.dta project_cs.dta,replace
copy https://www.stata-press.com/data/r17/project_panel.dta project_panel.dta
//截面数据
//直接将project_cs.dta与tl_2016_us_county.dta(自带tl_2016_us_county_shp.dta数据)合并:
use project_cs.dta,clear
use tl_2016_us_county.dta,clear
merge 1:1 fips using tl_2016_us_county.dta
keep if _merge==3
drop _merge
spset
spmatrix create contiguity Wc   //截面数据可以直接创建相邻权重矩阵
spmatrix create idistance Wd    //距离倒数矩阵
//面板数据
use project_panel.dta,clear
xtset fips time
spbalance
merge m:1 fips using tl_2016_us_county
keep if _merge==3
drop _merge
spset
//然后可以使用一下命令创建空间权重矩阵
spmatrix create contiguity Wc if time == 1   //面板数据需要使用某一年份的截面数据生成权重矩阵;
spmatrix create idistance  Wd  if time == 1              

*****二、with locations no shapefiles
//截面数据
//先生成只有locations没有shp的数据project_cs3.dta
copy project_cs.dta project_cs2.dta,replace   //copy生成新数据后,和shp文件的关联还在
use project_cs2,clear
spset
keep fips _CX _CY ALAND               //删除其它无关变量，_ID被删除后和shp文件的关联就没有了
keep in 1/250
rename (_CX _CY) (longitude latitude)
spset                                 //此时没有shp关联了
save project_cs3,replace              //project_cs3.dta只有locations(longitude,latitude),没有shp;
//利用locations信息生成权重矩阵
use project_cs3,clear
assert fips != .                      //看fips变量是否有缺失值
bysort fips:assert _N == 1            //看fips是否有重复值
spset fips,coord(longitude latitude)  //利用logitude和latitude变量生成标准的_CX和_CY位置信息变量,fips生成_ID变量,默认生成planar格式;坐标与经纬度(_CX横坐标,对应经度);
spset,coordsys(latlong miles)         //planar格式修改为latlong格式,单位为miles
spmatrix create idistance Wd          //此时可以直接应用坐标生成地理距离矩阵,无法生成相邻矩阵,因为没有shp信息;

//面板数据
//先生成面板数据,只有locations没有shp
copy project_panel.dta project_panel2.dta,replace
use project_panel2,clear
merge m:1 fips using project_cs2.dta  //将project_cs2中的locations信息合并进来;
keep fips state time _CX _CY ALAND
keep in 1/250
rename (_CX _CY) (longitude latitude)
spset
save project_panel3,replace           //已生成只有locations(longitude,latitude)没有shp的数据
//使用只含有locations信息的面板数据,要先平衡后才能再生成距离矩阵;
use project_panel3,clear
assert fips != .
assert time != .
bysort fips time:assert _N == 1       //每个fips和time只出现一行;
bysort fips time:gen assert_N = _N    //看一下每个地区内每个time出现的次数;
xtset
xtset,clear
xtset fips time
spset fips
spbalance                             //不平衡
bysort fips:gen npanel = _N           //每个fips下有多少行
tabulate npanel                       //发现一个等于1的
drop if npanel != 3
spbalance
drop npanel
xtset fips time
bysort fips time :assert longitude == longitude[1]
bysort fips time :assert latitude == latitude[1]  //确保同一地区不同时间的位置信息是一样的
spset fips,coord(longitude latitude)              //利用logitude和latitude变量生成标准的_CX和_CY位置信息变量,fips生成_ID变量,默认生成planar格式;
spset,modify coordsys(latlong)
spmatrix create idistance Wd if time == 1
spmatrix dir

*****三、no locations no shapefiles
//此时无法生成矩阵,关联外部矩阵或者自行计算经济距离等矩阵;


*****四、空间权重矩阵和莫兰散点图
***关于空间计量的各类软件
* stata回归很方便，数据和画图等处理不是很方便
* R语言spdep包 
* python中pySALbao
* GeoDa软件 
*** 以上几种软件的数据格式及相应操作



cd "E:\BaiduNetdiskWorkspace\郑大"
use data_geff_agglo,clear
//生成空间矩阵:
//距离倒数矩阵W:
spmatrix create idistance W if year == 2005,replace
spmatrix dir
spmatrix summarize W
//经济距离:
mata
function SinvD(vi, vj)                       //表示第i个个体和第j个个体之间的距离,vi表示第i个个体的指标向量
{
    return(1/sqrt( (vi-vj)*(vi-vj)' ) )
}
end
//使用人均gdp差的平方算术平方根的倒数生成经济矩阵Wecon
spmatrix userdefined Wecon = SinvD(gdp_sp) if year == 2005,replace 
/*使用gdp和pop二维坐标距离的倒数生成权重矩阵
spmatrix userdefined Wuser = SinvD(gdp pop) if year == 2005,replace
*/
spmatrix dir
spmatrix summarize Wecon
spmatrix save W using W.stswm          //stswm,stata专用权重矩阵格式；
spmatrix save Wecon using Wecon.stswm  //输出保存为stata空间权重矩阵格式；
spmatrix export W using W.txt
spmatrix import W1 using W.txt

//spatgsa命令计算莫兰、吉尔里、Go指数：无法使用spmatrix格式的矩阵直接计算，需要先转化为stata数据表格式的一般矩阵格式再计算，
//借助于matafromsp转换为一般矩阵格式
spmatrix use W using W.stswm
spmatrix dir
spmatrix matafromsp W id = W  //将W读入mata,再用get转换为stata变量
clear
getmata (city*)=W             //输出到stata数据
save W.dta,replace
//全局空间自相关指数
//转化为.dta格式矩阵后计算Getis-Ord指数时出错,需要W为0,1相邻矩阵;
spatwmat using W.dta,name(W) 
spatwmat using W.dta,name(SW) standardize
matrix list W

keep if year == 2005
spatgsa geff,weights(W) moran geary twotail
//局部空间自相关指数
spatlsa geff,weights(SW) moran graph(moran) twotail savegraph(moran2005.png) //这里莫兰散点图黑色背景很难看，借助于其它工具python，R，GeoDa等工具画图；
//有几种思路：
//1.stata直接画莫兰散点图，黑色背景，无法调格式很难看；
//2.python中借助geopandas转换为shp格式，后直接使用pysal库画图或回归等操作；
//3.GeoDa软件导入shp格式或者xls格式的数据带（lon，lat）坐表，可以直接进行画图和相关操作；
//4.R语言使用spdep包，导入stata格式的权重数据，也可以直接画图和回归操作；
