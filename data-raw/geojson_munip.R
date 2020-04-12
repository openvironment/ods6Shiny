## code to prepare `geojson_munip` dataset goes here

geojson_munip <- readr::read_rds(
  "~/Documents/curso-r/isdp-files/geo/geojson/geojson_munip.rds"
)

usethis::use_data(geojson_munip, overwrite = TRUE)
