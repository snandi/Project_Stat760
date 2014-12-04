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
Filename.Data <- 'Z:/Courses/Stat760_Fall2014/Project/Data/Data1_Leuk.txt'
Data <- read.table(file=Filename.Data, header=TRUE, sep='\t', quote="", 
                   comment.char="",
                   stringsAsFactors=F)
Cols <- colnames(Data) %w/o% c('Gene.Accession.Number', 
                               'Gene.Description')

Dist <- stats::dist(x = Data[,Cols], method = 'euclidean')
dim(Dist)

Diss <- cluster::daisy(x = Data[,Cols], stand = T)
########################################################################
## Load pcluster results for Data 1                                   ##
########################################################################
Filename.PC <- paste(RDataPath, 'flatPclusters1', sep='')
Cluster.PC <- read.table(file=Filename.PC, header=FALSE, sep='\t', quote="", 
                         comment.char="",
                         stringsAsFactors=F)
colnames(Cluster.PC) <- c('Gene.Accession.Number', 'PC')
Data <- merge(x = Data, y = Cluster.PC, by = 'Gene.Accession.Number')
Cols <- colnames(Data) %w/o% c('Gene.Accession.Number', 
                               'Gene.Description', 'PC')

Connectivity.PC <- clValid::connectivity(clusters = Data$PC, 
                                         Data = Data[,Cols])
Connectivity.PC
Dunn.PC <- dunn(clusters = Data$PC, Data = Data[,Cols], method = "euclidean")
Dunn.PC
SI.PC <- silhouette(x = Data$PC, dmatrix = Diss)
summary(SI.PC)

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

SI.KM <- cluster::silhouette(x = Data$KM, dmatrix = Diss)
summary(SI.KM)

Dunn.KM <- dunn(clusters = Data$KM, Data = Data[,Cols], method = "euclidean")

########################################################################
## Load GMM results for Data 1                                   ##
########################################################################
Filename.GMM <- 'Z:/Courses/Stat760_Fall2014/Project/Data/GMM1.RData'
load(Filename.GMM)

Cluster.GMM <- GMM1$classification
plot(GMM1, what='BIC')
Connectivity.GMM <- clValid::connectivity(clusters = Cluster.GMM, 
                                          Data = Data[,Cols])
SI.GMM <- silhouette(x = Cluster.GMM, dist = Dist)
summary(SI.GMM)

Dunn.GMM <- dunn(distance = NULL, clusters, Data = NULL, method = "euclidean")
########################################################################
## Load Comparison results for Data 1                                ##
########################################################################
Filename.Comp <- 'Z:/Courses/Stat760_Fall2014/Project/Data/Comparison1.RData'
load(Filename.Comp)

summary(Comparison1)
str(Comparison1)

Data.KM <- clValid(obj=Data[,Cols], nClust=4, maxitems=30000,
                       clMethods="kmeans",
                       validation="internal")
summary(Data.KM)
str(Data.KM)
Cluster.KM <- (((Data.KM@clusterObjs)$kmeans)[[1]])$cluster
SI.KM <- silhouette(x = Cluster.KM, dist=Dist)
summary(SI.KM)

