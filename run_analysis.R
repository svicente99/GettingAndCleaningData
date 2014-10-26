## 	----------------------------------------------------------
##  Coursera.org
## 
##	Getting Cleaning Data - Course Project: solution
##
##  Student...:	Sergio Vicente (Niteroi, Brazil)
##  Twitter...: @svicente99 (svicente99@yahoo.com)
##  Date......: Oct.20th 2014
## 	----------------------------------------------------------

## 	Refs.: https://class.coursera.org/getdata-008/human_grading/view/courses/972586/assessments/3/submissions

##	-----------------------------------------------------------


##  module parameters

UCI_folder <- "./UCI HAR Dataset"
EXT <- "txt"
vFiles <- c("subject", "y", "X")
vCases <- c("test", "train")
feat_file <- "features.txt"
ativ_file <- "activity_labels.txt"

check_data_files <- function() {
	for(attribute in vCases) {
		folder <- paste(UCI_folder, attribute, sep='/')
		for(oneFile in vFiles) {
			nmFile <- paste(folder,paste(paste(oneFile, attribute, sep="_"), EXT, sep='.'), sep="/")
			print(nmFile)
			if(!file.exists(nmFile)) 	return(FALSE)
		}
	}		
		
	return(TRUE);		
}

read_features <- function() {
	# http://stat.ethz.ch/R-manual/R-patched/library/base/html/readLines.html
	lstFeatures <- readLines(paste(UCI_folder, feat_file, sep="/"))
	return( lstFeatures )
}

read_data <- function(attribute) {
	folder <- paste(UCI_folder, attribute, sep='/')
	i <- 0
	print(paste("Wait... Merging files for attribute ", attribute));

	# read each file containing data to this project: subject, y and X
	for(oneFile in vFiles) {
		nmFile <- paste(folder,paste(paste(oneFile, attribute, sep="_"), EXT, sep='.'), sep="/")
		if(oneFile=="subject")
			df_subject = read.csv(nmFile,header=F)
		else
		if(oneFile=="y")
			df_y = read.csv(nmFile,header=F)
		else
		if(oneFile=="X")
			# http://stat.ethz.ch/R-manual/R-patched/library/utils/html/read.table.html
			df_X = read.table(nmFile, header=F, stringsAsFactors=F)
	}	
	# combine above data in one data frame (each row is a set of X, Y corresponding to a subject observation)
	df <- data.frame(attribute, df_subject, df_y)
	df <- cbind(df, df_X)
	return( df )
}


## -------------------------------------------------------------

merge_data <- function() {
	require(plyr)

	if(check_data_files())
		print("Locating data files... OK")
	else
		print("Locating data files... ERROR!")

	vFeatures <- read_features()
	nFeatures <- length(vFeatures)
	if( UCI_folder == "./UCI HAR Test" )  nFeatures = 8

	df1 <- read_data("test")
	colnames(df1) <- c("set", "Subject", "Activity", vFeatures[1:nFeatures])
	df2 <- read_data("train")
	colnames(df2) <- c("set", "Subject", "Activity", vFeatures[1:nFeatures])
##	use to debug
#	print(df1); print(dim(df1))
#	print(df2); print(dim(df2))
	print("*************************************************")
	oneData <- merge(df1, df2, all=TRUE)
#	print(oneData)
	print("*************************************************")
#	print(dim(oneData))
	
	return(oneData)
}

## -------------------------------------------------------------

cut_mean_stdDev <- function(df) {
	vFeatures <- read_features()
	# Ref.: http://grokbase.com/t/r/r-help/102q778ach/r-deleting-column-from-data-frame
	dfMeans <- df[, grep("mean()", colnames(df)) ]
	dfStd   <- df[, grep("std()",colnames(df)) ]
	df2 <- data.frame(df[,1:3], dfMeans, dfStd)
#	print(dim(df2))
	return(df2)
}

## -------------------------------------------------------------

describe_ativs <- function(df) {
	lstAtivs <- readLines(paste(UCI_folder, ativ_file, sep="/"))
	nAtivs <- length(lstAtivs)
	# Ref.: http://r.789695.n4.nabble.com/replace-values-in-data-frame-td803416.html
	# df$Activity <- replace(df$Activity, c(1:nAtivs), lstAtivs)
	return(df)
}

## -------------------------------------------------------------
## MAIN CODE	
## -------------------------------------------------------------

## 	Step 1) Merges the training and the test sets to create one data set
	dataSet <- merge_data()
##	Step 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
	dataSet <- cut_mean_stdDev(dataSet)
##	Step 3) Uses descriptive activity names to name the activities in the data set
	dataSet <- describe_ativs(dataSet)

#print(dataSet)
library(plyr)

# Ref.: http://www.cookbook-r.com/Manipulating_data/Summarizing_data/
#

#dfMeans <- ddply(dataSet, c("Subject", "Activity"),
#                 summarise, 
#                 mean1=mean(X1.tBodyAcc.mean...X),
#                 mean2=mean(X2.tBodyAcc.mean...Y)) 
#print(dfMeans)

##	Step 4) Appropriately labels the data set with descriptive variable names. 
	aCols <- colnames(dataSet)
	aColNames <- aCols[4:length(aCols)]

##  with the average of each variable for each activity and each subject = dfMeans
##	Step 5) From the data set in step 4, creates a second, independent tidy data set 

i <- 0 
dfMeans <- data.frame()
for(nmCol in aColNames) {
	i <- i+1
	#Ref.: http://stackoverflow.com/questions/15270482/string-to-variable-name-in-r (get)
	args <- alist(dataSet, c('Subject','Activity'), summarise, mean(get(nmCol)))
	#Ref.: http://stackoverflow.com/questions/16454943/how-can-i-assign-a-variables-value-to-column-name-in-plyr
	names(args) <- c("", "", "", nmCol)
	df1Mean <- do.call("ddply", args)
	if(i==1)
		dfMeans <- df1Mean
	else{
		dfMeans <- cbind(dfMeans, df1Mean[,3])
		#Ref.: http://stackoverflow.com/questions/7531868/how-to-rename-a-single-column-in-a-data-frame-in-r
		colnames(dfMeans)[i+2] <- nmCol
		}
}

#print(dfMeans)
write.table(dataSet, "result1.txt", row.names=FALSE)
write.table(dfMeans, "resultM.txt", row.names=FALSE)
