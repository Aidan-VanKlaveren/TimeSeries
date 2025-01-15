# Time Series Analysis Repository

This repository contains assignments, scripts, and documentation for the **STAT8122 Time Series Analysis** course. It showcases practical applications of time series modeling, forecasting, and data analysis using R.

---

## 📂 Repository Contents

### **Assignments and Reports**
- **`STAT8122 Time Series.docx`**: Overview and insights into key concepts and methodologies used in time series analysis.
- **`STAT8122 Time Series Assignment 2.pdf`**: Detailed assignment submission focusing on intermediate and advanced time series analysis techniques.
- **`AidanVanKlaveren44588070Assignment3.pdf`**: Comprehensive final assignment report, including modeling results, interpretations, and conclusions.

### **R Scripts**
- **`Assignment1.R`**: 
  - **Project Focus:** This script explores and analyzes weather-related time series data for Sydney. It evaluates minimum and maximum daily temperatures at Observatory Hill and daily rainfall at the Sydney Botanical Gardens. Key objectives include identifying trends, seasonality, and random components in the data.
  - **Key Analyses:**
    - **Temperature Analysis:** The script examines seasonal patterns, showing higher temperatures in summer compared to winter, with consistent variance across seasons. 
    - **Rainfall Analysis:** The randomness and lack of clear seasonal patterns in daily rainfall are highlighted, though monthly aggregation reveals small seasonal effects.
    - **Visualizations:** 
      - Yearly and seasonal temperature plots confirm seasonal cycles.
      - Lag and autocorrelation function (ACF) plots assess periodicity, revealing significant correlations over 2-year lags for temperature.
      - STL decomposition of monthly rainfall data isolates trend, seasonality, and noise, providing deeper insights into rainfall patterns. 
- **`Assignment2.R`**: 
  - **Project Focus:** This script demonstrates advanced time series modeling, including seasonal naïve forecasts, regression analysis, and exponential smoothing, applied to diverse datasets such as passenger counts, vehicle sales, and recruitment data.
  - **Key Analyses:**
    - **Seasonal Naïve Forecasting:**
      - Applied to various datasets (passenger, off-road vehicle, and people mover series) to identify trends, seasonality, and residual behaviors.
      - Observed significant lag effects in residuals, skewness, and cases where alternative models like naïve forecasting might be more appropriate.
    - **SOI and Recruitment Analysis:**
      - Time series plots revealed contrasting volatility and seasonal patterns between SOI and recruitment.
      - Regression analysis identified statistically significant lags (lags 5–12) of SOI in predicting recruitment, explaining 66.93% of the variation.
    - **Exponential Smoothing (ETS Model):**
      - Utilized ETS(A,A,N) with a Box-Cox transformation to address exponential variance in the dataset.
      - Model components (alpha, beta, initial states, and variance) provided insights into the relative weighting of recent values and trend focus.
      - ACF plots of residuals confirmed white noise, and forecast accuracy was assessed with a 6-year prediction and mean squared error calculation.
- **`Assignment3.R`**:
  - **Project Focus:** This script demonstrates advanced ARIMA modeling and comparative forecasting for economic and demographic datasets.
  - **Key Tasks:**
    - **ARIMA Modeling:** Developed various ARIMA models for transformed and non-transformed GDP data and selected the best model based on AICc scores.
    - **Forecasting:** Generated 10-year forecasts for both transformed and non-transformed data using ARIMA, and compared results with ETS models.
    - **Swiss Population Data:** Analyzed population trends using ACF/PACF plots, fitted suitable ARIMA models, and calculated multi-year forecasts.
  - **Outcomes:** Insights into optimal model selection, differences in forecasting techniques, and their impact on prediction intervals and accuracy.
---

## 🚀 Features

- **Time Series Exploration:** Decompose time series data into trend, seasonal, and residual components.
- **Model Implementation:** Fit and evaluate ARIMA, SARIMA, and exponential smoothing models for forecasting.
- **Forecasting:** Generate and validate forecasts using statistical methods.
- **Visualization:** Use R’s plotting libraries to visualize time series data and model predictions.

---

## 📊 Use Cases

1. **Data Exploration:** Understand underlying patterns in time series data such as seasonality, trends, and noise.
2. **Forecasting Applications:** Predict future values with high accuracy for real-world datasets.
3. **Model Comparison:** Evaluate multiple models to determine the best fit for given data.

---

## 🛠 Tools and Technologies

- **Language:** R
- **Key Libraries:** `forecast`, `tseries`, `ggplot2`, `dplyr`

---

## 📋 Getting Started

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/time-series-analysis.git
   cd time-series-analysis
