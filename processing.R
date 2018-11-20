writeLines("\nReading input file...")
input <- read.csv(
  "input.csv",
  sep = ";",
  stringsAsFactors = F
)
writeLines(paste("Done; read", nrow(input), "lines, resp. features."))

# just for testing:
input <- input[9:11,]
###

input$RGI_alias <- gsub(
  "\\.",
  "_",
  input$RGI_ID
)

input$raster_path <- NA

writeLines("\nStarting processing loop...")
for (i in seq(nrow(input))) {
  
  writeLines(paste("Processing ", i, "of", nrow(input), "..."))
  ras <- rgi2ras(input$RGI_ID[i])
  
  writeRaster(
    ras, 
    filename = paste0(output_directory, "/", input$RGI_alias[i], ".tif")
  )
  
  input$raster_path[i] <- paste0(output_directory, "/", input$RGI_alias[i], ".tif")
}
writeLines("\nProcessing complete.")

write.table(
  input, 
  file = paste0(output_directory, "/index.csv"),
  sep = ";", 
  row.names = F
)