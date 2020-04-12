## code to prepare `base_indicadores` dataset goes here

tab_munip_cod <- readr::read_rds(
  "~/Documents/curso-r/isdp-files/bases/base_ibge.rds"
) %>% 
  dplyr::distinct(municipio_cod) %>% 
  dplyr::mutate(munip_cod = stringr::str_sub(municipio_cod, 1, 6))

base_indicadores <- readxl::read_excel("../ods6/data/base_indicadores.xlsx") %>% 
  dplyr::left_join(tab_munip_cod, by = "munip_cod") %>% 
  dplyr::mutate(munip_cod = municipio_cod) %>% 
  dplyr::select(
    munip_cod:num_domicilios_censo,
    num_dom_fossa_septica:prop_esgoto_tratado
  ) %>% 
  dplyr::mutate(
    consumo_medio_per_capita = as.numeric(consumo_medio_per_capita)
  )

usethis::use_data(base_indicadores, overwrite = TRUE)
