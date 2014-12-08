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

fn_runclValid <- function(Data, Name='ALL', DataPath=RDataPath, Validation, NumClusters, clMethods){
  Comparison <- clValid(obj=Data, nClust=NumClusters, maxitems=30000,
                        clMethods=clMethods,
                        validation=Validation)
  Name1 <- paste('Comparison', Name, sep='_')
  assign(x = Name1, value = Comparison)
  Filename <- paste(DataPath, Name1, '.RData', sep='')
  save(list = Name1, file=Filename)
  return(Comparison)
}

fn_returnIndexData <- function(CompData=CompALL, NumClusters, Cluster_Type){
  Dunn <- c(measures(CompData, 'Dunn')[,,'hierarchical'], 
            measures(CompData, 'Dunn')[,,'kmeans'], 
            measures(CompData, 'Dunn')[,,'pam'], 
            measures(CompData, 'Dunn')[,,'sota'])
  Connectivity <- c(measures(CompData, 'Connectivity')[,,'hierarchical'], 
                    measures(CompData, 'Connectivity')[,,'kmeans'], 
                    measures(CompData, 'Connectivity')[,,'pam'], 
                    measures(CompData, 'Connectivity')[,,'sota'])
  Silhouette <- c(measures(CompData, 'Silhouette')[,,'hierarchical'], 
                  measures(CompData, 'Silhouette')[,,'kmeans'], 
                  measures(CompData, 'Silhouette')[,,'pam'], 
                  measures(CompData, 'Silhouette')[,,'sota'])
  Cluster_Num <- as.numeric(names(Dunn))

  Cluster_Type <- c(rep(x = 'hierarchical', times = length(NumClusters)),
                    rep(x = 'kmeans', times = length(NumClusters)), 
                    rep(x = 'pam', times = length(NumClusters)), 
                    rep(x = 'sota', times = length(NumClusters)))
  
  Measures <- as.data.frame(cbind(Cluster_Num, Dunn=as.vector(Dunn), 
                                  Connectivity=as.vector(Connectivity), 
                                  Silhouette=as.vector(Silhouette)))
  
  Measures <- within(data=Measures, {
    Cluster_Num <- as.numeric(Cluster_Num)
    Dunn <- as.numeric(Dunn)
    Connectivity <- as.numeric(Connectivity)
    Silhouette <- as.numeric(Silhouette)
  })
  
  Data <- reshape2::melt(data = Measures, id.vars = 'Cluster_Num')
  
  Data$Cluster_Type <- as.factor(rep(Cluster_Type, length(NumClusters)))
  
  Data <- plyr::rename(Data, c("variable"="Index", "value"="Index_Value"))
  return(Data)
}


fn_plotComparisons <- function(Data, Cluster_Type){
  Plot <- qplot(x=Cluster_Num, y=Index_Value, data=Data, color=Cluster_Type) + 
    geom_line(size=1) + geom_point(size=4) + 
    facet_wrap(~Index, ncol=1, scales="free") +
    xlab(label = 'Cluster Size') + ylab('') + ggtitle('ALL: Acute Lymphoblastic Leukemia') +
    theme(panel.background = element_rect(fill = 'black'), 
          plot.background = element_rect(color='black', fill = "gray10"), 
          plot.title=element_text(face="bold", size=15, colour="white"),
          axis.title.x = element_text(colour = "white"), axis.title.y = element_text(colour = "white"), 
          panel.grid.major = element_line(colour="gray20", size=0.35), 
          panel.grid.minor = element_line(colour="gray10", size=0.25), 
          legend.background = element_rect(fill = 'gray10'), 
          legend.text = element_text(colour = "white", size=14),
          legend.title = element_text(colour = "white", size=14), 
          legend.position = 'bottom', 
          legend.direction = 'horizontal'
    )
  return(Plot) 
}
