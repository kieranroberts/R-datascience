fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "data.zip", quiet = TRUE)
unzip("data.zip")


# Extra the two datasets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# 1. Have total emissions from PM2.5 decreased in the United States from 1999
# to 2008? Using the base plotting system, make a plot showing the total PM2.5 
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.
#
# Answer: Yes they have decreased by just over 50%

png(file = "plot1.png", width=480, height=480)
emissions.by.year <- aggregate(Emissions ~ year, data = NEI, FUN = sum, 
    na.rm = TRUE)
emissions.by.year$Emissions <- round(emissions.by.year$Emissions/1000)
barplot(emissions.by.year$Emissions, names.arg = emissions.by.year$year, 
    main = expression(paste('Total Emission of PM', ''[2.5], ' From All Sources')), 
    xlab = "Year", ylab = expression(paste('PM', ''[2.5], ' in Kilotons')))
dev.off()