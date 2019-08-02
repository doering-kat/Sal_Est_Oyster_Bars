# Header -----------------------------------------------------------------------
# Calculate salinity by NOAA code

# load packages, set options ---------------------------------------------------
library(tidyverse)
library(automap)
library(sp)
library(furrr) # to use parallel versions of purrr functions.
source("code/InterpolateWQData.R") # custom functions
options(stringsAsFactors = FALSE)

# create output folders --------------------------------------------------------
dir.create("figures")
dir.create("derived_data")
out_fig_dir <- file.path("figures", "1_calc_sal_by_NOAA_code")
out_dat_dir <- file.path("derived_data", "1_calc_sal_by_NOAA_code")
dir.create(out_fig_dir)
dir.create(out_dat_dir)

# read in data -----------------------------------------------------------------
bar_info_loc <- read.csv("data/Bar_info_location.csv")
SA_bars <- read.csv("data/SA_Bars.csv")
# Read in Kriging nested data frame (note: too large to upload to github)
sal_nested_df <- readRDS("data/WQ_Nested_S_SAL_Kriged.rds")
# get predictions at chosen locations ------------------------------------------
# Get locations in the correct way needed by function
colnames(SA_bars) <- "ID"
SA_bar_loc <- left_join(SA_bars, bar_info_loc, by = "ID") %>% 
                select(ID, cpntLongitude, cpntLatitude) %>% 
                rename(Lon = cpntLongitude) %>% 
                rename(Lat = cpntLatitude) %>% 
                na.omit() # get rid of bars without location for now.

# use map and mutate to get predicted values 
plan(multiprocess) #needed to run in parallel and speed up the run.
sal_nested_df <- sal_nested_df %>%
  #get predicted values
  mutate(Predicted_SA_bars = future_map(Interpolated, 
                                        GetPredictions, 
                                        locations = SA_bar_loc, 
                                        .progress = TRUE))

# Save predictions -------------------------------------------------------------

# Save R object just in case
saveRDS(sal_nested_df, file.path(out_dat_dir, "sal_nested_df.RDS"))

# Make 1 CSV file of all pred vals. Necessary information is the Bar, Cruise,
# Predicted values (point estimates and uncertainty.)
pred <- data.frame()
for(i in 1:nrow(sal_nested_df)){
  tmp_pred <- sal_nested_df$Predicted_SA_bars[[i]] %>%  # the predictions data
    select(ID, PredVal, PredValVar, PredValSD)
  tmp_pred$cruise <- sal_nested_df$Cruise[i] # add a column for cruise
  pred<- bind_rows(pred, tmp_pred) # bind the new obs to the previous ones.
}
# save all bars in the same csv
write.csv(pred, paste0(out_dat_dir, "/Pred_S_SAL_all_SA_Bars.csv"), 
          row.names = F)

