## K-MEANS CLUSTERING OF MICRO SHIFTS
library(ggplot2)
nc = 15 # number of clusters to test cluster sum of squares
nclust = 5 # number of clusters selected as inout for kmeans algorithm

# Determine optimal number of k-means clusters within group SSE
wss <- (nrow(ms.matrix)-1) * sum(apply(ms.matrix, 2, var))
for (i in 2:nc) { 
      wss[i] <- sum(kmeans(ms.matrix, centers = i)$withinss)
}
#plot with ggplot2
n <- as.data.frame(wss)
n$nclust <- 1:nc
n
ggplot(data=n, aes(x=nclust,y=wss)) + 
      geom_line(alpha=.3) + 
      geom_point(size=3) +
      xlab("Number of Clusters") +
      ylab("Within groups sum of squares") +
      ggtitle("Cluster sum of squares")

# create dataframe with term, mean.sin.val, total count columns 
mean.sin.val <- apply(ms.matrix, 1, mean)
summary(mean.sin.val)
cluster.df <- as.data.frame(mean.sin.val)
sum.sin.val <- apply(ms.matrix,1,sum)
table(sum.sin.val)
cluster.df$sum.sin.val <- factor(sum.sin.val)
head(cluster.df)

# perform k-means clustering with 5 clusters (as determined above)
kclust <- kmeans(cluster.df, nclust) # k cluster solution
kclust
kclust$totss
table(kclust$cluster)

# update data frame with cluster and term columns
cluster.df$cluster = factor(kclust$cluster)
centers = as.data.frame(kclust$centers)
cluster.df$term <- ms.vector
head(centers)
head(cluster.df)

# plot variance
ggplot(data=cluster.df, aes(x=sum.sin.val, y=mean.sin.val)) + 
      geom_point() + 
      geom_point(data=centers, aes(x=sum.sin.val,y=mean.sin.val, color='Center')) +
      geom_point(data=centers, aes(x=sum.sin.val,y=mean.sin.val, color='Center'), size=52, alpha=.3, show_guide = FALSE)

# generate term vectors for each cluster
cluster.terms <- data.frame()
for (i in 1:nclust){
      t <- rownames(subset(cluster.df,cluster.df$cluster==i))
      print(c("Cluster",i,t,"/n"))
      cluster.terms$i <- t
}
cluster.terms
      

## WARD HIARARCHICAL CLUSTERING
clm <- dist(ms.matrix, method = "euclidean") # calculate distance matrix
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
