
# Dagum基尼系数分解 -------------------------------------------------------------


# * 一、G的计算 ---------------------------------------------------------------

# 总的差异

# ** 1.1 尝试分步计算 ----------------------------------------------------------
rm(list = ls())
library(dplyr) # distinct 和 count函数

getwd()

setwd("/users/zhulu/files/MyGit/r/Gini")
haven::read_dta("gini.dta") |>
  mutate(
    loc = factor(
      area,
      levels = c("Eastern", "Central", "Western") # 將区域变量由字符型改为因子；
    )
  ) -> df
# df |>
#   dplyr::filter(year == 2005) |>
#   pull(6) -> index_2005

# purrr::map_dbl(index_2005, ~ abs(.x - index_2005) |>
#   sum()) |> sum() -> delta_2005

# index_2005 |> mean() -> mean_2005

# delta_2005 / (2 * mean_2005 * 279 * 279)

# ** 1.2 定义函数实现上面的操作 -----------------------------------------------
# 支持中文变量

G_total <- function(数据, 年份) {
  数据 |>
    dplyr::filter(year == 年份) |>
    pull(6) -> index

  purrr::map_dbl(
    index,
    ~ abs(.x - index) |> sum()
  ) |> sum() -> numerator

  数据 |>
    dplyr::filter(year == 年份) |>
    summarise(
      n = n(), # 取出个数，这里n==279
      mean = mean(index),
      denominator = 2 * n * n * mean
    ) |>
    pull(denominator) -> denominator

  return(numerator / denominator)
}

# G_total(df,2005)
# G_total(df,2006)

# purrr::map_df(
#   unique(df$year),
#   ~ tibble(
#     year = .x,
#     g = G_total(df, .x)
#   )
# ) -> G

# * 二、Gjj的计算 ---------------------------------------------------------------

# 相当于第j个区域内的差异，在G的基础上，样本限定在一个特定区域内：



# 只提取出一个区域用上面的G_total就相当于Gjj：
# df_loc |> distinct(loc)
# df_loc |> dplyr::filter(loc == "Eastern") |> G_total(2005)

G_jj <- function(数据, 年份, 地区) {
  数据 |>
    dplyr::filter(year == 年份 & loc == 地区) |>
    pull(6) -> index

  purrr::map_dbl(
    index,
    ~ abs(.x - index) |> sum()
  ) |> sum() -> numerator

  数据 |>
    dplyr::filter(year == 年份 & loc == 地区) |>
    summarise(
      n = n(), # 区域内的城市数量
      mean = mean(index),
      denominator = 2 * n * n * mean
    ) |>
    pull(denominator) -> denominator

  return(numerator / denominator)
}

# G_jj(df_loc, 2005, "Eastern")


# purrr::map_df(
#   unique(df$year),
#   ~ tibble(
#     年份 = .x,
#     总差异 = G_total(df, .x),
#     东部地区 = G_jj(df, .x, "Eastern"),
#     中部地区 = G_jj(df, .x, "Central"),
#     西部地区 = G_jj(df, .x, "Western")
#   )
# ) -> Gjj

# print(Gjj)



# 三、Gjh的计算---------------------------------------------------------------
# 计算j和h两个区域之间的差异

G_jh <- function(数据, 年份, 地区1, 地区2) {
  数据 |>
    dplyr::filter(year == 年份 & loc == 地区1) |>
    pull(6) -> index1
  数据 |>
    dplyr::filter(year == 年份 & loc == 地区2) |>
    pull(6) -> index2

  purrr::map_dbl(
    index1,
    ~ abs(.x - index2) |> sum()
  ) |> sum() -> numerator

  mean1 <- mean(index1)
  n1 <- length(index1)
  mean2 <- mean(index2)
  n2 <- length(index2)
  denominator <- (mean1 + mean2) * n1 * n2
  return(numerator / denominator)
}

# G_jh(df, "2005", "Eastern", "Western")

#  总输出 ---------------------------------------------------------------
# purrr::map_df(
#   unique(df$year),
#   ~ tibble(
#     年份 = .x,
#     总差异 = G_total(df, .x),
#     东部地区 = G_jj(df, .x, "Eastern"),
#     中部地区 = G_jj(df, .x, "Central"),
#     西部地区 = G_jj(df, .x, "Western"),
#     东西 = G_jh(df, .x, "Eastern", "Western"),
#     东中 = G_jh(df, .x, "Eastern", "Central"),
#     中西 = G_jh(df, .x, "Central", "Western")
#   )
# ) -> Gini

