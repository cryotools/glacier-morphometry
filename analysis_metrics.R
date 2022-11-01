# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Project: TopoCliF
# Script purpose: Deriving metrics
# Date: Mo Mar 19, 2019
# Author: Arne Thiemann
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



# ---- General metrics ----

# Detailed definitions are documented in the README.

index$m_area_absolute_glacier[i] <- nrow(temp_ras_data) * prod(res(temp_ras))

index$m_elevation_min[i] <- minValue(temp_ras[["elev_absolute"]])
index$m_elevation_max[i] <- maxValue(temp_ras[["elev_absolute"]])
index$m_elevation_range[i] <- maxValue(temp_ras[["elev_absolute"]]) -
  minValue(temp_ras[["elev_absolute"]])

index$m_elevation_mean[i] <- cellStats(temp_ras[["elev_absolute"]], "mean")
index$m_elevation_sd[i] <- cellStats(temp_ras[["elev_absolute"]], "sd")

index$m_ela_calculated[i] <- ela_calculated

index$m_glacier_skewness[i] <- e1071::skewness(temp_ras_data$elev_absolute, type = 3)



# ---- Plateau detection-derived metrics ----

# Plateau metrics are retrieved in `analysis_pleateaus.R` within two loops.