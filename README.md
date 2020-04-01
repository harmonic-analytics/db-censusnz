
<!-- README.md is generated from README.Rmd. Please edit that file -->

# censusnz

<!-- badges: start -->

[![pipeline-status](https://gitlab.harmonic.co.nz/ari/censusnz/badges/master/pipeline.svg)](https://gitlab.harmonic.co.nz/ari/censusnz)
[![coverage-status](https://gitlab.harmonic.co.nz/ari/censusnz/badges/master/coverage.svg?job=coverage)](https://gitlab.harmonic.co.nz/ari/censusnz/pipelines)
<!-- badges: end -->

A way to access the 2018 NZ Census Data. This package includes datasets
of census responses grouped by different geographic areas. It also
contains spatial dataframes of some of the geographic boundary areas.

In future, functions to help access the data will also exist.

## Installation

To install this package from gitlab, you must first generate a Personal
Access Token; the package can then be installed using via the Remotes
package:

``` r
remotes::install_gitlab(repo = 'ari/censusnz', auth_token = <PAT>, host = 'gitlab.harmonic.co.nz/')
```
