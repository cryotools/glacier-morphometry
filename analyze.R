# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Project: TopoCliF
# Script purpose: create presets from DEM tiles and Randolph SHP
# Date: Mo Nov 26, 2018
# Author: Arne Thiemann
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# ---- pre ------------

options(stringsAsFactors = F)

lapply(c("rgdal", "raster",
         "ggplot2",
         "tidyr", "dplyr",
         "gridExtra"
         ), require, character.only = T)

source("analysis_parameters.R")

# set raster plot colors
colors_elevation <- colorRampPalette(c("darkgreen", "forestgreen", 
                                       "chartreuse", "khaki", "yellow", 
                                       "peru", "sienna4"))
colors_slope <- colorRampPalette(colors_slope)



# ---- load index ------------

index <- read.csv(
  #file.choose(),
  index_input_path,
  sep = ";"
)

# ---- start loop for figures ------------
if(create_figures) writeLines("Creating figures")
if(calculate_metrics) writeLines("Calculating metrics")
pb <- txtProgressBar(0, nrow(index), style = 3)
for (i in seq(nrow(index))) {


temp_ras <- stack(index$raster_path[i])

names(temp_ras) <- c("elev_absolute", "elev_relative", "slope", "aspect")

temp_ras_data <- na.omit(as.data.frame(temp_ras))
colnames(temp_ras_data) <- c("elev_absolute", "elev_relative", "slope", 
                             "aspect")

if(create_figures) source("analysis_figures.R")

setTxtProgressBar(pb, i)
}

writeLines("\n")
