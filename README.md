# raire: Air formatter bundled into an unofficial R package

This is the [Air source code formatter](https://github.com/posit-dev/air) bundled into the R package,
along with a wrapper to use from R.

I'm nothing to do with Air itself, I've just stuffed the provided binaries into an R package.
It's a stop-gap measure until there's an official R package to use.

For progress on this front, see https://github.com/posit-dev/air/issues/48

## Prerequisites

Your system needs to have [git LFS](https://git-lfs.com/) installed & configured.

## Installation

The package can be installed with [remotes](https://cran.r-project.org/package=remotes):

```r
remotes::install_github("ravingmantis/raire")
```

raire versions are in-sync with air versions, if you need a particular version use the tagged release:

```r
remotes::install_github("ravingmantis/raire@v0.8.1")
```

## Usage

You can use Air with the ``air_format`` and ``air_check`` commands:

```r
## Format everything in R
raire::air_format("R")
```

```r
## Check everything in R without modifying, error if source changes required
stopifnot(air_check("R"))
```

## Installation debugging

If you are unlucky, you may see a message along the lines of:

```
Unknown R_PLATFORM x86_64-...
```

If so, then the mapping between ``R_PLATFORM`` and air release needs to be improved in [src/install.libs.R](src/install.libs.R).

The other (slim) possibility is your architecture isn't supported by the [official Air releases](https://github.com/posit-dev/air/releases).

## Updating

The [update.py](update.py) script generates new commits for each Air release.
Updating this package should be a case of re-running the script.

If there is sufficient interest, this could become an automatic Github action.
