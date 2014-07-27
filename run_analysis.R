#######################################################################
### 1.Merges the training and the test sets to create one data set. ###
#######################################################################

# reading the files that contain the dataset

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", sep = "", na.strings = "NA", header= FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", sep = "", na.strings = "NA", header= FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep = "", na.strings = "NA", header= FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", sep = "", na.strings = "NA", header= FALSE)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", sep = "", na.strings = "NA", header= FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep = "", na.strings = "NA", header= FALSE)

# merging the files to create a flat dataset

trainset <- cbind(X_train,subject_train,y_train)
testset <- cbind(X_test,subject_test,y_test)
dataset <- rbind(trainset, testset)

# delete non necessary sets to reduce memory storage
rm(X_train)
rm(y_train)
rm(subject_train)
rm(y_test)
rm(X_test)
rm(subject_test)
rm(trainset)
rm(testset)


##############################################################################
### 2 Appropriately labels the data set with descriptive variable names ######
##############################################################################

features_names_file <- read.table("./UCI HAR Dataset/features.txt", sep = "", na.strings = "NA", header= FALSE)
features_names <- as.vector(features_names_file[,2])
colnames1 <- append(features_names, "subject")
colnames <- append(colnames1,"activity_label")
colnames(dataset) <- colnames


# delete non necessary sets to reduce memory storage
rm(colnames1)
rm(features_names)
rm(features_names_file)

################################################################################
### 3 Uses descriptive activity names to name the activities in the data set ###
################################################################################

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

# delete non necessary r variables to reduce memory storage
rm(dataset_rows)
rm(i)

############################################################################################
# 4 Extracts only the measurements on the mean and standard deviation for each measurement.#  ###
############################################################################################

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

# delete non necessary r variables to reduce memory storage
rm(number_columns_variables)
rm(mean_string)
rm(sd_string)
rm(remove_colnames)
rm(j)
rm(colnames)

#####################################################################
# 5 Creates a second, independent tidy data set with the average  ###
#   of each variable for each activity and each subject           ###
#####################################################################
library(reshape2)
tidy_colnames <- colnames(tidy_dataset1)
tidy_colnames_variables <-tidy_colnames[1:66]
melt_dataset <- melt(tidy_dataset1, id=c("subject","activity_label"),measure.vars=tidy_colnames_variables)

tidy_dataset2 <- dcast(melt_dataset, subject+activity_label ~ variable , mean)
write.csv(file="tidy_dataset2.txt", x=tidy_dataset2 , row.names=FALSE)
# delete non necessary r variables to reduce memory storage
rm(tidy_colnames)
rm(tidy_colnames_variables)
rm(melt_dataset)

