## GENERATES DATA FRAME CONTAINING LONGITUDAL DATA
## Run lsa.R procedure first 
nclust = 5

## clean and order ms matrix 
dyn <- as.data.frame(ms.matrix)
colnames(dyn) = sub("*.txt","",colnames(dyn))# simplify column names 
head(dyn)
write.csv(dyn, "../dyn.df.csv") # create scv to reorder columns manually in ascending order
dyn.df <- read.csv("../dynet_ordered.csv") # read the ordered data back in
colnames(dyn.df) = sub("X*","",colnames(dyn.df))
head(dyn.df[1:10,1:10])


# do kmeans by month
dec12 <- kmeans(dyn.df[,1724:1843], nclust)
jan13 <- kmeans(dyn.df[,1597:1723], nclust)
feb13 <- kmeans(dyn.df[,1503:1596], nclust)
mar13 <- kmeans(dyn.df[,1390:1502], nclust)
apr13 <- kmeans(dyn.df[,1130:1389], nclust)
may13 <- kmeans(dyn.df[,1105:1129], nclust)
jun13 <- kmeans(dyn.df[,955:1104], nclust)
jul13 <- kmeans(dyn.df[,902:954], nclust)
aug13 <- kmeans(dyn.df[,851:901], nclust)
sep13 <- kmeans(dyn.df[,743:850], nclust)
oct13 <- kmeans(dyn.df[,633:742], nclust)
nov13 <- kmeans(dyn.df[,568:632], nclust)
dec13 <- kmeans(dyn.df[,503:567], nclust)
jan14 <- kmeans(dyn.df[,479:502], nclust)
feb14 <- kmeans(dyn.df[,366:478], nclust)
mar14 <- kmeans(dyn.df[,122:365], nclust)
apr14 <- kmeans(dyn.df[,68:121], nclust)
may14 <- kmeans(dyn.df[,1:67], nclust)

# generate vector of subsets
months <- list(dec12,jan13,feb13,mar13,apr13,may13,jun13,jul13,aug13,sep13,oct13,nov13,dec13,jan14,feb14,mar14,apr14,may14)

#initialise data frames
month.df <- data.frame()
ms.withinss.df <- data.frame()

# iterate over each month to add data to data frames
for (m in months){
      
      mdf <- data.frame(m$totss) # total sum of squares by month
      mdf$total.within.ss <- m$tot.withinss # within group sum of squares by month
      mdf$between.ss <- m$betweenss # betweenness by month
      # add to data frame by month
      month.df <- rbind(month.df, mdf)
      # within groups sum of squares by cluster
      print(m$withinss)
      ms.withinss.df <- rbind(ms.withinss.df, m$withinss)
}
month.df
month.df$month <- as.numeric(rownames(month.df)) # add month identifier column for plotting

ms.withinss.df$month <- as.numeric(rownames(ms.withinss.df)) # add month identifier column for plotting
colnames(ms.withinss.df) <- c("cl.1", "cl.2", "cl.3", "cl.4", "cl.5", "month" ) # assign cluster id as column names
ms.withinss.df
dim(ms.withinss.df)

# plot total sum of squares by manth (micro-shift level)
library(ggplot2)
ggplot(data=month.df, aes(x=month, y=total.within.ss)) + 
      geom_point(size=3) +
      geom_line(alpha=.3) +
      xlab("Month") +
      ylab("Micro-shift level") +
      ggtitle("Micro-shift level over time")

# plot within group sum of squares by cluster per month

ggplot(ms.withinss.df, aes(x = month)) + 
      geom_point(aes(y = ms.withinss.df$a), colour= "blue", size=3) + 
      geom_line(alpha=.3, colour= "blue", aes(y = ms.withinss.df$a)) +
      geom_point(aes(y = ms.withinss.df$b), colour = "red", size=3) + 
      geom_line(alpha=.3, colour = "red", aes(y = ms.withinss.df$b)) +
      geom_point(aes(y = ms.withinss.df$c), colour = "black", size=3) + 
      geom_line(alpha=.3, colour = "black", aes(y = ms.withinss.df$c)) +
      geom_point(aes(y = ms.withinss.df$d), colour = "orange", size=3) + 
      geom_line(alpha=.3, colour = "orange", aes(y = ms.withinss.df$d)) +
      geom_point(aes(y = ms.withinss.df$e), colour = "cyan", size=3) + 
      geom_line(alpha=.3, colour = "cyan", aes(y = ms.withinss.df$e)) +
      ylab(label="Micro-shift level") + 
      xlab("Month") +
      ggtitle("Micro-shift level by cluster")

