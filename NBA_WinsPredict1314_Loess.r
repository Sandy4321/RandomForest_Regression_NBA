data<-read.csv("leagues_NBA_2013_14_total_edited.csv") 
 data<-subset(data,MP>855)
 cumMP <- by(data = data$MP, INDICES = data$Team, FUN = sum)
 cumMP.df <- data.frame(Team = names(cumMP), cumMP = as.numeric(cumMP))
 data <- merge(x=data, y=cumMP.df, by = "Team")
 data$WinPctMP <- with(data, WinPct * (MP/cumMP))
 
lm_eqn = function(data, y, x){
    m = lm(y ~ x, data);
    eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2, 
         list(a = format(coef(m)[1], digits = 2), 
              b = format(coef(m)[2], digits = 2), 
             r2 = format(summary(m)$r.squared, digits = 3)))
    as.character(as.expression(eq));                 
}

lm_eqn = function(m) {

  l <- list(a = format(coef(m)[1], digits = 2),
      b = format(abs(coef(m)[2]), digits = 2),
      r2 = format(summary(m)$r.squared, digits = 3));

  if (coef(m)[2] >= 0)  {
    eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2,l)
  } else {
    eq <- substitute(italic(y) == a - b %.% italic(x)*","~~italic(r)^2~"="~r2,l)    
  }

  as.character(as.expression(eq));                 
}

plot1<-ggplot(data, aes(x=WSp48, y=WinPctMP)) + geom_point(shape=1) + geom_smooth() + ggtitle("WinPctMP vs WSp48") +
			geom_text(aes(x = .2, y = .15, label = lm_eqn(lm(WinPctMP ~ WSp48, data))), size=3, parse = TRUE)
		

plot2<-ggplot(data, aes(x=VORP, y=WinPctMP)) + geom_point(shape=1) + geom_smooth() + ggtitle("WinPctMP vs VORP") +
			geom_text(aes(x = 7, y = .15, label = lm_eqn(lm(WinPctMP ~ VORP, data))), size=3, parse = TRUE)

plot3<-ggplot(data, aes(x=PER, y=WinPctMP)) + geom_point(shape=1) + geom_smooth() + ggtitle("WinPctMP vs PER")  +
			geom_text(aes(x = 20, y = .15, label = lm_eqn(lm(WinPctMP ~ PER, data))), size=3, parse = TRUE)

install.packages('gridExtra')
library(gridExtra)
require(gridExtra)
library(ggplot2)
 jpeg('Loess_WinPctMPvsWS_VORP_PER1.jpg')
 grid.arrange(plot1, plot2, plot3, nrow=3)
 dev.off()