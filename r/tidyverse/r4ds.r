#########################R for Data Science#######################
# 第1章 使用ggplot2进行数据可视化
## 1.1 简介
install.packages("tidyverse")
library(tidyverse)
ggplot2::ggplot() # 使用某个包的某个函数
data(package = "dplyr") # 查看包里的数据集
readr_example("challenge.csv") # 返回案例数据集的路径

## 1.2 第一步
### 1.2.1 mpg数据框
ggplot2::mpg  # 使用ggplot2包里的mpg数据框
### 1.2.2 创建ggplot图形
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))
# 创建空白图形，然后使用+号向图形中添加图层；
# 向图形中添加geom_point图层（几何对象函数），每种函数都可以向图中添加不同类型的图层；
# mapping()参数总是与aes()函数成对出现
### 1.2.3 绘图模版

## 1.3 图形属性映射
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
# 图形属性：图中对象的可视化属性，包括数据点的大小、形状和颜色等；
# 上式用class变量的信息反映在数据点的颜色差异上；
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))
# class信息反映在数据点的大小上；
# 还有透明度alpha和形状shape等；
# 函数aes()中将图形属性名称（x、y、color、size、shape）和变量名称（displ、hwl和class等）关联起来；
# 注意和下面color属性的区别，上面color表示数据点的颜色用来表示class变量信息，下面将所有数据点设置为蓝色，在括号外；
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy),
    shape = 1,
    size = 4,
    fill = "blue")
## 1.4 常见问题
## 1.5 分面
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue") +
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue") +
  facet_grid(drv ~ cyl) # 按行列交叉显示数据；

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue") +
  facet_grid(. ~ cyl) # 按列排列显示cyl = 4 5 6 8的数据；

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue") +
  facet_grid(drv ~ .) # 按行显示drv分为三类的情况；

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue") +
  facet_grid(. ~ drv) # 按列显示drv分为三类的情况；
## 1.6 几何对象
geom_point() # 点几何对象
geom_smooth() # 线几何对象
# 同一图里多个几何对象:
# 方法1:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy)) # mapping为局部映射
# 方法2:
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + # mapping为全局映射
  geom_point() +
  geom_smooth(color = "red")
# 如果将mapping放在几何对象函数中，则为局部映射，只对该几何对象有效；
# 而如果将mapping放在ggplot函数中，则为全局映射，对所有图层有效；
# 方法3:
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + # mapping为全局映射
  geom_point(mapping = aes(color = class)) +
  geom_smooth(
    data = filter(mpg, class == "subcompact"),   # 取数据子集画图；
    se = FALSE,
    color = "red")

## 1.7 统计变换
# 画直方图时函数默认会直接自动进行频数统计
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))
# 而如果数据本身已经是频数统计时，可使用：
demo <- tribble(       # 注意tribble与tibble
  ~a, ~b,
  "bar_1", 20,
  "bar_2", 30,
  "bar_3", 25
)
ggplot(data = demo) +
  geom_bar(mapping = aes(x = a, y = b), stat = "identity")
  # 使用identity设置数据为标识，而不再需要先进行频数统计；

# "y = ..prop.."y轴设置为比例，而不是默认的频数；
ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, y = ..prop.., group = 1)
  )
## 1.8 位置调整
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, color = cut))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))

ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = clarity),
    position = "identity" # 默认
    )

ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = clarity),
    position = "fill" # 堆叠
    )

ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = clarity),
    position = "dodge" # 并列
    )
# 多个点重合无法显示时可以设置抖动，将重叠的点通过小的随机扰动（position = "jitter"）都显示出来：
ggplot(data = mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy),
    )

ggplot(data = mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy),
    position = "jitter"
    )
## 1.9 坐标系
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()  # 交换坐标

nz <- map_data("nz")
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black")
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap() # 调整纵横比

bar <- ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = cut),
    show.legend = FALSE,
    width = 1
  ) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)
bar
bar + coord_flip()
bar + coord_polar()
## 1.10 图形分层语法
# 模版包含7个参数，尖括号部分；
# 7个参数一同组成里图形语法；
# 使用这种方法能构建任何图形；
ggplot(data = <DATA>) +          # 1.数据集
  <GEOM_FUNCTION>(               # 2.几何对象
    mapping = aes(<MAPPING>),    # 3.映射集合
    stat = <STAT>,               # 4.统计变换
    position = <POSITION>,       # 5.位置调整
  ) +
  <COORDINATE_FUNCTION> +        # 6.坐标系
  <FACET_FUNCTION>               # 7.分面设置

# 第2章 工作流：基础
## 2.1 代码基础
## 2.2 对象名称
## 2.3 函数调用
y <- seq(1, 10, length.out = 5)
(y <- seq(1, 10, length.out = 5)) # 括号相当于print函数

