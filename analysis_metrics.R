# area, calculated by cells and cell dimensions from raster
index$area_raster[i] <- nrow(temp_ras_data) * prod(res(temp_ras))

# elevation
# min
index$elevation_min[i] <- minValue(temp_ras[["elev_absolute"]])
# max
index$elevation_max[i] <- maxValue(temp_ras[["elev_absolute"]])
#mean
index$elevation_mean[i] <- cellStats(temp_ras[["elev_absolute"]], "mean")
# range
index$elevation_range[i] <- maxValue(temp_ras[["elev_absolute"]]) - 
  minValue(temp_ras[["elev_absolute"]])

#ELA
index$ela_calculated[i] <- minValue(temp_ras[["elev_absolute"]]) +
  (maxValue(temp_ras[["elev_absolute"]]) - 
     minValue(temp_ras[["elev_absolute"]])) * ela_assumed

# skewness
#index$skewness1[i] <- skewness(temp_ras_data$elev_absolute, type = 1)
#index$skewness2[i] <- skewness(temp_ras_data$elev_absolute, type = 2)
index$skewness[i] <- skewness(temp_ras_data$elev_absolute, type = 3)

# plateau metrics are retrieved in the corresponding script
