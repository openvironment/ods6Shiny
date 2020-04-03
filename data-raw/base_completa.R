## code to prepare `base_completa` dataset goes here

base_completa <- readxl::read_excel("../ods6/data/base_indicadores.xlsx") %>% 
  dplyr::select(
    munip_cod:num_domicilios_censo,
    sanea_fossa_septica:esgoto_tratado_porc
  )

usethis::use_data(base_completa, overwrite = TRUE)
