## PREPROCESSING

net.df <- as.data.frame(cluster.df)
net.df$term <- ms.vector

netclust <- as.data.frame(cluster.df$cluster)
netterm <- as.data.frame(ms.vector)
head(netclust)
head(netterm)

net <- merge(netclust,netterm,by='cluster')

head(net.df)

dim(net.df)


library(data.table)
net.dt = data.table(net.df)

net.dt <- net.dt[, lapply(net.dt, FUN=, by = list(cluster)]
head(net.dt)

# CHANGE!!! generate binary network from dynamic controversy matrices
bn <- lsa.matrix[ms.vector, ] # subset lsa.matrix rows by the controversy vector
table(bn)

binet <- as.matrix((bn > 0) + 0)
authors <- data$AUTHOR
binet <- as.data.frame(binet)
colnames(binet) <- authors
table(binet)

# genereate term-author adjacency matrix


## NETWORK
library(network)
# load in biparite dataframe with weights
net <- network(binet, matrix.type='bipartite', ignore.eval=FALSE, names.eval='pies')
as.matrix(net, attername='pies')
plot.network(net)


## IGRAPH 
library(igraph)

## import edge-list data and convert to adjacency-matrix
edgelist <- "edgelist.csv"

data <- read.csv(edgelist, header = TRUE) # choose an edgelist in .csv file format
el <- graph.data.frame(data, directed = TRUE) #create 
el <- cbind(1:2000, 1:2000 ) #edgelist 
head(el)
em <- as.matrix(el)   
em[c] <- 1
head(em)

## build a graph
g <- graph.adjacency(em, weighted = TRUE, mode = "directed") # build a graph from the above matrix
g <- simplify(g) # remove loops
# set labels and degrees of vertices
V(g)$label <- V(g)$name
V(g)$degree <- degree(g)

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
closeness(g, mode="all")

incident(g, v, mode=c("all", "out", "in", "total"))
neighbors(g, v, mode = 1)
are.connected(g, v1, v2)
get.edge(g, id)
get.edges(g, es)



