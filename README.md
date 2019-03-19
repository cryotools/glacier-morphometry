# topoclif_R



## Installation


### Requirements

The scripts were written and tested in the following environment:
R version 3.4.4 (2018-03-15)
Platform: x86_64-redhat-linux-gnu (64-bit)
Running under: CentOS Linux 7 (Core)

Required R packages are: rgdal, raster, ggplot2, tidyr, dplyr, gridExtra and e1071, as well as their dependencies.



## Getting started


### Part 1: Preparations

Download and unpack ALOS tiles
Download and unpack RGI. Combine all relevant glacier SHPs into a single SHP for input.
List the glaciers of interest in input.csv.


### Part 2: Create glacier DEMs

Change definitions as wished in specifications.R.

Run `Rscript main.R`.


###  Part 3: Analyze glacier DEMs

Change settings in analysis_parameters.R as needed.

Run `Rscript analyze.R`.




## Outputs


### Metrics definitions


#### General metrics


##### `area_raster`

The area covered by the glacier raster, in square meters. Calculated using the raster; by number and dimension of cells dimensions.


##### `elevation_min`, `elevation_max`, `elevation_mean`

The minimal, maximal and arithmetic mean elevation of the glacier raster.


##### `elevation_range`

The range from the minimal to the maximal elevation of the glacier raster; maximal elevation minus minimal elevation.


##### `ela_calculated`

The Equilibrium Line Altitude (ELA), calculated using the glacier raster and the assumed relative elevation of the ELA, as set as Input in the `analysis_parameters.R` file.


##### `skewness`

The skewness of the glacier raster's elevation distribution, calculated using `b_1 = m_3 / s^3 = g_1 ((n-1)/n)^(3/2)` by `e1071::skewness`. All three approaches that the function provides have been tested and showed only minimally different results, mainly in the decimal places of the results.


#### Plateau detection derived metrics

##### 

#     0 17208 # glacier
#     1    10 # flat spots on glacier
#   100 47088 # plateau elevation band
#   101   882 # flat spot on plateau elevation band, but too small
#   111  3408 # plateau
#    NA 97868 # background-