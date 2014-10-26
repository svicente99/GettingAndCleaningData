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
"plyr" package. Two data sets (train and test) are read each one to a data frame and
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

## Step 4: Putting labels to the data set based on its descriptive variable names 

## Step 5: Creating a second, independent tidy data set with the average of each variable 
           summarized by each activity and each subject
		   
		   
