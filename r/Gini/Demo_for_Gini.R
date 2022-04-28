# install.packages("IC2")
# install.packages("tidyverse")
# install.packages("reshape2")
# install.packages("xtable")
# install.packages("flextable")

library(IC2)
library(tidyverse)
library(reshape2)


rm(list = ls())

setwd("E:/MyGit/r/Gini")

func_Dagum_dec=function(x,z){
  #目前R提供了dineq, ineqjD, ilneq, IC2包用于Gini测算和分解，但都不是Dagum基尼系数分解
  #为了弥补这一不足，本函数主要用于Dagum基尼系数分解
  #相对于网上其他函数的优点：
  #第一，本函数为R语言构建，程序简单明了且包含了必要注释。
  #第二，本函数一站式运行，没有烦人的子函数，无需对数据或参数进行设置。
  #第三，本函数可以对任意多分组的Gini进行测算和分解。比如可以用于企业、省-市数据等。
  #最后，本函数导出结果丰富多样并包含详细的注释。
  #用之前先运行一遍这个函数
  #x为数据向量
  #z为分组向量
  #注意.原始x和z的length必须相同，后面会自动根据z对x进行分组
  z=as.factor(z)#需要注意的是z必须为因子factor,所以这里用as.factor()函数来转换
  library(IC2)
  library(tidyverse)
  library(reshape2)
  df <- data.frame(x = x, z = z)%>%filter(.,!is.na(x)&!is.na(z))#构建数据框，如果包含缺失值则改行被删除
  df <- df[complete.cases(df), , drop = FALSE]
  df[, "z"] <- factor(df[, "z"], exclude = NULL)
  df <- df[order(df[, "x"]), ]
  dfSplit <- split(df[, c("x")], df[, "z"])
  #子群Gini
  i=2
  G_jj=NULL
  p_j=NULL
  s_j=NULL
  G_Wj=NULL
  for (i in 1:length(unique(z))) {
    X_j=dfSplit[i]%>%unlist()%>%as.numeric()
    G_jj[i]=calcSGini(X_j,NULL)[["ineq"]][["index"]]#子群内部Gini系数汇总
    p_j[i]=length(X_j)/length(x)
    s_j[i]=length(X_j)*mean(X_j)/(length(x)*mean(x))
    G_Wj[i]=G_jj[i]*p_j[i]*s_j[i]
  }
  G_W=sum(G_Wj)#子群内的Gini系数
  G_jh=NULL
  d_jh=NULL
  p_jh=NULL
  D_jh=NULL
  G_nb_j=NULL
  G_t_j=NULL
  names_jh=NULL
  # i=1
  # ii=2
  for (i in 1:c(length(unique(z)-1))) {
    for (ii in 2:length(unique(z))) {
      if(i<ii){
        X_i=dfSplit[i]%>%unlist()%>%as.numeric()
        X_ii=dfSplit[ii]%>%unlist()%>%as.numeric()
        EE=matrix(rep(X_i,length(X_ii)),ncol = length(X_ii))-
          matrix(rep(X_ii,each=length(X_i)),nrow = length(X_i))
        EE_jh=as.numeric(EE)
        G_jh0=sum(abs(EE))/(length(X_ii)*length(X_i)*(mean(X_i)+mean(X_ii)))
        G_jh=c(G_jh,G_jh0)#子群间的Gini系数汇总
        d_jh0=sum(EE_jh[which(EE_jh>0)])/(length(X_i)*length(X_ii))
        d_jh=c(d_jh,d_jh0)
        p_jh0=sum(abs(EE_jh[which(EE_jh<0)]))/(length(X_ii)*length(X_i))
        p_jh=c(p_jh,p_jh0)
        D_jh0=abs(d_jh0-p_jh0)/(d_jh0+p_jh0)   #abs
        D_jh=c(D_jh,D_jh0)
        p_i=length(X_i)/length(x)
        p_ii=length(X_ii)/length(x)
        s_i=length(X_i)*mean(X_i)/(length(x)*mean(x))
        s_ii=length(X_ii)*mean(X_ii)/(length(x)*mean(x))
        G_nb0=G_jh0*(p_i*s_ii+p_ii*s_i)*D_jh0
        G_nb_j=c(G_nb_j,G_nb0)
        G_t0=G_jh0*(p_i*s_ii+p_ii*s_i)*(1-D_jh0)
        G_t_j=c(G_t_j,G_t0)#每个子群间的超变密度贡献汇总
        names_jh0=paste(sort(unique(z))[i],"_",sort(unique(z))[ii],sep="")
        names_jh=c(names_jh,names_jh0)#命名
      }
    }
  }
  within_sub_Gini=matrix(G_jj,ncol = length(G_jj))%>%as.data.frame()#子群内的Gini系数
  colnames(within_sub_Gini)=sort(unique(z))#子群内的Gini系数命名
  within_sub_contribution=matrix(G_Wj,ncol = length(G_Wj))%>%as.data.frame()#子群内的Gini贡献
  colnames(within_sub_contribution)=sort(unique(z))#子群内的Gini贡献命名
  
  between_sub_contribution=matrix(G_nb_j,ncol = length(G_nb_j))%>%as.data.frame()#子群间的Gini贡献
  colnames(between_sub_contribution)=names_jh#子群间的Gini贡献命名
  between_sub_Gini=matrix(G_jh,ncol = length(G_jh))%>%as.data.frame()#子群间的Gini系数
  colnames(between_sub_Gini)=names_jh#子群间的Gini系数命名
  
  
  G_nb=sum(G_nb_j)#子群间的Gini贡献加总
  G_t=sum(G_t_j)#超变密度总贡献
  SGini=G_W+G_nb+G_t#用于当且仅当SGini==SGini_test正确，否则错误
  SGini_test=calcSGini(x,NULL)[["ineq"]][["index"]]%>%as.numeric()#IC2自带函数测算的结果
  
  print("SGini_test用于检验本函数是否正确，当且仅当SGini==SGini_test正确，否则出错")
  
  SGD=list(ineq = list(SGini = SGini, SGini_test = SGini_test), 
           Gini_details=list(within_sub_Gini = within_sub_Gini, 
                             between_sub_Gini = between_sub_Gini),
           
           decomp_sum = list(within_total_contribution = G_W, between_total_contribution = G_nb, 
                             overlap_total_contribution = G_t), 
           
           decom_details=list(within_sub_contribution = within_sub_contribution, 
                              between_sub_contribution = between_sub_contribution))
  return(SGD)
}


