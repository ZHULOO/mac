install.packages("Counterfactual")
library("Counterfactual")
help(package = "Counterfactual")
#### 案例1：
rm(list = ls())
library(quantreg)
data(engel)
attach(engel)

counter_income <- mean(income)+0.75*(income-mean(income))
cdfx <- c(1:length(income))/length(income)

plot(c(0,4000),range(c(0,1)), xlim =c(0, 4000), type="n", xlab = "Income",ylab="Probability")
lines(sort(income), cdfx)
lines(sort(counter_income), cdfx, lwd = 2, col = 'grey70')
legend(1500, .2, c("Original", "Counterfactual"), lwd=c(1,2),bty="n",col=c(1,'grey70'))
qrres <- counterfactual(foodexp~income, counterfactual_var = counter_income, transformation = TRUE)


taus <- c(1:99)/100
first <- sum(as.double(taus <= .10))
last <- sum(as.double(taus <= .90))
rang <- c(first:last)
rqres <- counterfactual(foodexp~income, counterfactual_var=counter_income, nreg=100, quantiles=taus,
                        transformation = TRUE, printdeco = FALSE, sepcore = TRUE,ncore=2)
duqf <- (rqres$resCE)[,1]
l.duqf <- (rqres$resCE)[,3]
u.duqf <- (rqres$resCE)[,4]
plot(c(0,1), range(c(min(l.duqf[rang]), max(u.duqf[rang]))), xlim = c(0,1),
     type = "n", xlab = expression(tau), ylab = "Difference in Food Expenditure",
     cex.lab=0.75)
polygon(c(taus[rang], rev(taus[rang])), c(u.duqf[rang], rev(l.duqf[rang])),
        density = -100, border = F, col = "grey70", lty = 1, lwd = 1)
lines(taus[rang], duqf[rang])
abline(h = 0, lty = 2)
legend(0, -90, "QE", cex = 0.75, lwd = 4, bty = "n", col = "grey70")
legend(0, -90, "QE", cex = 0.75, lty = 1, bty = "n", lwd = 1)


#### 案例2：
data(nlsw88)
attach(nlsw88)
lwage <- log(wage)
logitres <- counterfactual(lwage~tenure+ttl_exp+grade,
                           group = union, treatment=TRUE,
                           decomposition=TRUE, method = "logit",
                           weightedboot = TRUE, sepcore = TRUE, ncore=8)

taus <- c(1:99)/100
first <- sum(as.double(taus <= .10)) # as.double()满足条件返回1，有10个小于等于0.1的值，返回十个1，和为10；

last <- sum(as.double(taus <= .90))
rang <- c(first:last)
logitres <- counterfactual(lwage~tenure+ttl_exp+grade,
    group = union, treatment=TRUE, quantiles=taus, # 加1个分位数参数；
    method="logit", nreg=100, weightedboot = TRUE,
    printdeco=FALSE, decomposition = TRUE,
    sepcore = TRUE,ncore=8)



duqf_SE <- (logitres$resSE)[,1] # 第1列

l.duqf_SE <- (logitres$resSE)[,3]

u.duqf_SE <- (logitres$resSE)[,4]

duqf_CE <- (logitres$resCE)[,1]

l.duqf_CE <- (logitres$resCE)[,3]

u.duqf_CE <- (logitres$resCE)[,4]

duqf_TE <- (logitres$resTE)[,1]

l.duqf_TE <- (logitres$resTE)[,3]

u.duqf_TE <- (logitres$resTE)[,4]

range_x <- min(c(min(l.duqf_SE[rang]), min(l.duqf_CE[rang]),
                 min(l.duqf_TE[rang])))

range_y <- max(c(max(u.duqf_SE[rang]), max(u.duqf_CE[rang]),
                 max(u.duqf_TE[rang])))

par(mfrow=c(1,3))

plot(c(0,1), range(c(range_x, range_y)), xlim = c(0,1), type = "n",
     xlab = expression(tau), ylab = "Difference in Wages", cex.lab=0.75,
     main = "Total")

polygon(c(taus[rang],rev(taus[rang])),
        c(u.duqf_TE[rang], rev(l.duqf_TE[rang])), density = -100, border = F,
        col = "grey70", lty = 1, lwd = 1)

lines(taus[rang], duqf_TE[rang])

abline(h = 0, lty = 2)

plot(c(0,1), range(c(range_x, range_y)), xlim = c(0,1), type = "n",
     xlab = expression(tau), ylab = "", cex.lab=0.75, main = "Structure")

polygon(c(taus[rang],rev(taus[rang])),
        c(u.duqf_SE[rang], rev(l.duqf_SE[rang])), density = -100, border = F,
        col = "grey70", lty = 1, lwd = 1)

lines(taus[rang], duqf_SE[rang])

abline(h = 0, lty = 2)

plot(c(0,1), range(c(range_x, range_y)), xlim = c(0,1), type = "n",
     xlab = expression(tau), ylab = "", cex.lab=0.75, main = "Composition")

polygon(c(taus[rang],rev(taus[rang])),
        c(u.duqf_CE[rang], rev(l.duqf_CE[rang])), density = -100, border = F,
        col = "grey70", lty = 1, lwd = 1)

lines(taus[rang], duqf_CE[rang])

abline(h = 0, lty = 2)


















