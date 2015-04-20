##
## R source file
## This file is part of rgl
##
## $Id: plugin.R 39 2003-06-04 07:46:44Z dadler $
##

##
## quit R plugin
## 
##

rgl.quit <- function() {

  detach(package:rgl)

}


