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
## Data 1                                                             ##
########################################################################
Filename.Data1 <- 'Z:/Courses/Stat760_Fall2014/Project/Data/Data1_Leuk.txt'
Data1 <- read.table(file=Filename.Data1, header=TRUE, sep='\t', quote="", 
                    comment.char="",
                    stringsAsFactors=F)
#Data2.subset <- Data2[,1:10000]

Time1 <- Sys.time()
GMM1 <- Mclust(data = Data1[,-c(1:2)])
summary(GMM1)
Sys.time() - Time1

Modelname <- summary(GMM1)[['modelName']]
NumClusters <- summary(GMM1)[['G']]
GMM_Output <- paste('Mclust recommends', Modelname, '(', mclustModelNames('VVV')[['type']], ')', 'model with', 
                    NumClusters, 'components')  
print(GMM_Output)

Filename.GMM1 <- 'Z:/Courses/Stat760_Fall2014/Project/Data/GMM1.RData'
save(GMM1, file=Filename.GMM1)

Time1 <- Sys.time()
Comparison1 <- clValid(obj=t(Data1[,-c(1:2)]), nClust=4:10, maxitems=30000,
                       clMethods=c("hierarchical", "kmeans", "pam"),
                       validation="internal")
summary(Comparison1)
Sys.time() - Time1

Measures <- Comparison1@measures
str(Measures)
round(Measures[,,'hierarchical'], 4)
round(Measures[,,'kmeans'], 4)
round(Measures[,,'pam'], 4)
xtable(round(Measures[,,'hierarchical'], 4), digits = 4)

Filename.Comp1 <- 'Z:/Courses/Stat760_Fall2014/Project/Data/Comparison1.RData'
save(Comparison1, file=Filename.Comp1)

