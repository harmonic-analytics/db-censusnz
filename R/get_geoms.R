#' Get the SA1 geographic areas
#'
#' @param clipped If `FALSE`, the 2018 SA1 geographic areas are returned as
#'   defined. If `TRUE`, the geographic areas clipped to the NZ coastline are
#'   returned instead.
#'
#' @return The 2018 SA1 geographic areas
#' @export
get_sa1_geoms = function(clipped = FALSE) {
  get_geoms('sa1_geoms', clipped = clipped)
}

#' Get the SA2 geographic areas
#'
#' @param clipped If `FALSE`, the 2018 SA2 geographic areas are returned as
#'   defined. If `TRUE`, the geographic areas clipped to the NZ coastline are
#'   returned instead.
#'
#' @return The 2018 SA2 geographic areas
#' @export
get_sa2_geoms = function(clipped = FALSE) {
  get_geoms('sa2_geoms', clipped = clipped)
}

#' Get the Wards geographic areas
#'
#' @param clipped If `FALSE`, the 2018 Wards geographic areas are returned as
#'   defined. If `TRUE`, the geographic areas clipped to the NZ coastline are
#'   returned instead.
#'
#' @return The 2018 Wards geographic areas
#' @export
get_ward_geoms = function(clipped = FALSE) {
  get_geoms('ward_geoms', clipped = clipped)
}

#' Get the Territorial Authority geographic areas
#'
#' @param clipped If `FALSE`, the 2018 Territorial Authority geographic areas are returned as
#'   defined. If `TRUE`, the geographic areas clipped to the NZ coastline are
#'   returned instead.
#'
#' @return The 2018 Territorial Authority geographic areas
#' @export
get_ta_geoms = function(clipped = FALSE) {
  get_geoms('ta_geoms', clipped = clipped)
}

#' Get the Regional Council geographic areas
#'
#' @param clipped If `FALSE`, the 2018 Regional Council geographic areas are returned as
#'   defined. If `TRUE`, the geographic areas clipped to the NZ coastline are
#'   returned instead.
#'
#' @return The 2018 Regional Council geographic areas
#' @export
get_rc_geoms = function(clipped = FALSE) {
  get_geoms('rc_geoms', clipped = clipped)
}

get_geoms = function(df_name, clipped = FALSE) {
  areas = c('sa1_geoms', 'sa2_geoms', 'ward_geoms', 'ta_geoms', 'rc_geoms')
  assertthat::assert_that(df_name %in% areas, msg = 'Not a valid input')
  if (clipped) df_name = paste0(df_name, '_clipped')
  get(df_name)
}
