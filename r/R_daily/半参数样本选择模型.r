# 安装费了很大劲儿,通过在R3.1.1版本下,运行以下命令安装成功:
install.packages("SemiParSampleSel",repos="https://mran.microsoft.com/snapshot/2019-02-01/") # R 3.1.1版本下安装成功

# GJRM
install.packages("GJRM")
library("GJRM")
help("GJRM-package")
######################################################################
## Generate data
## Correlation between the two equations and covariate correlation 0.5 
## Sample size 2000 
######################################################################
rm(list = ls())

library(SemiParSampleSel) # 使用此安装包需要R3.1.1环境
help("SemiParSampleSel-package")
??SemiParSampleSel
### 模拟生成数据运行:
set.seed(0)

n <- 2000

rhC <- rhU <- 0.5      

SigmaU <- matrix(c(1, rhU, rhU, 1), 2, 2)
U      <- rmvnorm(n, rep(0,2), SigmaU)

SigmaC <- matrix(rhC, 3, 3); diag(SigmaC) <- 1

cov    <- rmvnorm(n, rep(0,3), SigmaC, method = "svd")
cov    <- pnorm(cov)

bi <- round(cov[,1]); x1 <- cov[,2]; x2 <- cov[,3]

f11 <- function(x) -0.7*(4*x + 2.5*x^2 + 0.7*sin(5*x) + cos(7.5*x))
f12 <- function(x) -0.4*( -0.3 - 1.6*x + sin(5*x))  
f21 <- function(x) 0.6*(exp(x) + sin(2.9*x)) 

ys <-  0.58 + 2.5*bi + f11(x1) + f12(x2) + U[, 1] > 0
y  <- -0.68 - 1.5*bi + f21(x1) +         + U[, 2]
yo <- y*(ys > 0)


dataSim <- data.frame(ys, yo, bi, x1, x2)

## CLASSIC SAMPLE SELECTION MODEL
## the first equation MUST be the selection equation

out <- SemiParSampleSel(list(ys ~ bi + x1 + x2, 
                             yo ~ bi + x1), 
                        data = dataSim)
conv.check(out)
summary(out)

AIC(out)
BIC(out)
aver(out)


## Not run:  

## SEMIPARAMETRIC SAMPLE SELECTION MODEL

## "cr" cubic regression spline basis      - "cs" shrinkage version of "cr"
## "tp" thin plate regression spline basis - "ts" shrinkage version of "tp"
## for smooths of one variable, "cr/cs" and "tp/ts" achieve similar results 
## k is the basis dimension - default is 10
## m is the order of the penalty for the specific term - default is 2

out <- SemiParSampleSel(list(ys ~ bi + s(x1, bs = "tp", k = 10, m = 2) + s(x2), 
                             yo ~ bi + s(x1)), 
                        data = dataSim)
conv.check(out)                        
AIC(out)
aver(out)

## compare the two summary outputs
## the second output produces a summary of the results obtained when only 
## the outcome equation is fitted, i.e. selection bias is not accounted for

summary(out)
summary(out$gam2)

## estimated smooth function plots
## the red line is the true curve
## the blue line is the naive curve not accounting for selection bias

x1.s <- sort(x1[dataSim$ys>0])
f21.x1 <- f21(x1.s)[order(x1.s)] - mean(f21(x1.s))

plot(out, eq = 2, ylim = c(-1, 0.8)); lines(x1.s, f21.x1, col = "red")
par(new = TRUE)
plot(out$gam2, se = FALSE, col = "blue", ylim = c(-1, 0.8), ylab = "", rug = FALSE)



## SEMIPARAMETRIC SAMPLE SELECTION MODEL with association and dispersion parameters 
## depending on covariates as well

out <- SemiParSampleSel(list(ys ~ bi + s(x1) + s(x2), 
                             yo ~ bi + s(x1),
                             ~ bi, 
                             ~ bi + x1), 
                        data = dataSim)
conv.check(out)                        
summary(out)
out$sigma
out$theta

