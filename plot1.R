download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",destfile="exdata-data-NEI_data.zip")
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Aggregate the data per year. Since the question was about the total, we sum up all observations
NEITotalsPerYear<-aggregate(NEI$Emissions,by=list(NEI$year),FUN=sum)
colnames(NEITotalsPerYear)<-c("Year","Emissions")

png(filename="plot1.png",width=640,height=800,units='px')
plot(NEITotalsPerYear$Emissions ~ NEITotalsPerYear$Year,type="l",xlab="Year",ylab="Total PM2.5 Emission Per Year")
title(main="Total PM2.5 Emission From All Sources Per Year")
dev.off()