download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",destfile="exdata-data-NEI_data.zip")
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#First we need to filter the data to only keep the observations for Baltimore
NEIBaltimore<-subset(NEI,fips==24510)
#Aggregate the data per year. Since the question was about the total, we sum up all observations
NEIBaltimoreTotalsPerYear<-aggregate(NEIBaltimore$Emissions,by=list(NEIBaltimore$year),FUN=sum)
colnames(NEIBaltimoreTotalsPerYear)<-c("Year","Emissions")

png(filename="plot2.png",width=640,height=480,units='px')
plot(NEIBaltimoreTotalsPerYear$Emissions ~ NEIBaltimoreTotalsPerYear$Year,type="l",xlab="Year",ylab="Total PM2.5 Emission Per Year")
title(main="Total PM2.5 Emission in Baltimore City, Maryland (fips=24510)")
dev.off()