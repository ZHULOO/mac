# install.packages("echarts4r")
library(echarts4r)
library(tidyverse)

mtcars %>% 
  rownames_to_column() %>% 
  e_charts(rowname) %>% 
  e_bar(mpg) %>% 
  e_step(drat) %>% 
  e_title("条形图与阶梯图")