# 第3章 使用dplyr进行数据转换
## 3.1 简介
### 3.1.1 准备工作
install.packages("nycflights13")
library(nycflights13)
library(tidyverse)
### 3.1.2 nycflights13
nycflights13::flights # 包含了2013年纽约市出发的所有336776次航班的信息
??flilghts
# tibble数据框
### 3.1.3 dplyr基础
filter()      # 筛选，按值筛选
arrange()     # 排序，
select()      # 筛选，按名称选取变量
mutate()      # 使用现有变量的函数创建新变量
summarize()   # 将多个值总结为一个摘要统计量
# 这是5个dplyr的核心函数，工作方式相似：
# 1、第一个参数都是一个数据框
# 2、随后的参数使用数据框中的变量名称
# 3、输出的结果是一个新的数据框
# 还可以联合
group_by()    #改变上面函数的作用范围，整个数据集变为分组
## 3.2 使用filter()筛选行
filter(flights, month == 1, day == 1) # 筛选1月1日的航班
jan1 <- filter(flights, month == 1, day == 1)
### 3.2.1 比较运算符
< <= > >= != ==
### 3.2.2 逻辑运算符
& # 与
| # 或
! # 非
%in% # 包含于
### 3.2.3 缺失值
NA ,not available
is.na() # 判断是否为缺失值
# 注意filter会排除NA
## 3.3 使用arrange()排列行
arrange(flights, year, month, day) # 按year，month，day进行排序
arrange(flights, desc(arr_delay))  # 降序排序，默认升序，缺失值总是排在最后
## 3.4 使用select()选择列
??select
select(flights, year, month)  # 选择year和month列
select(flights, year:day)     # 选择year和day之间的所有列
select(flights, -(year:day))  # 选择非year和day之间的列
# 还可以使用一些辅助函数（正则）筛选：
starts_with("abc")
ends_with("xyz")
contains("ijk")
matches("(.)\\1")   # 有重复字符的变量
num_range("x", 1:3) # 匹配x1，x2，x3
# select还可以重命名，但是丢掉了未重命名的变量，所以一般使用rename重命名
rename(flights, tail_num = tailnum)
select(flights, time_hour, air_time, everything()) # 借助everything函数将time_hour,和air_time移动到前两列
## 3.5 使用mutate()添加新变量
flight_sml <- select(flights,
  year:day,
  ends_with("delay"),
  distance,
  air_time
)

flight_sml

mutate(flight_sml,
  gain = arr_delay - dep_delay,
  speed = distance / air_time * 60
  gain_per_hour = gain / speed
)
flight_sml # 没有改变原数据框, 如果只保留新变量则使用transmute函数
transmute(flight_sml,
  gain = arr_delay - dep_delay,
  speed = distance / air_time * 60,
  gain_per_hour = gain / speed
)
flight_sml 
### 3.5.1 常用创建函数
# 必须是支持向量化运算的函数：
## 算数运算符
+
-
*
/
^
## 整除和求余
%/%
%%
## 取对数
log()
log2()
log10()
## 滞后
lag()
lead()
## 累加
cumsum()
cummin()
cummax()
## 逻辑
>=
!=
## 排秩
min_rank()
row_number()
percent_rank()

## 3.6 使用summarize()进行分组摘要
flights <- nycflights13::flights
summarize(flights, delay = mean(dep_delay, na.rm=TRUE))
# 组合使用group_by()函数实现更多功能
by_day <- group_by(flights, year, month)
flights
by_day 
summarize(by_day, delay = mean(dep_delay, na.rm=TRUE))
### 3.6.1 使用管道组合多
# 1、按照目的地对航班进行分组；
# 2、进行摘要统计，计算距离、平均延误时间和航班数量；
# 3、筛除异常点火奴鲁鲁机场；
by_dest <- group_by(flights, dest) # 1
by_dest
delay <- summarize(by_dest, # 2
  count = n(),
  dist = mean(distance, na.rm=TRUE),
  delay = mean(arr_delay, na.rm=TRUE)
)
delay
delay <- filter(delay, count > 20, dest != "HNL") # 3
delay
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

# 使用管道实现上述三个过程：
delays <- flights %>% 
  group_by(dest) %>%  # 1.分组
  summarize(  # 2.摘要统计
    count = n(),
    dist = mean(distance, na.rm=TRUE),
    delay = mean(arr_delay, na.rm=TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL") # 3.筛选
delay
### 3.6.2 缺失值
# mean函数，当数据有缺失值时，返回缺失值，所以需要na.rm = TRUE
flights %>% 
  group_by(year,month,day) %>% 
  summarize(mean = mean(dep_delay)) # 不处理缺失值时，结果多是缺失值；

flights %>% 
  group_by(year,month,day) %>% 
  summarize(mean = mean(dep_delay, na.rm=TRUE))
# 等价于下面先筛选出非缺失值，再求均值；
not_concelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))  #
not_concelled %>% 
  group_by(year, month, day) %>% 
  summarize(mean = mean(dep_delay))
### 3.6.3 计数
delays <- not_concelled %>% 
  group_by(tailnum) %>% 
  summarize(
    delay = mean(arr_delay)
  )
ggplot(data = delays, mapping = aes(x = delay)) +
  geom_freqpoly(binwidth = 10) # 按飞机尾编号分组计算每架航班的平均延误时间，画密度图；

# 画航班平均延误时间和频数散点图：
delays <- not_concelled %>% 
  group_by(tailnum) %>% 
  summarize(
    delay = mean(arr_delay),
    n = n()
  )
ggplot(data = delays, mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10) # 可以看出平均延误时间与航班数量的关系，当航班数量较少时，平均延误时间变动特别大；
# 通常应该筛选掉那些观测数量较小的分组，可以避免极端值的影响：
delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) +
    geom_point(alpha = 1/10)

