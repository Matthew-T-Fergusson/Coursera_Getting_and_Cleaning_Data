---
title: 'CodeBook: Getting and Cleaning Data Course Project'
author: "Matthew Fergusson"
date: "July 23, 2015"
output: html_document
---



#Introduction

This Codebook describes the fields in both the final table exported to a text file ("Activity_Recognition_Data_Avg_2" saved as "Activity_Recognition_Data_Avg.csv") and the table that is was compiled from ("Activity_Recognition_Data_5").

#Raw Data Set Information:

source:<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#>

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

#Attribute Information:

source:<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#>

For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

#Activity_Recognition_Data_5

Below are descriptions of the columns ("Subject", "row_id", "activity", "MeasurementType", "Axis", "mean", and "std") found in the data set produced prior to taking averages. 

* Subject
    * Description: Identifyer differentiating the 30 volunteer subjects that were used to collect the data.
    * Data Type: integer
    * Additional Details:
        * field is an integer with values from 1 - 30
* row_id
    * Description: this field was derived to give the initial position and data set that a record came from initially 
        * Data Type: character 
        * Additional Details:
            * For example a value of "1_Test" in the "row_id" field would correspond to the 1st record of data from the "X_test.txt", "y_test.txt", and "subject_test.txt" tables which would all be lined up in the "Activity_Recognition_Data_5" table.
* activity
    * Description: This field describes the actions the subjects were performing while they were being recorded to produce the raw data set.
    * Data Type: factor
    * Additional Details:
        * this column has 6 values as follows corresponding to what is found in "activity_labels.txt":
            1) WALKING
            2) WALKING_UPSTAIRS
            3) WALKING_DOWNSTAIRS
            4) SITTING
            5) STANDING
            6) LAYING
* MeasurementType
    * Description: These are the base measurement features that are derived from the list in features_info.txt.
    * Data Type: character
    * Additional Details: (Source: *features_info.txt*)
        * The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 
        * Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 
        * Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 
        * These signals were used to estimate variables of the feature vector for each pattern:  
              *'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.
              * tBodyAcc-XYZ
              * tGravityAcc-XYZ
              * tBodyAccJerk-XYZ
              * tBodyGyro-XYZ
              * tBodyGyroJerk-XYZ
              * tBodyAccMag
              * tGravityAccMag
              * tBodyAccJerkMag
              * tBodyGyroMag
              * tBodyGyroJerkMag
              * fBodyAcc-XYZ
              * fBodyAccJerk-XYZ
              * fBodyGyro-XYZ
              * fBodyAccMag
              * fBodyAccJerkMag
              * fBodyGyroMag
              * fBodyGyroJerkMag
          * The set of variables that were estimated from these signals are: 
              * mean(): Mean value
              * std(): Standard deviation
* Axis
    * Description: The measurements were taken from spacial movement information and were vectored on an X, Y, and Z axis.   
    * Data Type: character
    * Additional Details: 
        * This column was originally part of the MeasurementType field but was broken out to give more granular access to manipulating thdata for analysis
* mean           
    * Description: the mean of the measurements indicated by the combination of subject, activity, MeasurementType, and Axis.
    * Data Type: numeric
    * Additional Details:
        * This value was originally from one of the columns in the X_test.txt and X_train.txt files, but has been transformed into 1 column from those columns with a name containing "mean()" as specified in features.txt
* std
    * Description: the standard deviation of the measurements indicated by the combination of subject, activity, MeasurementType, and Axis.
    * Data Type: numeric
    * Additional Details:
        * This value was originally from one of the columns in the X_test.txt and X_train.txt files, but has been transformed into 1 column from those columns with a name containing "std()" as specified in features.txt

#Activity_Recognition_Data_Avg_2
*Fields in addition to those in Activity_Recognition_Data_5*

Below are descriptions of the additional columns ("mean_avg" and "std_avg") found in the final data set that was exported and submitted for the Getting and Cleaning Data Project.

* Columns Dropped - columns dropped to aggregate mean_avg and std_avg 
    * *row_id*
    * *mean*
    * *std*
* mean_avg
    * Description: This field is the average of "mean" column records from the "Activity_Recognition_Data_5" table where subject, activity, measurement type, and Axis are held constant.
    * Data Type: numeric
* std_avg
    * Description: This field is the average of "std" column records from the "Activity_Recognition_Data_5" table where subject, activity, measurement type, and Axis are held constant.
    * Data Type: numeric

