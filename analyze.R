# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Project: TopoCliF
# Script purpose: create presets from DEM tiles and Randolph SHP
# Date: Mo Nov 26, 2018
# Author: Arne Thiemann
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# ---- pre ------------

options(stringsAsFactors = F)

lapply(c("rgdal", "raster", "rasterVis", "ggplot2", "RColorBrewer"), require, character.only = T)



# ---- load index ------------

index <- read.csv(
  #file.choose(),
  "/data/projects/topoclif/result-data/run003_2018-11-19/index.csv",
  sep = ";"
)

# ---- start loop ------------
pb <- txtProgressBar(0, nrow(index), style = 3)
for (i in seq(nrow(index))) {



temp_ras <- stack(index$raster_path[i])

names(temp_ras) <- c("elev_absolute", "elev_relative", "slope", "aspect")

temp_ras_data <- na.omit(as.data.frame(temp_ras))
colnames(temp_ras_data) <- c("elev_absolute", "elev_relative", "slope", "aspect")


# ---- plot elevation and slope as raster ----

# set raster plot colors
colors_elevation <- colorRampPalette(c("darkgreen", "forestgreen", "chartreuse", "khaki", "yellow", "peru", "sienna4"))
colors_slope <- colorRampPalette(c("dodgerblue4", "dodgerblue3", "dodgerblue", "deepskyblue", "khaki", "yellow", "orange", "red3", "red4"))

png(
  filename = paste0(
    "/data/projects/topoclif/result-data/run003_graphics/",
    index$RGI_alias[i],
    "_01_overview.png"
  ),
  width = 1920,
  height = 1200,
  units = "px",
  res = 120
)

plot_elevation <- levelplot(
  temp_ras[["elev_absolute"]],
  margin=FALSE,
  colorkey=list(
    space='bottom',
    labels=list(at=round(seq(
      minValue(temp_ras[["elev_absolute"]]),
      maxValue(temp_ras[["elev_absolute"]]),
      length.out = 5
    )), font=4)
  ),
  scales=list(y=list(rot=90)),
  #scales=list(draw=FALSE),            # suppress axis labels
  col.regions=colors_elevation,                   # colour ramp
  at=seq(minValue(temp_ras[["elev_absolute"]]),
         maxValue(temp_ras[["elev_absolute"]]), len=110)
)

plot_slope <- levelplot(
  temp_ras[["slope"]],
  margin=FALSE,
  colorkey=list(
    space='bottom',
    labels=list(at= c(0, .5, 1, 1.5, 5, 10, 20, 30, 45, 60, 90), font=4)
  ),

  scales=list(y=list(rot=90)),
  #scales=list(draw=FALSE),            # suppress axis labels
  col.regions=colors_slope,                   # colour ramp
  at=c(0, .5, 1, 1.5, 5, 10, 20, 30, 45, 60, 90)
)

print(
  plot_elevation,
  position=c(0, 0, .5, 1), more=TRUE
)
print(
  plot_slope, 
  position=c(.5, 0, 1, 1)
)

dev.off()


# ---- plot hexbin slop ~ elevation ----


ggplot(
  temp_ras_data,
  aes(
    x = elev_absolute,
    y = slope
  )
) + 
  geom_hex(binwidth = c(30,3)) + 
  geom_smooth() +
  theme_light() +
  coord_fixed(ratio = ((
    max(temp_ras_data$elev_absolute) - min(temp_ras_data$elev_absolute) 
    ) / (
      max(temp_ras_data$slope) - min(temp_ras_data$slope)
      ) ) * 3/4 )


ggsave(
  filename = paste0(
    "/data/projects/topoclif/result-data/run003_graphics/",
    index$RGI_alias[i],
    "_03_elevation_slope_hexbin.png"
  )
)


setTxtProgressBar(pb, i)
}

