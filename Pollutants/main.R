pollutantmean <- function(directory, pollutant, id = 1:332) {
    fileZip <- "rprog-data-specdata.zip" 
    unzip(fileZip)
    
    obs = numeric()

    for (i in id) {
        fileName <- sprintf("%03d.csv", i)
        df <- read.csv(paste(directory, fileName, sep="/"))
        obs <- append(obs, df[[pollutant]])
    }
    mean(obs, na.rm = TRUE)
}
