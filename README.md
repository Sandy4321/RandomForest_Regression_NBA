# RandomForest_Regression_NBA
Random forest, regression and other statistical analysis on NBA data sets


In NBA_WinsPredict1415.r, I data obtained from http://www.basketball-reference.com/leagues/NBA_2015_advanced.html
I also modified the file so that WinPct is the winning percentage of the player's team as of 3/19/15

I wanted to predict which player statistic best predicts the team's winning percentage

I performed a Random Forest on nearly every predictor statistic variable
The results are displayed in ggplot_RF.jpg
Based on this, WSp48(player's win shares per 48 minutes) best predicts a team's win, 
followed by DWS (defensive win shares). 
It seems strange that WSp48 and DWS are greater predictors of a team's victories
than OWS and WS since WS is just OWS+DWS

I then performed a multiple linear regression on that same dataset.
PER,ORBpct,DRBpct,TRBpct,ASTpct,TOVpct,WSp48,OBPM,DBPM,BPM all have p-values less than 0.05
However, OWS,DWS, and WS all have p-values greater than .74
Using the relimp, the variables with highest relative importance were WSp48, ORBpct, DRBpct, and TRBpct


I also wanted to see if the regression and random forest would be any different if I focused only on guards (PG) and (SG). The statistical analysis for only Guards is in "NBA_WinsPredict1314_weighted_PG_SG.r"


In PTPM.r, I downloaded data from  https://docs.google.com/spreadsheets/d/1GtCDQw94kpcOw_kPhyH8F5cIjPT3QTsOGqvrX_hMCo8/edit?pli=1#gid=0
I used a multiple linear regression to determine which variables had the greatest impact on the team's winning percentage
TeamDefEffect had the highest relative importance value, but it's p-value is .585

I also wanted to see which of PTPM, WSp48 and VORP best predicts the team win percentage for a given player. The R-script is in "NBA_WinsPredict1415_WS_VORP_vsPTPM.r"


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/jk34/randomforest_regression_nba/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

