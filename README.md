<h2>Getting And Cleaning Data - Course Project</h2>

Related to "Getting And Cleaning Data", 3rd part of Data Science Specatialization, from Johns Hopkins University. A Coursera training.

### Introduction

This project was intended to demonstrate ability to collect, work with, 
and clean a data set provided by instructors. It represents data collected 
from the accelerometers from the Samsung Galaxy S smartphone. 
A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The goal is to prepare tidy data that can be used for later analysis. 

The data used in this project was downloaded from: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Step 0: Parameter definitions and file checking

First of all, I define a set of parameters that it allows reusing this code in several
situations or renaming its variables and files (names and extensions). 

After, I check if all necessary files to execute the script are available and saved 
in pointed folders.  

## Step 1: Training and test sets merged to create one data set

In this part I merge data calling a function named <b>"merge_data()"</b>. Its code requires
"<b>plyr</b>" package. Two data sets (train and test) are read each one to a data frame and
merged to another one called "oneData" (returned by this function).

<!-- -->

    merge_data <- function() {
        .
		.
		.
		oneData <- merge(df1, df2, all=TRUE)
		return(oneData)
    }

## Step 2: Extracting measurements on the mean and standard deviation for each measurement

I use 'dataSet' obtained before to cut only variables that represents mean and standard
deviation using [R] "grep" and "colnames" functions. The list of variables is read from
"features.txt" file to a specific vector ("vFeatures"). 

The function called is <b>"cut_mean_stdDev()"</b>

## Step 3: Describing activity names in the data set

"<b>describe_ativs</b>" is a simple function to read file with activity names and replace
activity codes by its names.

## Step 4: Putting labels to the data set based on its descriptive variable names

I create an array "<b>aColNames</b>" to set all column names doing a relation with 
variable names (many and many mean and standard deviation).

## Step 5: Creating a second, independent tidy data set with the average of each variable 
           summarized by each activity and each subject
		   
The most important (difficult, too!) part of this project ("core") is coded by loop
showed below:

<!-- -->

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
  		   
My solution was supported on 3 tracks that I got from "stackoverflow" code repository.
It uses mainly "<b>ddply</b>" and "<b>do.call</b>" features to summarise all dataSet, 
grouped by "Subject" and "Activity" factors.   

At last, data are saved in two .txt files. One, "result1.txt", with 10299 rows showing
all values collected from train and test sets. Second one, <b>"resultM.txt"</b> shows all means
and standard deviations measurements, with calculated mean summarized by Subject and
Activity. "<b>ddply</b>" method does this hard work and a dynamic expression (to join a big lot
of measurements is assembled by "<b>do.call</b>" special function.

Thanks for your attention.
---------
# Sergio
# @svicente99		   
