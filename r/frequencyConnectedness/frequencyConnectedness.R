install.packages("frequencyConnectedness")
library("frequencyConnectedness")
data(exampleSim)
exampleSim<-exampleSim[1:600,]
est<-VAR(exampleSim,p=2,type="const")
summary(est)
spilloverDY09(est, n.ahead = 100, no.corr = F)
spilloverDY12(est, n.ahead = 100, no.corr = F)#no.corr boolean parameter whether the off-diagonal in the covariance matrix should beset to zero
sp<-spilloverDY12(est, n.ahead = 100, no.corr = F)
overall(sp)
to(sp)
from(sp)
net(sp)
pairwise(sp)

library("stringr")