#
#

###################################################
## example using Clayton copula with normal margins
###################################################

set.seed(0)

theta <- 5
sig  <- 1.5

myCop <- archmCopula(family = "clayton", dim = 2, param = theta)

# other copula options are for instance: "amh", "frank", "gumbel", "joe"
# for FGM use the following code:
# myCop <- fgmCopula(theta, dim=2)

bivg  <- mvdc(copula = myCop, c("norm", "norm"), 
              list(list(mean = 0, sd = 1), 
                   list(mean = 0, sd = sig)))
er    <- rMvdc(n, bivg)

ys <-  0.58 + 2.5*bi + f11(x1) + f12(x2) + er[, 1] > 0
y  <- -0.68 - 1.5*bi + f21(x1) +         + er[, 2]
yo <- y*(ys > 0)

dataSim <- data.frame(ys, yo, bi, x1, x2)

out <- SemiParSampleSel(list(ys ~ bi + s(x1) + s(x2), 
                             yo ~ bi + s(x1)), 
                        data = dataSim, BivD = "C0")
conv.check(out)
summary(out)
aver(out)

x1.s <- sort(x1[dataSim$ys>0])
f21.x1 <- f21(x1.s)[order(x1.s)] - mean(f21(x1.s))

plot(out, eq = 2, ylim = c(-1.1, 1.6)); lines(x1.s, f21.x1, col = "red")
par(new = TRUE)
plot(out$gam2, se = FALSE, col = "blue", ylim = c(-1.1, 1.6), ylab = "", rug = FALSE)

#
#

########################################################
## example using Gumbel copula with normal-gamma margins
########################################################

set.seed(0)

k <- 2                                # shape of gamma distribution
miu  <- exp(-0.68 - 1.5*bi + f21(x1)) # mean values of y's (log m = Xb)
lambda <- k/miu	                      # rate of gamma distribution

theta <- 6

# Two-dimensional Gumbel copula with unif margins
gumbel.cop <- onacopula("Gumbel", C(theta, 1:2))

# Random sample from two-dimensional Gumbel copula with uniform margins
U <- rnacopula(n = n, gumbel.cop)		  

# Margins: normal and gamma
er <- cbind(qnorm(U[,1], 0, 1), qgamma(U[, 2], shape = k, rate = lambda))

ys <- 0.58 + 2.5*bi + f11(x1) + f12(x2) + er[, 1] > 0
y  <- er[, 2]
yo <- y*(ys > 0)

dataSim <- data.frame(ys, yo, bi, x1, x2)

out <- SemiParSampleSel(list(ys ~ bi + s(x1) + s(x2), 
                             yo ~ bi + s(x1)), 
                        data = dataSim, BivD = "G0", margins = c("N", "G"))
conv.check(out)
summary(out)
aver(out)

x1.s <- sort(x1[dataSim$ys>0])
f21.x1 <- f21(x1.s)[order(x1.s)] - mean(f21(x1.s))

plot(out, eq = 2, ylim = c(-1.1, 1)); lines(x1.s, f21.x1, col = "red")
par(new = TRUE)
plot(out$gam2, se = FALSE, col = "blue", ylim = c(-1.1, 1), ylab = "", rug = FALSE)

#
#


########################################################
## Example for discrete margins and normal copula
########################################################


