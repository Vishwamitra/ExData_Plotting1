library(ggplot2)
library(scales)
library("tidyverse")
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
plot3Data <- data[, c("Date","DateTime", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")]


plot3Data <- plot3Data %>%
  select(Date, DateTime, Sub_metering_1,Sub_metering_2,Sub_metering_3) %>%
  gather(key = "SubMetering", value = "value", -Date, -DateTime)


#Plot a basic timeline graph with newly created DateTime Column and Global Active power column
plot3 <- ggplot(plot3Data, aes(x=plot3Data$DateTime, y=value))+ 
  geom_line(aes(color = SubMetering), show.legend = TRUE) + 
  scale_color_manual(values = c("black", "red", "blue")) + theme(legend.position = c(.9,.9))+ theme( legend.title = element_blank())
plot3 <- plot3 + xlab("") 
plot3 <- plot3 + ylab("Energy Sub metering") 
plot3 <- plot3 + scale_x_datetime( labels = date_format("%a"), date_breaks = "1 day" ) 
plot3 <- plot3 + theme( panel.grid.major = element_blank(),panel.grid.minor = element_blank())
#plot3
ggsave("Plot3.png")
