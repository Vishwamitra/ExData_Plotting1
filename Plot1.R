library(ggplot2)
library(scales)
library(sqldf)

setwd("A:\\LEARNINGCOURSERA_REPO\\Assignment_ExData_Plotting")
fullSetData <- read.csv.sql("household_power_consumption.txt","select * from file where  Date ='1/2/2007' OR Date ='2/2/2007'", sep=";" )

#Change the format of Date string to Date class
fullSetData$Date <- parse_date_time(fullSetData$Date, orders ="dmy")

# subset columns which are required for plot 2
plot1Data <- fullSetData[,"Global_active_power"]

#to write the plot in a png file
png(file="Plot1.png")

#Plot a basic histogram with Global Active power column
plot1 <- hist(plot1Data, xlab="Global Active Power (kilowatts)", col="red", main = "Global Active Power")

#write the png and close
dev.off()