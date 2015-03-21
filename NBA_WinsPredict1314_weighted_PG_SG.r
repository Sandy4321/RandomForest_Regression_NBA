data<-read.csv("leagues_NBA_2013_14_per_game_edited.csv") 
data<-subset(data,MP>855)

cumMP <- by(data = data$MP, INDICES = data$Team, FUN = sum)
 cumMP.df <- data.frame(Team = names(cumMP), cumMP = as.numeric(cumMP))
 data <- merge(x=data, y=cumMP.df, by = "Team")
 data$WinPctMP <- with(data, WinPct * (MP/cumMP))
 
 data<-subset(data,Pos=="PG" | Pos=="SG")
# we only want to look at Guards

set.seed(1)
formula = as.formula(WinPctMP ~ PER + TSpct + ORBpct + DRBpct + TRBpct + ASTpct + STLpct + BLKpct + TOVpct + OWS + DWS + WS + WSp48 + OBPM + DBPM + BPM + VORP + PTS + X3PA + X3P + FTA)
rf = randomForest(formula, data=data, mtry=4, ntree=10000, importance=TRUE)

importance(rf)
          %IncMSE IncNodePurity
PER     8.9177363  0.0015133655
TSpct  13.6009420  0.0014710848
ORBpct  0.5869792  0.0009638182
DRBpct  0.1395294  0.0011679780
TRBpct  4.3564316  0.0011863054
ASTpct -0.4751696  0.0008248672
STLpct 10.5411284  0.0011992820
BLKpct  8.1388223  0.0008566573
TOVpct -3.6467586  0.0010237032
OWS    40.5451551  0.0056658687
DWS    80.0998651  0.0111959316
WS     86.7460676  0.0153670587
WSp48  34.2957491  0.0052472237
OBPM   22.4739262  0.0020107723
DBPM   21.5663944  0.0018105740
BPM    35.4583132  0.0039139729
VORP   49.7338238  0.0078644263
PTS    20.1312617  0.0026937675
X3PA   23.3113082  0.0019684872
X3P    -1.9550024  0.0009523032
FTA     4.0139485  0.0021159335


data<-data[,names(data)[-c(1,2,3,4,5,6,7,8,9,10,35)]]
 fit<-lm(WinPctMP ~ PER + TSpct + ORBpct + DRBpct + TRBpct + ASTpct + STLpct + BLKpct + TOVpct + OWS + DWS + WS + WSp48 + OBPM + DBPM + BPM + VORP + PTS + X3PA + X3P + FTA, data=data)
summary(fit)


Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.1792741  0.0390822   4.587 1.56e-05 ***
PER         -0.0035432  0.0020070  -1.765 0.081129 .  
TSpct       -0.1206101  0.0636959  -1.894 0.061730 .  
ORBpct      -0.0152935  0.0057678  -2.652 0.009576 ** 
DRBpct      -0.0151031  0.0058181  -2.596 0.011134 *  
TRBpct       0.0292202  0.0116362   2.511 0.013949 *  
ASTpct      -0.0006127  0.0003388  -1.808 0.074172 .  
STLpct      -0.0035510  0.0034845  -1.019 0.311094    
BLKpct       0.0037859  0.0033193   1.141 0.257290    
TOVpct       0.0011719  0.0006601   1.775 0.079480 .  
OWS          0.0033252  0.0203138   0.164 0.870365    
DWS          0.0173788  0.0206996   0.840 0.403533    
WS           0.0131749  0.0200210   0.658 0.512303    
WSp48       -0.4622687  0.1341846  -3.445 0.000894 ***
OBPM        -0.0032529  0.0202269  -0.161 0.872622    
DBPM        -0.0157504  0.0205377  -0.767 0.445290    
BPM          0.0228247  0.0207941   1.098 0.275494    
VORP        -0.0254270  0.0049175  -5.171 1.56e-06 ***
PTS          0.0009731  0.0010974   0.887 0.377733    
X3PA        -0.0044582  0.0017916  -2.488 0.014806 *  
X3P         -0.0417380  0.0279972  -1.491 0.139762    
FTA         -0.0014577  0.0015281  -0.954 0.342851    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.009578 on 84 degrees of freedom
Multiple R-squared:  0.8954,    Adjusted R-squared:  0.8692 
F-statistic: 34.22 on 21 and 84 DF,  p-value: < 2.2e-16



