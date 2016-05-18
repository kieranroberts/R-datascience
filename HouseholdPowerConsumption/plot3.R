# Temporary change the locale
my_lc_time <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "en_GB.UTF-8")

# Get the data
source("getData.R")
getData()

# read and extract relevant data
data <- read.table("./data/household_power_consumption.txt", header=TRUE, sep = ";", stringsAsFactors=FALSE)
subsetData <- subset(data, Date == "1/2/2007" | Date == "2/2/2007")

# convert necessary object types for plotting
subMetering1 <- as.numeric(subsetData$Sub_metering_1)
subMetering2 <- as.numeric(subsetData$Sub_metering_2)
subMetering3 <- as.numeric(subsetData$Sub_metering_3)
fulldate<- strptime(paste(subsetData$Date, subsetData$Time, sep=" "), "%d/%m/%Y %H:%M:%S")

# plot to a PNG file
png(file = "plot3.png", width=480, height=480)
plot(fulldate, subMetering1, type = "n", xlab="", ylab = "Energy sub metering")
lines(fulldate, subMetering3, col = "blue")
lines(fulldate, subMetering2, col = "red")
lines(fulldate, subMetering1, col = "black")
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")) 
dev.off()

# Return locale to original
Sys.setlocale("LC_TIME", my_lc_time)
