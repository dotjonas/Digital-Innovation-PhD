## PERFORMS HIERARCHICAL CLUSTERING OF MICRO SHIFTS

# Determine optimal number of k-means clusters
wss <- (nrow(tm)-1) * sum(apply(msm, 2, var))
for (i in 1:5) { 
      wss[i] <- sum(kmeans(msm, centers = i)$withinss)
}
plot(1:5, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares", main = "Cluster sum of squares")

# perform k-means clustering with 5 clusters (as determined above)
kc <- kmeans(msm, 5) # k cluster solution
# get cluster means 
aggregate(msm[1:273], by = list(kc$cluster), FUN = mean)
aggregate(kc$cluster, by = list(msv), FUN = mean) # cluster for each term

# append cluster assignment
msm <- data.frame(msm[1:273], kc$cluster)

# PLOT

# Cluster Plot against 1st 2 principal components

# vary parameters for most readable graph
library(cluster) 
clusplot(msm, kc$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

# Centroid Plot against 1st 2 discriminant functions
library(fpc)
plotcluster(msm, kc$cluster)

# plot it
library(cluster)
library(HSAUR)

dissE <- daisy(msm) 
dE2   <- dissE^2
sk2   <- silhouette(kc$cluster, dE2)
plot(sk2)



# get cluster means 
cmean <- as.data.frame(mn)
aggregate(cmean, by = m, FUN = mean)


## VARIOUS PLOTS FOR CLUSTER DENDOGRAMS

# draw fan type dendo with ape
library(ape)
plot(as.phylo(hc), type = "fan")

# plot dendrogram with some cuts
op = par(mfrow = c(2, 1))
plot(cut(hc, breaks=1:50, h = 75), main = "Upper tree of cut at h=75")
plot(cut(clm, h = 75)$lower[[2]], main = "Second branch of lower tree with cut at h=75")

# generate micro shift - document matrix



# Ward Hierarchical Clustering
clm <- dist(msm, method = "euclidean") # calculate distance matrix
nclust <- 4
hc <- hclust(clm, method="ward.D") 
groups <- cutree(hc, k = nclust) # cut tree into k clusters
plot(hc, main = "Micro Shift Dimension Clustering") # display dendogram
rect.hclust(hc, k = nclust, border = "red") # add red borders around the k clusters 

clusterMatrix <- as.matrix(hc)
table(clusterMatrix)

# get terms for each cluster 
for (i in 1:nclust){
      n <- names(subset(groups, groups == i))
      print(c("CLUSTER",n))
}

# append cluster assignment

clm <- data.frame(clm, hc$cluster)