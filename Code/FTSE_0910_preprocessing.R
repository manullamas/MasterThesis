               ################################
               #####  LOADING STOCKS DATA #####
               ################################
      
  #Choose input file
    path <- 'C:/Users/Manuel/Desktop/Southampton/MasterThesis/Data/FTSE_0910/raw/'
    setwd('C:/Users/Manuel/Desktop/Southampton/MasterThesis/Data/FTSE_0910/raw/')

### Create FTSE100 list of components   <- downloaded as ABF_L.csv...
myList = list.files(path, pattern="*.csv")
FTSE100_list <- vector(mode="character", length=0)
for (i in 1:length(myList)) {
  FTSE100_list[i] = unlist(strsplit(myList[i], split='_', fixed=TRUE))[1]   #remove _L.csv
}
# Load data on independent datasets
# for (i in 1:length(myList)) {
#   assign(FTSE100_list[i], read.csv(paste0(path,myList[i])))
# }
# 

# Create list with dataframes
list_dfs <- list()
for (i in seq_along(myList)) {
  # if (i != 1) {
  list_dfs[[i]] <- read.csv(file = myList[i])[, c('Date', 'Close')]
  # }
}
# Merge datasets by Date (inner join)
dfStocks <-  Reduce(function(x,y) merge(x,y, by = 'Date'), list_dfs)
# Name columns of dfStocks
names(dfStocks) <- c('Date', FTSE100_list)


################################################################################################
################################################################################################

             #######################################################
             ##### PROCESSING DATAFRAME: create returns matrix #####
             #######################################################


StocksFTSE <- dfStocks[2:ncol(dfStocks)]
Dates <- dfStocks[1]

### Calculate returns / logReturns
returns <- data.frame()
logReturns <- data.frame()
for (j in 1:ncol(StocksFTSE)) {
  for (i in 1:nrow(StocksFTSE)-1) {
    returns[i,j] <- (StocksFTSE[i+1,j]-StocksFTSE[i,j])/StocksFTSE[i,j]
    logReturns[i,j] <- log(StocksFTSE[i+1,j]/StocksFTSE[i,j])
  }
}
names(returns) <- FTSE100_list
names(logReturns) <- FTSE100_list

### dates vector corresponding to returns
datesReturns <- data.frame(Dates[2:nrow(Dates),])

### Create index matrix
FTSE_indexes <- cbind(1:length(FTSE100_list), FTSE100_list)

# ### Normalize?: take only values and normalize by column
# StocksNormalized <- data.frame(scale(Stocks))    
# 
# 
# ### Standarize?
# 
# 


################################################################################################
################################################################################################

#### STORAGE ####


### Save dataframes
path1 <- 'C:/Users/Manuel/Desktop/Southampton/MasterThesis/Data/FTSE_0910/processed/'
path2 <- 'C:/Users/Manuel/Desktop/Southampton/MasterThesis/Data/FTSE_0910/networks/'
path3 <- 'C:/Users/Manuel/Desktop/Southampton/MasterThesis/Data/FTSE_0910/'
write.csv(returns, file = paste0(path1,"FTSE100_returns.csv"),row.names=FALSE)
write.csv(logReturns, file = paste0(path1,"FTSE100_logReturns.csv"),row.names=FALSE)
write.csv(datesReturns, file = paste0(path1,"DatesReturns.csv"),row.names=FALSE)
write.csv(FTSE100_list, file = paste0(path1,"FTSE_names.csv"),row.names=FALSE)
write.csv(FTSE_indexes, file = paste0(path2,"FTSE_indexes.csv"),row.names=FALSE)
write.csv(FTSE_indexes, file = paste0(path3,"FTSE_indexes.csv"),row.names=FALSE)


# write.csv(Stocks, file = paste0(path1,"StocksNotNorm.csv"),row.names=FALSE)