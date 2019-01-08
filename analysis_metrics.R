# area, calculated by cells and cell dimensions from raster
index$area_raster[i] <- nrow(temp_ras_data) * prod(res(temp_ras))

# area derived from vector polygon
#...

# elevation
  # min
index$elevation_min[i] <- minValue(temp_ras[["elev_absolute"]])
  # max
index$elevation_max[i] <- maxValue(temp_ras[["elev_absolute"]])
  # range
index$elevation_range[i] <- maxValue(temp_ras[["elev_absolute"]]) - 
  minValue(temp_ras[["elev_absolute"]])

# skewness
index$skewness1[i] <- skewness(temp_ras_data$elev_absolute, type = 1)
index$skewness2[i] <- skewness(temp_ras_data$elev_absolute, type = 2)
index$skewness3[i] <- skewness(temp_ras_data$elev_absolute, type = 3)
