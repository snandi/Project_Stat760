rm(list=ls(all.names=TRUE))
rm(list=objects(all.names=TRUE))
#dev.off()

########################################################################
## This script uses Data2 and clusters them by Leukemia type          ##
########################################################################

########################################################################
## Run Header files                                                   ##
########################################################################
Filename.Header <- paste('Z:/RScripts/HeaderFile_lmcg.R', sep='')
source(Filename.Header)

RScriptPath <- 'Z:/Courses/Stat760_Fall2014/Project/RScripts_Stat760/'
RDataPath <- 'Z:/Courses/Stat760_Fall2014/Project/Data/'
RPlotPath <- 'Z:/Courses/Stat760_Fall2014/Project/RScripts_Stat760/Presentation/'
source(paste(RScriptPath, 'fn_Library_Project760.R', sep=''))

########################################################################
## Load GMM Results                                                   ##
########################################################################
load("Z:/Courses/Stat760_Fall2014/Project/Data/GMM_NoL.RData")

summary(GMM_NoL)
#str(GMM_NoL)

BIC <- GMM_NoL$BIC
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
pdf(file=paste(RPlotPath, 'BICPlot_NoL.pdf', sep=''))
BICPlot
dev.off()

