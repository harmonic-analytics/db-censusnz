
# **db.censusnz** (censusnz database plugin)

<!-- badges: start -->

[![pipeline-status](https://gitlab.harmonic.co.nz/harmonic/databases/db-censusnz/badges/master/pipeline.svg)](https://gitlab.harmonic.co.nz/harmonic/databases/db-censusnz/)
[![coverage-status](https://gitlab.harmonic.co.nz/harmonic/databases/db-censusnz/badges/master/coverage.svg?job=coverage)](https://gitlab.harmonic.co.nz/harmonic/databases/db-censusnz/pipelines)
<!-- badges: end -->

A way to access the 2018 NZ Census Data. This package includes datasets
of census responses grouped by different geographic areas.

In future, functions to help access the data will also exist.

## Installation

To install this package from gitlab, you must first generate a Personal
Access Token; the package can then be installed using via the Remotes
package:

``` r
remotes::install_gitlab(repo = 'harmonic/packages/censusnz', auth_token = <PAT>, host = 'gitlab.harmonic.co.nz/')
remotes::install_gitlab(repo = 'harmonic/databases/db-censusnz', auth_token = <PAT>, host = 'gitlab.harmonic.co.nz/')
```

Alternatively the `utilic` package can be used:

``` r
utilic::install_harmonic('harmonic/packages/censusnz')
utilic::install_harmonic('harmonic/databases/db-censusnz')
```

-----

# Basic Usage of `censusnz`

To get started working with **censusnz**, users should:

1.  Set their GitLab Personal Access Token key. A key can be obtained by
    following the instruction at
    <https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html>.

2.  Instantiate a `DataModel`.

<!-- end list -->

``` r
Sys.setenv(GITLAB_PAT = "xxxxxxxxxxxxxxxxxxxx")
Census <- PackageDataModel$new()
```

There are two major functions implemented in **censusnz**:

1.  `Census$get_variables()` returns a table with the available
    *geographies* and *variables* you can query; and
2.  `Census$get_data()` fetches a table with selected variables.

## Geography in **censusnz**

To get Census data, **censusnz** users supply an argument to the
required `geography` parameter:

  - **SA1**: Statistical Area 1
  - **SA2**: Statistical Area 2
  - **WARD**: Ward
  - **DHB**: District Health Board
  - **LBA**: Local Board Area (Auckland region only)
  - **TA**: Territorial Authority
  - **RC**: Regional Council

See more information about the geographies by calling
`?censusnz::DataModel`. For comprehensive information check [StatNZ
report](http://archive.stats.govt.nz/%7B~%7D/media/Statistics/surveys-and-methods/methods/class-stnd/geographic-hierarchy/statistical-standard-for-geographic-areas-2018.pdf),
pages 8-21.

## Searching for Variables

Getting variables from the Census requires knowing the variable name -
and there are hundreds of these variables across the different Census
files. To rapidly search for variables, use the *get\_variables()*
function. The function takes no arguments and outputs metadata of the
available geographies and variables.

``` r
head(Census$get_variables())
#> # A tibble: 6 x 5
#>   geography variable             category  subcategory concept                  
#>   <chr>     <chr>                <chr>     <chr>       <chr>                    
#> 1 DHB       usually_resident_po~ Individu~ 1           Census usually resident ~
#> 2 DHB       census_night_popula~ Individu~ 1           Census night population ~
#> 3 DHB       unit_record_data_so~ Individu~ 1           Unit record data source  
#> 4 DHB       sex                  Individu~ 1           Sex                      
#> 5 DHB       age_5_year_groups    Individu~ 1           Age in five-year groups,~
#> 6 DHB       median_age_curp      Individu~ 1           Age in broad groups
```

For ideal functionality, we recommend:

1)  Using the *View* function in RStudio to interactively browse for
    variables;
2)  Clicking on *filters*; and
3)  Typing a variable of interest.

<!-- end list -->

``` r
View(Census$get_variables())
```

<img src="https://i.imgur.com/KxvAalA.png" width="100%" style="display: block; margin: auto;" />

For comprehensive variable description check [StatNZ Census
user-guide](https://www.stats.govt.nz/assets/Uploads/Methods/2018-Census-data-user-guide/2018-census-data-user-guide.pdf),
pages 12-14.

## Working with Census

Querying the Census data requires you to set three parameres:

1.  [`geography`](#geography);
2.  [`variables`](#variables); and
3.  `year` (currently only 2018 is available).

Once you’ve figure out what you need, you can query the Census data with
get\_data(). The result is a long table with five columns:

1.  `geoid`;
2.  `name`;
3.  `variable`;
4.  `variable_group`; and
5.  `count`.

In the following example we query two variables, *maori\_descent* and
*smoking\_status*, from a regional council geography level.

``` r
query <- Census$get_data(
  geography = "RC", 
  variables = c("maori_descent", "smoking_status")
)

head(query, 10)
#> # A tibble: 10 x 5
#>    geoid name          variable     variable_group                         count
#>    <chr> <chr>         <chr>        <chr>                                  <dbl>
#>  1 01    Northland Re~ maori_desce~ 01_maori_descent_curp                  69225
#>  2 01    Northland Re~ maori_desce~ 02_no_maori_descent_curp              104586
#>  3 01    Northland Re~ maori_desce~ 04_dont_know_curp                       5268
#>  4 01    Northland Re~ maori_desce~ total_stated_curp                     179076
#>  5 01    Northland Re~ maori_desce~ 99_not_elsewhere_included_curp             0
#>  6 01    Northland Re~ maori_desce~ total_curp                            179076
#>  7 01    Northland Re~ smoking_sta~ 01_regular_smoker_curp_15years_and_o~  25800
#>  8 01    Northland Re~ smoking_sta~ 02_ex_smoker_curp_15years_and_over     39639
#>  9 01    Northland Re~ smoking_sta~ 03_never_smoked_regularly_curp_15yea~  76011
#> 10 01    Northland Re~ smoking_sta~ total_stated_curp_15years_and_over    141453
```

Not all geographies are available for all surveys, all years, and all
variables. Most Census geographies are supported in **censusnz** at the
moment; if you require a geography that is missing from the table below,
please file an issue at NA

## Visualising Census Data

The Census contains totals and their components. The totals are a
convenient way to:

  - Transform absolute numbers into percentage; and
  - Use an aggregate level of *variable\_group*.

In this example we plot the total number of smokers in each region
within NZ. Our definition of a smoker is anyone who smokes, regularly or
occasionally, or used to smoke. This means:

  - We need the total number of smokers, regardless of their current
    smoking habit; and
  - We need the number of smokers per region, rather than the total of
    all regions.

For the first point, we need to filter, i.e. include, the totals. We do
that by using `filter_at("variable_group", ~ grepl("^total_stated_",
.))`.

For the second point, we need to filter out, i.e. discard, the total
smokers in all regions combined. We do that by using `filter_at("name",
~ !grepl("^Total NZ", .))`.

``` r
(
    ggdata <- query 
    %>% dplyr::filter(variable %in% "smoking_status")
    %>% dplyr::filter_at("name", ~ !grepl("^Total NZ", .))
    %>% dplyr::filter_at("variable_group", ~ grepl("^total_stated_", .))  
)
#> # A tibble: 17 x 5
#>    geoid name                 variable      variable_group                 count
#>    <chr> <chr>                <chr>         <chr>                          <dbl>
#>  1 01    Northland Region     smoking_stat~ total_stated_curp_15years_an~ 1.41e5
#>  2 02    Auckland Region      smoking_stat~ total_stated_curp_15years_an~ 1.26e6
#>  3 03    Waikato Region       smoking_stat~ total_stated_curp_15years_an~ 3.61e5
#>  4 04    Bay of Plenty Region smoking_stat~ total_stated_curp_15years_an~ 2.44e5
#>  5 05    Gisborne Region      smoking_stat~ total_stated_curp_15years_an~ 3.62e4
#>  6 06    Hawke's Bay Region   smoking_stat~ total_stated_curp_15years_an~ 1.31e5
#>  7 07    Taranaki Region      smoking_stat~ total_stated_curp_15years_an~ 9.29e4
#>  8 08    Manawatu-Wanganui R~ smoking_stat~ total_stated_curp_15years_an~ 1.91e5
#>  9 09    Wellington Region    smoking_stat~ total_stated_curp_15years_an~ 4.13e5
#> 10 12    West Coast Region    smoking_stat~ total_stated_curp_15years_an~ 2.60e4
#> 11 13    Canterbury Region    smoking_stat~ total_stated_curp_15years_an~ 4.91e5
#> 12 14    Otago Region         smoking_stat~ total_stated_curp_15years_an~ 1.88e5
#> 13 15    Southland Region     smoking_stat~ total_stated_curp_15years_an~ 7.80e4
#> 14 16    Tasman Region        smoking_stat~ total_stated_curp_15years_an~ 4.29e4
#> 15 17    Nelson Region        smoking_stat~ total_stated_curp_15years_an~ 4.19e4
#> 16 18    Marlborough Region   smoking_stat~ total_stated_curp_15years_an~ 3.91e4
#> 17 99    Area Outside Region  smoking_stat~ total_stated_curp_15years_an~ 5.55e2
```

Plotting the filtered data we get

``` r
library(ggplot2)
(
    ggdata %>% ggplot(aes(x=name, y=count)) 
    + geom_col()
    + xlab("region")
    + coord_flip()
    + theme_bw()
)
```

<img src="man/figures/README-visualisation-plot-1.png" width="100%" style="display: block; margin: auto;" />

<!-- # References -->
