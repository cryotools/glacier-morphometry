# Glacier morphometry
A set of R scripts to facilitate geomorphometric analyses of glaciers.


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


### Plateau detection

#### Classified result raster

    value   meaning
    _____   __________________________________________________
        0   glacier
        1   flat spots on glacier
      100   plateau elevation band
      101   flat spot on plateau elevation band, but too small
      111   plateau (flat spot, big enough)
       NA   background


#### Plateau elevation raster


#### Metrics

Two metrics, the min and max elevation of plateaus are directly derived within the detection function and are added to the output. The definition and all externally derived outputs can be foud in the Metrics definition section.


### Metrics definitions


#### General metrics


##### `area_absolute_glacier`

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

##### `pleateau_elevation_min`, `plateau_elevation_max`, `plateau_elevation_range`

The lowest and highest elevation, and the range in between, of the detected plateaus. Derived within the plateau detection function itself, saved in the processing loop.

##### `plateau_elevation_mean`, `plateau_elevation_sd`, `plateau_elevation_skewness`

The arithmetic mean, the standard deviation and the skewness of the plateau elevations. Derived in the processing loop, after the plateau detection execution, from the result. The skewness is calculated in the same way as for the entire glacier, as described in previous sections.

##### `area_absolute_*`

The absolute area in square meters. If a cell fits into different categories, it is counted in all of them.

`area_absolute_glacier` is not derived in the plateau detection itself, but before in the main metrics script. It is described in the previous section.

`area_absolute_flat` is the sum of all flat areas on the glacier (with no minimum area), that do not exceed the threshold

# Acknoledgements
These scripts were developed within the research project "TopoClimatic Forcing and non-linear dynamics in the climate change adaption of glaciers in High Asia" (TopoClif). TopoCliF and the work of David Loibl and Arne Thiemann within the project were funded by [DFG](https://gepris.dfg.de/gepris/projekt/356944332) under the ID LO 2285/1-1.

