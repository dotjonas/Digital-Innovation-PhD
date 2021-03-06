\name{rgl.snapshot}
\alias{rgl.snapshot}
\title{export screenshot}
\description{
  Saves the screenshot as png file.
}
\usage{
rgl.snapshot( filename, fmt="png" )

rgl.snapshot(filename)
}
\arguments{
  \item{filename}{full path to filename}
  \item{fmt}{image export format, currently supported \"png\"}
}
\details{
Animations can be created using a loop to modify the scene and save 
a screenshot to a file. (See example below)
}
\examples{

\dontrun{

#
# create animation
#

for (i in 1:45) {
  rgl.viewpoint(i,20)
  print( paste("pic",formatC(i,digits=1,flag="0"),".png",sep="") )
  rgl.snapshot(filename)
}

}

}
\seealso{
  \code{\link{rgl.viewpoint}}
}
\keyword{dynamic}
