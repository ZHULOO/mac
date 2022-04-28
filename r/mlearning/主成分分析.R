getwd()
data <- read.csv("E:/data/MLR_Data/audiometric.csv",header = T)
str(data)
options(digits = 2)
cor(data)
apply(data, 2, mean) # 2表示按列计算均值,1表示按行计算均值;
apply(data,2,sd)

# 主成分分析 -------------------------------------------------------------------

fit <- prcomp(data,scale = TRUE)
fit
names(fit)
fit$sdev # 各主成分的标准差
fit$x    # 各主成分的得分
fit$rotation # 主成分载荷矩阵
fit$rotation <- -fit$rotation
summary(fit)
plot(fit,type = 'line',main = "Screen Plot") # 画出陡坡图
abline(h=0.455,lty = 2)
# 提取PVE手动画图
pve <- summary(fit)$importance[2,]
plot(1:8,pve,type = "b",main = "PVE",xlab = "Principal Component",ylab = "Proportion
     of Variance Explained")
# 画累计PVE图
plot(1:8,cumsum(pve),type = "b",main = "PVE",xlab = "Principal Component",ylab = "Commulative
     Proportion of Variance Explained")
# 画双标图
biplot(fit,cex=0.8,col = c(1,4))
# 画三标图
install.packages("rgl")
library(rgl)
plot3d(fit$x[,1:3],size = 1,type = "s",col = "blue")
# 根据前三个主成分得分进行k均值据类
set.seed(1)
clust <- kmeans(fit$x[,1:3],centers = 3,nstart = 100)
clust$cluster
plot3d(fit$x[,1:3],size = 1,type = "s",col = clust$cluster+2)


# 主成分回归 -------------------------------------------------------------------
install.packages("pampe") 
library(pampe)
data(growth) #使用pampe包下的growth数据;
head(growth)
colnames(growth)[1] <- "Hongkong_CN"
colnames(growth)[24] <- "Taiwan_CN"
colnames(growth)
str(growth)
cor(growth)[1,] #显示相关系数矩阵的第一行
# 使用pls包的pcr函数进行主成分回归
install.packages("pls")
library(pls)
fit <- pcr(Hongkong_CN~.,data=growth[1:44,],scale=TRUE,validation="LOO")
summary(fit)



