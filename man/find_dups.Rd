% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find_dups.R
\name{find_dups}
\alias{find_dups}
\title{Find Duplicate Keys}
\usage{
find_dups(ds, keys)
}
\arguments{
\item{ds}{The source dataset}

\item{keys}{vector of keys in character format}
}
\description{
Finds rows that are duplicated based on the supplied keys.
Returns all duplicate rows in descending order based on num_dups. num_dups
is appended to the end of the dataset.
}
\details{
Finds rows that are duplicated based on the supplied keys
}
\keyword{dataset}
