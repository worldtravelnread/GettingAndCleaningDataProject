## run_analysis.R

## Getting and Cleaning Data Week 4 Project

## library(plyr) 
## library(dplyr)

## read subject files into R
subjectTest <- read.table("subject_test.txt")
uniqSubjectTest <- unique(subjectTest)
## there were 9 test participants
subjectTrain <- read.table("subject_train.txt")
uniqSubjectTrain <- unique(subjectTrain)
## there were 21 train participants

## load the subject data sets into table data frames
subjectTestTblDf <- tbl_df(subjectTest)
subjectTrainTblDf <- tbl_df(subjectTrain)

## add a column to indicate that the subject was in 
## train set or test set, as appropriate
subjectTestTblDf <- mutate(subjectTestTblDf, set = "Test")
subjectTrainTblDf <- mutate(subjectTrainTblDf, set = "Train")

## add names to the subject data frames
names(subjectTestTblDf) <- c("subject", "set")
names(subjectTrainTblDf) <- c("subject", "set")

## This helps meet item 4 of the R script requirements 
## to label the data set with descriptive variable names. 


## read features file into R
features <- read.table("features.txt")
## load the features data set into table data frames
featuresTblDf <- tbl_df(features)
## has 2 columns, 1st is an index, 2nd is the feature name

## Because three sets of variable names are repeated two times each (see 
## CodeBook.md for details), a third column will be added to featuresTblDf 
## that pastes the index number and feature name so that the variable names
## will be unique.
featuresTblDf <- mutate(featuresTblDf, indexFeatureName = paste(V1, V2, 
                                                        sep = "-"))


## create a character vector of the 3rd column of the
## features table data frame
featuresVect <- as.vector(featuresTblDf$indexFeatureName)

## isolate the features that calculate the mean or
## standard deviation. This will help with item 2 of the
## R script requirements.
meanStd <- grep("mean|std", 
              featuresTblDf$indexFeatureName,
              value = TRUE)
## This returns a vector with 79 items.

## unzip the X- files
unzip("X_test.txt.zip")
unzip("X_train.txt.zip")

## read the X test file into R
Xtest <- read.table("X_test.txt")
## load the X test data set into table data frames
XtestTblDf <- tbl_df(Xtest)

## read the X train file into R
Xtrain <- read.table("X_train.txt")
## load the X test data set into table data frames
XtrainTblDf <- tbl_df(Xtrain)

## assign the features vector as the variable names in 
## XtestTblDf
names(XtestTblDf) <- featuresVect

## assign the features vector as the variable names in 
## XtrainTblDf
names(XtrainTblDf) <- featuresVect

## This helps meet item 4 of the R script requirements 
## to label the data set with descriptive variable names.  


## read the activity labels file into R
activities <- read.table("activity_labels.txt")
## load the activities data set into a table data frame
activitiesTblDf <- tbl_df(activities)
## there are 2 columns, 1st for the index, 2nd for the 
## activity

## name the columns in activitiesTblDf
names(activitiesTblDf) <- c("activityID", "activity")

## add a column with the activity labels in lower case
activitiesTblDf <- mutate(activitiesTblDf, newActivityLabel = 
                                  tolower(activitiesTblDf$activity))

## use only the activityID and newActivityLabel columns in activitiesTblDf
activitiesTblDf <- select(activitiesTblDf, activityID, newActivityLabel)


## read the y test file into R
ytest <- read.table("y_test.txt")
## load the y test data set into table data frames
ytestTblDf <- tbl_df(ytest)

## read the y train file into R
ytrain <- read.table("y_train.txt")
## load the y train data set into table data frames
ytrainTblDf <- tbl_df(ytrain)

## name the column in ytestTblDf
names(ytestTblDf) <- c("activityID")

## name the column in ytrainTblDf
names(ytrainTblDf) <- c("activityID")

## This helps meet item 4 of the R script requirements 
## to label the data set with descriptive variable names.  


## add the activity names to ytestTblDf
ytestTblDf <- join(ytestTblDf, activitiesTblDf, by = "activityID")

## add the activity names to ytrainTblDf
ytrainTblDf <- join(ytrainTblDf, activitiesTblDf, by = "activityID")

## This meets item 3  in the R script requirements 
## to use descriptive activity names to name
## the activities in the data set.

## combine the subject test and y test data frames
subjectYtestTblDf <- bind_cols(subjectTestTblDf, ytestTblDf)

## combine the subject train and y train data frames
subjectYtrainTblDf <- bind_cols(subjectTrainTblDf, ytrainTblDf)

## combine the subjectYtestTblDf and the XtestTblDf
## data frames
testAllTblDf <- bind_cols(subjectYtestTblDf, XtestTblDf)
dim(testAllTblDf)
## [1] 2947  565

## combine the subjectYtrainTblDf and the XtrainTblDf
## data frames
trainAllTblDf <- bind_cols(subjectYtrainTblDf, XtrainTblDf)
dim(trainAllTblDf)
## [1] 7352  565

## combine the testAllTblDf and trainAllTblDf data 
## frames
consolidated <- bind_rows(testAllTblDf, trainAllTblDf)
dim(consolidated)
## [1] 10299   565

## This is the combined data set for item 1 of the 
## R script requirements.


## create a data frame with the features that calculate 
## mean or standard deviation
meanStdTblDf <- select(consolidated, 1:4, contains("mean"), 
                       contains("std"))

## data frame includes features where a mean is part of the 
## feature but is not the calculation of the feature, for
## example 555-angle(tBodyAccMean,gravity) or
## 556-angle(tBodyAccJerkMean) or 555-angle(tBodyAccMean,gravity).

## Delete these features from the data frame

meanStdTblDf <- select(consolidated, 1, 4, contains("mean"), 
                       contains("std"), -contains("mean)"),
                       -contains("mean,"))

## This meets item 2 of the R script requirements.


## Convert the subject variable's class from integer to 
## character so it won't get calculated as a mean

meanStdTblDf <- mutate(meanStdTblDf, subject = 
                         as.character(subject))

## calculate the means of all the variables by activity
activityMeans <- meanStdTblDf %>%
  group_by(newActivityLabel) %>%
  summarize_each(funs(mean))

## You will get warnings because the subject variable is now
## a character type so the mean cannot be calculated on the subjects, but 
## that is okay.


## calculate the means of all the variables by subject
subjectMeans <- meanStdTblDf %>%
  group_by(subject) %>% 
  summarize_each(funs(mean))

## You will get warnings because means cannot be calculated
## on the newActivityLabel variable, but that is okay.

## combine the means of all variables by activity and
## the means of all variables by subject
tidyData <- bind_rows(activityMeans, subjectMeans)

## write the tidyData out to a .txt file
write.table(tidyData, "tidyData.txt", row.names = FALSE)

## write the tidyData out to a .csv file
write.csv(tidyData, "tidyData.csv")

## I misinterpreted the last item and created a data set with the average for
## each variable for each subject, and the average of each variable for each
## activity.

## this code creates a data set with the average for each variable for each 
## activity and subject.

allMeans <- meanStdTblDf %>%
        group_by(newActivityLabel, subject) %>%
        summarize_each(funs(mean))

## write the allMeans data frame to a .txt file
write.table(allMeans, "allMeans.txt", row.names = FALSE)

## This meets item 5 of the R script requirements.

## write the tidyData out to a .csv file
write.csv(allMeans, "allMeans.csv")
















