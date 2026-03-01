find_exec <- function() {
  normalizePath(file.path(
    find.package('raire'),
    'bin',
    .Platform$r_arch,
    if (.Platform$OS.type == 'windows') 'air.exe' else 'air'
  ))
}

air_format <- function(
  paths,
  log_level = c("warn", "error", "info", "debug", "trace"),
  no_color = FALSE
) {
  log_level <- match.arg(log_level)

  rv <- system2(
    find_exec(),
    c(
      "format",
      "--log-level",
      log_level,
      (if (isTRUE(no_color)) "--no-color" else NULL),
      paths
    )
  )
  if (rv != 0) {
    stop("air format returned ", rv)
  }
  return(invisible(NULL))
}

air_check <- function(
  paths,
  log_level = c("warn", "error", "info", "debug", "trace"),
  no_color = FALSE
) {
  log_level <- match.arg(log_level)

  rv <- system2(
    find_exec(),
    c(
      "format",
      "--check",
      "--log-level",
      log_level,
      (if (isTRUE(no_color)) "--no-color" else NULL),
      paths
    )
  )
  return(rv == 0)
}