# Creating simulation function
bcds <- function(n, s.tau = 0.2, s.sigma = 1, s.nu = 0.5, 
                 rhC = 0.2, outcome.margin = "PO", copula = "FGM")  {
  
  # Generating covariates     
  SigmaC <- matrix( c(1,rhC,rhC,rhC,rhC,1,rhC,rhC,rhC,rhC,1,rhC,rhC,rhC,rhC,1), 4 , 4)
  covariates    <- rmvnorm(n,rep(0,4),SigmaC, method="svd")
  covariates    <- pnorm(covariates)
  x1 <- covariates[,1]
  x2 <- covariates[,2]
  x3 <- round(covariates[,3])
  x4 <- round(covariates[,4])
  
  # Establishing copula object
  if (copula == "FGM") {
    Cop <- fgmCopula(dim = 2, param = iTau(fgmCopula(), s.tau))
  } else if (copula == "N") {
    Cop <- ellipCopula(family = "normal", dim = 2, param = iTau(normalCopula(), s.tau))
  } else if (copula == "AMH") {
    Cop <- archmCopula(family = "amh", dim = 2, param = iTau(amhCopula(), s.tau))
  } else if (copula == "C0") {
    Cop <- archmCopula(family = "clayton", dim = 2, param = iTau(claytonCopula(), s.tau))
  } else if (copula == "F") {
    Cop <- archmCopula(family = "frank", dim = 2, param = iTau(frankCopula(), s.tau))
  } else if (copula == "G0") {
    Cop <- archmCopula(family = "gumbel", dim = 2, param = iTau(gumbelCopula(), s.tau))
  } else if (copula == "J0") {
    Cop <- archmCopula(family = "joe", dim = 2, param = iTau(joeCopula(), s.tau))
  }  
  
  # Setting up equations
  f1 <- function(x) 0.4*(-4 - (5.5*x-2.9) + 3*(4.5*x-2.3)^2 - (4.5*x-2.3)^3)
  f2 <- function(x) x*sin(8*x)
  mu_s  <- 1.0 + f1(x1) - 2.0*x2 + 3.1*x3 - 2.2*x4
  mu_o  <-  exp(1.3 + f2(x1) - 1.9*x2 + 2.4*x3 - 0.1*x4)
  
  # Creating margin dependent object
  if (outcome.margin == "P") {
    speclist <- list(mu = mu_o)
    outcome.margin2 <- "PO"
  } else if (outcome.margin == "NB") {
    speclist  <- list(mu = mu_o, sigma = s.sigma)
    outcome.margin2 <- "NBI"
  } else if (outcome.margin == "D") {
    speclist  <- list(mu = mu_o, sigma = s.sigma, nu = s.nu)
    outcome.margin2 <- "DEL"
  } else if (outcome.margin == "PIG") {
    speclist  <- list(mu = mu_o, sigma = s.sigma)
    outcome.margin2 <- "PIG"
  } else if (outcome.margin == "S") {
    speclist  <- list(mu = mu_o, sigma = s.sigma, nu = s.nu)
    outcome.margin2 <- "SICHEL"
  }
  spec  <- mvdc(copula = Cop, c("norm", outcome.margin2), 
                list(list(mean = mu_s, sd = 1), speclist))  
  
  # Simulating data
  simGen <- rMvdc(n, spec)
  y <- ifelse(simGen[,1]>0, simGen[,2], -99)
  
  dataSim <- data.frame(y, x1, x2, x3, x4)  
  dataSim  
}



# Creating plots of the true functional form of x1 in both equations
xt1  <- seq(0, 1, length.out=200)
xt2  <- seq(0,1, length.out=200)
f1t <- function(x) 0.4*(-4 - (5.5*x-2.9) + 3*(4.5*x-2.3)^2 - (4.5*x-2.3)^3)
f2t <- function(x) x*sin(8*x)
plot(xt1, f1t(xt1))
plot(xt2, f2t(xt2))




# Simulating 1000 deviates

set.seed(0)

dataSim<- bcds(1000, s.tau = 0.6, s.sigma = 0.1, s.nu = 0.5, 
               rhC = 0.5, outcome.margin = "NB", copula = "N")
dataSim$y.probit<-ifelse(dataSim$y >= 0, 1, 0)


# Estimating SemiParSampleSel

out1 <- SemiParSampleSel(list(y.probit ~ s(x1) + x2 + x3 + x4, y ~ s(x1) + x2 + x3 + x4), 
                         data = dataSim, BivD = "N", margins = c("N", "P")) 
conv.check(out1)

out2 <- SemiParSampleSel(list(y.probit ~ s(x1) + x2 + x3 + x4, y ~ s(x1) + x2 + x3 + x4), 
                         data = dataSim, BivD = "N", margins = c("N", "NB")) 
