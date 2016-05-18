fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "data.zip", quiet = TRUE)
unzip("data.zip")


# Extra the two datasets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# 3. Of the four types of sources indicated by the type (point, nonpoint, 
# onroad, nonroad) variable, which of these four sources have seen decreases 
# in emissions from 1999–2008 for Baltimore City? Which have seen increases in
# emissions from 1999–2008? Use the ggplot2 plotting system to make a plot 
# answer this question.
#
# Answer: The _point_ type of sources have increased from 1999 to 2008.
# All other types of sources have decreased.

library(ggplot2)
png(file = "plot3.png", width=480, height=480)
baltimore <- subset(NEI, fips == "24510")
ggplot(baltimore,aes(x=factor(type),y=Emissions,fill=factor(year)), color=factor(year)) + 
    stat_summary(fun.y=sum,position=position_dodge(),geom="bar") + 
    labs(x= "Source of Emission") + 
    scale_fill_discrete(name = "Years")
dev.off()
