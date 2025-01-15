library(fpp3)
library(tidyverse)
library(here)
library(lubridate)
library(readxl)
library(MASS)
library(dplyr)
library(ggplot2)
library(ggpubr)
install.packages("ggpubr")
#Question 1

#read in the dataset
registrations <- read_excel("Registered_vehicles_by_type.xlsx")
registrations

## Passengers

#create tsibble with index being Quarterly
registrations1 <- registrations %>% 
  mutate(Quarter = yearquarter(Quarter)) %>%
  as_tsibble(index=Quarter)

#fill missing values
missing <- registrations1 %>%
  fill_gaps()
filled <- missing %>%
  model(ARIMA(Passenger)) %>%
  interpolate(missing)

#Apply seasonal naive method to passenger series with drift
snaive_passengers <- filled %>%
  model(SNAIVE(Passenger ~ drift()))

#Check residuals
snaive_passengers %>% gg_tsresiduals()


#Look at some forecasts
filled %>% 
  model(SNAIVE(Passenger ~ drift())) %>% 
  forecast(h=5) %>%
  autoplot(filled)


## Off_road

#fill missing values
filled1 <- missing %>%
  model(ARIMA(Off_road)) %>%
  interpolate(missing)

#Apply seasonal naive method to off_road series with drift
snaive_offroad <- filled1 %>%
  model(SNAIVE(Off_road ~ drift()))

#Check residuals
snaive_offroad %>% gg_tsresiduals()

#Look at some forecasts
snaive_offroad %>%
  forecast(h= "5 years") %>%
  autoplot(filled1) + theme_bw()

## People_mover
#fill missing values
filled2 <- missing %>%
  model(ARIMA(People_movers)) %>%
  interpolate(missing)

filled2 %>%
  as_tsibble(index = Quarter) %>%
  features(People_movers, guerrero)

#Apply seasonal naive method to people_movers series with drift
snaive_people <- filled2 %>%
  model(SNAIVE(box_cox(People_movers, 2)))

#Check residuals
snaive_people %>% gg_tsresiduals()

#Look at some forecasts
snaive_people %>%
  forecast(h= "5 years") %>%
  autoplot(filled2) + theme_bw()

#Question 3

fishsoi <- readr::read_csv("FISHSOI.csv")
date <- as.Date("1950/01/01")
len <- 453
dates <- seq(date, by= "month", length.out = len)
fishsoi$Date <- dates 

#time series plot for SoI and Recruitment
timeseries %>%
  pivot_longer(1:2, names_to="key", values_to="value") %>%
  autoplot(.vars = value) +
  facet_grid(vars(key), scales = "free_y") + theme_bw()

#Plot Recruitment lag against SOI and each lag up to 12
timeseries <- as_tsibble(fishsoi, index=Date)
timeseries$lag1 <- lag(timeseries$SOI, n=1, default = NA)
timeseries$lag2 <- lag(timeseries$SOI, n=2, default = NA)
timeseries$lag3 <- lag(timeseries$SOI, n=3, default = NA)
timeseries$lag4 <- lag(timeseries$SOI, n=4, default = NA)
timeseries$lag5 <- lag(timeseries$SOI, n=5, default = NA)
timeseries$lag6 <- lag(timeseries$SOI, n=6, default = NA)
timeseries$lag7 <- lag(timeseries$SOI, n=7, default = NA)
timeseries$lag8 <- lag(timeseries$SOI, n=8, default = NA)
timeseries$lag9 <- lag(timeseries$SOI, n=9, default = NA)
timeseries$lag10 <- lag(timeseries$SOI, n=10, default = NA)
timeseries$lag11 <- lag(timeseries$SOI, n=11, default = NA)
timeseries$lag12 <- lag(timeseries$SOI, n=12, default = NA)

SOI <- timeseries %>% 
  ggplot(aes(x=SOI, y=Recruit)) + geom_point() + theme_bw()
SOI1 <- timeseries %>% 
  ggplot(aes(x=lag1, y=Recruit)) + geom_point() + theme_bw()
SOI2 <- timeseries %>% 
  ggplot(aes(x=lag2, y=Recruit)) + geom_point() + theme_bw()
SOI3 <- timeseries %>% 
  ggplot(aes(x=lag3, y=Recruit)) + geom_point() + theme_bw()
SOI4 <- timeseries %>% 
  ggplot(aes(x=lag4, y=Recruit)) + geom_point() + theme_bw()
SOI5 <- timeseries %>% 
  ggplot(aes(x=lag5, y=Recruit)) + geom_point() + theme_bw()
SOI6 <- timeseries %>% 
  ggplot(aes(x=lag6, y=Recruit)) + geom_point() + theme_bw()
SOI7 <- timeseries %>% 
  ggplot(aes(x=lag7, y=Recruit)) + geom_point() + theme_bw()
SOI8 <- timeseries %>% 
  ggplot(aes(x=lag8, y=Recruit)) + geom_point() + theme_bw()
SOI9 <- timeseries %>% 
  ggplot(aes(x=lag9, y=Recruit)) + geom_point() + theme_bw()
SOI10 <- timeseries %>% 
  ggplot(aes(x=lag10, y=Recruit)) + geom_point() + theme_bw()
SOI11 <- timeseries %>% 
  ggplot(aes(x=lag11, y=Recruit)) + geom_point() + theme_bw()
SOI12 <- timeseries %>% 
  ggplot(aes(x=lag12, y=Recruit)) + geom_point() + theme_bw()

figure <- ggarrange(SOI, SOI1, SOI2, SOI3, SOI4, SOI5, SOI6, SOI7, SOI8, SOI9, SOI10, SOI11, SOI12,
                    ncol = 4, nrow =4)
figure

#regress recruitment
fit <- timeseries %>% 
  model(TSLM(Recruit ~ SOI + lag1 + lag2 + lag3 + lag4 + lag5 + 
             lag6 + lag7 + lag8 + lag9 + lag10 + lag11
             + lag12))
fit %>% report()


#Question 4

# Transform series into a tsibble
library(Mcomp)
(M1$YAF2)$x

Renault <- tibble(Turnover = (M1$YAF2)$x)
date1 <- as.Date("1972/01/01")
len1 <- 22
dates1 <- seq(date1, by= "year", length.out = len1)
Renault$Date <- dates1
Renaultseries <- as_tsibble(Renault, index=Date)

Renaultseries %>% mutate(Date = year(as.character(Date))) %>%
  as_tsibble(index = Date) %>%
  features(Turnover, guerrero)

#exponential smoothing with additive trend with parameter values
fit1 <- Renaultseries %>%
  mutate(Date = year(as.character(Date))) %>%
  as_tsibble(index = Date) %>%
  model(
    aan = ETS(box_cox(Turnover,0.427)~ error("A") + trend("A") + season("N"))
  )
report(fit1)

Renaultseries %>%
  autoplot(box_cox(Turnover, 0.427))

#residuals from the ETS
fit1 %>% 
  gg_tsresiduals()

#Generate 6 year prediction
fc <- fit1 %>%
  fabletools::forecast(h = 6)
fc

#plot of the forecasts
Renaultseries1 <- Renaultseries %>% mutate(Date = year(as.character(Date))) %>% as_tsibble(index = Date)
fc %>%
  autoplot(Renaultseries1)

#calculate the mean squared error
(M1$YAF2)$xx

residuals = ((601253-588568)^2 + (660320-646758)^2 + (722522-849998) + (787902-1106740) + (856496-1184550) 
             + (928345-1425090))
MSE = (1/6) * residuals
MSE