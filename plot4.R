library(dplyr)

# download data

if (!file.exists("household_power_consumption.txt")) {
  fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileurl, destfile = "data.zip")
  unzip("data.zip", "household_power_consumption.txt")
}

# get the data into data frame und clean up times and dates
df <- read.table("household_power_consumption.txt", sep = ";", header = TRUE, na.strings = "?")
df$DateTime <- as.POSIXct(strptime(paste(df$Date, df$Time), "%d/%m/%Y %H:%M:%S"))

# filter for 1st and 2nd or Feb 2007
condition <- df$DateTime >= strptime("2007/02/01", "%Y/%m/%d") & df$DateTime < strptime("2007/02/03", "%Y/%m/%d")
df <- filter(df, condition)

# plot
png(filename = "plot4.png", width=480, height=480)
par(mfrow = c(2,2))
with(df, {
  # plot left top
  plot(df$DateTime, df$Global_active_power, xlab="", ylab="Global Active Power", col="black", type="l")
  # plot right top
  plot(df$DateTime, df$Voltage, xlab="datetime", ylab="Voltage", col="black", type="l")
  # plot left bottom
  plot(df$DateTime, df$Sub_metering_1, xlab="", ylab="Energy sub metering", col="black", type="l")
  points(df$DateTime, df$Sub_metering_2, col="red", type="l")
  points(df$DateTime, df$Sub_metering_3, col="blue", type="l")
  legend("topright", bty="n", pch = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  # plot right bottom
  plot(df$DateTime, df$Global_reactive_power, xlab="datetime", ylab="Global_reactive_power", col="black", type="l")
})
dev.off()