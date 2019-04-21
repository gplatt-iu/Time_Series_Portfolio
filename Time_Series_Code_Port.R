#############################
# Code Portfolio            #
# Time Series Analysis      #
#############################

## All references to DataCamp in this file can be found at https://www.datacamp.com/. 

## Note that much of this code will not run, DataCamp takes advantage of preinstalled packages in their learning software. 
## The intent of this portfolio is to serve as a quick reference on how to do this - knowing what to do is prequisite - this is 
## just a code repository.

##### Comments with 5 # are Section Headers
####  Comments with 4 # are my notes
#     Comments with 1 # are comments brought in from DataCamp

## Check to be sure needed packages are loaded

## astsa is primary package - comes preloaded in R-Studio. Other platforms may need to have loaded. 

#########################################################
## From DataCamp: Introduction to Time Series Analysis ##
#########################################################

##### Create Time Series using ts()

data_vector <- c(1,5,6,8,0,2,3,9,7,4)

# Use print() and plot() to view data_vector
print(data_vector)
plot(data_vector)

# Convert data_vector to a ts object with start = 2004 and frequency = 4
time_series <- ts(data_vector, start = 2004, frequency = 4)

# Use print() and plot() to view time_series
print(time_series)
plot(time_series)


##### Removing Trends

#### Changing exponential growth to linear, stabilizes datasets to have consistant variance over time. 

# Log rapid_growth
linear_growth <- log(rapid_growth)

# Plot linear_growth using ts.plot()
ts.plot(linear_growth)

#### Differencing a time series removes the time trend, allow focus on the changes between values

# Generate the first difference of z
dz <- diff(z)

# Plot dz
ts.plot(dz)

# View the length of z and dz, respectively
length(z)
length(dz)

#### Differencing can also be done with lags to represent seasonal changes. For instance Y/Y values are often more useful than M/M
#### Think about December over December vs. November to December. This example uses a log of 4, which is good for quarterly patterns

# Generate a diff of x with lag = 4. Save this to dx
dx <- diff(x, lag = 4)

# Plot dx
ts.plot(dx)

# View the length of x and dx, respectively 
length(x)
length(dx)


##### Exploring Time Series

#### Pay special attention here - this exploration is based on financial data and can probably be used directly. 
#### Probably easier to do this in Tableau - but understanding summary statistics is important before proceeding
#### Helps inform next steps of analysis and time series

#### General Explore

# Generate means from eu_percentreturns
colMeans(eu_percentreturns)

# Use apply to calculate sample variance from eu_percentreturns
apply(eu_percentreturns, MARGIN = 2, FUN = var)

# Use apply to calculate standard deviation from eu_percentreturns
apply(eu_percentreturns, MARGIN = 2, FUN = sd)

# Display a histogram of percent returns for each index
par(mfrow = c(2,2))
apply(eu_percentreturns, MARGIN = 2, FUN = hist, main = "", xlab = "Percentage Return")

# Display normal quantile plots of percent returns for each index
par(mfrow = c(2,2))
apply(eu_percentreturns, MARGIN = 2, FUN = qqnorm, main = "")
qqline(eu_percentreturns)

##### Covariance and Correlation
#### This is again important - we have a lot of correlated data - we need to know how things move together or opposition to one another

# Use cov() with DAX_logreturns and FTSE_logreturns
cov(DAX_logreturns, FTSE_logreturns)

# Use cov() with logreturns
cov(logreturns)

# Use cor() with DAX_logreturns and FTSE_logreturns
cor(DAX_logreturns, FTSE_logreturns)

# Use cor() with logreturns
cor(logreturns)

##### Auto Correlation
####  This is a must - most time series data is autocorrelated. For instance much of our BoB data will be autocorrelated.
####  Where our data isn't autocorrelated, we need to take sure stakeholders understand this fact. When it is, they need
####  to understand the degree. Think work volumes on a Tuesday when Monday is over forecast. 

# Define x_t0 as x[-1]
x_t0 <- x[-1]

# Define x_t1 as x[-n]
x_t1 <- x[-n]

# Confirm that x_t0 and x_t1 are (x[t], x[t-1]) pairs  
head(cbind(x_t0, x_t1))

# Plot x_t0 and x_t1
plot(x_t0, x_t1)

# View the correlation between x_t0 and x_t1
cor(x_t0, x_t1)

# Use acf with x
acf(x, lag.max = 1, plot = FALSE)

