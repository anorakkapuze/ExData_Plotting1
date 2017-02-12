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
png(filename = "plot2.png", width=480, height=480)
plot(df$DateTime, df$Global_active_power, xlab="", ylab="Global Active Power (kilowatts)", col="black", type="l")
dev.off()