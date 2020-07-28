FROM rocker/tidyverse:3.6.3
ARG R_REPOS='https://cran.rstudio.com'

# Install {censusnz}
ARG GITLAB_PAT
RUN R echo 'GITLAB_PAT='${GITLAB_PAT} >> .Renviron
RUN R -q -e "stopifnot(nchar(Sys.getenv('GITLAB_PAT'))==20)"
RUN R -q -e "remotes::install_gitlab('harmonic/packages/censusnz', host = 'gitlab.harmonic.co.nz')"

# Install {db.censusnz} dependencies
WORKDIR /censusnz
COPY DESCRIPTION /censusnz/

RUN R -q -e "remotes::install_version('roxygen2', read.dcf('DESCRIPTION', 'RoxygenNote'), repos = ${R_REPOS})"
RUN R -q -e "desc::description\$new()\$del_remotes('census')\$del_dep('census')\$write()"
RUN R -q -e "remotes::install_deps(dependencies = TRUE, repos = ${R_REPOS})"

COPY . /censusnz/
