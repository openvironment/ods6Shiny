filtrar_ano_mais_recente <- function(tab) {
  tab %>% 
    dplyr::filter(ano == max(ano))
}

show_data <- function() {
  base_indicadores %>% 
    dplyr::glimpse()
}

formatar_numero <- function(x, accuracy = 0.1) {
  scales::number(x, big.mark = ".", decimal.mark = ",", accuracy = accuracy)
}

#' Pipe
`%>%` <- dplyr::`%>%`