# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Project: TopoCliF
# Script purpose: Plateau detection
# Date: Mo Mar 19, 2019
# Author: Arne Thiemann
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -




# ---- source plateau detection function ----


source("analysis_plateaus_f_get-plateaus.R")




# ---- apply detection and derive metrics ----


# loop slope thresholds
for (i_slope in metric_slope_limit) {
  
  # loop clump thresholds
  for (i_clump in metric_clump_size_limit) {
    
    # avoid metrics derivation from previous raster, if creation fails
    intm_ras <- NULL 
    
    # create intermediate raster
    intm_ras <- get_plateaus(
      ras_elev_abs = temp_ras[["elev_absolute"]],
      ras_slope = temp_ras[["slope"]],
      plateau_min_size_sqm = i_clump,
      slope_threshold_deg = i_slope,
      ela_absolute = ela_calculated
    )

    # derive included metrics from plateau detection function
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_plateau_elevation_min")] <- intm_ras$metrics_result$plateau_min_elevation
    index$plateau_elevation_max[i] <- intm_ras$metrics_result$plateau_max_elevation
    
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_plateau_elevation_range")] <- intm_ras$metrics_result$plateau_max_elevation -
      intm_ras$metrics_result$plateau_min_elevation
    
    # sourced out metrics
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_plateau_elevation_mean")] <- cellStats(
      intm_ras$raster_plateau_dem, "mean"
    )
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_plateau_elevation_sd")] <- cellStats(
      intm_ras$raster_plateau_dem, "sd"
    )
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_plateau_elevation_skewness")] <- e1071::skewness(
      na.omit(as.data.frame(intm_ras$raster_plateau_dem))[,1],
      type = 3
    )
    
    
    # absolute area
    
    resulting_areas <- NULL
    resulting_areas <- raster::freq(intm_ras$raster_result_classified) %>% 
      as.data.frame() %>% 
      mutate(count = count * prod(res(intm_ras$raster_result_classified)))
    
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_flat")] <- sum(
      resulting_areas$count[resulting_areas$value %in% c(1, 101, 111)]
    )
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_plateau_elevation_band")] <- sum(
      resulting_areas$count[resulting_areas$value %in% c(100, 101, 111)]
    )
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_flat_in_plateau_elevation_band")] <- sum(
      resulting_areas$count[resulting_areas$value %in% c(101, 111)]
    )
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_plateau")] <- resulting_areas$count[
      resulting_areas$value == 111 & !is.na(resulting_areas$value)]
    
    
    # area comparison
    
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_rel_flat_to_glacier")] <- (
      index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_flat")] / 
        index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_glacier")]
      ) * 100
    
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_rel_plateau_to_glacier")] <- (
      index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_plateau")] / 
        index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_glacier")]
      ) * 100
    
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_rel_plateau_elevation_band_to_glacier")] <- (
      index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_plateau_elevation_band")] / 
        index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_glacier")]
      ) * 100
    
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_rel_flat_in_plateau_elevation_band_to_glacier")] <- (
      index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_flat_in_plateau_elevation_band")] / 
        index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_glacier")]
      ) * 100
    
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_rel_plateau_to_flat")] <- (
      index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_plateau")] / 
        index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_flat")]
      ) * 100
    
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_rel_flat_to_plateau_elevation_band")] <- (
      index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_flat")] / 
        index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_plateau_elevation_band")]
      ) * 100
    
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_rel_flat_in_plateau_elevation_band_to_flat")] <- (
      index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_flat_in_plateau_elevation_band")] / 
        index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_flat")]
      ) * 100
    
    
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_rel_plateau_to_plateau_elevation_band")] <- (
      index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_plateau")] / 
        index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_plateau_elevation_band")]
      ) * 100
    
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_rel_plateau_to_flat_in_plateau_elevation_band")] <- (
      index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_plateau")] / 
        index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_flat_in_plateau_elevation_band")]
      ) * 100
    
    index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_rel_flat_in_plateau_elevation_band_to_plateau_elevation_band")] <- (
      index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_flat_in_plateau_elevation_band")] / 
        index[i, paste0("m_s", i_slope, "_c", i_clump, "_area_absolute_plateau_elevation_band")]
      ) * 100
    
    
    
    
    
    ###### ToDo: add more, corresponding to matrix
    
    
    # save raster, if set
    if (save_plateau_rasters) {
      dir.create(paste0(
        plateau_rasters_output_directory,
        "/plateau_detection/", i_slope, "_", i_clump, "/"
      ))
      writeRaster(
        intm_ras, 
        filename = paste0(
          plateau_rasters_output_directory,
          "/plateau_detection/", i_slope, "_", i_clump, "/",
          input$RGI_alias[i], ".tif"
        )
      )
    }
    
    
    # plot raster if figure creation is set (syntax matching to other outputs)
    if (plot_plateau_detection_figures) {
      #### not implemented yet
    }

  }
}





# test application of function
if(F){
TESCHT <- get_plateaus(
  ras_elev_abs = temp_ras[["elev_absolute"]],
  ras_slope = temp_ras[["slope"]],
  
  plateau_min_size_sqm = 80^2,
  slope_threshold_deg = 5,
  ela_absolute = ela_calculated
)

plot(TESCHT$raster_Result)
freq(TESCHT$raster_Result)

# value count
#     0 17208 # glacier
#     1    10 # flat spots on glacier
#   100 47088 # plateau elevation band
#   101   882 # flat spot on plateau elevation band, but too small
#   111  3408 # plateau
#    NA 97868 # background

# ---- multiple apply plateau function ----

names(TESCHT$raster_Result) <- "plateaus"

test_RE_stack <- stack(temp_ras, TESCHT$raster_Result)
plot(test_RE_stack)








  for (i_slope in metric_slope_limit) {
    for (i_clump in metric_clump_size_limit) {
      
      assign(
        paste0("raster_", i_slope, "_", i_clump),
        get_plateaus(
          ras_elev_abs = temp_ras[["elev_absolute"]],
          ras_slope = temp_ras[["slope"]],
          slope_threshold_deg = i_slope,
          ras_elev_rel = temp_ras[["elev_relative"]],
          ela_relative = ela_assumed,
          plateau_min_size_sqm = i_clump
        )
      )
      
      plateau_geotable <- rbind(plateau_geotable, get_plateaus(
        ras_slope = temp_ras[["slope"]],
        slope_threshold_deg = i_slope,
        ras_elev_rel = temp_ras[["elev_relative"]],
        ela_relative = ela_assumed,
        plateau_min_size_sqm = i_clump
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
            legend.position = "bottom",
            legend.key.width = unit(1.5, "cm"),
            axis.text.y = element_text(angle = 45, hjust = 1),
            axis.title.x = element_blank(),
            axis.title.y = element_blank()
          ) +
          #geom_contour() + # integrate ELA indicator line here, later
          scale_fill_manual(
            values = c(
              rgb(.72, .92, .98), # glaciers
              rgb(.37, .47, .88), # below slope limit
              "#000000" # plateau detected
            )
          ))
  
  dev.off()
  

  # PLACEHOLDER: print plateau area into metrics
}