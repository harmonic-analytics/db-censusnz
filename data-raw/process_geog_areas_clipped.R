### Script to process geographical area files - clipped versions

# Read in geopackages -----------------------------------------------------

dir = './data-raw/geog-areas-2018-clipped'

sa1_geoms_clipped = sf::st_read(file.path(dir, 'statistical-area-1-2018-clipped-generalised.gpkg'))
sa2_geoms_clipped = sf::st_read(file.path(dir, 'statistical-area-2-2018-clipped-generalised.gpkg'))
ward_geoms_clipped = sf::st_read(file.path(dir, 'ward-2018-clipped-generalised.gpkg'))
ta_geoms_clipped = sf::st_read(file.path(dir, 'territorial-authority-2018-clipped-generalised.gpkg'))
rc_geoms_clipped = sf::st_read(file.path(dir, 'regional-council-2018-clipped-generalised.gpkg'))

# Tidy and prepare geometry files -----------------------------------------

sa1_geoms_clipped = sa1_geoms_clipped %>%
  dplyr::select(SA1_2018_NAME = SA12018_V1_00, geom)
sa1_geoms_clipped$geom = sf::st_transform(sa1_geoms_clipped$geom, '+proj=longlat +datum=WGS84') # Change to lat/lon for map plotting

sa2_geoms_clipped = sa2_geoms_clipped %>%
  dplyr::select(SA2_2018_CODE = SA22018_V1_00, SA2_2018_NAME = SA22018_V1_00_NAME, geom)
sa2_geoms_clipped$geom = sf::st_transform(sa2_geoms_clipped$geom, '+proj=longlat +datum=WGS84')

ward_geoms_clipped = ward_geoms_clipped %>%
  dplyr::select(WARD_2018_CODE = WARD2018_V1_00, WARD_2018_NAME = WARD2018_V1_00_NAME, geom)
ward_geoms_clipped$geom = sf::st_transform(ward_geoms_clipped$geom, '+proj=longlat +datum=WGS84')

ta_geoms_clipped = ta_geoms_clipped %>%
  dplyr::select(TA_2018_CODE = TA2018_V1_00, TA_2018_NAME = TA2018_V1_00_NAME, geom)
ta_geoms_clipped$geom = sf::st_transform(ta_geoms_clipped$geom, '+proj=longlat +datum=WGS84')

rc_geoms_clipped = rc_geoms_clipped %>%
  dplyr::select(RC_2018_CODE = REGC2018_V1_00, RC_2018_NAME = REGC2018_V1_00_NAME, geom)
rc_geoms_clipped$geom = sf::st_transform(rc_geoms_clipped$geom, '+proj=longlat +datum=WGS84')
