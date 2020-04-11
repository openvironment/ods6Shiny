## code to prepare `base_indicadores` dataset goes here

base_indicadores <- readxl::read_excel("../ods6/data/base_indicadores.xlsx") %>% 
  dplyr::select(
    munip_cod:num_domicilios_censo,
    num_dom_fossa_septica:prop_esgoto_tratado
  ) %>% 
  dplyr::mutate(
    consumo_medio_per_capita = as.numeric(consumo_medio_per_capita)
  )

usethis::use_data(base_indicadores, overwrite = TRUE)
