install.packages("xlsx")
install.packages("lpSolve")
rm(list = ls())
library("xlsx")
library("lpSolve")
getwd()
data <- read.xlsx("data.xlsx",1,header = T)
View(data)
data
typeof(data)
inputs <- data.frame(data[2])
inputs
typeof(inputs)
outputs <- data.frame(data[c(3,4,5)])
outputs
typeof(outputs)
dim(data)
N <- dim(data)[1]
s <- dim(input)[2]
m <- dim(output)[2]
f.rhs <- c(rep(0,1,N),1) 
f.dir <- c(rep("<=",1,N),"=") 
aux <- cbind(-1*inputs,outputs)
for (i in 1:N) {
    f.obj <- c(0*rep(1,s),as.numeric(outputs[i,])) 
    f.con <- rbind(aux ,c(as.numeric(inputs[i,]), rep(0,1,m))) 
    results <- lp ("max",as.numeric(f.obj), f.con, f.dir, f.rhs,scale=0, compute.sens=TRUE) 
    if (i==1) { 
        weights <- results$solution 
        effcrs <- results$objval 
        lambdas <- results$duals[seq(1,N)] 
    } else { 
            weights <- rbind(weights, results$solution) 
            effcrs <- rbind(effcrs , results$objval) 
            lambdas <- rbind(lambdas, results$duals[seq(1,N)] ) 
    } 
}
# merge the efficiency and multipliers
spreadsheet <- cbind(effcrs,weights)
# assign the utilities’ names to the spreadsheet rows
rownames(spreadsheet) <- data[,1]
# assign the variables names to the spreadsheet columns
colnames(spreadsheet) <- c('efficiency',names(inputs),names(outputs))
# record file by xlsReadWrite package
write.xlsx(spreadsheet ,"resultscrs.xls",colNames = TRUE,sheet = 1,from = 1)
# or record file by xlsx package
write.xlsx(spreadsheet ,"resultscrs.xls",col.names = TRUE)
# duals variables
spreadsheet<-lambdas
# assign the utilities’ names to the spreadsheet rows and columns
rownames(spreadsheet)<-data[,1]
colnames(spreadsheet)<- data[,1]
# record file by xlsReadWrite package
write.xls(spreadsheet ,"dualscrs.xls",colNames = TRUE,sheet = 1,from = 1)
# or record file by xlsx package
write.xlsx(spreadsheet ,"dualscrs.xls",col.names = TRUE)







