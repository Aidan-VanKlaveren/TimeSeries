library(tsibble)
library(fpp3)
library(tidyverse)
library(here)
library(lubridate)
library(readxl)
library(MASS)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(purrr)
library(patchwork)
library(fabletools)

##Question 2

#load in the data global_economy
global_economy <- tsibbledata::global_economy

#create a new table for just USA data
us_economy <- global_economy %>%
  filter(Code == "USA") %>%
  as_tsibble(index = Year)

#can see the GDP numbers here
us_economy$GDP

#time series plot of GDP
us_economy %>% 
  autoplot(GDP)

#find suitable box-cox transformation
us_economy %>% 
  features(GDP, guerrero)

#time series with transformation
us_economy %>%
  autoplot(box_cox(GDP, 0.282))

#fit ARIMA model with box-cox transformed data
fit <- us_economy %>%
  model(
    arima = ARIMA(box_cox(GDP,0.282))
  )
report(fit)

#fit codes for models ARIMA(0,1,0) w/drift, ARIMA(0,1,1) w/drift and ARIMA(1,1,1) w/drift
fit1 <- us_economy %>%
  model(
    arima010 = ARIMA(box_cox(GDP,0.282) ~ pdq(0,1,0)),
    arima011 = ARIMA(box_cox(GDP,0.282) ~ pdq(0,1,1)),
    arima111 = ARIMA(box_cox(GDP,0.282) ~ pdq(1,1,1))
  )
glance(fit1) %>% arrange(AICc)

#Examine residuals of ARIMA(1,1,0) w/ drift
fit %>% 
  gg_tsresiduals()

#10 year forecast for box-cox transformed data
fit %>%
  forecast(h= "10 years") %>%
  autoplot(us_economy)

#10 year forecast using ARIMA() on non transformed data
fit3 <- us_economy %>%
  model(
    arima = ARIMA(GDP)
  )
fit3 %>%
  forecast(h= "10 years") %>%
  autoplot(us_economy)

#ets model on GDP
us_economy %>%
  model(ets = ETS(GDP))

#residual diagnostic check for ETS model
us_economy %>%
  model(ets = ETS(GDP)) %>%
  gg_tsresiduals()

#forecast 10 years
us_economy %>%
  model(ets = ETS(GDP)) %>%
  forecast(h= "10 years") %>%
  autoplot(us_economy)

## Question 3

#produce a time plot of the data
swiss_pop <- global_economy %>%
  filter(Country == "Switzerland") %>%
  mutate(Population = Population / 1e6) %>%
  as_tsibble(index = Year)
swiss_pop$Population

swiss_pop %>%
  autoplot(Population)

#Generate ACF and PACF plots on original series

swiss_pop %>% gg_tsdisplay(Population, plot_type="partial")

#generate ACF and PACF plots on differenced series

swiss_pop %>% gg_tsdisplay(difference(log(Population),1), plot_type="partial")

#calculate forecasts for next 3 years
first_year = (0.0053 + 8.47 + 1.64*(8.47-8.37) - 1.17*(8.37-8.28) + 0.45*(8.28-8.19))
second_year = (0.0053 + 8.5745 + 1.64*(8.5745-8.47) - 1.17*(8.47-8.37) + 0.45*(8.37-8.28))
third_year = (0.0053 + 8.67468 + 1.64*(8.67468-8.5745) - 1.17*(8.5745-8.47) + 0.45*(8.47-8.37))
forecasts <- matrix(c(first_year, second_year, third_year))
forecasts

#calculate forecast using function
function_forecast <- swiss_pop %>%
  model(
    arima = ARIMA(Population ~ pdq(3,1,0))
  ) %>%
  forecast(h = "3 years")

view(function_forecast) 