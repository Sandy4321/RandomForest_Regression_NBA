install.packages("plyr")
library(plyr)
 install.packages("ggplot2")

 data<-read.csv("leagues_NBA_2014_15__WS_VORPvsPTPM.csv") 
  data<-subset(data,MP>855)
> data <- subset(data,!(is.na(data$OPTPM)))
 cumMP <- by(data = data$MP, INDICES = data$Team, FUN = sum)
  cumMP.df <- data.frame(Team = names(cumMP), cumMP = as.numeric(cumMP))
  data <- merge(x=data, y=cumMP.df, by = "Team")
  data$WinPctMP <- with(data, WinPct * (MP/cumMP))
 data<-data[,names(data)[-c(1,2,4,5,6,7,8,14,15,20,21,22,23,32)]]
  data<-data[c(1,19,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18)]#put WinPctMP next to Player name
 data<-data[,names(data)[-c(7,11,16,17,18)]] #get rid of Ts_pct, ASTpct, etc
 data<-data[,names(data)[-c(7,8,9)]] #get rid of ORBpct DRBpct TRBpct
 data<-data[,names(data)[-c(3,4,7)]] #get rid of OPTPM DPTPM OWS
 install.packages("reshape")
 library(reshape)
install.packages("scales")
 install.packages("colorspace")
 library(colorspace)
 library(scales)
  datanew<-data[order(data[,2],decreasing=TRUE),]
datanew<- head(datanew,15)
data.m<-melt(datanew)

 > data.m <- ddply(data.m, .(variable), transform,rescale=rescale(value))
  library(ggplot2)
  jpeg('WSvsVORPvsPTPM_top15_Heatmap.jpg')
 (p <- ggplot(data.m, aes(variable, Player)) + geom_tile(aes(fill = rescale), colour = "white") 
 + scale_fill_gradient(low = "white",    high = "steelblue"))
dev.off()
#This is heatmap for only the players with the top 15 values of WinPctMP