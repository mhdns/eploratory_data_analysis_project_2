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
yearlyEmissions <- NEI %>% 
    group_by(year) %>% 
    summarise(total_emissions = sum(Emissions, na.rm=TRUE)) %>% 
    mutate(total_emissions_mil = round(total_emissions/1000000,2))

# Plot
png("plot1.png")
bplot <- with(yearlyEmissions, barplot(total_emissions_mil,
                                       ylim=c(0,8), las=1,
                                       main="Total Annual PM2.5 Emissions in USA",
                                       names.arg=year,
                                       ylab = "Total PM2.5 Emissions (Million tons)"))

text(x = bplot, 
     y = yearlyEmissions$total_emissions_mil+0.5, 
     labels = as.character(yearlyEmissions$total_emissions_mil))

dev.off()
