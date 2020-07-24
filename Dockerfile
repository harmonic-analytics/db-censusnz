FROM rocker/tidyverse:3.6.3

WORKDIR /censusnz

COPY DESCRIPTION /censusnz/

RUN R -e "remotes::install_deps(dependencies = TRUE)"

COPY . /censusnz/
