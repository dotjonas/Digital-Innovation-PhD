## MEASURES EFFECT OF MICRO-SHIFTS ON ACTOR NETWORK
## Run microshift.R procedure first to identify micro shifts


## clean and order document colnames
dynlsa <- as.data.frame(LSAmatrix)
names(dynlsa) = sub("*.txt","",names(dynlsa)) # simplify column names 
write.csv(dynlsa, "../dynlsalsa.csv") # create scv to reorder columns manually in ascending order
dynlsa <- read.csv("../dynet_ordered.csv") # read the ordered data back in



# attribute author to document













## split into relevant time intervals for each month

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

# add each month to a list of matrices
