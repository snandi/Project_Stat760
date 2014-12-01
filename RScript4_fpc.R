rm(list=ls(all.names=TRUE))
rm(list=objects(all.names=TRUE))
#dev.off()

########################################################################
## This script uses the packages fpc and cluster to compare the       ##
## clustering techniques                                              ##
########################################################################

########################################################################
## Run Header files                                                   ##
########################################################################
Filename.Header <- paste('Z:/RScripts/HeaderFile_lmcg.R', sep='')
source(Filename.Header)

RScriptPath <- 'Z:/Courses/Stat760_Fall2014/Project/RScripts_Stat760/'
RDataPath <- 'Z:/Courses/Stat760_Fall2014/Project/Data/'
source(paste(RScriptPath, 'fn_Library_Project760.R', sep=''))

########################################################################
## Load Data 1                                                        ##
########################################################################
Filename.Data1 <- 'Z:/Courses/Stat760_Fall2014/Project/Data/Data1_Leuk.txt'
Data1 <- read.table(file=Filename.Data1, header=TRUE, sep='\t', quote="", 
                    comment.char="",
                    stringsAsFactors=F)

########################################################################
## Load Clusters                                                      ##
########################################################################
Filename.GMM1 <- 'Z:/Courses/Stat760_Fall2014/Project/Data/GMM1.RData'
load(Filename.GMM1)

Cluster1.GMM <- GMM1$classification
plot(GMM1, what='BIC')

clValid::connectivity(clusters = Cluster1.GMM, Data = Data1[,-c(1:2)])

Filename.Comp1 <- 'Z:/Courses/Stat760_Fall2014/Project/Data/Comparison1.RData'
load(Filename.Comp1)

Cluster1.kmeans <- ((Comparison1@clusterObjs)$kmeans)[1]

Time1 <- Sys.time()
Comparison1 <- clValid(obj=Data1[,-c(1:2)], nClust=4:6, maxitems=30000,
                       clMethods=c("hierarchical", "kmeans", "pam"),
                       validation="internal")
summary(Comparison1)
Sys.time() - Time1
