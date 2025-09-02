#Downloading SP500 price using quantmod
library(stats)
library(quantmod)
library(forecast)
options("getSymbols.warning4.0"=FALSE)
options("getSymbols.yahoo.warning"=FALSE)
getSymbols("^GSPC", from = '2009-01-01', to = "2023-10-31",warnings = FALSE,
           auto.assign = TRUE)
head(GSPC)
chart_Series(GSPC)

#Select the relevant close price series
stock_prices = GSPC[,4]
head(stock_prices)

#Log transformation stock data
sp500_log <- log(stock_prices)
head(sp500_log, n = 10)
plot(sp500_log, main = "log sp500 Data chart")

#Autocorrelation (ACF)
acf_log <- acf(sp500_log, lag.max = 930)

#PACF
pacf_log <- pacf(sp500_log, lag.max = 930)

#Ljung-Box Test
Box.test(sp500_log, lag = 1, type = "Ljung")

#Stationary Test
library(tseries) 
adf <- adf.test(sp500_log, alternative = c("stationary", "explosive"), k = 0)
adf

#Normality Test
install.packages("nortsTest")
library(nortsTest)
nortest::ad.test(sp500_log)

#ARIMA Model 
#Checking using auto.arima
ARIMA<-auto.arima((sp500_log), seasonal=FALSE)
ARIMA

#ARIMA (4,1,4) model fitting and Forecasting
model <- Arima(sp500_log,order=c(4,1,4),include.constant=T)
model
forecast1 <- forecast(model, h = 100)
plot(forecast1)

#Residuals
checkresiduals(model)



