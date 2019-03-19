# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Project: TopoCliF
# Script purpose: Deriving metrics
# Date: Mo Mar 19, 2019
# Author: Arne Thiemann
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



# ---- General metrics ----

# Detailed definitions are documented in the README.

index$area_raster[i] <- nrow(temp_ras_data) * prod(res(temp_ras))

index$elevation_min[i] <- minValue(temp_ras[["elev_absolute"]])
index$elevation_max[i] <- maxValue(temp_ras[["elev_absolute"]])
index$elevation_mean[i] <- cellStats(temp_ras[["elev_absolute"]], "mean")

index$elevation_range[i] <- maxValue(temp_ras[["elev_absolute"]]) - 
  minValue(temp_ras[["elev_absolute"]])

index$ela_calculated[i] <- ela_calculated

index$skewness[i] <- e1071::skewness(temp_ras_data$elev_absolute, type = 3)



# ---- Plateau detection-derived metrics ----

# Plateau metrics are retrieved in `analysis_pleateaus.R` within two loops.