.Par3d <- c("FOV", "ignoreExtent",
	   "mouseMode", 
	   "modelMatrix", "projMatrix", "skipRedraw", "userMatrix", 
	   "scale", "viewport", "zoom", "bbox"
	   )
	   
.Par3d.readonly <- c( 
	   "modelMatrix", "projMatrix",
	   "viewport", "bbox"
	   )

par3d <- function (..., no.readonly = FALSE)
{
    single <- FALSE
    args <- list(...)
    if (!length(args))
	args <- as.list(if (no.readonly)
                        .Par3d[-match(.Par3d.readonly, .Par3d)]
        else .Par3d)
    else {
	if (is.null(names(args)) && all(unlist(lapply(args, is.character))))
	    args <- as.list(unlist(args))
	if (length(args) == 1) {
	    if (is.list(args[[1]]) | is.null(args[[1]]))
		args <- args[[1]]
	    else
		if(is.null(names(args)))
		    single <- TRUE
	}
    }
     if ("userMatrix" %in% names(args)) {
        m <- args$userMatrix
        svd <- svd(m[1:3, 1:3])
        m[1:3, 1:3] <- svd$u %*% t(svd$v)
        theta <- -asin(m[1,3])*180/pi
	    m <-  m %*% rotationMatrix(theta*pi/180, 0,1,0)
	    svd <- svd(m[1:3, 1:3])
	    m[1:3,1:3] <- svd$u %*% t(svd$v)	
	    phi <- -asin(m[2,3])*180/pi
	    args$.position <- c(theta, phi)
    }   
    value <-
        if (single) .External(rgl_par3d, args)[[1]] 
        else .External(rgl_par3d, args)

    if(!is.null(names(args))) invisible(value) else value
}

