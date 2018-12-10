# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Project: TopoCliF
# Script purpose: Main file for execution
# Date: Mo Nov 19, 2018
# Author: Arne Thiemann
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


writeLines(paste("Start:", Sys.time()))

writeLines(paste0(
  "- - - - - - - - - - - - - - - - - -\n"
  ,"TCF Runner, version 2.0, 2018-11-19\n",
  "- - - - - - - - - - - - - - - - - -\n"
))


source("./create_presets.R")

source("./create_glacier_raster.R")

source("./processing.R")







# ---- TESTING PIT ------------

if(F){
for (i in seq(results)){
  writeRaster(results[[i]], paste0(names(results)[i], ".tif"))
  writeLines(paste0(names(results)[i], ".tif saved."))
}



#find relation between elev and slope, evtly play with counts of elev and slope (per area)


file_list <- list.files(pattern = "\\.tif$", full.names = T)

name_list <- list.files(pattern = "\\.tif$")
name_list <- gsub(".tif", "", name_list)
}