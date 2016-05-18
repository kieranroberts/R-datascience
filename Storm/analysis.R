URL <- "http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
destfile <- "./repdata-data-StormData.csv.bz2"
download.file(URL, destfile)
storm <- read.csv(bzfile("repdata-data-StormData.csv.bz2"))

# 1. Across the United States, which types of events (as indicated in the 
# EVTYPE variable) are most harmful with respect to population health?

# We need to look at the columns INJURIES AND FATALITIES

library(dplyr)

# From https://www.ncdc.noaa.gov/stormevents/details.jsp we can see that only
# from 1996 were data collected for all 48 types of events. For this reason
# we will only consider events from 1996-01-01.

storm.1 <- storm[c(2,8,23,24)]
storm.1$BGN_DATE <- as.character(storm.1$BGN_DATE)
storm.1$BGN_DATE <- sub("[ ]+(.)*", "", storm.1$BGN_DATE)
storm.1$BGN_DATE <- as.Date(storm.1$BGN_DATE, format = "%m/%d/%Y")
storm.1 <- subset(storm.1, BGN_DATE >= as.Date("1996-01-01"))
storm.1$EVTYPE <- tolower(storm.1$EVTYPE) 

# Remove rows where FATALITIES AND INJURIES are 0.
storm.1 <- subset(storm.1, !(FATALITIES == 0 & INJURIES == 0))

