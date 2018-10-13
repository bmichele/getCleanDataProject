## preliminaries
rm(list = ls())
setwd("/home/miche/Repositories/getCleanDataProject")

## loading packages
library("dplyr")
library("reshape2")

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
list_Features <- read.table("data/UCI HAR Dataset/features.txt")
list_Features <- rename(list_Features,"featureid" = "V1","featurename" = "V2")
list_Features$featurename <- make.names(
    names = list_Features$featurename,
    unique = TRUE
)
list_Activities <- read.table("data/UCI HAR Dataset/activity_labels.txt")
list_Activities <- rename(list_Activities,
                          "activityid" = "V1",
                          "activityname" = "V2"
                          )

# load the training dataset
data_Train_X <- read.table("data/UCI HAR Dataset/train/X_train.txt")
data_Train_Y <- read.table("data/UCI HAR Dataset/train/y_train.txt")
data_Train_Subj <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
# load the test dataset
data_Test_X <- read.table("data/UCI HAR Dataset/test/X_test.txt")
data_Test_Y <- read.table("data/UCI HAR Dataset/test/y_test.txt")
data_Test_Subj <- read.table("data/UCI HAR Dataset/test/subject_test.txt")

# Setting names to dataframes of training set
names(data_Train_X) <- list_Features$featurename 
data_Train_Y <- rename(data_Train_Y,"activity" = "V1")
data_Train_Subj <- rename(data_Train_Subj,"subject.id" = "V1")


# Setting names to dataframes of test set
names(data_Test_X) <- list_Features$featurename 
data_Test_Y <- rename(data_Test_Y,"activity" = "V1")
data_Test_Subj <- rename(data_Test_Subj,"subject.id" = "V1")

# Storing dimensions of dataframes
nobs_Train <- nrow(data_Train_X) # number of window samples in training dataset
nobs_Test <- nrow(data_Test_X)   # number of window samples in test dataset
nobs_Global <- nobs_Train + nobs_Test # total number of window samples

# Adding a column to keep track of original dataset
data_Train_X$dataset <- as.factor(rep("train",nobs_Train))
data_Test_X$dataset <- as.factor(rep("test",nobs_Test))

# I merge the two datasets (training BEFORE test in rows)
data_Global_X <- rbind(data_Train_X,data_Test_X)
data_Global_Y <- rbind(data_Train_Y,data_Test_Y)
data_Global_Subj <- rbind(data_Train_Subj,data_Test_Subj)

# I specify the activities using factors and with levels given by proper names
data_Global_Y$activity <- as.factor(data_Global_Y$activity)
levels(data_Global_Y$activity) <- tolower(list_Activities$activityname)

# I specify the subjects using factors instead of integers
data_Global_Subj$subject.id <- as.factor(data_Global_Subj$subject.id)

# I put all informations together in a dataframe data_Global
# This dataframe contains as much informations as possible coming from the
# starting data and can be used to extract what is needed for the project.
data_Global <- cbind(
    data_Global_Y,
    data_Global_Subj,
    data_Global_X
)

# I build a dataframe containing only measurements of mean and standard
# deviations
data_Final <- select(
    data_Global,
    activity,
    subject.id,
    grep("mean\\.\\.|std\\.\\.",names(data_Global),value = TRUE)
)

# I do some replacements to have descriptive names
names_desc <- sub("^t","time",names(data_Final))
names_desc <- sub("^f","frequency",names_desc)
names_desc <- sub("Acc","Acceleration",names_desc)
names_desc <- sub("Gyro","AngularAcceleration",names_desc)
names_desc <- sub("Mag","Magnitude",names_desc)
names_desc <- sub("mean","average",names_desc)
names_desc <- sub("std","standard.deviation",names_desc)
names_desc <- gsub("([A-Z])",".\\1",names_desc)
names_desc <- gsub("\\.{2,}$","",names_desc)
names_desc <- tolower(gsub("\\.{2,}","\\.",names_desc))

names(data_Final) <- names_desc

# I build a second dataset with required average values
data_Final <- melt(data = data_Final, id = c("subject.id", "activity"))
data_Final <- dcast(data = data_Final,subject.id + activity ~ variable,fun.aggregate = mean)

# I write the data in the file "data_Final.csv"
write.csv(data_Final,file = "data_final.csv",row.names = FALSE,quote = FALSE)