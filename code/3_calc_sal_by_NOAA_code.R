# Header -----------------------------------------------------------------------
# Get average salinity by year and noaa code

# Load Packages, set options ---------------------------------------------------
library(tidyverse)
library(lubridate)
options(stringsAsFactors = FALSE)

# Load Data --------------------------------------------------------------------
# Filtered kriging set
pred_sal <- read.csv("derived_data/2_calc_sal_by_NOAA_code/Pred_S_SAL_SA_Bars_Filter_Loc_Val.csv")
# cruise and date key
cruise_date_key <- read.csv("data/cruise_date_lookup.csv")
bar_info_loc <- read.csv("data/Bar_info_location.csv") # bars and NOAA codes
# Create Output folders --------------------------------------------------------
out_dat_dir <- file.path("derived_data","3_calc_sal_by_NOAA_code")
dir.create(out_dat_dir)
out_fig_dir <- file.path("figures", "3_calc_sal_by_NOAA_code")
dir.create(out_fig_dir)

# Manipulate data --------------------------------------------------------------
#  make min and max dates into dat format (not character)
cruise_date_key$min_date <- as.Date(cruise_date_key$min_date, 
                                    format = "%m/%d/%Y" )
cruise_date_key$max_date <- as.Date(cruise_date_key$max_date, 
                                    format = "%m/%d/%Y")
# Bind data set with cruise and date key and add additional date cols
pred_sal_date <- left_join(pred_sal, cruise_date_key, by = "cruise") %>% 
                    mutate(min_month = month(min_date)) %>% 
                    mutate(year = year(min_date)) %>% 
                    select(-X)
bar_info_loc <- select(bar_info_loc, ID, NOAACode)
# Bind ID's with the NOAA code
pred_sal_date <- left_join(pred_sal_date, bar_info_loc, by = "ID")
# Get an average monthly value by NOAA code
avg_month <- pred_sal_date %>% 
              select(min_month, year, NOAACode, PredVal) %>% 
              group_by(min_month, year, NOAACode) %>% 
              summarize(Sal_month_avg = mean(PredVal)) %>% 
              ungroup()
# Average the montly values by year by NOAA code.
avg_yr <- avg_month %>% 
            select(year, NOAACode, Sal_month_avg) %>% 
            group_by(year, NOAACode) %>% 
            summarize(mean_sal_yr = mean(Sal_month_avg)) %>% 
            ungroup()

# Save values ------------------------------------------------------------------
write.csv(avg_yr, file.path(out_dat_dir, "avg_sal_NOAA_yr.csv"), 
          row.names = FALSE)
# Make and Save plots ----------------------------------------------------------
# maybe really simple bar plot or something .
ggplot(data = avg_yr, aes(x = year, y = mean_sal_yr))+
  geom_point()+
  geom_line()+
  facet_wrap(~NOAACode)+
  theme_classic()
ggsave(file.path(out_fig_dir, "mean_sal_yr_NOAA.png"), device = "png", 
       width = 10, height = 8)  
