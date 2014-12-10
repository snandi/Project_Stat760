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
load(paste("Z:/Courses/Stat760_Fall2014/Project/Data/Comparison_", Name, ".RData", sep=''))

CompName <- paste('Comparison_', Name, sep='')
summary(get(CompName))

Opt <- as.data.frame(optimalScores(get(CompName)), stringsAsFactor = F)
Opt$Score <- round(Opt$Score, 2)
Opt$Method <- as.vector(Opt$Method)
Opt$Clusters <- as.numeric(as.vector(Opt$Clusters))
Opt

load(paste("Z:/Courses/Stat760_Fall2014/Project/Data/GMM_", Name, ".RData", sep=''))
GMMName <- paste('GMM_', Name, sep='')
str(get(GMMName))
ModelName <- (get(GMMName))$modelName
BIC <- ((get(GMMName))$BIC)[9,ModelName]
ModelType <- mclustModelNames(ModelName)$type

Opt <- rbind(Opt, c(round(BIC), ModelType, 9))
rownames(Opt)[4] <- 'BIC (GMM)'
Opt
