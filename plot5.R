download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",destfile="exdata-data-NEI_data.zip")
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Filter SCC by vehicles-related sources 
#For this we look for SCC observations that have the word "Vehicles" in the EI.Sector column
VehiclesSCC<-subset(SCC,grepl("Vehicles",EI.Sector))

#In addition we are only looking for vehicles in Baltimore City, Maryland. So we subset the
#NEI dataset for this:
NEIBaltimore<-subset(NEI,fips==24510)

#Now we need to filter the NEI Baltimore dataframe by the SCC sources we obtained previously:
NEIBALVehicles<-subset(NEIBaltimore,(SCC %in% VehiclesSCC$SCC))

#And now it is necessary to obtain the totals per year:
NEIBALVehiclesTotalsPerYear<-aggregate(NEIBALVehicles$Emissions,by=list(NEIBALVehicles$year),FUN=sum)
colnames(NEIBALVehiclesTotalsPerYear)<-c("Year","Emissions")

#And finally we need to determine how they have changed. For this we'll use regular plot to show
#how it has behaves in the four years:
png(filename="plot5.png",width=640,height=800,units='px')
plot(NEIBALVehiclesTotalsPerYear$Emissions ~ NEIBALVehiclesTotalsPerYear$Year,type="l",xlab="Year",ylab="Total PM2.5 Emission from Motor Vehicle Sources")
title(main="Emissions from Motor Vehicle Sources from 1999-2008 in Baltimore City")
dev.off()