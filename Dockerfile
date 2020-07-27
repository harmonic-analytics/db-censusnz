FROM rocker/tidyverse:3.6.3

# Install {censusnz}
ARG GITLAB_PAT
RUN R echo 'GITLAB_PAT='${GITLAB_PAT} >> .Renviron
RUN R -q -e "assertthat::assert_that(nchar(Sys.getenv('GITLAB_PAT'))==20, msg = 'There is no environment variable named GITLAB_PAT')"
RUN R -q -e "remotes::install_gitlab('harmonic/packages/censusnz', host = 'gitlab.harmonic.co.nz')"

# Install {db.censusnz} dependencies
WORKDIR /censusnz
COPY DESCRIPTION /censusnz/

#RUN R -e "desc::description\$new()\$del_remotes('census')\$del_dep('census')\$write()"
RUN R -e "remotes::install_deps(dependencies = TRUE)"

COPY . /censusnz/
