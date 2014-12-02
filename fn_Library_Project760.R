## Function library for Clustering project

######################### Convert NAs to Zero ##########################
na.is.zero <- function(X)
  {
      X1 <- X
        X1[is.na(X)] <- 0.0
        return(X1)
    }
########################################################################

########################################################################
"%notin%" <- function(x, y){
    if(x %in% y){
          return(FALSE)
        } else{
              return(TRUE)
            }
  }
########################################################################

########################################################################
"%w/o%" <- function(x, y){
    return(x[!x %in% y])
  }
########################################################################

########################################################################
Mode <- function(x) {
    ux <- unique(x)
      ux[which.max(tabulate(match(x, ux)))]
  }
########################################################################

####################### Extract Name of an object ######################
objectName <- function(object) {
  Name <-deparse(substitute(object))
  return(Name)
} 
########################################################################

########################################################################
## Run GMM using mclust and save the cluster object for further analy ##
## sis.                                                               ##
########################################################################
fn_runGMM <- function(Data, Name='ALL', DataPath=RDataPath){
  GMM <- Mclust(data = Data)
  Name1 <- paste('GMM', Name, sep='_')
  assign(x = Name1, value = GMM)
  Filename.GMM <- paste(DataPath, Name1, '.RData', sep='')
  save(list = Name1, file=Filename.GMM)
}
########################################################################
