library(lubridate)

# Load the data file
# fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fileUrl <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Go from zip file to txt
# http://stackoverflow.com/questions/3053833/using-r-to-download-zipped-data-file-extract-and-import-data
temp <- tempfile()
download.file(fileUrl, temp)
filepath <- "household_power_consumption.txt"
unz(temp, filepath)
unlink(temp)

data <- read.table(file=filepath, header=TRUE, sep=";", na.strings="?")
data$Date <- as.Date(data$Date, "%d/%m/%Y")
data$Time <- hms(data$Time)
data$Global_active_power <- as.numeric(data$Global_active_power)
data2007 <- data[year(data$Date) == 2007, ]
data2007feb <- data2007[month(data2007$Date) == 2, ]
feb1data <- data2007feb[day(data2007feb$Date) == 1, ]
feb2data <- data2007feb[day(data2007feb$Date) == 2, ]
finaldata <- rbind(feb1data, feb2data)

# Plot 1 - Global Active Power
png(filename = "plot1.png", width=480, height=480)
hist(finaldata$Global_active_power, col = "red", main = "Global Active Power", xlab="Global Active Power (kilowatts)")
dev.off()
