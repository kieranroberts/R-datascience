fileZip <- "rprog-data-specdata.zip" 
unzip(fileZip)

complete <- function(directory, id = 1:332) {
    nobs = integer()
    for (i in id) {
        fileName <- sprintf("%03d.csv", i)
        df <- read.csv(paste(directory, fileName, sep="/"))
        good <- complete.cases(df$sulfate, df$nitrate)
        nobs <- append(nobs, length(df$sulfate[good]))       
    }
    df2 <- data.frame(id, nobs)
    df2
}
