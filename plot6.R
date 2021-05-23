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
motoVehiclesEmmissions <- completeNEI %>% 
    filter((fips == "24510" | fips == "06037") & SCC.Level.One == "Mobile Sources") %>%
    mutate(city = ifelse(fips == "24510", "Baltimore City", "Los Angeles County")) %>%
    group_by(year, city) %>% 
    summarise(total_emissions = sum(Emissions, na.rm=TRUE))
    

# Plot
png("plot6.png")

bplot <- with(motoVehiclesEmmissions, 
              plot(year, total_emissions, col=factor(city), pch=19, xaxt="n",
                   ylim=c(0,17000), xlim=c(1998,2010),
                   xlab="Year", ylab="Total PM2.5 Emissions (tons)",
                   main="Total Annual PM2.5 Emissions from Motor Vehicles"))

axis(1, xaxp=c(1999, 2008, 3), las=1)
with(motoVehiclesEmmissions, text(year+1, total_emissions, 
                                  labels=as.character(round(total_emissions, 2)),
                                  cex=0.7))
legend("topright", legend=c("Los Angeles County", "Baltimore City"), col = c(2,1), pch = 19, cex = 0.7)
dev.off()

