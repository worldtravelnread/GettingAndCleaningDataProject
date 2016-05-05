# CodeBook.md

## Getting and Cleaning Data Week 4 Project


This file explains the rationale and methodology for the names used in this project. It is to be used in conjunction with the original readme.txt, features_info.txt, and features.txt files.

### Naming Conventions

Even with abbreviations, the variable names in features.txt are long.  
The explanations for the abbreviations in features_info.txt make sense, and the naming conventions result in variable names that are reasonably descriptive. Therefore, the following existing naming conventions have been  retained because they improve readability for the user.

* Mixed case: The use of both lower and upper case improves readability
* t prefix: Denotes time domain signals. From readme.txt, the units are seconds.
* f prefix: Denotes frequency domain signals. From readme.txt, the units are Hz.
* Acc: indicates data from the accelerometer
* Gyro: indicates data from the gyroscope
* Mag: indicates magnitude of the signals
* X, Y, Z: denote the specific axial dimension(s) measured
* -: use of the dash improves readability
* (): use of the parentheses improves readability
* ,: use of the comma improves readability

### Subject Data Sets

Both subject_test.txt and subject_train.txt were loaded into R and then loaded as table data frames for manipulation with dplyr.

```{r}
subjectTest <- read.table("subject_test.txt")
uniqSubjectTest <- unique(subjectTest)
```

This results in a data frame with 2,947 observations and 1 variable.
There were 9 unique participants in test.

```{r}
subjectTrain <- read.table("subject_train.txt")
uniqSubjectTrain <- unique(subjectTrain)
```

This results in a data frame with 7,352 observations and 1 variable.
There were 21 unique participants in train.

```{r}
subjectTestTblDf <- tbl_df(subjectTest)
subjectTrainTblDf <- tbl_df(subjectTrain)
```

Both data frames were mutated to add a second column indicating from which set the data originated: Test or Train.


```{r]
subjectTestTblDf <- mutate(subjectTestTblDf, set = "Test")
subjectTrainTblDf <- mutate(subjectTrainTblDf, set = "Train")
```

Variable names were added to each data frame: subject and set.

```{r}
names(subjectTestTblDf) <- c("subject", "set")
names(subjectTrainTblDf) <- c("subject", "set")
```

This results in two variables in each data frame.

* This helps meet item 4 of the R script requirements to label the data set with descriptive variable names. 

### Features Data Set

Upon examination of the features.txt file, the following duplications in variable names were observed:

* Variables 303 through 316 are repeated verbatim as
        +       Variables 317 through 330
        +       Variables 331 through 344

* Variables 382 through 395 are repeated verbatim as
        +       Variables 396 through 409
        +       Variables 410 through 423

* Variables 461 through 474 are repeated verbatim as
        +       Variables 475 through 488
        +       Variables 489 through 502

To make the variable names unique, the following steps were taken:

1. features.txt was loaded into R and then loaded as a table data frame for manipulation with dplyr.

```{r}
features <- read.table("features.txt")
featuresTblDf <- tbl_df(features)
```

This results in a data frame with 561 observations and 2 variables.
The two variables are an index and the feature names.

2. A third column was added that pastes the index number and the feature name.
[Note: My personal preference is to used mixed case in variable names to 
improve readability.]

```{r}
featuresTblDf <- mutate(featuresTblDf, indexFeatureName = paste(V1, V2, 
                                                                 sep = "-"))
```

A character vector was created with the new feature names so that they can be assigned as names to the X_test.txt and X_train.txt data sets.

```{r}
featuresVect <- as.vector(featuresTblDf$indexFeatureName)
```

A vector was created with the features that either calculate a mean or a standard deviation. This will help with item 2 of the R script requirements.

```{r}
meanStd <- grep("mean|std", 
              featuresTblDf$indexFeatureName,
              value = TRUE)
```

This results in a vector of length 79.

  
### X- Data Sets

Both X_test.txt and X_train.txt were loaded into R and then loaded as table data frames for manipulation with dplyr.
  
```{r}
Xtest <- read.table("X_test.txt")
XtestTblDf <- tbl_df(Xtest)
```

This results in a data frame with 2,947 observations and 561 variables.

```{r}
Xtrain <- read.table("X_train.txt")
XtrainTblDf <- tbl_df(Xtrain)
```

This results in a data frame with 7,352 observations and 561 variables.

Next, the featuresVect vector is assigned as the variable names for both  XtestTblDf and XtrainTblDf.

```{r}
names(XtestTblDf) <- featuresVect
names(XtrainTblDf) <- featuresVect
```

* This helps meet item 4 of the R script requirements to label the data set with descriptive variable names. 

### Activitiy Labels Data Set

The activity_labels.txt data set was loaded into R then loaded as a table data  frame for manipulation with dplyr.

```{r}
activities <- read.table("activity_labels.txt")
activitiesTblDf <- tbl_df(activities)
```

This results in a data frame with 6 observations and 2 variables.
The variables are an index and the activity labels (i.e., names).

Next, names were assigned to the variables.

```{r}
names(activitiesTblDf) <- c("activityID", "activity")
```

A third column was added with the activity labels in lower case. 


```{r}
activitiesTblDf <- mutate(activitiesTblDf, newActivityLabel = 
                                  tolower(activitiesTblDf$activity))
```

The original activity column (with names in upper case) was removed from the data frame.

```{r}
activitiesTblDf <- select(activitiesTblDf, activityID, newActivityLabel)
```


