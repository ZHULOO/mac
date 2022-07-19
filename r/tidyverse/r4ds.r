#########################R for Data Science#######################
# 第1章 使用ggplot2进行数据可视化
## 1.1 简介
install.packages("tidyverse")
library(tidyverse)
ggplot2::ggplot() # 使用某个包的某个函数

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
demo <- tribble( # 注意tribble与tibble
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
ggplot(data = faithful) +
  geom_point(mapping = aes(x = eruptions, y = waiting))
library(modelr)
mod <- lm(log(price) ~ log(carat), data = diamonds)
diamonds2 <- diamonds %>% 
  add_residuals(mod) %>% 
  mutate(resid = exp(resid))

ggplot(data = diamonds2) +
  geom_point(mapping = aes(x = carat, y = resid))


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
df[1,2]
df[3,2]
df[1,]
df[2,]
## 7.4 与旧代码交互
# 遇到不支持tibble的情况，转化回data.frame
as.data.frame(df)


