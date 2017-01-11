# install systematic investor
# Run only once
# install.packages('curl', repos = 'http://cran.r-project.org')
###############################################################################
#library(curl)
#install.packages('sit', repos = NULL, type='source')
#library(SIT)
##########
# test strategies
##########

#load.packages('quantmod')

#*****************************************************************
# Load historical data
#******************************************************************     
load.packages('quantmod')
tickers = spl('DJIA')

data <- new.env()
getSymbols(tickers, src = 'yahoo', from = '2000-01-01', env = data, auto.assign = T)
bt.prep(data, align='keep.all', dates='2000::2016')

#*****************************************************************
# Code Strategies
#****************************************************************** 
prices = data$prices    

# Buy & Hold    
data$weight[] = 1
buy.hold = bt.run(data) 

# MA Cross
sma = bt.apply(data, function(x) { SMA(Cl(x), 200) } )  
data$weight[] = NA
data$weight[] = iif(prices >= sma, 1, 0)
sma.cross = bt.run(data, trade.summary=T)           

#*****************************************************************

# Create Report
#****************************************************************** 
plotbt.custom.report.part1(buy.hold, sma.cross)
#plotbt.custom.report.part2(buy.hold, sma.cross)
#plotbt.custom.report.part3(buy.hold, sma.cross)
rm(data)