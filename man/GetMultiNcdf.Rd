% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ncdf_get_multi.R
\name{GetMultiNcdf}
\alias{GetMultiNcdf}
\title{Get WRF Hydro output/restart (scalar) timeseries spread over multiple files.}
\usage{
GetMultiNcdf(filesList, variableList, indexList, env = parent.frame(),
  parallel = FALSE)
}
\arguments{
\item{filesList}{The list of file groups. Names must match those in the other
lists.}

\item{variableList}{The list of variables for each file group. Names must
match filesList.}

\item{indexList}{The list of indices or statistics to be applied to each
variable.}

\item{env}{The environment where the stat function lives}

\item{parallel}{Logical, this is the .parallel argument of plyr functions. 
Parallelization is at the file level (not file group).Typcially we achieve 
parallelization using the DoMC package. See examples.}
}
\value{
A dataframe (in an awesome format).
}
\description{
\code{GetMultiNcdf} is designed to get *all* your output/restart data which 
are spread over multiple files. Three collated lists specify 1) file groups,
2) variables for each file group, and 3) indices or statistics for each
variable in each file group. The names of the lists must match. See examples
for details. While the routine can read and summarize raster data at each
time via specificied statistics, it only returns scalar timeseries. (It may
be possible to extend to return both scalar and raster data if there's 
demand.)
}
\examples{
# This example only shows data for 3 dates, because of limitation of package data.
# Find the package data directory on your machine
\dontrun{
tcPath <- '~/wrfHydroTestCases/'
fcPath <- paste0(tcPath,'Fourmile_Creek/')
dataPath <- paste0(fcPath,'/RUN.RTTESTS/OUTPUT_CHRT_DAILY/')
fileList - These are the groups of files.
lsmFiles <- list.files(path=dataPath, pattern='LDASOUT_DOMAIN', full.names=TRUE)
hydroFiles <- list.files(path=dataPath, pattern='HYDRO_RST', full.names=TRUE)
fileList <- list( lsm=lsmFiles, hydro=hydroFiles)

# varList - Define which variables are desired for each file group.
lsmVars   <- list(TRAD='TRAD', SWE='SNEQV')
## smc1-4 will correspond to the vertical layers.
hydroVars <- list(streamflow='qlink1', smc1='sh2ox', smc2='sh2ox', 
                  smc3='sh2ox', smc4='sh2ox')
# Note that the outer names collate with fileList.
variableList <- list(lsm=lsmVars, hydro=hydroVars)

# indexList - Define what indices/stats are desired for each variable.
# Note that only scalars can be returned for each entry. Spatial fields can 
# be summarized via statistics. 
# Show how to define your own useful stats to use.
# For basin average and max we need the basin mask (this is a non-standard
# field in the fine grid file).
basinMask <- ncdump(paste0(fcPath,'DOMAIN/hydro_OrodellBasin_100m.nc'), 
                    'basn_msk_geogrid')
nc_close(fineGridNc)
basAvg <- function(var) sum(basinMask*var)/sum(basinMask)
basMax <- function(var) max(ceiling(basinMask)*var)
basinKm2 <- sum(basinMask)  ## just asking about the total area of the basin.

# Note that the list names at this level collate with the variable names
# in VarList. You are responsible for entering the correct indices. Note
# that these are reverse order from what is shown in "ncdump -h".
lsmInds   <- list(TRAD=list(start=c(1,1,1), end=c(21,7,1), stat='basAvg'),
                  SNEQV=list(start=c(1,1,1), end=c(21,7,1), stat='basMax'))
hydroInds <- list(qlink1=1,
                  smc1=list(start=c(1,1,1), end=c(21,7,1), stat='basAvg'),
                  smc2=list(start=c(1,1,2), end=c(21,7,2), stat='basAvg'),
                  smc3=list(start=c(1,1,3), end=c(21,7,3), stat='basAvg'),
                  smc4=list(start=c(1,1,4), end=c(21,7,4), stat='basAvg') )
indexList <- list( lsm=lsmInds, hydro=hydroInds)

library(doMC)   ## Showing parallelization, which is at the file level within
registerDoMC(3) ## each file grous; pointless to be longer than your timeseries.
fileData <- GetMultiNcdf(file=fileList,var=variableList, ind=indexList,
                         parallel=TRUE)

# plot
# the lsm and hyro output for this spinup were at different times... 
library(ggplot2)
library(scales)
ggplot( fileData, aes(x=POSIXct, y=value, color=fileGroup)) +
  geom_line() + geom_point() +
  facet_wrap(~variableGroup, scales='free_y', ncol=1) +
  scale_x_datetime(breaks = date_breaks("5 days")) + theme_bw()
}
}

