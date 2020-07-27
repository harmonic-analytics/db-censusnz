FROM rocker/tidyverse:3.6.3

RUN R -q -e "remotes::install_version('remotes', version = '2.1.1')"
RUN R -q -e "remotes::install_gitlab('harmonic/packages/censusnz', host = 'gitlab.harmonic.co.nz')"

WORKDIR /censusnz

COPY DESCRIPTION /censusnz/

#RUN R -e "desc::description\$new()\$del_remotes('census')\$del_dep('census')\$write()"
RUN R -e "remotes::install_deps(dependencies = TRUE)"

COPY . /censusnz/
