#' @title DataModel Plug-in for Accessing Census Data
#' @description This plug-in uses the \code{db.census} package on Harmonic
#'   Gitlab server.
#' @export
PackageDataModel <- R6::R6Class(
    classname = "PackageDataModel",
    inherit = censusnz::DataModel,
    cloneable = FALSE,
    private = list(
        # Private Fields ----------------------------------------------------------
        census_2018 = NULL,
        geographies = c(),
        variables = c(),
        # Private Methods ---------------------------------------------------------
        .establish_connection = function(self, private) PackageDataModel$funs$establish_connection(self, private),
        .get_variables = function(self, private) PackageDataModel$funs$get_variables(self, private),
        .get_data = function(self, private, geography, variables, year) PackageDataModel$funs$get_data(self, private, geography, variables, year),
        .finalize = function(self, private) PackageDataModel$funs$finalize(self, private)
    )
)
PackageDataModel$funs <- new.env()

# Private Methods ----------------------------------------------------------
PackageDataModel$funs$get_variables <- function(self, private){
    data <- private$census_2018$available_variables
    return(data[complete.cases(data), ])
}

PackageDataModel$funs$get_data <- function(self, private, geography, variables, year){
    # Defensive Programming
    geography <- match.arg(toupper(geography), private$geographies)
    variables <- match.arg(tolower(variables), private$variables, several.ok = TRUE)

    # Setup
    result <- tibble::tribble(~geoid, ~name, ~variable, ~variable_group, ~count)

    # Filter Data
    invisible(
        result <- private$census_2018
        %>% dm::dm_filter(!!geography, variable %in% variables)
        %>% dm::dm_apply_filters_to_tbl(!!geography)
        %>% dplyr::rename(geoid = dplyr::ends_with("_CODE"))
        %>% dplyr::rename(name = dplyr::ends_with("_NAME"))
    )

    return(result)
}

PackageDataModel$funs$establish_connection <- function(self, private){
    # Defensive Programming
    assertthat::assert_that(nchar(Sys.getenv("GITLAB_PAT")) > 0, msg = PackageDataModel$msg$GITLAB_PAT)

    # Helpers -----------------------------------------------------------------
    dm <- purrr::partial(dm::dm, .name_repair = "universal")
    dm_add_pk <- purrr::partial(dm::dm_add_pk, check = FALSE, force = TRUE)
    dm_add_fk <- purrr::partial(dm::dm_add_fk, check = FALSE)

    # Generate Data Model -----------------------------------------------------
    private$census_2018 <-
        dplyr::src_df(pkg = 'db.censusnz') %>%
        dm::dm_from_src()
    private$census_2018 <-
        private$census_2018 %>%
        dm::dm_zoom_to(area_hierarchy) %>%
        dm::mutate(HIERARCY_2018_CODE = as.character(seq_len(nrow(.)))) %>%
        dm::dm_update_zoomed()
    private$census_2018 <-
        private$census_2018 %>%
        dm_add_pk(SA1, SA1_2018_CODE) %>%
        dm_add_pk(SA2, SA2_2018_CODE) %>%
        dm_add_pk(area_hierarchy, HIERARCY_2018_CODE) %>%
        dm_add_fk(SA1, SA1_2018_CODE, area_hierarchy) %>%
        dm_add_fk(SA2, SA2_2018_CODE, area_hierarchy)

    # Return ------------------------------------------------------------------
    private$geographies <- unique(db.censusnz::available_variables$geography)
    private$variables <- unique(db.censusnz::available_variables$variable)
    invisible(self)
}

PackageDataModel$funs$finalize <- function(self, private){
    private$census_2018 <- NULL
    invisible(self)
}

# Messages ----------------------------------------------------------------
PackageDataModel$msg <- new.env()
PackageDataModel$msg$GITLAB_PAT <- c(
    "There is no environment variable named GITLAB_PAT",
    "You can set it by calling Sys.setenv(GITLAB_PAT='xxxxxxxxxxxxxxxxxxx')"
)


