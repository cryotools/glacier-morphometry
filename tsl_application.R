TSL_input <- read.csv(
  "../../input-data/tables/TSL+RGI.csv"
)

TSL_input <- TSL_input[TSL_input$RGIId %in% index$RGI_ID,]
length(unique(TSL_input$RGIId))

# plot
ggplot(TSL_input) +
  geom_line(
    aes(
      x = as.POSIXct(strptime(TSL_input$BgnDate, "%Y%m%d")),
      y = TSL_ELEV,
      col = RGIId
    )
  )

  # plot
  ggplot(TSL_input) +
    geom_line(
      aes(
        x = as.POSIXct(strptime(TSL_input$BgnDate, "%Y%m%d")),
        y = TSL_ELEV
      )
    ) +
  facet_wrap(~ RGIId)

  
  # plot
  ggplot(TSL_input) +
    geom_line(
      aes(
        x = as.POSIXct(LS_DATE),
        y = TSL_ELEV,
        col = RGIId
      )
    )
  
  # plot
  ggplot(TSL_input) +
    geom_line(
      aes(
        x = as.POSIXct(LS_DATE),
        y = TSL_ELEV
      )
    ) +
    facet_wrap(~ RGIId)
  