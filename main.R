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


#test
karanag_test <- rgi2ras(
  "RGI60-15.07374"
)


writeLines("\nStarting main processing...")
results <- list(
  Karanag = singleEvaluate("RGI60-15.07374"),
  # Karanag = singleEvaluate("RGI60-15.07439"),
  KubiKangri = singleEvaluate("RGI60-15.10994"),
  TshoKarpo = singleEvaluate("RGI60-15.05606"),
  Dhaulagiri = singleEvaluate("RGI60-15.04830"),
  PanbariHimal = singleEvaluate("RGI60-15.04541"),
  TsangbuRi = singleEvaluate("RGI60-15.04075"),
  Shishapangma = singleEvaluate("RGI60-15.10255"),
  Dangnok = singleEvaluate("RGI60-15.03448"),
  Jongsong = singleEvaluate("RGI60-15.10434"), #AKA Kaer
  Zeng = singleEvaluate("RGI60-13.26239"),
  Qiaqing = singleEvaluate("RGI60-13.00965"),
  TC_qilian = singleEvaluate("RGI60-13.32806"),
  TC_kunlunCentral = singleEvaluate("RGI60-13.33980"),
  TC_plateauWest = singleEvaluate("RGI60-13.53958"),
  Chongce = singleEvaluate("RGI60-13.53223"),
  TC_himalayaWest = singleEvaluate("RGI60-15.07374"),
  TC_karakoramCentral = singleEvaluate("RGI60-15.03448"),
  TC_hindukush = singleEvaluate("RGI60-14.24900"),
  #TC_karakoramCentral = singleEvaluate("RGI60-15.03448"), # is a duplicate
  TC_pamirEast = singleEvaluate("RGI60-13.41822"),
  TC_pamirCentral = singleEvaluate("RGI60-13.13595"),
  Abramov = singleEvaluate("RGI60-13.18096"),
  TC_tienNorth = singleEvaluate("RGI60-13.48040"),
  TC_tienNorth2 = singleEvaluate("RGI60-13.05479"),
  TC_tienEast = singleEvaluate("RGI60-13.29436"),
  UrumqiNo1 = singleEvaluate("RGI60-13.45335"),
  TC_gobi = singleEvaluate("RGI60-13.45075"),
  Aerqialeteer = singleEvaluate("RGI60-13.31151")
)
writeLines("\nWriting result rasters...")
for (i in seq(results)){
  writeRaster(results[[i]], paste0(names(results)[i], ".tif"))
  writeLines(paste0(names(results)[i], ".tif saved."))
}


# ---- determination ------------

#find relation between elev and slope, evtly play with counts of elev and slope (per area)
