
# 第11章:决策树 ----------------------------------------------------------------


library(rpart)
library(MASS)
dim(Boston)
set.seed(1)
train <- sample(506,354)
data("Boston")
head(Boston)
str(Boston)
# 决策树:
set.seed(123)
fit <- rpart(medv~.,data = Boston,subset = train)
fit1 <- lm(medv~.,data = Boston,subset = train)
fit1
fit
# 画出决策树
op <- par(no.readonly = TRUE)
par(mar=c(1,1,1,1))
plot(fit,margin = 0.1)
text(fit)
par(op)

# 画出10折交叉验证误差图
plotcp(fit)

# 图中的具体信息
fit$cptable

# 提取最小化最优复杂性参数cp
min_cp <- fit$cptable[which.min(fit$cptable[,"xerror"]),"CP"]
min_cp

# 根据最优cp进行修枝
fit_best <- prune(fit,cp = 0.03)

# 画出修枝后的决策树
install.packages("rpart.plot")
library(rpart.plot)
prp(fit_best,type = 2)
prp(fit_best,type = 0)
prp(fit_best,type = 1)
prp(fit_best,type = 3)
prp(fit_best,type = 4)
prp(fit_best,type = 5)
summary(Boston$medv)

# 预测并计算预测误差
tree.pred <- predict(fit_best,newdata = Boston[-train,])
y.test <- Boston[-train,"medv"]
mean((tree.pred-y.test)^2)
plot(tree.pred,y.test)

# 案例:葡萄牙银行
bank <- read.csv("bank-additional.csv",header = TRUE,sep = ";")
str(bank,vec.len=1)
bank$duration <- NULL
bank$duration
prop.table(table(bank$y))
#
set.seed(1)
train <- sample(4119,3119)
set.seed(123)
library(rpart)
fit <- rpart(y~.,data=bank,subset = train)
plotcp(fit)
fit$cptable
min_cp <- fit$cptable[which.min(fit$cptable[,"xerror"]),"CP"]
fit_best <- prune(fit,cp=min_cp)
plot(fit_best)
text(fit_best)

library(rpart.plot)
prp(fit_best,type = 1)

tree.pred <- predict(fit_best,bank[-train,],type = "class")
tree.pred
head(tree.pred)

y.test <- bank[-train,"y"]
table <- table(tree.pred,y.test)
sum(diag(table))/sum(table)
table(bank$y)

tree.prob <- predict(fit_best,bank[-train,],type = "prob")
tree.prob
head(tree.prob)
tree.prob <- tree.prob[,2]>=0.1
table(tree.prob,y.test)
