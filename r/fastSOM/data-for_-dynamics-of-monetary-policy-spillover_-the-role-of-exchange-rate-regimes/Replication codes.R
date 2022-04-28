library(fastSOM)
library(openxlsx)
library(vars)

MAcoefs <- function (Sigma, ARcoefs, H)
{
  nstep <- H - 1
  nstep <- abs(as.integer(nstep))
  K <- dim(Sigma)[1]
  p <- length(ARcoefs)
  if (nstep >= p) {
    As <- array(0, dim = c(K, K, nstep + 1))
    for (i in (p + 1):(nstep + 1)) {
      As[, , i] <- matrix(0, nrow = K, ncol = K)
    }
  }
  else {
    As <- array(0, dim = c(K, K, p))
  }
  for (i in 1:p) {
    As[, , i] <- ARcoefs[[i]]
  }
  Phi <- array(0, dim = c(K, K, nstep + 1))
  Phi[, , 1] <- diag(K)
  Phi[, , 2] <- Phi[, , 1] %*% As[, , 1]
  if (nstep > 1) {
    for (i in 3:(nstep + 1)) {
      tmp1 <- Phi[, , 1] %*% As[, , i - 1]
      tmp2 <- matrix(0, nrow = K, ncol = K)
      idx <- (i - 2):1
      for (j in 1:(i - 2)) {
        tmp2 <- tmp2 + Phi[, , j + 1] %*% As[, , idx[j]]
      }
      Phi[, , i] <- tmp1 + tmp2
    }
  }
  return(Phi)
} 
### Table 1 ###
data_vola = read.xlsx("Replication.xlsx", sheet=z) ### Change sheet no. for appropriate set of sample economies
control=read.xlsx("Controls.xlsx")
Lagdata=data.frame(VARselect(data_vola[,-1], season = 52, exogen = control ))
EstRes=VAR(data_vola[,-1],p=Lagdata[1,1], exogen = control) ### Lagdata[1,1] and Lagdata[3,1] for lags suggested by AIC and SBC respectively
Sigma=summary(EstRes)$covres
A=MAcoefs(Sigma,Acoef(EstRes), H=h) ### H=No. of horizons; This study uses 2 weeks and 10 weeks
res_Ret <- soi_avg_exact(Sigma,A,ncores=0) ### This contains the max,avg and min SI values.



### Figs 3 and 4
SI_data=data.frame()
for (i in 1:546) {
  data_vola = read.xlsx("Replication.xlsx", sheet=1) ### Change sheet no. for appropriate set of sample economies
  control=read.xlsx("Controls.xlsx")
  data_vola = data_vola[i:(i+199),] ### For 200 weeks rolling window
  control=control[i:(i+199),] ### For 200 weeks rolling window
  Lagdata=data.frame(VARselect(data_vola[,-1], season = 52, exogen = control ))
  EstRes = VAR(data_vola[,-1],p=Lagdata[1,1], exogen = control) ### We use only AIC values in this section
  Sigma = summary(EstRes)$covres
  A = MAcoefs(Sigma,Acoef(EstRes), H=h) ### H=No. of horizons; This study uses 2 weeks and 10 weeks
  res_Ret = data.frame(soi_avg_exact(Sigma,A,ncores=0))
  res_Ret=res_Ret[1,(1:3)]
  SI_data=rbind(SI_data,res_Ret)
}

write.xlsx(SI_data,"SI_data.xlsx")


