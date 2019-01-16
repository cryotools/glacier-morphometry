# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Project: TopoCliF
# Script purpose: Setting analysis parameters
# Date: Mo Dez 18, 2018
# Author: Arne Thiemann
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



# ---- parameters ----

# height of the glacier (0 = lowest value, .5 = middle elevation, 1 = max elevation)
ela_assumed <- 1/3 

# number of hexbins at the x-axis (elevation) in the hexbin plot
nhexbins <- 35

# class breaks for slope analysis in degrees; min and max must be included
slope_bins <- c(0, .5, 1, 1.5, 5, 10, 20, 30, 45, 60, 90)
colors_slope <- c("dodgerblue4", "dodgerblue3", "dodgerblue", 
  "deepskyblue", "khaki", "yellow", "orange", 
  "red3", "red4")



# ---- settings ----

# Should plateaus be detected?
plateau_detection <- T

  # slope limits for detecting possible plateaus
  pd_slope_limits <- c(2.5, 5, 7.5, 10)

  # clump sizes of flat areas to try out for detection
  pd_clump_size_limits <- c(.005, .01, .015, .02, .025)
  

# Should figures for every glacier be created?
create_figures <- F # TRUE or FALSE, default is TRUE

# Should metrics for every glacier in the index be calculated?
calculate_metrics <- T # TRUE or FALSE, default is TRUE

index_input_path <- "/data/projects/topoclif/result-data/run003_2018-11-19/index.csv"

# output path for plots, will be added if it does not exist
plot_output_path <- "/data/projects/topoclif/result-data/run003_graphics/"

# index with metrics output csv
index_metrics_output_file <- "/data/projects/topoclif/result-data/index_metrics.csv"
metrics_histogram_figure_path <- "/data/projects/topoclif/result-data/metrics_histogram.png"
