library(knitr) # for cleaner outputs of tables
library(dplyr) # for processing data
library(RSQLite) # To enable connection to SQL databases
library(dbplyr) # to enable dplyr commands on databases
library(dtplyr) # to enable dplyr commands on data.tables
library(data.table) # to use functions for speed
library(tictoc) # for testing and timing sections of code
library(ggplot2) # to plot charts
library(openxlsx) # to output results as Excel files
library(tidyr) # for processing NAs in variables
library(ascii) # for outputing results inline in html
library(kableExtra) # For better formatting of final tables
library(lazyeval) # to allow commands to be concatenated with quotes
library(gmodels)
library(nnet) # For multinomial regression
library(randomForest)
library(caret) # For random forest charts
library(ModelMetrics) # For some goodness of fit
library(ROCR) # for getting AUC values for ROC curves and plotting them
library(grDevices) # to save charts as objects
library(stats) #  for multiple regression
library(car) # for multiple regression tests
library(rpart) # for decision tree analysis
library(rpart.plot) # for graphs of decision tree


# Define the nominal repayment thresholds. Years are the April at the end of the tax year
plan_1_thresholds <- data.frame(
  TY_END = c(2002:2021),
  PLAN_1_THRESHOLD = c(10000,10000,10000,10000,15000,15000,15000,15000,15000,15000,15000,
                       15795,16365,16910,17335,17495,17775,18330,18935,19390)
)

plan_2_thresholds <- data.frame(
  TY_END = c(2017:2021),
  PLAN_2_THRESHOLD = c(21000,21000,25000,25725,26575)
)

plan_3_thresholds <- data.frame(
  TY_END = c(2020:2021),
  PLAN_3_THRESHOLD = c(21000,21000)
)

# Connect to the SQL database

slc_data <- dbConnect(odbc::odbc(),
                      driver = "SQL Server Native Client 11.0",
                      server = "VMT1PR-DHSQL01",
                      database = "SLC-OUTLAY-PERSONAL-WKG",
                      trusted_connection = "yes")

# Read in the data as lazy queries




# Put the threshold tables into SQL and read them back in so we can join them using dbplyr
copy_to(slc_data,
        plan_1_thresholds, 
        "#plan_1_thresholds",
        temporary = TRUE
)
copy_to(slc_data, 
        plan_2_thresholds, 
        "#plan_2_thresholds",
        temporary = TRUE
)
copy_to(slc_data, 
        plan_3_thresholds, 
        "#plan_3_thresholds",
        temporary = TRUE
)
