rm(list=ls(all.names=TRUE))
rm(list=objects(all.names=TRUE))
#dev.off()

########################################################################
## This script just reads in and saves two parts of Data2. One of the ##
## parts is just the last 5 cols and the other part is a transpose of ##
## the remaining dataset. This is similar to Data1 format.            ##
########################################################################

########################################################################
## Run Header files                                                   ##
########################################################################
Filename.Header <- paste('Z:/RScripts/HeaderFile_lmcg.R', sep='')
source(Filename.Header)

RScriptPath <- 'Z:/Courses/Stat760_Fall2014/Project/RScripts_Stat760/'
RDataPath <- 'Z:/Courses/Stat760_Fall2014/Project/Data/'
source(paste(RScriptPath, 'fn_Library_Project760.R', sep=''))

########################################################################
## Data 2                                                             ##
########################################################################
Filename.Data2 <- 'Z:/Courses/Stat760_Fall2014/Project/Data/Data2_Leuk.txt'
Data2 <- read.table(file=Filename.Data2, header=TRUE, sep='\t', stringsAsFactors=F)
#Data2.subset <- Data2[,1:10000]

## Save last 5 columns of Data 2
View(Data2[,20173:20177])
Filename.Data2_Last5 <- 'Z:/Courses/Stat760_Fall2014/Project/Data/Data2_Last5Cols.txt'
write.table(x = Data2[,20173:20177], file = Filename.Data2_Last5, row.names = T, col.names=T, 
            sep = "\t", quote = FALSE)

## Save without the last 5 columns of Data 2, transposed
Filename.Data2_T <- 'Z:/Courses/Stat760_Fall2014/Project/Data/Data2_Leuk_Transposed.txt'
write.table(x = t(Data2[,1:20172]), file = Filename.Data2_T, row.names = T, col.names=T, 
            sep = "\t", quote = FALSE)

