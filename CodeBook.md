# Code Book

## Actions performed to clean tha dataset

Original data are downloaded at the link

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

and a full description of the data is available at the page

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


In the following, we go through the most important steps taken in the cleaning process.

### Download and clean training and test datasets

The required files are loaded by

```
# features and activity names
list_Features <- read.table("data/UCI HAR Dataset/features.txt")
list_Activities <- read.table("data/UCI HAR Dataset/activity_labels.txt")
# training dataset
data_Train_X <- read.table("data/UCI HAR Dataset/train/X_train.txt")
data_Train_Y <- read.table("data/UCI HAR Dataset/train/y_train.txt")
data_Train_Subj <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
# test dataset
data_Test_X <- read.table("data/UCI HAR Dataset/test/X_test.txt")
data_Test_Y <- read.table("data/UCI HAR Dataset/test/y_test.txt")
data_Test_Subj <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
```

Then the names of the dataframes are modified in order to be compatible with R (removing parenthesis and calling the `make.names()` function).

The names of the dataframes containing the training and test datasets are given by the features listed in `list_Features` and are set by

```
names(data_Train_X) <- list_Features$featurename
names(data_Test_X) <- list_Features$featurename

```

### Merging the datasets

Firstly, the dataframes corresponding to the training dataset and the test dataset are merged by rows, so that the resulting dataframes have all the observations (window samples) of the training set first, followed by the observations of the test dataset. This is done using

```
data_Global_X <- rbind(data_Train_X,data_Test_X)
data_Global_Y <- rbind(data_Train_Y,data_Test_Y)
data_Global_Subj <- rbind(data_Train_Subj,data_Test_Subj)
```

At this point, we have three dataframes:

 * `data_Global_X`, containing the feature values for all the observations
 * `data_Global_Y`, containing the activity corresponding to each observation
 * `data_Global_Subj`, containing the individuals corresponding to each observation.
 
 The dataframes are merged by column by
 
 ```
 data_Global <- cbind(
    data_Global_Y,
    data_Global_Subj,
    data_Global_X
)
 ```

### Selecting relevant columns and cleaning names

As requested by the exercise, from the dataframe `data_Global`, only the values of means and standard deviations are selected using the `select()` function from the `dplyr` package.

Moerover, the names of the resulting dataframes are changed in order to be more understandable, by multiple calls to the `sub()` function. For example, the first call replaces the prefix `t` of the "time" variables by

```
names(data_Final) <- sub("^t","time",names(data_Final))
```

### Building and writing the tidy dataset

The tidy dataframe containing the average of each variable for each activity and each subject is defined using the functions `melt()` and `dcast()` (`reshape2` package) in the following way:

```
data_Final <- melt(data = data_Final, id = c("subject.id", "activity"))
data_Final <- dcast(data = data_Final,subject.id + activity ~ variable,fun.aggregate = mean)
```

and the tidy dataset is written to the file *data_final.csv*.

## Summary of quantities reported in data_final.csv

#### 1. activity

"factor"
Activity type.
Values:

* walking
* walking_upstairs
* walking_downstairs
* sitting
* standing
* laying

#### 2. subject.id

"factor"
Subject performing the activity.
Values: 1-30

#### 3. time.body.acceleration.average.x

"numeric"
Standard gravity units 'g'.
Average body acceleration along x-axis.

#### 4. time.body.acceleration.average.y

"numeric"
Standard gravity units 'g'.
Average body acceleration along y-axis.
	
#### 5. time.body.acceleration.average.z

"numeric"
Standard gravity units 'g'.
Average body acceleration along z-axis.
	
#### 6. time.body.acceleration.standard.deviation.x

"numeric"
Standard gravity units 'g'.
Average standard deviation of body acceleration along x-axis.

#### 7. time.body.acceleration.standard.deviation.y

"numeric"
Standard gravity units 'g'.
Average standard deviation of body acceleration along y-axis.

#### 8. time.body.acceleration.standard.deviation.z

"numeric"
Standard gravity units 'g'.
Average standard deviation of body acceleration along z-axis.

#### 9. time.gravity.acceleration.average.x

