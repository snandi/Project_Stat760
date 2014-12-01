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
## Load Data 2                                                        ##
########################################################################
Filename.Data2_T <- 'Z:/Courses/Stat760_Fall2014/Project/Data/Data2_Leuk_Transposed.txt'
Data2 <- read.table(file=Filename.Data2_T, header=TRUE, sep='\t', stringsAsFactors=F)

Time1 <- Sys.time()
GMM2 <- Mclust(data = Data2[1:1000,]) ## If you want to cluster a subset of the data
# GMM2 <- Mclust(data = Data2) ## If you want to cluster all of Data2, then uncomment this line
summary(GMM2)
Sys.time() - Time1

Time1 <- Sys.time()
Comparison2 <- clValid(obj=Data2, nClust=4:10, maxitems=30000,
                       clMethods=c("hierarchical", "kmeans", "pam"),
                       validation="internal")
summary(Comparison2)
Sys.time() - Time1