# Confirm that difference factor is (n-1)/n
cor(x_t1, x_t0) * (n-1)/n


#########################################################
##       From DataCamp: ARIMA Modeling with R          ##
#########################################################

#### Generally for ARIMA data an assumption of stationarity is assumed. Differencing the data is often required to remove
#### the trend and lead to a stationary data set. THIS IS IMPORTANT!!!!

#### Often just rating the difference will be sufficient. For log() will also be needed. Refer to above for removing trends. 

##### Generating White Noise and seeing what AR and MA plots look like. 
####  You obviously need real data for this to be valuable - but this helps with know the arguments. 

# Generate and plot white noise
WN <- arima.sim(model = list(order = c(0,0,0)), n=200)
plot(WN)

# Generate and plot an MA(1) with parameter .9 
MA <- arima.sim(model=list(order = c(0,0,1), ma = .9 ) , n = 200)
plot(MA)

# Generate and plot an AR(2) with parameters 1.5 and -.75
AR <- arima.sim(model=list(order = c(2,0,0), ar=c(1.5, -.75)), n=200)
plot(AR)

##### Fitting an AR Model

# Generate 100 observations from the AR(1) model
x <- arima.sim(model = list(order = c(1, 0, 0), ar = .9), n = 100) 

# Plot the generated data 
plot(x)

# Plot the sample P/ACF pair
acf2(x)

# Fit an AR(1) to the data and examine the t-table
sarima(x, 1,0,0)

##### Fitting an MA Model
# Plot x
plot(x)

# Plot the sample P/ACF of x
acf2(x)

# Fit an MA(1) to the data and examine the t-table
sarima(x,0,0,1)

##### Fitting an ARMA Model

# Plot x
plot(x)

# Plot the sample P/ACF of x
acf2(x)

# Fit an ARMA(2,1) to the data and examine the t-table
sarima(x,2,0,1)

#### These models are important to understanding what models to apply to actual data. 
#### AR(X,0,0) - ACF Tails Off and PACF Cuts off after X
#### MA(0,0,X) - ACF Cuts Off after X and PACF tails off
#### ARMA(X,0,X) - They both tail off


#### Once you determine which model to use, start with replacing X with the number 1, then increment it.
#### use the AIC and BIC of the model to assess if you're adding value or not. (lower is better)
#### If you aren't sure which model to use even after the ACF/PACF you can also use the AIC/BIC to assess if the AR and MA parts add value.

##### Fitting an ARIMA Model
#### ARIMA adds differencing to ARMA. Reality for us largely lives in the ARIMA world

##### Example 1

# Plot sample P/ACF of differenced data and determine model
acf2(diff(x))


# Estimate parameters and examine output
sarima(x, 2,1,0)

##### Example 2

# Plot the sample P/ACF pair of the differenced data 
acf2(diff(globtemp))

# Fit an ARIMA(1,1,1) model to globtemp
sarima(globtemp, 1, 1, 1)

# Fit an ARIMA(0,1,2) model to globtemp. Which model is better?
sarima(globtemp, 0,1,2)

##### Using ARIMA to forecast
#### new commend sarima.for

# Plot P/ACF pair of differenced data 
acf2(diff(x))

# Fit model - check t-table and diagnostics
sarima(x,1,1,0)

# Forecast the data 20 time periods ahead
sarima.for(x, n.ahead = 20, p = 1, d = 1, q = 0) 
lines(y)  

#### This gives you a forecast and confidence bands. 

##### ARIMA with seasonality
####  Note: this is a jump in complexity. lower case variable handle model, upper case handle seasonality

##### Pure Seasonal

# Plot sample P/ACF to lag 60 and compare to the true values
acf2(x, max.lag = 60)

# Fit the seasonal model to x
sarima(x, p = 0, d = 0, q = 0, P = 1, D = 0, Q = 1, S = 12)

##### Mixed Seasonal

# Plot sample P/ACF pair to lag 60 and compare to actual
acf2(x, max.lag = 60)

# Fit the seasonal model to x
sarima(x, 0,0,1,0,0,1,12)

#### Forecasting Seasonal ARIMA

# Fit your previous model to unemp and check the diagnostics
sarima(unemp,2,1,0,0,1,1,12)

# Forecast the data 3 years into the future
sarima.for(unemp,n.ahead=36,2,1,0,0,1,1,12)