Deom_data=read.csv("gini.csv")   # 修改为自己的csv格式数据路径和名称；
head(Deom_data)

Gini_frame=NULL
for (i in 1:length(unique(Deom_data$Year))) {
  data_Dagum_Gini=Deom_data%>%
    filter(.,Year==min(Year)+i-1)#逐年
  unique(data_Dagum_Gini$Year)
  dim(data_Dagum_Gini)
  x=data_Dagum_Gini%>%.$x
  length(x)
  z=data_Dagum_Gini%>%.$z#你也可以用Province，那么则以28个省进行分组
  length(z)
  Dagum_Gini=func_Dagum_dec(x,z)#函数运行
  
  SGini=Dagum_Gini$ineq$SGini
  within_Gini=Dagum_Gini$Gini_details$within_sub_Gini
  between_Gini=Dagum_Gini$Gini_details$between_sub_Gini
  within_contribution=Dagum_Gini$decomp_sum$within_total_contribution
  between_contribution=Dagum_Gini$decomp_sum$between_total_contribution
  overlap_contribution=Dagum_Gini$decomp_sum$overlap_total_contribution
  Year=2004+i #这里的年份需要修改
  
  Gini_frame_0=data.frame(
    Year=Year,
    SGini=Dagum_Gini$ineq$SGini,
    within_Gini,
    between_Gini,
    within_contribution,
    between_contribution,
    overlap_contribution
  )
  
  Gini_frame=rbind(Gini_frame,Gini_frame_0)
  
}

#结果
Gini_frame




