# 学习tidyverse
## 一、ggplot2
library(tidyverse)
mpg

ggplot(data = mpg) +
geom_point(mapping = aes(x = displ, y = hwy, color = class))

ggplot(data = mpg) +
geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

ggplot(data = mpg) +
geom_point(mapping = aes(x = displ, y = hwy), color = "blue") +
facet_wrap(~ class, nrow = 3)

ggplot(data = mpg) +
geom_point(mapping = aes(x = displ, y = hwy), color = "blue") +
facet_grid(drv ~ cyl)

ggplot(data = mpg) +
geom_point(mapping = aes(x = displ, y = hwy), color = "blue") +
facet_grid(drv ~ cyl)

ggplot(data = mpg) +
geom_point(mapping = aes(x = displ, y = hwy), color = "blue") +
facet_grid(drv ~ .)


