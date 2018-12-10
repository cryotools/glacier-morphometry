# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Project: TopoCliF
# Script purpose: create presets from DEM tiles and Randolph SHP
# Date: Mo Nov 26, 2018
# Author: Arne Thiemann
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# ---- pre ------------

options(stringsAsFactors = F)

lapply(c("rgdal", "raster", "rasterVis", "ggplot2"), require, character.only = T)



# ---- load index ------------

index <- read.csv(
  file.choose(),
  sep = ";"
)

i=26

temp_ras <- stack(index$raster_path[i])

plot(temp_ras)

temp_ras_data <- na.omit(as.data.frame(temp_ras))
colnames(temp_ras_data) <- c("elev_absolute", "elev_relative", "slope", "aspect")

ggplot(
  temp_ras_data,
  aes(
    x = elev_absolute,
    y = slope
  )
) + geom_hex() + geom_smooth()
