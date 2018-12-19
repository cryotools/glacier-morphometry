# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Project: TopoCliF
# Script purpose: Setting analysis parameters
# Date: Mo Dez 18, 2018
# Author: Arne Thiemann
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# height of the glacier (0 = lowest value, .5 = middle elevation, 1 = max elevation)
ela_assumed <- 1/3 

# number of hexbins at the x-axis (elevation) in the hexbin plot
nhexbins <- 30

# class breaks for slope analysis in degrees; min and max must be included
slope_bins <- c(0, .5, 1, 1.5, 5, 10, 20, 30, 45, 60, 90)

