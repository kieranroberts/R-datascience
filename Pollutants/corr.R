source("complete.R")
fileZip <- "rprog-data-specdata.zip" 
unzip(fileZip)

corr <- function(directory, threshold = 0) {
    cdf <- complete(directory)
    corrs = numeric()
    for (i in 1:332) {
        if (cdf$nobs[i] >= threshold) {
            fileName <- sprintf("%03d.csv", i)
            df <- read.csv(paste(directory, fileName, sep="/"))
            corrs <- append(corrs, 
                cor(df$sulfate, df$nitrate, use = "pairwise.complete.obs"))
        }
    }
    corrs
}
