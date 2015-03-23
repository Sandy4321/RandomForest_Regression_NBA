data<-read.csv("leagues_NBA_2013_14_total_edited.csv") 
 data<-subset(data,MP>855)
 cumMP <- by(data = data$MP, INDICES = data$Team, FUN = sum)
 cumMP.df <- data.frame(Team = names(cumMP), cumMP = as.numeric(cumMP))
 data <- merge(x=data, y=cumMP.df, by = "Team")
 data$WinPctMP <- with(data, WinPct * (MP/cumMP))
 
 fit<-lm(WinPctMP ~ WSp48, data=data)
 plot1<-ggplot(data, aes(x=WSp48, y=WinPctMP)) +
+     geom_point(shape=1) +    
+     geom_smooth() + ggtitle("WinPctMP vs WSp48")

plot2<-ggplot(data, aes(x=VORP, y=WinPctMP)) +
+     geom_point(shape=1) +    
+     geom_smooth() + ggtitle("WinPctMP vs VORP")

plot3<-ggplot(data, aes(x=PER, y=WinPctMP)) +
+     geom_point(shape=1) +    
+     geom_smooth() + ggtitle("WinPctMP vs PER")

install.packages('gridExtra')
library(gridExtra)
require(gridExtra)
library(ggplot2)
 jpeg('Loess_WinPctMPvsWS_VORP_PER.jpg')
 grid.arrange(plot1, plot2, plot3, nrow=3)
 dev.off()