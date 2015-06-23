## QAP ANALYSIS


# generate adjacency matrices
el <- ***
mat<-matrix(0, 5, 5) # dims of el
for(i in 1:NROW(el)) mat[ el[i,1], el[i,2] ] <- el[i,3]  # SEE UPDATE
mat