# preliminaries
# rm(list = ls())
# setwd("/home/miche/Repositories/getCleanDataProject")

# I download the data
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("dataset.zip")){
    download.file(fileURL,destfile = "dataset.zip")
}
# and unzip, putting content in ./data
if(!file.exists("./data")){
    dir.create("data")
    unzip("dataset.zip",exdir = "./data")
}

