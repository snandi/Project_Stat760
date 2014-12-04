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
Filename.Header <- paste('~/RScripts/HeaderFile_lmcg.R', sep='')
source(Filename.Header)

RScriptPath <- '~/Courses/Stat760_Fall2014/Project/RScripts_Stat760/'
RDataPath <- '~/Courses/Stat760_Fall2014/Project/Data/'
source(paste(RScriptPath, 'fn_Library_Project760.R', sep=''))

########################################################################
## Data 2                                                             ##
########################################################################
Filename.Data <- '~/Courses/Stat760_Fall2014/Project/Data/Data2_Leuk_Transposed.txt'
Data <- read.table(file=Filename.Data, header=TRUE, sep='\t', quote="", 
                   comment.char="",
                   stringsAsFactors=F)

########################################################################
## Load pcluster results for Data 1                                   ##
########################################################################
Filename.PC <- paste(RDataPath, 'flatPclusters2', sep='')
Cluster.PC <- read.table(file=Filename.PC, header=FALSE, sep='\t', quote="", 
                         comment.char="",
                         stringsAsFactors=F)
colnames(Cluster.PC) <- c('Gene.Accession.Number', 'PC')
Data <- merge(x = Data, y = Cluster.PC, by = 'Gene.Accession.Number')
Cols <- colnames(Data) %w/o% c('Gene.Accession.Number', 
                               'Gene.Description', 'PC')

Connectivity.PC <- clValid::connectivity(clusters = Cluster.PC$V2, 
                                         Data = Data)
Connectivity.PC

########################################################################
## Load kmeans results for Data 1                                   ##
########################################################################
Filename.KM <- paste(RDataPath, 'KMeans_G4_Data1.kgg', sep='')
Cluster.KM <- read.table(file=Filename.KM, header=TRUE, sep='\t', quote="", 
                         comment.char="",
                         stringsAsFactors=F)
colnames(Cluster.KM) <- c('Gene.Accession.Number', 'KM')

Data <- merge(x = Data, y = Cluster.KM, by = 'Gene.Accession.Number')
Cols <- colnames(Data) %w/o% c('Gene.Accession.Number', 
                               'Gene.Description', 'KM', 'PC')
Connectivity.KM <- clValid::connectivity(clusters = Data$KM, 
                                         Data = Data[,Cols])
Connectivity.KM

Dist <- stats::dist(x = Data[,Cols], method = 'euclidean')

SI.KM <- silhouette(x = Cluster.KM$KM, dist = Dist)
summary(SI.KM)

Dunn.KM <- dunn(clusters = Data$KM, Data = Data[,Cols], method = "euclidean")

########################################################################
## Load GMM results for Data 1                                   ##
########################################################################
Filename.GMM <- '~/Courses/Stat760_Fall2014/Project/Data/GMM2.RData'
load(Filename.GMM)

Cluster.GMM <- GMM2$classification
plot(GMM2, what='BIC')
Connectivity.GMM <- clValid::connectivity(clusters = Cluster.GMM, 
                                          Data = Data)
SI.GMM <- silhouette(x = Cluster.GMM, dist = Dist)
summary(SI.GMM)

Dunn.GMM <- dunn(distance = NULL, clusters, Data = NULL, method = "euclidean")
########################################################################
## Load Comparison results for Data 1                                ##
########################################################################
Filename.Comp <- '~/Courses/Stat760_Fall2014/Project/Data/Comparison1.RData'
load(Filename.Comp)

summary(Comparison1)
