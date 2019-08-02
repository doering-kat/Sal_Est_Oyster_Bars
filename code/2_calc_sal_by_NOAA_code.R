# Header -----------------------------------------------------------------------
# Check and filter kriging output
# 
# Load packages, set options ---------------------------------------------------
library(tidyverse)
options(stringsAsFactors = FALSE)

# Read in data -----------------------------------------------------------------
sal_SA_bars <- read.csv(
  "derived_data/1_calc_sal_by_NOAA_code/Pred_S_SAL_all_SA_Bars.csv")
# get information about number of points sampled in the main, east, and western
#  parts of the bay
n_sal_df <-  read.csv("data/S_SAL_Count_Points.csv")

# folder locations to save output ----------------------------------------------
out_dat_dir <- file.path("derived_data","2_calc_sal_by_NOAA_code")
dir.create(out_dat_dir)

out_fig_dir <- file.path("figures", "2_calc_sal_by_NOAA_code")
dir.create(out_fig_dir)

# Filter data by point criteria ------------------------------------------------
#set some minimum sampling criteria to determine if kriging should not be done.
## Get cruise names that should be included for the set of data
# to krige
# Chose 5 in each, because it is a fairly small number to krige, but still got
# rid of unreasonable cruise values (i.e., cruises where it was obvious that 
# kriging failed.)

sal_cruise_include <- n_sal_df %>% 
  filter(count_main >= 5) %>% 
  filter(count_west >= 5) %>% 
  filter(count_east >= 5) %>% 
  select(Cruise)

#filter the kriging predictions for only cruises that met the criteria.
pred_sal_filtered_df <- sal_SA_bars %>% 
  filter(cruise %in% sal_cruise_include$Cruise)

# Explore filtered kriging output ----------------------------------------------
summary(pred_sal_filtered_df) # to see range of Predicted values
# save histogram
png(file.path(out_fig_dir, "hist_filtered_sal.png"),height = 4, width = 6, units = "in", res = 150)
hist(pred_sal_filtered_df$PredVal)
dev.off()

# Additional filtering by value ------------------------------------------------
pred_sal_filter_loc_val <- pred_sal_filtered_df %>% 
                            filter(PredVal >= 0) %>% 
                            filter(PredVal <= 35) %>% 
                            na.omit()

pred_sal_below_0 <- filter(pred_sal_filtered_df, PredVal <= 0) %>% 
                       na.omit()
pred_sal_above_35 <- filter(pred_sal_filtered_df, PredVal >= 35) %>% 
                       na.omit()
# Save filtered kriging --------------------------------------------------------
# Set ONLY excluding cruises with little sampling
write.csv(pred_sal_filtered_df,
          file.path(out_dat_dir, "Pred_S_SAL_SA_Bars_Filter_Loc.csv"))
# set excluding cruises with little sampling and extreme values
write.csv(pred_sal_filter_loc_val,
  file.path(out_dat_dir, "Pred_S_SAL_SA_Bars_Filter_Loc_Val.csv"))
# save the out of range values
write.csv(pred_sal_below_0, file.path(out_dat_dir, "pred_S_SAL_SA_Bars_bad_below_0.csv"))
write.csv(pred_sal_above_35, file.path(out_dat_dir, "pred_S_SAL_SA_Bars_bad_above_35.csv"))


