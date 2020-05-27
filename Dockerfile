FROM rocker/geospatial:3.6.3

COPY DESCRIPTION ./censusnz/.

RUN R -e "remotes::install_deps(dependencies = TRUE)"

COPY . ./censusnz/.
