data<-read.csv("leagues_NBA_2013_14.csv") 
data<-subset(data,MP>855)
data<-data[,names(data)[-c(1,2,3,4,6,7,8,11,12,20)]]
#get rid of Player, Rk, Pos, etc
set.seed(1)
formula = as.formula(WinPct ~ PER + TSpct + ORBpct + DRBpct + TRBpct + ASTpct + STLpct + BLKpct + TOVpct + OWS + DWS + WS + WSp48 + OBPM + DBPM + BPM + VORP)
 rf = randomForest(formula, data=data, mtry=4, ntree=10000, importance=TRUE)
 importance(rf)
 data = data.frame(type=colnames(data[-c(1)]), importance(rf), check.names=F)
> data$type = reorder(data$type, data$`%IncMSE`)

 
           %IncMSE IncNodePurity
PER     24.4677099     0.3147944
TSpct   32.0671986     0.3251914
ORBpct  25.1316759     0.2268658
DRBpct  40.8944150     0.3110853
TRBpct  33.0586782     0.2776497
ASTpct  21.7789114     0.2170437
STLpct  16.8248134     0.1919708
BLKpct  15.1885151     0.1939016
TOVpct  -0.1880389     0.1978633
OWS     34.2151210     0.2332551
DWS     83.8572473     0.6927952
WS      38.7478916     0.3530879
WSp48  119.1658701     1.0545436
OBPM    33.3085306     0.2858194
DBPM    46.6181919     0.3570639
BPM     50.9006058     0.4407539
VORP    33.1430558     0.2710255

Residual standard error: 0.08048 on 242 degrees of freedom
Multiple R-squared:  0.7478,    Adjusted R-squared:   0.73 
F-statistic:  42.2 on 17 and 242 DF,  p-value: < 2.2e-16


fit<-lm(WinPct ~ PER + Ts_pct + ORBpct + DRBpct + TRBpct + ASTpct + STLpct + BLKpct + TOVpct + OWS + DWS + WS + WSp48 + OBPM + DBPM + BPM + VORP, data=data)
summary(fit)


> calc.relimp(fit, type = c("lmg"), rela = TRUE)
Response variable: WinPct 
Total response variance: 0.02399059 
Analysis based on 260 observations


Relative importance metrics: 
              lmg
PER    0.04295534
TSpct  0.04463005
ORBpct 0.08288074
DRBpct 0.08930307
TRBpct 0.08330451
ASTpct 0.01434808
STLpct 0.01687711
BLKpct 0.01422507
TOVpct 0.01408459
OWS    0.03636422
DWS    0.07873850
WS     0.05498343
WSp48  0.24913012
OBPM   0.02283433
DBPM   0.05401036
BPM    0.05793960
VORP   0.04339089
