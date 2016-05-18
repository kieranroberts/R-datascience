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
globalActivePower <- as.numeric(subsetData$Global_active_power)
fulldate<- strptime(paste(subsetData$Date, subsetData$Time, sep=" "), "%d/%m/%Y %H:%M:%S")

# plot to a PNG file
png(file = "plot2.png", width=480, height=480)
plot(fulldate, globalActivePower, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")
dev.off()

# Return locale to original
Sys.setlocale("LC_TIME", my_lc_time)

