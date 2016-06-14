rm(list=ls(all.names=TRUE))
rm(list=objects(all.names=TRUE))
#dev.off()

########################################################################
## This script is a copy of RScript10_Data2_GMM.R, only this one runs
## on stat linux systems
## This is to reproduce the results.
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
## GMM                                                                ##
########################################################################
fn_runGMM(ALL, Name='ALL', DataPath=RDataPath)

fn_runGMM(AML, Name='AML', DataPath=RDataPath)

fn_runGMM(CLL, Name='CLL', DataPath=RDataPath)

fn_runGMM(CML, Name='CML', DataPath=RDataPath)

fn_runGMM(NoL, Name='NoL', DataPath=RDataPath)

Name <- 'ALL'
for(Name in c('ALL', 'AML', 'CLL', 'CML', 'NoL')){
  Name1 <- paste('GMM', Name, sep='_')
  Filename.GMM <- paste(RDataPath, Name1, '.RData', sep='')
  load(Filename.GMM)
  print(summary(get(Name1)))
}