# print(Gini)


# 新分解方法
# 在Gjj的基础上计算Gw

# 计算Gjj的过程中直接输出pjsj
GW_jj <- function(数据, 年份, 地区) {
  数据 |>
    dplyr::filter(year == 年份 & loc == 地区) |>
    pull(6) -> index

  purrr::map_dbl(
    index,
    ~ abs(.x - index) |> sum()
  ) |> sum() -> fz

  数据 |> # 提取nj和区域j的均值
    dplyr::filter(year == 年份 & loc == 地区) |>
    summarise(
      n_j = n(), # 区域内的城市数量nj
      mean_yj = mean(index),
      fm = 2 * n_j * n_j * mean_yj
    ) -> yj

  数据 |> # 提取n和总均值
    dplyr::filter(year == 年份) |>
    summarise(
      n = n(),
      mean_y = mean(index),
    ) -> y

  return((fz / yj$fm) * (yj$n_j / y$n) * ((yj$n_j * yj$mean_yj) / (y$n * y$mean_y)))
}

# GW_jj(df, "2005", "Eastern")
# GW <- GW_jj(df, "2005", "Eastern") + GW_jj(df, "2005", "Western") + GW_jj(df, "2005", "Central")

GW <- function(df, year) {
  gw <- GW_jj(df, year, "Eastern") + GW_jj(df, year, "Western") + GW_jj(df, year, "Central")
  return(gw)
}
# GW(df, "2005")

# purrr::map_df(
#   unique(df$year),
#   ~ tibble(
#     年份 = .x,
#     总差异 = G_total(df, .x),
#     东部地区 = G_jj(df, .x, "Eastern"),
#     中部地区 = G_jj(df, .x, "Central"),
#     西部地区 = G_jj(df, .x, "Western"),
#     东西 = G_jh(df, .x, "Eastern", "Western"),
#     东中 = G_jh(df, .x, "Eastern", "Central"),
#     中西 = G_jh(df, .x, "Central", "Western"),
#     Gw = GW(df, .x)
#   )
# ) -> Gini

# print(Gini)

# 计算Gnb,在G_jh基础上修改;

Gnb_jh <- function(数据, 年份, 地区1, 地区2) {
  数据 |>
    dplyr::filter(year == 年份) |>
    pull(6) -> index
  数据 |>
    dplyr::filter(year == 年份 & loc == 地区1) |>
    pull(6) -> index1
  数据 |>
    dplyr::filter(year == 年份 & loc == 地区2) |>
    pull(6) -> index2

  purrr::map_dbl(
    index1,
    ~ abs(.x - index2) |> sum()
  ) |> sum() -> numerator   # Δjh
  mean <- mean(index)
  n <- length(index)
  mean1 <- mean(index1)
  n1 <- length(index1)
  mean2 <- mean(index2)
  n2 <- length(index2)
  denominator <- (mean1 + mean2) * n1 * n2
  return((numerator / denominator) * ((n1 / n) * ((n2 * mean2) / (n * mean)) + (n2 / n) * ((n1 * mean1) / (n * mean))) * (abs(mean1 - mean2) / (numerator / (n1 * n2))))
}

# Gnb_jh(df, "2005", "Eastern", "Western")
Gnb <- function(df, year) {
  gnb <- Gnb_jh(df, year, "Eastern", "Western") + Gnb_jh(df, year, "Eastern", "Central") + Gnb_jh(df, year, "Central", "Western") # nolint
  return(gnb)
}
# Gnb(df, "2005")
# Gnb(df, "2006")
# Gnb(df, "2007")

purrr::map_df(
  unique(df$year),
  ~ tibble(
    年份 = .x,
    G = G_total(df, .x),
    东部地区 = G_jj(df, .x, "Eastern"),
    中部地区 = G_jj(df, .x, "Central"),
    西部地区 = G_jj(df, .x, "Western"),
    东西 = G_jh(df, .x, "Eastern", "Western"),
    东中 = G_jh(df, .x, "Eastern", "Central"),
    中西 = G_jh(df, .x, "Central", "Western"),
    Gw = GW(df, .x),
    Gnb = Gnb(df, .x),
    Gt = G - Gw - Gnb
  )
) -> Gini

print(Gini)
write.csv(Gini, file = "Dagum.csv")
