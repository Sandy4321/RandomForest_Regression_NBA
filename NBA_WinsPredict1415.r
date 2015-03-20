data<-read.csv("leagues_NBA_2015_advanced_advanced.csv") 
#data obtained from http://www.basketball-reference.com/leagues/NBA_2015_advanced.html
#I also modified file so that WinPct is the winning percentage of the player's team as of 3/19/15

data<-subset(data,MP>855)
data<-data[,names(data)[-c(1,2,3,4,6,7,8,11,12,20)]]
#get rid of Player, Rk, Pos, etc
set.seed(1)
formula = as.formula(WinPct ~ PER + Ts_pct + ORBpct + DRBpct + TRBpct + ASTpct + STLpct + BLKpct + TOVpct + OWS + DWS + WS + WSp48 + OBPM + DBPM + BPM + VORP)
 rf = randomForest(formula, data=data, mtry=4, ntree=10000, importance=TRUE)
 importance(rf)
 jpeg('rfplot.jpg')
varImpPlot(rf)
dev.off()


data = data.frame(type=colnames(data[-c(1)]), importance(rf), check.names=F)
> data$type = reorder(data$type, data$`%IncMSE`)

 jpeg('ggplot_RF.jpg')
ggplot(data=data, aes(x=type, y=`%IncMSE`)) + geom_bar(stat='identity') + geom_hline(yintercept=abs(min(data$`%IncMSE`)), col=2, linetype='dashed') + coord_flip()
dev.off()

#based on this, WSp48(player's win shares per 48 minutes) best predicts a team's win, 
#followed by DWS (defensive win shares). 
#It seems strange that WSp48 and DWS are greater predictors of a team's victories
#than OWS and WS since WS is just OWS+DWS


fit<-lm(WinPct ~ PER + Ts_pct + ORBpct + DRBpct + TRBpct + ASTpct + STLpct + BLKpct + TOVpct + OWS + DWS + WS + WSp48 + OBPM + DBPM + BPM + VORP, data=data)
summary(fit)
#PER,ORBpct,DRBpct,TRBpct,ASTpct,TOVpct,WSp48,OBPM,DBPM,BPM all have p-values less than 0.05
#However, OWS,DWS, and WS all have p-values greater than .74

calc.relimp(data, type = c("lmg"), rela = TRUE)
Relative importance metrics: 

#               lmg
#PER    0.068253540
##Ts_pct 0.017154726
#ORBpct 0.146613076
#DRBpct 0.167435788
#TRBpct 0.156744697
#ASTpct 0.013575950
#STLpct 0.004440579
#BLKpct 0.007663018
#TOVpct 0.014909587
#OWS    0.032333799
#DWS    0.048049711
#WS     0.048577486
#WSp48  0.121765270
#OBPM   0.030760239
#DBPM   0.038281717
#BPM    0.033949218
#VORP   0.049491599