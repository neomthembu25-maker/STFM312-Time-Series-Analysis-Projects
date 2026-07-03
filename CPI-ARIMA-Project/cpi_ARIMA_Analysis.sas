/* ================================================================ */
/* STFM 312 ARIMA PROJECT - COMPLETE SAS CODE                      */
/* Time Series Analysis of South African Consumer Price Index (CPI) */
/* Student: Neo Mthembu                                             */
/* Student Number: 36321389                                         */
/* Due Date: 09 May 2026                                            */
/* ================================================================ */


/* ================================================================ */
/* STEP 1: INPUT DATA                                               */
/* ================================================================ */

data cpi_data;
    input year quarter $ cpi;
    date = input(cats(year, quarter), yyq6.);
    format date yyq6.;
    drop year quarter;
    datalines;
2015 Q1 5.1
2015 Q2 6.0
2015 Q3 4.3
2015 Q4 5.2
2016 Q1 6.9
2016 Q2 5.3
2016 Q3 5.5
2016 Q4 5.1
2017 Q1 4.9
2017 Q2 4.0
2017 Q3 4.6
2017 Q4 3.8
2018 Q1 4.1
2018 Q2 5.0
2018 Q3 3.8
2018 Q4 4.4
2019 Q1 4.4
2019 Q2 4.5
2019 Q3 3.1
2019 Q4 3.2
2020 Q1 4.4
2020 Q2 2.0
2020 Q3 3.6
2020 Q4 2.9
2021 Q1 2.7
2021 Q2 2.9
2021 Q3 3.7
2021 Q4 4.0
2022 Q1 3.9
2022 Q2 5.0
2022 Q3 5.5
2022 Q4 5.5
2023 Q1 4.5
2023 Q2 4.8
2023 Q3 4.1
2023 Q4 4.6
2024 Q1 5.8
2024 Q2 3.6
2024 Q3 2.8
2024 Q4 2.8
2025 Q1 4.0
2025 Q2 2.4
2025 Q3 3.2
;
run;


/* ================================================================ */
/* STEP 2: SUMMARY STATISTICS                                      */
/* ================================================================ */

proc means data=cpi_data n mean median stddev min max;
    var cpi;
    title "Table 1: Summary Statistics of South African CPI (2015 Q1 - 2025 Q3)";
run;


/* ================================================================ */
/* STEP 3: PLOT ORIGINAL SERIES                                    */
/* ================================================================ */

proc sgplot data=cpi_data;
    series x=date y=cpi / markers markerattrs=(symbol=circle color=blue size=8)
                           lineattrs=(color=red thickness=2);
    xaxis label="Quarter (2015 Q1 - 2025 Q3)" valuesformat=yyq6.;
    yaxis label="CPI Inflation Rate (%)" min=0 max=8;
    title "Figure 1: South African Quarterly CPI Inflation Rate (2015 Q1 - 2025 Q3)";
run;


/* ================================================================ */
/* STEP 4: STATIONARITY TEST - ORIGINAL SERIES                     */
/* ================================================================ */

proc arima data=cpi_data;
    identify var=cpi stationarity=(adf=(0,1,2));
    title "Table 2: ADF Unit Root Test - Original CPI Series";
run;


/* ================================================================ */
/* STEP 5: FIRST DIFFERENCING (d=1)                                */
/* ================================================================ */

proc arima data=cpi_data;
    identify var=cpi(1) stationarity=(adf=(0,1,2)) nlag=12;
    title "Table 3: ADF Unit Root Test - First Differenced Series (d=1)";
run;

/* Plot the differenced series */
data cpi_diff;
    set cpi_data;
    diff_cpi = dif(cpi);
    format date yyq6.;
run;

