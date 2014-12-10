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

NoL <- Data2[,49:60]

########################################################################
## Cluster system times                                               ##
########################################################################
clMethods <- c("hierarchical", "kmeans", "pam", "sota", "model")
NGenes <- c(2500, 5000, 10000, 15000, 20172)
Times <- expand.grid(ClusterType=clMethods, NGenes=NGenes)
Times$Time <- 0
for(i in 1:nrow(Times)){
  #Subset <- NoL[1:Times[i,'NGenes'],]
  Rows <- sample(x=1:20172, size=Times[i,'NGenes'], replace=FALSE)
  Subset <- NoL[Rows,]
  ClusterType <- Times[i,'ClusterType']
  Times[i,'Time'] <- system.time(clValid(obj=Subset, nClust=6, maxitems=30000,
                             clMethods=ClusterType, validation='internal'))[[3]]
}


########################################################################
## Plot results                                                       ##
########################################################################
Times <- within(data=Times, {
  ClusterType <- as.factor(ClusterType)
})
str(Times)
TimePlot <- qplot(x=NGenes, y=Time/60, data=Times, color=ClusterType) +
  geom_line(size=1) + geom_point(size=3) +
  xlab(label = 'Number of Genes') + ylab('Computation time (in minutes)') +
  ggtitle('Computation time of different types of clusters') +
  theme(panel.background = element_rect(fill = 'black'), 
        plot.background = element_rect(color='black', fill = "gray10"), 
        plot.title=element_text(face="bold", size=14, colour="white"),
        axis.title.x = element_text(colour = "white"), axis.title.y = element_text(colour = "white"), 
        panel.grid.major = element_line(colour="gray20", size=0.35), 
        panel.grid.minor = element_line(colour="gray10", size=0.25), 
        legend.background = element_rect(fill = 'gray10'), 
        legend.text = element_text(colour = "white"),
        legend.title = element_text(colour = "white"), 
        legend.position = 'bottom', 
        legend.direction = 'horizontal'
        )    
pdf(file=paste(RPlotPath, 'TimePlot_NoL.pdf', sep=''))
TimePlot
dev.off()
    #dev.copy(device = jpeg, paste(RPlotPath, 'TimePlot_NoL.jpeg', sep=''))
dev.off()

