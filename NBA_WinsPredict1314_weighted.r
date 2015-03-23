#This new model replaces the player's WinPct, which is the team's winning percentage, by
#adjusting it so that the WinPct is multipled by the fraction of the team's minutes that the player plays
#That is, WinPctMP = WinPct*MP/(Team's total MP)

#For example, Jeremy Lamb of OKC had a WSp48 of .102 (ranked #171) while Reggie Jackson had .104 (#167)
#However, after using WinPctMP instead of WinPct as the response variable, now VORP becomes a more 
#significant predictor, due to its updated relative importance and %IncMSE values being much higher
#for WinPctMP than for WinPct
#Jeremy Lamb has a VORP of .3 (#201) and Reggie Jackson has a VORP of .9 (#128)
#What this means is that, because Reggie Jackson has a much higher MP and thus played in a much greater fraction
# of OKC's minutes, the WinPctMP model assumes he should affect the team more positively than Jeremy Lamb
#because his coach trusted him more and he played more against competitive players while more of Jeremy Lamb's
#minutes may have come against less competitive players when the game had less importance

#Similarly, Brandom Wright of DAL had a WSp48 of .227 (#8), but VORP of 1.5 (#87)


data<-read.csv("leagues_NBA_2013_14_total_edited.csv") 
 data<-subset(data,MP>855)
 cumMP <- by(data = data$MP, INDICES = data$Team, FUN = sum)
 cumMP.df <- data.frame(Team = names(cumMP), cumMP = as.numeric(cumMP))
 data <- merge(x=data, y=cumMP.df, by = "Team")
 data$WinPctMP <- with(data, WinPct * (MP/cumMP))
 
 set.seed(1)
 formula = as.formula(WinPctMP ~ PER + TSpct + ORBpct + DRBpct + TRBpct + ASTpct + STLpct + BLKpct + TOVpct + OWS + DWS + WS + WSp48 + OBPM + DBPM + BPM + VORP)
rf = randomForest(formula, data=data, mtry=4, ntree=10000, importance=TRUE)
 importance(rf)
 
            %IncMSE IncNodePurity
PER     22.1442385   0.004611104
TSpct   22.5793361   0.003557686
ORBpct  41.6688713   0.004481929
DRBpct  33.6812543   0.003895361
TRBpct  39.4379303   0.004025743
ASTpct  14.9810146   0.003286153
STLpct  23.7869581   0.002971363
BLKpct  26.3146500   0.003421060
TOVpct   0.6684798   0.002565035
OWS     54.7647444   0.016180859
DWS    122.7087019   0.030202987
WS     112.2018334   0.041211703
WSp48   28.0443861   0.006874092
OBPM    32.2541651   0.005677378
DBPM    27.5989847   0.003025654
BPM     46.6140253   0.010544775
VORP    68.7299022   0.023757447
#VORP's %IncMSE is now twice as high as WSp48 and half as much as DWS and WS
#whereas previously it was about 1/4 as much as WSp48

#Although WS and DWS have the highest %IncMSE values, they have p-values greater than .05
#as seen in the linear regression below

 data<-data[,names(data)[-c(1,2,3,4,5,6,7,8,11,12,20,29)]]
 
 
 fit<-lm(WinPctMP ~ PER + TSpct + ORBpct + DRBpct + TRBpct + ASTpct + STLpct + BLKpct + TOVpct + OWS + DWS + WS + WSp48 + OBPM + DBPM + BPM + VORP, data=data)
summary(fit)

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.0976784  0.0177054   5.517 8.85e-08 ***
PER         -0.0008353  0.0004968  -1.681   0.0940 .  
TSpct       -0.0552238  0.0350583  -1.575   0.1165    
ORBpct      -0.0108770  0.0025962  -4.190 3.92e-05 ***
DRBpct      -0.0116537  0.0026679  -4.368 1.86e-05 ***
TRBpct       0.0214612  0.0053382   4.020 7.77e-05 ***
ASTpct      -0.0002380  0.0001835  -1.297   0.1958    
STLpct      -0.0064417  0.0015702  -4.103 5.59e-05 ***
BLKpct      -0.0014546  0.0008849  -1.644   0.1015    
TOVpct       0.0004521  0.0003331   1.357   0.1760    
OWS          0.0085667  0.0119396   0.718   0.4738    
DWS          0.0198554  0.0119991   1.655   0.0993 .  
WS           0.0015938  0.0119614   0.133   0.8941    
WSp48       -0.2312581  0.0495835  -4.664 5.13e-06 ***
OBPM         0.0028693  0.0125538   0.229   0.8194    
DBPM         0.0008954  0.0127027   0.070   0.9439    
BPM          0.0042474  0.0126963   0.335   0.7383    
VORP        -0.0123516  0.0024795  -4.981 1.20e-06 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.009706 on 242 degrees of freedom
Multiple R-squared:  0.8694,    Adjusted R-squared:  0.8602 
F-statistic: 94.76 on 17 and 242 DF,  p-value: < 2.2e-16





calc.relimp(fit, type = c("lmg"), rela = TRUE)
Response variable: WinPctMP 
Total response variance: 0.000673936 
Analysis based on 260 observations 

17 Regressors: 
PER TSpct ORBpct DRBpct TRBpct ASTpct STLpct BLKpct TOVpct OWS DWS WS WSp48 OBPM DBPM BPM VORP 
Proportion of variance explained by model: 86.94%
Metrics are normalized to sum to 100% (rela=TRUE). 

Relative importance metrics: 

               lmg
PER    0.037658972
TSpct  0.018814869
ORBpct 0.019207352
DRBpct 0.017862465
TRBpct 0.018743270
ASTpct 0.008814195
STLpct 0.017351110
BLKpct 0.011974787
TOVpct 0.006595656
OWS    0.100031805
DWS    0.216329188
WS     0.211007829
WSp48  0.063761125
OBPM   0.047968993
DBPM   0.027084154
BPM    0.064992246
VORP   0.111801983
#as seen above, OWS, DWS, and WS have p-values greater than .05
