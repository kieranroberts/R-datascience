# Codebook: Human Activity Recognition Using Smartphones

# Experiment Design

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained data set has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


# Description of Varaibles

## Raw data collection
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

```
tBodyAcc-XYZ: 
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag
```
Measurements containing the string _Acc_ are deduced from signals detected by the accelerormeter and presented in the standard gravity units _g_ (1 _g_ is approximately 9 .82 m/s^2^ )

Measurements containg the string _Gyro_ are deduced from signals detected by the gyroscope. The gyoscope records the measurements in _rad/s_ (radians per seconds, the standard unit for angular velocity). If the measurement name also contains the string _Jerk_, then the unit of measurement is _rad/s^3_.

If any measurement contains the string _Mag_, then this is a measure of magnitude. This is a scalar and has no unit of measure.


## Variables
The first two variables in the data set are _subject_ (the identifiers given to volunteers of the experiment) and _activity_ (the description of the activity).

The remaining variables were estimated from the measurements described above are mean values 
(mean) and standard deviation (std):

```
time.body.accelerometer.mean.x
time.body.accelerometer.mean.y
time.body.accelerometer.mean.z
time.body.accelerometer.std.x
time.body.accelerometer.std.y
time.body.accelerometer.std.z
time.gravity.accelerometer.mean.x
time.gravity.accelerometer.mean.y
time.gravity.accelerometer.mean.z
time.gravity.accelerometer.std.x
time.gravity.accelerometer.std.y
time.gravity.accelerometer.std.z
time.body.accelerometer.jerk.mean.x
time.body.accelerometer.jerk.mean.y
time.body.accelerometer.jerk.mean.z
time.body.accelerometer.jerk.std.x
time.body.accelerometer.jerk.std.y
time.body.accelerometer.jerk.std.z
time.body.gyrometer.mean.x
time.body.gyrometer.mean.y
time.body.gyrometer.mean.z
time.body.gyrometer.std.x
time.body.gyrometer.std.y
time.body.gyrometer.std.z
time.body.gyrometer.jerk.mean.x
time.body.gyrometer.jerk.mean.y
time.body.gyrometer.jerk.mean.z
time.body.gyrometer.jerk.std.x
time.body.gyrometer.jerk.std.y
time.body.gyrometer.jerk.std.z
time.body.accelerometer.magnitude.mean
time.body.accelerometer.magnitude.std
time.gravity.accelerometer.magnitude.mean
time.gravity.accelerometer.magnitude.std
time.body.accelerometer.jerk.magnitude.mean
time.body.accelerometer.jerk.magnitude.std
time.body.gyrometer.magnitude.mean
time.body.gyrometer.magnitude.std
time.body.gyrometer.jerk.magnitude.mean
time.body.gyrometer.jerk.magnitude.std
frequency.body.accelerometer.mean.x
frequency.body.accelerometer.mean.y
frequency.body.accelerometer.mean.z
frequency.body.accelerometer.std.x
frequency.body.accelerometer.std.y
frequency.body.accelerometer.std.z
frequency.body.accelerometer.jerk.mean.x
frequency.body.accelerometer.jerk.mean.y
frequency.body.accelerometer.jerk.mean.z
frequency.body.accelerometer.jerk.std.x
frequency.body.accelerometer.jerk.std.y
frequency.body.accelerometer.jerk.std.z
frequency.body.gyrometer.mean.x
frequency.body.gyrometer.mean.y
frequency.body.gyrometer.mean.z
frequency.body.gyrometer.std.x
frequency.body.gyrometer.std.y
frequency.body.gyrometer.std.z
frequency.body.accelerometer.magnitude.mean
frequency.body.accelerometer.magnitude.std
frequency.body.body.accelerometer.jerk.magnitude.mean
frequency.body.body.accelerometer.jerk.magnitude.std
frequency.body.body.gyrometer.magnitude.mean
frequency.body.body.gyrometer.magnitude.std
frequency.body.body.gyrometer.jerk.magnitude.mean
frequency.body.body.gyrometer.jerk.magnitude.std
```

Each value of such a variable is associated to a pair (_subject_, _activity_).

# The Cleaning Process and Transformation of Data

## Step 1
Merge the training and the test sets to create one data set. Add two additional 
columns (variables), namely, the subjects (identified by 1 to 30) and the the 
activity label (_walking, walking.upstairs, walking.downstairs, sitting, standing, laying_).
This results in a data set with 563 columns and 10299 rows.

## Step 2
Extract only the measurements on the mean and standard deviation for each measurement.
This reduces the number variables to 68.

## Step 3
Create descriptive activity names to name the activities in the data set and
appropriately label the data set with descriptive variable names.

## Step 4
Using the resulting data set from steps 2 & 3, create a second, independent tidy data set with the average of each variable for each activity and each subject. Each row can be viewed
as the unique pair (_subject_, _activity_). The new data set has 68 columns as before but now
only 30 (# subjects) * 6 (# activities) = 180 rows.
