% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/roll_down_on_null.R
\name{roll_down_on_null}
\alias{roll_down_on_null}
\title{Replaces every NA in some columns by the last non null string observed.}
\usage{
roll_down_on_null(d, ...)
}
\arguments{
\item{d}{a data frame.}

\item{...}{columns to be drilled down.}
}
\value{
d with different columns names.
}
\description{
Replaces every NA in some columns by the last non null string observed.
}
