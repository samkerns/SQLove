<!-- README.md is generated from README.Rmd. Please edit that file -->

# SQLove <img src="https://github.com/user-attachments/assets/0cb7009e-af30-47c2-b4c5-b09b17b3f186" align="right" height="272"/>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/SQLove)](https://cran.r-project.org/package=dplyr)
[![R-CMD-check](https://github.com/samkerns/SQLove/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/tidyverse/dplyr/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

## Overview

`SQLove` is a package designed to support the ELT process in R. For many
R programmers, we may want to interface with a database (e.g. Redshift)
in order to do some basic data joining and manipulation in SQL, but to
perform more complex transformations and later analysis in R. This
package allows the user to deploy a complex, multi-statement SQL script
and load the results as a dataframe in R. Here are the two functions
included in the package:

-   `dbGetMultiQuery()` takes a file path to a complex SQL script ending
    in a `SELECT` statement and deploys that SQL script, importing the
    final table created by the final statement into a dataframe object
    in R.
-   `dbSendMultiStatement()` takes a file path to a complex SQL script
    that is intended to make modifications to the database tables, but
    which the user wishes to deploy in R. This function is most useful
    when multiple ETL/ELT processes are being managed within a single R
    workflow.

If you are new to SQLove, the best place to start is the [vignette
available through
CRAN](https://cran.r-project.org/web/packages/SQLove/vignettes/SQLove.html).

## Installation

The most up-to-date version of this package is available in GitHub, with
regular updates being made to CRAN no more frequently than on a monthly
basis. Therefore, if you're having any issues with bugs/functionality,
please try the GitHub version as well.

``` r
# The easiest way to get dplyr is to install SQLove from CRAN:
install.packages("SQLove")
```

### Development version

To get a bug fix or to use a feature from the development version, you
can install the development version of `SQLove` from GitHub.

``` r
# install.packages("pak")
pak::pak("samkerns/SQLove")
```

## 
