# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Project: TopoCliF
# Script purpose: Setting analysis parameters
# Date: Mo Dez 18, 2018
# Author: Arne Thiemann
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



# ---- parameters ----

# relative ELA position (0 = lowest value, .5 = middle elevation, 1 = max elevation)
ela_assumed <- 1/3 

# number of hexbins at the x-axis (elevation) in the hexbin plot
nhexbins <- 35

# class breaks for slope analysis in degrees; min and max must be included
slope_bins <- c(0, .5, 1, 1.5, 5, 10, 20, 30, 45, 60, 90) # DO NOT CHANGE, is hardcoded elsewhere, recently!
colors_slope <- c("dodgerblue4", "dodgerblue3", "dodgerblue", 
  "deepskyblue", "khaki", "yellow", "orange", 
  "red3", "red4")



# ---- settings ----

# Should plateaus be detected?
plateau_detection <- T

  # metric slope limit (single or multiple inputs possible)
  metric_slope_limit <- c(5, 10)
  
  # clump size (in square meters, single or multiple inputs possible)
  metric_clump_size_limit <- 80^2
  
  # save plateau rasters to the hard drive
  save_plateau_rasters <- T # TRUE OR FALSE, default: TRUE
  
    # where should the plateau rasters be saved, then?
    # to the given path, ending without slash, /plateau_detection/slopelimit_sizethreshold/ will be added for each loop
    plateau_rasters_output_directory <- "/data/projects/topoclif/result-data/run001_2018-11-19" # default: getwd()
  
  # create plateau detection map figures
    plot_plateau_detection_figures <- T # TRUE or FALSE, default is TRUE

# Should figures for every glacier be created?
create_figures <- T # TRUE or FALSE, default is TRUE

# Should metrics for every glacier in the index be calculated?
calculate_metrics <- T # TRUE or FALSE, default is TRUE

index_input_path <- "/data/projects/topoclif/result-data/run003_2018-11-19/index.csv"

# output path for plots, will be added if it does not exist
plot_output_path <- "/data/projects/topoclif/result-data/run003_graphics/"

# index with metrics output csv
index_metrics_output_file <- "/data/projects/topoclif/result-data/index_metrics.csv"
metrics_histogram_figure_path <- "/data/projects/topoclif/result-data/metrics_histogram.png"
