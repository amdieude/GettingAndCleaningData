---
title: "README"
author: "KONAN  Amani Dieudonne"
date: "Wednesday, February 18, 2015"
output: html_document
---

#Overall informations about the assignment
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

[link 1](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) 

Here are the data for the project: 

[link 2](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

You should create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!


```r
#Remove list in the current environnement
rm(list=ls())
#Set working directory
setwd("C:/DATA SCIENCE SPECIALIZATION/Getting and Cleaning Data")
```



```r
#installation and Loading of some necessary packages
if (!require("data.table")) {
  install.packages("data.table")
}
if (!require("reshape2")) {
  install.packages("reshape2")
}
require("data.table")
require("reshape2")
```

#Scripts for creating tidy dataset

```r
 # Read activity labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")[,2]

# Read data column names
features <- read.table("UCI HAR Dataset/features.txt")[,2]

# Extract only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", features)

# Load and process X_test & y_test data.
Xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

names(Xtest) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
Xtest <- Xtest[,extract_features]

# Load activity labels
Ytest[,2] = activity_labels[Ytest[,1]]
names(Ytest) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Bind data
test_data <- cbind(as.data.table(subject_test), Ytest, Xtest)

# Read and process X_train & Y_train data.
Xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

names(Xtrain) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
Xtrain = Xtrain[,extract_features]

# Read activity data
Ytrain[,2] = activity_labels[Ytrain[,1]]
names(Ytrain) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Merge Xtrain and Ytrain data
train_data <- cbind(as.data.table(subject_train), Xtrain, Ytrain)

# Merge test and train data
MERGE = rbind(test_data, train_data)

labels_id = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(MERGE), labels_id)
melt_data = melt(MERGE, id = labels_id, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "tidy_data.txt", row.names=FALSE)
```

