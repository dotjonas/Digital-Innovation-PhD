## GENERATES DATA FRAME CONTAINING LONGITUDAL DATA
## Run lsa.R procedure first 


## clean and order document colnames
dyn <- as.matrix(LSAmatrix)
names(dyn) = sub("*.txt","",names(dyn)) # simplify column names 
write.csv(dyn, "../dynlsa.csv") # create scv to reorder columns manually in ascending order
dynlsa <- read.csv("../dynet_ordered.csv") # read the ordered data back in

## assign time intervals of one month to each
dec12 <- dynlsa[,1724:1843]
jan13 <- dynlsa[,1597:1723]
feb13 <- dynlsa[,1503:1596]
mar13 <- dynlsa[,1390:1502]
apr13 <- dynlsa[,1130:1389]
may13 <- dynlsa[,1105:1129]
jun13 <- dynlsa[,955:1104]
jul13 <- dynlsa[,902:954]
aug13 <- dynlsa[,851:901]
sep13 <- dynlsa[,743:850]
oct13 <- dynlsa[,633:742]
nov13 <- dynlsa[,568:632]
dec13 <- dynlsa[,503:567]
jan14 <- dynlsa[,479:502]
feb14 <- dynlsa[,366:478]
mar14 <- dynlsa[,122:365]
apr14 <- dynlsa[,68:121]
may14 <- dynlsa[,1:67]

months <- c(dec12,jan13,feb13,mar13,apr13,may13,jun13,jul13,aug13,sep13,oct13,nov13,dec13,jan14,feb14,mar14,apr14,may14)

# add each month to a list of matrices
