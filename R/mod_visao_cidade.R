#' visao_cidade UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_visao_cidade_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      box(
        width = 3,
        uiOutput(ns("ui_select_cidade"))
      ),
      col_3(
        valueBoxOutput(ns("vb_populacao"), width = 12)
      ),
      col_3(
        valueBoxOutput(ns("vb_num_domicilios"), width = 12)
      ),
      col_3(
        valueBoxOutput(ns("vb_taxa_pop_domicilios"), width = 12)
      ),
      separador_secao(),
      box(
        width = 4,
        title = "Resumo",
        reactable::reactableOutput(ns("tab_resumo"))
      ),
      box(
        width = 4,
        title = "Alertas",
        reactable::reactableOutput(ns("tab_alertas"))
      ),
      box(
        width = 4,
        highcharter::highchartOutput(ns("plot_mapa"))
      ),
      separador_secao(),
      box(
        width = 3,
        uiOutput(ns("ui_select_indicador"))
      )
    )
  )
}
    
#' visao_cidade Server Function
#'
#' @noRd 
mod_visao_cidade_server <- function(input, output, session, base_indicadores) {
  
  ns <- session$ns
  
  output$ui_select_cidade <- renderUI({
    
    opcoes <- base_indicadores %>%
      dplyr::pull(munip_nome) %>%
      unique() %>%
      sort()
    
    selectInput(
      inputId = ns("select_cidade"),
      label = "Selecione uma cidade",
      selected = "São Paulo",
      choices = opcoes
    )
    
  })
  
  base_filtrada <- reactive({
    req(input$select_cidade)
    base_indicadores %>% 
      dplyr::filter(munip_nome == input$select_cidade)
  })
  
  output$vb_populacao <- renderValueBox({
    base_filtrada() %>% 
      filtrar_ano_mais_recente() %>% 
      dplyr::pull(populacao) %>% 
      formatar_numero(accuracy = 1) %>% 
      valueBox(
        subtitle = "População estimada",
        icon = icon("user-friends"),
        color = "aqua"
      )
  })
  
  output$vb_num_domicilios <- renderValueBox({
    base_filtrada() %>% 
      filtrar_ano_mais_recente() %>% 
      dplyr::pull(num_domicilios) %>%
      formatar_numero(accuracy = 1) %>% 
      valueBox(
        subtitle = "Número estimado de domicílios",
        icon = icon("home"),
        color = "aqua"
      )
  })
  
  output$vb_taxa_pop_domicilios <- renderValueBox({
    base_filtrada() %>% 
      filtrar_ano_mais_recente() %>% 
      dplyr::pull(taxa_hab_domicilio) %>%
      formatar_numero() %>% 
      valueBox(
        subtitle = "Habitantes por domicílio",
        icon = icon("house-user"),
        color = "aqua"
      )
  })
  
  output$tab_resumo <- reactable::renderReactable({
    base_filtrada() %>% 
      filtrar_ano_mais_recente() %>% 
      dplyr::select(
        prop_pop_servida_rede_publica_agua,
        prop_pop_servida_poco_nasc,
        prop_pop_abast_sist_adequados,
        prop_pop_servida_rede_coleta,
        prop_pop_fossa_septica,
        prop_pop_servida_coleta_esgoto,
        prop_esgoto_tratado,
        consumo_medio_per_capita,
        perc_perdas_rede_dist
      ) %>% 
      dplyr::mutate_at(
        dplyr::vars(-consumo_medio_per_capita),
        ~scales::percent(.x, accuracy = 0.1, scale = 1)
      ) %>%
      dplyr::mutate(
        consumo_medio_per_capita = paste(
          round(consumo_medio_per_capita),
          "litros/habitante/dia"
        )
      ) %>% 
      tidyr::gather(var, val) %>%
      reactable::reactable(
        columns = list(
          var = reactable::colDef(
            name = "Indicador",
            align = "left"
          ),
          val = reactable::colDef(
            name = "",
            align = "right"
          )
        ),
        striped = TRUE,
        highlight = TRUE
      )
  })
  
  output$tab_alertas <- reactable::renderReactable({
    base_filtrada() %>% 
      filtrar_ano_mais_recente() %>% 
      dplyr::select(dplyr::starts_with("prop"), perc_perdas_rede_dist) %>% 
      tidyr::gather(var, val) %>%
      dplyr::filter(val > 100) %>% 
      dplyr::arrange(dplyr::desc(val)) %>% 
      dplyr::mutate(
        val = scales::percent(val, accuracy = 0.1, scale = 1)
      ) %>%
      reactable::reactable(
        columns = list(
          var = reactable::colDef(
            name = "Indicador",
            align = "left"
          ),
          val = reactable::colDef(
            name = "",
            align = "right"
          )
        ),
        striped = TRUE,
        highlight = TRUE
      )
  })
  
  output$ui_select_indicador <- renderUI({

    opcoes <- base_indicadores %>%
      dplyr::select(pop_servida_abast_agua:prop_esgoto_tratado) %>%
      names()

    selectInput(
      inputId = ns("select_indicador"),
      label = "Selecione um indicador",
      choices = opcoes
    )
  })
  
  # dados_filtrados <- reactive({
  #   
  #   req(input$select_cidade, input$select_indicador)
  #   
  #   tab <- base_indicadores %>% 
  #     dplyr::filter(
  #       munip_nome == input$select_cidade
  #     ) %>% 
  #     dplyr::rename(var = input$select_indicador)
  #   
  #   # nome_formatado <- tab_depara %>% 
  #   #   dplyr::filter(
  #   #     cod == input$select_indicador
  #   #   ) %>% 
  #   #   dplyr::pull(nome_formatado)
  #   
  #   list(
  #     tab = tab
  #     # nome_formatado = nome_formatado
  #   )
  #   
  # })
  # 
  # output$plot_serie <- renderPlot({
  #   
  #   dados_filtrados()$tab %>% 
  #     ggplot2::ggplot(ggplot2::aes(x = ano, y = var)) +
  #     ggplot2::geom_line()
  #     # ggplot2::labs(y = dados_filtrados()$nome_formatado)
  #   
  # })
  
}
