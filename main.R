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
