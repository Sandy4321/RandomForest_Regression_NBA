  #for VORP vs Season
  data<-read.csv("BGvsKHvsLuolvsKobevsRWvsRose.csv")
 data<-data[,names(data)[-c(3:8)]]
 dataVORP<-data[,names(data)[-c(3:4)]]
 plot1<-ggplot(dataVORP, aes(Season, VORP, colour=Player)) + 
+ geom_line(aes(group=Player))+ geom_point() +  theme(legend.position="top")

#for WSp48 vs Season
dataWSp<-data[,names(data)[-c(4:5)]]
plot2<-ggplot(dataWSp, aes(Season, WSp48, colour=Player))  +
+  geom_line(aes(group=Player))+ geom_point() +  theme(legend.position="top")

install.packages('gridExtra')
library(gridExtra)
require(gridExtra)
library(ggplot2)
 jpeg('LineChart_VORP_WSpvsSeason.jpg')
 grid.arrange(plot1, plot2, nrow=2)
 dev.off()