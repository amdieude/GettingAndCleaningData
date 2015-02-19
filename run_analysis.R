#Remove list in the current environnement
rm(list=ls())
#Set working directory
setwd("C:/DATA SCIENCE SPECIALIZATION/Getting and Cleaning Data")

if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

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