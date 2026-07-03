data sales;
format Quarter yyq6.;
input Quarter : yyq6. Sales;
datalines;
2016Q1 900
2016Q2 980
2016Q3 1020
2016Q4 1150
2017Q1 1100
2017Q2 1200
2017Q3 1250
2017Q4 1400
2018Q1 1350
2018Q2 1480
2018Q3 1550
2018Q4 1720
2019Q1 1650
2019Q2 1800
2019Q3 1880
2019Q4 2100
2020Q1 2000
2020Q2 1900
2020Q3 2050
2020Q4 2300
2021Q1 2250
2021Q2 2450
2021Q3 2550
2021Q4 2850
2022Q1 2750
2022Q2 3000
2022Q3 3150
2022Q4 3500
2023Q1 3350
2023Q2 3650
2023Q3 3800
2023Q4 4200
2024Q1 4000
2024Q2 4350
2024Q3 4550
2024Q4 5000
2025Q1 4800
2025Q2 5200
2025Q3 5450
2025Q4 6000
;
run;

proc sgplot data=sales;
series x=Quarter y=Sales / markers;
xaxis label="Year";
yaxis label="sales (ZAR '000)";
title "Quarterly Sales (2016-2025)";
run;
proc arima data=sales;
identify var=Sales stationarity=(adf);
run;
quit;
proc arima data=sales;
identify var=Sales(1);	/* First difference */
run;
proc arima data=sales;
identify var=Sales(1,4); /* First difference + seasonal difference (quarterly) */
run;
proc arima data=sales;
identify var=Sales(1,4) nlag=16;
run;
quit;
/* Model A - ARIMA(0,1,1)(0,1,1)4 */
proc arima data=sales;
identify var=Sales(1,4) noprint;
estimate q=1 q=(4) method=ml;
title "Model A: ARIMA(0,1,1)(0,1,1)4";
run;
/* Model B - ARIMA(0,1,1)(1,1,0)4 */
proc arima data=sales;
identify var=Sales(1,4) noprint;
estimate q=1 p=(4) method=ml;
title "Model B: ARIMA(0,1,1)(1,1,0)4";
run;
/* Model C - ARIMA(0,1,0)(0,1,1)4 */
proc arima data=sales;
identify var=Sales(1,4) noprint;
estimate q=(4) method=ml;
title "Model C: ARIMA(0,1,0)(0,1,1)4";
run;
/* Model D - ARIMA(0,1,1)(0,1,2)4 */
proc arima data=sales;
identify var=Sales(1,4) noprint;
estimate q=1 q=(4,8) method=ml;
title "Model D: ARIMA(0,1,1)(0,1,2)4";
run;
proc arima data=sales;
identify var=Sales(1,4) noprint;
estimate q=(4) method=ml;
/* Ljung-Box test for residual autocorrelation */
check q=12;
/* Generate forecasts and residuals */
forecast lead=8 out=forecast_results;
run;
/* Normality test on residuals */
data residuals;
set forecast_results;
residual = Sales - forecast;
run;
proc univariate data=residuals normal;
var residual;
histogram residual / normal;
title "Figure: Residual Distribution with Normality Curve";
run;
data sales;
set sales;
time = _n_;
run;

proc arima data=sales;
identify var=Sales(1,4);
estimate q=(4) method=ml;
forecast lead=8 out=forecast_results;
run;
quit;

data forecast_results;
set forecast_results;
obs_num = _n_;
length Quarter $ 8;

if obs_num <= 40 then do;
    Year = 2016 + floor((obs_num-1)/4);
    Qnum = mod(obs_num-1, 4) + 1;
    Quarter = cats(Year, " Q", Qnum);
end;
else do;
    Year = 2026 + floor((obs_num-41)/4);
    Qnum = mod(obs_num-41, 4) + 1;
    Quarter = cats(Year, " Q", Qnum);
end;
drop Year Qnum;
run;
proc print data=forecast_results(where=(obs_num >= 41)) noobs;
var Quarter forecast l95 u95;
format forecast l95 u95 comma8.0;
title "Table 16: Sales Forecast for 2026-2027 (ZAR '000)";
run;
proc sgplot data=forecast_results;
where obs_num >= 33;
series x=obs_num y=Sales / lineattrs=(color=blue thickness=2) legendlabel="Actual Sales";
series x=obs_num y=forecast / lineattrs=(color=red thickness=2 pattern=dash) legendlabel="Forecast";
band x=obs_num lower=l95 upper=u95 / transparency=0.5 legendlabel="95% Confidence Band";
xaxis label="Year and Quarter" 
       values=(33 to 48 by 1)
       valueattrs=(size=6)
       valuesdisplay=("2024 Q1" "2024 Q2" "2024 Q3" "2024 Q4"
                      "2025 Q1" "2025 Q2" "2025 Q3" "2025 Q4"
                      "2026 Q1" "2026 Q2" "2026 Q3" "2026 Q4"
                      "2027 Q1" "2027 Q2" "2027 Q3" "2027 Q4");
yaxis label="Sales (ZAR '000)" grid;
title "Figure 2: Actual and Forecasted Sales (2024-2027)";
run;



