% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ameriflux_get.R
\docType{data}
\name{tzLookup}
\alias{tzLookup}
\title{Time zone lookup table}
\format{data.frame:  539 obs. of  3 variables:
\describe{
 \item{TZ}{Time zone name}
 \item{UTC_offset}{UTC offset w/o daylight savings}
 \item{UTC_DST_offset}{UTC offset with daylight savings}
}}
\usage{
tzLookup
}
\description{
Lookup table to match time zones to UTC offsets.
}
\section{Citation}{

Originator: Paul Eggert/IANA \cr
Publication_Date: 20140325 \cr
Title: Time Zone Database \cr
List of time zones in the tz database release 2014b
Online_Linkage: \link[http://en.wikipedia.org/wiki/List_of_tz_database_time_zones]{
http://en.wikipedia.org/wiki/List_of_tz_database_time_zones} \cr
Online_Linkage: \link[http://www.iana.org/time-zones]{http://www.iana.org/time-zones} \cr
}
\seealso{
Other Ameriflux: \code{\link{ReadAmeriflux}},
  \code{\link{amfMeta}}
}
\concept{
data
}
\keyword{data}

