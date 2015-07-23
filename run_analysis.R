###########################################################
#title: 'Getting and Cleaning Data: Course Project'
#author: "Matthew Fergusson"
#date: "July 22, 2015"
#output: tidy data set
###########################################################

#Remove all objects in [r] environment
  #rm(list = ls(all.names = TRUE))


###########################################
# Set Libraries 
###########################################
library(dplyr)
library(sqldf)

###########################################
# Download data 
###########################################

#file URL
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#Destination file path and file name
fileDest <- "C:/Users/mfergusson/Desktop/MTF Personal/Education - Coursera Data Science Specialization/03 - Getting and Clearing Data/Course Project/getdata_projectfiles_UCI_HAR_Dataset.zip"

#directory for R scripts and other work
  Base_wd = "C:/Users/mfergusson/Desktop/MTF Personal/Education - Coursera Data Science Specialization/03 - Getting and Clearing Data/Course Project"
  setwd(Base_wd)


#download file
download.file(fileUrl, destfile = fileDest)
#unzip all to location
  
  #list all zip files
  file_list <- list.files(pattern = "*zip")
  #unzip all zip files in folder
  lapply(file_list, unzip)
    

###########################################
# Raw Data Locations 
###########################################

#data directories
  #directory for R scripts and other work
  Base_wd #set above
    #setwd(Base_wd)
    #Data Files:
      #getdata_projectfiles_UCI_HAR_Dataset.zip - source data downloaded from "Getting and Cleaning Data Course Project" instructions
      #UCI HAR Dataset - unzipped folder
   
  #folder containing raw files
  data_wd = paste(Base_wd,"/UCI HAR Dataset", sep="")
      #setwd(data_wd)
        #data.frame(dir())
          #1 activity_labels.txt - 6 activity labels
          #2        features.txt - 556 labels
          #3   features_info.txt - 
          #4          README.txt
          #5                test
          #6               train
  
  test_wd = paste(data_wd,"/test", sep="")
      #setwd(test_wd)
        #data.frame(dir())
          #1 Inertial Signals - additional underlying data
          #2 subject_test.txt - vector of numbers
          #3       X_test.txt - large data table without headers
          #4       y_test.txt - vector of numbers
  
  train_wd = paste(data_wd,"/train", sep="")
      #setwd(train_wd)
        #data.frame(dir())
          #1 Inertial Signals - additional underlying data
          #2 subject_test.txt - vector of numbers
          #3       X_test.txt - large data table without headers
          #4       y_test.txt - vector of numbers

###########################################
# Read in Raw Data 
###########################################
  
#data_wd
  setwd(data_wd)
  file_list <- list.files(pattern = "*txt")
  #View(file_list)
    #  1 - activity_labels.txt (READ)
    #  2 - features.txt (READ)
    #  3 - features_info.txt
    #  4 - README.txt
  FeaturesList <- read.table("features.txt")
  ActivityLabels <- read.table("activity_labels.txt")

#test_wd
  setwd(test_wd)
  file_list <- list.files(pattern = "*txt")
  #View(file_list)
    #  1 - subject_test.txt (READ) 
    #  2 - X_test.txt (READ) 
    #  3 - y_test.txt (READ) 
  Test_X <- read.table("X_test.txt")
  Test_y <- read.table("y_test.txt")
  Test_subject <- read.table("subject_test.txt")
      #change column name for later combination with other tables
      colnames(Test_subject) <- c("Subject")
  
#train_wd
  setwd(train_wd)
  file_list <- list.files(pattern = "*txt")
  #View(file_list)
    #  1 - subject_train.txt (READ)
    #  2 - X_train.txt (READ)
    #  3 - y_train.txt (READ)
  Train_X <- read.table("X_train.txt")
  Train_y <- read.table("y_train.txt")
  Train_subject <- read.table("subject_train.txt")
      #change column name for later combination with other tables
      colnames(Train_subject) <- c("Subject")

###########################################
# Profile Raw Data 
###########################################

subject_list = unique(rbind(Train_subject,Test_subject))
Subject_Count = count(unique(rbind(Train_subject,Test_subject)))
count(unique(rbind(Train_subject)))
count(unique(rbind(Test_subject)))
  #n=30 / 21 traing / 9 test
    #this is a marker for the 30 volunteers in the study

unique(rbind(Test_y,Train_y))
  #1-6 
    #corresponds to the 6 activity labels

head(FeaturesList, n=20)
  #561 labels appear to correspond to the columns of X_train.txt and X_test.txt

##############################################
# Merge training and test sets into 1 table
##############################################
  
#create activity tables (link activity labels to the )

  #create field to maintain order after merge
    Train_y2 <- Train_y
      Train_y2$row_id <- 1:nrow(Train_y2)
    Test_y2 <- Test_y
      Test_y2$row_id <- 1:nrow(Test_y2)
  #merge activity data (Train_y/Train_X) with lookup table
    Train_activity <- merge(Train_y2,ActivityLabels,by.x ="V1",by.y ="V1") 
      colnames(Train_activity) <- c("activity_id","row_id", "activity")
    Test_activity <- merge(Test_y2,ActivityLabels,by.x ="V1",by.y ="V1")
      colnames(Test_activity) <- c("activity_id","row_id", "activity")
  #arrange activity tables to be combined with data sets later
    Train_activity <- arrange(Train_activity,row_id)
    Test_activity <- arrange(Test_activity,row_id)

