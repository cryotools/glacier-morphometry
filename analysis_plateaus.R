
# ---- define plateau detection function ----

get_plateaus <- function(
  
  # raster inputs
  ras_elev_abs,
  ras_elev_rel,####### # to be replaced by absolute ELA stuff
  ras_slope,  
  
  # single value inputs
  clump_min_size_absolute,
  slope_threshold,
  ela_relative
  
){
  
  # apply slope threshold, only above the assumed ELA
  glacier_flat <- ras_slope <= slope_threshold & 
    ras_elev_rel > (ela_relative * 1000)

  
  # detect clumps
  glacier_flat_clumps <- clump(glacier_flat)
  
  # sieve out clumps that are big enough, relatively to the glacier size
  glacier_flat_clumps_sieve <- glacier_flat_clumps %>% 
    freq() %>% 
    as.data.frame() %>% 
    na.omit()
  
  glacier_flat_clumps_sieve$clump_area <- glacier_flat_clumps_sieve$count *
    prod(res(glacier_flat_clumps)) #conversion from pixels to square meters
  
  glacier_flat_clumps_sieve <- glacier_flat_clumps_sieve %>% 
    filter(
      clump_area >= clump_min_size_absolute
    )
  
  glacier_flat_clumps_sieved <- glacier_flat_clumps %in% glacier_flat_clumps_sieve$value
  
  
  # get min/max of plateaus
  masked_elevation_plateau <- ras_elev_abs %>% 
    mask(
      .,
      mask = glacier_flat_clumps_sieved,
      maskvalue = T,
      inverse = T
    )
  
  elev_plateau_min <- minValue(masked_elevation_plateau)
  elev_plateau_max <- maxValue(masked_elevation_plateau)
  
  # get flat elevation band
  glacier_plateau_elevband <- ras_elev_abs >= elev_plateau_min &
    ras_elev_abs <= elev_plateau_max
  
  
  # build result raster, containing glacier_flats and plateaus
  
  ras_result <- stack(glacier_flat, glacier_flat_clumps_sieved,
    glacier_plateau_elevband)
  
  metrics_result <- list(
    elev_plateau_min,
    elev_plateau_max
  )
  
  return(list(raster_Result = ras_result, metrics_result = metrics_result))
}


# test application of function

TESCHT <- get_plateaus(
  ras_elev_abs = temp_ras[["elev_absolute"]],
  ras_elev_rel = temp_ras[["elev_relative"]],
  ras_slope = temp_ras[["slope"]],
  
  clump_min_size_absolute = 80^2,
  slope_threshold = 5,
  ela_relative = ela_assumed
)

plot(TESCHT$raster_Result)

# ---- multiple apply plateau function ----

plateau_geotable <- data.frame()

if(plateau_detection){
  
  for (i_slope in metric_slope_limit) {
    for (i_clump in metric_clump_size_limit) {
      
      assign(
        paste0("raster_", i_slope, "_", i_clump),
        get_plateaus(
          ras_elev_abs = temp_ras[["elev_absolute"]],
          ras_slope = temp_ras[["slope"]],
          slope_threshold = i_slope,
          ras_elev_rel = temp_ras[["elev_relative"]],
          ela_relative = ela_assumed,
          clump_min_size_absolute = i_clump
        )
      )
      
      plateau_geotable <- rbind(plateau_geotable, get_plateaus(
        ras_slope = temp_ras[["slope"]],
        slope_threshold = i_slope,
        ras_elev_rel = temp_ras[["elev_relative"]],
        ela_relative = ela_assumed,
        clump_min_size_absolute = i_clump
      )%>% 
        as(., "SpatialPixelsDataFrame") %>% 
        as.data.frame() %>% 
        mutate(
          class = ifelse(
            layer == 0,
            "glacier",
            ifelse(
              layer == 1,
              "below slope limit",
              ifelse(
                layer == 2,
                "plateau detected",
                "ERROR"
              )
            )
          )
        ) %>% 
        mutate(
          slope_limit = i_slope,
          clump_size_limit = i_clump
        )
      )
      
    }
  }
  
  # check option of df processing vs geoprocessing... matching via coordinates
  # PLACEHOLDER: Detect equal-elevation zones and delineate them
  
  
  plateau_geotable$class <- factor(
    plateau_geotable$class,
    levels = c("glacier", "below slope limit", "plateau detected")
  )
  
  
  png(
    filename = paste0(
      plot_output_path,
      index$RGI_alias[i],
      "_21_plateau_detection_thresholds.png"
    ),
    width = 1920,
    height = 1200,
    units = "px",
    res = 120
  )
  
  as.data.frame(temp_ras[["elev_absolute"]])
  
  print(ggplot() +
          geom_raster(
            data = plateau_geotable,
            mapping = aes(x = x, y = y, fill = class)
          ) +
          facet_grid(slope_limit ~ clump_size_limit) +
          coord_fixed() +
          theme_minimal() +
          theme(
            legend.position="bottom",
            legend.key.width=unit(1.5, "cm"),
            axis.text.y = element_text(angle = 45, hjust = 1),
            axis.title.x=element_blank(),
            axis.title.y=element_blank()
          ) +
          #geom_contour() + # integrate ELA indicator line here, later
          scale_fill_manual(
            values = c(
              rgb(.72,.92,.98), # glaciers
              rgb(.37,.47,.88), # below slope limit
              "#000000" # plateau detected
            )
          ))
  
  dev.off()
  

  # PLACEHOLDER: print plateau area into metrics
  
}
