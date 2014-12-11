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
Name <- 'CML'
Subsets <- c('ALL', 'AML', 'CLL', 'CML', 'NoL')
OptResults <- NULL
OptResults.Sc <- NULL
BICs <- NULL
for(Name in Subsets){
  Title <- c(ALL='Acute Lymphoblastic Leukemia (ALL)', 
             AML='Acute Myeloid Leukemia (AML)', 
             CLL='Chronic Lymphocytic Leukemia (CLL)', 
             CML='Chronic Myeloid Leukemia (CML)', 
             NoL='Non-leukemia and (healthy bone marrow) (NoL)')
  Title[[Name]]
  
  clMethods=c("hierarchical", "kmeans", "pam", "sota")
  
  
  load(paste("Z:/Courses/Stat760_Fall2014/Project/Data/Comparison_", Name, ".RData", sep=''))
  load(paste("Z:/Courses/Stat760_Fall2014/Project/Data/Comparison_", Name, "_Scaled.RData", sep=''))
  load(paste("Z:/Courses/Stat760_Fall2014/Project/Data/GMM_", Name, ".RData", sep=''))
  
  Name1 <- paste('Comparison_', Name, sep='')
  Name2 <- paste('Comparison', Name, 'Scaled', sep='_')
  GMMName <- paste('GMM_', Name, sep='')
  summary(get(Name1))
  summary(get(Name2))
  summary(get(GMMName))
  
  
  ########################################################################
  ## This part of the code was used to fix the plot titles.             ##
  ########################################################################
  # NumClusters <- c(6:9)
  # IndexComparison <- fn_returnIndexData(CompData = get(Name1), NumClusters = NumClusters, 
  #                                           Cluster_Type = Cluster_Type)
  # Plot <- fn_plotComparisons(Data = IndexComparison, Cluster_Type = Cluster_Type,
  #                                Title=Title[[Name]])
  # Plot
  # dev.copy(device = jpeg, paste(RPlotPath, 'Plot_', Name, '.jpeg', sep=''))
  # dev.off()
  # 
  # NumClusters <- c(6:9)
  # IndexComparison <- fn_returnIndexData(CompData = get(Name2), NumClusters = NumClusters, 
  #                                       Cluster_Type = Cluster_Type)
  # Plot <- fn_plotComparisons(Data = IndexComparison, Cluster_Type = Cluster_Type,
  #                            Title=paste(Title[[Name]], '[Scaled]'))
  # Plot
  # dev.copy(device = jpeg, paste(RPlotPath, 'Plot_', Name, '_Scaled.jpeg', sep=''))
  # dev.off()
  ########################################################################
  
  Opt <- as.data.frame(optimalScores(get(Name1)), stringsAsFactor = F)
  Opt$Score <- round(Opt$Score, 2)
  Opt$Method <- as.vector(Opt$Method)
  Opt$Clusters <- as.numeric(as.vector(Opt$Clusters))
  Opt$Index <- rownames(Opt)
  Opt$Subset <- Name
  rownames(Opt) <- NULL

  OptResults <- rbind(OptResults, Opt)
  
  Opt.Sc <- as.data.frame(optimalScores(get(Name2)), stringsAsFactor = F)
  Opt.Sc$Score <- round(Opt.Sc$Score, 2)
  Opt.Sc$Method <- as.vector(Opt.Sc$Method)
  Opt.Sc$Clusters <- as.numeric(as.vector(Opt.Sc$Clusters))
  Opt.Sc$Index <- rownames(Opt.Sc)
  Opt.Sc$Subset <- Name
  rownames(Opt.Sc) <- NULL

  OptResults.Sc <- rbind(OptResults.Sc, Opt.Sc)

  ModelName <- (get(GMMName))$modelName
  BIC <- round(as.numeric(((get(GMMName))$BIC)[9,ModelName]))
  ModelType <- mclustModelNames(ModelName)$type
  BICs <- rbind(BICs, c(Subset=Name, Model=ModelName, BIC=BIC))  
}

OptResults <- as.data.frame(OptResults)
str(OptResults)
OptResults

print(xtable(OptResults), include.rownames=FALSE)

OptResults.Sc <- as.data.frame(OptResults.Sc)
str(OptResults.Sc)
OptResults.Sc
print(xtable(OptResults.Sc[,-5]), include.rownames=FALSE)

BICs <- as.data.frame(BICs)
str(BICs)
BICs <- within(data=BICs, {
  BIC <- as.numeric(as.vector(BIC))
})

