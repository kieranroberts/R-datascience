activity <- read.csv(unz("repdata-data-activity.zip", "activity.csv"))
head(activity)

activity$date <- as.Date(activity$date, "%Y-%m-%d")
class(activity$date)


#histogram

hist(totalStepsByDay$steps, main = "Histogram of total number of steps taken each day", xlab = "Number of steps")

meanStepsByDay <- mean(totalStepsByDay$steps)
medianStepsByDay <- median(totalStepsByDay$steps)
meanstr <- sprintf("mean = %.2f", meanStepsByDay)
medianstr <- sprintf("median = %.2f", medianStepsByDay)

abline(v = medianStepsByDay, lty = 3, col = "blue")
abline(v = meanStepsByDay, lty = 2, col = "red")
text(meanStepsByDay,26,labels=meanstr, pos=4, col="red")    
text(medianStepsByDay,24,labels=medianstr, pos=4, col="blue") 

meanStepsByDay
medianStepsByDay




# Create new data frame from old

avgStepsByInterval <- aggregate(steps ~ interval, data = activity, mean)
head(avgStepsByInterval)
    
# Plot the time series.

with(avgStepsByInterval, 
    plot(interval, steps, type = "l", 
    xlab = "5-minute intervals", ylab = "average number of steps taken 
    (across all days)", main = "Average number of steps taken per interval"))
    
maxInterval <- 
    avgStepsByInterval[which.max(avgStepsByInterval$steps),]$interval

abline(v = maxInterval,lty = 5, col = "blue")
maxstr <- sprintf("max = %.2f", max(avgStepsByInterval$steps))
text(maxInterval, 200, labels = maxstr, pos=4, col="blue")


# Find missing values

MissingValues <- sum(with(activity, is.na(steps)))
MissingValues

# We will replace missing values with mean at that given interval in the day

N <- dim(activity)[1]
activity2 <- activity

for (i in 1:N) {
    rowData <- activity[i,]
    if (is.na(rowData$steps)) {
        activity2$steps[i] <- subset(avgStepsByInterval, interval == rowData$interval)$steps
    }
}

head(activity2)

# Recreate histogram with missing NA values recomputed. 

totalStepsByDay2 <- aggregate(steps ~ date, data = activity2, FUN = sum)
hist(totalStepsByDay$steps, main = "Histogram of total number of steps taken each day", xlab = "Number of steps")

meanStepsByDay2 <- mean(totalStepsByDay2$steps)
medianStepsByDay2 <- median(totalStepsByDay2$steps)
meanstr <- sprintf("mean = %.2f", meanStepsByDay2)
medianstr <- sprintf("median = %.2f", medianStepsByDay2)

abline(v = medianStepsByDay2, lty = 3, col = "blue")
abline(v = meanStepsByDay2, lty = 2, col = "red")
text(meanStepsByDay2,26,labels=meanstr, pos=4, col="red")    
text(medianStepsByDay2,24,labels=medianstr, pos=4, col="blue") 

# The mean has remain unchanged. This is as expected since adding new values to
# activity which are equal to its existing mean would not change its mean.
# The median has changed slightly. This is expected too since adding new values
# would change the ascending order of the values. The mean and median are now
# equal.

meanStepsByDay2
medianStepsByDay2


###

# First add a new factor column  to *activity2* called _typeDay_ with possible 
# levels 'Weekday' and 'Weekend'

N <- dim(activity2)[1]
typeDay = character()
for (i in 1:N) {
    if (weekdays(activity2$date[i]) %in% c("Saturday", "Sunday"))
        typeDay <- append(typeDay, "Weekend")
    else
        typeDay <- append(typeDay, "Weekday")
}

typeDay <- as.factor(typeDay)
activity2$typeDay <- typeDay


# Now create a new data frame from *activity2* where there are three columns.
# _intervals_, _typeDay_, _steps_
# Each interval from 0 to 2355 appears twice for 'Weekend' and 'Weekday'
# The _steps_ column records the average number of steps for that given
# interval as a function of typeDay.

avgStepsLevels <- aggregate(steps ~ interval + typeDay, data = activity2,  
    FUN = mean)
names(stepsByDay) <- c("interval", "daylevel", "steps")

# A panel plot containing a time series plot of the 5-minute interval (x-axis) 
# and the average number of steps taken, averaged across all weekday days or 
# weekend days (y-axis).  

xyplot(steps ~ interval | typeDay, data = avgStepsLevels, type = "l", 
    layout = c(1, 2),  xlab = "Interval", ylab = "Average number of steps")