proc sgplot data=cpi_diff;
    series x=date y=diff_cpi / markers markerattrs=(symbol=circle color=blue size=6)
                              lineattrs=(color=red thickness=2);
    refline 0 / axis=y lineattrs=(color=gray pattern=2);
    xaxis label="Quarter (2015 Q1 - 2025 Q3)" valuesformat=yyq6.;
    yaxis label="First Difference of CPI (%)";
    title "Figure 2: First Differenced CPI Series (d=1)";
run;


/* ================================================================ */
/* STEP 6: ACF AND PACF OF DIFFERENCED SERIES                      */
/* ================================================================ */

proc arima data=cpi_data;
    identify var=cpi(1) nlag=12;
    title "Figure 3: ACF and PACF of First-Differenced CPI Series";
run;


/* ================================================================ */
/* STEP 7: ESTIMATE CANDIDATE MODELS                               */
/* ================================================================ */

/* MODEL 1: ARIMA(1,1,0) */
proc arima data=cpi_data;
    identify var=cpi(1) noprint;
    estimate p=1 q=0 method=ml;
    title "Table 4a: ARIMA(1,1,0) - Candidate Model 1";
run;

/* MODEL 2: ARIMA(0,1,1) */
proc arima data=cpi_data;
    identify var=cpi(1) noprint;
    estimate p=0 q=1 method=ml;
    title "Table 4b: ARIMA(0,1,1) - Candidate Model 2";
run;

/* MODEL 3: ARIMA(1,1,1) */
proc arima data=cpi_data;
    identify var=cpi(1) noprint;
    estimate p=1 q=1 method=ml;
    title "Table 4c: ARIMA(1,1,1) - Candidate Model 3";
run;

/* MODEL 4: ARIMA(2,1,0) */
proc arima data=cpi_data;
    identify var=cpi(1) noprint;
    estimate p=2 q=0 method=ml;
    title "Table 4d: ARIMA(2,1,0) - Candidate Model 4";
run;

/* MODEL 5: ARIMA(0,1,2) */
proc arima data=cpi_data;
    identify var=cpi(1) noprint;
    estimate p=0 q=2 method=ml;
    title "Table 4e: ARIMA(0,1,2) - Candidate Model 5";
run;

/* MODEL 6: ARIMA(2,1,1) */
proc arima data=cpi_data;
    identify var=cpi(1) noprint;
    estimate p=2 q=1 method=ml;
    title "Table 4f: ARIMA(2,1,1) - Candidate Model 6";
run;

/* MODEL 7: ARIMA(1,1,2) */
proc arima data=cpi_data;
    identify var=cpi(1) noprint;
    estimate p=1 q=2 method=ml;
    title "Table 4g: ARIMA(1,1,2) - Candidate Model 7";
run;


/* ================================================================ */
/* STEP 8: SELECTED MODEL - ARIMA(0,1,1)                          */
/* ================================================================ */

proc arima data=cpi_data;
    identify var=cpi(1) noprint;
    estimate p=0 q=1 method=ml;
    title "Table 5: Selected Model - ARIMA(0,1,1)";
run;


/* ================================================================ */
/* STEP 9: DIAGNOSTIC CHECKS                                       */
/* ================================================================ */

/* Save residuals from selected model */
proc arima data=cpi_data;
    identify var=cpi(1) noprint;
    estimate p=0 q=1 method=ml;
    forecast lead=0 out=residuals id=date interval=qtr;
run;

/* Ljung-Box Test on Residuals */
proc arima data=residuals;
    identify var=residual nlag=24;
    title "Table 6: Ljung-Box Q-Test for Residual Autocorrelation";
run;

/* Plot Residuals over Time */
proc sgplot data=residuals;
    series x=date y=residual / markers markerattrs=(symbol=circle color=blue size=6)
                               lineattrs=(color=red thickness=1);
    refline 0 / axis=y lineattrs=(color=gray pattern=2);
    xaxis label="Quarter" valuesformat=yyq6.;
    yaxis label="Residuals";
    title "Figure 4: Residuals from ARIMA(0,1,1) Model";
