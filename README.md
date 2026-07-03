# STFM312 Time Series Analysis Projects

## About This Repository

This repository contains two applied time series analysis projects completed as part of the STFM312 module (Introduction to Time Series Analysis) at North-West University. Both projects use the Box-Jenkins (ARIMA/SARIMA) methodology to analyze quarterly data and generate forecasts.

**Author:** Neo Mthembu
**Student Number:** 36321389
**Course:** BCom in Statistics
**Institution:** North-West University

---

## Projects Overview

### 1. South African CPI Forecasting

**Objective:** Model and forecast South Africa's Consumer Price Index (CPI) from Q1 2015 to Q3 2025 using Box-Jenkins ARIMA methodology.

**Methodology:** ARIMA(0,1,1) selected based on:
- Lowest AIC (111.20)
- Lowest SBC (114.67)
- Parsimonious model (1 parameter)
- Significant MA1 parameter (p < 0.0001)

**Key Finding:** Inflation forecast to decline from 3.01% (2025 Q4) to 2.62% (2027 Q3)

**Data Source:** South African Reserve Bank (SARB), Series KBP7177Q

**Forecast Accuracy:**
| Metric | Value |
|--------|-------|
| RMSE | 0.8679 |
| MAE | 0.7137 |
| MAPE | 18.68% |

---

### 2. Epsilon Digital Sales Forecasting

**Objective:** Forecast quarterly sales (2016-2025) for a retail firm and provide actionable business insights.

**Methodology:** SARIMA(0,1,0)(0,1,1)₄ selected based on:
- Lowest AIC (403.14)
- Lowest SBC (406.25)
- Best balance of fit and parsimony

**Key Finding:** Sales projected to reach ZAR 8.216 million by 2027 Q4

