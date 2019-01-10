require(tidyverse)

source("analysis_parameters.R")

index <- read.csv(
  #file.choose(),
  index_input_path,
  sep = ";"
)

TSL_input <- read.csv(
  "/data/projects/topoclif/input-data/tables/TSL+RGI.csv"
)

TSL_input <- TSL_input[TSL_input$RGIId %in% index$RGI_ID,]
length(unique(TSL_input$RGIId))

ggplot(TSL_input) +
  geom_line(
    aes(
      x = as.POSIXct(LS_DATE),
      y = TSL_ELEV
    )
  ) +
  facet_wrap(~ RGIId)
