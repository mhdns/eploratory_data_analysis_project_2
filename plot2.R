library(dplyr)
# Get data from data source
if (!all(file.exists("data/summarySCC_PM25.rds", "data/Source_Classification_Code.rds"))) {
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    
    # Check if data directory exist and create if not
    if (!dir.exists("data")) {
        dir.create("data")
    }
    
    # Download and extract file into data directory
    setwd("data")
    download.file(url, "data.zip")
    unzip("data.zip")
    file.remove("data.zip")
    setwd("..")
    rm(url)
}

# Read data into memory
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

# Yearly emissions
yearlyEmissionsBaltimore <- NEI %>% 
    filter(fips == "24510") %>%
    group_by(year) %>% 
    summarise(total_emissions = sum(Emissions, na.rm=TRUE))

# Plot
png("plot2.png")
bplot <- with(yearlyEmissionsBaltimore, barplot(total_emissions,
                                       ylim=c(0,3500),
                                       las=1,
                                       main="Total Annual PM2.5 Emissions in Baltimore",
                                       names.arg=year,
                                       ylab = "Total PM2.5 Emissions (tons)"))

text(x = bplot, 
     y = yearlyEmissionsBaltimore$total_emissions+100, 
     labels = as.character(round(yearlyEmissionsBaltimore$total_emissions,2)))

dev.off()