BICPlot <- qplot(x=Subset, y=BIC, data=BICs) +
  geom_bar(stat='identity', fill='gray70') + 
  xlab(label = 'Type of Leukemia') + ylab('BIC') +
  ggtitle('BIC of Gaussian Mixture models') +
  theme(panel.background = element_rect(fill = 'black'), 
        plot.background = element_rect(color='black', fill = "gray10"), 
        plot.title=element_text(face="bold", size=14, colour="white"),
        axis.title.x = element_text(colour = "white", size=12), 
        axis.title.y = element_text(colour = "white", size=12), 
        axis.text.x = element_text(size=12, face='bold'), 
        panel.grid.major = element_line(colour="gray20", size=0.35), 
        panel.grid.minor = element_line(colour="gray10", size=0.25), 
        legend.background = element_rect(fill = 'gray10'), 
        legend.text = element_text(colour = "white"),
        legend.title = element_text(colour = "white"), 
        legend.position = 'right'
        #legend.direction = 'horizontal'
  )    

pdf(file=paste(RPlotPath, 'BICPlot_Comparison.pdf', sep=''))
BICPlot
dev.off()

str(OptResults)
subset(OptResults, Index=='Connectivity')
ConnectPlot <- qplot(x=factor(Subset), y=Score, data=subset(OptResults, Index=='Connectivity')) +
  geom_bar(stat='identity', fill='deepskyblue1') + 
  xlab(label = 'Type of Leukemia') + ylab('Connectivity Index') +
  ggtitle('Connectivity Index of Hierarchical clusters (size 6)') +
  theme(panel.background = element_rect(fill = 'black'), 
        plot.background = element_rect(color='black', fill = "gray10"), 
        plot.title=element_text(face="bold", size=14, colour="white"),
        axis.title.x = element_text(colour = "white", size=12), 
        axis.title.y = element_text(colour = "white", size=12), 
        axis.text.x = element_text(size=12, face='bold'), 
        panel.grid.major = element_line(colour="gray20", size=0.35), 
        panel.grid.minor = element_line(colour="gray10", size=0.25), 
        legend.background = element_rect(fill = 'gray10'), 
        legend.text = element_text(colour = "white"),
        legend.title = element_text(colour = "white"), 
        legend.position = 'right'
        #legend.direction = 'horizontal'
  )    
pdf(file=paste(RPlotPath, 'ConnectPlot_Comparison.pdf', sep=''))
ConnectPlot
dev.off()


ComparisonPlot <- qplot(x=factor(Subset), y=Score, data=OptResults) +
  geom_bar(width=0.75, stat='identity', fill='deepskyblue1') + 
  facet_wrap(~Index, ncol=1, scales="free") +
  xlab(label = 'Type of Leukemia') + ylab('') +
  ggtitle('Comparison of best cluster for different Leukemia types') +
  theme(panel.background = element_rect(fill = 'black'), 
        plot.background = element_rect(color='black', fill = "gray10"), 
        plot.title=element_text(face="bold", size=14, colour="white"),
        axis.title.x = element_text(colour = "white", size=12), 
        axis.title.y = element_text(colour = "white", size=12), 
        axis.text.x = element_text(size=12, face='bold'), 
        panel.grid.major = element_line(colour="gray20", size=0.35), 
        panel.grid.minor = element_line(colour="gray10", size=0.25), 
        legend.background = element_rect(fill = 'gray10'), 
        legend.text = element_text(colour = "white"),
        legend.title = element_text(colour = "white"), 
        legend.position = 'right'
        #legend.direction = 'horizontal'
  )    

pdf(file=paste(RPlotPath, 'ComparisonPlot.pdf', sep=''))
ComparisonPlot
dev.off()

ComparisonPlot.Sc <- qplot(x=factor(Subset), y=Score, data=OptResults.Sc) +
  geom_bar(width=0.75, stat='identity', fill='turquoise1') + 
  facet_wrap(~Index, ncol=1, scales="free") +
  xlab(label = 'Type of Leukemia') + ylab('') +
  ggtitle('Comparison of best cluster for different Leukemia types (Scaled Data)') +
  theme(panel.background = element_rect(fill = 'black'), 
        plot.background = element_rect(color='black', fill = "gray10"), 
        plot.title=element_text(face="bold", size=14, colour="white"),
        axis.title.x = element_text(colour = "white", size=12), 
        axis.title.y = element_text(colour = "white", size=12), 
        axis.text.x = element_text(size=12, face='bold'), 
        panel.grid.major = element_line(colour="gray20", size=0.35), 
        panel.grid.minor = element_line(colour="gray10", size=0.25), 
        legend.background = element_rect(fill = 'gray10'), 
        legend.text = element_text(colour = "white"),
        legend.title = element_text(colour = "white"), 
        legend.position = 'right'
        #legend.direction = 'horizontal'
  )    

pdf(file=paste(RPlotPath, 'ComparisonPlot_Sc.pdf', sep=''))
ComparisonPlot.Sc
dev.off()
