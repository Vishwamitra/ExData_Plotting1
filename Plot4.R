library(ggplot2)
library(scales)
library(tidyverse)
library(sqldf)
library(lubridate)

setwd("A:\\LEARNINGCOURSERA_REPO\\Assignment_ExData_Plotting")
fullSetData <- read.csv.sql("household_power_consumption.txt","select * from file where  Date ='1/2/2007' OR Date ='2/2/2007'", sep=";" )

#Change the format of Date string to Date class
fullSetData$Date <- parse_date_time(fullSetData$Date, orders ="dmy")

#Add a new column combining Date and Time Columns
data <- fullSetData %>% 
        mutate(DateTime = as.POSIXct(paste(Date, Time))) 

data$DateTime <- parse_date_time(data$DateTime, orders ="ymd HMS")

#plot1 data set
plot1Data <- data[, c("Date","DateTime", "Voltage")]

#plot4 data set
plot4Data <- data[, c("Date","DateTime", "Global_reactive_power")]


# subset columns which are required for plot 2
plot2Data <- data[, c("Date","DateTime", "Global_active_power")]

# subset columns which are required for plot 3
plot3Data <- data[, c("Date","DateTime", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")]
plot3Data <- plot3Data %>%
  select(Date, DateTime, Sub_metering_1,Sub_metering_2,Sub_metering_3) %>%
  gather(key = "SubMetering", value = "value", -Date, -DateTime)


#Plot a basic timeline graph with newly created DateTime Column and Global Active power column
p2 <- ggplot(plot2Data, aes(x=plot2Data$DateTime , y=plot2Data$Global_active_power)) +
  geom_line() + xlab("") + ylab("Global Active Power (kilowatts)") +
  scale_x_datetime( labels = date_format("%a"), date_breaks = "1 day" ) +
  theme( panel.grid.major = element_blank(),panel.grid.minor = element_blank())

#Plot a basic timeline graph with newly created DateTime Column and Voltage column
p1 <- ggplot(plot1Data, aes(x=plot1Data$DateTime , y=plot1Data$Voltage)) +
  geom_line() +
  xlab("datetime") +
  ylab("Voltage") +
  scale_x_datetime( labels = date_format("%a"), date_breaks = "1 day" ) +
  theme( panel.grid.major = element_blank(),panel.grid.minor = element_blank())

#Plot a basic timeline graph with newly created DateTime Column and Global Active power column
p3 <- ggplot(plot3Data, aes(x=plot3Data$DateTime, y=value))+ 
  geom_line(aes(color = SubMetering), show.legend = TRUE) + 
  scale_color_manual(values = c("black", "red", "blue")) + theme(legend.position = c(.8,.8))+ theme( legend.title = element_blank())+
  xlab("") +
  ylab("Energy Sub metering") +
  scale_x_datetime( labels = date_format("%a"), date_breaks = "1 day" ) +
  theme( panel.grid.major = element_blank(),panel.grid.minor = element_blank())
#Plot a basic timeline graph with newly created DateTime Column and global reactive power column
p4 <- ggplot(plot4Data, aes(x=plot4Data$DateTime , y=plot4Data$Global_reactive_power)) +
  geom_line() +
  xlab("datetime") +
  ylab("Global_reactive_power")+
  scale_x_datetime( labels = date_format("%a"), date_breaks = "1 day" ) +
  theme( panel.grid.major = element_blank(),panel.grid.minor = element_blank())

#to write the plot in a png file
png(file="Plot4.png")
ggarrange(p2, p1, p3, p4,  hjust = 0.5, vjust = 2)
dev.off()
