% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getBirths.R
\name{getBirths}
\alias{getBirths}
\title{Function to get Births file from DHS .dta files.}
\usage{
getBirths(filepath, surveyyear, variables = c("caseid", "v001", "v002",
  "v004", "v005", "v021", "v022", "v023", "v024", "v025", "v139", "bidx"),
  strata = c("v024", "v025"))
}
\arguments{
\item{filepath}{file path of raw .dta file from DHS}

\item{surveyyear}{year of survey}

\item{variables}{vector of variables to be used in obtaining the person-month files. The variables correspond the the DHS recode manual VI. For early DHS data, the variable names may need to be changed.}

\item{strata}{vector of variable names used for strata. If a single variable is specified, then that variable will be used as strata indicator If multiple variables are specified, the interaction of these variables will be used as strata indicator.}
}
\value{
A list of birth-month data
}
\description{
Function to get Births file from DHS .dta files.
}
\examples{
\dontrun{
my_fp <- "/myExampleFilepath/surveyData.DTA"
DemoData <- getBirths(filepath = my_fp, surveyyear = 2015) 
}

}
