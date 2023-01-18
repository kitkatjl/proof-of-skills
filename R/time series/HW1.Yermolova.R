
rm(list = ls())

library(readxl)
library(readr)
library(stats)
library(smooth)
library(Mcomp)
library(forecast)

df<-read.csv('co-emissions-per-capita.csv')
colnames(df)[3]<-'yr'
colnames(df)[4]<-'emission'
plot(df$yr,df$emission)

Y <- df$emission
# ACF and PACF
acf(Y)
pacf(Y)