data<-data[,names(data)[-c(7,8,9)]] #get rid of STL, BLK, TOV because they were very insignificant
 fit<-lm(WinPctMP ~ PER + TSpct + ORBpct + DRBpct + TRBpct + ASTpct + OWS + DWS + WS + WSp48 + OBPM + DBPM + BPM + VORP + PTS + X3PA + X3P + FTA, data=data)
summary(fit)

Call:
lm(formula = WinPctMP ~ PER + TSpct + ORBpct + DRBpct + TRBpct + 
    ASTpct + OWS + DWS + WS + WSp48 + OBPM + DBPM + BPM + VORP + 
    PTS + X3PA + X3P + FTA, data = data)

Residuals:
       Min         1Q     Median         3Q        Max 
-0.0299250 -0.0050811  0.0003218  0.0048687  0.0268266 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.1347986  0.0311629   4.326 4.04e-05 ***
PER         -0.0032096  0.0015800  -2.031  0.04527 *  
TSpct       -0.0424904  0.0466440  -0.911  0.36484    
ORBpct      -0.0174676  0.0056133  -3.112  0.00252 ** 
DRBpct      -0.0179844  0.0056205  -3.200  0.00192 ** 
TRBpct       0.0350647  0.0111135   3.155  0.00220 ** 
ASTpct      -0.0001997  0.0001877  -1.064  0.29035    
OWS          0.0035775  0.0204384   0.175  0.86146    
DWS          0.0162459  0.0208254   0.780  0.43745    
WS           0.0135150  0.0201341   0.671  0.50384    
WSp48       -0.5077975  0.1203622  -4.219 6.00e-05 ***
OBPM        -0.0062070  0.0203063  -0.306  0.76059    
DBPM        -0.0146265  0.0207271  -0.706  0.48228    
BPM          0.0223599  0.0208998   1.070  0.28764    
VORP        -0.0248070  0.0049590  -5.002 2.92e-06 ***
PTS          0.0009392  0.0009225   1.018  0.31149    
X3PA        -0.0030875  0.0016285  -1.896  0.06129 .  
X3P         -0.0375941  0.0278498  -1.350  0.18055    
FTA         -0.0015451  0.0014527  -1.064  0.29048    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.009688 on 87 degrees of freedom
Multiple R-squared:  0.8891,    Adjusted R-squared:  0.8662 
F-statistic: 38.76 on 18 and 87 DF,  p-value: < 2.2e-16


calc.relimp(fit, type = c("lmg"), rela = TRUE)
Response variable: WinPctMP 
Total response variance: 0.000701399 
Analysis based on 106 observations 

18 Regressors: 
PER TSpct ORBpct DRBpct TRBpct ASTpct OWS DWS WS WSp48 OBPM DBPM BPM VORP PTS X3PA X3P FTA 
Proportion of variance explained by model: 88.91%
Metrics are normalized to sum to 100% (rela=TRUE). 

Relative importance metrics: 

               lmg
PER    0.040792120
TSpct  0.021492652
ORBpct 0.009041976
DRBpct 0.010240608
TRBpct 0.010785643
ASTpct 0.008910471
OWS    0.097127859
DWS    0.170587906
WS     0.189819248
WSp48  0.073498025
OBPM   0.043510094
DBPM   0.039198250
BPM    0.059954031
VORP   0.104366935
PTS    0.055755133
X3PA   0.026690686
X3P    0.006065446
FTA    0.032162918

#WS, OWS, PTS and DWS have p-values greater than .05
#WSp48 and VORP have p-values less than .05