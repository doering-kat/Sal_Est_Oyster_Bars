Salinity at Oyster Bars
================

Setup
=====

``` r
# load packages, set options ---------------------------------------------------
library(tidyverse)
options(stringsAsFactors = FALSE)

# create output folders --------------------------------------------------------
dir.create("figures")
dir.create("derived_data")
out_fig_dir <- file.path("figures", "1_calc_sal_by_NOAA_code")
out_dat_dir <- file.path("derived_data", "1_calc_sal_by_NOAA_code")
dir.create(out_fig_dir)
dir.create(out_dat_dir)

# read in data -----------------------------------------------------------------
# read in all salinity estimates  (may need to do this if bar subset is different)
# kriged sal est
sal_all <- read.csv("data/Predicted_S_SAL_subset_2018_10_10.csv")
# metadata: bar and NOAA code lookup, cruise data lookup
cruise_date_key <- read.csv("data/cruise_date_lookup.csv")
bar_info <- read.csv("data/BarInfo.csv")
```

Analysis
========

Does `unique(sal_est$ID)` contain all the oyster bars needed?

``` r
# bind w/ metadata -------------------------------------------------------------
sal_all <- left_join(sal_all, cruise_date_key, by = "cruise")

# filter kriging estimates -----------------------------------------------------
# For only the years and bars of interest
sal_est <- sal_all %>% 
            filter(year > 1998)  # b/c stock assessment model started in '98
            # add filter for only bars of interest
# check: do we need to include more bars than what are already included?
unique(sal_est$ID) # cross check this list 
```

    ##  [1] "BRCDN0" "BRCRO0" "EBNBG0" "EBNHN0" "EBNPI0" "FIBGC0" "HACTW0"
    ##  [8] "HLSHS0" "HORNO1" "LAAHA0" "LAAHP0" "LCHBR0" "LCRCP0" "LCRLI0"
    ## [15] "LCSHI0" "LPRCH0" "LSMCC0" "LTCCA0" "LTCRP0" "LTSOW0" "MARGE0"
    ## [22] "MCRSH0" "MIRLP0" "MIRTB0" "MPRRP0" "MPXBI0" "MTSBC0" "MTSPE0"
    ## [29] "NWRWL0" "POSMA0" "SMSBU0" "TARDM0" "TASST0" "UBESP0" "UCHOF0"
    ## [36] "UCROS0" "UCSFP0" "UPRLC0" "USMPA0" "UTSSS0" "WWRLA0" "WWRMW0"
    ## [43] "WYRBI0"