run;

/* ACF of Residuals */
proc arima data=residuals;
    identify var=residual nlag=24;
    title "Figure 5: ACF of Residuals - White Noise Check";
run;

/* Normality Tests */
proc univariate data=residuals normal;
    var residual;
    qqplot / normal(mu=est sigma=est);
    title "Table 7: Normality Tests for Residuals";
run;

/* Histogram of Residuals */
proc sgplot data=residuals;
    histogram residual / binwidth=0.3 fillattrs=(color=blue transparency=0.6);
    density residual / type=normal;
    xaxis label="Residual Value";
    yaxis label="Frequency";
    title "Figure 6: Histogram of Residuals with Normal Curve";
run;


/* ================================================================ */
/* STEP 10: FORECASTING (8 QUARTERS AHEAD)                         */
/* ================================================================ */

proc arima data=cpi_data;
    identify var=cpi(1) noprint;
    estimate p=0 q=1 method=ml;
    forecast lead=8 out=forecast_data id=date interval=qtr;
    title "Table 8: Two-Year Forecast (2025 Q4 - 2027 Q3)";
run;

/* Print forecast table */
proc print data=forecast_data(where=(forecast ne .));
    var date forecast std l95 u95;
    format date yyq6. forecast std l95 u95 5.2;
    title "Table 9: Detailed Forecast Results with 95% Confidence Intervals";
run;


/* ================================================================ */
/* STEP 11: PLOT HISTORICAL + FORECAST                             */
/* ================================================================ */

/* Merge historical and forecast data */
data historical;
    set cpi_data;
    keep date cpi;
run;

data plot_data;
    merge historical forecast_data;
    by date;
    format date yyq6.;
run;

/* Create plot with historical and forecast */
proc sgplot data=plot_data;
    band x=date lower=l95 upper=u95 / transparency=0.5 fillattrs=(color=lightgray) name="band";
    series x=date y=cpi / markers markerattrs=(color=blue size=6)
                           lineattrs=(color=blue thickness=1) name="hist";
    series x=date y=forecast / markers markerattrs=(color=red size=6)
                               lineattrs=(color=red thickness=2) name="fcst";
    refline 3 6 / axis=y lineattrs=(color=green pattern=2 thickness=1)
                 label=("SARB Lower Bound (3%)" "SARB Upper Bound (6%)");
    xaxis label="Quarter" valuesformat=yyq6.;
    yaxis label="CPI Inflation Rate (%)" min=0 max=8;
    title "Figure 7: Historical CPI and 2-Year Forecast with 95% Confidence Intervals";
    keylegend "hist" "fcst" "band" / title="";
run;


/* ================================================================ */
/* STEP 12: OUT-OF-SAMPLE FORECAST ACCURACY (BACKTESTING)          */
/* ================================================================ */

/* Split data: Train (2015 Q1 - 2024 Q4) and Test (2025 Q1 - 2025 Q3) */
data cpi_train;
    set cpi_data;
    where date <= '01Oct2024'd;  /* Up to 2024 Q4 */
run;

data cpi_test;
    set cpi_data;
    where date >= '01Jan2025'd;  /* 2025 Q1 - Q3 */
run;

/* Estimate ARIMA(0,1,1) on training data and forecast 3 quarters */
proc arima data=cpi_train;
    identify var=cpi(1) noprint;
    estimate p=0 q=1 method=ml;
    forecast lead=3 out=backtest id=date interval=qtr;
    title "Backtesting: ARIMA(0,1,1) Forecast for 2025 Q1-Q3";
run;

/* Merge actual values with forecasts */
data forecast_accuracy;
    merge cpi_test (keep=date cpi rename=(cpi=actual))
          backtest (keep=date forecast);
    by date;
    format date yyq6.;
    
    /* Calculate error metrics */
    error = actual - forecast;
    abs_error = abs(error);
    sq_error = error**2;
    
    if actual > 0 then do;
        pct_error = abs(error / actual) * 100;
    end;
    else do;
        pct_error = .;
    end;
    
    keep date actual forecast error abs_error sq_error pct_error;
