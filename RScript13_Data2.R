rm(list=ls(all.names=TRUE))
rm(list=objects(all.names=TRUE))
#dev.off()

########################################################################
## This script uses Data2 and records the times of clusters           ##
########################################################################

########################################################################
## Run Header files                                                   ##
########################################################################
Filename.Header <- paste('~/RScripts/HeaderFile_lmcg.R', sep='')
source(Filename.Header)

RScriptPath <- '~/Courses/Stat760_Fall2014/Project/RScripts_Stat760/'
RDataPath <- '~/Courses/Stat760_Fall2014/Project/Data/'
RPlotPath <- '~/Courses/Stat760_Fall2014/Project/RScripts_Stat760/Presentation/'
source(paste(RScriptPath, 'fn_Library_Project760.R', sep=''))

########################################################################
## Load Data 2                                                        ##
########################################################################
Filename.Data2_T <- '~/Courses/Stat760_Fall2014/Project/Data/Data2_Leuk_Transposed.txt'
Data2 <- read.table(file=Filename.Data2_T, header=TRUE, sep='\t', stringsAsFactors=F)
#Data2.subset <- Data2[,1:10000]
Data2.T <- scale(x=t(Data2), center=TRUE, scale=TRUE)

########################################################################
## Cluster system times                                               ##
########################################################################
clMethods <- c("hierarchical", "kmeans", "pam", "sota")
Comparison.Patients <- clValid(obj=t(Data2), nClust=4:8, maxitems=30000, 
                               clMethods=clMethods, validation='internal')
summary(Comparison.Patients)

Comparison.Patients.Sc <- clValid(obj=Data2.T, nClust=4:8, maxitems=30000, 
                               clMethods=clMethods, validation='internal')
summary(Comparison.Patients.Sc)

GMM.Patients <- Mclust(data=t(Data2), G=4:8)
