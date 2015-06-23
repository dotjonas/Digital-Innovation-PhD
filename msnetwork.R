## MEASURES EFFECT OF MICRO-SHIFTS ON ACTOR NETWORK
## Run microshift.R procedure first to identify micro shifts
library(igraph)
dynet <- dyn.df
dynet$term <- dyn.df[,1844]
dynet <- dynet[,-1844]
cl <- cluster.df$cluster
cl <- cl[-c(37, 69, 70, 71, 72)] #delete noisy rows
dynet$cluster <- cl


# generate matrices for each month
dec12.net <- dynet[,c(1724:1843,1845)]
jan13.net <- dynet[,c(1597:1723,1845)]
feb13.net <- dynet[,c(1503:1596,1845)]
mar13.net <- dynet[,c(1390:1502,1845)]
apr13.net <- dynet[,c(1130:1389,1845)]
may13.net <- dynet[,c(1105:1129,1845)]
jun13.net <- dynet[,c(955:1104,1845)]
jul13.net <- dynet[,c(902:954,1845)]
aug13.net <- dynet[,c(851:901,1845)]
sep13.net <- dynet[,c(743:850,1845)]
oct13.net <- dynet[,c(633:742,1845)]
nov13.net <- dynet[,c(568:632,1845)]
dec13.net <- dynet[,c(503:567,1845)]
jan14.net <- dynet[,c(479:502,1845)]
feb14.net <- dynet[,c(366:478,1845)]
mar14.net <- dynet[,c(122:365,1845)]
apr14.net <- dynet[,c(68:121,1845)]
may14.net <- dynet[,c(1:67,1845)]


# generate vector of data frames
months.net <- list(dec12.net,jan13.net,feb13.net,mar13.net,apr13.net,may13.net,jun13.net,jul13.net,aug13.net,sep13.net,oct13.net,nov13.net,dec13.net,jan14.net,feb14.net,mar14.net,apr14.net,may14.net)

phase_1 <- cbind(dec12.net,jan13.net,feb13.net,mar13.net,apr13.net)
phase_2 <- cbind(may13.net,jun13.net,jul13.net,aug13.net,sep13.net,oct13.net)
phase_3 <- cbind(nov13.net,dec13.net,jan14.net,feb14.net,mar14.net,apr14.net,may14.net)

phases <- list(phase_1,phase_2,phase_3)

# measure density for each micro-shift by phase
ddf <- data.frame()
net.bin <- data.frame()
den.v <- c()
for (p in phases){
      net <- p
      net$cluster <- NULL # remove cluster column
      net.num <- as.matrix(sapply(net, as.numeric))
      #net.bin <- as.numeric(unlist(net.bin))
      net.bin <- as.data.frame((net.num > 0) + 0) # turn into binary matrix
      net.bin$cluster <- p$cluster # reappend cluster column
      print(dim(net.bin))
      #ddf <- data.frame(net.bin$cluster)
      for (i in 1:5){
            d <- net.bin[net.bin$cluster == as.character(i),]
            d$cluster
            d$cluster <- NULL # remove cluster column
            d <- as.matrix(d)
            d <- d %*% t(d) # transpose to ms-ms matrix
            g <- graph.data.frame(d, directed = FALSE) #create network graph
            #g <- simplify(g) # remove loops
            den <- graph.density(g, loops=FALSE) # calculate network density
            den.v <- c(den.v,den)
            print(c('Density: ',i,den))
            ddf <- data.frame(den)
            rbind(ddf, den.v)
      }
      #cbind(phase.density, den.v) 
}
den.v
ddf






# Reduce number of columns to the appropriate 
library("reshape2")
df.m<-melt(df,id.vars=c("Year","Subdiv"))

#2) Then add additional columns based on the variable column that holds your previous df's column names

library("stringr")
df.m$Fish<-str_extract(df.m$variable,"[A-Z]")
df.m$Age<-str_extract(df.m$variable,"[0-9]")



# initialise data frame
net.df <- data.frame()

for (mn in months.net){
      # binary adjacency matrix 
      binary.adj <- as.matrix((may14.net > 0) + 0)
      # add cluster id column
      
      # merge rows by cluster id
      
      ndf <- data.frame(net.matrix$rownames(net.matrix))
      g <- graph.data.frame(net.matrix, directed = FALSE) #create network graph
      g <- simplify(g) # remove loops
      g
      d <- graph.density(g, loops=FALSE) # calculate network density (No of edges / possible edges)
      graph.density(g)
      net.df$density <- rbind(net.df, d)
}
net.df

net.matrix <- n %*% t(n) # transpose to ms-ms matrix

# create binary term-doc matrix
binet <- as.matrix((ms.matrix > 0) + 0)
table(binet)
binet[1:10,1:10]

# generate micro-shift adjacency matrix
net.matrix <- binet %*% t(binet)
net.matrix[1:10,1:10]

#Visualize the micro-shift network
library(network)
net <- network(net.matrix)
plot(net)


#######################################



# import edge list
data <- read.csv("edgelist.csv")
dim(data)
head(data)


g <- graph.data.frame(data, directed = TRUE) #create 
# el <- cbind(1:2000, 1:2000 ) #edgelist 
head(el)
em <- as.matrix(el)   
em[c] <- 1
head(em)

## plot it
set.seed(3952) #set seed to make the layout reproducible
layout1 <- layout.fruchterman.reingold(g)
plot(g, layout = layout1)
# alternative layout: > 
#plot(g, layout=layout.kamada.kawai)
tkplot(g, layout=layout.kamada.kawai) #interactive plot


## tidy up the graph layout to make it look better
V(g)$label.cex <- 2.2 * V(g)$degree / max(V(g)$degree)+ .2
V(g)$label.color <- rgb(0, 0, .2, .8)
V(g)$frame.color <- NA
egam <- (log(E(g)$weight)+.4) / max(log(E(g)$weight)+.4)
E(g)$color <- rgb(.5, .5, 0, egam)
E(g)$width <- egam
# plot the graph in layout1
plot(g, layout=layout1)


## run analytics to get basic stats
vcount(g)
ecount(g)
is.directed(g)
c <- data.frame(closeness(g, mode="all"))
c





data$doc.id <- colnames(ms.matrix[,1:1842])
doc.id <- data$doc.id
doc.id <- data$doc.id = sub("*.txt","",data$doc.id) # simplify column names
doc.id <- as.numeric(sort(doc.id, decreasing=FALSE))
doc.id
data$doc.id <- doc.id



cluster <- cluster.df$cluster
term <- rownames(ms.matrix) 
write.csv(term, "../ms_terms.csv")
      
net.df <- as.data.frame(cluster)
net.df$term <- term
net.df$author <- data$AUTHOR
head(net.df)



# add each month to a list of matrices
