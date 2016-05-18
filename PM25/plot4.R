fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "data.zip", quiet = TRUE)
unzip("data.zip")


# Extra the two datasets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# 4. Across the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?
#
# Answer: Decreased by just below 50%.

png(file = "plot4.png", width=480, height=480)
coal <- grepl("coal",SCC$Short.Name, ignore.case = TRUE)
coal <- SCC[coal, ]
scc <- coal$SCC
coal <- subset(NEI, SCC %in% scc)
coal.by.year <- aggregate(Emissions ~ year, data = coal, FUN = sum, na.rm = TRUE)
coal.by.year$Emissions <- round(coal.by.year$Emissions/1000)
barplot(coal.by.year$Emissions, names.arg = coal.by.year$year, 
    main = expression(paste('Total Emissions of PM', ''[2.5], ' From Coal Combustion Sources')), 
    xlab = "Year", ylab = expression(paste('PM', ''[2.5], ' in Kilotons')))
dev.off()
