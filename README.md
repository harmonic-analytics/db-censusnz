
# **db.censusnz** (censusnz database plugin)

<!-- badges: start -->

[![pipeline-status](https://gitlab.harmonic.co.nz/harmonic/databases/db-censusnz/badges/master/pipeline.svg)](https://gitlab.harmonic.co.nz/harmonic/databases/db-censusnz/)
<!-- badges: end -->

This package contains datasets of responses to the 2006, 2013 and 2018 
NZ Censuses grouped by different geographic areas. This package is designed 
to be used as a data package for the **censusnz** package, which will provide
functions for accessing and interacting with the data.

## Installation

To install this package from gitlab, you must first generate a Personal
Access Token; the package can then be installed using via the Remotes
package (replacing `GITLAB_PAT` with your Personal Access Token):

``` r
remotes::install_gitlab(repo = 'harmonic/databases/db-censusnz', host = 'gitlab.harmonic.co.nz/', auth_token = GITLAB_PAT)
```

Alternatively the `utilic` package can be used:

``` r
utilic::install_harmonic('harmonic/databases/db-censusnz')
```

In future, this package will be installed automatically with the
**censusnz** package automatically.
