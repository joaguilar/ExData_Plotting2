download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",destfile="exdata-data-NEI_data.zip")
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Filter SCC by coal combustion-related sources 
#For this we look for SCC observations that have the word "Coal" in the EI.Sector column
CoalCombSCC<-subset(SCC,grepl("Coal",EI.Sector))

#Now we need to filter the NEI dataframe by the SCC sources we obtained in the previous step:
NEICoalComb<-subset(NEI,(SCC %in% CoalCombSCC$SCC))

#And now it is necessary to obtain the totals per year:
NEICoalCombTotalsPerYear<-aggregate(NEICoalComb$Emissions,by=list(NEICoalComb$year),FUN=sum)
colnames(NEICoalCombTotalsPerYear)<-c("Year","Emissions")

#And finally we need to determine how they have changed. For this we'll use regular plot to show
#how it has behaves in the four years:
png(filename="plot4.png",width=640,height=800,units='px')
plot(NEICoalCombTotalsPerYear$Emissions ~ NEICoalCombTotalsPerYear$Year,type="l",xlab="Year",ylab="Total PM2.5 Emission from Coal Combustion-Related Sources")
title(main="Total PM2.5 Emission From Coal Combustion-Related Sources Per Year")
dev.off()