"numeric"
Standard gravity units 'g'.
Average gravitational acceleration along x-axis.

#### 10. time.gravity.acceleration.average.y

"numeric"
Standard gravity units 'g'.
Average gravitational acceleration along y-axis.

#### 11. time.gravity.acceleration.average.z

"numeric"
Standard gravity units 'g'.
Average gravitational acceleration along z-axis.

#### 12. time.gravity.acceleration.standard.deviation.x

"numeric"
Standard gravity units 'g'.
Average standard deviation of gravity acceleration along x-axis.

#### 13. time.gravity.acceleration.standard.deviation.y

"numeric"
Standard gravity units 'g'.
Average standard deviation of gravity acceleration along y-axis.

#### 14. time.gravity.acceleration.standard.deviation.z

"numeric"
Standard gravity units 'g'.
Average standard deviation of gravity acceleration along z-axis.

#### 15. time.body.acceleration.jerk.average.x

"numeric"
Standard gravity units per seconds 'g/s'.
Average derivative (with respect to time) of body acceleration along x-axis.

#### 16. time.body.acceleration.jerk.average.y

"numeric"
Standard gravity units per seconds 'g/s'.
Average derivative (with respect to time) of body acceleration along y-axis.

#### 17. time.body.acceleration.jerk.average.z

"numeric"
Standard gravity units per seconds 'g/s'.
Average derivative (with respect to time) of body acceleration along z-axis.

#### 18. time.body.acceleration.jerk.standard.deviation.x

"numeric"
Standard gravity units per seconds 'g/s'.
Average standard deviation of the derivative (with respect to time) of body acceleration along x-axis.

#### 19. time.body.acceleration.jerk.standard.deviation.y

"numeric"
Standard gravity units per seconds 'g/s'.
Average standard deviation of the derivative (with respect to time) of body acceleration along y-axis.

#### 20. time.body.acceleration.jerk.standard.deviation.z

"numeric"
Standard gravity units per seconds 'g/s'.
Average standard deviation of the derivative (with respect to time) of body acceleration along z-axis.


#### 21. time.body.angular.acceleration.average.x
	
"numeric"
Radians per seconds squared '1/s^2'.
Average angular body acceleration along x-axis.

#### 22. time.body.angular.acceleration.average.y
	
"numeric"
Radians per seconds squared '1/s^2'.
Average angular body acceleration along y-axis.
	
#### 23. time.body.angular.acceleration.average.z
	
"numeric"
Radians per seconds squared '1/s^2'.
Average angular body acceleration along z-axis.

#### 24. time.body.angular.acceleration.standard.deviation.x
	
"numeric"
Radians per seconds squared '1/s^2'.
Average standard deviation of angular body acceleration along x-axis.

#### 25. time.body.angular.acceleration.standard.deviation.y
	
"numeric"
Radians per seconds squared '1/s^2'.
Average standard deviation of angular body acceleration along y-axis.

#### 26. time.body.angular.acceleration.standard.deviation.z
	
"numeric"
Radians per seconds squared '1/s^2'.
Average standard deviation of angular body acceleration along z-axis.

#### 27. time.body.angular.acceleration.jerk.average.x
	
"numeric"
Radians per seconds cube '1/s^3'.
Average derivative of angular body acceleration along x-axis.

#### 28. time.body.angular.acceleration.jerk.average.y
	
"numeric"
Radians per seconds cube '1/s^3'.
Average derivative of angular body acceleration along y-axis.

#### 29. time.body.angular.acceleration.jerk.average.z
	
"numeric"
Radians per seconds cube '1/s^3'.
Average derivative of angular body acceleration along z-axis.

#### 30. time.body.angular.acceleration.jerk.standard.deviation.x
	
"numeric"
Radians per seconds cube '1/s^3'.
Average standard deviation of derivative of angular body acceleration along x-axis.

#### 31. time.body.angular.acceleration.jerk.standard.deviation.y
	
"numeric"
Radians per seconds cube '1/s^3'.
Average standard deviation of derivative of angular body acceleration along y-axis.

#### 32. time.body.angular.acceleration.jerk.standard.deviation.z
	
"numeric"
Radians per seconds cube '1/s^3'.
Average standard deviation of derivative of angular body acceleration along z-axis.