storm.1$EVTYPE[grep("(?=.*coastal)", storm.1$EVTYPE, perl=TRUE)] <- "coastal flood"
storm.1$EVTYPE[grep("(?=.*wind)(?=.*chill)", storm.1$EVTYPE, perl=TRUE)] <- "cold/wind chill"
storm.1$EVTYPE[grep("(?=.*dense)(?=.*fog)|^(fog)", storm.1$EVTYPE, perl=TRUE)] <- "dense fog"
storm.1$EVTYPE[grep("(?=.*smoke)", storm.1$EVTYPE, perl=TRUE)] <- "dense smoke"
storm.1$EVTYPE[grep("dry microburst", storm.1$EVTYPE, perl=TRUE)] <- "thunderstorm wind" 
storm.1$EVTYPE[grep("heat wave", storm.1$EVTYPE, perl=TRUE)] <- "excessive heat"
storm.1$EVTYPE[grep("(?=.+heat)", storm.1$EVTYPE, perl=TRUE)] <- "excessive heat"
storm.1$EVTYPE[grep("warm weather", storm.1$EVTYPE, perl=TRUE)] <- "heat"
storm.1$EVTYPE[grep("weather", storm.1$EVTYPE, perl=TRUE)] <- "winter weather"
storm.1$EVTYPE[grep("(?=.*river)(?=.*flood)", storm.1$EVTYPE, perl=TRUE)] <- "flash flood"
storm.1$EVTYPE[grep("freezing", storm.1$EVTYPE, perl=TRUE)] <- "winter weather"
storm.1$EVTYPE[grep("^(tstm)", storm.1$EVTYPE, perl=TRUE)] <- "thunderstorm wind"
storm.1$EVTYPE[grep("rain/snow", storm.1$EVTYPE, perl=TRUE)] <- "sleet"
storm.1$EVTYPE[grep("light snow", storm.1$EVTYPE, perl=TRUE)] <- "winter weather"
storm.1$EVTYPE[grep("(?=.*snow)(?=.*and)", storm.1$EVTYPE, perl=TRUE)] <- "winter weather"
storm.1$EVTYPE[grep("snow", storm.1$EVTYPE, perl=TRUE)] <- "heavy snow"
storm.1$EVTYPE[grep("surf", storm.1$EVTYPE, perl=TRUE)] <- "high surf"
storm.1$EVTYPE[grep("marine t", storm.1$EVTYPE, perl=TRUE)] <- "marine thunderstorm wind"
storm.1$EVTYPE[grep("hurricane", storm.1$EVTYPE, perl=TRUE)] <- "hurricane"
storm.1$EVTYPE[grep("rip current", storm.1$EVTYPE, perl=TRUE)] <- "rip current"
storm.1$EVTYPE[grep("whirlwind" , storm.1$EVTYPE, perl=TRUE)] <- "tornado"
storm.1$EVTYPE[grep("^(strong wind)", storm.1$EVTYPE, perl=TRUE)] <- "strong wind"
storm.1$EVTYPE[grep("^(thunderstorm)", storm.1$EVTYPE, perl=TRUE)] <- "thunderstorm wind"
storm.1$EVTYPE[grep("fire", storm.1$EVTYPE, perl=TRUE)] <- "wildfire"
storm.1$EVTYPE[grep("torrential rainfall", storm.1$EVTYPE, perl=TRUE)] <- "heavy rain"
storm.1$EVTYPE[grep("mudslide|landslide", storm.1$EVTYPE, perl=TRUE)] <- "debris flow"  
storm.1$EVTYPE[grep("storm surge", storm.1$EVTYPE, perl=TRUE)] <- "storm surge/tide"
storm.1$EVTYPE[grep("ice|icy", storm.1$EVTYPE, perl=TRUE)] <- "winter weather"
storm.1$EVTYPE[grep("wind", storm.1$EVTYPE, perl=TRUE)] <- "strong wind"
storm.1$EVTYPE[grep("coastal storm", storm.1$EVTYPE, perl=TRUE)] <- "marine thunderstorm wind"
storm.1$EVTYPE[grep("urban/sml stream fld" , storm.1$EVTYPE, perl=TRUE)] <- "flood"
storm.1$EVTYPE[grep("extended cold", storm.1$EVTYPE, perl=TRUE)] <- "winter weather"
storm.1$EVTYPE[grep("typhoon", storm.1$EVTYPE, perl=TRUE)] <- "hurricane"
storm.1$EVTYPE[grep("seas", storm.1$EVTYPE, perl=TRUE)] <- "rip current"
storm.1$EVTYPE[grep("wave", storm.1$EVTYPE, perl=TRUE)] <- "rip current"
storm.1$EVTYPE[grep("water", storm.1$EVTYPE, perl=TRUE)] <- "rip current"
storm.1$EVTYPE[grep("drowning", storm.1$EVTYPE, perl=TRUE)] <- "rip current"
storm.1$EVTYPE[grep("hail", storm.1$EVTYPE, perl=TRUE)] <- "hail"
storm.1$EVTYPE[grep("wintry mix", storm.1$EVTYPE, perl=TRUE)] <- "winter weather"
storm.1$EVTYPE[grep("glaze", storm.1$EVTYPE, perl=TRUE)] <- "winter storm"
storm.1$EVTYPE[grep("cold", storm.1$EVTYPE, perl=TRUE)] <- "cold/wind chill"
storm.1$EVTYPE[grep("warm", storm.1$EVTYPE, perl=TRUE)] <- "drought"
storm.1$EVTYPE[grep("hypothermia", storm.1$EVTYPE, perl=TRUE)] <- "drought"
storm.1$EVTYPE[grep("mixed precip", storm.1$EVTYPE, perl=TRUE)] <- "mixed precipitation"
storm.1$EVTYPE[grep("tidal|coastalstorm|swells|marine accident", storm.1$EVTYPE, perl=TRUE)] <- "storm surge/tide"



storm.1.fat <- aggregate(FATALITIES ~ EVTYPE, data = storm.1, FUN = sum)
storm.1.fat <- subset(storm.1.fat, FATALITIES>=100)
stormplot.fat <- ggplot(storm.1.fat, aes(x = factor(EVTYPE), y = FATALITIES)) + 
             geom_bar(stat = "identity", fill="#808080", colour="black")

storm.1.inj <- aggregate(INJURIES ~ EVTYPE, data = storm.1, FUN = sum)
storm.1.inj <- subset(storm.1.inj, INJURIES>=500)
stormplot.inj <- ggplot(storm.1.inj, aes(x = factor(EVTYPE), y = INJURIES)) + 
             geom_bar(stat = "identity", fill="#8B4513", colour="black")

c(2,8,23,24)


library(ggplot2)
#storm.1.fat <- subset(storm.1, FATALITIES >=10) 
#storm.1.inj <- subset(storm.1, INJURIES >= 10)

