rm(list=ls(all.names=TRUE))
rm(list=objects(all.names=TRUE))
#dev.off()

########################################################################
## This script explores the pcluster algorithm and dataset described  ##
## in Friedman's working paper                                        ##
########################################################################

########################################################################
## Run Header files                                                   ##
########################################################################
Filename.Header <- paste('~/RScripts/HeaderFile_lmcg.R', sep='')
source(Filename.Header)
########################################################################
Today <- Sys.Date()

library(clusterSim)
library(mclust)

data(data_ratio)
kmeans(data_ratio,data_ratio[initial.Centers(data_ratio, 10),])

