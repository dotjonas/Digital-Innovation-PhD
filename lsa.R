## GENERATES SEMANTIC VECTOR SPACE FROM DOCUMENT REPOSITORY
library(SnowballC)
library(lsa)

# assign directory holding your docs
txtdir <- "../lsadocs"

#initialise stopwords
data(stopwords_en)

# create de-noised document-term matrix
docterm.matrix <- textmatrix(txtdir, stemming = TRUE, stopwords = stopwords_en) # stemming = TRUE, 

# apply TF-IDF weighing algorithm
docterm.weighed <- lw_logtf(docterm.matrix) * gw_idf(docterm.matrix) 
summary(docterm.weighed)
head(docterm.weighed)

# create the latent semantic space
lsa.space <- lsa(docterm.weighed)
summary(lsa.space)

# display it as a texmatrixatrix again
lsa.matrix <- as.textmatrix(lsa.space)
lsa.matrix # YES! SVD IS NOW COMPUTED!
dim(lsa.matrix)
head(rownames(lsa.matrix))

# calculate the optimal dimensionality 
share <- 0.5 # 118 dimensions with standard share of 0.5
k <- min(which(cumsum(lsa.space$sk/sum(lsa.space$sk))>=share))
print(k)
lsa.reduced <- lsa(docterm.weighed, dims = k)
summary(lsa.reduced)

