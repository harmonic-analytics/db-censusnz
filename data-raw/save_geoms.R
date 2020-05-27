# Process all the data

# Process geog areas

source('./data-raw/process_geog_areas.R')

# Process clipped geog areas

source('./data-raw/process_geog_areas_clipped.R')

# Export data

# Area hierachy for external use
usethis::use_data(area_hierarchy, overwrite = TRUE)

# Geographies for reference to internal function
usethis::use_data(
  sa1_geoms,
  sa2_geoms,
  ward_geoms,
  ta_geoms,
  rc_geoms,
  sa1_geoms_clipped,
  sa2_geoms_clipped,
  ward_geoms_clipped,
  ta_geoms_clipped,
  rc_geoms_clipped,
  overwrite = TRUE
)
