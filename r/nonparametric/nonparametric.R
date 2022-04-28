install.packages('np')
install.packages('crs')
install.packages('npRmpi') # 版本不对;
library('np')
library('crs')
example('crs')
example("npreg")

#### 简单单变量局部常量和局部线性回归与绘图简介####
rm(list=ls())
library(np)
data(cps71)
## Attach the data so that the variables `logwage' and `age' can be
## called directly
attach(cps71)

## Plot the data (note it is sorted on age already which helps when
## plotting the lines below, and note the cex=0.25 uses circles that
## are 1/4 the standard size that are grey not black which is the
## default)

plot(age,logwage,cex=0.25,col="grey")

## Fit a (default) local constant model (since we do not explicitly
## call npregbw() which conducts least-squares cross-validated
## bandwidth selection by default it is automatically invoked when we
## call npreg())

model.lc <- npreg(logwage~age)

## Plot the fitted values (the colors and linetypes allow us to
## distinguish different plots on the same figure)

lines(age,fitted(model.lc),col=1,lty=1)


## Fit a local linear model (we use the arguments regtype="ll" to do
## this)

model.ll <- npreg(logwage~age,regtype="ll")

## Plot the fitted values with a different color and linetype

lines(age,fitted(model.ll),col=2,lty=2)


## Add a legend

legend("topleft",
       c("Local Constant","Local Linear"),
       lty=c(1,2),
       col=c(1,2),
       bty="n")

#### 简单单变量局部常数和局部线性回归及导数估计####
rm(list=ls())

## Here is a simple illustration to help you get started with
## univariate kernel regression and derivative estimation.

## First, let's grab some data from the np package

## Load the np package

library(np)

## Load the cps71 dataset contained in the np package

data(cps71)

## Attach the data so that the variables `logwage' and `age' can be
## called directly

attach(cps71)

## Fit a (default) local constant model and compute the derivatives
## (since we do not explicitly call npregbw() which conducts
## least-squares cross-validated bandwidth selection by default it is
## automatically invoked when we call npreg())

model.lc <- npreg(logwage~age,gradients=TRUE)

## Plot the estimated derivatives (the colors and linetypes allow us
## to distinguish different plots on the same figure). Note that the
## function `gradients' is specific to the np package and works only
## when the argument `gradients=TRUE' is invoked when calling npreg()

plot(age,gradients(model.lc),
     ylab="Derivative",
     col=1,
     lty=1,
     type="l")

## Fit a local linear model (we use the arguments regtype="ll" to do
## this)

model.ll <- npreg(logwage~age,regtype="ll",gradients=TRUE)

## Plot the fitted values with a different color and linetype

lines(age,gradients(model.ll),col=2,lty=2)

## Add a legend

legend("topleft",
       c("Local Constant","Local Linear"),
       lty=c(1,2),
       col=c(1,2),
       bty="n")

#### 通过`plot（foo，...）'绘制对象的介绍####
# 其中foo是一个非参数对象，添加了误差范围（渐近线和自举），依此类推
rm(list=ls())

## Here is a simple illustration to help you get started with
## univariate kernel regression and plotting via R's `plot' function
## (which calls the np function `npplot')

## First, let's grab some data from the np package

## Load the np package

library(np)

## Load the cps71 dataset contained in the np package

data(cps71)

## Attach the data so that the variables `logwage' and `age' can be
## called directly

attach(cps71)

## Fit a local linear model (since we do not explicitly call npregbw()
## which conducts least-squares cross-validated bandwidth selection by
## default it is automatically invoked when we call npreg())

model.ll <- npreg(logwage~age,regtype="ll")

## model.ll will be an object of class `npreg'. The generic R function
## `plot' will call `npplot' when it is deployed on an object of this
## type (see ?npplot for details on supported npplot
## arguments). Calling plot on a npreg object allows you to do some
## tedious things without having to write code such as including
## confidence intervals as the following example demonstrates. Note
## also that we do not explicitly have to specify `gradients=TRUE' in
## the call to npreg() as plot (npplot) will take care of this for
## us. Below we use the asymptotic standard error estimates and then
## take +- 1.96 standard error)

plot(model.ll,plot.errors.method="asymptotic",plot.errors.style="band")

## We might also wish to use bootstrapping instead (here we bootstrap
## the standard errors and then take +- 1.96 standard error)

plot(model.ll,plot.errors.method="bootstrap",plot.errors.style="band")

## Alternately, we might compute true nonparametric confidence
## intervals using (by default) the 0.025 and 0.975 percentiles of the
## pointwise bootstrap distributions

plot(model.ll,plot.errors.method="bootstrap",plot.errors.type="quantiles",plot.errors.style="band")

## Note that adding the argument `gradients=TRUE' to the plot call
## will automatically plot the derivatives instead

plot(model.ll,plot.errors.method="bootstrap",plot.errors.type="quantiles",plot.errors.style="band",gradients=TRUE)

#### 多元回归简介####
rm(list=ls())

## Here is a simple illustration to help you get started with
## multivariate kernel regression and plotting via R's `plot' function
## (which calls the np function `npplot')

## First, let's grab some data from the np package

## Load the np package

library(np)

## Load the wage1 dataset contained in the np package

data(wage1)

## Attach the data so that the variables `lwage', `female', `educ' and
## `exper' can be called directly

attach(wage1)

## Fit a local linear model (since we do not explicitly call npregbw()
## which conducts least-squares cross-validated bandwidth selection by
## default it is automatically invoked when we call npreg()). Here we
## have a `factor' (female) and two `numeric' predictors (educ and
## exper - see ?wage1 for details)

model <- npreg(lwage~female+educ+exper,regtype="ll")


## model will be an object of class `npreg'. The generic R function
## `plot' will call `npplot' when it is deployed on an object of this
## type (see ?npplot for details on supported npplot
## arguments). Calling plot on a npreg object allows you to do some
## tedious things without having to write code such as including
## confidence intervals as the following example demonstrates. Note
## also that we do not explicitly have to specify `gradients=TRUE' in
## the call to npreg() as plot (npplot) will take care of this for
## us. Below we use the asymptotic standard error estimates and then
## take +- 1.96 standard error)

plot(model,plot.errors.method="asymptotic",plot.errors.style="band")

## We might also wish to use bootstrapping instead (here we bootstrap
## the standard errors and then take +- 1.96 standard error)

plot(model,plot.errors.method="bootstrap",plot.errors.style="band")

## Alternately, we might compute true nonparametric confidence
## intervals using (by default) the 0.025 and 0.975 percentiles of the
## pointwise bootstrap distributions

plot(model,plot.errors.method="bootstrap",plot.errors.type="quantiles",plot.errors.style="band")

## Note that adding the argument `gradients=TRUE' to the plot call
## will automatically plot the derivatives instead

plot(model,plot.errors.method="bootstrap",plot.errors.type="quantiles",plot.errors.style="band",gradients=TRUE)

