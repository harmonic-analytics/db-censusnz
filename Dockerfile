FROM rocker/tidyverse:3.6.3

RUN R -q -e "remotes::install_gitlab('harmonic/packages/censusnz', host = 'gitlab.harmonic.co.nz')"

WORKDIR /censusnz

COPY DESCRIPTION /censusnz/

RUN R -e "remotes::install_deps(dependencies = TRUE)"

COPY . /censusnz/
