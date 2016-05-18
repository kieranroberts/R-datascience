## Part 1
###############################################################################
hospitaldata <- read.csv("outcome-of-care-measures.csv", 
    colClasses = "character")
head(hospitaldata)

outcomeData[, 11] <- as.numeric(outcome[, 11])
hist(outcomeData[, 11])
##
###############################################################################


## Part 2
###############################################################################

best <- function(state, outcome) {
    # Read the appropriate data
    outcomeData  <- read.csv("outcome-of-care-measures.csv", 
        colClasses = "character")
    
    # Assign new names for the appropriate rates of mortality 
    # outcomeData$heart_attack <- outcomeData[, 11]
    # outcomeData$heart_failure <- outcomeData[, 17]
    # outcomeData$pnuemonia <- outcomeData[, 23]
    
    # Generate valid input for the state and outcome
    states <- unique(outcomeData$State)
    outcomes <- c("heart attack", "heart failure", "pneumonia")
    
    
    if (!(state %in% states))
        stop("invalid state")
    if (!(outcome %in% outcomes))
        stop("invalid outcome")
    
    # Convert the string outcome that is readable variable in the data frame
    ## outcome <- sub(pattern=" ", replacement="_", x=outcome, fixed=TRUE)
    ## outcome <- eval(parse(text = outcome))
    # Did not work as I expected.
    
    # Assign the appropriate column number to the inputted outcome.
    if (outcome == "heart attack") colnum <- 11
    if (outcome == "heart failure") colnum <- 17
    if (outcome == "pneumonia") colnum <- 23
    
    # Create a new data frame containing only the columns:
    # Hospital.Name, State, outcome = colnum
    subColsData <- outcomeData[c(2,7,colnum)]
    
    # Take a subset of subColsData by filtering out State = state
    subData <- subset(subColsData, State == state)
    rates <- suppressWarnings(as.numeric(subData[,3]))
    I <- which(rates == min(rates, na.rm = TRUE))
    sort(subData$Hospital.Name[I]) 
}

rankhospital <- function(state, outcome, num = "best") {
    # Read the appropriate data
    outcomeData  <- read.csv("outcome-of-care-measures.csv", 
        colClasses = "character")
    
    # Generate valid input for the state and outcome
    states <- unique(outcomeData$State)
    outcomes <- c("heart attack", "heart failure", "pneumonia")
    
    # Check state and outcome are valid inputs
    if (!(state %in% states))
        stop("invalid state")
    if (!(outcome %in% outcomes))
        stop("invalid outcome")
    
    # Convert the string _outcome_ to its column number. 
    if (outcome == "heart attack") colNum <- 11
    if (outcome == "heart failure") colNum <- 17
    if (outcome == "pneumonia") colNum <- 23       
    
    outcomeData[, colNum] <- suppressWarnings(as.numeric(outcomeData[, colNum]))  
    #outcome <- sub(" ", replacement = "_", outcome)
    #names(outcomeData)[colNum] <- outcome
    
    subColsData <- outcomeData[c(2, 7, colNum)]
    subData <- subset(subColsData, State == state)
    subData <- subData[with(subData, order(subData[3], subData[1])),]
    
    rates <- subData[3]
    noHospitals <- length(rates[!is.na(rates)])
    
    
    
    # Check (and convert if necessary) that the rank is a valid input.
    if (num == "best") num <- 1
    if (num == "worst") num <- length(subData[3][!is.na(subData[3])])
    if (num > noHospitals)
        return(NA)
    
    subData[num, 1]
}

rankall <- function(outcome, num = "best") {
    # Read the appropriate data
    outcomeData  <- read.csv("outcome-of-care-measures.csv", 
        colClasses = "character")
    
    # Generate valid input for outcut and check the argument
    # _outcome_ lies in the list
    outcomes <- c("heart attack", "heart failure", "pneumonia")
    if (!(outcome %in% outcomes))
        stop("invalid outcome")
    
     states <- sort(unique(outcomeData$State))
     table <- data.frame(state = states, hospital = character(54))
     table$hospital <- as.character(table$hospital) 
     i <- 1
     for (s in states) {
        table$hospital[i] <- rankhospital(s, outcome, num)
        i <- i+1
     }
     table
}


