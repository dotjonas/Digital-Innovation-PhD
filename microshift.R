## IDENTIFIES MICRO-SHIFTS
## Run LSA.R procedure first to genreate semantic space

# Generate micro-shift query vector
querytext <- "alteration change conversion deviation move transfer transformation variation bend changeover deflection displacement double fault modification passage permutation rearrangement removal shifting substitution tack transference transit translocation turn veering yaw adjustment adoption alteration conversion modification refitting remodelling reworking shift transformation variation adapt adjust amend change convert develop dial-back diversify fine-tune metamorphose modify mutate recalibrate recast reconstruct refashion reform remodel renovate reshape revamp revise shift transform transmute turn vary"
q <- query(querytext, rownames(lsa.matrix), stemming = TRUE)
print(q)
summary(q)

## extract non-zero terms from search result
query.matrix <- as.matrix(q)
query.vector <- names(query.matrix[query.matrix > 0, ])  # add corresponding values to micro-shift vector

## calculate semantically associated terms to micro-shifts vector using cosine similarity
ms.vector <- ""
for (i in 1:length(query.vector)){
      print(query.vector[[i]])
      associations <- associate(lsa.matrix, query.vector[i], measure = "cosine", threshold = 0.7)
      associations <- associations[associations != ""]
      print(names(associations))
      ms.vector <- c(ms.vector, names(associations))   
}
ms.vector <- ms.vector[ms.vector != ""]
summary(ms.vector)


## create a reduced micro-shift matrix subset by micro shift vector
ms.space <- lsa.matrix[ms.vector, ] # subset lsa.matrix rows by the micro shift vector
ms.matrix <- as.matrix(ms.space) # turn it into a textmatrix object
class(ms.matrix)  # show me it worked
dim(ms.matrix)





