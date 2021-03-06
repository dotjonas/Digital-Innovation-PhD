##
## R source file
## This file is part of rgl
##
## $Id: internal.R 555 2007-02-19 02:24:00Z dmurdoch $
##

##
## ===[ SECTION: internal ]===================================================
##

#
# rgl.range
#
# ensure value x is between low and high
#

rgl.range <- function ( x, low, high )
{
  if (length(x) > 1)
    stop( deparse(substitute(x)), " must be a single numeric")
  if ( ( x < low ) || ( x > high ) )
    stop( deparse(substitute(x)), " must be a numeric in the range [ ",low, ":", high , "]")
}


#
# rgl.clamp
#
# clamp value if lower than low or higher than high
#

rgl.clamp <- function(value, low, high)
{
  if (value < low) {
    warning( paste("value clamped to ",low) ); 
    result <- low
  }
  else if (value > high) {
    warning( paste("value clamped to ",high) );
    result <- high
  }
  else {
    result <- value
  }

  return (result);
}

##
## types verification
##


#
# single field bool
#

rgl.bool <- function ( x )
{
  if (length(x) > 1)
    stop( deparse(substitute(x)), " must be a single color character string")
}


#
# single field numeric
#

rgl.numeric <- function ( x )
{
  if (length(x) > 1)
    stop( deparse(substitute(x)), " must be a single numeric value")
}


#
# vertex data object
#

rgl.vertex <- function (x,y=NULL,z=NULL)
{
  xyz <- xyz.coords(x,y,z,recycle=TRUE)
  return ( matrix( rbind(xyz$x,xyz$y,xyz$z), nrow=3, dimnames=list( c("x","y","z"), NULL ) ) )
}

#
# texture coordinate data object
#

rgl.texcoords <- function(s,t=NULL) 
{
  xy <- xy.coords(s, t, recycle=TRUE)
  return( matrix( rbind(xy$x, xy$y), nrow=2, dimnames=list( c("s", "t"), NULL ) ) )
}

#
# obtain number of vertices
#

rgl.nvertex <- function (vertex)
{  
  return ( ncol(vertex) )
}


#
# rgl.color - single field color
#

rgl.color <- function ( color )
{
  if (length(color) > 1)
    stop( deparse(substitute(color)), " must be a single color character string")
  else
    return (col2rgb(color))
}


#
# rgl.mcolor - multiple field colors
#

rgl.mcolor <- function ( colors )
{
  return ( col2rgb(colors) )
}


#
# if vattr > 1, recycle data
#

rgl.attr <- function (vattr, nvertex) 
{
  nvattr <- length(vattr)

  if ((nvattr > 1) && (nvattr != nvertex))
    vattr  <- rep(vattr,length.out=nvertex)
  
  return(vattr)
}
