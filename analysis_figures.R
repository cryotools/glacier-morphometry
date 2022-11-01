
# ---- plot elevation and slope as raster ----

png(
  filename = paste0(
    plot_output_path,
    index$RGI_alias[i],
    "_01_overview_map.png"
  ),
  width = 1920,
  height = 1200,
  units = "px",
  res = 120
)

# elevation
ggras_elev_absolute <- temp_ras[["elev_absolute"]] %>% 
  as(., "SpatialPixelsDataFrame") %>% 
  as.data.frame()
colnames(ggras_elev_absolute) <- c("value", "x", "y")

ggp_elev <- ggplot() +
  geom_raster(data=ggras_elev_absolute, aes(x = x, y = y, fill = value)) +
  coord_fixed() +
  #theme_map() +
  theme_light()+
  #coord_map("albers", lat0 = 39, lat1 = 45) +
  geom_contour(
    data = ggras_elev_absolute,
    aes(x = x, y = y, z = value),
    breaks = ela_calculated,
    col = "black"
  ) +
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
  geom_raster(data = ggras_slope, aes(x = x, y = y, fill = value_class)) +
  coord_fixed() +
  #theme_map() +
  theme_light()+
  #coord_map("albers", lat0 = 39, lat1 = 45) +
  geom_contour(
    data = ggras_elev_absolute,
    aes(x = x, y = y, z = value),
    breaks = ela_calculated,
    col = "black"
  ) +
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
  scale_fill_manual(
    values = c(
      "[0,0.5]" = "dodgerblue4",
      "(0.5,1]" = "dodgerblue3",
      "(1,1.5]" = "dodgerblue",
      "(1.5,5]" = "deepskyblue",
      "(5,10]" = "khaki",
      "(10,20]" = "yellow",
      "(20,30]" = "orange",
      "(30,45]" = "red2", 
      "(45,60]" = "red3", 
      "(60,90]" = "red4"
    )
  ) +
  xlim(layer_scales(ggp_elev)$x$range$range) +
  ylim(layer_scales(ggp_elev)$y$range$range)

grid.arrange(ggp_elev, ggp_slope, ncol = 2)

dev.off()


# ---- plot hexbin slop ~ elevation ----

png(
  filename = paste0(
    plot_output_path,
    index$RGI_alias[i],
    "_02_elevation_slope_hexbin.png"
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
    (max(temp_ras_data$elev_absolute) - min(temp_ras_data$elev_absolute)) /
      nhexbins, # elevation (x) bins
    (91.8 - -1.8)/(nhexbins*3/4)  # slope (y) bins
  ),
  aes(
    #alpha = ..count.., 
    fill = ..count..)
  ) + 
  #geom_smooth() +
  theme_light() +
  coord_fixed(ratio = ((
    max(temp_ras_data$elev_absolute) - min(temp_ras_data$elev_absolute) 
  ) / 95 ) * 3/4 ) +
  scale_fill_gradient(low = "navy", high = "red") +
  geom_vline(xintercept = ela_calculated) +
  scale_y_continuous(
    breaks = c(0, 5, 10, 20, 30, 45, 60, 90), 
    limits = c(
      0 - 90*.02, 
      90 + 90*.02
    ),
    minor_breaks = NULL
  )) +
  xlim(
    min(temp_ras_data$elev_absolute) - 
      ((max(temp_ras_data$elev_absolute) - 
          min(temp_ras_data$elev_absolute)) * .02), 
    max(temp_ras_data$elev_absolute) + 
      ((max(temp_ras_data$elev_absolute) - 
          min(temp_ras_data$elev_absolute)) * .02)
  )


dev.off()



# ---- simple cumulative elevation plot, as in Zaho et al. ----

elev_absolute_hist <- hist(
  temp_ras_data$elev_absolute, 
  breaks = seq(0,1e4,50), 
  plot = F
)

elev_absolute_hist <- data.frame(
  elevation = elev_absolute_hist$mids[elev_absolute_hist$counts > 0],
  value = elev_absolute_hist$counts[elev_absolute_hist$counts > 0],
  visual = "histogram"
)

elev_absolute_curve <- temp_ras_data %>% 
  group_by(round(elev_absolute)) %>% 
  summarise(value = n()) %>% 
  select(elevation = "round(elev_absolute)", value) %>% 
  arrange(elevation) %>% 
  mutate(value = cumsum(value))
elev_absolute_curve$visual <- "curve"

profileplotdata <- rbind(
  elev_absolute_curve,
  elev_absolute_hist
)

profileplotdata$value <- profileplotdata$value * (prod(res(temp_ras)) / 1000^2)
profileplotdata$visual_factor <- factor(
  profileplotdata$visual, 
  levels = c("histogram", "curve"), 
  labels = c("Histogram (50 m steps)", "Cumulated curve (1 m steps)")
)

normal_line <- data.frame(
  x = min(profileplotdata$elevation[profileplotdata$visual == "curve"]),
  xend = max(profileplotdata$elevation[profileplotdata$visual == "curve"]),
  y = min(profileplotdata$value[profileplotdata$visual == "curve"]),
  yend = max(profileplotdata$value[profileplotdata$visual == "curve"]),
  visual = "curve"
) %>% 
  mutate(
    visual_factor = factor(
      visual, 
      levels = c("histogram", "curve"), 
      labels = c("Histogram (50 m steps)", "Cumulated curve (1 m steps)")
    )
  )

normal_hist_reference <- sum(
  profileplotdata[profileplotdata$visual == "histogram",]$value
) / (
  nrow(elev_absolute_hist)
)

png(
  filename = paste0(
    plot_output_path,
    index$RGI_alias[i],
    "_03_elevation_curve_hist.png"
  ),
  width = 1920,
  height = 1200,
  units = "px",
  res = 120
)
print(ggplot() +
        geom_bar(
          data = profileplotdata[profileplotdata$visual == "histogram",],
          aes(
            x = elevation,
            y = value
          ),
          stat = "identity",
          width = 50
        ) +
        geom_line(
          data = profileplotdata[profileplotdata$visual == "curve",],
          aes(
            x = elevation,
            y = value
          )
        ) +
        coord_flip() +
        facet_wrap(~ visual_factor, ncol = 2, scales = "free_x") +
        theme_minimal() +
        labs(
          x = "Elevation [m a.s.l.]",
          y = "Area [km²]"
        ) +
        geom_segment(
          data = normal_line,
          aes(
            x = x, y = y, xend = xend, yend = yend
          ),
          inherit.aes = F,
          linetype = "dashed"
        ) +
        geom_vline(xintercept = ela_calculated) +
        geom_hline(
          data = filter(profileplotdata, visual == "histogram"), 
          aes(yintercept = normal_hist_reference),
          linetype = "dashed"
        )
)
dev.off()