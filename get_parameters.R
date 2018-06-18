# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Project: TopoCliF
# Script purpose: Visualizing derived GeoTIFFs and obtaining parameters
# Date: Mo Jun 18, 2018
# Author: Arne Thiemann
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# ---- pre ------------

require(raster)

setwd("/data/projects/topoclif/result-data/run001_2018-06-18")

dir.create("/data/projects/topoclif/result-data/run001_2018-06-18/img")
dir.create("/data/projects/topoclif/result-data/run001_2018-06-18/tables")



# ---- go ------------

file_list <- list.files(pattern = "\\.tif$", full.names = T)

name_list <- list.files(pattern = "\\.tif$")
name_list <- gsub(".tif", "", name_list)

for (i in file_list) {
  # plot graphic
  png(
    filename = paste0("img/", name_list[i], ".png"),
    width = 1600,
    height = 1200,
    units = "px"
  )
  plot(
    raster(file_list[i], main = name_list[i])
  )
  dev.off()
}