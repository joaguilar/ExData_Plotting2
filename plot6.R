download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",destfile="exdata-data-NEI_data.zip")
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Filter SCC by vehicles-related sources 
#For this we look for SCC observations that have the word "Vehicles" in the EI.Sector column
VehiclesSCC<-subset(SCC,grepl("Vehicles",EI.Sector))

#In addition we are only looking for vehicles in Baltimore City, Maryland (24510) and 
#Los Angeles, CA (06037). So we subset the NEI dataset for these two::
NEIBalLA<-subset(NEI,(fips=="24510" | fips=="06037"))

#Now we need to filter the NEI Baltimore/LA dataframe by the SCC sources we obtained previously:
NEIBALLAVehicles<-subset(NEIBalLA,(SCC %in% VehiclesSCC$SCC))

#And now it is necessary to obtain the totals per year:
NEIBALLAVehiclesTotalsPerYear<-aggregate(NEIBALLAVehicles$Emissions,by=list(NEIBALLAVehicles$year,NEIBALLAVehicles$fips),FUN=sum)
#And let's change the fips to human readable form:
locs<-NEIBALLAVehiclesTotalsPerYear$Group.2
locs<-as.factor(locs)
levels(locs)<-c("Los Angeles","Baltimore")
NEIBALLAVehiclesTotalsPerYear<-cbind(NEIBALLAVehiclesTotalsPerYear,locs)
colnames(NEIBALLAVehiclesTotalsPerYear)<-c("Year","fips","Emissions","Location")

#And finally we need to determine how they have changed. For this we'll use a line chart in ggplot 
#to show the behavior in those two locations through the 4 years
#In case ggplot is not installed:
install.package("ggplot2")
#Load the ggplot library:
library(ggplot2)

g<-qplot(Year,Emissions,data=NEIBALLAVehiclesTotalsPerYear,color=Location,geom=c("line"))
#Add title and labels for the X and Y Axis
g<-g+ylab("Total PM2.5 Emission from Motor Vehicle Sources")
g<-g+xlab("Year")
g<-g+ggtitle("PM2.5 Emission from Motor Vehicle Sources from 1999-2008 in Baltimore City and Los Angeles County, California")

png(filename="plot6.png",width=800,height=600,units='px')
print(g)
dev.off()