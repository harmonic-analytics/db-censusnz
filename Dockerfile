FROM rocker/geospatial:3.6.3

COPY DESCRIPTION ./censusnz/.

RUN r "remotes::install_deps(dependencies = TRUE)"

COPY . ./censusnz/.
