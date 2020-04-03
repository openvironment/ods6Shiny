#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session ) {
  
  base_completa <- ods6Shiny::base_completa
  
  ggplot2::theme_set(ggplot2::theme_minimal())
  
  callModule(
    mod_informacoes_gerais_server, 
    "informacoes_gerais_ui_1"
  )
  
  callModule(
    mod_visao_cidade_server, 
    "visao_cidade_ui_1",
    base_completa
  )
}
