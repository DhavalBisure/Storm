##Download the data
if (!file.exists("StormData.csv.bz2")) 
       fileURL <- 'https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2'
       download.file(fileURL, destfile='StormData.csv.bz2')
  }
##Reading the daata
storm <- read.csv(bzfile('StormData.csv.bz2'),header=TRUE, stringsAsFactors = FALSE)

##Summarising the data and checking for NA values in needed columns
summary(storm)

##Finding harmful events
harmData <- aggregate(storm$FATALITIES, by = list(storm$EVTYPE), FUN = sum)
harmData2 <- aggregate(storm$INJURIES, by = list(storm$EVTYPE), FUN = sum)
harm <- merge(harmData,harmData2, by.x = "Group.1", by.y = "Group.1")
names(harm) <- c("Event","Fatalities","Injuries")
harm <- harm[order(-harm$Injuries),]
head(harm)

##Creating plot
