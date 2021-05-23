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
emissionsBaltimore <- NEI %>% 
    filter(fips == "24510") %>%
    group_by(year, type) %>% 
    summarise(total_emissions = sum(Emissions, na.rm=TRUE)) %>%
    mutate(year = as.character(year))

# Plot
gplot <- ggplot(emissionsBaltimore, aes(year, total_emissions))

gplot <- gplot + geom_bar(stat="identity") + facet_grid(type~.) 
gplot <- gplot + geom_text(aes(label=round(total_emissions,2)),
                           nudge_y = 210, size=3) 
gplot <- gplot + coord_cartesian(ylim = c(0, 2500)) 
gplot <- gplot + labs(title = "Baltimore Annual PM2.5 Emmisions for Various Sources", 
                      x="Year", y="PM2.5 Emissions (tons)")

ggsave("plot3.png")