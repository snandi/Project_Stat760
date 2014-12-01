rm(list=ls(all.names=TRUE))
rm(list=objects(all.names=TRUE))
#dev.off()

########################################################################
## This script uses the mclust and clValid packages to compare the    ##
## clustering techniques                                              ##
########################################################################

########################################################################
## Run Header files                                                   ##
########################################################################
library(mclust)
library(clValid)
########################################################################
## Load Data 1                                                        ##
########################################################################
Filename.Data1 <- 'Z:/Courses/Stat760_Fall2014/Project/Data/Data1_Leuk.txt'
Data1 <- read.table(file=Filename.Data1, header=TRUE, sep='\t', quote="", 
                    comment.char="",
                    stringsAsFactors=F)

Time1 <- Sys.time()
GMM1 <- Mclust(data = Data1[,-c(1:2)])    ## If you want to cluster a subset of the data
# GMM1 <- Mclust(data = Data1[,-c(1:2)])    ## If you want to cluster the whole dataset, uncomment this line
summary(GMM1)
Sys.time() - Time1

Time1 <- Sys.time()
Comparison1 <- clValid(obj=t(Data1[,-c(1:2)]), nClust=4:10, maxitems=30000,
                       clMethods=c("hierarchical", "kmeans", "pam"),
                       validation="internal")
summary(Comparison1)
Sys.time() - Time1


