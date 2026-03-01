choose_archive <- function(
  plat = Sys.getenv("R_PLATFORM"),
  is_windows = WINDOWS
) {
  if (is_windows && startsWith(plat, "x86_64-")) {
    return("air-x86_64-pc-windows-msvc.zip")
  }

  if (is_windows && startsWith(plat, "aarch64-")) {
    return("air-aarch64-pc-windows-msvc.zip")
  }

  if (startsWith(plat, "x86_64-pc-linux-")) {
    return("air-x86_64-unknown-linux-gnu.tar.gz")
  }

  if (startsWith(plat, "aarch64-pc-linux-")) {
    return("air-aarch64-unknown-linux-gnu.tar.gz")
  }

  if (startsWith(plat, "aarch64-apple-")) {
    return("air-aarch64-apple-darwin.tar.gz")
  }

  if (startsWith(plat, "x86_64-apple-")) {
    return("air-x86_64-apple-darwin.tar.gz")
  }

  stop("Unknown R_PLATFORM ", plat)
}

fetch_binary <- function(archive_name, archive_url, digest) {
  is_tarball <- endsWith(archive_name, ".tar.gz")

  download.file(archive_url, destfile = archive_name)
  on.exit(file.remove(archive_name), add = TRUE)

  if (nchar(digest) == 0) {
    # No digest, nothing to do
  } else if (requireNamespace("digest", quietly = TRUE)) {
    digest <- strsplit(digest, ":")[[1]]
    stopifnot(length(digest) == 2)
    stopifnot(
      digest[[2]] ==
        digest::digest(archive_name, file = TRUE, algo = digest[[1]])
    )
  } else {
    warning("digest package not installed, not checking download digest")
  }

  if (is_tarball) {
    execs <- untar(archive_name, list = TRUE)
    stopifnot(untar(archive_name) == 0L)
  } else {
    execs <- unzip(archive_name, unzip = "internal")
  }

  # Only remaining item should be air executable
  execs <- execs[!dir.exists(execs)] # Filter directory names
  stopifnot(length(execs) == 1)
  stopifnot(basename(execs) %in% c("air", "air.exe"))
  return(execs)
}

archive <- choose_archive()
releases <- read.table("releases.txt", header = TRUE, row.names = "name")[
  archive,
]
if (nrow(releases) != 1) {
  stop("Release not found for ", archive)
}
execs <- fetch_binary(archive, releases[, 'url'], releases[, 'digest'])

dest <- file.path(R_PACKAGE_DIR, paste0('bin', R_ARCH))
dir.create(dest, recursive = TRUE, showWarnings = FALSE)
file.copy(execs, dest, overwrite = TRUE)
file.remove(execs)
