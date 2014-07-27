Code Book
=================

Study Design
=================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 
Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 
we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 
The experiments have been video-recorded to label the data manually. 
The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected 
for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then 
sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). 
The sensor acceleration signal, which has gravitational and body motion components, 
was separated using a Butterworth low-pass filter into body acceleration and gravity. 
The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz 
cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 


For each record it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. 
   Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

Work  Performed
=================

Firstly, data contained in files "X_train.txt", "y_train.txt", "subject_train.txt", "y_test.txt", "X_test.txt" and "subject_test.txt" 
was merged in a flat data table that contained 10299 rows of 563 columns.
561 were the variables that are listed in file features.txt. The 562th variable was the subject (person id) that performed the activity.
The 563th column contained the label of the initial dataset, which is the id of activity performed during the specific measurement.

Rcode:

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", sep = "", na.strings = "NA", header= FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", sep = "", na.strings = "NA", header= FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep = "", na.strings = "NA", header= FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", sep = "", na.strings = "NA", header= FALSE)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", sep = "", na.strings = "NA", header= FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep = "", na.strings = "NA", header= FALSE)

trainset <- cbind(X_train,subject_train,y_train)
testset <- cbind(X_test,subject_test,y_test)
dataset <- rbind(trainset, testset)

Secondly, the data variables were labeled with the variable names that are presented in the files features.txt. 
The variable with the subjects id was given the name "subject" and the label column was given the name "activity_label".

R code:

features_names_file <- read.table("./UCI HAR Dataset/features.txt", sep = "", na.strings = "NA", header= FALSE)
features_names <- as.vector(features_names_file[,2])
colnames1 <- append(features_names, "subject")
colnames <- append(colnames1,"activity_label")
colnames(dataset) <- colnames

Then, we changed the activities ids in the dataset with the relative descriptive activity names that were mapped in the file "activity_labels.txt".

R code

dataset_rows <- nrow(dataset)
for (i in 1:dataset_rows)
{
    if(dataset[i,563]==1)
    {
        dataset[i,563] <- "WALKING"
    }
    if(dataset[i,563]==2)
    {
        dataset[i,563] <- "WALKING_UPSTAIRS"
    }
    if(dataset[i,563]==3)
    {
        dataset[i,563] <- "WALKING_DOWNSTAIRS"
    }
    if(dataset[i,563]==4)
    {
        dataset[i,563] <- "SITTING"
    }
    if(dataset[i,563]==5)
    {
        dataset[i,563] <- "STANDING"
    }
    if(dataset[i,563]==6)
    {
        dataset[i,563] <- "LAYING"
    }
}

Subsequently, we extracted only the measurements on the mean and standard deviation for each measurement.
The dataset created was written in a file named tidy_dataset1.txt

R code:

number_columns_variables <- ncol(dataset) -2
mean_string <- "mean()"
sd_string <- "std()"

remove_colnames <- character()

for (j in 1:number_columns_variables)
{
    if(!(grepl(mean_string,colnames[j], fixed=TRUE) || grepl(sd_string,colnames[j],fixed=TRUE)))
    {
      remove_colnames <- append(remove_colnames, colnames[j])
    }
}
 
tidy_dataset1 <- dataset[,-which(names(dataset) %in% remove_colnames)]
write.csv(file="tidy_dataset1.txt", x=tidy_dataset1 , row.names=FALSE)

Finally, we created the final independent tidy data set with the average of each variable 
of the dataset created before, for each activity and each subject.

R code:

library(reshape2)
tidy_colnames <- colnames(tidy_dataset1)
tidy_colnames_variables <-tidy_colnames[1:66]
melt_dataset <- melt(tidy_dataset1, id=c("subject","activity_label"),measure.vars=tidy_colnames_variables)

tidy_dataset2 <- dcast(melt_dataset, subject+activity_label ~ variable , mean)
write.csv(file="tidy_dataset2.txt", x=tidy_dataset2 , row.names=FALSE)
	  
Code Book
=================

Final dataset contains 68 variables and 180 rows. It contains the aggregated values of the average of every mean and every standard deviation calculation of each measurement for each subject and each activity.

More specifically, the dataset contains the following variables:

