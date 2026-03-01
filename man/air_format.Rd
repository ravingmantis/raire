\name{air_format}
\alias{air_format}
\alias{air_check}
\title{Format R source code}

\description{
Use Air to format given R source code files
}

\usage{

air_format(
  paths,
  log_level = c("warn", "error", "info", "debug", "trace"),
  no_color = FALSE
)

air_check(
  paths,
  log_level = c("warn", "error", "info", "debug", "trace"),
  no_color = FALSE
)

}

\arguments{
\item{paths}{Character vector of path(s) to format / check}
\item{log_level}{Log level for air to use}
\item{no_color}{Boolean, if true disable colored output}
}

\details{
\code{air_format} will update all R source code files in \var{paths}, and error if not possible.
\code{air_check} will report if changes are required (i.e. the \code{--check} flag).
}

\value{
\subsection{air_format}{NULL}

\subsection{air_check}{TRUE iff all source code checks pass}
}

\examples{
\dontrun{
## Format everything in R
air_format("R")
}

\dontrun{
## Check everything in R without modifying, error if source changes required
stopifnot(air_check("R"))
}
}
