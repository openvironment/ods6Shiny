#' visao_cidade UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_visao_cidade_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      box(
        width = 3,
        uiOutput(ns("ui_select_indicador")),
        uiOutput(ns("ui_select_cidade"))
      ),
      box(
        width = 9,
        plotOutput(ns("plot_serie"))
      )
    )
  )
}
    
#' visao_cidade Server Function
#'
#' @noRd 
mod_visao_cidade_server <- function(input, output, session, base_completa) {
  
  ns <- session$ns
  
  output$ui_select_indicador <- renderUI({
    
    opcoes <- base_completa %>% 
      dplyr::select(sanea_fossa_septica:esgoto_tratado_porc) %>% 
      names()
    
    selectInput(
      inputId = ns("select_indicador"),
      label = "Selecione um indicador",
      choices = opcoes
    )
  })
  
  output$ui_select_cidade <- renderUI({
    
    opcoes <- base_completa %>% 
      dplyr::pull(munip_nome) %>% 
      unique() %>% 
      sort()
    
    selectInput(
      inputId = ns("select_cidade"),
      label = "Selecione uma cidade",
      choices = opcoes
    )
      
  })
  
  dados_filtrados <- reactive({
    
    req(input$select_cidade, input$select_indicador)
    
    tab <- base_completa %>% 
      dplyr::filter(
        munip_nome == input$select_cidade
      ) %>% 
      dplyr::rename(var = input$select_indicador)
    
    # nome_formatado <- tab_depara %>% 
    #   dplyr::filter(
    #     cod == input$select_indicador
    #   ) %>% 
    #   dplyr::pull(nome_formatado)
    
    list(
      tab = tab
      # nome_formatado = nome_formatado
    )
    
  })
  
  output$plot_serie <- renderPlot({
    
    dados_filtrados()$tab %>% 
      ggplot2::ggplot(ggplot2::aes(x = ano, y = var)) +
      ggplot2::geom_line()
      # ggplot2::labs(y = dados_filtrados()$nome_formatado)
    
  })
  
}
