# 结构方程模型
install.packages("lavaan")
library("lavaan")
myModel <- " # 主要回归方程
            y1 + y2 ~ f1 + f2 + x1 + x2
            f1 ~ f2 + f3
            f2 ~ f3 + x1 + x2
            # 定义潜变量
            f1 =~ y1 + y2 + y3
            f2 =~ y4 + y5 + y6
            f3 =~ y7 + y8 + y9 + y10
            # 方差和协方差
            y1 ~~ y1
            y1 ~~ y2
            f1 ~~ f2
            # 截距项
            y1 ~ 1
            f1 ~ 1
            "
??HolzingerSwineford
data(HolzingerSwineford1939)

HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9'
# 然后拟合cfa函数，第一个参数是模型，第二个参数是数据集
fit <- cfa(HS.model, data = HolzingerSwineford1939)
# 再通过summary函数给出结果
summary(fit, fit.measure = TRUE)
