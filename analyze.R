# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Project: TopoCliF
# Script purpose: create presets from DEM tiles and Randolph SHP
# Date: Mo Nov 26, 2018
# Author: Arne Thiemann
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# ---- pre ------------

options(stringsAsFactors = F)

lapply(c("rgdal", "raster", "rasterVis", "ggplot2", "RColorBrewer", "rgeos", 
         "tidyr", "dplyr", "ggthemes", "scales", "grid", "viridis", 
         "gridExtra", "hexbin"
         ), require, character.only = T)

source("analysis_parameters.R")

rasterOptions(
  maxmemory = 4e9,
  chunksize = 2e9
)



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
colnames(temp_ras_data) <- c("elev_absolute", "elev_relative", "slope", 
                             "aspect")


# ---- plot elevation and slope as raster ----

# set raster plot colors
colors_elevation <- colorRampPalette(c("darkgreen", "forestgreen", 
                                       "chartreuse", "khaki", "yellow", 
                                       "peru", "sienna4"))
colors_slope <- colorRampPalette(c("dodgerblue4", "dodgerblue3", "dodgerblue", 
                                   "deepskyblue", "khaki", "yellow", "orange", 
                                   "red3", "red4"))

png(
  filename = paste0(
    "/data/projects/topoclif/result-data/run003_graphics/",
    index$RGI_alias[i],
    "_01_overview2.png"
  ),
  width = 1920,
  height = 1200,
  units = "px",
  res = 120
)

# calculate ELA height from defined assumption
ela_calculated <- minValue(temp_ras[["elev_absolute"]]) +
  (maxValue(temp_ras[["elev_absolute"]]) - 
     minValue(temp_ras[["elev_absolute"]])) * ela_assumed

# elevation
ggras_elev_absolute <- temp_ras[["elev_absolute"]] %>% 
  as(., "SpatialPixelsDataFrame") %>% 
  as.data.frame()
colnames(ggras_elev_absolute) <- c("value", "x", "y")

ggp_elev <- ggplot() +
  geom_raster(data=ggras_elev_absolute, aes(x=x, y=y, fill=value)) +
  coord_fixed() +
  #theme_map() +
  theme_light()+
  #coord_map("albers", lat0 = 39, lat1 = 45) +
  geom_contour(data=ggras_elev_absolute, aes(x=x, y=y, z=value), breaks = ela_calculated, col = "black")+
  labs(fill = "Elevation [m a.s.l.]") +
  theme(
    legend.position="bottom",
    legend.key.width=unit(1.5, "cm"),
    axis.text.y = element_text(angle = 90, hjust = 1),
    axis.title.x=element_blank(),
    axis.title.y=element_blank()
  ) +
  scale_fill_gradientn(colors = colors_elevation(35))


# slope
ggras_slope <- temp_ras[["slope"]] %>% 
  as(., "SpatialPixelsDataFrame") %>% 
  as.data.frame()
colnames(ggras_slope) <- c("value", "x", "y")

# classify slope raster
ggras_slope$value_class <- cut(
  ggras_slope$value, 
  breaks = slope_bins,
  include.lowest = T, 
  ordered_result = T
)



ggp_slope <- ggplot() +
  geom_raster(data=ggras_slope, aes(x=x, y=y, fill=value_class)) +
  coord_fixed() +
  #theme_map() +
  theme_light()+
  #coord_map("albers", lat0 = 39, lat1 = 45) +
  geom_contour(data=ggras_elev_absolute, aes(x=x, y=y, z=value), breaks = ela_calculated, col = "black")+
  labs(fill = "Slope [°]") +
  theme(
    legend.position="bottom",
    #legend.key.width=unit(.2, "cm"),
    axis.text.y = element_text(angle = 90, hjust = 1),
    axis.title.x=element_blank(),
    axis.title.y=element_blank(), 
    legend.direction = "horizontal", 
    legend.box = "horizontal"
  ) +
  guides(
    fill = guide_legend(
      label.position = "bottom",
      nrow = 1,
      byrow = T
    )
  ) +
  scale_fill_manual(values = c("dodgerblue4", "dodgerblue3", "dodgerblue", 
                      "deepskyblue", "khaki", "yellow", "orange", 
                      "red2", "red3", "red4")) +
  xlim(layer_scales(ggp_elev)$x$range$range) +
  ylim(layer_scales(ggp_elev)$y$range$range)
  
grid.arrange(ggp_elev, ggp_slope, ncol = 2)

dev.off()


# ---- plot hexbin slop ~ elevation ----

png(
  filename = paste0(
    "/data/projects/topoclif/result-data/run003_graphics/",
    index$RGI_alias[i],
    "_03_elevation_slope_hexbin.png"
  ),
  width = 1920,
  height = 1200,
  units = "px",
  res = 120
)

print(ggplot(
  temp_ras_data,
  aes(
    x = elev_absolute,
    y = slope
  )
) + 
  geom_hex(binwidth = c(
    (max(temp_ras_data$elev_absolute) - min(temp_ras_data$elev_absolute))/nhexbins, # elevation (x) bins
    (max(temp_ras_data$slope) - min(temp_ras_data$slope))/(nhexbins*3/4)  # slope (y) bins
    ),
    aes(
      #alpha = ..count.., 
      fill = ..count..)
  ) + 
  #geom_smooth() +
  theme_light() +
  coord_fixed(ratio = (
    max(temp_ras_data$elev_absolute) - min(temp_ras_data$elev_absolute) 
    ) / 95  * 3/5 ) +
    scale_fill_gradient(low = "navy", high = "red") +
  geom_vline(xintercept = ela_calculated) +
  scale_y_continuous(
    breaks = c(0, 5, 10, 20, 30, 45, 60, 90), 
    limits = c(-2.5, 92.5),
    minor_breaks = NULL
  ))


dev.off()



# ---- simple cumulative elevation plot, as in Zaho et al. ----





# move progress bar forward
setTxtProgressBar(pb, i)
}

writeLines("\n")