# 打击率与击球数之间的关系
install.packages("Lahman")
batting <- as_tibble(Lahman::Batting)
batters <- batting %>% 
  group_by(playerID) %>% 
  summarize(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )
batters %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() +
  geom_smooth(se = FALSE)

batters %>% 
  filter(ab >100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() +
  geom_smooth(se = FALSE)
### 3.6.4 常用摘要函数:mean,sd,IQR,mad,min,quantile,max,first,nth,last,n,n_distinct,count,sum等
not_concelled %>% 
  group_by(year, month, day) %>% 
  summarize(
    n1 = n(),
    n2 = count(flights),
    avg_delay1 = mean(arr_delay), 
    avg_delay2 = mean(arr_delay[arr_delay > 0]), 
    first = min(dep_time),
    last = max(dep_time), 
    first_dep = first(dep_time)
  )
not_concelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time)))  %>% 
  filter(r %in% range(r))

r <- c(1, 2, 3, 4, 9)
range(r)
r %in% range(r) # range(r)显示r的范围
# 计数
not_concelled %>% 
  group_by(dest) %>% 
  summarize(carrier = n_distinct(carrier)) %>% 
  arrange(desc(carrier))

d <- c(1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 6, NA, NA, NA)
n_distinct(d) # 去重后的数量
sum(!is.na(d)) # 非缺失值的数量

not_concelled %>% 
  count(dest)

View(not_concelled)

not_concelled %>%
  count(tailnum, wt = distance)

l <- c(1, 2, 3, 4, 5, 6)
(l >= 5)
sum(l >= 5)   # 大于5的数量
mean(l >= 5)  # 大于5所占的比例

not_concelled %>% 
  group_by(year, month, day) %>% 
  summarize(n_early = sum(dep_time < 500))

not_concelled %>% 
  group_by(year, month, day) %>% 
  summarize(hour_perc = mean(arr_delay > 60))

### 3.6.5 按多个变量分组
daily <- group_by(flights, year, month, day)
(per_day <- summarize(daily, flights = n()))
(per_month <- summarize(per_day, flights = sum(flights)))
(per_year <- summarize(per_month, flights = sum(flights)))
### 3.6.6 取消分组
daily %>% 
  summarize(flights = n())

daily %>% 
  ungroup() %>% 
  summarize(flights = n())
## 3.7 分组新变量（和筛选器）
flights %>% 
  group_by(year, month, day) %>% 
  filter(rank(desc(dep_time)) < 10) # 每一组小于10的筛选出来

flights %>% 
  group_by(dest) %>% 
  filter(n() > 365) %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)

# 第4章 工作流：脚本

# 第5章 探索性数据分析
library(tidyverse)
### 5.3.1 对分布进行可视化
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut)) # 分类变量条形图

diamonds %>% 
  count(cut)

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat),binwidth = 0.5) # 连续性变量直方图
diamonds %>% 
  count(cut_width(carat, 0.5))

diamonds %>% 
  filter(carat < 3) %>% 
  ggplot(mapping = aes(x = carat)) +
    geom_histogram(binwidth = 0.1) +
    geom_freqpoly(mapping = aes(color = cut), binwidth = 0.1)

### 5.3.2 典型值
smaller <- diamonds %>% 
  filter(carat < 3)
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01) # 直方图容易看出数据中的典型值

ggplot(data = faithful, mapping = aes(x = eruptions)) +
  geom_histogram(binwidth = 0.25)

### 5.3.3 异常值
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = y),binwidth = 0.5)
# 分组数据太少了不容易观察出，可将纵轴靠近0的部分放大
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))
# 在（0， 50）更小范围内观看异常值；
# 找出异常值
unsual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  arrange(y)
unsual

## 5.4 缺失值
diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))  # between函数

diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) +
  geom_point() # ggplot默认会忽略缺失值，使用is.na = TRUE不显示忽略缺失值警告；
# 比较有无缺失值观测的区别
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) +
    geom_freqpoly(
      mapping = aes(color = cancelled),
      binwidth = 1/4
    )

nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  .$cancelled

## 5.5 相关变动
### 5.5.1 分类变量与连续变量
ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)
# 难以看出不同cut组的分布形状的差别，因为各组数量差别很大
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))
# 未来让各组具有可比性，要改变y轴的显示内容，改为密度而不是计数
ggplot(data = diamonds, 
  mapping = aes(x = price, y = ..density..)
  ) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)
# 箱线图
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()
# 分类变量进行排序：
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

ggplot(data = mpg) +
  geom_boxplot(
    mapping = aes(
      x = reorder(class, hwy, FUN = median),
      y = hwy
    )
  )
# 交换坐标轴：
ggplot(data = mpg) +
  geom_boxplot(
    mapping = aes(
      x = reorder(class, hwy, FUN = median),
      y = hwy
    )
  ) +
  coord_flip()

### 5.5.2 两个分类变量
# 计算两个分类变量所有组合中的观测数：
ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))
# 或者先使用dplyr中的count函数计数后再画图
diamonds %>% 
  count(color, cut) %>% 
  ggplot(mapping = aes(x = color, y = cut)) +
    geom_tile(mapping = aes(fill = n))

