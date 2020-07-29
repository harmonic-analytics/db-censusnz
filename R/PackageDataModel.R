#' @title DataModel Plug-in for Accessing Census Data
#' @description This plug-in uses the \code{db.census} package on Harmonic
#'   Gitlab server.
#' @seealso \link[censusnz]{DataModel}
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
    relevant_hierarchies <- c(
        "LANDWATER_NAME",
        colnames(private$census_2018[[geography]] %>% dplyr::select(dplyr::ends_with("_CODE") | dplyr::ends_with("_NAME")))
    )

    invisible(
        land_type <- private$census_2018[["area_hierarchy"]]
        %>% dplyr::select(tidyselect::any_of(relevant_hierarchies))
        %>% dplyr::rename(land_type = LANDWATER_NAME)
        %>% dplyr::mutate_if(is.factor, as.character)
        %>% dplyr::distinct()
        %>% dplyr::arrange_at(relevant_hierarchies[-1])
        %>% dplyr::group_by_at(relevant_hierarchies[-1])
        %>% dplyr::summarise(land_type = land_type[1], n_landtype = dplyr::n())
        %>% dplyr::mutate(land_type = dplyr::if_else(n_landtype > 1, "Mixture", land_type))
        %>% dplyr::select(-n_landtype)
        %>% dplyr::ungroup()
    )

    suppressMessages((
        result <- private$census_2018[[geography]]
        %>% dplyr::filter(variable %in% variables)
        %>% dplyr::left_join(land_type)
        %>% dplyr::rename(geoid = dplyr::ends_with("_CODE"))
        %>% dplyr::rename(name = dplyr::ends_with("_NAME"))
        %>% dplyr::select(geoid, land_type, dplyr::everything())
    ))

    return(result)
}

PackageDataModel$funs$establish_connection <- function(self, private){
    # Defensive Programming
    assertthat::assert_that(nchar(Sys.getenv("GITLAB_PAT")) > 0, msg = PackageDataModel$msg$GITLAB_PAT)

    # Helpers -----------------------------------------------------------------
    suppressEverything <- function(expr) suppressWarnings(suppressMessages(expr))

    # Generate Data Model -----------------------------------------------------
    suppressEverything(private$census_2018 <- dplyr::src_df(pkg = 'db.censusnz')$env)

    private$census_2018$area_hierarchy <-
        private$census_2018$area_hierarchy %>%
        dplyr::mutate(HIERARCY_2018_CODE = as.character(seq_len(nrow(.))))

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
