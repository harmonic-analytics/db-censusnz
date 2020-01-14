# load packages
# library(sf)
# library(dplyr)

# import the sa1 data (sourced from https://datafinder.stats.govt.nz/layer/92206-statistical-area-1-higher-geographies-2018-generalised/)
sa1_geog_2018 <- st_read("./data-raw/sa1_2018.gpkg", stringsAsFactors = FALSE) %>%
  rename(SA1_2018 = SA12018_V1_00) %>%
  arrange(SA1_2018)

# Pull out only useful data and rename some variables for simpler use
area_hierarchy_2018 <- sa1_geog_2018 %>%
  rename(
    SA2_2018 = SA22018_V1_00,
    SA2_2018_NAME = SA22018_V1_00_NAME,
    UR_INDIC_2018_NAME = IUR2018_V1_00_NAME,
    TA_2018 = TA2018_V1_00,
    TA_2018_NAME = TA2018_V1_00_NAME,
    RC_2018 = REGC2018_V1_00,
    RC_2018_NAME = REGC2018_V1_00_NAME,
  ) %>%
  select(-c(UR2018_V1_00, UR2018_V1_00_NAME, IUR2018_V1_00, LANDWATER, Shape_Length, geom))

# Extract SA1 centroids
sa1_centroid_2018 <- sa1_geog_2018 %>%
  select(geom) %>%
  st_centroid() %>%
  st_coordinates()

# Rename centroid coordinates
dimnames(sa1_centroid_2018)[[2]] <- c("NZTM2000Easting", "NZTM2000Northing")

# Combine all useful geographic data
sa1_geog_temp <- area_hierarchy_2018 %>%
  bind_cols(as.data.frame(sa1_centroid_2018)) %>%
  st_drop_geometry()
