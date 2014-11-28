rm(list=ls(all.names=TRUE))
rm(list=objects(all.names=TRUE))
#dev.off()

########################################################################
## This script uses the clValid package to compare the clustering     ##
## techniques
########################################################################

########################################################################
## Run Header files                                                   ##
########################################################################
Filename.Header <- paste('Z:/RScripts/HeaderFile_lmcg.R', sep='')
source(Filename.Header)


########################################################################
## Data 1                                                          ##
########################################################################
Filename.Data1 <- paste('~/Courses//Stat760_Fall2014/Project/Data/Data1_Leuk.txt')
Data1 <- read.table(file=Filename.Data1, header=TRUE, sep='\t', quote="", 
                    comment.char="",
                    stringsAsFactors=F)

Time1 <- Sys.time()
GMM1 <- Mclust(data = Data1[,-c(1:2)])
summary(GMM1)
Sys.time() - Time1
Filename.GMM1 <- '~/Courses/Stat760_Fall2014/Project/Data/GMM1.RData'
save(GMM1, file=Filename.GMM1)

Time1 <- Sys.time()
Comparison1 <- clValid(obj=Data1[,-c(1:2)], nClust=4:10, maxitems=30000,
                      clMethods=c("hierarchical","kmeans", "pam"),
                      #clMethods=c("hierarchical","kmeans", "pam", "model"),
                      validation="internal")
summary(Comparison1)
Sys.time() - Time1
Filename.Comp1 <- '~/Courses/Stat760_Fall2014/Project/Data/Comparison1.RData'
save(Comparison1, file=Filename.Comp1)
rm(Data1, GMM1, Comparison1)

########################################################################
## Data 2                                                        ##
########################################################################
Filename.Data2 <- 'Z:/Courses/Stat760_Fall2014/Project/Data/Data2_Leuk.txt'
Data2 <- read.table(file=Filename.Data2, header=TRUE, sep='\t', stringsAsFactors=F)
#Data2.subset <- Data2[,1:10000]

Time1 <- Sys.time()
GMM2 <- Mclust(data = t(Data2[,1:20172]))
summary(GMM2)
Sys.time() - Time1
Filename.GMM2 <- '~/Courses/Stat760_Fall2014/Project/Data/GMM2.RData'
save(GMM2, file=Filename.GMM2)

Time1 <- Sys.time()
Comparison2 <- clValid(obj=Data2[,1:20172], nClust=4:10, maxitems=30000,
                      clMethods=c("hierarchical", "kmeans", "pam"),
                      validation="internal")
summary(Comparison2)
Sys.time() - Time1
Filename.Comp2 <- '~/Courses/Stat760_Fall2014/Project/Data/Comparison2.RData'
save(Comparison2, file=Filename.Comp2)
rm(Data2, GMM2, Comparison2)