run;

/* Print detailed forecast accuracy table */
proc print data=forecast_accuracy noobs;
    var date actual forecast error abs_error pct_error;
    format actual forecast error abs_error pct_error 5.2;
    title "Table 10: Out-of-Sample Forecast Accuracy - Backtest Results (2025 Q1-Q3)";
run;

/* Calculate summary statistics (MAE, RMSE, MAPE) */
proc sql;
    create table accuracy_summary as
    select 
        mean(abs_error) as MAE,
        sqrt(mean(sq_error)) as RMSE,
        mean(pct_error) as MAPE
    from forecast_accuracy;
quit;

proc print data=accuracy_summary noobs;
    format MAE RMSE MAPE 5.2;
    title "Table 11: Out-of-Sample Forecast Accuracy Summary (2025 Q1-Q3)";
run;


/* ================================================================ */
/* STEP 13: IN-SAMPLE FORECAST ACCURACY (USING RESIDUALS)          */
/* ================================================================ */

/* Calculate in-sample accuracy measures */
data accuracy_insample;
    set residuals;
    where date <= '01Oct2025'd;  /* Historical period only */
    
    /* Calculate errors */
    error = residual;  /* residual = actual - forecast */
    abs_error = abs(residual);
    sq_error = residual**2;
    
    /* Only calculate percentage error if actual is not missing and > 0 */
    if cpi ne . and cpi > 0 then do;
        pct_error = abs(residual/cpi)*100;
    end;
    else do;
        pct_error = .;
    end;
    
    keep date cpi forecast residual abs_error sq_error pct_error;
    format date yyq6.;
run;

/* Print in-sample accuracy table */
proc print data=accuracy_insample(obs=43) noobs;
    var date cpi forecast abs_error pct_error;
    format cpi forecast abs_error pct_error 5.2;
    title "Table 12: In-Sample Forecast Accuracy Metrics (2015 Q1 - 2025 Q3)";
run;

/* Calculate summary statistics */
proc means data=accuracy_insample mean std min max;
    var abs_error sq_error pct_error;
    title "Table 13: In-Sample Forecast Accuracy Summary";
run;

/* Calculate MAE, RMSE, MAPE for in-sample */
proc sql;
    create table insample_summary as
    select 
        mean(abs_error) as MAE,
        sqrt(mean(sq_error)) as RMSE,
        mean(pct_error) as MAPE
    from accuracy_insample
    where abs_error ne .;
quit;

proc print data=insample_summary noobs;
    format MAE RMSE MAPE 5.2;
    title "Table 14: In-Sample Forecast Accuracy Summary (MAE, RMSE, MAPE)";
run;


/* ================================================================ */
/* STEP 14: COMPLETE FORECAST TABLE WITH ALL VALUES                */
/* ================================================================ */

/* Create final forecast table with actual, forecast, and confidence limits */
data final_forecast;
    merge cpi_data (in=a)
          forecast_data (in=b keep=date forecast std l95 u95);
    by date;
    format date yyq6.;
    
    /* If forecast is missing, set to . for future periods */
    if b then do;
        forecast_value = forecast;
        std_error = std;
        lower_95 = l95;
        upper_95 = u95;
    end;
    else do;
        forecast_value = .;
        std_error = .;
        lower_95 = .;
        upper_95 = .;
    end;
    
    keep date cpi forecast_value std_error lower_95 upper_95;
run;

/* Print complete table */
proc print data=final_forecast noobs;
    var date cpi forecast_value std_error lower_95 upper_95;
    format cpi forecast_value std_error lower_95 upper_95 5.2;
    title "Table 15: Complete Dataset with Historical CPI and 2-Year Forecast";
run;
