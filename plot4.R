library(dplyr)
library(ggplot2)
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
completeNEI <- merge(NEI, SCC, by="SCC")
coalEmmissions <- completeNEI %>% 
    filter(SCC.Level.Four == "Coal") %>%
    group_by(year) %>% 
    summarise(total_emissions = sum(Emissions, na.rm=TRUE)) %>%
    mutate(year = as.character(year))


# Plot
png("plot4.png")
bplot <- with(coalEmmissions, barplot(total_emissions, names.arg = year,
                                      ylim=c(0, 2500), 
                                      main="Total Annual PM2.5 Emissions Related to Coal in USA",
                                      ylab = "Total PM2.5 Emissions (tons)"))

text(x=bplot, y=coalEmmissions$total_emissions+100,
     labels = as.character(round(coalEmmissions$total_emissions,2)))
dev.off()
