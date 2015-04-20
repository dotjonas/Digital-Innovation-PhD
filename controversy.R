## Run LSA.R procedure first to genreate semantic space

# Generate controversy query vector
querytext <- "problem issue trouble dispite disagree dont anyway admit competition oppose doesnot clash conflict confrontation encounter engagement fracas rub run-in scrap set-to skirmish tap touch tussle claiming confrontation dare defiance demanding demur interrogation objection protest provocation remonstrance contest test threat trial ultimatum affray argument battle brawl break broil brush bump collision concussion conflict confrontation crash difference of opinion discord discordance disharmony dispute donnybrook embroilment encounter engagement fracas fray have a go at each other impact jam jar jolt jump melee misunderstanding mix-up opposition rift riot row rumpus run-in rupture scrap scrimmage set-to shock showdown skirmish smash wallop"
q <- query(querytext, rownames(LSAmatrix), stemming = TRUE)
print(q)
summary(q)

## extract non-zero terms from search result
qm <- as.matrix(q)
qv <- names(qm[qm > 0, ])  # add corresponding values to controverusy vector

## add semantically assiciated terms to controversy vector
cv <- ""
for (i in 1:length(qv)){
      print(qv[[i]])
      associations <- associate(LSAmatrix, qv[i], measure = "cosine", threshold = 0.7)
      associations <- associations[associations != ""]
      print(names(associations))
      cv <- c(cv, names(associations))   
}
cv <- cv[cv != ""]
summary(cv)

## create a controversy matrix based on controversy vector
m <- LSAmatrix[cv, ] # subset LSAmatrix rows by the controversy vector
cm <- as.textmatrix(m) # turn it into a textmatrix object
class(cm)  # show me it worked

## clean and order document colnames
dynlsa <- as.data.frame(LSAmatrix)
names(dynlsa) = sub("*.txt","",names(dynlsa)) # simplify column names 
write.csv(dynlsa, "../dynlsalsa.csv") # create scv to reorder columns manually in ascending order
dynlsa <- read.csv("../dynlsalsa_ordered.csv") # read the ordered data back in

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


# calculate mean of singular values for each cluster
tech <- c("download", "ipad")
roi <- c("value")


