# Files in repository

## ./instructions.md

Project instructions

## ./dataset.zip
Starting dataset downloaded from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## ./data

Folder containing unzipped data, before cleaning. The folder contains two datasets:

* *data/test*,
* *data/train*.

and some additional files

* *README.txt*
* *activity_labels.txt*
* *features.txt*
* *features_info.txt*

### Datasets

The train dataset contains:

* *X_train.txt*
The actual dataset, in a 7352x561 table. Each row corresponds to an observation (window sample), each column to a feature.

* *y_train.txt*
Contains labels specifying the type of activity for each observation. It is a vector of length 7352, with entries in the range 1-6, which correspond to the six types of activity considered.

* *subject_train.txt*
Contains a vector of length 7352, with entries in the range 1-30, corresponding to the individual performing the activity for each observation.

* *Inertial Signals (folder)*
Contains the raw data used to compute the 561 features reported in *X_train.txt*. Contains various tables of dim 7352x128. 128 is the number of numerical output obtained from the device in each observations for body acceleration, angular accelerations, (...) used to compute the features. 

The test dataset has a similar structure, with the following differences:

* The observations are only 2947, and correspond to the observations taken on the 30 individals selected randomly to build the test dataset.

* The features considered, as well as the activity types are the same as for the train dataset.

### Other files

* *README.txt*
Readme file, with more info.

* *activity_labels.txt*
Links between the indices 1-6 to hte activity type (walking, ...)

* *features.txt*
Labels for the 561 columns of the tables reported in *X_train.txt* and *X_test.xt*.

* *features_info.txt*
More info about the features and how they were computed.

## ./run_analysis.R

Actual analysis