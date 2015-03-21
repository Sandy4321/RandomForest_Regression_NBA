data<-read.csv("leagues_NBA_2014_15__WS_VORPvsPTPM.csv") 
data<-subset(data,MP>855)
data <- subset(data,!(is.na(data$OPTPM)))
#remove players like Markieff Moore who are not in the PTPM dataset
#only 3 players removed this way

cumMP <- by(data = data$MP, INDICES = data$Team, FUN = sum)
 cumMP.df <- data.frame(Team = names(cumMP), cumMP = as.numeric(cumMP))
 data <- merge(x=data, y=cumMP.df, by = "Team")
 data$WinPctMP <- with(data, WinPct * (MP/cumMP))
 
  set.seed(1)
  formula = as.formula(WinPctMP ~ OPTPM + DPTPM +PTPM + PER + Ts_pct + ORBpct + DRBpct + TRBpct + ASTpct + STLpct + BLKpct + TOVpct + OWS + DWS + WS + WSp48 + OBPM + DBPM + BPM + VORP)
rf = randomForest(formula, data=data, mtry=4, ntree=10000, importance=TRUE)
  importance(rf)
          %IncMSE IncNodePurity
OPTPM  20.0641726   0.005384693
DPTPM  22.4343473   0.005385369
PTPM   34.8240650   0.010689629
PER    34.4158320   0.005982420
Ts_pct  1.9382874   0.004547998
ORBpct 34.3894437   0.005778808
DRBpct 24.6892623   0.004801385
TRBpct 30.1093165   0.004952339
ASTpct 10.6181424   0.004115286
STLpct  0.2019059   0.003706626
BLKpct 25.4444006   0.004394576
TOVpct  1.8344573   0.003463842
OWS    54.3540444   0.016056647
DWS    79.8069062   0.022895218
WS     88.6560034   0.032412195
WSp48  33.9524671   0.008719400
OBPM   23.9140420   0.005850170
DBPM   18.4507113   0.004305332
BPM    35.9879006   0.011316331
VORP   65.3150274   0.024002529


fit<-lm(WinPctMP ~ OPTPM + DPTPM +PTPM + PER + Ts_pct + ORBpct + DRBpct + TRBpct + ASTpct + OWS + DWS + WS + WSp48 + OBPM + DBPM + BPM + VORP, data=data)
summary(fit)

Call:
lm(formula = WinPctMP ~ OPTPM + DPTPM + PTPM + PER + Ts_pct + 
    ORBpct + DRBpct + TRBpct + ASTpct + OWS + DWS + WS + WSp48 + 
    OBPM + DBPM + BPM + VORP, data = data)

Residuals:
      Min        1Q    Median        3Q       Max 
-0.036131 -0.011470 -0.001777  0.010313  0.047089 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.0554278  0.0249251   2.224 0.027239 *  
OPTPM       -0.1387920  0.2332895  -0.595 0.552534    
DPTPM       -0.1403616  0.2333110  -0.602 0.548091    
PTPM         0.1398824  0.2333168   0.600 0.549466    
PER         -0.0023361  0.0006846  -3.412 0.000774 ***
Ts_pct       0.0200096  0.0442982   0.452 0.651954    
ORBpct      -0.0141980  0.0047423  -2.994 0.003088 ** 
DRBpct      -0.0151813  0.0047462  -3.199 0.001597 ** 
TRBpct       0.0291865  0.0094629   3.084 0.002317 ** 
ASTpct       0.0001180  0.0001909   0.619 0.536915    
OWS          0.0343716  0.0251768   1.365 0.173662    
DWS          0.0515167  0.0253223   2.034 0.043176 *  
WS          -0.0227736  0.0254732  -0.894 0.372343    
WSp48       -0.2164986  0.1016706  -2.129 0.034396 *  
OBPM         0.0176619  0.0227983   0.775 0.439396    
DBPM         0.0133964  0.0227577   0.589 0.556732    
BPM         -0.0137085  0.0228953  -0.599 0.549993    
VORP        -0.0063936  0.0062036  -1.031 0.303909    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.01574 on 208 degrees of freedom
Multiple R-squared:  0.7365,    Adjusted R-squared:  0.715 
F-statistic:  34.2 on 17 and 208 DF,  p-value: < 2.2e-16





calc.relimp(fit, type = c("lmg"), rela = TRUE)
Response variable: WinPctMP 
Total response variance: 0.0008689318 
Analysis based on 226 observations 

17 Regressors: 
OPTPM DPTPM PTPM PER Ts_pct ORBpct DRBpct TRBpct ASTpct OWS DWS WS WSp48 OBPM DBPM BPM VORP 
Proportion of variance explained by model: 73.65%
Metrics are normalized to sum to 100% (rela=TRUE). 

Relative importance metrics: 

               lmg
OPTPM  0.035575825
DPTPM  0.018661188
PTPM   0.038632049
PER    0.046377590
Ts_pct 0.020778680
ORBpct 0.019026222
DRBpct 0.020553565
TRBpct 0.020744327
ASTpct 0.009950921
OWS    0.103921424
DWS    0.175977938
WS     0.187552758
WSp48  0.056447496
OBPM   0.044465156
DBPM   0.024691549
BPM    0.065392041
VORP   0.111251271

Only PER, ORBpct, DRBpct, TRBpct, DWS, and WSp48 have p-values less than .05
