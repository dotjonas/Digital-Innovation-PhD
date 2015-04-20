library(Matrix)
library(arules)
library(arulesSequences)

# read a .txt file
x <- read_baskets(con = system.file("misc", "zaki.txt", package = "arulesSequences"), info = c("sequenceID","eventID","SIZE"))
as(x, "data.frame")

# execute the CSPADE algorithm
s1 <- cspade(x, parameter = list(support = 0.4), control = list(verbose = TRUE))

# view output
#cspade> summary(s1)
summary(s1)

# print as data.frame
#cspade> as(s1, "data.frame")
as.data.frame(s1)