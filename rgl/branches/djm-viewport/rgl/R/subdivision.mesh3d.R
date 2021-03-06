# 
# subdivision.mesh3d
#
# an *efficient* algorithm for subdivision of mesh3d objects
# using addition operations and homogenous coordinates 
# by Daniel Adler 
#
# $Id: subdivision.mesh3d.R 750 2009-02-28 16:06:35Z murdoch $
# 

edgemap <- function( size ) {
  data<-vector( mode="numeric", length=( size*(size+1) )/2 )
  data[] <- -1
  return(data)
}

edgeindex <- function( from, to, size, row=min(from,to), col=max(from,to) )
  return( row*size - ( row*(row+1) )/2 - (size-col) )

divide.mesh3d <- function (mesh,vb=mesh$vb, ib=mesh$ib, it=mesh$it ) {
  nv    <- dim(vb)[2]
  nq <- if (is.null(ib)) 0 else dim(ib)[2]
  nt <- if (is.null(it)) 0 else dim(it)[2]
  primout <- c()
  nvmax <- nv + nq + ( nv*(nv+1) )/2
  outvb <- matrix(data=0,nrow=4,ncol=nvmax)  
  # copy old points
  outvb[,1:nv] <- vb  
  vcnt <- nv
  em    <- edgemap( nv )
  result <- structure(list(material=mesh$material, normals=mesh$normals), class="mesh3d")
  
  if (nq) {
    newnq <- nq*4

    outib <- matrix(nrow=4,ncol=newnq)
    vcnt  <- vcnt + nq
  
    for (i in 1:nq ) {
      isurf <- nv + i
      for (j in 1:4 ) {
      
        iprev <- ib[((j+2)%%4) + 1, i]
        ithis <- ib[j,i]
        inext <- ib[ (j%%4)    + 1, i]
      
        # get or alloc edge-point this->next
        mindex <- edgeindex(ithis, inext, nv)
        enext <- em[mindex]
        if (enext == -1) {
          vcnt       <- vcnt + 1
          enext      <- vcnt
          em[mindex] <- enext
        }

        # get or alloc edge-point prev->this
        mindex <- edgeindex(iprev, ithis, nv)
        eprev <- em[mindex]
        if (eprev == -1) {
          vcnt       <- vcnt + 1
          eprev      <- vcnt
          em[mindex] <- eprev
        }

        # gen grid      
        outib[, (i-1)*4+j ] <- c( ithis, enext, isurf, eprev )

        # calculate surface point
        outvb[,isurf] <- outvb[,isurf] + vb[,ithis]
      
        # calculate edge point
        outvb[,enext] <- outvb[,enext] + vb[,ithis] 
        outvb[,eprev] <- outvb[,eprev] + vb[,ithis] 

      }
    }
    primout <- "quad"
    result$ib <- outib
  }
  if (nt) {
    newnt <- nt*4
    outit <- matrix(nrow=3,ncol=newnt)
  
    for (i in 1:nt ) {
      for (j in 1:3 ) {
      
        iprev <- it[((j+1)%%3) + 1, i]
        ithis <- it[j,i]
        inext <- it[ (j%%3)    + 1, i]
        
        # get or alloc edge-point this->next
        mindex <- edgeindex(ithis, inext, nv)
        enext <- em[mindex]
        if (enext == -1) {
          vcnt       <- vcnt + 1
          enext      <- vcnt
          em[mindex] <- enext
        }

        # get or alloc edge-point prev->this
        mindex <- edgeindex(iprev, ithis, nv)
        eprev <- em[mindex]
        if (eprev == -1) {
          vcnt       <- vcnt + 1
          eprev      <- vcnt
          em[mindex] <- eprev
        }

        # gen grid      
        outit[, (i-1)*4+j ] <- c( ithis, enext, eprev )
      
        # calculate edge point
        outvb[,enext] <- outvb[,enext] + vb[,ithis] 
        outvb[,eprev] <- outvb[,eprev] + vb[,ithis] 

      }
      # Now central triangle
      
      outit[, (i-1)*4+4 ] <- c( em[edgeindex(ithis, inext, nv)],
                                em[edgeindex(inext, iprev, nv)],
                                em[edgeindex(iprev, ithis, nv)] )
    }
    primout <- c(primout, "triangle")
    result$it <- outit
  }  
  result$vb <- outvb[,1:vcnt]
  result$primitivetype <- primout
  return ( result )
}

normalize.mesh3d <- function (mesh) {
  mesh$vb[1,] <- mesh$vb[1,]/mesh$vb[4,]
  mesh$vb[2,] <- mesh$vb[2,]/mesh$vb[4,]
  mesh$vb[3,] <- mesh$vb[3,]/mesh$vb[4,]
  mesh$vb[4,] <- 1
  return (mesh)
}

deform.mesh3d <- function( mesh, vb=mesh$vb, ib=mesh$ib, it=mesh$it )
{
  nv <- dim(vb)[2]
  nq <- if (is.null(ib)) 0 else dim(ib)[2]
  nt <- if (is.null(it)) 0 else dim(it)[2]
  out <- matrix(0, nrow=4, ncol=nv )
  if (nq) {
    for ( i in 1:nq ) {
      for (j in 1:4 ) {
        iprev <- ib[((j+2)%%4) + 1, i]
        ithis <- ib[j,i]
        inext <- ib[ (j%%4)    + 1, i]
        out[ ,ithis ] <- out[ , ithis ] + vb[,iprev] + vb[,ithis] + vb[,inext]
      }
    }
    mesh$vb <- out
  }
  if (nt) {
    for ( i in 1:nt ) {
      for (j in 1:3 ) {
        iprev <- it[((j+1)%%3) + 1, i]
        ithis <- it[j,i]
        inext <- it[ (j%%3)    + 1, i]
        out[ ,ithis ] <- out[ , ithis ] + vb[,iprev] + vb[,ithis] + vb[,inext]
      }
    }
    mesh$vb <- out
  }  
  return(mesh)
}

subdivision3d.mesh3d <- function(x,depth=1,normalize=FALSE,deform=TRUE,...) {
  mesh <- x
  if (depth) {
    mesh <- divide.mesh3d(mesh)
    if (normalize)
      mesh <- normalize.mesh3d(mesh)
    if (deform)
      mesh <- deform.mesh3d(mesh)      
    mesh<-subdivision3d.mesh3d(mesh,depth-1,normalize,deform)
  }
  return(mesh)  
}

