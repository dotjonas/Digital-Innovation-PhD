library(lsa)

# assign directory holding your docs
txtdir <- "lsadocs"

#initialise stopwords
data(stopwords_en)

# read files into a document-term matrix
tm <- textmatrix(txtdir, stemming=TRUE) # stemming = TRUE, stopwords = stopwords_en
myMatrix <- lw_bintf(tm) * gw_idf(tm)
summary(tm)

# create the latent semantic space
# LSAspace <- lsa(myMatrix, dims = dimcalc_raw())     # Raw = no LSA, pure vector model!
LSAspace <- lsa(myMatrix, dims = 50)

# display it as a textmatrix again
round(as.textmatrix(LSAspace), 2) # should give the original
 
# display it as a textmatrix again
LSAMatrix <- as.textmatrix(LSAspace)
LSAMatrix # should be different!
# YES! SVD IS NOW COMPUTED!

print(rownames(LSAMatrix))

# plot it!
t.locs <- LSAspace$tk %*% diag(LSAspace$sk)
plot(t.locs,type="p")
text(t.locs, labels=rownames(LSAspace$tk))

# compare two terms with the cosine measure
cosine(LSAMatrix["cashier", ], myMatrix["branch", ])

# calc associations for term
associate(LSAMatrix, "branch", measure = "cosine")

# demonstrate generation of a query

query("digitaleagl", rownames(LSAMatrix))
query("myZone", rownames(myMatrix)) 

# compare two documents with pearson
cor(myMatrix[ ,1], myMatrix[ ,2], method = "pearson")
