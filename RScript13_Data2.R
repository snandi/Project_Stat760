rm(list=ls(all.names=TRUE))
rm(list=objects(all.names=TRUE))
#dev.off()

########################################################################
## This script uses Data2 and records the times of clusters           ##
########################################################################

########################################################################
## Run Header files                                                   ##
########################################################################
Filename.Header <- paste('~/RScripts/HeaderFile_lmcg.R', sep='')
source(Filename.Header)

RScriptPath <- '~/Courses/Stat760_Fall2014/Project/RScripts_Stat760/'
RDataPath <- '~/Courses/Stat760_Fall2014/Project/Data/'
RPlotPath <- '~/Courses/Stat760_Fall2014/Project/RScripts_Stat760/Presentation/'
source(paste(RScriptPath, 'fn_Library_Project760.R', sep=''))

########################################################################
## Load Data 2                                                        ##
########################################################################
Filename.Data2_T <- '~/Courses/Stat760_Fall2014/Project/Data/Data2_Leuk_Transposed.txt'
Data2 <- read.table(file=Filename.Data2_T, header=TRUE, sep='\t', stringsAsFactors=F)
#Data2.subset <- Data2[,1:10000]
Data2.T <- scale(x=t(Data2), center=TRUE, scale=TRUE)

########################################################################
## Cluster system times                                               ##
########################################################################
clMethods <- c("hierarchical", "kmeans", "pam", "sota")
Comparison.Patients <- clValid(obj=t(Data2), nClust=4:8, maxitems=30000, 
                               clMethods=clMethods, validation='internal')
summary(Comparison.Patients)

Comparison.Patients.Sc <- clValid(obj=Data2.T, nClust=4:8, maxitems=30000, 
                               clMethods=clMethods, validation='internal')
summary(Comparison.Patients.Sc)

GMM.Patients <- Mclust(data=t(Data2), G=4:8)
summary(GMM.Patients)
Filename.GMM <- paste(RDataPath, 'GMM_Patients.RData', sep='')
save(GMM.Patients, file=Filename.GMM)

BIC <- GMM.Patients$BIC
BIC.r <- as.data.frame(melt(data = BIC))
colnames(BIC.r) <- c('ClusterSize', 'ModelType', 'BIC')
BIC.r <- within(data=BIC.r, {
  ModelType <- as.factor(ModelType)
})
str(BIC.r)

BICPlot <- qplot(x=ClusterSize, y=BIC, data=BIC.r, color=ModelType) +
  geom_line(size=1) + geom_point(size=3) + 
  xlab(label = 'Number of Clusters') + ylab('BIC') +
  ggtitle('Cluster Size selection in Gaussian Mixture models') +
  theme(panel.background = element_rect(fill = 'black'), 
        plot.background = element_rect(color='black', fill = "gray10"), 
        plot.title=element_text(face="bold", size=14, colour="white"),
        axis.title.x = element_text(colour = "white"), axis.title.y = element_text(colour = "white"), 
        panel.grid.major = element_line(colour="gray20", size=0.35), 
        panel.grid.minor = element_line(colour="gray10", size=0.25), 
        legend.background = element_rect(fill = 'gray10'), 
        legend.text = element_text(colour = "white"),
        legend.title = element_text(colour = "white"), 
        legend.position = 'right'
        #legend.direction = 'horizontal'
  )   
pdf(file=paste(RPlotPath, 'BICPlot_Patient.pdf', sep=''))
BICPlot
dev.off()