conv.check(out2)


# Model comparison

AIC(out1)
AIC(out2)
VuongClarke(out1, out2)


# Model diagnostics

summary(out2, cm.plot = TRUE)
plot(out2, eq = 1)
plot(out2, eq = 2)
aver(out2, univariate = TRUE)
aver(out2, univariate = FALSE)

#
#
################################################################################
### 实际案例数据运行:
# 搜索找到ND的数据集:search "the data from the rand health insurance experiment"
# 最新版本直接读取stata格式数据:
# R3.1.1版本过老,使用repos指定日期下载老版本:
install.packages("haven",repos = "https://mran.microsoft.com/snapshot/2019-02-01/")
rm(list = ls())
library(haven)
ND <- read_dta("F:/DownLoad/chrome/randdata.dta")
View(ND)
library(SemiParSampleSel)
sessionInfo()
??SemiParSampleSel
save(ND,file='F:/DownLoad/chrome/ND.Rdata')
load('F:/DownLoad/chrome/ND.Rdata')
### R 3.3.0
install.packages("checkpoint")
getwd()
setwd("E:/MyGit/r/semipar")
library("checkpoint")
checkpoint("2017-12-30")

SE <- binexp ~ logc + idp + fmde + physlm + disea + hlthg + hlthf +
  hlthp + female + child + fchild + black + s(lpi) + s(linc) + #缺少pi、inc变量
  s(lfam) + s(educdec) + s(xage)
OE <- lnmeddol ~ logc + idp + fmde + physlm + disea + hlthg + hlthf +
  hlthp + female + child + fchild + black + s(lpi) + s(linc) +
  s(lfam) + s(educdec) + s(xage)

out_N <- SemiParSampleSel(list(SE, OE), data = ND)
out_C <- SemiParSampleSel(list(SE, OE), data = ND, BivD = "C0")
out_J <- SemiParSampleSel(SE, OE, data = ND, BivD = "J0")
out_FGM <- SemiParSampleSel(SE, OE, data = ND, BivD = "FGM", gamma = 1.4)
out_F <- SemiParSampleSel(SE, OE, data = ND, BivD = "F", gamma = 1.4)
out_AMH <- SemiParSampleSel(SE, OE, data = ND, BivD = "AMH", gamma = 1.4)
out_G <- SemiParSampleSel(SE, OE, data = ND, BivD = "G", gamma = 1.4)

AIC_N <- AIC(out_N)
AIC_C <- AIC(out_C)
AIC_J <- AIC(out_J)
AIC_FGM <- AIC(out_FGM)
AIC_F <- AIC(out_F)
AIC_AMH <- AIC(out_AMH)
AIC_G <- AIC(out_G)

ss.checks(out_F)

set.seed(1)
summary(out_F)

plot(out_F, eq = 2, pages = 1, scale = 0, shade = TRUE, seWithMean = TRUE,
        cex.axis = 1.6, cex.lab = 1.6)

SE_s <- binexp ~ logc + idp + fmde + physlm + disea + hlthg + hlthf +
  hlthp + female + child + fchild + black +
  s(pi, bs = "ts") + s(inc, bs = "ts") + s(fam, bs = "ts") +
  s(educdec, bs = "ts") + s(xage, bs = "ts")
OE_s <- lnmeddol~ logc + idp + fmde + physlm + disea + hlthg + hlthf +
  hlthp + female + child + fchild + black +
  s(pi, bs = "ts") + s(inc, bs = "ts") + s(fam, bs = "ts") +
  s(educdec, bs = "ts") + s(xage, bs = "ts")
out_F_s <- SemiParSampleSel(SE_s, OE_s, data = ND, BivD = "F", gamma = 1.4)
plot(out_F_s, eq = 2, pages = 1, scale = 0, shade = TRUE, seWithMean = TRUE,
        cex.axis = 1.6, cex.lab = 1.6)