1.  subject: 
	Type = Numeric, Integer
	Possible values: 1 to 30

2.	activity_label:
	Type = nominal 
	Possible values: "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"
	
3.  tBodyAcc-mean()-X
	Type = Numeric, Float
    Range of Values: -1 to 1 

4.  tBodyAcc-mean()-Y
	Type = Numeric, Float
    Range of Values: -1 to 1 	

5.  tBodyAcc-mean()-Z
	Type = Numeric, Float
    Range of Values: -1 to 1 	

6.  tBodyAcc-std()-X
	Type = Numeric, Float
    Range of Values: -1 to 1 	

7.  tBodyAcc-std()-Y
	Type = Numeric, Float
    Range of Values: -1 to 1 	

8.  tBodyAcc-std()-Z
	Type = Numeric, Float
    Range of Values: -1 to 1 	

9.  tGravityAcc-mean()-X
	Type = Numeric, Float
    Range of Values: -1 to 1 
	
10. tGravityAcc-mean()-Y
	Type = Numeric, Float
    Range of Values: -1 to 1 	

11. tGravityAcc-mean()-Z
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
12. tGravityAcc-std()-X
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
13. tGravityAcc-std()-Y
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
14. tGravityAcc-std()-Z
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
15. tBodyAccJerk-mean()-X
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
16. tBodyAccJerk-mean()-Y
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
17. tBodyAccJerk-mean()-Z
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
18. tBodyAccJerk-std()-X
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
19. tBodyAccJerk-std()-Y
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
20. tBodyAccJerk-std()-Z
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
21. tBodyGyro-mean()-X
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
22. tBodyGyro-mean()-Y
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
23. tBodyGyro-mean()-Z
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
24. tBodyGyro-std()-X
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
25. tBodyGyro-std()-Y
	Type = Numeric, Float
    Range of Values: -1 to 1 	
26. tBodyGyro-std()-Z
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
27. tBodyGyroJerk-mean()-X
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
28. tBodyGyroJerk-mean()-Y
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
29. tBodyGyroJerk-mean()-Z
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
30. tBodyGyroJerk-std()-X
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
31. tBodyGyroJerk-std()-Y
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
32. tBodyGyroJerk-std()-Z
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
33. tBodyAccMag-mean()
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
34. tBodyAccMag-std()
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
35. tGravityAccMag-mean()
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
36. tGravityAccMag-std()
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
37. tBodyAccJerkMag-mean()
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
38. tBodyAccJerkMag-std()
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
39. tBodyGyroMag-mean()
	Type = Numeric, Float
    Range of Values: -1 to 1 	
		
40. tBodyGyroMag-std()
	Type = Numeric, Float
    Range of Values: -1 to 1 
	
41. tBodyGyroJerkMag-mean()
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
42. tBodyGyroJerkMag-std()
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
43. fBodyAcc-mean()-X
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
44. fBodyAcc-mean()-Y
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
45. fBodyAcc-mean()-Z
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
46. fBodyAcc-std()-X
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
47. fBodyAcc-std()-Y
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
48. fBodyAcc-std()-Z
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
49. fBodyAccJerk-mean()-X
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
50. fBodyAccJerk-mean()-Y
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
51. fBodyAccJerk-mean()-Z
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
52. fBodyAccJerk-std()-X
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
53. fBodyAccJerk-std()-Y
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
54. fBodyAccJerk-std()-Z
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
55. fBodyGyro-mean()-X
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
56. fBodyGyro-mean()-Y
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
57. fBodyGyro-mean()-Z
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
58. fBodyGyro-std()-X
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
59. fBodyGyro-std()-Y
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
60. fBodyGyro-std()-Z
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
61. fBodyAccMag-mean()
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
62. fBodyAccMag-std()
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
63. fBodyBodyAccJerkMag-mean()
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
64. fBodyBodyAccJerkMag-std()
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
65. fBodyBodyGyroMag-mean()
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
66. fBodyBodyGyroMag-std()
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
67. fBodyBodyGyroJerkMag-mean()
	Type = Numeric, Float
    Range of Values: -1 to 1 	
	
68. fBodyBodyGyroJerkMag-std()
	Type = Numeric, Float
    Range of Values: -1 to 1 	
