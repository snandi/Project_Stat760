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
## Data 1                                                             ##
########################################################################
Filename.Data <- '~/Courses/Stat760_Fall2014/Project/Data/Data1_Leuk.txt'
Data <- read.table(file=Filename.Data, header=TRUE, sep='\t', quote="", 
                   comment.char="",
                   stringsAsFactors=F)
Cols <- colnames(Data) %w/o% c('Gene.Accession.Number', 
                               'Gene.Description')

Dist <- stats::dist(x = Data[,Cols], method = 'euclidean')
dim(Dist)

Diss <- cluster::daisy(x = Data[,Cols], stand = T)
dim(Diss)

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
SI.PC <- cluster::silhouette(x = Data$PC, dmatrix = Dist)
summary(SI.PC)

########################################################################
## Load kmeans results for Data 1                                   ##
########################################################################
## Filename.KM <- paste(RDataPath, 'KMeans_G4_Data1.kgg', sep='')
## Cluster.KM <- read.table(file=Filename.KM, header=TRUE, sep='\t', quote="", 
##                  comment.char="",
##                  stringsAsFactors=F)
## colnames(Cluster.KM) <- c('Gene.Accession.Number', 'KM')

## Data <- merge(x = Data, y = Cluster.KM, by = 'Gene.Accession.Number')
## Cols <- colnames(Data) %w/o% c('Gene.Accession.Number', 
##                                'Gene.Description', 'KM', 'PC')
## Connectivity.KM <- clValid::connectivity(clusters = Data$KM, 
##                                       Data = Data[,Cols])
## Connectivity.KM

## SI.KM <- cluster::silhouette(x = Data$KM, dmatrix = Diss)
## summary(SI.KM)

## Dunn.KM <- dunn(clusters = Data$KM, Data = Data[,Cols], method = "euclidean")

########################################################################
## Load GMM results for Data 1                                   ##
########################################################################
Filename.GMM <- '~/Courses/Stat760_Fall2014/Project/Data/GMM1.RData'
load(Filename.GMM)
str(GMM1)

Cluster.GMM <- GMM1$classification
plot(GMM1, what='BIC')

Connectivity.GMM <- clValid::connectivity(clusters = Cluster.GMM, 
                                          Data = Data[,Cols])
Connectivity.GMM

SI.GMM <- silhouette(x = Cluster.GMM, dist = Dist)
summary(SI.GMM)

Dunn.GMM <- dunn(clusters = Cluster.GMM, Data = Data[,Cols],
                 method = "euclidean")
Dunn.GMM

## NewCluster.GMM <- clValid(obj=Data[,Cols], nClust=4, maxitems=30000,
##                        clMethods="model",
##                        validation="internal")
## summary(NewCluster.GMM)

########################################################################
## Load Comparison results for Data 1                                ##
########################################################################
Filename.Comp <- '~/Courses/Stat760_Fall2014/Project/Data/Comparison1.RData'
load(Filename.Comp)

summary(Comparison1)
str(Comparison1)

NewCluster.KM <- clValid(obj=Data[,Cols], nClust=4, maxitems=30000,
                       clMethods="kmeans",
                       validation="internal")
summary(NewCluster.KM)
str(NewCluster.KM)
## Cluster.KM <- (((NewCluster.KM@clusterObjs)$kmeans)[[1]])$cluster
## SI.KM <- silhouette(x = Cluster.KM, dist=Dist)
## summary(SI.KM)

## Connectivity.KM <- clValid::connectivity(clusters = Cluster.KM, 
##                                          Data = Data[,Cols])
## Connectivity.KM

## Dunn.KM <- dunn(clusters = Cluster.KM, Data = Data[,Cols],
##                 method = "euclidean")
## Dunn.KM
Connectivity.KM <- (NewCluster.KM@measures)['Connectivity',,]
SI.KM <- (NewCluster.KM@measures)['Silhouette',,]
Dunn.KM <- (NewCluster.KM@measures)['Dunn',,]

########################################################################
## Hierarchical Clustering                                            ##
########################################################################
NewCluster.HI <- clValid(obj=Data[,Cols], nClust=4, maxitems=30000,
                         clMethods="hierarchical", method='average',
                         validation="internal")
summary(NewCluster.HI)
str(NewCluster.HI)

Connectivity.HI <- (NewCluster.HI@measures)['Connectivity',,]
SI.HI <- (NewCluster.HI@measures)['Silhouette',,]
Dunn.HI <- (NewCluster.HI@measures)['Dunn',,]

Connectivity <- c(Connectivity.PC, Connectivity.GMM, Connectivity.KM, Connectivity.HI)

Dunn <- c(Dunn.PC, Dunn.GMM, Dunn.KM, Dunn.HI)

Silhouette <- c(mean(SI.PC[,3]), mean(SI.GMM[,3]),
                SI.KM, SI.HI)

Table1 <- as.data.frame(cbind(Connectivity, Dunn, Silhouette))
rownames(Table1) <- c('pCluster', 'Gaussian Mixture', 'K-Means', 'Agglomerative Hierarchical')

round(Table1, 4)
save(Table1, file=paste(RDataPath, 'Table1.RData', sep=''))