#### 33. time.body.acceleration.magnitude.average

"numeric"
Standard gravity units 'g'.
Average euclidean norm of body acceleration.

#### 34. time.body.acceleration.magnitude.standard.deviation

"numeric"
Standard gravity units 'g'.
Average euclidean norm of standard deviation of body acceleration.

#### 35. time.gravity.acceleration.magnitude.average

"numeric"
Standard gravity units 'g'.
Average euclidean norm of gravity acceleration.

#### 36. time.gravity.acceleration.magnitude.standard.deviation

"numeric"
Standard gravity units 'g'.
Average euclidean norm of standard deviation of gravity acceleration.

#### 37. time.body.acceleration.jerk.magnitude.average

"numeric"
Standard gravity units 'g/s'.
Average euclidean norm of time derivative of body acceleration (jerk).

#### 38. time.body.acceleration.jerk.magnitude.standard.deviation

"numeric"
Standard gravity units 'g/s'.
Average euclidean norm of standard deviation of time derivative of body acceleration.

#### 39. time.body.angular.acceleration.magnitude.average

"numeric"
Radians per seconds squared '1/s^2'.
Average euclidean norm of body angular acceleration.

#### 40. time.body.angular.acceleration.magnitude.standard.deviation

"numeric"
Standard gravity units 'g'.
Average euclidean norm of standard deviation of body angular acceleration.

#### 41. time.body.angular.acceleration.jerk.magnitude.average

"numeric"
Radians per seconds cube '1/s^3'.
Average euclidean norm of time derivative of body angular acceleration.


#### 42. time.body.angular.acceleration.jerk.magnitude.standard.deviation

"numeric"
Radians per seconds cube '1/s^3'.
Average euclidean norm of time standard deviation od derivative of body angular acceleration.


#### 43. frequency.body.acceleration.average.x

Fourier transform of corresponding quantity labelled with "time" (see above)	
	
#### 44. frequency.body.acceleration.average.y

Fourier transform of corresponding quantity labelled with "time" (see above)	
	
#### 45. frequency.body.acceleration.average.z

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 46. frequency.body.acceleration.standard.deviation.x

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 47. frequency.body.acceleration.standard.deviation.y

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 48. frequency.body.acceleration.standard.deviation.z

Fourier transform of corresponding quantity labelled with "time" (see above)	


#### 49. frequency.body.acceleration.jerk.average.x

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 50. frequency.body.acceleration.jerk.average.y

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 51. frequency.body.acceleration.jerk.average.z

Fourier transform of corresponding quantity labelled with "time" (see above)	


#### 52. frequency.body.acceleration.jerk.standard.deviation.x

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 53. frequency.body.acceleration.jerk.standard.deviation.y

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 54. frequency.body.acceleration.jerk.standard.deviation.z

Fourier transform of corresponding quantity labelled with "time" (see above)	


#### 55. frequency.body.angular.acceleration.average.x

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 56. frequency.body.angular.acceleration.average.y

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 57. frequency.body.angular.acceleration.average.z

Fourier transform of corresponding quantity labelled with "time" (see above)	


#### 58. frequency.body.angular.acceleration.standard.deviation.x

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 59. frequency.body.angular.acceleration.standard.deviation.y

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 60. frequency.body.angular.acceleration.standard.deviation.z

Fourier transform of corresponding quantity labelled with "time" (see above)	


#### 61. frequency.body.acceleration.magnitude.average

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 62. frequency.body.acceleration.magnitude.standard.deviation

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 63. frequency.body.body.acceleration.jerk.magnitude.average

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 64. frequency.body.body.acceleration.jerk.magnitude.standard.deviation

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 65. frequency.body.body.angular.acceleration.magnitude.average

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 66. frequency.body.body.angular.acceleration.magnitude.standard.deviation

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 67. frequency.body.body.angular.acceleration.jerk.magnitude.average

Fourier transform of corresponding quantity labelled with "time" (see above)	

#### 68. frequency.body.body.angular.acceleration.jerk.magnitude.standard.deviation

Fourier transform of corresponding quantity labelled with "time" (see above)	

