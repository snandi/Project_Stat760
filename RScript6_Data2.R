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

RScriptPath <- 'Z:/Courses/Stat760_Fall2014/Project/RScripts_Stat760/'
RDataPath <- 'Z:/Courses/Stat760_Fall2014/Project/Data/'
source(paste(RScriptPath, 'fn_Library_Project760.R', sep=''))

########################################################################
## Data 2                                                             ##
########################################################################
Filename.Data2_T <- 'Z:/Courses/Stat760_Fall2014/Project/Data/Data2_Leuk_Transposed.txt'
Data2 <- read.table(file=Filename.Data2_T, header=TRUE, sep='\t', stringsAsFactors=F)
#Data2.subset <- Data2[,1:10000]

Time1 <- Sys.time()
GMM2 <- Mclust(data = Data2[1:1000,])
summary(GMM2)
Sys.time() - Time1

Modelname <- summary(GMM2)[['modelName']]
NumClusters <- summary(GMM2)[['G']]
# Mclust VVV (ellipsoidal, varying volume, shape, and orientation) model with 2 components:
GMM_Output <- paste('Mclust recommends', Modelname, '(', mclustModelNames('VVV')[['type']], ')', 'model with', 
                    NumClusters, 'components')  
print(GMM_Output)


#Filename.GMM2 <- '~/Courses/Stat760_Fall2014/Project/Data/GMM2.RData'
#save(GMM2, file=Filename.GMM2)

Time1 <- Sys.time()
Comparison2 <- clValid(obj=t(Data2[1:1000,]), nClust=4:10, maxitems=30000,
                       clMethods=c("hierarchical", "kmeans", "pam"),
                       validation="internal")
summary(Comparison2)
Sys.time() - Time1

Measures <- Comparison2@measures
str(Measures)
round(Measures[,,'hierarchical'], 4)
round(Measures[,,'kmeans'], 4)
round(Measures[,,'pam'], 4)
xtable(round(Measures[,,'hierarchical'], 4), digits = 4)

# Filename.Comp2 <- '~/Courses/Stat760_Fall2014/Project/Data/Comparison2.RData'
# save(Comparison2, file=Filename.Comp2)


