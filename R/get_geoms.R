#' Get the SA1 geographic areas
#'
#' @param clipped If `FALSE`, the 2018 SA1 geographic areas are returned as
#'   defined. If `TRUE`, the geographic areas clipped to the NZ coastline are
#'   returned instead.
#'
#' @return The 2018 SA1 geographic areas
#' @export
get_sa1_geoms = function(clipped = FALSE) {
  if (clipped) {
    return (sa1_geoms_clipped)
  } else {
    return (sa1_geoms)
  }
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
  if (clipped) {
    return (sa2_geoms_clipped)
  } else {
    return (sa2_geoms)
  }
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
  if (clipped) {
    return (ward_geoms_clipped)
  } else {
    return (ward_geoms)
  }
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
  if (clipped) {
    return (ta_geoms_clipped)
  } else {
    return (ta_geoms)
  }
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
  if (clipped) {
    return (rc_geoms_clipped)
  } else {
    return (rc_geoms)
  }
}
