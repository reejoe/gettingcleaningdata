# run_analysis.R - source code

# set the working dir where the data is present
setwd("~/R/courseproj")
pathData            <- file.path("./data","UCI HAR Dataset")

#read the activity, subject and feature data from files into variables
TestData            <- read.table(file.path(pathData,"test","Y_test.txt"),header = FALSE)
trainData           <- read.table(file.path(pathData,"train","Y_train.txt"), header = FALSE)
subjTestData        <- read.table(file.path(pathData,"test","subject_test.txt"), header = FALSE)
subjTrainData       <- read.table(file.path(pathData,"train","subject_train.txt"), header = FALSE)
featTestData        <- read.table(file.path(pathData,"test","X_test.txt"),header = FALSE)
featTrainData       <- read.table(file.path(pathData,"train","X_train.txt"), header = FALSE)

# Merge the training and test data into one
subjData            <- rbind(subjTrainData,subjTestData)
actData             <- rbind(trainData,TestData)
featureData         <- rbind(featTrainData,featTestData)

# set the names to variables
names(subjData)     <- c("Subject")
names(actData)      <- c("Activity")
featureDataName     <- read.table(file.path(pathData,"features.txt"),head=FALSE)
names(featureData)  <- featureDataName$V2

# Merge columns to produce data frame
combineData         <- cbind(subjData,actData)
processData         <- cbind(featureData,combineData)

#subset fetures by measurement on mean and SD
subFeatureNameData  <- featureDataName$V2[grep("mean\\(\\)|std\\(\\)", featureDataName$V2)]
selectedNames       <-c(as.character(subFeatureNameData), "Subject", "Activity" )

# Produce the data based on selected names
processData         <-subset(processData,select=selectedNames)

# Assign labels
names(processData)  <-gsub("^t", "Time", names(processData))
names(processData)  <-gsub("^f", "Frequency", names(processData))
names(processData)  <-gsub("Acc", "Accelerometer", names(processData))
names(processData)  <-gsub("Gyro", "Gyroscope", names(processData))
names(processData)  <-gsub("Mag", "Magnitude", names(processData))
names(processData)  <-gsub("BodyBody", "Body", names(processData))

#produce output tiny data set
library(plyr)
Data2               <-aggregate(. ~subject + Activity, processData, mean)
Data2               <-Data2[order(Data2$subject,Data2$Activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)