# Download and extract data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "data.zip", quiet = TRUE)
    unzip("data.zip")
file.rename("UCI HAR Dataset", "data")


# Load datasets containing feature names and activity labels.
# Extract the relevant column vectors from the data frame.
# The labels and column names are common to both test and training datasets.
features <- read.table("data/features.txt", colClasses = "character")
features <- features$V2
labels <- read.table("data/activity_labels.txt", colClasses = "character")
labels <- gsub("_", ".", tolower(labels$V2))


# Load and create the test dataset
testX <- read.table("data/test/X_test.txt")
names(testX) <- features
testY <- read.table("data/test/y_test.txt")
testY.f <- factor(testY$V1, labels = labels)
testX$activity <- testY.f
subject <- read.table("data/test/subject_test.txt")$V1
testX$subject <- subject

# Load and create the training dataset
trainX <- read.table("data/train/X_train.txt")
names(trainX) <- features
trainY <- read.table("data/train/y_train.txt")
trainY.f <- factor(trainY$V1, labels = labels)
trainX$activity <- trainY.f
subject <- read.table("data/train/subject_train.txt")$V1
trainX$subject <- subject


# Use rbind to merge the datasets because both have identical columns.
data <- rbind(trainX, testX)

# Convert this
library(dplyr)
data <- tbl_df(data) 


# Extract columns which contain mean() and std()
newColsIdx <- c(563, 562)
newColsIdx <- append(newColsIdx, grep("mean\\(\\)|std\\(\\)", 
    names(data), ignore.case = TRUE))
data <- data[newColsIdx]


# Using regular expression to appropriately rename column names.

colNames <- names(data)

colNames <- gsub("^t", "time.", colNames)
colNames <- gsub("^f", "frequency.", colNames)
colNames <- gsub("Body", "body.", colNames)
colNames <- gsub("Gravity", "gravity.", colNames)
colNames <- gsub("Acc", "accelerometer.", colNames)
colNames <- gsub("Gyro", "gyrometer.", colNames)
colNames <- gsub("Jerk", "jerk.", colNames)
colNames <- gsub("Mag", "magnitude.", colNames)
colNames <- gsub("\\-mean\\(\\)(\\-|*)", "mean", colNames)
colNames <- gsub("\\-std\\(\\)(\\-|*)", "std", colNames)
colNames <- gsub("X", ".x", colNames)
colNames <- gsub("Y", ".y", colNames)
colNames <- gsub("Z", ".z", colNames)

names(data) <- colNames

# Create a dataset that is grouped by subject and activity and and contains the
# mean value of each measurement for every pair (subject, activity)
dataBySubjectActivity <- group_by(data, subject, activity)
dataBySubjectActivity <- summarize_each(dataBySubjectActivity, funs(mean))

# Write the table to local storage.
write.table(dataBySubjectActivity, file = "tidydata.txt", row.name=FALSE)