#combine data tables to create 1 table for test 1 table for train
  Train_data <- cbind(Train_subject,Train_activity,Train_X)
      #update row_id to trace back to raw data
      Train_data$row_id <- paste(as.character(Train_data$row_id),"_Train", sep = "")
  Test_data <- cbind(Test_subject,Test_activity,Test_X)
      #update row_id to trace back to raw data
      Test_data$row_id <- paste(as.character(Test_data$row_id),"_Test", sep = "")
#combinetest and train into 1 data set
  Activity_Recognition_Data <- rbind(Train_data,Test_data)
    
    
#add correct headers to the final table

  #change FeaturesList$V2 to character to allow if in the column names
    #added number in front of column name due to duplicate column names
  FeatureList_Vector <-  c(as.character(paste(FeaturesList$V1,FeaturesList$V2,sep = "-")))

  #add desired column names to overall data set  
  colnames(Activity_Recognition_Data) <- c("Subject","activity_id","row_id","activity", FeatureList_Vector)

################################################################
# Extract only measurements on the mean and standard deviation
################################################################

  field_names <- data.frame(names(Activity_Recognition_Data))
  colnames(field_names) <- c("Fields")

  #find fields that are standard deviations ("std()") and means of variables
    # "std\\x28\\x29" --> "std()" // "mean\\x28\\x29" --> "mean()"
    #need one "\" for R understanding and secong "\" for it to pass to the grep command
  field_names2 <- cbind(column_no = grep("*std\\x28\\x29*|*mean\\x28\\x29*",field_names$Fields),filter(field_names,grepl("*std\\x28\\x29*|*mean\\x28\\x29*",field_names$Fields)== TRUE))
  #View(field_names2)
  field_names2$Select_Fields <- paste("Activity_Recognition_Data`",field_names2$Fields,"`", sep = "")
  
  #QC checks
    #write.csv(field_names, file = paste(Base_wd,"/field_names.csv", sep = ""))
    #write.csv(field_names2, file = paste(Base_wd,"/field_names2.csv", sep = ""))

  #create initial table with first 4 fields  
  Activity_Recognition_Data_2 <- select(Activity_Recognition_Data, Subject,activity_id,row_id,activity)

  #ADD mean and std fields
  #for loop to add only needed columns
  for(i in 1:length(field_names[,1]))
      if( nrow(filter(field_names2,field_names2$column_no == i)) == 1) {
        Activity_Recognition_Data_2 <- cbind(Activity_Recognition_Data_2,Activity_Recognition_Data[i])
      }

################################################################
# transform into tidy data set
################################################################
  
  #Goals:
    #1) Each variable forms a column
    #2) Each observation forms a row
    #3) Each type of observational unit forms a table

  #put all values into 1 column for analysis
    #also remove any NAs (there were none)
  Activity_Recognition_Data_3 <- gather(Activity_Recognition_Data_2, MeasurementType, Measurement
                                        , -Subject,-activity_id,-row_id, -activity, na.rm = TRUE)

  #split measurement type ( and then remove column_no)
  Activity_Recognition_Data_4 <- separate(data = Activity_Recognition_Data_3, col = MeasurementType
                                          , into = c("column_no","MeasurementType","Calculation","Axis"))
    #remove column_no (no longer needed to trace back column)
    #remove activity_id (no longer needed since activities exist as full name in this data set)
    #row
  Activity_Recognition_Data_4 <- select(Activity_Recognition_Data_4, -column_no, -activity_id)

  #Spread calculation field to give mean and standard deviation their own columns
  Activity_Recognition_Data_5 <- spread( Activity_Recognition_Data_4, Calculation , Measurement )    
  names(Activity_Recognition_Data_4)

################################################################
# get value averages
################################################################

  #create new fields with averages   
  Activity_Recognition_Data_Avg <-
    Activity_Recognition_Data_5 %>%
    group_by(Subject, activity, MeasurementType, Axis) %>%
    mutate(mean_avg = mean(mean),
           std_avg = mean(std)
    )
  
  names(Activity_Recognition_Data_5)
  
  #QC test --> averages match when repeated in excel
      #test <- Activity_Recognition_Data_Avg[Activity_Recognition_Data_Avg$Subject == 1,]
      #write.csv(test, file = paste(Base_wd,"/test.csv", sep = ""))

################################################################
# remove duplicates and leave only averages
################################################################

  #dedupe averages table to only have newly calculated totals  
  Activity_Recognition_Data_Avg_2 <- Activity_Recognition_Data_Avg %>%
    select( -row_id , -mean , -std ) %>%
    unique
    
  #write table to file for submission
  write.csv(Activity_Recognition_Data_Avg_2, file = paste(Base_wd,"/Activity_Recognition_Data_Avg.txt"
                          , sep = ""), row.names = FALSE)
  
  #code for MD file and html file
  library(knitr)
  setwd(Base_wd)
  knit2html(paste(Base_wd,"/README.Rmd",sep = ""))
  
  knit2html(paste(Base_wd,"/CodeBook.Rmd",sep = ""))