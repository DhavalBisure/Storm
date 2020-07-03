##Download the data
if (!file.exists("StormData.csv.bz2")) 
       fileURL <- 'https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2'
       download.file(fileURL, destfile='StormData.csv.bz2')
  
##Reading the daata
storm <- read.csv(bzfile('StormData.csv.bz2'),header=TRUE, stringsAsFactors = FALSE)

##Summarising the data and checking for NA values in needed columns
summary(storm)

##Finding events with highest Fatality
FatalityData <- aggregate(storm$FATALITIES, by = list(storm$EVTYPE), FUN = sum)
names(FatalityData) <- c("Event","Fatalities")
FatalityData <- FatalityData[order(-FatalityData$Fatalities),]
FatalityData <- FatalityData[1:20,]
head(FatalityData)


##Finding events with highest Injuries
InjuryData <- aggregate(storm$INJURIES, by = list(storm$EVTYPE), FUN = sum)
names(InjuryData) <- c("Event","Injuries")
InjuryData <- InjuryData[order(-InjuryData$Injuries),]
InjuryData <- InjuryData[1:20,]
head(InjuryData)

##Creating plot for harmful events
library(ggplot2)

fatalplot <- ggplot(FatalityData,aes(y=Fatalities,x= reorder(Event, -Fatalities))) +
 geom_bar(stat="identity",fill="steelblue") +
 theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) +
 ggtitle("Events with Highest Fatality") + xlab("Events") + ylab("Number of Fatalities")

injuryplot <- ggplot(InjuryData,aes(y=Injuries,x= reorder(Event, -Injuries))) +
  geom_bar(stat="identity",fill="red") +
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) +
  ggtitle("Events with Highest Injuries") + xlab("Events") + ylab("Number of Injuries")

library(gridExtra)
grid.arrange(fatalplot,injuryplot,ncol=2)
 
##Finding Total Economic Damage
propdamage <- aggregate(storm$PROPDMG, by = list(storm$EVTYPE),FUN=sum)
names(propdamage) <- c("Event","PropDamage")
cropdamage <- aggregate(storm$CROPDMG, by = list(storm$EVTYPE),FUN=sum)
names(cropdamage) <- c("Event","CropDamage")
TotalDamage <- merge(propdamage,cropdamage, by.x = "Event", by.y = "Event")
TotalDamage$Total <- TotalDamage$PropDamage + TotalDamage$CropDamage
TotalDamage <- TotalDamage[order(-TotalDamage$Total),]
head(TotalDamage,n=10)

##Making plot
options(scipen = 3500000)
damageplot <- ggplot(TotalDamage, aes(x=reorder(Event, -Total),y = Total)) +                          
  geom_bar(stat="identity",fill="red") +
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) +
  ggtitle("Events with Highest Damage") + xlab("Events") + ylab("Amount of Damage($)")
