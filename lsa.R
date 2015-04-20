library(lsa)

# assign directory holding your docs
txtdir <- "../lsadocs"

#initialise stopwords
data(stopwords_en)

# create de-noised document-term matrix
tm <- textmatrix(txtdir, stemming = TRUE, stopwords = stopwords_en) # stemming = TRUE, 

# apply TF-IDF weighing algorithm
wm <- lw_logtf(tm) * gw_idf(tm) 
summary(wm)
head(wm)

# create the latent semantic space
LSAspace <- lsa(wm)
dim(LSAspace)

# display it as a textmatrix again
LSAmatrix <- as.textmatrix(LSAspace)
LSAmatrix # YES! SVD IS NOW COMPUTED!
dim(LSAmatrix)
tail(rownames(LSAmatrix))

# calculate the optimal dimensionality 
share <- 0.5 # 119 dimensions with standard share of 0.5
k <- min(which(cumsum(LSAspace$sk/sum(LSAspace$sk))>=share))
print(k)
LSAreduced <- lsa(wm, dims = k)
summary(LSAreduced)

## EXTRAS FROM HERE

# scree of varience explained by dims
ul <- unlist(LSAreduced)
screeplot(diag(ul))
s <- as.list(LSAmatrix$sk)
screeplot(s, xlim = c(1,1000), ylim = c(1,100))
LSAmatrix$sk

# plot it!
t.locs <- LSAspace$tk %*% diag(LSAspace$sk)
plot(t.locs, type = "p")
text(t.locs, labels = rownames(LSAspace$tk))


# compare two terms with the cosine measure
cosine(LSAmatrix["cashier", ], LSAmatrix["angela", ])
cosine(LSAmatrix["digitaleagl", ], LSAmatrix["radical", ])

# calc associations for term
associate(LSAmatrix, "teach", measure = "cosine")
associate(LSAmatrix, "issue", measure = "cosine")

# demonstrate generation of a query
query("digitaleagl disrupt radical please", rownames(LSAmatrix))

# compare two documents with pearson
cor(wm[ ,1], wm[ ,2], method = "pearson")

## LSA search

# sk - The sigma diagonal matrix
sk <- matrix(0, length(LSAspace$sk), length(LSAspace$sk))
       for (i in 1:length(LSAspace$sk)) {
 		sk[i,i] <- LSAspace$sk[i]
 	}
print(sk[1:8,1:8])

