
# 融合 ----------------------------------------------------------------------
install.packages("reshape2")
library("reshape2")
??reshape2
ID <- c(1,1,2,2)
Time <- c(1,2,1,2)
X1 <- c(5,3,6,2)
X2 <- c(6,5,1,4)
mydata <- cbind(ID,Time,X1,X2)
mydata
mydata1 <- as.data.frame(mydata)
mydata1
typeof(mydata)
typeof(mydata1)
names(mydata1)
md <- melt(mydata1,id.vars=c("ID","Time")) # melt的对象是frame
md

# 重铸 ----------------------------------------------------------------------
# 不执行整合
dcast(md,ID+Time~variable)
dcast(md,ID+variable~Time)
dcast(md,ID~variable+Time)
# 用均值进行整合
dcast(md,ID~variable,mean)

# 案例 ----------------------------------------------------------------------
install.packages("openxlsx")
library(openxlsx)
getwd()
mydata2 <- read.xlsx("例9.2.xlsx")
mydata2
newdata <- mydata2[1:3,1:4]
newdata
md1 <- melt(newdata,id.vars = c("X1"))
md1
names(md1) <- c("生产地","质量","数量")
md1

area <- read.xlsx("paneldata.xlsx")
area
md2 <- melt(area,id.vars = "地区")
md2
names(md2) <- c("area","year","cpi")
md2
