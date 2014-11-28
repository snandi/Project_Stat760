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
Filename.Header <- paste('~/RScripts/HeaderFile_Nandi.R', sep='')
source(Filename.Header)
########################################################################
Today <- Sys.Date()

library("leukemiasEset")

data(leukemiasEset)

leukemiasEset

# ExpressionSet overview:
leukemiasEset

# Phenodata:
pData(leukemiasEset)

# Number of samples per class:
summary(leukemiasEset$LeukemiaType)

#View(leukemiasEset)

str(leukemiasEset)

Filename <- '~/Courses/Stat760_Fall2014/Project/Data/LeukemiaData.txt'
#write.table(leukemiasEset, file=Filename, sep='\t')

