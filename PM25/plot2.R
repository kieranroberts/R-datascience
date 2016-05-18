fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "data.zip", quiet = TRUE)
unzip("data.zip")


# Extra the two datasets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a 
# plot answering this question.
#
# Answer: Yes they have decreased by 50%. 
# 1999 -> 2002 (decrease), 
# 2002 -> 2005 (increase), 
# 2005 -> 2008 (decrease). 
# Overall 1999 -> 2008 (decrease).  

png(file = "plot2.png", width=480, height=480)
baltimore <- subset(NEI, fips == "24510")
baltimore.by.year <- aggregate(Emissions ~ year, data = baltimore, FUN = sum, 
    na.rm = TRUE)
barplot(baltimore.by.year$Emissions, names.arg = baltimore.by.year$year, 
    main = expression(paste('Total Emission of PM', ''[2.5], ' in Baltimore')), xlab = "Year", 
    ylab = expression(paste('PM', ''[2.5], ' in tons')))
dev.off()

