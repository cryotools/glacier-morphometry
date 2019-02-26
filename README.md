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

