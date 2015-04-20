## IDENTIFIES MICRO-SHIFTS
## Run LSA.R procedure first to genreate semantic space

# Generate micro-shift query vector
querytext <- "alteration change conversion deviation move transfer transformation variation bend changeover deflection displacement double fault modification passage permutation rearrangement removal shifting substitution tack transference transit translocation turn veering yaw adjustment adoption alteration conversion modification refitting remodelling reworking shift transformation variation adapt adjust amend change convert develop dial-back diversify fine-tune metamorphose modify mutate recalibrate recast reconstruct refashion reform remodel renovate reshape revamp revise shift transform transmute turn vary"
q <- query(querytext, rownames(LSAmatrix), stemming = TRUE)
print(q)
summary(q)

## extract non-zero terms from search result
qm <- as.matrix(q)
qv <- names(qm[qm > 0, ])  # add corresponding values to micro-shift vector

## add semantically assiciated terms to micro-shifts vector
msv <- ""
for (i in 1:length(qv)){
      print(qv[[i]])
      associations <- associate(LSAmatrix, qv[i], measure = "cosine", threshold = 0.3)
      associations <- associations[associations != ""]
      print(names(associations))
      msv <- c(msv, names(associations))   
}
msv <- msv[msv != ""]
summary(msv)

## create a micro-shift matrix based on micro shift vector
m <- LSAmatrix[msv, ] # subset LSAmatrix rows by the micro shift vector
msm <- as.textmatrix(m) # turn it into a textmatrix object
class(msm)  # show me it worked


# calculate mean of singular values for each cluster



