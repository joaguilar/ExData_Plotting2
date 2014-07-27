download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",destfile="exdata-data-NEI_data.zip")
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#First we need to filter the data to only keep the observations for Baltimore
NEIBaltimore<-subset(NEI,fips==24510)

#Aggregate the data per year. Since the question was about the total, we sum up all observations
NEIBaltimoreTotalsPerYearAndType<-aggregate(NEIBaltimore$Emissions,by=list(NEIBaltimore$year,NEIBaltimore$type),FUN=sum)
colnames(NEIBaltimoreTotalsPerYearAndType)<-c("Year","Type","Emissions")

#In case ggplot is not installed:
install.package("ggplot2")
#Load the ggplot library:
library(ggplot2)

#Create the plot.
#We need to plot the year and emissions to get the points in the graph, thus the "Year" and "Emission" arguments.
#We also need to determine which types increase/decreased. For this we separate them using ggplot's facets and facet by type.
#AND, in addition to using facets, we create a "smoother", that will tell us if the trend is to
# increase or decrease. thus we use the "geom" argument, and the "lm" method, 
# that gives us the regression
#Finally we color the points and regression lines by type, to make it prettier.
g<-qplot(Year,Emissions,data=NEIBaltimoreTotalsPerYearAndType,facets= . ~ Type, geom=c("point","smooth"),method="lm",color=Type)

#Add title and labels for the X and Y Axis
g<-g+ylab("Total Emissions per Year")
g<-g+xlab("Year")
g<-g+ggtitle("Total Emissions per Year per Type")

#alternatively with the next line we would just split the types using "color", so they
#all end up in the same graph. It, however, was too confusing to read.
#g<-qplot(Year,
#          Emissions,
#          data=NEIBaltimoreTotalsPerYearAndType,
#          geom=c("point","smooth"),
#          method="lm",
#          color=Type)

#And finally save it to the file:
png(filename="plot3.png",width=800,height=600,units='px')
print(g)
dev.off()