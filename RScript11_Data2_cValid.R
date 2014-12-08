rm(list=ls(all.names=TRUE))
rm(list=objects(all.names=TRUE))
#dev.off()

########################################################################
## This script uses Data2 and clusters them by Leukemia type          ##
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

ALL <- Data2[,1:12]
AML <- Data2[,13:24]
CLL <- Data2[,25:36]
CML <- Data2[,36:48]
NoL <- Data2[,49:60]

########################################################################
## clValid Comparison                                                 ##
########################################################################
Time1 <- Sys.time()
NumClusters=c(6:10)
clMethods=c("hierarchical", "kmeans", "pam", "sota")
Cluster_Type <- c(rep(x = 'hierarchical', times = length(NumClusters)),
                  rep(x = 'kmeans', times = length(NumClusters)), 
                  rep(x = 'pam', times = length(NumClusters)), 
                  rep(x = 'sota', times = length(NumClusters)))

########################################################################
## ALL                                                                ##
########################################################################
CompALL <- fn_runclValid(Data = ALL, Name='ALL', DataPath=RDataPath, Validation = "internal", NumClusters=NumClusters, clMethods=clMethods)
print(Sys.time() - Time1)
summary(CompALL)
IndexComparison_ALL <- fn_returnIndexData(CompData = CompALL, NumClusters = NumClusters, 
                                          Cluster_Type = Cluster_Type)
Plot_ALL <- fn_plotComparisons(Data = IndexComparison_ALL, Cluster_Type = Cluster_Type)
Plot_ALL
dev.copy(device = jpeg, paste(RPlotPath, 'Plot_ALL.jpeg', sep=''))
dev.off()

########################################################################
## AML                                                                ##
########################################################################
Time1 <- Sys.time()
CompAML <- fn_runclValid(Data = AML, Name='AML', DataPath=RDataPath, Validation = "internal", 
                         NumClusters=NumClusters, clMethods=clMethods)
print(Sys.time() - Time1)
summary(CompAML)
IndexComparison_AML <- fn_returnIndexData(CompData = CompAML, NumClusters = NumClusters, 
                                          Cluster_Type = Cluster_Type)
Plot_AML <- fn_plotComparisons(Data = IndexComparison_AML, Cluster_Type = Cluster_Type)
Plot_AML
dev.copy(device = jpeg, paste(RPlotPath, 'Plot_AML.jpeg', sep=''))
dev.off()

########################################################################
## CLL                                                                ##
########################################################################
CompCLL <- fn_runclValid(CLL, Name='CLL', DataPath=RDataPath)
summary(CompCLL)
IndexComparison_CLL <- fn_returnIndexData(CompData = CompCLL, NumClusters = NumClusters, 
                                          Cluster_Type = Cluster_Type)
Plot_CLL <- fn_plotComparisons(Data = IndexComparison_CLL, Cluster_Type = Cluster_Type)
Plot_CLL
dev.copy(device = jpeg, paste(RPlotPath, 'Plot_AML.jpeg', sep=''))
dev.off()

########################################################################
## CML                                                                ##
########################################################################
CompCML <- fn_runclValid(CML, Name='CML', DataPath=RDataPath)
summary(CompCML)
IndexComparison_CML <- fn_returnIndexData(CompData = CompCML, NumClusters = NumClusters, 
                                          Cluster_Type = Cluster_Type)
Plot_CML <- fn_plotComparisons(Data = IndexComparison_CML, Cluster_Type = Cluster_Type)
Plot_CML
dev.copy(device = jpeg, paste(RPlotPath, 'Plot_CML.jpeg', sep=''))
dev.off()

########################################################################
## NoL                                                                ##
########################################################################
CompNoL <- fn_runclValid(NoL, Name='NoL', DataPath=RDataPath)
summary(CompNoL)
IndexComparison_NoL <- fn_returnIndexData(CompData = CompNoL, NumClusters = NumClusters, 
                                          Cluster_Type = Cluster_Type)
Plot_NoL <- fn_plotComparisons(Data = IndexComparison_NoL, Cluster_Type = Cluster_Type)
Plot_NoL
dev.copy(device = jpeg, paste(RPlotPath, 'Plot_NoL.jpeg', sep=''))
dev.off()