my_sum <- function(y) {
    s <- sum(y)
    if ( s>= 10)
        return(s)
    else
        return(NA)
}
ggplot(storm.1,aes(x=factor(EVTYPE), y=FATALITIES)) + stat_summary(fun.y=my_sum, geom="bar")
ggplot(storm.1.inj,aes(x=factor(EVTYPE), y=INJURIES)) + stat_summary(fun.y=sum, geom="bar")




storm.2 <- storm[c(2,8,25,26,27,28)]
storm.2$BGN_DATE <- as.character(storm.2$BGN_DATE)
storm.2$BGN_DATE <- sub("[ ]+(.)*", "", storm.2$BGN_DATE)
storm.2$BGN_DATE <- as.Date(storm.2$BGN_DATE, format = "%m/%d/%Y")
storm.2 <- subset(storm.2, BGN_DATE >= as.Date("1996-01-01"))
storm.2$EVTYPE <- tolower(storm.2$EVTYPE) 

storm.2 <- subset(storm.2, !( PROPDMG == 0 & CROPDMG == 0))

storm.2$EVTYPE[grep("(?=.*coastal)(?=.*flood)", storm.2$EVTYPE, perl=TRUE)] <- "coastal flood"
storm.2$EVTYPE[grep("^(coastal erosion)$", storm.2$EVTYPE, perl=TRUE)] <- "coastal flood"
storm.2$EVTYPE[grep("^(?=.*extreme)(?=.*(chill|cold))", storm.2$EVTYPE, perl=TRUE)] <- "extreme cold/wind chill"
storm.2$EVTYPE[grep("^(?!.*extreme)(?=.*cold)", storm.2$EVTYPE, perl=TRUE)] <- "cold/wind chill"
storm.2$EVTYPE[grep("slide", storm.2$EVTYPE, perl=TRUE)] <- "debris flow"
storm.2$EVTYPE[grep("^(fog)$", storm.2$EVTYPE, perl=TRUE)] <- "dense fog"
storm.2$EVTYPE[grep("^(blowing dust)$", storm.2$EVTYPE, perl=TRUE)] <- "dust storm"
storm.2$EVTYPE[grep("^(unseasonably warm)$", storm.2$EVTYPE, perl=TRUE)] <- "heat"
storm.2$EVTYPE[grep("flash", storm.2$EVTYPE, perl=TRUE)] <- "flash flood"
storm.2$EVTYPE[grep("^(river)", storm.2$EVTYPE, perl=TRUE)] <- "flash flood"
storm.2$EVTYPE[grep("^(erosion/cstl flood)$", storm.2$EVTYPE, perl=TRUE)] <- "coastal flood"
storm.2$EVTYPE[grep("^(tidal flooding)$", storm.2$EVTYPE, perl=TRUE)] <- "storm surge/tide"
storm.2$EVTYPE[grep("^(storm surge)$|^(coastal storm)$", storm.2$EVTYPE, perl=TRUE)] <- "storm surge/tide"
storm.2$EVTYPE[grep("frost", storm.2$EVTYPE, perl=TRUE)] <- "frost/freeze"
storm.2$EVTYPE[grep("^(small hail)$", storm.2$EVTYPE, perl=TRUE)] <- "hail"
storm.2$EVTYPE[grep("rain", storm.2$EVTYPE, perl=TRUE)] <- "heavy rain"
storm.2$EVTYPE[grep("^(?=.*snow)(?=.*(heavy|excessive|squall))", storm.2$EVTYPE, perl=TRUE)] <- "heavy snow"
storm.2$EVTYPE[grep("^(snow)$", storm.2$EVTYPE, perl=TRUE)] <- "winter weather"
storm.2$EVTYPE[grep("^(?=.*light)(?=.*snow)", storm.2$EVTYPE, perl=TRUE)] <- "winter weather"
storm.2$EVTYPE[grep("^(late season snow)$", storm.2$EVTYPE, perl=TRUE)] <- "winter weather"
storm.2$EVTYPE[grep("^(lake effect snow)$", storm.2$EVTYPE, perl=TRUE)] <- "lake-effect snow"
storm.2$EVTYPE[grep("^(blowing snow)$", storm.2$EVTYPE, perl=TRUE)] <- "winter storm"
storm.2$EVTYPE[grep("surf", storm.2$EVTYPE, perl=TRUE)] <- "high surf"
storm.2$EVTYPE[grep("^(tstm wind)", storm.2$EVTYPE, perl=TRUE)] <- "thunderstorm wind"
storm.2$EVTYPE[grep("^(whirlwind)$", storm.2$EVTYPE, perl=TRUE)] <- "tornado"
storm.2$EVTYPE[grep("^(landslump)$", storm.2$EVTYPE, perl=TRUE)] <- "debris flow"
storm.2$EVTYPE[grep("^(?!.*storm)(?=.*wint)", storm.2$EVTYPE, perl=TRUE)] <- "winter weather"
storm.2$EVTYPE[grep("fire", storm.2$EVTYPE, perl=TRUE)] <- "wildfire"
storm.2$EVTYPE[grep(".*(freeze)$", storm.2$EVTYPE, perl=TRUE)] <- "frost/freeze"
storm.2$EVTYPE[grep("^(landspout)$", storm.2$EVTYPE, perl=TRUE)] <- "tornado"
storm.2$EVTYPE[grep(".*(microburst)$", storm.2$EVTYPE, perl=TRUE)] <- "thunderstorm wind"
storm.2$EVTYPE[grep("^(beach erosion)$", storm.2$EVTYPE, perl=TRUE)] <- "thunderstorm wind"
storm.2$EVTYPE[grep("^(marine tstm wind)$", storm.2$EVTYPE, perl=TRUE)] <- "marine thunderstorm wind"
storm.2$EVTYPE[grep("(typhoon)$", storm.2$EVTYPE, perl=TRUE)] <- "hurricane"
storm.2$EVTYPE[grep("^(?!.*storm)(?=.*(ice|icy))", storm.2$EVTYPE, perl=TRUE)] <- "winter weather"
storm.2$EVTYPE[grep("^(glaze)", storm.2$EVTYPE, perl=TRUE)] <- "winter weather"
storm.2$EVTYPE[grep("^downburst$", storm.2$EVTYPE, perl=TRUE)] <- "thunderstorm wind"
storm.2$EVTYPE[grep("^(dam break)$", storm.2$EVTYPE, perl=TRUE)] <- "flash flood"
storm.2$EVTYPE[grep("^(high swells)$", storm.2$EVTYPE, perl=TRUE)] <- "rip current"
storm.2$EVTYPE[grep("^(rip currents)$", storm.2$EVTYPE, perl=TRUE)] <- "rip current"
storm.2$EVTYPE[grep("^(urban/sml stream fld)$", storm.2$EVTYPE, perl=TRUE)] <- "flood"
storm.2$EVTYPE[grep("^(strong|gust).*wind", storm.2$EVTYPE, perl=TRUE)] <- "strong wind"
storm.2$EVTYPE[grep("^(wind)$", storm.2$EVTYPE, perl=TRUE)] <- "strong wind"
storm.2$EVTYPE[grep("^(high wind)", storm.2$EVTYPE, perl=TRUE)] <- "high wind"
storm.2$EVTYPE[grep("^(wind and wave)$", storm.2$EVTYPE, perl=TRUE)] <- "marine thunderstorm wind"
storm.2$EVTYPE[grep("^(marine accident)$", storm.2$EVTYPE, perl=TRUE)] <- "marine thunderstorm wind"
storm.2$EVTYPE[grep("^(freezing drizzle)$", storm.2$EVTYPE, perl=TRUE)] <- "winter weather"
storm.2$EVTYPE[grep("^(mixed precipitation)$", storm.2$EVTYPE, perl=TRUE)] <- "sleet"
storm.2$EVTYPE[grep("^(gradient wind)$", storm.2$EVTYPE, perl=TRUE)] <- "strong wind"
storm.2$EVTYPE[grep("(?=.*non)(?=.*wind)", storm.2$EVTYPE, perl=TRUE)] <- "strong wind"
storm.2$EVTYPE[grep("(?=.*high)(?=.*(tide|sea))", storm.2$EVTYPE, perl=TRUE)] <- "storm surge/tide"
storm.2$EVTYPE[grep("^(hi damage)", storm.2$EVTYPE, perl=TRUE)] <- "other" 
storm.2$EVTYPE[grep("^( tstm wind)", storm.2$EVTYPE, perl=TRUE)] <- "thunderstorm wind" 

