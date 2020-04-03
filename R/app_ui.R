#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboard
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    dashboardPage(
      dashboardHeader(
        title = "ODS6"
      ),
      dashboardSidebar(
        sidebarMenu(
          menuItem(
            "Informações gerais",
            tabName = "informacoes_gerais"
          ),
          menuItem(
            "Visão por cidade",
            tabName = "visao_cidade"
          )
        )
      ),
      dashboardBody(
        tabItems(
          tabItem(
            "informacoes_gerais",
            mod_informacoes_gerais_ui("informacoes_gerais_ui_1")
          ),
          tabItem(
            "visao_cidade",
            mod_visao_cidade_ui("visao_cidade_ui_1")
          )
        )
      )
    )
  )
    
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @import shinydashboard
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
  
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'templateGolem'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

