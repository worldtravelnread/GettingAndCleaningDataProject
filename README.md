# README.md

## Getting and Cleaning Data Week 4 Project

This file gives an overview of the steps performed to complete the assigned project. 

The script file, run_analysis.R, has detailed comments describing what the code does.

The CodeBook.md file contains supplemental information to the original readme.txt, features_info.txt, and features.txt files on naming conventions and notes about the data set, including dimensions. It contains detailed descriptions, including the code, for how the data sets were prepared and transformed for the assignment.

The files used in this project are listed below and are from

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly  Support Vector Machine. International Workshop of Ambient Assisted Living  (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

* subject_test.txt
* subject_train.txt
* features.txt
* X_test.txt.zip
* X_train.txt.zip
* activity_labels.txt
* y_test.txt
* y_train.txt

Details on the study are in the readme.txt file. 

A summary of the data files is as follows:

The experiments were conducted with 30 participants who performed 6 activities while wearing a smartphone on the waist. The participant data was randomly partitioned into two sets, where 70% (21 of 30) of the participants were  selected for generating the training data, 30% (9 of 30) for the test data.

* subject_test.txt contains the IDs of each participant in the test set. There are 2,947 observations in the set, with 9 unique IDs.

* subject_train.txt contains the IDs of each participant in the training set. There are 7,352 observations in the set, with 21 unique IDs.

Tri-axial measurements were taken from the phones' accelerometers and  gyroscopes, and 561 features were generated for each observation. 

* features.txt contains the index and names of each of the generated features. There are 561 observations in the set, and there were duplicates (see CodeBook.md for details). 

* X_test.txt contains the feature data generated for each observation in the  test set. There are 2,947 observations and 561 variables in the set.

* X_train.txt contains the feature data generated for each observation in the training set. There are 7,352 observations and 561 variables in the set.

* activity_labels.txt contains the activity IDs and names of the 6 activities performed during the experiment. There are 6 observations and 2 variables in the set.

* y_test.txt contains the activity IDs for each activity that was performed.  There are 2,947 observations and 2 variables in the set.

* y_train.txt contains the activity IDs for each activity that was performed. There are 7,352 observations and 2 variables in the set.

1. All the files were read into R and loaded as table data frames for manipulation with dplyr.

2. Both of the subject- data sets were transformed by adding a column to indicate which set the participant belonged to: Test or Train. Then variable names were added to each data set.

3. As mentioned earlier, features.txt had duplicative feature names. This data set was transformed by adding a column that pasted the ID with the feature name to create unique values. A character vector was created from the new column, and the variable names for the X- data sets were assigned using the vector.

* This meets  item 4 of the R script requirements.

4. Another vector was created with features that calculated the mean or standard deviation. This will help with item 2 of the R script requirements. The resulting vector has a length of 79.


5. The y- data sets were joined with the activity_labels data set so that each observation was labeled with the activity performed. 

* This meets item 3 of the R script requirements.

6. The subject- and y- data frames were combined into new data sets. 

7. The X- data frames were added to the newly combined sets.

8. The test- and train- data frames were combined into one consolidated data set with 10,299 observations and 565 variables.

* This meets item 1 of the R script requirements.

9. The features with the mean and standard deviation 
measurements were extracted from the consolidated data frame, along with the subject and newActivityLevel data. The resulting data frame has 10,299 observations and 81 variables.

* This meets item 2 of the R script requirements.

10. Convert the subject variable's class from integer to character so it won't get calculated as a mean.

11. Create a data frame that calculates the means of all variables by activity. The resulting data frame has 6 observations and 81 variables.

12. Create a data frame that calculates the means of all variables by subject. The resulting data frame has 30 observations and 81 variables.

13. Combine the data frames with the means by activity and the means by subject into one tidy data set. The resulting data frame has 36 observations and 81 variables.

14. Write the tidy data set to a .txt file.

* This meets item 5 of the R script requirements.

15. Write the tidy data set to a .csv file.












