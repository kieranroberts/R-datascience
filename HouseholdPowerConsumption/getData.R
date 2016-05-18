# getData:
# A function with 0 arguments and fetches the necessary data.

getData <- function() {
    # Create a subdirectory for the data
    if (!file.exists("data"))
        dir.create("data")

    # Check to see if the Data 
    fileUrl <-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    fileZip <- "./data/exdata-data-household_power_consumption.zip"
    if (!file.exists("./data/household_power_consumption.txt")) {
        if (!file.exists(fileZip))
            download.file(fileUrl, destfile=fileZip, method = "curl", quiet = TRUE)
        unzip(fileZip, exdir = "./data")
        print("Data exists.")
    }
}

