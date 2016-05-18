fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "data.zip", quiet = TRUE)
unzip("data.zip")


# Extra the two datasets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# 6. Compare emissions from motor vehicle sources in Baltimore City with 
# emissions from motor vehicle sources in Los Angeles County, California
# (fips == "06037"). Which city has seen greater changes over time in motor 
# vehicle emissions?
#
# Answer: From the graph one can see that emissions from motor vehicle sources
# in LA County have decreased approximately 35% whereas from the previous
# graph we can see that this decrease is only 2% in Baltimore City. 

library(ggplot2)
png(file = "plot6.png", width=480, height=480)
vehicle <- grepl("vehicle",SCC$Short.Name, ignore.case = TRUE)
vehicle <- SCC[vehicle,]
scc <- vehicle$SCC
vehicle <- subset(NEI, SCC %in% scc)
vehicle <- subset(vehicle, (fips == "24510" | fips == "06037")) 
ggplot(vehicle,aes(x=factor(year),y=Emissions,fill=factor(fips)), color=factor(fips)) + 
    stat_summary(fun.y=sum,position=position_dodge(),geom="bar") + 
    labs(x= "Year", y=expression(paste('PM', ''[2.5], ' in tons'))) + 
    labs(title = expression(paste('PM', ''[2.5],  ' Motor Vehicle-Emissions in two US Counties'))) +
    scale_fill_discrete(name ="County", labels=c("Los Angeles County", "Baltimore City"))
dev.off()