### 5.5.3 两个连续变量
ggplot(data = diamonds) +
  geom_point(
    mapping = aes(x = carat, y = price),
    alpha = 1 / 100
    )
# 使用geom_bin2d()和geom_hex()函数在两个维度上进行分箱
ggplot(data = smaller) +
  geom_bin2d(mapping = aes(x = carat, y = price))

install.packages("hexbin")
ggplot(data = smaller) +
  geom_hex(mapping = aes(x = carat, y = price))

# 也可以对carat分组后生成箱线图
ggplot(data = smaller, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.4)))
ggplot(data = smaller, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.4)), varwidth = TRUE) # varwidth表示箱体宽度与观测数量成正比

## 5.6 模式和模型
library(tidyverse)
ggplot(data = faithful) +
  geom_point(mapping = aes(x = eruptions, y = waiting))
library(modelr)
mod <- lm(log(price) ~ log(carat), data = diamonds)
diamonds2 <- diamonds %>% 
  add_residuals(mod) %>% 
  mutate(resid = exp(resid))

ggplot(data = diamonds2) +
  geom_point(mapping = aes(x = carat, y = resid))

ggplot(data = diamonds2) +
  geom_boxplot(mapping = aes(x = cut, y = resid))

## 5.7 ggplot2调用
ggplot(data = faithful, mapping = aes(x = eruptions)) +
  geom_freqpoly(binwidth = 0.25)
# 一种更精简的绘图语句
ggplot(faithful, aes(eruptions)) +
  geom_freqpoly(binwidth = 0.25)
# 数据转换结果直接转换为一张图
diamonds %>% 
  count(cut, clarity) %>% 
  ggplot(aes(clarity, cut, fill = n)) +
    geom_tile()


# 第7章 使用tibble实现简单数据框
## 7.2 创建tibble
library(tidyverse)
head(iris)
iris_t <- as_tibble(iris) # as_tibble(),数据框data.frame转化为tibble
head(iris_t)
tib1 <- tibble(
  x = 1:5,
  y = 1,
  z = x^2 + y
)
tib1
# 特殊符号做变量名，需要用反引号：
tib2 <- tibble(
  `:)` = "smile",
  ` ` = "space",
  `2000` = "number"
)
tib2
# 快速简易输入少量数据
tib3 <- tribble(
  ~x, ~y, ~z,
  "a", 1, 2,
  "b", 2, 4,
  "c", 3, 5,
)
tib3
## 7.3 对比tibble和data.frame
### 7.3.1 tibble对打印进行了优化，打印前十行，列也适应屏幕，打印出列名和类型
# print控制一般打印输出选项
nycflights13::flights  %>% print(n = 10, width = Inf) # 前10行，Inf:所有列
# 通过options设置默认打印输出方式：
options(tibble.print_max = n, tibble.print_min = m) # 如果大于m行，则只打印n行
options(tibble.print_min = Inf) # Inf：打印所有行
options(tibble.width = Inf) # Inf：打印所有列，不考虑屏幕宽度
# View()数据查看器查看数据，大写v
nycflights13::flights  %>%  View()
### 7.3.2 取子集
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
df
df$x
df[[1]]
df[[2]]
df %>% .$x
df %>% .[[2]]
df$x
df[[2]]
df[1,2]
df[3,2]
df[1,]
df[2,]
## 7.4 与旧代码交互
# 遇到不支持tibble的情况，转化回data.frame
as.data.frame(df)

# 第8章 使用readr进行数据导入
library(tidyverse)
setwd("/Users/zhulu/Files/MyGit/r/tidyverse/")
## 8.2 入门
read_csv() # 读取逗号分隔文件
read_csv2() # 读取分号分隔文件
read_tsv() # 读取制表符分隔文件
read_delim() # 读取使用任意分隔的文件
read_fwf() # 读取固定宽度的文件
read_log() # 读取Apache风格的日志文件

data(package = "dplyr")
heights <- read_csv("data/heights.csv", show_col_types = FALSE)
heights
skip = n # 读的时候跳过前n行
comment = "#" # "#"号开头为注释，跳过
col_names = FALSE # 不要将第一行作为列标题，数据不包含列标题
\n # 换行

read_csv("a,b,c\n1,2,3\n4,5",col_names = FALSE)
read_csv("1,2,3\n4,5,6",col_names = c("x","y","z"))
read_csv("a,b,c\n1,2,3\n4,5",na = ".")
### 8.2.1 与R基础包中的read.csv()比较
# read_csv更快
# R基础包中的函数更依赖操作系统、环境变量，换机后不一定能正常运行；

## 8.3 解析向量
# parse_*()族函数，接受一个字符向量，解析返回一个特定向量，逻辑、整数或者日期等；
parse_logical(c("true","TRUE","FALSE","NA"))
parse_integer(c("1","123","1.5","NA"))
parse_date(c("2022-07-22","2022-07-22"))

# 重要的8种解析函数
parse_logical() # 解析逻辑值
parse_integer() # 解析整数
parse_double()  # 解析数值型
parse_character() # 字符编码
parse_factor() # 解析因子
parse_date() # 解析日期
parse_time() # 解析时间
parse_datetime() # 解析日期+时间

