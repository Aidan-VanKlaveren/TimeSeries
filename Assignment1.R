library(fpp3)
library(tidyverse)
library(here)
library(lubridate)
library(patchwork)
library(readxl)
library(timeSeries)
#Question 1

#read in the dataset
obs_hill_temp <- readr::read_csv("ObservatoryHillTemperature.csv")
obs_hill_temp

#separate date column by / to make new variable Date
obs_hill_temp1 <- separate(obs_hill_temp, col=date, into=c("Day","Month","Year"), sep="/", remove=TRUE)
obs_hill_temp1

# combine year, month and day into date format for modelling 
obs_hill_temp1$Date <- ymd(paste(obs_hill_temp1$Year, obs_hill_temp1$Month, obs_hill_temp1$Day))
obs_hill_temp1

obs_hill_temp2 <- as_tsibble(obs_hill_temp1, index=Date)

#autoplot of minimum temperature(degC)
obs_hill_temp2 %>%
  autoplot(`minimum_temperature_(degC)`)

#autoplot minimum temperature year
obs_hill_temp2 %>%
  filter(year(Date) == 1940) %>%
  autoplot(`minimum_temperature_(degC)`)

#ggseason minimum temperature
obs_hill_temp2 %>%
  gg_season(`minimum_temperature_(degC)`)

#ggsubseries minimum temperature
obs_hill_temp2 %>%  
  gg_subseries(`minimum_temperature_(degC)`)

#gglag minimum temperature
obs_hill_temp2 %>% 
  gg_lag(`minimum_temperature_(degC)`, geom='point')

#ACF minimum temperature
obs_hill_temp2 %>%
  ACF(`minimum_temperature_(degC)`, lag_max = 730) %>%
  autoplot()

#autoplot of maximum temperature(degC)
obs_hill_temp2 %>%
  autoplot(`maximum_temperature_(degC)`)

#autoplot maximum temperature year
obs_hill_temp2 %>%
  filter(year(Date) == 1940) %>%
  autoplot(`maximum_temperature_(degC)`)

#ggseason maximum temperature
obs_hill_temp2 %>%
  gg_season(`maximum_temperature_(degC)`)

#ggsubseries maximum temperature
obs_hill_temp2 %>%  
  gg_subseries(`maximum_temperature_(degC)`)

#gglag maximum temperature
obs_hill_temp2 %>% 
  gg_lag(`maximum_temperature_(degC)`, geom='point')

#ACF maximum temperature
obs_hill_temp2 %>%
  ACF(`maximum_temperature_(degC)`, lag_max = 730) %>%
  autoplot()

#read in botanical gardens daily
syd_bot_gard_daily <- readr::read_csv("SydneyBotanicGardensDailyRainfall.csv")
syd_bot_gard_daily

# combine year, month and day into date format for modeling 
syd_bot_gard_daily$Date <- ymd(paste(syd_bot_gard_daily$Year, syd_bot_gard_daily$Month, syd_bot_gard_daily$Day))
syd_bot_gard_daily

syd_bot_gard_daily1 <- as_tsibble(syd_bot_gard_daily, index=Date)

#autoplot of daily rainfall
syd_bot_gard_daily1 %>%
  autoplot(`Rainfall amount (millimetres)`)

#autoplot of daily rainfall
syd_bot_gard_daily1 %>%
  filter(year(Date) >= 2000, year(Date) <= 2010) %>%
  autoplot(`Rainfall amount (millimetres)`)

#ggseason of daily rainfall
syd_bot_gard_daily1 %>%
  gg_season(`Rainfall amount (millimetres)`)

#ggsubseries of daily rainfall
syd_bot_gard_daily1 %>%  
  mutate(Date = as.character(Date)) %>%
  as_tsibble(index = Date) %>%
  gg_subseries(`Rainfall amount (millimetres)`)

#gglag of daily rainfall
syd_bot_gard_daily1 %>% 
  gg_lag(`Rainfall amount (millimetres)`, geom='point')

#ACF of daily rainfall
syd_bot_gard_daily1 %>%
  ACF(`Rainfall amount (millimetres)`, lag_max = 730) %>%
  autoplot()

#Question 2
#read in the dataset
syd_bot_gard_monthly <- read_excel("SydneyBotanicGardensMonthlyRainfall.xlsx")
syd_bot_gard_monthly

# combine year, month and day into date format for modeling 
syd_bot_gard_monthly$Date <- ymd(paste(syd_bot_gard_monthly$Year, syd_bot_gard_monthly$Month, "1"))
syd_bot_gard_monthly

syd_bot_gard_monthly1 <- as_tsibble(syd_bot_gard_monthly, index=Date)

#autoplot of monthly rainfall
syd_bot_gard_monthly1 %>%
  autoplot(Rainfall)

#ggsubseries of daily rainfall
syd_bot_gard_monthly1 %>%
  mutate(Date = yearmonth(as.character(Date))) %>%
  as_tsibble(index = Date) %>%
  gg_subseries(Rainfall)

#ggseason of daily rainfall
syd_bot_gard_monthly1 %>%
  mutate(Date = yearmonth(as.character(Date))) %>%
  as_tsibble(index = Date) %>%
  gg_season(Rainfall)

syd_bot_gard_monthly2 <-syd_bot_gard_monthly1 %>%
  mutate(Date = yearmonth(as.character(Date))) %>%
  as_tsibble(index = Date)

#fill missing values
missing <- syd_bot_gard_monthly2 %>%
  fill_gaps()
filled <- missing %>%
  model(ARIMA(Rainfall)) %>%
  interpolate(missing)
#fit STL model to the data with cleaned
ah_decomp <- filled %>%
  model(STL(Rainfall)) %>%
  components()
ah_decomp %>% autoplot()

#seasonal change year on year
ah_decomp %>% gg_season(season_year)

#autoplot of monthly rainfall
syd_bot_gard_monthly2 %>%
  autoplot(Rainfall) +
  autolayer(ah_decomp, season_adjust, col="blue")
