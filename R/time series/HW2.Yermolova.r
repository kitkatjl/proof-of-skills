---
title: "R Notebook"
output: html_notebook
---


library(tseries)
library(urca)
library(haven)
library(normtest)
library(forecast)
library(dynlm)
library(FinTS)

df<-read.csv('co-emissions-per-capita.csv')
colnames(df)[3]<-'yr'
colnames(df)[4]<-'emission'
df<- df[-seq(nrow(df),nrow(df)-3),]
plot(df$yr,df$emission)

# Defining variables
Y <- df$emission
d.Y <- diff(Y)
t <- df$yr

# Dickey-Fuller test for variable Y
adf.test(Y, alternative="stationary", k=0)
adf.test(Y, k=0)

# Augmented Dickey-Fuller test, 1 lag
adf.test(Y, alternative="stationary", k=1)

# Augmented Dickey-Fuller test, 3 lags
adf.test(Y, alternative="stationary", k=3)
#Ho assumes the data is non-stationary, we can not reject it

x=ur.df(Y, type="none", selectlags ="AIC") 
summary(x)
x5=ur.df(Y, type="none", lags=5) 
summary(x5)

#third lag seems to be the most correlated


# DF and ADF tests for differenced variable
adf.test(d.Y, k=0)
#the differences are stationary

dx=ur.df(d.Y, type="none", selectlags ="AIC") # number of lags based upon the AIC 
summary(dx)

dx=ur.df(d.Y, type="none", lags =0) # number of lags based upon the AIC 
summary(dx)
#the differences are highly correlated with the previous datapoints (lag 1)

# ACF and PACF
acf(Y)
pacf(Y)

acf(d.Y)
pacf(d.Y)

# ARIMA(1,1,0)
arima(Y, order = c(1,0,0))
arima <- arima(Y, order = c(1,0,0))
resid <- residuals(arima)

Box.test(resid, lag=3) # test for normality, lag=log(sample size)
#Ho there is no autocorrelation, we can reject it

# ARIMA(1,1,1)
arima(Y, order = c(1,0,1))
arima1 <- arima(Y, order = c(1,0,1))
resid1 <- residuals(arima1)

Box.test(resid1, lag=3)



# ARIMA(2,1,3)
arima(Y, order = c(2,0,3))
arima2 <- arima(Y, order = c(2,0,3))
resid2 <- residuals(arima2)

Box.test(resid2, lag=3)

# ARIMA(2,1,1)
arima(Y, order = c(2,0,1))
arima3 <- arima(Y, order = c(2,0,1))
resid3 <- residuals(arima3)

Box.test(resid3, lag=3)


# ARIMA(2,1,1) forecasting
forecast1 <- forecast(arima3, h=4)
plot(forecast1)



# Checking for ARCH effect

#visually

ggtsdisplay(resid2)
resid2sq<-resid2^2
ggtsdisplay(resid2sq)

# formal test
model1<-dynlm(resid2sq~L(resid2sq) + L(L(resid2sq)))
summary(model1)


# LM ARCH test
resid2ArchLM <- ArchTest(resid2, lags=2, demean=TRUE)
resid2ArchLM
#H0 no Arch effects, we can reject it


# estimate the model ARCh(1)
ppi.arch <- garch(resid2,c(0,1))
sum_ppi.arch <- summary(ppi.arch)
sum_ppi.arch

#conditional variance h
hhat <- ts(2*ppi.arch$fitted.values[-1,1]^2)
plot.ts(hhat)



