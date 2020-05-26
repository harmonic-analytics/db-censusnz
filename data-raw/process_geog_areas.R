### Script to process geographical area files

# Read in geopackages -----------------------------------------------------

dir = './data-raw/geog-areas-2018'

sa1_geoms = sf::st_read(file.path(dir, 'statistical-area-1-higher-geographies-2018-generalised.gpkg'))
sa2_geoms = sf::st_read(file.path(dir, 'statistical-area-2-2018-generalised.gpkg'))
ward_geoms = sf::st_read(file.path(dir, 'ward-2018-generalised.gpkg'))
ta_geoms = sf::st_read(file.path(dir, 'territorial-authority-2018-generalised.gpkg'))
rc_geoms = sf::st_read(file.path(dir, 'regional-council-2018-generalised.gpkg'))


# Extract Area Hierarchy --------------------------------------------------

area_hierarchy <- sa1_geoms  %>%
  dplyr::select(
    SA1_2018_NAME = SA12018_V1_00,
    SA2_2018_CODE = SA22018_V1_00,
    SA2_2018_NAME = SA22018_V1_00_NAME,
    TA_2018_CODE = TA2018_V1_00,
    TA_2018_NAME = TA2018_V1_00_NAME,
    RC_2018_CODE = REGC2018_V1_00,
    RC_2018_NAME = REGC2018_V1_00_NAME,
    LANDWATER_NAME
  ) %>%
  sf::st_drop_geometry()


# Tidy and prepare geometry files -----------------------------------------

sa1_geoms = sa1_geoms %>%
  dplyr::select(SA1_2018_NAME = SA12018_V1_00, geom)
sa1_geoms$geom = sf::st_transform(sa1_geoms$geom, '+proj=longlat +datum=WGS84') # Change to lat/lon for map plotting

sa2_geoms = sa2_geoms %>%
  dplyr::select(SA2_2018_CODE = SA22018_V1_00, SA2_2018_NAME = SA22018_V1_NAME, geom)
sa2_geoms$geom = sf::st_transform(sa2_geoms$geom, '+proj=longlat +datum=WGS84')

ward_geoms = ward_geoms %>%
  dplyr::select(WARD_2018_CODE = WARD2018_V1_00, WARD_2018_NAME = WARD2018_V1_00_NAME, geom)
ward_geoms$geom = sf::st_transform(ward_geoms$geom, '+proj=longlat +datum=WGS84')

ta_geoms = ta_geoms %>%
  dplyr::select(TA_2018_CODE = TA2018_V1_00, TA_2018_NAME = TA2018_V1_00_NAME, geom)
ta_geoms$geom = sf::st_transform(ta_geoms$geom, '+proj=longlat +datum=WGS84')

rc_geoms = rc_geoms %>%
  dplyr::select(RC_2018_CODE = REGC2018_V1_00, RC_2018_NAME = REGC2018_V1_00_NAME, geom)
rc_geoms$geom = sf::st_transform(rc_geoms$geom, '+proj=longlat +datum=WGS84')
