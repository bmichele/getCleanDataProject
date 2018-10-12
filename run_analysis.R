## preliminaries
rm(list = ls())
setwd("/home/miche/Repositories/getCleanDataProject")

## loading packages
library("dplyr")

## I download and unzip the data
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("dataset.zip")){
    download.file(fileURL,destfile = "dataset.zip")
}
if(!file.exists("./data")){
    dir.create("data")
    unzip("dataset.zip",exdir = "./data")
}

## Firstly, I merge the train and test datsets. In order to keep as much
## information as possible, before merging, I add a column specifying the
## original dataset (training or test)

# load files with info ad giving names
list.Features <- read.table("data/UCI HAR Dataset/features.txt")
list.Features <- rename(list.Features,"featureid" = "V1","featurename" = "V2")
list.Features$featurename <- make.names(
    names = list.Features$featurename,
    unique = TRUE
)
list.Activities <- read.table("data/UCI HAR Dataset/activity_labels.txt")
list.Activities <- rename(list.Activities,
                          "activityid" = "V1",
                          "activityname" = "V2"
                          )

# load the training dataset
data.Train.X <- read.table("data/UCI HAR Dataset/train/X_train.txt")
data.Train.Y <- read.table("data/UCI HAR Dataset/train/y_train.txt")
data.Train.Subj <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
# load the test dataset
data.Test.X <- read.table("data/UCI HAR Dataset/test/X_test.txt")
data.Test.Y <- read.table("data/UCI HAR Dataset/test/y_test.txt")
data.Test.Subj <- read.table("data/UCI HAR Dataset/test/subject_test.txt")

# Setting names to dataframes of training set
names(data.Train.X) <- list.Features$featurename 
data.Train.Y <- rename(data.Train.Y,"activity" = "V1")
data.Train.Subj <- rename(data.Train.Subj,"subjectid" = "V1")


# Setting names to dataframes of test set
names(data.Test.X) <- list.Features$featurename 
data.Test.Y <- rename(data.Test.Y,"activity" = "V1")
data.Test.Subj <- rename(data.Test.Subj,"subjectid" = "V1")

# Storing dimensions of dataframes
nobs.Train <- nrow(data.Train.X) # number of window samples in training dataset
nobs.Test <- nrow(data.Test.X)   # number of window samples in test dataset
nobs.Global <- nobs.Train + nobs.Test # total number of window samples

# Adding a column to keep track of original dataset
data.Train.X$dataset <- as.factor(rep("train",nobs.Train))
data.Test.X$dataset <- as.factor(rep("test",nobs.Test))

# I merge the two datasets (training BEFORE test in rows)
data.Global.X <- rbind(data.Train.X,data.Test.X)
data.Global.Y <- rbind(data.Train.Y,data.Test.Y)
data.Global.Subj <- rbind(data.Train.Subj,data.Test.Subj)

# I specify the activities using factors and with levels given by proper names
data.Global.Y$activity <- as.factor(data.Global.Y$activity)
levels(data.Global.Y$activity) <- list.Activities$activityname

# I specify the subjects using factors instead of integers
data.Global.Subj$subjectid <- as.factor(data.Global.Subj$subjectid)

# I put all informations together in a dataframe data.Global
# This dataframe contains as much informations as possible coming from the
# starting data and can be used to extract what is needed for the project.
data.Global <- cbind(
    data.Global.Y,
    data.Global.Subj,
    data.Global.X
)

# I build a dataframe containing only measurements of mean and standard
# deviations
data.Final <- select(
    data.Global,
    activity,
    subjectid,
    grep("mean\\.\\.|std\\.\\.",names(data.Global),value = TRUE)
)


# TODOs: 
#  - set proper names
#  - set units
#  - build second dataset with required average values