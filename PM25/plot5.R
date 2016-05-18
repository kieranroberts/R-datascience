fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "data.zip", quiet = TRUE)
unzip("data.zip")


# Extra the two datasets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# 5. How have emissions from motor vehicle sources changed from 1999–2008 in 
# Baltimore City?
#
# Answer: Decreased by approximately 2%.

png(file = "plot5.png", width=480, height=480)
vehicle <- grepl("vehicle",SCC$Short.Name, ignore.case = TRUE)
vehicle <- SCC[vehicle,]
scc <- vehicle$SCC
vehicle <- subset(NEI, SCC %in% scc)
vehicles.by.year <- aggregate(Emissions ~ year, data = vehicle, FUN = sum, na.rm = TRUE)
vehicles.by.year$Emissions <- round(vehicles.by.year$Emissions/1000)
barplot(vehicles.by.year$Emissions, names.arg = vehicles.by.year$year, 
    main = expression(paste('Total Emissions of PM', ''[2.5], ' From Motor Vehicle Sources')), xlab = "Year", 
    ylab = expression(paste('PM', ''[2.5], ' in Kilotons')))
dev.off()