### Y- Data Sets

Read the y_test.txt and y_train.txt data sets into R and load as table data frames for manipulation in dplyr.

```{r}
ytest <- read.table("y_test.txt")
ytestTblDf <- tbl_df(ytest)
```
This results in a data frame with 2,947 observations and 1 variable.
The variable is the activity ID performed by the participant. 

```{r}
ytrain <- read.table("y_train.txt")
ytrainTblDf <- tbl_df(ytrain)
```

This results in a data frame with 7,352 observations and 1 variable.
The variable is the activity ID performed by the participant.

The name "activityID" is added to each data frame.
[Note: My personal preference is to used mixed case in variable names to 
improve readability.]

```{r}
names(ytestTblDf) <- c("activityID")
names(ytrainTblDf) <- c("activityID")
```


### Combining the Data Sets

All the individual data sets have been loaded in R and loaded as table data  frames. This section describes how all the sets were combined into one.

#### Y- Data Frames and Activity Data Frame

The activity labels (i.e., names) were added to the y- data frames.

```{r}
ytestTblDf <- join(ytestTblDf, activitiesTblDf, by = "activityID")
ytrainTblDf <- join(ytrainTblDf, activitiesTblDf, by = "activityID")
```

ytestTblDf is a data frame with 2,947 observations and 2 variables.

ytrainTblDf is a data frame with 7,352 observations and 2 variables.

* This meets item 3 in the R script requirements to use descriptive activity names to name the activities in the data set.

The merge function is not used because the order of the observations (i.e., rows) is not preserved.

#### Subject- Data Frames and Y- Data Frames

The subject test and y- test data frames are combined.

```{r}
subjectYtestTblDf <- bind_cols(subjectTestTblDf, ytestTblDf)
```

This results in a data frame with 2,947 observations and 4 variables.

The subject train and y- train data frames are combined.

```{r}
subjectYtrainTblDf <- bind_cols(subjectTrainTblDf, ytrainTblDf)
```

This results in a data frame with 7,352 observations and 4 variables.


#### Add the X- Data Frames

The x- test data frame is added.

```{r}
testAllTblDf <- bind_cols(subjectYtestTblDf, XtestTblDf)
```

This results in a data frame with 2,947 observations and 565 variables.

The x- train data frame is added.

```{r}
trainAllTblDf <- bind_cols(subjectYtrainTblDf, XtrainTblDf)
```

This results in a data frame with 7,352 observations and 565 variables.


#### Combine the Test and Train Data Frames

The test and train data frames are combined.

```{r}
consolidated <- bind_rows(testAllTblDf, trainAllTblDf)
```

This results in a data frame with 10,299 observations and 565 variables.

* This is the combined data set for item 1 of the R script requirements.
* The data set uses descriptive activity names, which meets item 2.
* The data set has descriptive variable names, which meets item 3.

## Extract Features with the Mean or Standard Deviation

The features with the Mean or Standard Deviation were extracted from the consolidated data frame.

```{r}
meanStdTblDf <- select(consolidated, 1:4, contains("mean"), contains("std"))
```

This results in a data frame with 10,299 observations and 90 variables.

The first 4 variables are: subject, set, activityID, and newActivityLabel. 
This leaves 86 variables out of the original 561 features. When the meanStd vector was created earlier, 

```{r}
meanStd <- grep("mean|std", 
              featuresTblDf$indexFeatureName,
              value = TRUE)
```

the resulting vector was length 79. Upon closer examination of meanStdTblDf, there are 7 variables that
are not a feature that calculates the mean, but have a mean calculation included, such as 555-angle(tBodyAccMean,gravity) or 556-angle(tBodyAccJerkMean) or 555-angle(tBodyAccMean,gravity).

The select statement was modified to exclude these types of features and exclude the set and activityID variables:

```{r}
meanStdTblDf <- select(consolidated, 1, 4, contains("mean"), contains("std"), -contains("mean)"),
                       -contains("mean,"))
```

This results in a data frame with 10,299 observations and 81 variables.

* This meets item 2 of the R script requirements.


## Create a Second, Tidy Independent Data Set with the Average of Each Variable for Each Activity and Each Subject

Convert the subject variable's class from integer to  character so it won't get calculated as a mean:

```{r}
meanStdTblDf <- mutate(meanStdTblDf, subject = 
                         as.character(subject))
```

Calculate the means of all the variables by activity:

```{r}
activityMeans <- meanStdTblDf %>%
  group_by(newActivityLabel) %>%
  summarize_each(funs(mean))
```

You will get warnings because the subject variable is now a character type so the mean cannot be calculated on the subjects, but that is okay.

This results in a data frame with 6 observations and 81 variables.

Calculate the means of all the variables by subject:

```{r}
subjectMeans <- meanStdTblDf %>%
  group_by(subject) %>% 
  summarize_each(funs(mean))
```

You will get warnings because means cannot be calculated on the newActivityLabel variable, but that is okay.

This results in a data frame with 30 observations and 81 variables. 

Combine the means of all variables by activity and the means of all variables by subject:

```{r}
tidyData <- bind_rows(activityMeans, subjectMeans)
```

This results in a data frame with 36 observations and 81 variables.

Write the tidyData into a .txt file:

```{r}
write.table(tidyData, "tidyData.txt", row.names = FALSE)
```

* This meets item 5 of the R script requirements.

Write the tidyData into a .csv file:

```{r}
write.csv(tidyData, "tidyData.csv")
```











