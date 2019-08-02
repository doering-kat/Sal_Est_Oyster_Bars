Data sources
================

# -----------------------------------------------------------------------------
=====
+ SA_Bars.csv is a list of all Bars in NOAA codes in oyster SA (extra columns removed except for the BarID)

+ Predicted_S_SAL_subset_2018_10_10 from KD's R project 
Explore_Envir_Fac_Dis\Derived_Data\Filter_Kriging.
These are kriged salinity estimates using data from
https://www.chesapeakebay.net/what/downloads/cbp_water_quality_database_1984_present

+ Bar_info_location.csv is selected columns from the BarInfo table from Fall dredge survey Database, accessed May 8 2018 (then processed). https://dnr.maryland.gov/fisheries/Pages/shellfish-monitoring/fall-survey.aspx

+ cruise_date_lookup from KD's R Project
Explore_Envir_Fac_Dis\Derived_Data\Run_Kriging_S_SAL_Output_2018_09_20.
The is to look up  cruises and dats for the CBP water quality data from:
https://www.chesapeakebay.net/what/downloads/cbp_water_quality_database_1984_present

+ WQ_Nested_S_SAL_Kriged.rds is an R object containing kriging output from KD's 
R project: Explore_Envir_Fac_Dis located in subfolder Derived_Data\Run_Kriging_S_SAL_Output_2018_09_20 . Data based on is from:
https://www.chesapeakebay.net/what/downloads/cbp_water_quality_database_1984_present. NOTE: too large to upload to github

# -----------------------------------------------------------------------------