### 8.3.1 数值
parse_double("1,23", locale = locale(decimal_mark = ",")) # 不同国家小数点不一样，是这小数点格式；
parse_number("$100")
parse_number("15%")
parse_number("It cost $123.5")
parse_number("123,456,78")

### 8.3.2 字符串
ASCII(可以非常好滴支持英文) -> UTF-8(几乎支持所有语言)
charToRaw("Hadley") # 获取一个字符串的底层，每个16进制数表示信息的一个字节
charToRaw("你好")

x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

# 猜测字符的编码方式
guess_encoding(charToRaw(x1))
parse_character(x1, locale = locale(encoding = "ISO-8859-1"))
guess_encoding(charToRaw(x2))
parse_character(x2, locale = locale(encoding = "KOI8-R")) # 不行

### 8.3.3 因子
fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)

### 8.3.4 日期与时间
parse_datetime("2020-07-22 2013")
parse_date("2014-2-12")
parse_date("2014-02-12")

parse_time("02:23 am")
parse_time("21:12:13")

parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%y/%m/%d")

## 8.4 解析文件
### 8.4.1 策略
# 先读取文件的前1000行，再用某种启发式算法确定每一列的类型：
# 先使用guess_parser()函数返回readr最可信的猜测，再使用parse_guess()函数使用这个猜测来解析列
guess_parser("2022-10-01")
guess_parser("2022-01-01")
guess_parser("2022-1-01")
guess_parser("20:08")
guess_parser(c("TRUE","T","FALSE","F"))
parse_guess("2022-10-01")

### 8.4.2 问题
# 1、前1000行可能不足以代表整个文件，后边可能有不同的类型；
# 2、前1000行都是NA值，readr可能猜测为字符向量，而我们实际想将这一列解析为更具体的值；
readr_example("challenge.csv") # 返回案例数据的路径
challenge <- read_csv(readr_example("challenge.csv"))

challenge

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_integer(),  # 前1000行是整数型，1000行以后会报错；
    y = col_character()
  )
)

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(), # 设置为双精度型不再报错；
    y = col_character()
  )
)

tail(challenge)

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date() # y列是日期型，设置为日期型也可
  )
)
challenge
tail(challenge)
# 建议读入数据时总是提供col_types参数，保证脚本的重复实用性，否则依赖程序猜测类型，当数据发生变化以后，readr继续读入数据；

### 8.4.3 其他策略
# 上面的示例，如果多猜测一行，就可以解析成功
challenge2 <- read_csv(
  readr_example("challenge.csv"),
  guess_max = 1001
)
# 将所有列都作为字符向量读入，会更容易诊断出问题
challenge2 <- read_csv(readr_example("challenge.csv"),
  col_types = cols(.default = col_character())
)

# type_convert()启发式解析
df <- tribble(
  ~x, ~y,
  "1", "1.21",
  "1", "1.21",
  "1", "1.21"
)
type_convert(df) # 自动识别改动为double类型
## 8.5 写入文件
write_csv()
write_tsv()
write_excel_csv() # 该函数会在文件开头写入一个特殊字符，告诉Excel这个文件使用的是UTF-8编码
# 他们总是使用UTF-8编码；
# 使用ISO8601格式来保存日期和时间数据；
# 保存为csv文件时，列类型信息就丢失列；
challenge
write_csv(challenge, "challenge-2.csv")
read_csv("challenge-2.csv")
# csv文件每次加载时都要重建列类型，可以有两种替代方式：
# write_rds()和read_rds()将数据保存和读取R自定义的二进制格式；
write_rds(challenge, "challenge.rds")
read_rds("challenge.rds")
# feather包实现了一种快速二进制格式，可以在多个编程语言之间共享；
library(feather)
write_feather(challenge, "challenge.feather")
read_feather("challenge.feather")
# feather比rds速度还要快，而且可以在R之外使用；

## 8.6 其它类型数据
# haven：SPSS、Stata、和SAS文件
# readxl：Excel(.xls和.xlsx均可)
# 配合专用数据库后端程序(RMySQL,RSQLite,RPostgreSQL等)，DBI可以对相应数据库进行SQL查询；
# jsonlite：JSON
# xml2:XML

# 第9章 使用dpylr数理关系数据
library(tidyverse)
library(nycflights13)
## 9.3 键
View(planes)
View(flights)
# 主键：唯一表示所在表中的每一个观测值；
# 外键：唯一表示另一个数据中的每一个观测值；
# 验证是否是主键：count()后，查看是否有重复值
planes  %>% 
  count(tailnum) %>% 
  filter(n>1)

weather %>% 
  count(year, month, day, hour, origin) %>% 
  filter(n>1)

flights %>% 
  count(year, month, day, flight) %>% 
  filter(n>1)
# 关系：一对一、一对多、多对一
## 9.4 合并连接
# 合并连接：将两个表格中的变量合并起来，将一个表格合并到另一个表格的右侧
flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2
airlines
flights2 %>% 
  select(-origin, -dest) %>% 
  left_join(airlines, by = "carrier") # 通过carrier变量将航空公司名称name合并到flights2中；

flights2 %>% 
  select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

### 9.4.1 理解连接
### 9.4.2 内连接
# 内连接相当于取交集，没有匹配的行不包含在结果中；
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)
x %>% inner_join(y, by = "key")

