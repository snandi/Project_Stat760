rm(list=ls(all.names=TRUE))
rm(list=objects(all.names=TRUE))
#dev.off()

########################################################################
## This script explores the hierarchical clustering algorithms from   ##
## the package mclust                                                 ##
########################################################################

########################################################################
## Run Header files                                                   ##
########################################################################
Filename.Header <- paste('~/RScripts/HeaderFile_Nandi.R', sep='')
source(Filename.Header)
########################################################################
Today <- Sys.Date()
data(leukemiasEset)
data(faithful)
faithful_Mclust <- Mclust(data = faithful)
summary(faithful_Mclust)

data(precip)

data(iris)
iris_Mclust <- Mclust(data = iris[,1:4])
summary(iris_Mclust)

data(Baudry_etal_2010_JCGS_examples)
ex4_1_Mcluse <- Mclust(data = ex4.1)
#plot(ex4_1_Mcluse)

Filename <- '~/Courses/Stat760_Fall2014/Project/Data/LeukemiaData.txt'
LeukemiaData <- read.table(file=Filename, header=TRUE, sep='\t', stringsAsFactors=F)
LeukemiaData.subset <- LeukemiaData[,1:2000]
Time1 <- Sys.time()
Leuk_GMM_Cluster <- Mclust(data = t(LeukemiaData.subset))
Sys.time() - Time1
summary(Leuk_GMM_Cluster)
#plot(Leuk_GMM_Cluster, what = c("BIC", "classification"))

Filename <- '~/Courses/Stat760_Fall2014/Project/Data/Leuk_GMM_Cluster.RData'
#save(Leuk_GMM_Cluster, file=Filename)
load(file=Filename)
summary(Leuk_GMM_Cluster)
plot(Leuk_GMM_Cluster,what="BIC")
Leuk_GMM_Cluster.Genes <- Leuk_GMM_Cluster$classification

########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
d.banknot <- read.table("http://stat.ethz.ch/Teaching/Datasets/WBL/banknot.dat")
head(d.banknot)
#a) Make a clustering with Mclust() from the package mclust using
#   the maximum likelihood method.

ml.banknot<-Mclust(d.banknot[,-1])
summary(ml.banknot)
#What number of clusters and what model do you propose?

plot(ml.banknot,d.banknot[,-1],what="BIC")
plot(ml.banknot, which.plots=2)

#b) Make a table with the misclassification of the model based method with respect to CODE. Keep in mind: CODE=0 are the genuine banknotes an CODE=1 the forged ones.

ml.cluster<-Mclust(d.banknot[,-1],modelNames="EEE",G=4)$classification
table(ml.cluster)
table(ml.cluster,d.banknot[,1])

#Make a pairs plot of the variables.

pairs(d.banknot[,-1],col=d.banknot[,1]+1,pch=ml.cluster)

# c) Carry out the PAM-algorithm for the same number of clusters as
#    above and the euclidean metric.

pam.banknot <- pam(d.banknot[,-1],k=4,metric="euclidean")
pam.cluster <- pam(d.banknot[,-1],k=4,metric="euclidean")$clustering
plot(pam.banknot, which.plots=2)

#Make a table with the "misclassification" of the model based
#method compared to the PAM algorithm.

table(pam.cluster,ml.cluster)

Comparison <- clValid(obj=d.banknot[,-1],, nClust=2:6, 
                      clMethods=c("hierarchical","kmeans","pam", "model"),
                      validation="internal")
summary(Comparison)