**Data Source:** Simulated retail sales data (ZAR '000)

---

## Repository Structure
STFM312-ARIMA-Projects/
│
├── CPI-ARIMA-Project/
│   ├── cpi_arima_analysis.sas          (SAS code)
│   ├── TSReport.csv                    (data file)
│   ├── CPI_Report.docx                 (Word report)
│   └── CPI_Presentation.pptx           (PowerPoint)
│
├── Epsilon-Sales-Project/
│   ├── epsilon_sales_analysis.sas      (SAS code)
│   ├── epsilon_sales_data.csv          (data file)
│   ├── Epsilon_Report.docx             (Word report)
│
├── README.md                           (Main project description)
└── LICENSE                             (MIT License)


---

## Methodology

Both projects follow the Box-Jenkins four-step framework:

| Step | Description | Key Output |
|------|-------------|------------|
| **Identification** | Plot data, check stationarity | ACF, PACF plots |
| **Estimation** | Estimate candidate models | AIC, SBC, parameters |
| **Diagnostic Checking** | Ljung-Box test | Residual ACF, p-values |
| **Forecasting** | Generate forecasts | Forecast table, plot |

### Stationarity Testing

- Augmented Dickey-Fuller (ADF) unit root tests
- First differencing (d=1) for trend removal
- Seasonal differencing (D=1, s=4) where required

### Model Selection Criteria

- **AIC** (Akaike Information Criterion) - Lower is better
- **SBC** (Schwarz Bayesian Criterion) - Lower is better
- **Ljung-Box Q** - p > 0.05 indicates white noise
- **Parsimony** - Simpler models preferred

### Diagnostic Checks

- Ljung-Box Q-test for residual autocorrelation
- Shapiro-Wilk test for normality
- Zero mean t-test
- Residual plots (time series, ACF, Q-Q, histogram)

---

## Key Skills Demonstrated

| Skill | Project |
|-------|---------|
| Time series visualization and decomposition | Both |
| Stationarity testing (ADF unit root tests) | Both |
| ARIMA/SARIMA model identification | Both |
| Model estimation using Maximum Likelihood | Both |
| Model selection using AIC/SBC criteria | Both |
| Diagnostic checking (white noise, normality) | Both |
| Forecasting with confidence intervals | Both |
| Academic report writing | CPI Project |
| Consultancy report writing | Epsilon Project |
| SAS programming (PROC ARIMA, SGPLOT) | Both |

---

## Technologies Used

- **SAS** - Primary analysis tool (PROC ARIMA, PROC SGPLOT, PROC UNIVARIATE)
- **Microsoft Word** - Report preparation
- **Microsoft PowerPoint** - Presentation creation

---

## Forecast Highlights

### CPI Forecast (2025 Q4 - 2027 Q3)

| Quarter | Forecast (%) | 95% CI |
|---------|-------------|--------|
| 2025 Q4 | 3.01 | (1.27 - 4.74) |
| 2026 Q1 | 2.95 | (1.05 - 4.85) |
| 2026 Q2 | 2.90 | (0.84 - 4.95) |
| 2026 Q3 | 2.84 | (0.65 - 5.03) |
| 2026 Q4 | 2.79 | (0.46 - 5.11) |
| 2027 Q1 | 2.73 | (0.28 - 5.18) |
| 2027 Q2 | 2.68 | (0.10 - 5.25) |
| 2027 Q3 | 2.62 | (-0.07 - 5.31) |

### Sales Forecast (2026 Q1 - 2027 Q4)

| Quarter | Forecast (ZAR '000) | 95% CI |
|---------|--------------------|--------|
| 2026 Q1 | 5,833 | (5,687 - 5,979) |
| 2026 Q2 | 6,247 | (6,041 - 6,453) |
| 2026 Q3 | 6,511 | (6,259 - 6,764) |
| 2026 Q4 | 7,063 | (6,772 - 7,355) |
| 2027 Q1 | 6,919 | (6,531 - 7,307) |
| 2027 Q2 | 7,355 | (6,890 - 7,821) |
| 2027 Q3 | 7,642 | (7,111 - 8,174) |
| 2027 Q4 | 8,216 | (7,626 - 8,806) |

---

## Business Recommendations

### Epsilon Digital Sales

| Recommendation | Rationale | Timeline |
|----------------|-----------|----------|
| **Increase Q4 inventory** | Consistent seasonal Q4 peaks | Annually, by September |
| **Hire seasonal staff** | Q4 sales volume requires additional support | Q3-Q4 each year |
| **Allocate marketing budget to pre-Q4** | Maximize return during peak season | August-September |
| **Consider business expansion** | Strong sustained growth trend | 2026-2027 |
| **Monitor Q1 post-holiday dip** | Prepare for lower Q1 sales | Q1 annually |
| **Update forecasts quarterly** | Improve accuracy with new data | Every quarter |

---

## References

Box, G.E.P., Jenkins, G.M., Reinsel, G.C., & Ljung, G.M. (2015). *Time Series Analysis: Forecasting and Control* (5th ed.). John Wiley & Sons.

Burnham, K.P., & Anderson, D.R. (2002). *Model Selection and Multimodel Inference: A Practical Information-Theoretic Approach* (2nd ed.). Springer.

Hyndman, R.J. & Athanasopoulos, G. (2018). *Forecasting: Principles and Practice* (2nd ed.). OTexts.

Riofrío, J., Chang, O., Revelo-Fuelagán, E.J. & Peluffo-Ordóñez, D.H. (2020). Forecasting the Consumer Price Index (CPI) of Ecuador. *International Journal on Advanced Science, Engineering and Information Technology*, 10(3), p.1078.

South African Reserve Bank (2025). KBP7177Q: Consumer prices - CPI excluding food, fuel and electricity.

Wang, L., Liu, Y., & Zhang, J. (2019). Information criteria for seasonal time series model selection. *Communications in Statistics - Simulation and Computation*, 48(7), 2105-2120.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Contact

**Neo Mthembu**
- GitHub: [Your GitHub Username]
- LinkedIn: [Your LinkedIn URL]
- Email: [Your Email]

---

## Acknowledgments

- **Dr Martin Chanza** - Course Coordinator, STFM312
- **North-West University** - Faculty of Natural and Agricultural Sciences
- **South African Reserve Bank** - Data provision
- **Epsilon Data Mining (Pty) Ltd** - Consultancy context

---

*Last Updated: July 2026*