### 9.4.3 外连接
# 外连接：只保留一个表格中的观测，分为：
# 左连接：保留左侧x中的所有观测
# 右连接：保留右侧y中的所有观测
# 全连接；保留x和y中的所有观测
x %>% left_join(y, by = "key")
x %>% right_join(y, by = "key")
x %>% full_join(y, by = "key")

### 9.4.4 重复键
# 一张表中的键出现了重复值
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)
left_join(x, y, by = "key")
# 两张表都有重复键：错误，此时得到所有可能的组合，相当于笛卡尔积；
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3"
)
left_join(x, y, by = "key")
### 9.4.5 定义键列
# 自定义匹配列
# by = NULL,默认使用两个表中的所有变量
flights2 %>% left_join(weather) # "year", "month", "day", "hour", "origin"使用这些两个数据中都有的公共变量连接

# by = "x",通过x变量连接
flights2 %>% left_join(planes, by = "tailnum") # year变量重复了，后边加了后缀以示区分；

# by = c("a" = "b"),x中的a变量与y中的b变量匹配
flights2 %>% left_join(airports, c("dest" = "faa"))

### 9.4.7 其它实现方式
# 与base::merge()对比
inner_join(x, y)  <-> merge(x, y)
left_join(x, y)  <-> merge(x, y, all.x = TRUE)
right_join(x, y)  <-> merge(x, y, all.y = TRUE)
full_join(x, y)  <-> merge(x, y, all.x = TRUE, all.y = TRUE)

## 9.5 筛选连接
semi_join(x, y) # 保留x表中与y观测值相匹配的所有观测；
anti_join(x, y) # 丢弃x表中与y观测值相匹配的所有观测；
topdest <- flights %>% 
  count(dest, sort = TRUE) %>% 
  head(10)
topdest

flights %>% 
  filter(dest %in% topdest$dest)

# 上面的筛选等价于:
# 半连接
flights %>% 
  semi_join(topdest)

# 反连接：查看flights中有哪些planes中没有的观测
flights %>% 
  anti_join(planes, by = "tailnum") %>% 
  count(tailnum, sort = TRUE)
## 9.7 集合操作
df1 <- tribble(
  ~x, ~y,
  1, 1,
  2, 1
)
df2 <- tribble(
  ~x, ~y,
  1, 1,
  3, 1
)
intersect(df1, df2) # 交集
union(df1, df2)  # 并集
setdiff(df1, df2) # 差集

# 第10章 使用stringr处理字符串
library(tidyverse)
library(stringr)
string1 <- "This is a string"
string2 <- 'To put a "quote" inside a string, using single quotes'
string1
string2
string3 <- 'this is a string without a closing quote'
double_quote <- "\""
# 转义符 \
# 换行符 \n
# 制表符 \t

### 10.2.1 字符串长度
# stringr中处理字符串的函数都是str开头
str_length(c("a", "R for data science", NA))
### 10.2.2 字符串组合（拼接）
str_c("a", "bc")
str_c("a", "bc", sep = "-")
x <- c("baidu", "google", NA, "")
str_c("www.", x, ".com") # str_c是自动循环迭代函数，NA缺失值会传染
str_c("www.", str_replace_na(x), ".com") # 不让NA传染，当作普通字符；
str_c(c("a","b","c"))
str_c(c("a","b","c"),collapse = ",")
### 10.2.3 字符串取子集
x <- c("apple", "banana", "pear")
str_sub(x, 1, 3) # 自动循环迭代，x向量里的每一个元素都取前3个字符
str_sub(x, -3, -1) # 负数表示从后往前取
str_sub(x, 1, 1) <- str_to_upper(str_sub(x, 1, 1))
x
str_sub(x, 1, 1) <- "迭代"
x
### 10.2.4 区域设置
str_to_lower("banana")
str_to_upper("banana")
str_to_title("banana") 
x <- c("apple", "egg", "banana")
str_sort(x, locale = "en")
str_sort(x, locale = "haw") # locale根据不同的区域，排序顺序不同

## 10.3 使用正则表达式进行模式匹配
### 10.3.1 精准匹配
x <- c("apple", "banana", "pear")
str_view(x, "an")
str_view(x,".a.") # .匹配任意字符
dot <- "\\."
dot
writeLines(dot)
str_view(c("abc", "a.c", "bef"), "a.c")
str_view(c("abc", "a.c", "bef"), "a\.c")
str_view(c("abc", "a.c", "bef"), "a\\.c")
# "\\."匹配.
# "\\\\"匹配一个\
### 10.3.3 锚点：从什么位置开始匹配
^：从字符串开头进行匹配
$：从字符串结尾进行匹配
x <- c("apple", "banana", "pear")
str_view(x, "^a")
str_view(x, "a$")
x <- c("apple pie", "apple", "apple cake")
str_view(x, "^apple")
str_view(x, "apple")
str_view(x, "^apple$")
### 10.3.5 字符类和字符选项
\d 
\s
[abc]
[^abc]
str_view(c('graw', 'grew'), "gr(a|e)y")

