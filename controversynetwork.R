library(igraph)

edgelist <- "edgelist.csv"

## import edge-list data and convert to adjacency-matrix
data <- read.csv(edgelist, header = TRUE) # choose an edgelist in .csv file format
el <- graph.data.frame(data, directed = TRUE) #create 
el <- cbind(1:2000, 1:2000 ) #edgelist (a=origin, b=destination)
head(el)
em <- as.matrix(el)   
em[c] <- 1
head(em)

## build a graph
# build a graph from the above matrix
g <- graph.adjacency(am, weighted=TRUE, mode = “directed”)
# remove loops
g <- simplify(g)
# set labels and degrees of vertices
V(g)$label <- V(g)$name
V(g)$degree <- degree(g)

## plot it
#set seed to make the layout reproducible
set.seed(3952)
layout1 <- layout.fruchterman.reingold(g)
plot(g, layout=layout1)

# alternative layout: > plot(g, layout=layout.kamada.kawai)
# interactive plot: > tkplot(g, layout=layout.kamada.kawai)

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



