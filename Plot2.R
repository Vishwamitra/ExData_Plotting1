library(ggplot2)
library(scales)
library(sqldf)

setwd("A:\\LEARNINGCOURSERA_REPO\\Assignment_ExData_Plotting")
fullSetData <- read.csv.sql("household_power_consumption.txt","select * from file where  Date ='1/2/2007' OR Date ='2/2/2007'", sep=";" )

#Change the format of Date string to Date class
fullSetData$Date <- parse_date_time(fullSetData$Date, orders ="dmy")

#Add a new column combining Date and Time Columns
data <- fullSetData %>% 
        mutate(DateTime = as.POSIXct(paste(Date, Time))) 

data$DateTime <- parse_date_time(data$DateTime, orders ="ymd HMS")

# subset columns which are required for plot 2
plot2Data <- data[, c("Date","DateTime", "Global_active_power")]

#Plot a basic timeline graph with newly created DateTime Column and Global Active power column
plot2 <- ggplot(plot2Data, aes(x=plot2Data$DateTime , y=plot2Data$Global_active_power)) 
plot2 <- plot2 + geom_line() 
plot2 <- plot2 + xlab("") 
plot2 <- plot2 + ylab("Global Active Power (kilowatts)") 
plot2 <- plot2 + scale_x_datetime( labels = date_format("%a"), date_breaks = "1 day" ) 
plot2 <- plot2 + theme( panel.grid.major = element_blank(),panel.grid.minor = element_blank())
#plot2
ggsave("Plot2.png")