### 10.3.7 重复
?:# 0次或1次
*:# 0次或多次
+:# 1次或多次
x <- "1888 is the longest year in roman numerals :MDCCCLXXXVIIILXABCLXABCCCCCCCABXXXXLASDABCXXX"
str_view(x, "CCC?")
str_view(x, "CC?")
str_view(x, "CC")
str_view(x, "C")
str_view(x, "CC+")
str_view(x, "C[LX]+")
str_view(x, "C{4,}")
str_view(x, "C{4,}?")
str_view(x, "C{4,}+")
### 10.3.9 分组与回溯引用
str_view(fruit, "(..)\\1")  # 重复两个字母
str_view(fruit, "(.)\\1")   # 重复一个字母

## 10.4 工具
# 各种stringr函数，可以：
# 匹配
# 定位
# 提取
# 替换
# 拆分
### 10.4.1 匹配检测
x <- c("apple", "banana", "pear")
str_detect(x, "e") # 返回逻辑值，如果包含e返回1，否则0
str_detect(words, "^t")
sum(str_detect(words, "^t"))
mean(str_detect(words, "[aeiou]$")) # 以元音字母结尾
str_detect(words, "[aeiou]")[1:10]
!str_detect(words, "[aeiou]")[1:10]
mean(!str_detect(words, "[aeiou]"))
mean(!str_detect(words, "(a|e|i|o|u)"))
mean(str_detect(words, "^[^aeiou]+$"))

x <- c("apple", "banana", "pear", "how", "are", "what", "whkt")
str_view(x, "[aeiou]")
str_view_all(x, "[aeiou]")
str_view(x, "[^aeiou]")
str_view(x, "^[^aeiou]")
str_view(x, "^[^aeiou]+")
str_view(x, "^[^aeiou]+$")
str_view(x, "[^aeiou]$")

# 逻辑取子集
words[str_detect(words, "x$")]
str_subset(words, "x$")
# 正则条件也可用于filter函数
df <- tibble(
  word = words,
  i = seq_along(word)
)
df
df %>% 
  filter(str_detect(word, "x$"))
# 显示匹配到的数量str_count()
x <- c("apple", "banana", "pear")
str_count(x, "a")
str_count(words, "[aeiou]")
df %>% 
  mutate(
    nowels = str_count(word, "[aeiou]"),
    consonants = str_count(word, "[^aeiou]")
  )

# 匹配不会重叠
str_count("abababa", "aba")
str_view_all("abababa", "aba")
### 10.4.3 提取匹配内容
length(sentences)
head(sentences)
color <- c("red", "orange", "yellow", "green", "blue", "purple")
color_match <- str_c(color, collapse = "|")
color_match
has_color <- str_subset(sentences, color_match)
has_color
matches <- str_extract(has_color, color_match)
matches
more <- sentences[str_count(sentences, color_match) > 1]
more
str_extract(more, color_match)
str_extract_all(more, color_match)
str_extract_all(more, color_match, simplify = TRUE) # 返回一个矩阵，少的部分自动扩展；
### 10.4.5 分组匹配
# 使用括号，结合优先级，对一个复杂表达式进行分组
noun <- "(a|the) ([^ ]+)"
has_noun <- sentences %>% 
  str_subset(noun) %>% 
  head(10)
has_noun
has_noun %>% 
  str_extract(noun)

has_noun %>% 
  str_match(noun) 
# str_extract()给出完整匹配
# str_match()给出个组匹配到的内容
### 10.4.7 替换匹配到的内容
x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "*")      # 替换第一个
str_replace_all(x, "[aeiou]", "*")  # 替换所有
# 根据一个向量匹配替换
x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))
str_replace_all(x, c("1" = "one", "2" = "two"))
# 配合回溯可以将匹配到的内容
head(sentences)
sentences %>% 
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>% 
  head()
sentences %>% 
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\3 \\2 \\1") %>% 
  head()
### 10.4.9 拆分
sentences %>% 
  head(5) %>% 
  str_split(" ")

"a|b|c|d" %>% 
  str_split("\\|") %>% 
  .[[1]] # str_split返回的是一个列表，提取列表的第一个元素

sentences  %>% 
  head(5) %>% 
  str_split(" ", simplify = TRUE) # simplify返回一个矩阵形式的结果

fileds <- c("name: hadley", "country: NZ", "Age: 35")
fileds %>% str_split(": ", n = 2, simplify = TRUE)
fileds %>% str_split(": ", n = 3, simplify = TRUE) # n拆分为多少列
# boundary函数设置通过字母、行、和单词边界来拆分字符串；
x <- "this is a sentence, that is another sentences."
str_view_all(x, boundary("word"))
str_split(x, " ")
str_split(x, " ")[[1]] # 按空格拆分；
str_split(x, boundary("word"))[[1]] # 按单词拆分；

## 10.5 其他类型的模式
# regex函数：匹配时R自动用regex对表达式进行了包装
str_view(fruit, "nana")
str_view(fruit, regex("nana"))
# regex函数设置不同参数来更改匹配方式
ignore_case = TRUE # 不区分大小写
banana <- c("banana", "Banana", "BANANA")
str_view(banana, "banana")
str_view(banana, regex("banana"))
str_view(banana, regex("banana", ignore_case = TRUE))

