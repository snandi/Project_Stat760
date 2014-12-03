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
CompALL <- fn_runclValid(ALL, Name='ALL', DataPath=RDataPath)
summary(CompALL)

CompAML <- fn_runclValid(AML, Name='AML', DataPath=RDataPath)
summary(CompAML)

CompCLL <- fn_runclValid(CLL, Name='CLL', DataPath=RDataPath)
summary(CompCLL)

CompCML <- fn_runclValid(CML, Name='CML', DataPath=RDataPath)
summary(CompCML)

CompNoL <- fn_runclValid(NoL, Name='NoL', DataPath=RDataPath)
summary(CompNoL)

