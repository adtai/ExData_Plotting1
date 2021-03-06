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
data$Datetime <- dmy_hms(paste(data$Date, data$Time))
data$Date <- as.Date(data$Date, "%d/%m/%Y")
data$Time <- hms(data$Time)
data$Global_active_power <- as.numeric(data$Global_active_power)
data2007 <- data[year(data$Date) == 2007, ]
data2007feb <- data2007[month(data2007$Date) == 2, ]
feb1data <- data2007feb[day(data2007feb$Date) == 1, ]
feb2data <- data2007feb[day(data2007feb$Date) == 2, ]
finaldata <- rbind(feb1data, feb2data)

# Plot 4
png(filename = "plot4.png", width=480, height=480)
par(mfrow=c(2,2))
# subplot 1 - global active power
plot(finaldata$Datetime, finaldata$Global_active_power, type="l", xlab="", ylab="Global Active Power")
# subplot 2 - Voltage
plot(finaldata$Datetime, finaldata$Voltage, type="l", xlab="datetime", ylab="Voltage")
# subplot 3 - Repeat plot from plot3.
with(finaldata, plot(Datetime, Sub_metering_1, type="l", col="black", xlab="", ylab="Energy sub metering"))
with(finaldata, points(Datetime, Sub_metering_2, type="l", col="red"))
with(finaldata, points(Datetime, Sub_metering_3, type="l", col="blue"))
legend("topright", lty=1, col=c("black","red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty="n")
# subplot 4 - Global inactive power
plot(finaldata$Datetime, finaldata$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")
dev.off()