multiline = TRUE # 按行从每行的开头结尾进行匹配，而不是整段的开头和结尾进行匹配
x <- "this is line 1\nthis is line 2\nthat are line 3"
str_extract_all(x, "^this")[[1]]
str_extract_all(x, regex("^this", multiline = TRUE))[[1]] # 每一行都单独匹配；

comments = TRUE # 忽略注释#的内容
phone <- regex("
  \\(?         # 可选的左括号
  (\\d{3})     # 三位地区编码
  [)- ]?       # 右括号、短划线、空格
  (\\d{3})     # 另外三位数字
  [ -]?        # 可选的空格或短线
  (\\d{3})     # 另外三位数字
  ", comments = TRUE)
str_view("514-791-8184", phone)
str_match("514-791-8184", phone)

dotall = TRUE # .可以匹配\n在内的所有字符

# fixed()函数：忽略表达式中的所有特殊字符，按照字符串的字节形势精准匹配，速度比普通正则表达式快很多：
install.packages("microbenchmark")
microbenchmark::microbenchmark(
  fixed = str_detect(sentences, fixed("the")), # fixed()方法匹配the比一般方式匹配快很多，时间对比
  regex = str_detect(sentences, "the"),
  times = 20
)
# fixed函数慎用，一个字符有多种表达方式：
a1 <- "\u00e1"
a2 <- "a\u0301"
a1 == a2
c(a1, a2) # a1和a2看上去是一样的，但是用不同的方式实现的，他们并不一样；
str_detect(a1, fixed(a2))
str_detect(a1, coll(a2)) # coll使用排序规则来显示，二者是一样的；
# coll函数速度较慢，因为确定字符是否相同的规则比较复杂

## 10.6 正则表达式的其它应用
apropos("replace") # 在全局环境中搜索replace可用对象
head(dir(pattern = "\\.Rmd$")) # dir函数可以使用正则表达式查找本地文件；

## 10.7 stringi
# stringr建立在stringi的基础上，stringi包含更多的函数，区别在于str_和stri_


# 第11章 使用forcats处理因子
library(tidyverse)
library(forcats)
## 11.2 创建因子
x1 <- c("Dec", "Apr", "Jan", "Mar")
x2 <- c("Dec", "Apr", "Jam", "Mar")
# 直接排序
sort(x1) # 按字母顺序，没有实际意义
# 自定义序列排序
month_levels <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
# 创建因子
y1 <- factor(x1, levels = month_levels)
y1
sort(y1)
y2 <- factor(x2, levels = month_levels)
y2
# 如果有错误，可以使用parse_factor()函数
y2 <- parse_factor(x2, levels = month_levels)
# 如果不设置levels参数将默认字母顺序的数据作为水平
factor(x1)
# 如果不想按字母顺序，按照数据原本顺序：
factor(x1, levels = unique(x1))
# 或者创建因子后使用fct_inorder()函数：
f2 <- x1 %>% factor() %>% fct_inorder()
f2
# 显示因子的各种水平
levels(f2)

## 11.3 综合社会调查
# 因子的水平不易看到，使用count函数查看：
gss_cat %>% 
  count(race)
# 或者使用条形图：
ggplot(data = gss_cat, mapping = aes(x = race)) +
  geom_bar()
# ggplot2默认会丢弃没有水平的数据，drop = FALSE强制显示所有水平
ggplot(data = gss_cat, mapping = aes(x = race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)

## 11.4 修改因子水平
gss_cat %>% count(partyid)
# 使用fct_recode()可以对每个水平进行修改或重新编码
gss_cat %>% 
  mutate(partyid = fct_recode(partyid,
    "Republican, strong" = "Strong republican",
    "Republican, weak"   = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak"  = "Not str democrat",
    "Democrat, strong" = "Strong democrat"
  )) %>% 
  count(partyid)
# 也可以将原来的多水平合并为一个新的水平：
gss_cat %>% 
  mutate(partyid = fct_recode(partyid,
    "Republican, strong" = "Strong republican",
    "Republican, weak"   = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak"  = "Not str democrat",
    "Democrat, strong" = "Strong democrat",
    "Other" = "No answer",
    "Other" = "Don't know",
    "Other" = "Other party"
  )) %>% 
  count(partyid)
# 使用fct_collapse()合并更简单：
gss_cat %>% 
  mutate(partyid = fct_collapse(partyid,
    rep = c("Strong republican", "Not str republican"),
    ind = c("Ind,near rep", "Ind,near dem", "Independent"),
    dem = c("Not str democrat", "Strong democrat"),
    Other = c("No answer", "Don't know", "Other party")
  )) %>% 
  count(partyid)

# 第12章 使用lubridate处理日期和时间
library(tidyverse)
library(lubridate)
library(nycflights13)
# 三种日期和时间类型：date、time和dttm（date，time）
today()
now()
### 12.2.1 通过字符串创建
ymd("20170101")
ymd("2017-01-01")
mdy("01312017")
dmy("31-Jan-2017")
dmy("31-1-2017")
ymd("20170321")
### 12.2.2 通过各个成分创建
flights %>% 
  select(year, month, day, hour, minute) %>% 
  mutate(
    departure = make_datetime(year, month, day, hour, minute)
  )

make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100) # 求商和余数
}

flights_dt <- flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time),
  ) %>% 
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt

10 %/% 3
10 %% 3

# 第13章 ---------------------------------------------------------------

