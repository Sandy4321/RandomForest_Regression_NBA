#http://rpubs.com/jimhester/nba
#data from https://docs.google.com/spreadsheets/d/1GtCDQw94kpcOw_kPhyH8F5cIjPT3QTsOGqvrX_hMCo8/edit?pli=1#gid=0
#meaning of data explained below:
#http://nyloncalculus.com/2014/10/27/2014-2015-highly-plausible-win-projections-pt-pm-aspm-editions/
#http://forums.realgm.com/boards/viewtopic.php?t=1374892
#http://nyloncalculus.com/2015/02/11/half-season-player-tracking-plus-minus-rankings/

stats<-read.csv("PT-PM Half Season Scores.csv") 
#I also modified file so that WinPct is the winning percentage of the player's team as of 3/19/15

fit <- lm(WinPct ~ PTPM + PTPM + PTPM + Scoring + Passing + OffPoss + RimProtection + DefPoss + TeamDefEffect + StablizedPTPM , data=stats)
summary(fit)
#StablizedPTPM had the lowest p-value of .0554. 

> install.packages('relaimpo')
> drops <- c("PLAYER_ID","PLAYER","Team")
> stats <- subset(stats, select = -c(PLAYER_ID,PLAYER,TEAM) )
 calc.relimp(stats, type = c("lmg"), rela = TRUE)
 #Proportion of variance explained by model: 35.8%
 #Relative importance metrics: 

                     # lmg
#OPTPM         0.079888591
#DPTPM         0.116700858
#PTPM          0.155418971
##Scoring       0.041484629
#Passing       0.016706809
#OffPoss       0.007046756
#RimProtection 0.064785371
#DefPoss       0.045745349
#TeamDefEffect 0.305660718
#StablizedPTPM 0.166561948

#TeamDefEffect has the highest value, but it's p-value is .585